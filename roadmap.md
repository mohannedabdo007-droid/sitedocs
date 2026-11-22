# Project Doc Control — Roadmap

## Phase 1 — Foundation (current)
- [ ] Backend schema: companies, members, projects, parties/roles, disciplines, doc types, numbering, documents, revisions, reviews, attachments, comments, audit, import staging, integration placeholders
- [ ] Server-side permissions (RLS + guarded functions) and tenant isolation
- [ ] Auth (email/password + Google + Lovable)
- [ ] AR/EN with RTL/LTR, Navy + Gold design, installable manifest
- [ ] Companies / projects / members UI
- [ ] Central register with search + filters + pagination
- [ ] Document detail: revisions, workflow actions, response codes, attachments, comments (internal/external), audit
- [ ] Project settings: numbering, workflow (PMC/Owner optional), response codes
- [ ] Excel import: staging -> preview -> mapping -> validation -> chunked commit
- [ ] Dashboard KPIs
- [ ] Tests + end-to-end check (project, document, revision, comment, register)

## Later (not started — do not present as available)
- OneDrive / Microsoft Graph sync with retry + conflict handling (schema placeholders only)
- OCR with human review (schema placeholder only)
- Windows scanner helper
- Pricing, 14-day trial, Marketing analytics, Smart Engineering Forms