create table public.programs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null check (char_length(name) between 1 and 100),
  description text not null check (char_length(description) between 1 and 1000),
  category text not null,
  platform text not null default '',
  website_url text not null default '',
  file_path text not null,
  original_file_name text not null,
  cover_path text,
  video_url text,
  created_at timestamptz not null default now()
);

alter table public.programs enable row level security;
grant select, insert on public.programs to anon, authenticated;
create policy "Anyone can view programs" on public.programs for select using (true);
create policy "Signed-in users can add their programs" on public.programs for insert to authenticated with check (auth.uid() = user_id);

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values
  ('program-files', 'program-files', true, 1073741824, null),
  ('program-media', 'program-media', true, 52428800, array['image/jpeg','image/png','image/webp','image/gif','video/mp4','video/webm'])
on conflict (id) do update set
  public = excluded.public,
  file_size_limit = excluded.file_size_limit,
  allowed_mime_types = excluded.allowed_mime_types;

create policy "Public can download program files" on storage.objects
for select using (bucket_id in ('program-files', 'program-media'));
create policy "Signed-in users upload their files" on storage.objects
for insert to authenticated
with check (bucket_id in ('program-files', 'program-media') and (storage.foldername(name))[1] = (select auth.uid())::text);
