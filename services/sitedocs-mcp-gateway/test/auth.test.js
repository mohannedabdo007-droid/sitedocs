import test from "node:test";
import assert from "node:assert/strict";
import { isAuthorized } from "../src/auth.js";

const token = "test-token-with-at-least-thirty-two-characters";

test("accepts the exact bearer token", () => {
  const request = new Request("https://example.test/mcp", {
    headers: { authorization: `Bearer ${token}` },
  });
  assert.equal(isAuthorized(request, token), true);
});

test("rejects a missing or malformed authorization header", () => {
  assert.equal(isAuthorized(new Request("https://example.test/mcp"), token), false);
  const malformed = new Request("https://example.test/mcp", {
    headers: { authorization: `Basic ${token}` },
  });
  assert.equal(isAuthorized(malformed, token), false);
});

test("rejects an incorrect token", () => {
  const request = new Request("https://example.test/mcp", {
    headers: { authorization: "Bearer wrong-token-value" },
  });
  assert.equal(isAuthorized(request, token), false);
});

test("fails closed when the configured secret is missing or too short", () => {
  const request = new Request("https://example.test/mcp", {
    headers: { authorization: `Bearer ${token}` },
  });
  assert.equal(isAuthorized(request, undefined), false);
  assert.equal(isAuthorized(request, "short"), false);
});
