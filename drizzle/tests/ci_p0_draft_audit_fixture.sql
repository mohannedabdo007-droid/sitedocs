-- Synthetic P0 fixtures for disposable PostgreSQL and local Supabase API acceptance only.
create schema if not exists extensions;
set search_path = public, extensions;
insert into auth.users(id,email,encrypted_password,email_confirmed_at,raw_user_meta_data) values
(:'creator_user_id','p0-creator@sitedocs.test',crypt('P0-Test-Password!',gen_salt('bf')),now(),'{"full_name":"P0 Creator"}'),
(:'originator_peer_user_id','p0-peer@sitedocs.test',crypt('P0-Test-Password!',gen_salt('bf')),now(),'{"full_name":"P0 Originator Peer"}'),
(:'wrong_party_user_id','p0-wrong@sitedocs.test',crypt('P0-Test-Password!',gen_salt('bf')),now(),'{"full_name":"P0 Wrong Party"}'),
(:'current_reviewer_user_id','p0-reviewer@sitedocs.test',crypt('P0-Test-Password!',gen_salt('bf')),now(),'{"full_name":"P0 Reviewer"}'),
(:'project_manager_user_id','p0-pm@sitedocs.test',crypt('P0-Test-Password!',gen_salt('bf')),now(),'{"full_name":"P0 Project Manager"}'),
(:'viewer_not_pm_user_id','p0-viewer@sitedocs.test',crypt('P0-Test-Password!',gen_salt('bf')),now(),'{"full_name":"P0 Viewer"}'),
(:'company_admin_user_id','p0-company-admin@sitedocs.test',crypt('P0-Test-Password!',gen_salt('bf')),now(),'{"full_name":"P0 Company Admin"}'),
(:'company_owner_user_id','p0-company-owner@sitedocs.test',crypt('P0-Test-Password!',gen_salt('bf')),now(),'{"full_name":"P0 Company Owner"}'),
(:'other_tenant_user_id','p0-other-tenant@sitedocs.test',crypt('P0-Test-Password!',gen_salt('bf')),now(),'{"full_name":"P0 Other Tenant"}')
on conflict (email) do nothing;

-- Supabase GoTrue requires an email identity and provider metadata for password sign-in.
update auth.users
   set raw_app_meta_data = jsonb_build_object('provider','email','providers',jsonb_build_array('email'))
 where email like 'p0-%@sitedocs.test';

insert into auth.identities(provider_id,user_id,identity_data,provider,created_at,updated_at)
select u.id::text,u.id,
       jsonb_build_object('sub',u.id::text,'email',u.email,'email_verified',true),
       'email',now(),now()
  from auth.users u
 where u.email like 'p0-%@sitedocs.test'
on conflict (provider_id,provider) do nothing;

insert into public.companies(id,name,code,created_by) values
('10000000-0000-4000-8000-000000000010','P0 Owner Company','P0OWN',:'creator_user_id'),
('10000000-0000-4000-8000-000000000011','P0 Consultant Company','P0CON',:'current_reviewer_user_id'),
('10000000-0000-4000-8000-000000000012','P0 PMC Company','P0PMC',:'wrong_party_user_id'),
('10000000-0000-4000-8000-000000000013','P0 Other Tenant Company','P0OTH',:'other_tenant_user_id');

insert into public.company_members(company_id,user_id,role) values
('10000000-0000-4000-8000-000000000010',:'creator_user_id','admin'),
('10000000-0000-4000-8000-000000000010',:'originator_peer_user_id','member'),
('10000000-0000-4000-8000-000000000010',:'project_manager_user_id','member'),
('10000000-0000-4000-8000-000000000011',:'viewer_not_pm_user_id','member'),
('10000000-0000-4000-8000-000000000010',:'company_admin_user_id','admin'),
('10000000-0000-4000-8000-000000000010',:'company_owner_user_id','owner'),
('10000000-0000-4000-8000-000000000011',:'current_reviewer_user_id','member'),
('10000000-0000-4000-8000-000000000012',:'wrong_party_user_id','member'),
('10000000-0000-4000-8000-000000000013',:'other_tenant_user_id','member');

insert into public.projects(id,company_id,code,name,created_by) values
('20000000-0000-4000-8000-000000000010','10000000-0000-4000-8000-000000000010','P0-SEC','P0 Security Acceptance',:'creator_user_id'),
('20000000-0000-4000-8000-000000000011','10000000-0000-4000-8000-000000000013','P0-OTH','P0 Other Tenant Project',:'other_tenant_user_id');

insert into public.project_party_companies(project_id,project_company_id,participant_company_id,party,linked_by) values
('20000000-0000-4000-8000-000000000010','10000000-0000-4000-8000-000000000010','10000000-0000-4000-8000-000000000010','contractor',:'creator_user_id'),
('20000000-0000-4000-8000-000000000010','10000000-0000-4000-8000-000000000010','10000000-0000-4000-8000-000000000011','consultant',:'creator_user_id'),
('20000000-0000-4000-8000-000000000010','10000000-0000-4000-8000-000000000010','10000000-0000-4000-8000-000000000012','pmc',:'creator_user_id'),
('20000000-0000-4000-8000-000000000011','10000000-0000-4000-8000-000000000013','10000000-0000-4000-8000-000000000013','contractor',:'other_tenant_user_id');

insert into public.project_members(project_id,company_id,participant_company_id,user_id,party,role,is_project_manager) values
('20000000-0000-4000-8000-000000000010','10000000-0000-4000-8000-000000000010','10000000-0000-4000-8000-000000000010',:'creator_user_id','contractor','controller',false),
('20000000-0000-4000-8000-000000000010','10000000-0000-4000-8000-000000000010','10000000-0000-4000-8000-000000000010',:'originator_peer_user_id','contractor','controller',false),
('20000000-0000-4000-8000-000000000010','10000000-0000-4000-8000-000000000010','10000000-0000-4000-8000-000000000012',:'wrong_party_user_id','pmc','controller',false),
('20000000-0000-4000-8000-000000000010','10000000-0000-4000-8000-000000000010','10000000-0000-4000-8000-000000000011',:'current_reviewer_user_id','consultant','reviewer',false),
('20000000-0000-4000-8000-000000000010','10000000-0000-4000-8000-000000000010','10000000-0000-4000-8000-000000000010',:'project_manager_user_id','contractor','viewer',true),
('20000000-0000-4000-8000-000000000010','10000000-0000-4000-8000-000000000010','10000000-0000-4000-8000-000000000011',:'viewer_not_pm_user_id','consultant','viewer',false),
('20000000-0000-4000-8000-000000000011','10000000-0000-4000-8000-000000000013','10000000-0000-4000-8000-000000000013',:'other_tenant_user_id','contractor','controller',false);

insert into public.project_workflows(project_id,company_id,document_type_id,steps,review_days,requires_review,uses_response_codes)
select '20000000-0000-4000-8000-000000000010','10000000-0000-4000-8000-000000000010',id,
       array['contractor','consultant']::public.project_party[],7,true,true
from public.document_types where code='WIR';

select set_config('request.jwt.claim.sub',:'creator_user_id',false);
insert into public.documents(id,company_id,project_id,document_type_id,doc_number,title)
select '30000000-0000-4000-8000-000000000010','10000000-0000-4000-8000-000000000010','20000000-0000-4000-8000-000000000010',id,'P0-DRAFT','P0 synthetic protected draft'
from public.document_types where code='WIR';
insert into public.documents(id,company_id,project_id,document_type_id,doc_number,title)
select '30000000-0000-4000-8000-000000000011','10000000-0000-4000-8000-000000000010','20000000-0000-4000-8000-000000000010',id,'P0-SUBMITTED','P0 synthetic submitted document'
from public.document_types where code='WIR';
insert into public.documents(id,company_id,project_id,document_type_id,doc_number,title)
select '30000000-0000-4000-8000-000000000012','10000000-0000-4000-8000-000000000010','20000000-0000-4000-8000-000000000010',id,'P0-SELF','P0 synthetic self-review document'
from public.document_types where code='WIR';

select set_config('app.doc_transition','on',false);
update public.documents set status='submitted',current_step=2,submitted_at=now()
where id='30000000-0000-4000-8000-000000000011';
update public.documents set status='submitted',workflow_steps=array['contractor','contractor']::public.project_party[],current_step=2,submitted_at=now()
where id='30000000-0000-4000-8000-000000000012';
update public.document_revisions set submitted_at=now()
where document_id in ('30000000-0000-4000-8000-000000000011','30000000-0000-4000-8000-000000000012');
select set_config('app.doc_transition','',false);

select set_config('request.jwt.claim.sub',:'creator_user_id',false);
insert into public.comments(document_id,revision_id,project_id,company_id,body,visibility)
select id,current_revision_id,project_id,company_id,'Synthetic private draft comment','internal'
from public.documents where id='30000000-0000-4000-8000-000000000010';
insert into public.document_reviews(document_id,revision_id,project_id,company_id,step,party,action,from_status,to_status,actor_id)
select id,current_revision_id,project_id,company_id,1,'contractor','submit','draft','submitted',:'creator_user_id'
from public.documents where id='30000000-0000-4000-8000-000000000010';

insert into public.attachments(id,document_id,revision_id,project_id,company_id,storage_path,file_name,mime_type,size_bytes,uploaded_by)
select '40000000-0000-4000-8000-000000000010',id,current_revision_id,project_id,company_id,
'20000000-0000-4000-8000-000000000010/30000000-0000-4000-8000-000000000010/draft.pdf','draft.pdf','application/pdf',128,:'creator_user_id'
from public.documents where id='30000000-0000-4000-8000-000000000010';
insert into public.attachments(id,document_id,revision_id,project_id,company_id,storage_path,file_name,mime_type,size_bytes,uploaded_by)
select x.id,d.id,d.current_revision_id,d.project_id,d.company_id,x.path,x.file_name,'application/pdf',64,:'creator_user_id'
from public.documents d
cross join (values
 ('40000000-0000-4000-8000-000000000011'::uuid,'20000000-0000-4000-8000-000000000010/30000000-0000-4000-8000-000000000010/creator-upload.pdf'::text,'creator-upload.pdf'::text),
 ('40000000-0000-4000-8000-000000000012'::uuid,'20000000-0000-4000-8000-000000000010/30000000-0000-4000-8000-000000000010/other-party-upload.pdf'::text,'other-party-upload.pdf'::text),
 ('40000000-0000-4000-8000-000000000013'::uuid,'20000000-0000-4000-8000-000000000010/30000000-0000-4000-8000-000000000010/pm-upload.pdf'::text,'pm-upload.pdf'::text),
 ('40000000-0000-4000-8000-000000000014'::uuid,'20000000-0000-4000-8000-000000000010/30000000-0000-4000-8000-000000000010/api-seeded.pdf'::text,'api-seeded.pdf'::text)
) as x(id,path,file_name)
where d.id='30000000-0000-4000-8000-000000000010';
insert into storage.objects(bucket_id,name) values
('document-files','20000000-0000-4000-8000-000000000010/30000000-0000-4000-8000-000000000010/draft.pdf');
insert into public.ocr_jobs(id,company_id,project_id,attachment_id,status,extracted) values
('50000000-0000-4000-8000-000000000010','10000000-0000-4000-8000-000000000010','20000000-0000-4000-8000-000000000010','40000000-0000-4000-8000-000000000010','needs_review','{"text":"synthetic OCR content","page_count":1}');

select set_config('request.jwt.claim.sub',:'originator_peer_user_id',false);
insert into public.import_batches(id,project_id,company_id,document_type_id,file_name,sheet_name,headers,total_rows)
select '60000000-0000-4000-8000-000000000010','20000000-0000-4000-8000-000000000010','10000000-0000-4000-8000-000000000010',id,'synthetic-import.xlsx','Sheet1','["Document No","Title"]'::jsonb,1
from public.document_types where code='WIR';
insert into public.import_rows(batch_id,row_number,raw,mapped) values
('60000000-0000-4000-8000-000000000010',1,'{"Document No":"P0-RAW-001","Secret":"synthetic raw value"}'::jsonb,'{"doc_number":"P0-RAW-001","title":"Synthetic import row"}'::jsonb);

insert into public.audit_log(company_id,project_id,document_id,entity_type,entity_id,action,actor_id,changes)
select company_id,project_id,id,'documents',id,'fixture_insert',created_by,jsonb_build_object('title',title)
from public.documents where id='30000000-0000-4000-8000-000000000010'
and not exists(select 1 from public.audit_log a where a.document_id='30000000-0000-4000-8000-000000000010');
insert into public.audit_log(company_id,project_id,entity_type,entity_id,action,actor_id,changes)
select company_id,project_id,'import_batches',id,'fixture_insert',created_by,'{"status":"staged","total_rows":1}'::jsonb
from public.import_batches where id='60000000-0000-4000-8000-000000000010'
and not exists(select 1 from public.audit_log a where a.entity_type='import_batches' and a.entity_id='60000000-0000-4000-8000-000000000010');
