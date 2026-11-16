import assert from "node:assert/strict";
import { createClient } from "@supabase/supabase-js";

const url = process.env.API_URL;
const anonKey = process.env.ANON_KEY;
const serviceKey = process.env.SERVICE_ROLE_KEY;
assert.ok(url, "API_URL is required");
assert.ok(anonKey, "ANON_KEY is required");
assert.ok(serviceKey, "SERVICE_ROLE_KEY is required");

const password = "P0-Test-Password!";
const projectId = "20000000-0000-4000-8000-000000000010";
const ownerCompanyId = "10000000-0000-4000-8000-000000000010";
const draftId = "30000000-0000-4000-8000-000000000010";
const submittedId = "30000000-0000-4000-8000-000000000011";
const selfReviewId = "30000000-0000-4000-8000-000000000012";
const bucket = "document-files";
const draftPath = projectId + "/" + draftId + "/api-seeded.pdf";
const creatorUploadPath = projectId + "/" + draftId + "/creator-upload.pdf";
const wrongUploadPath = projectId + "/" + draftId + "/other-party-upload.pdf";
const pmUploadPath = projectId + "/" + draftId + "/pm-upload.pdf";
const unregisteredPath = projectId + "/" + draftId + "/not-registered.pdf";

const options = { auth: { persistSession: false, autoRefreshToken: false, detectSessionInUrl: false } };
const admin = createClient(url, serviceKey, options);
const anon = createClient(url, anonKey, options);

function pass(label) {
  process.stdout.write("PASS " + label + "\n");
}
function failIfError(error, label) {
  if (error) throw new Error(label + ": " + error.message + " (" + (error.code ?? "no code") + ")");
}
async function signIn(email) {
  const client = createClient(url, anonKey, options);
  const result = await client.auth.signInWithPassword({ email, password });
  failIfError(result.error, "Auth sign-in " + email);
  assert.ok(result.data.session?.access_token, "No access token for " + email);
  return client;
}
async function rows(client, table, column, value) {
  const result = await client.from(table).select("*").eq(column, value);
  failIfError(result.error, "PostgREST " + table);
  return result.data ?? [];
}
async function expectRead(client, table, column, value, expected, label) {
  const result = await rows(client, table, column, value);
  assert.equal(result.length > 0, expected, label);
  pass(label);
}
async function expectStorageDownload(client, path, expected, label) {
  const result = await client.storage.from(bucket).download(path);
  assert.equal(Boolean(result.data), expected, label + ": " + (result.error?.message ?? "unexpected download result"));
  if (expected) {
    const text = await result.data.text();
    assert.match(text, /SiteDocs synthetic P0 document/);
  }
  pass(label);
}
async function expectUpload(client, path, expected, label) {
  const result = await client.storage.from(bucket).upload(
    path,
    new Blob(["SiteDocs synthetic P0 upload"], { type: "application/pdf" }),
    { contentType: "application/pdf", upsert: false },
  );
  assert.equal(!result.error && Boolean(result.data?.path), expected, label + ": " + (result.error?.message ?? "unexpected upload result"));
  pass(label);
}
async function expectSignedUrl(client, path, expected, label) {
  const result = await client.storage.from(bucket).createSignedUrl(path, 60);
  assert.equal(!result.error && Boolean(result.data?.signedUrl), expected, label + ": " + (result.error?.message ?? "unexpected signed URL result"));
  if (expected) {
    const signed = new URL(result.data.signedUrl, url);
    const response = await fetch(signed);
    assert.equal(response.status, 200, label + ": signed URL returned HTTP " + response.status);
    assert.match(await response.text(), /SiteDocs synthetic P0 document/);
  }
  pass(label);
}

const creator = await signIn("p0-creator@sitedocs.test");
const peer = await signIn("p0-peer@sitedocs.test");
const wrong = await signIn("p0-wrong@sitedocs.test");
const reviewer = await signIn("p0-reviewer@sitedocs.test");
const pm = await signIn("p0-pm@sitedocs.test");
const viewer = await signIn("p0-viewer@sitedocs.test");
const companyAdmin = await signIn("p0-company-admin@sitedocs.test");
const otherTenant = await signIn("p0-other-tenant@sitedocs.test");
pass("Supabase Auth password grant issued distinct authenticated sessions for synthetic actors");

// Seed actual object bytes through the local service-role client. Every check
// below uses a non-privileged actor JWT and the real HTTP APIs.
const seeded = await admin.storage.from(bucket).upload(
  draftPath,
  new Blob(["SiteDocs synthetic P0 document"], { type: "application/pdf" }),
  { contentType: "application/pdf", upsert: false },
);
failIfError(seeded.error, "Seed private document object");
pass("Real Storage object seeded in private document-files bucket");

// PostgREST document visibility.
await expectRead(creator, "documents", "id", draftId, true, "PostgREST creator reads own draft");
await expectRead(peer, "documents", "id", draftId, true, "PostgREST originator-party peer reads draft");
await expectRead(pm, "documents", "id", draftId, true, "PostgREST explicitly appointed PM reads draft");
await expectRead(wrong, "documents", "id", draftId, false, "PostgREST different party cannot read draft");
await expectRead(viewer, "documents", "id", draftId, false, "PostgREST ordinary viewer cannot read draft");
await expectRead(companyAdmin, "documents", "id", draftId, false, "PostgREST company admin without project membership cannot read draft");
await expectRead(otherTenant, "documents", "id", draftId, false, "PostgREST other tenant cannot read draft");

// Child data and side channels follow the document boundary.
for (const table of ["document_revisions", "document_reviews", "attachments", "comments", "audit_log", "ocr_jobs"]) {
  const column = table === "ocr_jobs" ? "id" : "document_id";
  const value = table === "ocr_jobs" ? "50000000-0000-4000-8000-000000000010" : draftId;
  await expectRead(wrong, table, column, value, false, "PostgREST different party blocked from " + table);
  await expectRead(pm, table, column, value, true, "PostgREST PM can read authorized " + table);
}
await expectRead(pm, "import_batches", "id", "60000000-0000-4000-8000-000000000010", false, "PostgREST PM cannot read raw import staging");
await expectRead(otherTenant, "companies", "id", ownerCompanyId, false, "PostgREST other tenant cannot enumerate owner company");

// Actual Storage download and signed URL routes.
await expectStorageDownload(creator, draftPath, true, "Storage creator downloads draft bytes");
await expectStorageDownload(peer, draftPath, true, "Storage originating-party peer downloads draft bytes");
await expectStorageDownload(pm, draftPath, true, "Storage PM downloads draft bytes read-only");
await expectStorageDownload(wrong, draftPath, false, "Storage different party cannot download draft");
await expectStorageDownload(otherTenant, draftPath, false, "Storage other tenant cannot download draft");
await expectSignedUrl(creator, draftPath, true, "Storage creator obtains and uses signed URL");
await expectSignedUrl(pm, draftPath, true, "Storage PM obtains and uses read-only signed URL");
await expectSignedUrl(wrong, draftPath, false, "Storage different party cannot create signed URL");
await expectSignedUrl(otherTenant, draftPath, false, "Storage other tenant cannot create signed URL");

// Upload policy binds the path to a registered attachment and document-level
// write permission, rather than project membership alone.
await expectUpload(creator, creatorUploadPath, true, "Storage creator uploads registered document attachment");
await expectUpload(wrong, wrongUploadPath, false, "Storage different party cannot upload registered attachment");
await expectUpload(pm, pmUploadPath, false, "Storage PM cannot upload despite read access");
await expectUpload(creator, unregisteredPath, false, "Storage creator cannot upload unregistered object path");

// Protected RPCs through PostgREST.
const pmTransition = await pm.rpc("transition_document", {
  _doc: submittedId, _action: "start_review", _response_code: null, _notes: null,
});
assert.ok(pmTransition.error, "PM unexpectedly invoked workflow transition RPC");
pass("PostgREST PM cannot invoke transition_document");

const wrongTransition = await wrong.rpc("transition_document", {
  _doc: submittedId, _action: "start_review", _response_code: null, _notes: null,
});
assert.ok(wrongTransition.error, "Different party unexpectedly invoked workflow transition RPC");
pass("PostgREST different party cannot invoke transition_document");

const selfReview = await creator.rpc("transition_document", {
  _doc: selfReviewId, _action: "start_review", _response_code: null, _notes: null,
});
assert.ok(selfReview.error, "Creator unexpectedly self-reviewed their own document");
assert.match(selfReview.error.message, /SELF_REVIEW_FORBIDDEN/);
pass("PostgREST creator self-review is rejected with SELF_REVIEW_FORBIDDEN");

const companySearch = await companyAdmin.rpc("search_companies_for_project_invitation", {
  _project: projectId, _query: "P0X",
});
assert.ok(companySearch.error, "Company admin without project membership unexpectedly searched project invitations");
assert.match(companySearch.error.message, /FORBIDDEN/);
pass("PostgREST company admin without project membership is denied invitation-search RPC");

const anonRpc = await anon.rpc("transition_document", {
  _doc: submittedId, _action: "start_review", _response_code: null, _notes: null,
});
assert.ok(anonRpc.error, "Anon unexpectedly invoked protected workflow RPC");
pass("PostgREST anon cannot invoke protected workflow RPC");

process.stdout.write("\nSupabase API/Storage P0 acceptance: all checks passed.\n");
