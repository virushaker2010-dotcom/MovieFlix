-- MovieFlix V2: نفّذ هذا الملف داخل Supabase SQL Editor.
create extension if not exists pgcrypto;

create table if not exists public.contents (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  description text default '',
  type text not null check (type in ('movie','series')),
  year int,
  rating numeric(3,1) default 0,
  genre text default '',
  poster_url text,
  video_url text,
  published boolean default true,
  created_at timestamptz default now()
);

create table if not exists public.episodes (
  id uuid primary key default gen_random_uuid(),
  content_id uuid not null references public.contents(id) on delete cascade,
  episode_number int not null,
  title text default '',
  video_url text,
  created_at timestamptz default now()
);

create table if not exists public.favorites (
  user_id uuid not null references auth.users(id) on delete cascade,
  content_id uuid not null references public.contents(id) on delete cascade,
  created_at timestamptz default now(),
  primary key(user_id,content_id)
);

alter table public.contents enable row level security;
alter table public.episodes enable row level security;
alter table public.favorites enable row level security;

create policy "public can read published content" on public.contents for select using (published=true or auth.uid() is not null);
create policy "public can read episodes" on public.episodes for select using (true);
create policy "users manage own favorites" on public.favorites for all using (auth.uid()=user_id) with check (auth.uid()=user_id);

-- التخزين: أنشئ Bucket باسم posters وBucket باسم videos من Storage.
-- اجعل posters وvideos Public إذا أردت تشغيل الروابط المباشرة من التطبيق.
-- لإنتاج أكثر أمانًا، استخدم Private Buckets + Signed URLs لاحقًا.

-- ملاحظة مهمة:
-- صلاحيات INSERT/UPDATE/DELETE للمحتوى هنا ليست مفتوحة للمستخدمين.
-- حتى تضيف مديرًا حقيقيًا، الأفضل لاحقًا إنشاء role/profile خاص بالمدير
-- ثم كتابة RLS policies تعتمد على user_roles. لا تستخدم service_role key داخل التطبيق.
