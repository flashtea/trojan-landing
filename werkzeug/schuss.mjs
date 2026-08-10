#!/usr/bin/env node
// schuss.mjs <url> <breite> <ziel-praefix> [--serie=N] [--voll] [--scroll=PX]
//
// Screenshots ueber das DevTools-Protokoll. Node 22+ bringt WebSocket mit,
// deshalb braucht das hier weder Puppeteer noch Playwright.
//
//   --serie=N   N gleichmaessig verteilte Ansichten von oben nach unten
//               -> <praefix>-01.png ... <praefix>-N.png  (Standard: 1)
//   --voll      stattdessen ein Bild ueber die ganze Seitenhoehe
//   --scroll=PX stattdessen genau eine Ansicht ab dieser Scrollhoehe
//
// Gibt am Ende Seitenhoehe und waagrechten Ueberlauf aus. Ueberlauf > 0
// heisst: die Seite laesst sich seitlich schieben, das ist immer ein Fehler.
import { spawn } from 'node:child_process';
import { mkdtempSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';

const [url, breiteRaw, praefix, ...rest] = process.argv.slice(2);
if (!url || !breiteRaw || !praefix) {
  console.error('schuss.mjs <url> <breite> <ziel-praefix> [--serie=N] [--voll] [--scroll=PX]');
  process.exit(2);
}
const breite = +breiteRaw;
const hoehe = breite < 700 ? 844 : 900;
const voll = rest.includes('--voll');
const serie = +(rest.find(a => a.startsWith('--serie='))?.slice(8) || 0);
const scrollArg = rest.find(a => a.startsWith('--scroll='));
const scroll = scrollArg ? +scrollArg.slice(9) : null;

const port = 9200 + (process.pid % 700);
const profil = mkdtempSync(join(tmpdir(), 'schuss-'));
const chrome = spawn('chromium', [
  '--headless=new', '--disable-gpu', '--no-sandbox', '--hide-scrollbars',
  '--no-first-run', '--disable-extensions', '--force-device-scale-factor=1',
  `--user-data-dir=${profil}`, `--remote-debugging-port=${port}`,
  `--window-size=${breite},${hoehe}`, 'about:blank',
], { stdio: ['ignore', 'ignore', 'ignore'] });

const schlaf = ms => new Promise(r => setTimeout(r, ms));

async function debugUrl() {
  for (let i = 0; i < 80; i++) {
    try {
      const l = await (await fetch(`http://127.0.0.1:${port}/json/list`)).json();
      const p = l.find(x => x.type === 'page');
      if (p) return p.webSocketDebuggerUrl;
    } catch { /* noch nicht oben */ }
    await schlaf(200);
  }
  throw new Error('Chromium meldet sich nicht');
}

const ws = new WebSocket(await debugUrl());
await new Promise((ok, weg) => { ws.onopen = ok; ws.onerror = weg; });

let id = 0;
const offen = new Map();
ws.onmessage = e => {
  const m = JSON.parse(e.data);
  if (m.id && offen.has(m.id)) { offen.get(m.id)(m); offen.delete(m.id); }
};
const ruf = (method, params = {}) => new Promise(ok => {
  const n = ++id;
  offen.set(n, m => ok(m.result ?? m.error));
  ws.send(JSON.stringify({ id: n, method, params }));
});
const js = async expression => (await ruf('Runtime.evaluate',
  { expression, returnByValue: true })).result?.value;

await ruf('Page.enable');
await ruf('Emulation.setDeviceMetricsOverride',
  { width: breite, height: hoehe, deviceScaleFactor: 1, mobile: breite < 700 });
await ruf('Page.navigate', { url });
await schlaf(2800);                       // Schriften, Bilder, die Plan-Abfrage

async function schiessen(datei, beyond = false) {
  const r = await ruf('Page.captureScreenshot', { format: 'png', captureBeyondViewport: beyond });
  if (!r.data) { console.error('kein Bild:', JSON.stringify(r)); process.exit(1); }
  writeFileSync(datei, Buffer.from(r.data, 'base64'));
  console.log(datei);
}

const seite = await js('document.documentElement.scrollHeight');
if (voll) {
  await schiessen(`${praefix}.png`, true);
} else if (scroll !== null) {
  await js(`scrollTo(0,${scroll})`); await schlaf(1000);
  await schiessen(`${praefix}.png`);
} else {
  const n = Math.max(1, serie || 1);
  const weit = Math.max(0, seite - hoehe);
  for (let i = 0; i < n; i++) {
    const y = n === 1 ? 0 : Math.round(weit * i / (n - 1));
    await js(`scrollTo(0,${y})`);
    await schlaf(i === 0 ? 200 : 1000);   // Einblendungen laufen lassen
    await schiessen(`${praefix}-${String(i + 1).padStart(2, '0')}.png`);
  }
}

const ueberlauf = await js('document.documentElement.scrollWidth - innerWidth');
console.log(`breite=${breite} seitenhoehe=${seite} ueberlauf=${ueberlauf}`);
ws.close(); chrome.kill();
process.exit(0);
