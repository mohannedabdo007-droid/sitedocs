-- Deterministic, disposable fixtures for company invitation / JV acceptance tests.
-- This file is intended ONLY for the ephemeral CI PostgreSQL service.
insert into auth.users (id, email, email_confirmed_at, raw_user_meta_data) values
 ('00000000-0000-4000-8000-000000000001','owner-admin@sitedocs.test',now(),'{"full_name":"Owner Admin"}'),
 ('00000000-0000-4000-8000-000000000002','external-admin@sitedocs.test',now(),'{"full_name":"External Admin"}'),
 ('00000000-0000-4000-8000-000000000003','external-member@sitedocs.test',now(),'{"full_name":"External Member"}'),
 ('00000000-0000-4000-8000-000000000004','jv-admin@sitedocs.test',now(),'{"full_name":"JV Admin"}'),
 ('00000000-0000-4000-8000-000000000005','jv-member@sitedocs.test',now(),'{"full_name":"JV Member"}');

insert into public.companies (id, name, code, created_by) values
 ('10000000-0000-4000-8000-000000000001','Owner Company','OWNER','00000000-0000-4000-8000-000000000001'),
 ('10000000-0000-4000-8000-000000000002','External Company','EXT','00000000-0000-4000-8000-000000000002'),
 ('10000000-0000-4000-8000-000000000003','JV Company Alpha','JVCO','00000000-0000-4000-8000-000000000004');

insert into public.company_members (company_id, user_id, role) values
 ('10000000-0000-4000-8000-000000000001','00000000-0000-4000-8000-000000000001','admin'),
 ('10000000-0000-4000-8000-000000000002','00000000-0000-4000-8000-000000000002','admin'),
 ('10000000-0000-4000-8000-000000000002','00000000-0000-4000-8000-000000000003','member'),
 ('10000000-0000-4000-8000-000000000003','00000000-0000-4000-8000-000000000004','admin'),
 ('10000000-0000-4000-8000-000000000003','00000000-0000-4000-8000-000000000005','member');

insert into public.projects (id, company_id, code, name, created_by)
values ('20000000-0000-4000-8000-000000000001',
        '10000000-0000-4000-8000-000000000001',
        'CI-JV','SiteDocs CI JV Acceptance',
        '00000000-0000-4000-8000-000000000001');

insert into public.project_party_companies
 (project_id, project_company_id, participant_company_id, party, linked_by)
values ('20000000-0000-4000-8000-000000000001',
        '10000000-0000-4000-8000-000000000001',
        '10000000-0000-4000-8000-000000000001',
        'contractor','00000000-0000-4000-8000-000000000001');

insert into public.project_members
 (project_id, company_id, user_id, party, role)
values ('20000000-0000-4000-8000-000000000001',
        '10000000-0000-4000-8000-000000000001',
        '00000000-0000-4000-8000-000000000001',
        'contractor','admin');
