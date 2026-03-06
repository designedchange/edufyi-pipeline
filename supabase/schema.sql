-- EDU.FYI Customer Pipeline — Supabase Schema
-- Run this in Supabase SQL Editor (Dashboard > SQL Editor > New Query)

-- ============================================
-- 1. DEALS
-- ============================================
CREATE TABLE IF NOT EXISTS deals (
  id TEXT PRIMARY KEY,
  org TEXT NOT NULL,
  type TEXT DEFAULT 'Education',
  description TEXT DEFAULT '',
  stage TEXT DEFAULT 'Awareness',
  priority TEXT DEFAULT 'High',
  owner TEXT DEFAULT '',
  contact TEXT DEFAULT '',
  next_step TEXT DEFAULT '',
  next_date TEXT DEFAULT '',
  products JSONB DEFAULT '[]'::jsonb,
  notes TEXT DEFAULT '',
  learners INTEGER DEFAULT 0,
  fyi_link TEXT DEFAULT '',
  deal_structure TEXT DEFAULT 'Per-Student',
  deal_value NUMERIC DEFAULT 0,
  activity JSONB DEFAULT '[]'::jsonb,
  attachments JSONB DEFAULT '[]'::jsonb,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- ============================================
-- 2. COMMS
-- ============================================
CREATE TABLE IF NOT EXISTS comms (
  id TEXT PRIMARY KEY,
  type TEXT DEFAULT 'Email',
  deal_id TEXT DEFAULT '',
  people TEXT DEFAULT '',
  subject TEXT DEFAULT '',
  direction TEXT DEFAULT 'Outbound',
  date TEXT DEFAULT '',
  fyi_link TEXT DEFAULT '',
  summary TEXT DEFAULT '',
  followup TEXT DEFAULT '',
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- ============================================
-- 3. PEOPLE
-- ============================================
CREATE TABLE IF NOT EXISTS people (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  role TEXT DEFAULT '',
  org TEXT DEFAULT '',
  email TEXT DEFAULT '',
  phone TEXT DEFAULT '',
  notes TEXT DEFAULT '',
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- ============================================
-- 4. TASKS
-- ============================================
CREATE TABLE IF NOT EXISTS tasks (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  deal_id TEXT DEFAULT '',
  owner TEXT DEFAULT '',
  due TEXT DEFAULT '',
  priority TEXT DEFAULT 'Medium',
  status TEXT DEFAULT 'To Do',
  notes TEXT DEFAULT '',
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- ============================================
-- 5. EVENTS
-- ============================================
CREATE TABLE IF NOT EXISTS events (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  date TEXT DEFAULT '',
  end_date TEXT DEFAULT '',
  location TEXT DEFAULT '',
  notes TEXT DEFAULT '',
  partners JSONB DEFAULT '[]'::jsonb,
  pitch_plan TEXT DEFAULT '',
  followups JSONB DEFAULT '[]'::jsonb,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- ============================================
-- 6. ASSETS
-- ============================================
CREATE TABLE IF NOT EXISTS assets (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  type TEXT DEFAULT 'Pitch Deck',
  audience TEXT DEFAULT '',
  link TEXT DEFAULT '',
  deal_id TEXT DEFAULT '',
  notes TEXT DEFAULT '',
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- ============================================
-- 7. TEMPLATES
-- ============================================
CREATE TABLE IF NOT EXISTS templates (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  stage TEXT DEFAULT '',
  type TEXT DEFAULT '',
  subject TEXT DEFAULT '',
  body TEXT DEFAULT '',
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- ============================================
-- 8. SCENARIOS (Deal Economics)
-- ============================================
CREATE TABLE IF NOT EXISTS scenarios (
  id TEXT PRIMARY KEY,
  name TEXT DEFAULT '',
  date TEXT DEFAULT '',
  partner TEXT DEFAULT '',
  product TEXT DEFAULT 'EDU.FYI',
  learners INTEGER DEFAULT 0,
  rev_per_learner NUMERIC DEFAULT 0,
  impl_fee NUMERIC DEFAULT 0,
  rev_share NUMERIC DEFAULT 0,
  growth NUMERIC DEFAULT 25,
  years INTEGER DEFAULT 3,
  platform_cost NUMERIC DEFAULT 0,
  content_cost NUMERIC DEFAULT 0,
  support_cost NUMERIC DEFAULT 0,
  sales_cost NUMERIC DEFAULT 0,
  dev_cost NUMERIC DEFAULT 0,
  overhead NUMERIC DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- ============================================
-- Auto-update updated_at on all tables
-- ============================================
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DO $$
DECLARE
  tbl TEXT;
BEGIN
  FOR tbl IN SELECT unnest(ARRAY['deals','comms','people','tasks','events','assets','templates','scenarios'])
  LOOP
    EXECUTE format('DROP TRIGGER IF EXISTS set_updated_at ON %I', tbl);
    EXECUTE format('CREATE TRIGGER set_updated_at BEFORE UPDATE ON %I FOR EACH ROW EXECUTE FUNCTION update_updated_at()', tbl);
  END LOOP;
END;
$$;

-- ============================================
-- Row-Level Security (disabled for now — single user via API key)
-- Enable later when adding team access
-- ============================================
ALTER TABLE deals ENABLE ROW LEVEL SECURITY;
ALTER TABLE comms ENABLE ROW LEVEL SECURITY;
ALTER TABLE people ENABLE ROW LEVEL SECURITY;
ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;
ALTER TABLE events ENABLE ROW LEVEL SECURITY;
ALTER TABLE assets ENABLE ROW LEVEL SECURITY;
ALTER TABLE templates ENABLE ROW LEVEL SECURITY;
ALTER TABLE scenarios ENABLE ROW LEVEL SECURITY;

-- Allow service role full access (API routes use service key)
CREATE POLICY "Service role full access" ON deals FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Service role full access" ON comms FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Service role full access" ON people FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Service role full access" ON tasks FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Service role full access" ON events FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Service role full access" ON assets FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Service role full access" ON templates FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Service role full access" ON scenarios FOR ALL USING (true) WITH CHECK (true);
