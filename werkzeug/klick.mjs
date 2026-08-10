#!/usr/bin/env node
// klick.mjs <url> <breite> <praefix> [schritte...]
//
// Fährt eine Seite über das DevTools-Protokoll ab und schiesst nach jedem
// Schritt ein Bild. Ein Schritt ist entweder
//   klick:<css>     ein Element anklicken (nach Sichtbarmachen)
//   js:<ausdruck>   beliebiger Ausdruck im Seitenkontext
//   warte:<ms>      pausieren
//   schuss:<name>   Bild schiessen
// Am Ende meldet es Überlauf, Seitenhöhe und gesammelte Konsolenfehler.
import { spawn } from 'node:child_process';
import { mkdtempSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';

const [url, breiteRaw, praefix, ...schritte] = process.argv.slice(2);
const breite = +breiteRaw, hoehe = breite < 700 ? 844 : 900;
const port = 9300 + (process.pid % 600);
const profil = mkdtempSync(join(tmpdir(), 'klick-'));
const chrome = spawn('chromium', [
  '--headless=new', '--disable-gpu', '--no-sandbox', '--hide-scrollbars',
  '--no-first-run', '--force-device-scale-factor=1',
  `--user-data-dir=${profil}`, `--remote-debugging-port=${port}`,
  `--window-size=${breite},${hoehe}`, 'about:blank',
], { stdio: ['ignore', 'ignore', 'ignore'] });

const schlaf = ms => new Promise(r => setTimeout(r, ms));
let wsu;
for (let i = 0; i < 80; i++) {
  try {
    const l = await (await fetch(`http://127.0.0.1:${port}/json/list`)).json();
    const p = l.find(x => x.type === 'page');
    if (p) { wsu = p.webSocketDebuggerUrl; break; }
  } catch {}
  await schlaf(200);
}
const ws = new WebSocket(wsu);
await new Promise((ok, weg) => { ws.onopen = ok; ws.onerror = weg; });

let id = 0; const offen = new Map(); const fehler = [];
ws.onmessage = e => {
  const m = JSON.parse(e.data);
  if (m.method === 'Runtime.consoleAPICalled' && m.params.type === 'error')
    fehler.push(m.params.args.map(a => a.value ?? a.description ?? '?').join(' '));
  if (m.method === 'Runtime.exceptionThrown')
    fehler.push('EXCEPTION ' + (m.params.exceptionDetails.exception?.description
      || m.params.exceptionDetails.text));
  if (m.id && offen.has(m.id)) { offen.get(m.id)(m); offen.delete(m.id); }
};
const ruf = (method, params = {}) => new Promise(ok => {
  const n = ++id; offen.set(n, m => ok(m.result ?? m.error));
  ws.send(JSON.stringify({ id: n, method, params }));
});
const js = async e => (await ruf('Runtime.evaluate',
  { expression: e, returnByValue: true, awaitPromise: true })).result?.value;

await ruf('Runtime.enable'); await ruf('Page.enable');
await ruf('Emulation.setDeviceMetricsOverride',
  { width: breite, height: hoehe, deviceScaleFactor: 1, mobile: breite < 700 });
await ruf('Page.navigate', { url });
await schlaf(2800);

let n = 0;
async function schuss(name) {
  const r = await ruf('Page.captureScreenshot', { format: 'png' });
  const datei = `${praefix}-${String(++n).padStart(2, '0')}${name ? '-' + name : ''}.png`;
  writeFileSync(datei, Buffer.from(r.data, 'base64'));
  console.log(datei);
}

for (const s of schritte) {
  const [art, ...rest] = s.split(':');
  const wert = rest.join(':');
  if (art === 'klick') {
    const ok = await js(`(()=>{const e=document.querySelector(${JSON.stringify(wert)});
      if(!e) return 'FEHLT'; e.scrollIntoView({block:'center',behavior:'instant'});
      e.click(); return 'ok'})()`);
    if (ok !== 'ok') console.log(`  ! klick ${wert}: ${ok}`);
    await schlaf(1100);
  } else if (art === 'js') {
    console.log('  js →', JSON.stringify(await js(wert)));
  } else if (art === 'warte') {
    await schlaf(+wert);
  } else if (art === 'schuss') {
    await schuss(wert);
  }
}

const mass = await js(`JSON.stringify({
  ueberlauf: document.documentElement.scrollWidth - innerWidth,
  hoehe: document.documentElement.scrollHeight })`);
console.log(mass, fehler.length ? `\nKONSOLENFEHLER:\n  ${fehler.join('\n  ')}` : '\nkeine Konsolenfehler');
ws.close(); chrome.kill(); process.exit(0);
