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
