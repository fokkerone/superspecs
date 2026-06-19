#!/usr/bin/env node
const { execSync } = require('child_process');
const path = require('path');
const args = process.argv.slice(2);

if (args[0] === 'install') {
  const setupPath = path.join(__dirname, '..', 'setup.sh');
  execSync(`bash "${setupPath}"`, { stdio: 'inherit' });
} else {
  console.log('SuperSpecs CLI');
  console.log('Usage: superspecs install');
}
