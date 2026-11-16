-- Synthetic P0 fixtures for the disposable GitHub Actions PostgreSQL database only.
insert into auth.users(id,email,raw_user_meta_data) values
('00000000-0000-4000-8000-000000000010','p0-creator@sitedocs.test','{"full_name":"P0 Creator"}'),
('00000000-0000-4000-8000-000000000011','p0-peer@sitedocs.test','{"full_name":"P0 Originator Peer"}'),
('00000000-0000-4000-8000-000000000012','p0-wrong@sitedocs.test','{"full_name":"P0 Wrong Party"}'),
('00000000-0000-4000-8000-000000000013','p0-reviewer@sitedocs.test','{"full_name":"P0 Reviewer"}'),
('00000000-0000-4000-8000-000000000014','p0-pm@sitedocs.test','{"full_name":"P0 Project Manager"}'),
('00000000-0000-4000-8000-000000000015','p0-viewer@sitedocs.test','{"full_name":"P0 Viewer"}'),
('00000000-0000-4000-8000-000000000016','p0-company-admin@sitedocs.test','{"full_name":"P0 Company Admin"}'),
('00000000-0000-4000-8000-000000000017','p0-company-owner@sitedocs.test','{"full_name":"P0 Company Owner"}'),
('00000000-0000-4000-8000-000000000018','p0-other-tenant@sitedocs.test','{"full_name":"P0 Other Tenant"}');

insert into public.companies(id,name,code,created_by) values
('10000000-0000-4000-8000-000000000010','P0 Owner Company','P0OWN','00000000-0000-4000-8000-000000000010'),
('10000000-0000-4000-8000-000000000011','P0 Consultant Company','P0CON','00000000-0000-4000-8000-000000000013'),
('10000000-0000-4000-8000-000000000012','P0 PMC Company','P0PMC','00000000-0000-4000-8000-000000000012'),
('10000000-0000-4000-8000-000000000013','P0 Other Tenant Company','P0OTH','00000000-0000-4000-8000-000000000018');

insert into public.company_members(company_id,user_id,role) values
('10000000-0000-4000-8000-000000000010','00000000-0000-4000-8000-000000000010','admin'),
('10000000-0000-4000-8000-000000000010','00000000-0000-4000-8000-000000000011','member'),
('10000000-0000-4000-8000-000000000010','00000000-0000-4000-8000-000000000014','member'),
('10000000-0000-4000-8000-000000000010','00000000-0000-4000-8000-000000000015','member'),
('10000000-0000-4000-8000-000000000010','00000000-0000-4000-8000-000000000016','admin'),
('10000000-0000-4000-8000-000000000010','00000000-0000-4000-8000-000000000017','owner'),
('10000000-0000-4000-8000-000000000011','00000000-0000-4000-8000-000000000013','member'),
('10000000-0000-4000-8000-000000000012','00000000-0000-4000-8000-000000000012','member'),
('10000000-0000-4000-8000-000000000013','00000000-0000-4000-8000-000000000018','member');

insert into public.projects(id,company_id,code,name,created_by) values
('20000000-0000-4000-8000-000000000010','10000000-0000-4000-8000-000000000010','P0-SEC','P0 Security Acceptance','00000000-0000-4000-8000-000000000010'),
('20000000-0000-4000-8000-000000000011','10000000-0000-4000-8000-000000000013','P0-OTH','P0 Other Tenant Project','00000000-0000-4000-8000-000000000018');

insert into public.project_party_companies(project_id,project_company_id,participant_company_id,party,linked_by) values
('20000000-0000-4000-8000-000000000010','10000000-0000-4000-8000-000000000010','10000000-0000-4000-8000-000000000010','contractor','00000000-0000-4000-8000-000000000010'),
('20000000-0000-4000-8000-000000000010','10000000-0000-4000-8000-000000000010','10000000-0000-4000-8000-000000000011','consultant','00000000-0000-4000-8000-000000000010'),
('20000000-0000-4000-8000-000000000010','10000000-0000-4000-8000-000000000010','10000000-0000-4000-8000-000000000012','pmc','00000000-0000-4000-8000-000000000010'),
('20000000-0000-4000-8000-000000000011','10000000-0000-4000-8000-000000000013','10000000-0000-4000-8000-000000000013','contractor','00000000-0000-4000-8000-000000000018');

insert into public.project_members(project_id,company_id,participant_company_id,user_id,party,role,is_project_manager) values
('20000000-0000-4000-8000-000000000010','10000000-0000-4000-8000-000000000010','10000000-0000-4000-8000-000000000010','00000000-0000-4000-8000-000000000010','contractor','controller',false),
('20000000-0000-4000-8000-000000000010','10000000-0000-4000-8000-000000000010','10000000-0000-4000-8000-000000000010','00000000-0000-4000-8000-000000000011','contractor','controller',false),
('20000000-0000-4000-8000-000000000010','10000000-0000-4000-8000-000000000010','10000000-0000-4000-8000-000000000012','00000000-0000-4000-8000-000000000012','pmc','controller',false),
('20000000-0000-4000-8000-000000000010','10000000-0000-4000-8000-000000000010','10000000-0000-4000-8000-000000000011','00000000-0000-4000-8000-000000000013','consultant','reviewer',false),
('20000000-0000-4000-8000-000000000010','10000000-0000-4000-8000-000000000010','10000000-0000-4000-8000-000000000010','00000000-0000-4000-8000-000000000014','contractor','viewer',true),
('20000000-0000-4000-8000-000000000010','10000000-0000-4000-8000-000000000010','10000000-0000-4000-8000-000000000010','00000000-0000-4000-8000-000000000015','contractor','viewer',false),
('20000000-0000-4000-8000-000000000011','10000000-0000-4000-8000-000000000013','10000000-0000-4000-8000-000000000013','00000000-0000-4000-8000-000000000018','contractor','controller',false);

insert into public.project_workflows(project_id,company_id,document_type_id,steps,review_days,requires_review,uses_response_codes)
select '20000000-0000-4000-8000-000000000010','10000000-0000-4000-8000-000000000010',id,
       array['contractor','consultant']::public.project_party[],7,true,true
from public.document_types where code='WIR';

select set_config('request.jwt.claim.sub','00000000-0000-4000-8000-000000000010',false);
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

select set_config('request.jwt.claim.sub','00000000-0000-4000-8000-000000000010',false);
insert into public.comments(document_id,revision_id,project_id,company_id,body,visibility)
select id,current_revision_id,project_id,company_id,'Synthetic private draft comment','internal'
from public.documents where id='30000000-0000-4000-8000-000000000010';
insert into public.document_reviews(document_id,revision_id,project_id,company_id,step,party,action,from_status,to_status,actor_id)
select id,current_revision_id,project_id,company_id,1,'contractor','submit','draft','submitted','00000000-0000-4000-8000-000000000010'
from public.documents where id='30000000-0000-4000-8000-000000000010';

insert into public.attachments(id,document_id,revision_id,project_id,company_id,storage_path,file_name,mime_type,size_bytes,uploaded_by)
select '40000000-0000-4000-8000-000000000010',id,current_revision_id,project_id,company_id,
'20000000-0000-4000-8000-000000000010/30000000-0000-4000-8000-000000000010/draft.pdf','draft.pdf','application/pdf',128,'00000000-0000-4000-8000-000000000010'
from public.documents where id='30000000-0000-4000-8000-000000000010';
insert into storage.objects(bucket_id,name) values
('document-files','20000000-0000-4000-8000-000000000010/30000000-0000-4000-8000-000000000010/draft.pdf');
insert into public.ocr_jobs(id,company_id,project_id,attachment_id,status,extracted) values
('50000000-0000-4000-8000-000000000010','10000000-0000-4000-8000-000000000010','20000000-0000-4000-8000-000000000010','40000000-0000-4000-8000-000000000010','needs_review','{"text":"synthetic OCR content","page_count":1}');

select set_config('request.jwt.claim.sub','00000000-0000-4000-8000-000000000011',false);
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
