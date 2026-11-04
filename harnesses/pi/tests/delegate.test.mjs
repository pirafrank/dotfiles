import test from "node:test";
import assert from "node:assert/strict";
import { Ajv2020 } from "ajv/dist/2020.js";
import { createResultParser, delegatedArgs, runPi } from "../lib/delegate.mjs";

const validate = new Ajv2020().compile({ type: "object", required: ["status", "summary"], properties: {
  status: { enum: ["ok", "failed", "cancelled", "timeout"] }, summary: { type: "string" }, files: { type: "array", items: { type: "string" } }
} });
const result = { status: "ok", summary: "Evidence with Unicode \u2028 and café", files: ["src/main.ts"] };
const event = (value = result, stopReason = "stop") => JSON.stringify({ type: "message_end", message: { role: "assistant", stopReason, content: [{ type: "text", text: JSON.stringify(value) }] } }) + "\n";

test("extracts the last assistant response across chunk boundaries", () => {
  const parser = createResultParser(validate);
  const raw = event({ status: "ok", summary: "earlier" }) + JSON.stringify({ type: "message_end", message: { role: "toolResult" } }) + "\n" + event();
  for (let i = 0; i < raw.length; i += 3) parser.feed(raw.slice(i, i + 3));
  assert.deepEqual(parser.finish(), result);
});

test("rejects malformed, missing, unsuccessful, and schema-invalid results", () => {
  for (const raw of ["", JSON.stringify(result) + "\n", event(result, "error"), event(result, "aborted"), event(result, "length"), event({ status: "ok" }), event({ status: "ok", summary: "x", files: [1] }), event({ status: "failed", summary: "failure" }), event() + '{"type":"agent_settled","aborted":true}\n', event().trimEnd(), "invalid\n"]) {
    assert.throws(() => { const parser = createResultParser(validate); parser.feed(raw); parser.finish(); });
  }
});

test("enforces role tools, preserves the base prompt, and separates CLI input", () => {
  const args = delegatedArgs({ prompt: "Explore", tools: ["read", "grep"] }, { task: "--dangerous-looking task", schema: {}, context: "prior evidence" });
  assert.equal(args[args.indexOf("--tools") + 1], "read,grep");
  assert.ok(args.includes("--append-system-prompt"));
  assert.ok(args.includes("--no-mcp"));
  assert.deepEqual(args.slice(-2), ["--", "--dangerous-looking task"]);
  assert.throws(() => delegatedArgs({ prompt: "x", tools: ["*"] }, { task: "x", schema: {} }));
});

test("streams large transcripts while retaining the final validated result", async () => {
  const code = `for(let i=0;i<2000;i++) process.stdout.write(JSON.stringify({type:'message_update',text:'x'.repeat(100)})+String.fromCharCode(10)); process.stdout.write(${JSON.stringify(event())});`;
  const output = await runPi(["-e", code], 5000, undefined, validate, process.execPath);
  assert.deepEqual(output.result, result);
  assert.ok(output.raw.length <= 65536);
});

test("rejects successful process exits with assistant errors and nonzero exits", async () => {
  await assert.rejects(runPi(["-e", `process.stdout.write(${JSON.stringify(event(result, "error"))})`], 5000, undefined, validate, process.execPath), /successfully/);
  await assert.rejects(runPi(["-e", "process.exit(2)"], 5000, undefined, validate, process.execPath), /exited 2/);
});

test("cancels and escalates termination for an unresponsive child", async () => {
  await assert.rejects(runPi(["-e", "process.on('SIGTERM',()=>{});setInterval(()=>{},100)"], 150, undefined, validate, process.execPath), /timed out/);
  const controller = new AbortController();
  const promise = runPi(["-e", "setInterval(()=>{},100)"], 5000, controller.signal, validate, process.execPath);
  controller.abort();
  await assert.rejects(promise, /cancelled/);
  await assert.rejects(runPi([], 5000, controller.signal, validate, process.execPath), /cancelled/);
});

test("rejects oversized JSON records without retaining the full stream", async () => {
  await assert.rejects(runPi(["-e", "process.stdout.write('x'.repeat(1100000))"], 5000, undefined, validate, process.execPath), /capture limit/);
});
