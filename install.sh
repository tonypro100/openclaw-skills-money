
set -e
REPO="https://github.com/tonypro100/openclaw-skills-money.git"

rm -rf openclaw-skills-money || true
git clone "$REPO"
cd openclaw-skills-money

mkdir -p skills/ssgm-core/{orchestrator,memory,guardian,evals,templates}

cat > skills/ssgm-core/SKILL.md <<'MD'
---
name: ssgm-core
description: Core orchestration + memory + safety guardrails for SSGM-grade OpenClaw agents.
version: 0.1.0
metadata:
  openclaw:
    emoji: "🧠"
---
MD

cat > skills/ssgm-core/orchestrator/ssgm-swarm.js <<'JS'
#!/usr/bin/env node
const fs = require("fs");
const path = require("path");

function arg(name, def=null){
  const i = process.argv.indexOf(`--${name}`);
  return (i !== -1 && process.argv[i+1]) ? process.argv[i+1] : def;
}
const agents = Number(arg("agents","8"));
const concurrency = Number(arg("concurrency","4"));
const taskFile = arg("tasks","tasks.json");

const outDir = path.resolve(process.cwd(),"out");
fs.mkdirSync(outDir,{recursive:true});

const tasks = JSON.parse(fs.readFileSync(taskFile,"utf8"));
fs.writeFileSync(path.join(outDir,"run.json"), JSON.stringify({
  ts: new Date().toISOString(),
  agents, concurrency,
  tasksCount: tasks.length
}, null, 2));

console.log("[SSGM] Swarm ready");
JS

chmod +x skills/ssgm-core/orchestrator/ssgm-swarm.js

cat > install.sh <<'SH'
=======

#!/usr/bin/env bash
mkdir -p ~/.openclaw/skills
cp -R skills/* ~/.openclaw/skills/
echo "Installed"

SH

chmod +x install.sh

git add .
git commit -m "Add SSGM core"
git push origin main

bash install.sh
=======

