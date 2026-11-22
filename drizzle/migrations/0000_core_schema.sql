-- ===== Enums =====
create type public.company_role as enum ('owner','admin','member');
create type public.project_party as enum ('contractor','consultant','owner','pmc');
create type public.project_role as enum ('admin','controller','reviewer','viewer');
create type public.doc_lifecycle as enum ('draft','submitted','under_review','returned','approved','closed');
create type public.response_outcome as enum ('proceed','return','close');
create type public.comment_visibility as enum ('internal','external');

-- ===== Profiles =====
create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  email text,
  full_name text,
  locale text not null default 'ar' check (locale in ('ar','en')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
grant select, insert, update on public.profiles to authenticated;
grant all on public.profiles to service_role;
alter table public.profiles enable row level security;
create index profiles_email_idx on public.profiles (lower(email));

-- ===== Companies (tenants) =====
create table public.companies (
  id uuid primary key default gen_random_uuid(),
  name text not null check (length(btrim(name)) between 1 and 200),
  name_ar text,
  code text not null check (code ~ '^[A-Za-z0-9_-]{1,20}$'),
  created_by uuid not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
grant select, update on public.companies to authenticated;
grant all on public.companies to service_role;
alter table public.companies enable row level security;

create table public.company_members (
  id uuid primary key default gen_random_uuid(),
  company_id uuid not null references public.companies(id) on delete cascade,
  user_id uuid not null,
  role public.company_role not null default 'member',
  created_at timestamptz not null default now(),
  unique (company_id, user_id)
);
grant select, insert, update, delete on public.company_members to authenticated;
grant all on public.company_members to service_role;
alter table public.company_members enable row level security;
create index company_members_user_idx on public.company_members (user_id);

-- ===== Projects =====
create table public.projects (
  id uuid primary key default gen_random_uuid(),
  company_id uuid not null references public.companies(id) on delete restrict,
  code text not null check (code ~ '^[A-Za-z0-9_-]{1,20}$'),
  name text not null check (length(btrim(name)) between 1 and 200),
  name_ar text,
  client_name text,
  location text,
  status text not null default 'active' check (status in ('active','on_hold','completed','archived')),
  start_date date,
  created_by uuid not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (company_id, code)
);
grant select, update on public.projects to authenticated;
grant all on public.projects to service_role;
alter table public.projects enable row level security;

create table public.project_members (
  id uuid primary key default gen_random_uuid(),
  project_id uuid not null references public.projects(id) on delete cascade,
  company_id uuid not null references public.companies(id) on delete cascade,
  user_id uuid not null,
  party public.project_party not null,
  role public.project_role not null default 'viewer',
  organization text,
  created_at timestamptz not null default now(),
  unique (project_id, user_id)
);
grant select, insert, update, delete on public.project_members to authenticated;
grant all on public.project_members to service_role;
alter table public.project_members enable row level security;
create index project_members_user_idx on public.project_members (user_id);

-- ===== Reference data =====
create table public.disciplines (
  id uuid primary key default gen_random_uuid(),
  code text not null unique,
  name_en text not null,
  name_ar text not null,
  sort int not null default 0
);
grant select on public.disciplines to authenticated;
grant all on public.disciplines to service_role;
alter table public.disciplines enable row level security;

create table public.document_types (
  id uuid primary key default gen_random_uuid(),
  code text not null unique,
  name_en text not null,
  name_ar text not null,
  category text not null check (category in ('inspection','submittal','correspondence','report','quality')),
  uses_response_codes boolean not null default true,
  requires_review boolean not null default true,
  has_direction boolean not null default false,
  sort int not null default 0
);
grant select on public.document_types to authenticated;
grant all on public.document_types to service_role;
alter table public.document_types enable row level security;

-- ===== Per-project configuration =====
create table public.project_response_codes (
  id uuid primary key default gen_random_uuid(),
  project_id uuid not null references public.projects(id) on delete cascade,
  company_id uuid not null references public.companies(id) on delete cascade,
  code text not null check (code ~ '^[A-Z0-9]{1,4}$'),
  label_en text not null,
  label_ar text not null,
  outcome public.response_outcome not null,
  active boolean not null default true,
  sort int not null default 0,
  unique (project_id, code)
);
grant select, insert, update on public.project_response_codes to authenticated;
grant all on public.project_response_codes to service_role;
alter table public.project_response_codes enable row level security;

create table public.project_workflows (
  id uuid primary key default gen_random_uuid(),
  project_id uuid not null references public.projects(id) on delete cascade,
  company_id uuid not null references public.companies(id) on delete cascade,
  document_type_id uuid references public.document_types(id),
  steps public.project_party[] not null check (array_length(steps, 1) between 1 and 6),
  review_days int not null default 7 check (review_days between 0 and 365),
  requires_review boolean,
  uses_response_codes boolean,
  updated_at timestamptz not null default now(),
  unique nulls not distinct (project_id, document_type_id)
);
grant select, insert, update on public.project_workflows to authenticated;
grant all on public.project_workflows to service_role;
alter table public.project_workflows enable row level security;

create table public.numbering_schemes (
  id uuid primary key default gen_random_uuid(),
  project_id uuid not null references public.projects(id) on delete cascade,
  company_id uuid not null references public.companies(id) on delete cascade,
  document_type_id uuid not null references public.document_types(id),
  discipline_id uuid references public.disciplines(id),
  pattern text not null check (pattern like '%{SEQ%' and length(pattern) <= 120),
  next_seq int not null default 1 check (next_seq >= 1),
  updated_at timestamptz not null default now(),
  unique nulls not distinct (project_id, document_type_id, discipline_id)
);
grant select, insert, update on public.numbering_schemes to authenticated;
grant all on public.numbering_schemes to service_role;
alter table public.numbering_schemes enable row level security;

-- ===== Documents =====
create table public.documents (
  id uuid primary key default gen_random_uuid(),
  company_id uuid not null references public.companies(id),
  project_id uuid not null references public.projects(id) on delete restrict,
  document_type_id uuid not null references public.document_types(id),
  discipline_id uuid references public.disciplines(id),
  doc_number text not null,
  title text not null check (length(btrim(title)) between 1 and 500),
  description text,
  location text,
  direction text check (direction in ('incoming','outgoing')),
  from_party text,
  to_party text,
  originator_party public.project_party not null default 'contractor',
  status public.doc_lifecycle not null default 'draft',
  current_response_code text,
  current_revision_id uuid,
  current_rev_label text not null default '00',
  current_rev_index int not null default 0,
  workflow_steps public.project_party[] not null default '{contractor,consultant}',
  current_step int not null default 1,
  requires_review boolean not null default true,
  uses_response_codes boolean not null default true,
  review_days int not null default 7,
  submitted_at timestamptz,
  due_date date,
  last_response_at timestamptz,
  closed_at timestamptz,
  legacy_ref text,
  source text not null default 'manual' check (source in ('manual','import')),
  import_batch_id uuid,
  metadata jsonb not null default '{}'::jsonb,
  created_by uuid not null default auth.uid(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (project_id, doc_number)
);
grant select, insert, update on public.documents to authenticated;
grant all on public.documents to service_role;
alter table public.documents enable row level security;
create index documents_project_type_idx on public.documents (project_id, document_type_id);
create index documents_project_status_idx on public.documents (project_id, status);
create index documents_project_disc_idx on public.documents (project_id, discipline_id);
create index documents_company_idx on public.documents (company_id);

create table public.document_revisions (
  id uuid primary key default gen_random_uuid(),
  document_id uuid not null references public.documents(id) on delete cascade,
  project_id uuid not null references public.projects(id),
  company_id uuid not null references public.companies(id),
  rev_index int not null check (rev_index >= 0),
  rev_label text not null check (length(btrim(rev_label)) between 1 and 20),
  change_note text,
  submitted_at timestamptz,
  response_code text,
  responded_at timestamptz,
  response_by uuid,
  response_notes text,
  source text not null default 'manual' check (source in ('manual','import')),
  created_by uuid not null default auth.uid(),
  created_at timestamptz not null default now(),
  unique (document_id, rev_index),
  unique (document_id, rev_label)
);
grant select, insert on public.document_revisions to authenticated;
grant all on public.document_revisions to service_role;
alter table public.document_revisions enable row level security;
create index document_revisions_project_idx on public.document_revisions (project_id);

alter table public.documents
  add constraint documents_current_revision_fk foreign key (current_revision_id)
  references public.document_revisions(id) deferrable initially deferred;

-- Workflow history (append-only)
create table public.document_reviews (
  id uuid primary key default gen_random_uuid(),
  document_id uuid not null references public.documents(id) on delete cascade,
  revision_id uuid references public.document_revisions(id),
  project_id uuid not null references public.projects(id),
  company_id uuid not null references public.companies(id),
  step int not null,
  party public.project_party,
  action text not null check (action in ('submit','start_review','respond','return','close')),
  from_status public.doc_lifecycle,
  to_status public.doc_lifecycle not null,
  response_code text,
  notes text,
  actor_id uuid not null,
  created_at timestamptz not null default now()
);
grant select on public.document_reviews to authenticated;
grant all on public.document_reviews to service_role;
alter table public.document_reviews enable row level security;
create index document_reviews_doc_idx on public.document_reviews (document_id, created_at);

create table public.attachments (
  id uuid primary key default gen_random_uuid(),
  document_id uuid not null references public.documents(id) on delete cascade,
  revision_id uuid references public.document_revisions(id),
  project_id uuid not null references public.projects(id),
  company_id uuid not null references public.companies(id),
  storage_path text not null unique,
  file_name text not null,
  mime_type text,
  size_bytes bigint,
  uploaded_by uuid not null default auth.uid(),
  created_at timestamptz not null default now()
);
grant select, insert on public.attachments to authenticated;
grant all on public.attachments to service_role;
alter table public.attachments enable row level security;
create index attachments_doc_idx on public.attachments (document_id);

create table public.comments (
  id uuid primary key default gen_random_uuid(),
  document_id uuid not null references public.documents(id) on delete cascade,
  revision_id uuid references public.document_revisions(id),
  project_id uuid not null references public.projects(id),
  company_id uuid not null references public.companies(id),
  body text not null check (length(btrim(body)) between 1 and 5000),
  visibility public.comment_visibility not null default 'internal',
  author_id uuid not null default auth.uid(),
  author_party public.project_party not null,
  created_at timestamptz not null default now()
);
grant select, insert on public.comments to authenticated;
grant all on public.comments to service_role;
alter table public.comments enable row level security;
create index comments_doc_idx on public.comments (document_id, created_at);

-- ===== Audit trail (append-only, written by triggers) =====
create table public.audit_log (
  id uuid primary key default gen_random_uuid(),
  company_id uuid,
  project_id uuid,
  document_id uuid,
  entity_type text not null,
  entity_id uuid,
  action text not null,
  actor_id uuid,
  changes jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);
grant select on public.audit_log to authenticated;
grant all on public.audit_log to service_role;
alter table public.audit_log enable row level security;
create index audit_log_project_idx on public.audit_log (project_id, created_at desc);
create index audit_log_document_idx on public.audit_log (document_id, created_at desc);

-- ===== Excel import staging =====
create table public.import_batches (
  id uuid primary key default gen_random_uuid(),
  project_id uuid not null references public.projects(id) on delete cascade,
  company_id uuid not null references public.companies(id) on delete cascade,
  document_type_id uuid references public.document_types(id),
  file_name text not null,
  sheet_name text not null,
  headers jsonb not null default '[]'::jsonb,
  status text not null default 'staged' check (status in ('staged','validated','committing','committed','cancelled')),
  column_mapping jsonb not null default '{}'::jsonb,
  value_mapping jsonb not null default '{}'::jsonb,
  total_rows int not null default 0,
  stats jsonb not null default '{}'::jsonb,
  created_by uuid not null default auth.uid(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
grant select, insert, update on public.import_batches to authenticated;
grant all on public.import_batches to service_role;
alter table public.import_batches enable row level security;

create table public.import_rows (
  id uuid primary key default gen_random_uuid(),
  batch_id uuid not null references public.import_batches(id) on delete cascade,
  project_id uuid not null references public.projects(id) on delete cascade,
  company_id uuid not null references public.companies(id) on delete cascade,
  row_number int not null,
  raw jsonb not null,
  mapped jsonb,
  validation_status text not null default 'pending' check (validation_status in ('pending','valid','warning','error','duplicate','conflict')),
  messages jsonb not null default '[]'::jsonb,
  decision text not null default 'pending' check (decision in ('pending','import','skip')),
  commit_status text check (commit_status in ('created','revision_added','skipped_existing','failed')),
  committed_document_id uuid references public.documents(id),
  committed_at timestamptz,
  unique (batch_id, row_number)
);
grant select, insert, update on public.import_rows to authenticated;
grant all on public.import_rows to service_role;
alter table public.import_rows enable row level security;
create index import_rows_batch_status_idx on public.import_rows (batch_id, validation_status);

-- ===== Future integration placeholders (not exposed as features) =====
create table public.integration_connections (
  id uuid primary key default gen_random_uuid(),
  company_id uuid not null references public.companies(id) on delete cascade,
  project_id uuid references public.projects(id) on delete cascade,
  provider text not null check (provider in ('onedrive')),
  status text not null default 'not_configured' check (status in ('not_configured','active','error','disabled')),
  config jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);
grant select on public.integration_connections to authenticated;
grant all on public.integration_connections to service_role;
alter table public.integration_connections enable row level security;

create table public.sync_jobs (
  id uuid primary key default gen_random_uuid(),
  company_id uuid not null references public.companies(id) on delete cascade,
  project_id uuid references public.projects(id) on delete cascade,
  connection_id uuid references public.integration_connections(id) on delete cascade,
  entity_type text not null,
  entity_id uuid,
  direction text not null check (direction in ('push','pull')),
  status text not null default 'queued' check (status in ('queued','running','succeeded','failed','conflict')),
  attempts int not null default 0,
  max_attempts int not null default 5,
  next_retry_at timestamptz,
  last_error text,
  conflict jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
grant select on public.sync_jobs to authenticated;
grant all on public.sync_jobs to service_role;
alter table public.sync_jobs enable row level security;

create table public.ocr_jobs (
  id uuid primary key default gen_random_uuid(),
  company_id uuid not null references public.companies(id) on delete cascade,
  project_id uuid not null references public.projects(id) on delete cascade,
  attachment_id uuid not null references public.attachments(id) on delete cascade,
  status text not null default 'queued' check (status in ('queued','processing','needs_review','approved','rejected','failed')),
  extracted jsonb,
  reviewed_by uuid,
  reviewed_at timestamptz,
  created_at timestamptz not null default now()
);
grant select on public.ocr_jobs to authenticated;
grant all on public.ocr_jobs to service_role;
alter table public.ocr_jobs enable row level security;

-- ===== Permission helpers (security definer, read-only) =====
create or replace function public.is_company_member(_company uuid)
returns boolean language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.company_members where company_id = _company and user_id = auth.uid())
$$;

create or replace function public.is_company_admin(_company uuid)
returns boolean language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.company_members where company_id = _company and user_id = auth.uid() and role in ('owner','admin'))
$$;

create or replace function public.project_role_of(_project uuid)
returns public.project_role language sql stable security definer set search_path = public as $$
  select coalesce(
    (select role from public.project_members where project_id = _project and user_id = auth.uid()),
    (select 'admin'::public.project_role from public.projects p
       join public.company_members cm on cm.company_id = p.company_id
      where p.id = _project and cm.user_id = auth.uid() and cm.role in ('owner','admin'))
  )
$$;

create or replace function public.project_party_of(_project uuid)
returns public.project_party language sql stable security definer set search_path = public as $$
  select party from public.project_members where project_id = _project and user_id = auth.uid()
$$;

create or replace function public.is_project_member(_project uuid)
returns boolean language sql stable security definer set search_path = public as $$
  select public.project_role_of(_project) is not null
$$;

create or replace function public.can_manage_project(_project uuid)
returns boolean language sql stable security definer set search_path = public as $$
  select public.project_role_of(_project) = 'admin'
$$;

create or replace function public.can_edit_documents(_project uuid)
returns boolean language sql stable security definer set search_path = public as $$
  select public.project_role_of(_project) in ('admin','controller')
$$;

create or replace function public.can_comment(_project uuid)
returns boolean language sql stable security definer set search_path = public as $$
  select public.project_role_of(_project) in ('admin','controller','reviewer')
$$;

create or replace function public.shares_scope_with(_other uuid)
returns boolean language sql stable security definer set search_path = public as $$
  select _other = auth.uid()
    or exists (select 1 from public.project_members a join public.project_members b on a.project_id = b.project_id
               where a.user_id = auth.uid() and b.user_id = _other)
    or exists (select 1 from public.company_members a join public.company_members b on a.company_id = b.company_id
               where a.user_id = auth.uid() and b.user_id = _other)
$$;

-- ===== RLS policies =====
create policy "profiles: read in shared scope" on public.profiles for select to authenticated using (public.shares_scope_with(id));
create policy "profiles: insert self" on public.profiles for insert to authenticated with check (id = auth.uid());
create policy "profiles: update self" on public.profiles for update to authenticated using (id = auth.uid()) with check (id = auth.uid());

create policy "companies: members read" on public.companies for select to authenticated using (public.is_company_member(id));
create policy "companies: admins update" on public.companies for update to authenticated using (public.is_company_admin(id)) with check (public.is_company_admin(id));

create policy "company_members: members read" on public.company_members for select to authenticated using (public.is_company_member(company_id));
create policy "company_members: admins insert" on public.company_members for insert to authenticated with check (public.is_company_admin(company_id) and role <> 'owner');
create policy "company_members: admins update" on public.company_members for update to authenticated using (public.is_company_admin(company_id) and role <> 'owner') with check (public.is_company_admin(company_id) and role <> 'owner');
create policy "company_members: admins delete" on public.company_members for delete to authenticated using (public.is_company_admin(company_id) and role <> 'owner');

create policy "projects: members read" on public.projects for select to authenticated using (public.is_project_member(id));
create policy "projects: admins update" on public.projects for update to authenticated using (public.can_manage_project(id)) with check (public.can_manage_project(id));

create policy "project_members: members read" on public.project_members for select to authenticated using (public.is_project_member(project_id));
create policy "project_members: admins insert" on public.project_members for insert to authenticated with check (public.can_manage_project(project_id));
create policy "project_members: admins update" on public.project_members for update to authenticated using (public.can_manage_project(project_id)) with check (public.can_manage_project(project_id));
create policy "project_members: admins delete" on public.project_members for delete to authenticated using (public.can_manage_project(project_id) and user_id <> auth.uid());

create policy "disciplines: read" on public.disciplines for select to authenticated using (true);
create policy "document_types: read" on public.document_types for select to authenticated using (true);

create policy "response_codes: members read" on public.project_response_codes for select to authenticated using (public.is_project_member(project_id));
create policy "response_codes: admins insert" on public.project_response_codes for insert to authenticated with check (public.can_manage_project(project_id));
create policy "response_codes: admins update" on public.project_response_codes for update to authenticated using (public.can_manage_project(project_id)) with check (public.can_manage_project(project_id));

create policy "workflows: members read" on public.project_workflows for select to authenticated using (public.is_project_member(project_id));
create policy "workflows: admins insert" on public.project_workflows for insert to authenticated with check (public.can_manage_project(project_id));
create policy "workflows: admins update" on public.project_workflows for update to authenticated using (public.can_manage_project(project_id)) with check (public.can_manage_project(project_id));

create policy "numbering: members read" on public.numbering_schemes for select to authenticated using (public.is_project_member(project_id));
create policy "numbering: admins insert" on public.numbering_schemes for insert to authenticated with check (public.can_manage_project(project_id));
create policy "numbering: admins update" on public.numbering_schemes for update to authenticated using (public.can_manage_project(project_id)) with check (public.can_manage_project(project_id));

create policy "documents: members read" on public.documents for select to authenticated using (public.is_project_member(project_id));
create policy "documents: editors insert" on public.documents for insert to authenticated with check (public.can_edit_documents(project_id));
create policy "documents: editors update" on public.documents for update to authenticated using (public.can_edit_documents(project_id)) with check (public.can_edit_documents(project_id));

create policy "revisions: members read" on public.document_revisions for select to authenticated using (public.is_project_member(project_id));
create policy "revisions: editors insert" on public.document_revisions for insert to authenticated with check (public.can_edit_documents(project_id));

create policy "reviews: members read" on public.document_reviews for select to authenticated using (public.is_project_member(project_id));

create policy "attachments: members read" on public.attachments for select to authenticated using (public.is_project_member(project_id));
create policy "attachments: contributors insert" on public.attachments for insert to authenticated with check (public.can_comment(project_id));

create policy "comments: read external or own party" on public.comments for select to authenticated
  using (public.is_project_member(project_id) and (visibility = 'external' or author_party = public.project_party_of(project_id)));
create policy "comments: contributors insert" on public.comments for insert to authenticated
  with check (public.can_comment(project_id) and author_id = auth.uid() and author_party = public.project_party_of(project_id));

create policy "audit: project members read" on public.audit_log for select to authenticated
  using ((project_id is not null and public.is_project_member(project_id)) or (project_id is null and company_id is not null and public.is_company_admin(company_id)));

create policy "import_batches: editors read" on public.import_batches for select to authenticated using (public.can_edit_documents(project_id));
create policy "import_batches: editors insert" on public.import_batches for insert to authenticated with check (public.can_edit_documents(project_id));
create policy "import_batches: editors update" on public.import_batches for update to authenticated using (public.can_edit_documents(project_id)) with check (public.can_edit_documents(project_id));

create policy "import_rows: editors read" on public.import_rows for select to authenticated using (public.can_edit_documents(project_id));
create policy "import_rows: editors insert" on public.import_rows for insert to authenticated with check (public.can_edit_documents(project_id));
create policy "import_rows: editors update" on public.import_rows for update to authenticated using (public.can_edit_documents(project_id)) with check (public.can_edit_documents(project_id));

create policy "integrations: company admins read" on public.integration_connections for select to authenticated using (public.is_company_admin(company_id));
create policy "sync_jobs: company admins read" on public.sync_jobs for select to authenticated using (public.is_company_admin(company_id));
create policy "ocr_jobs: project editors read" on public.ocr_jobs for select to authenticated using (public.can_edit_documents(project_id));

-- ===== Seed reference data =====
insert into public.disciplines (code, name_en, name_ar, sort) values
  ('ARC','Architectural','معماري',1),
  ('STR','Structural','إنشائي',2),
  ('MEC','Mechanical','ميكانيكي',3),
  ('ELE','Electrical','كهربائي',4),
  ('CIV','Civil','مدني',5);

insert into public.document_types (code, name_en, name_ar, category, uses_response_codes, requires_review, has_direction, sort) values
  ('WIR','Work Inspection Request','طلب فحص أعمال','inspection',true,true,false,1),
  ('RFI','Request for Inspection / Information','طلب فحص / استفسار','inspection',true,true,false,2),
  ('MIR','Material Inspection Request','طلب فحص مواد','inspection',true,true,false,3),
  ('LTR-IN','Incoming Letter','خطاب وارد','correspondence',false,false,true,4),
  ('LTR-OUT','Outgoing Letter','خطاب صادر','correspondence',false,false,true,5),
  ('DLR','Daily Report','التقرير اليومي','report',false,false,false,6),
  ('WPR','Weekly Progress Report','تقرير التقدم الأسبوعي','report',false,false,false,7),
  ('TRS','Test Results Submittal','تقديم نتائج الاختبارات','submittal',true,true,false,8),
  ('SOR','Site Observation Report','تقرير ملاحظات الموقع','quality',false,true,false,9),
  ('NCR','Non-Conformance Report','تقرير عدم مطابقة','quality',false,true,false,10),
  ('MQR','Material Quality Report','تقرير جودة المواد','quality',true,true,false,11),
  ('SNAG','Snag List','قائمة الملاحظات النهائية','quality',false,true,false,12);