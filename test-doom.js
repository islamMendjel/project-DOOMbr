#!/usr/bin/env node
/**
 * test-doom.js - Automated Playwright test for DOOM web player
 *
 * Validates:
 * - Page loads without errors
 * - Start button works
 * - Canvas renders non-black pixels (game started)
 * - No console errors or network failures
 */

const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch({ headless: true });
  const page = await browser.newPage();

  const errors = [];
  const networkFailures = [];

  // Listen for console logs
  page.on('console', msg => {
    console.log('[BROWSER]', msg.type(), msg.text());
    if (msg.type() === 'error') {
      errors.push(msg.text());
    }
  });

  page.on('pageerror', err => {
    console.error('[PAGE ERROR]', err);
    errors.push(err.message);
  });

  // Listen for network failures
  page.on('response', response => {
    if (!response.ok() && response.status() !== 304) {
      networkFailures.push(`${response.status()} ${response.url()}`);
    }
  });

  console.log('[TEST] Loading http://localhost:8000/');
  await page.goto('http://localhost:8000/', { waitUntil: 'networkidle', timeout: 15000 });

  console.log('[TEST] Waiting for start button...');
  await page.waitForSelector('#btn-start', { timeout: 5000 });

  console.log('[TEST] Clicking Start Game button...');
  await page.click('#btn-start');

  // Wait for game to initialize and run
  console.log('[TEST] Waiting for game to load and start...');
  await page.waitForFunction(() => window.__DOOM_RUNNING__ === true, { timeout: 35000 });

  console.log('[TEST] Game running. Waiting 3.5 seconds for title screen render...');
  await page.waitForTimeout(3500);

  // Take screenshot of the game canvas
  const screenshotPath = './doom-test-screenshot.png';
  const canvasElement = await page.$('#canvas');
  const canvasScreenshot = await canvasElement.screenshot({ path: screenshotPath });
  console.log(`[TEST] Canvas screenshot saved: ${screenshotPath} (${canvasScreenshot.length} bytes)`);

  const fullpagePath = './doom-fullpage-screenshot.png';
  await page.screenshot({ path: fullpagePath });
  console.log(`[TEST] Full page screenshot saved: ${fullpagePath}`);

  // Verify non-black pixels directly from the rendered canvas PNG
  const zlib = require('zlib');
  const width = canvasScreenshot.readUInt32BE(16);
  const height = canvasScreenshot.readUInt32BE(20);
  const colorType = canvasScreenshot.readUInt8(25);
  const bytesPerPixel = colorType === 6 ? 4 : 3;

  let pos = 8;
  const idatChunks = [];
  while (pos < canvasScreenshot.length) {
    const len = canvasScreenshot.readUInt32BE(pos);
    const type = canvasScreenshot.toString('ascii', pos + 4, pos + 8);
    if (type === 'IDAT') {
      idatChunks.push(canvasScreenshot.subarray(pos + 8, pos + 8 + len));
    }
    pos += 12 + len;
  }
  const decompressed = zlib.inflateSync(Buffer.concat(idatChunks));
  const stride = 1 + width * bytesPerPixel;
  let nonBlackPixels = 0;
  for (let y = 0; y < height; y++) {
    const rowStart = y * stride + 1;
    for (let x = 0; x < width; x++) {
      const idx = rowStart + x * bytesPerPixel;
      const r = decompressed[idx];
      const g = decompressed[idx + 1];
      const b = decompressed[idx + 2];
      if (r > 10 || g > 10 || b > 10) {
        nonBlackPixels++;
      }
    }
  }
  const totalPixels = width * height;
  const nonBlackPct = (nonBlackPixels / totalPixels) * 100;
  console.log(`[TEST] Canvas pixel verification: ${nonBlackPct.toFixed(2)}% colored pixels (${nonBlackPixels}/${totalPixels})`);
  const hasRendered = nonBlackPct > 1.0;

  // Send a few keystrokes
  console.log('[TEST] Simulating keyboard input...');
  await page.keyboard.press('ArrowUp');
  await page.waitForTimeout(200);
  await page.keyboard.press('ArrowLeft');
  await page.waitForTimeout(200);
  await page.keyboard.press('Space');

  await browser.close();

  // Results
  console.log('\n========== TEST RESULTS ==========');
  console.log(`✓ Page loaded`);
  console.log(`✓ Start button clicked`);
  console.log(`✓ Loading completed`);
  console.log(`${hasRendered ? '✓' : '✗'} Canvas rendered: ${hasRendered ? 'YES' : 'NO (BLACK SCREEN)'}`);
  console.log(`${errors.length === 0 ? '✓' : '✗'} Console errors: ${errors.length}`);
  if (errors.length > 0) {
    errors.forEach(e => console.log(`  - ${e}`));
  }
  console.log(`${networkFailures.length === 0 ? '✓' : '✗'} Network failures: ${networkFailures.length}`);
  if (networkFailures.length > 0) {
    networkFailures.forEach(f => console.log(`  - ${f}`));
  }
  console.log('==================================\n');

  if (!hasRendered || errors.length > 0 || networkFailures.length > 0) {
    console.error('[FAIL] Test failed - see issues above.');
    process.exit(1);
  }

  console.log('[PASS] All tests passed!');
  process.exit(0);
})();
