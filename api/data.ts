import type { VercelRequest, VercelResponse } from '@vercel/node';
import { createClient } from '@supabase/supabase-js';

const supabase = createClient(
  process.env.SUPABASE_URL || '',
  process.env.SUPABASE_SERVICE_KEY || ''
);

// Simple token validation (shared with auth.ts via header check)
function isAuthorized(req: VercelRequest): boolean {
  const auth = req.headers.authorization;
  if (!auth || !auth.startsWith('Bearer ')) return false;
  const token = auth.slice(7);
  // For simplicity, we validate tokens exist (non-empty)
  // In production, use JWT verification
  return token.length > 0;
}

// Table name mapping: frontend key → Supabase table
const TABLES = ['deals', 'comms', 'people', 'tasks', 'events', 'assets', 'templates'] as const;

// Map frontend field names to DB column names
function toDB(table: string, row: any): any {
  const mapped: any = { ...row };
  if (table === 'deals') {
    if ('desc' in mapped) { mapped.description = mapped.desc; delete mapped.desc; }
    if ('nextStep' in mapped) { mapped.next_step = mapped.nextStep; delete mapped.nextStep; }
    if ('nextDate' in mapped) { mapped.next_date = mapped.nextDate; delete mapped.nextDate; }
    if ('fyiLink' in mapped) { mapped.fyi_link = mapped.fyiLink; delete mapped.fyiLink; }
  }
  if (table === 'comms') {
    if ('deal' in mapped) { mapped.deal_id = mapped.deal; delete mapped.deal; }
    if ('fyiLink' in mapped) { mapped.fyi_link = mapped.fyiLink; delete mapped.fyiLink; }
  }
  if (table === 'tasks') {
    if ('deal' in mapped) { mapped.deal_id = mapped.deal; delete mapped.deal; }
  }
  if (table === 'events') {
    if ('endDate' in mapped) { mapped.end_date = mapped.endDate; delete mapped.endDate; }
    if ('pitchPlan' in mapped) { mapped.pitch_plan = mapped.pitchPlan; delete mapped.pitchPlan; }
  }
  if (table === 'assets') {
    if ('deal' in mapped) { mapped.deal_id = mapped.deal; delete mapped.deal; }
  }
  // Remove any fields not in DB
  delete mapped.created_at;
  delete mapped.updated_at;
  return mapped;
}

// Map DB column names back to frontend field names
function toFrontend(table: string, row: any): any {
  const mapped: any = { ...row };
  delete mapped.created_at;
  delete mapped.updated_at;
  if (table === 'deals') {
    if ('description' in mapped) { mapped.desc = mapped.description; delete mapped.description; }
    if ('next_step' in mapped) { mapped.nextStep = mapped.next_step; delete mapped.next_step; }
    if ('next_date' in mapped) { mapped.nextDate = mapped.next_date; delete mapped.next_date; }
    if ('fyi_link' in mapped) { mapped.fyiLink = mapped.fyi_link; delete mapped.fyi_link; }
  }
  if (table === 'comms') {
    if ('deal_id' in mapped) { mapped.deal = mapped.deal_id; delete mapped.deal_id; }
    if ('fyi_link' in mapped) { mapped.fyiLink = mapped.fyi_link; delete mapped.fyi_link; }
  }
  if (table === 'tasks') {
    if ('deal_id' in mapped) { mapped.deal = mapped.deal_id; delete mapped.deal_id; }
  }
  if (table === 'events') {
    if ('end_date' in mapped) { mapped.endDate = mapped.end_date; delete mapped.end_date; }
    if ('pitch_plan' in mapped) { mapped.pitchPlan = mapped.pitch_plan; delete mapped.pitch_plan; }
  }
  if (table === 'assets') {
    if ('deal_id' in mapped) { mapped.deal = mapped.deal_id; delete mapped.deal_id; }
  }
  return mapped;
}

// Scenario field mapping
function scenarioToDB(s: any): any {
  return {
    id: s.id, name: s.name, date: s.date, partner: s.partner, product: s.product,
    learners: s.learners, rev_per_learner: s.revPerLearner, impl_fee: s.implFee,
    rev_share: s.revShare, growth: s.growth, years: s.years,
    platform_cost: s.platformCost, content_cost: s.contentCost, support_cost: s.supportCost,
    sales_cost: s.salesCost, dev_cost: s.devCost, overhead: s.overhead
  };
}

function scenarioToFrontend(s: any): any {
  return {
    id: s.id, name: s.name, date: s.date, partner: s.partner, product: s.product,
    learners: s.learners, revPerLearner: s.rev_per_learner, implFee: s.impl_fee,
    revShare: s.rev_share, growth: s.growth, years: s.years,
    platformCost: s.platform_cost, contentCost: s.content_cost, supportCost: s.support_cost,
    salesCost: s.sales_cost, devCost: s.dev_cost, overhead: s.overhead
  };
}

export default async function handler(req: VercelRequest, res: VercelResponse) {
  if (req.method === 'OPTIONS') return res.status(200).end();

  if (!isAuthorized(req)) {
    return res.status(401).json({ error: 'Unauthorized' });
  }

  // GET — Load all data
  if (req.method === 'GET') {
    try {
      const [deals, comms, people, tasks, events, assets, templates, scenarios] = await Promise.all([
        supabase.from('deals').select('*').order('created_at'),
        supabase.from('comms').select('*').order('created_at'),
        supabase.from('people').select('*').order('created_at'),
        supabase.from('tasks').select('*').order('created_at'),
        supabase.from('events').select('*').order('created_at'),
        supabase.from('assets').select('*').order('created_at'),
        supabase.from('templates').select('*').order('created_at'),
        supabase.from('scenarios').select('*').order('created_at'),
      ]);

      // Check for errors
      for (const result of [deals, comms, people, tasks, events, assets, templates, scenarios]) {
        if (result.error) {
          return res.status(500).json({ error: result.error.message });
        }
      }

      return res.status(200).json({
        deals: (deals.data || []).map(r => toFrontend('deals', r)),
        comms: (comms.data || []).map(r => toFrontend('comms', r)),
        people: (people.data || []).map(r => toFrontend('people', r)),
        tasks: (tasks.data || []).map(r => toFrontend('tasks', r)),
        events: (events.data || []).map(r => toFrontend('events', r)),
        assets: (assets.data || []).map(r => toFrontend('assets', r)),
        templates: (templates.data || []).map(r => toFrontend('templates', r)),
        scenarios: (scenarios.data || []).map(r => scenarioToFrontend(r)),
      });
    } catch (err: any) {
      return res.status(500).json({ error: err.message });
    }
  }

  // POST — Save all data (full sync)
  if (req.method === 'POST') {
    try {
      const data = req.body;
      if (!data) return res.status(400).json({ error: 'No data provided' });

      // For each table: delete all, then insert all (simple full-replace strategy)
      // This is fine for single user with small dataset
      for (const table of TABLES) {
        if (data[table]) {
          await supabase.from(table).delete().gte('created_at', '1970-01-01');
          const rows = data[table].map((r: any) => toDB(table, r));
          if (rows.length > 0) {
            const { error } = await supabase.from(table).insert(rows);
            if (error) {
              console.error(`Error inserting ${table}:`, error);
              return res.status(500).json({ error: `Failed to save ${table}: ${error.message}` });
            }
          }
        }
      }

      // Handle scenarios separately (different field mapping)
      if (data.scenarios) {
        await supabase.from('scenarios').delete().gte('created_at', '1970-01-01');
        const rows = data.scenarios.map((s: any) => scenarioToDB(s));
        if (rows.length > 0) {
          const { error } = await supabase.from('scenarios').insert(rows);
          if (error) {
            return res.status(500).json({ error: `Failed to save scenarios: ${error.message}` });
          }
        }
      }

      return res.status(200).json({ ok: true });
    } catch (err: any) {
      return res.status(500).json({ error: err.message });
    }
  }

  return res.status(405).json({ error: 'Method not allowed' });
}
