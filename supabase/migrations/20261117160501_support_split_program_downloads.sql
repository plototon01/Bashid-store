alter table public.programs
add column file_parts integer not null default 1 check (file_parts between 1 and 12);
