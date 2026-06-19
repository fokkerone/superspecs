#!/usr/bin/env node
'use strict';

const { execSync } = require('child_process');
const path = require('path');
const fs = require('fs');

const pkg = require('../package.json');
const args = process.argv.slice(2);
const cmd = args[0];

const HELP = `
SuperSpecs — Spec-driven AI development

Usage:
  superspecs install       Symlink skills into all AI agent dirs + init project
  superspecs init          Init superspec/ directory structure in current project
  superspecs version       Print version
  superspecs help          Show this help

Examples:
  superspecs install       # Run once after global install
  npx superspecs install   # Run without installing globally
`;

if (cmd === 'version' || cmd === '-v' || cmd === '--version') {
  console.log(pkg.version);
  process.exit(0);
}

if (!cmd || cmd === 'help' || cmd === '--help' || cmd === '-h') {
  console.log(HELP);
  process.exit(0);
}

if (cmd === 'install' || cmd === 'init') {
  const setupPath = path.join(__dirname, '..', 'setup.sh');

  if (!fs.existsSync(setupPath)) {
    console.error('Error: setup.sh not found at', setupPath);
    process.exit(1);
  }

  // Pass the user's CWD so setup.sh creates superspec/ there, not in the npm module dir
  const env = {
    ...process.env,
    SUPERSPECS_PROJECT_DIR: process.cwd(),
    SUPERSPECS_SKIP_SYMLINKS: cmd === 'init' ? '1' : '0',
  };

  try {
    execSync(`bash "${setupPath}"`, { stdio: 'inherit', env });
  } catch (err) {
    process.exit(err.status || 1);
  }
} else {
  console.error(`Unknown command: ${cmd}`);
  console.log(HELP);
  process.exit(1);
}
