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
const returnReviewId = "30000000-0000-4000-8000-000000000013";
const closeReviewId = "30000000-0000-4000-8000-000000000014";
const bucket = "document-files";
const draftPath = projectId + "/" + draftId + "/api-seeded.pdf";
const creatorUploadPath = projectId + "/" + draftId + "/creator-upload.pdf";
const wrongUploadPath = projectId + "/" + draftId + "/other-party-upload.pdf";
const pmUploadPath = projectId + "/" + draftId + "/pm-upload.pdf";
const unregisteredPath = projectId + "/" + draftId + "/not-registered.pdf";
const orphanPath = projectId + "/" + draftId + "/orphan-without-attachment-metadata.pdf";

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
async function expectAnonNoRows(table, column, value, label) {
  const query = anon.from(table).select("*").eq(column, value);
  const result = await query;
  // Either PostgREST denies the relation entirely, or RLS returns no rows.
  // A successful response containing even one fixture row is an exposure.
  assert.ok(result.error || (Array.isArray(result.data) && result.data.length === 0),
    label + ": anonymous role received rows");
  pass(label);
}
async function expectRead(client, table, column, value, expected, label) {
  const result = await rows(client, table, column, value);
  assert.equal(result.length > 0, expected, label);
  pass(label);
}
async function expectStorageListDeniedOrEmpty(client, prefix, forbiddenNames, label) {
  const result = await client.storage.from(bucket).list(prefix, { limit: 100 });
  const names = (result.data ?? []).map(item => item.name);
  for (const name of forbiddenNames) assert.ok(!names.includes(name), label + ": unauthorized object was listed: " + name);
  assert.ok(result.error || names.length === 0, label + ": unauthorized listing returned objects");
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
async function expectStorageList(client, prefix, expectedNames, forbiddenNames, label) {
  const result = await client.storage.from(bucket).list(prefix, { limit: 100, offset: 0, sortBy: { column: "name", order: "asc" } });
  failIfError(result.error, label);
  const names = (result.data ?? []).map((entry) => entry.name);
  for (const name of expectedNames) assert.ok(names.includes(name), label + ": missing registered object " + name);
  for (const name of forbiddenNames) assert.ok(!names.includes(name), label + ": exposed forbidden object " + name);
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

// Exercise the profile-email guard through the real local Supabase Auth + PostgREST
// boundary, not only through a direct SQL role/JWT simulation.
const otherTenantIdentity = await otherTenant.auth.getUser();
failIfError(otherTenantIdentity.error, "Resolve authenticated other-tenant identity");
assert.ok(otherTenantIdentity.data.user?.id, "Authenticated other-tenant user ID is missing");
const spoofAttempt = await otherTenant
  .from("profiles")
  .update({ email: "p0-unregistered-invite-target@sitedocs.test" })
  .eq("id", otherTenantIdentity.data.user.id);
assert.ok(spoofAttempt.error, "PostgREST allowed an authenticated user to rewrite profiles.email");
assert.match(spoofAttempt.error.message, /PROFILE_EMAIL_IMMUTABLE/);
const unchangedProfile = await admin
  .from("profiles")
  .select("email")
  .eq("id", otherTenantIdentity.data.user.id)
  .single();
failIfError(unchangedProfile.error, "Verify profile email remained unchanged after PostgREST spoof attempt");
assert.equal(unchangedProfile.data.email, "p0-other-tenant@sitedocs.test");
pass("PostgREST authenticated profile-email spoof rejected and original identity preserved");

pass("Supabase Auth password grant issued distinct authenticated sessions for synthetic actors");

// Direct anonymous table reads: do not rely only on RPC execute grants.
// Each predicate targets a known synthetic row, so an empty table cannot
// produce a misleading pass.
await expectAnonNoRows("companies", "id", ownerCompanyId, "Anon cannot directly read owner company");
await expectAnonNoRows("projects", "id", projectId, "Anon cannot directly read project");
await expectAnonNoRows("project_members", "project_id", projectId, "Anon cannot enumerate project memberships");
await expectAnonNoRows("documents", "id", draftId, "Anon cannot directly read draft documents");
await expectAnonNoRows("document_revisions", "document_id", draftId, "Anon cannot directly read document revisions");
await expectAnonNoRows("document_reviews", "document_id", draftId, "Anon cannot directly read document reviews");
await expectAnonNoRows("attachments", "document_id", draftId, "Anon cannot directly read attachment metadata");
await expectAnonNoRows("comments", "document_id", draftId, "Anon cannot directly read comments");
await expectAnonNoRows("audit_log", "document_id", draftId, "Anon cannot directly read document audit history");
await expectAnonNoRows("import_batches", "id", "60000000-0000-4000-8000-000000000010", "Anon cannot directly read import batches");
await expectAnonNoRows("import_rows", "batch_id", "60000000-0000-4000-8000-000000000010", "Anon cannot directly read raw import rows");
await expectAnonNoRows("ocr_jobs", "id", "50000000-0000-4000-8000-000000000010", "Anon cannot directly read OCR jobs");

// Seed actual object bytes through the local service-role client. Every check
// below uses a non-privileged actor JWT and the real HTTP APIs.
const seeded = await admin.storage.from(bucket).upload(
  draftPath,
  new Blob(["SiteDocs synthetic P0 document"], { type: "application/pdf" }),
  { contentType: "application/pdf", upsert: false },
);
failIfError(seeded.error, "Seed private document object");
pass("Real Storage object seeded in private document-files bucket");
const orphanSeed = await admin.storage.from(bucket).upload(
  orphanPath,
  new Blob(["SiteDocs synthetic orphan object"], { type: "application/pdf" }),
  { contentType: "application/pdf", upsert: false },
);
failIfError(orphanSeed.error, "Seed orphan Storage object without attachment metadata");
pass("Orphan Storage object seeded without an attachments row");

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
const importBatchId = "60000000-0000-4000-8000-000000000010";
await expectRead(peer, "import_batches", "id", importBatchId, true, "PostgREST import creator reads own staging batch");
await expectRead(peer, "import_rows", "batch_id", importBatchId, true, "PostgREST import creator reads own raw rows");
for (const [actor, label] of [
  [creator, "document creator who did not create the import batch"],
  [wrong, "different project party"],
  [reviewer, "current document reviewer"],
  [pm, "read-only project manager"],
  [viewer, "ordinary project viewer"],
  [companyAdmin, "company admin without project membership"],
  [otherTenant, "different tenant"],
]) {
  await expectRead(actor, "import_batches", "id", importBatchId, false, "PostgREST " + label + " cannot read raw import batch");
  await expectRead(actor, "import_rows", "batch_id", importBatchId, false, "PostgREST " + label + " cannot read raw import rows");
}
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

// Storage listing must enforce the same document-aware boundary as download.
// Registered metadata is visible to authorized readers; orphan objects and
// other-party prefixes must not be enumerable through the list endpoint.
const draftFolder = projectId + "/" + draftId;
await expectStorageList(
  creator,
  draftFolder,
  ["api-seeded.pdf"],
  ["orphan-without-attachment-metadata.pdf"],
  "Storage creator lists registered attachment but cannot enumerate orphan object",
);
await expectStorageList(
  pm,
  draftFolder,
  ["api-seeded.pdf"],
  ["orphan-without-attachment-metadata.pdf"],
  "Storage PM lists authorized registered attachment read-only",
);
await expectStorageList(
  wrong,
  draftFolder,
  [],
  ["api-seeded.pdf", "orphan-without-attachment-metadata.pdf"],
  "Storage different party cannot enumerate draft object names",
);
await expectStorageList(
  otherTenant,
  draftFolder,
  [],
  ["api-seeded.pdf", "orphan-without-attachment-metadata.pdf"],
  "Storage other tenant cannot enumerate draft object names",
);
await expectStorageListDeniedOrEmpty(
  anon,
  draftFolder,
  ["api-seeded.pdf", "orphan-without-attachment-metadata.pdf"],
  "Storage anon cannot enumerate private object names",
);
await expectStorageDownload(creator, orphanPath, false, "Storage creator cannot download orphan object without attachment metadata");

// Upload policy binds the path to a registered attachment and document-level
// write permission, rather than project membership alone.
await expectUpload(creator, creatorUploadPath, true, "Storage creator uploads registered document attachment");
await expectUpload(wrong, wrongUploadPath, false, "Storage different party cannot upload registered attachment");
await expectUpload(pm, pmUploadPath, false, "Storage PM cannot upload despite read access");
await expectUpload(creator, unregisteredPath, false, "Storage creator cannot upload unregistered object path");

// Draft submission is creator-only, even for another member of the originating party.
const peerSubmit = await peer.rpc("transition_document", {
  _doc: draftId, _action: "submit", _response_code: null, _notes: null,
});
assert.ok(peerSubmit.error, "Originating-party peer unexpectedly submitted another user's draft");
assert.match(peerSubmit.error.message, /CREATOR_ONLY_SUBMIT/);
pass("PostgREST originating-party peer cannot submit another member's draft");

const wrongPartySubmit = await wrong.rpc("transition_document", {
  _doc: draftId, _action: "submit", _response_code: null, _notes: null,
});
assert.ok(wrongPartySubmit.error, "Different party unexpectedly submitted draft");
pass("PostgREST different party cannot submit draft");

const creatorSubmit = await creator.rpc("transition_document", {
  _doc: draftId, _action: "submit", _response_code: null, _notes: null,
});
failIfError(creatorSubmit.error, "Draft creator submission");
assert.equal(creatorSubmit.data?.status, "submitted", "Draft creator could not submit own draft");
pass("PostgREST draft creator can submit own eligible draft");

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

const validReviewerTransition = await reviewer.rpc("transition_document", {
  _doc: submittedId, _action: "start_review", _response_code: null, _notes: null,
});
failIfError(validReviewerTransition.error, "Authorized current-party reviewer transition");
assert.equal(validReviewerTransition.data?.status, "under_review", "Authorized reviewer did not start review");
pass("PostgREST current workflow reviewer can start review");

const missingResponseCode = await reviewer.rpc("transition_document", {
  _doc: submittedId, _action: "respond", _response_code: null, _notes: null,
});
assert.ok(missingResponseCode.error, "Reviewer response without a required code unexpectedly succeeded");
assert.match(missingResponseCode.error.message, /RESPONSE_CODE_REQUIRED/);
pass("PostgREST reviewer cannot respond without a required project response code");

const wrongPartyResponse = await wrong.rpc("transition_document", {
  _doc: returnReviewId, _action: "respond", _response_code: "R", _notes: "unauthorized",
});
assert.ok(wrongPartyResponse.error, "Wrong party unexpectedly submitted a reviewer response");
assert.match(wrongPartyResponse.error.message, /FORBIDDEN/);
pass("PostgREST wrong party cannot issue a reviewer response");

const proceedResponse = await reviewer.rpc("transition_document", {
  _doc: submittedId, _action: "respond", _response_code: "P", _notes: "Proceed with the next step",
});
failIfError(proceedResponse.error, "Reviewer proceed response");
assert.equal(proceedResponse.data?.status, "approved", "Proceed response did not approve the final workflow step");
assert.equal(proceedResponse.data?.current_response_code, "P");
pass("PostgREST reviewer proceed response approves the final workflow step");

const returnResponse = await reviewer.rpc("transition_document", {
  _doc: returnReviewId, _action: "respond", _response_code: "R", _notes: "Please revise the submission",
});
failIfError(returnResponse.error, "Reviewer return response");
assert.equal(returnResponse.data?.status, "returned", "Return response did not return the document");
assert.equal(returnResponse.data?.current_response_code, "R");
pass("PostgREST reviewer return response returns the document to its originator");

const closeResponse = await reviewer.rpc("transition_document", {
  _doc: closeReviewId, _action: "respond", _response_code: "I", _notes: "No further action",
});
failIfError(closeResponse.error, "Reviewer close response");
assert.equal(closeResponse.data?.status, "closed", "Close response did not close the document");
assert.equal(closeResponse.data?.current_response_code, "I");
pass("PostgREST reviewer close response closes the review cycle");

const selfReview = await creator.rpc("transition_document", {
  _doc: selfReviewId, _action: "start_review", _response_code: null, _notes: null,
});
assert.ok(selfReview.error, "Creator unexpectedly self-reviewed their own document");
assert.match(selfReview.error.message, /SELF_REVIEW_FORBIDDEN/);
pass("PostgREST creator self-review is rejected with SELF_REVIEW_FORBIDDEN");

const implicitRole = await companyAdmin.rpc("project_role_of", { _project: projectId });
assert.equal(implicitRole.error, null, "Could not inspect caller project role through PostgREST");
assert.equal(implicitRole.data, null, "Company admin without project membership inherited a project role");
pass("PostgREST company admin does not inherit project role from company administration");

const implicitManage = await companyAdmin.rpc("can_manage_project", { _project: projectId });
assert.equal(implicitManage.error, null, "Could not inspect project-management permission through PostgREST");
assert.equal(implicitManage.data, false, "Company admin without project membership inherited project-admin permission");
pass("PostgREST company admin without project membership cannot manage project");

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
