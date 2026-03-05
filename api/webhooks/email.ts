import type { VercelRequest, VercelResponse } from '@vercel/node';
import { createClient } from '@supabase/supabase-js';

const supabase = createClient(
  process.env.SUPABASE_URL || '',
  process.env.SUPABASE_SERVICE_KEY || ''
);

// Parse email content to extract key fields
function parseEmail(raw: { from?: string; to?: string; subject?: string; text?: string; html?: string }) {
  const text = raw.text || raw.html || '';
  const from = raw.from || '';
  const subject = (raw.subject || '').replace(/^(Re:|Fwd:|FW:)\s*/gi, '').trim();

  // Extract sender name from "Name <email>" format
  const nameMatch = from.match(/^([^<]+)/);
  const senderName = nameMatch ? nameMatch[1].trim() : from;

  // Determine if inbound (not from our domains)
  const isOurs = from.includes('asu.edu') || from.includes('fyi.') || from.includes('edufyi');
  const direction = isOurs ? 'Outbound' : 'Inbound';

  // Build summary (first ~300 chars of body, cleaned up)
  const cleanText = text
    .replace(/<[^>]*>/g, ' ') // strip HTML tags
    .replace(/\s+/g, ' ')     // collapse whitespace
    .trim();
  const summary = cleanText.substring(0, 300) + (cleanText.length > 300 ? '...' : '');

  // Look for follow-up hints
  let followup = '';
  const fuMatch = cleanText.match(/(?:let me know|happy to|schedule|next step|follow.?up|let's connect|call to discuss)[^.!?\n]*/i);
  if (fuMatch) followup = fuMatch[0].trim();

  return {
    id: 'c' + Date.now(),
    type: 'Email',
    deal_id: '', // Will need to be assigned manually or via keyword matching
    people: senderName,
    subject,
    direction,
    date: new Date().toISOString().slice(0, 10),
    fyi_link: '',
    summary,
    followup
  };
}

// Try to match email to a deal based on keywords in subject/body
async function matchDeal(subject: string, body: string): Promise<string> {
  const { data: deals } = await supabase.from('deals').select('id, org');
  if (!deals) return '';

  const searchText = (subject + ' ' + body).toLowerCase();
  for (const deal of deals) {
    if (searchText.includes(deal.org.toLowerCase())) {
      return deal.id;
    }
  }
  return '';
}

export default async function handler(req: VercelRequest, res: VercelResponse) {
  if (req.method === 'OPTIONS') return res.status(200).end();
  if (req.method !== 'POST') return res.status(405).json({ error: 'Method not allowed' });

  // Optional: validate webhook secret
  const secret = req.headers['x-webhook-secret'] || req.query.secret;
  if (process.env.WEBHOOK_SECRET && secret !== process.env.WEBHOOK_SECRET) {
    return res.status(403).json({ error: 'Invalid webhook secret' });
  }

  try {
    const body = req.body;

    // Support multiple email provider formats:
    // SendGrid Inbound Parse: { from, to, subject, text, html }
    // Mailgun: { From, Subject, body-plain, body-html }
    // Resend: { from, subject, text, html }
    // Generic: normalize to { from, subject, text }
    const normalized = {
      from: body.from || body.From || body.sender || '',
      to: body.to || body.To || body.recipient || '',
      subject: body.subject || body.Subject || '',
      text: body.text || body['body-plain'] || body.body || '',
      html: body.html || body['body-html'] || ''
    };

    const comm = parseEmail(normalized);

    // Try to auto-match to a deal
    comm.deal_id = await matchDeal(normalized.subject, normalized.text);

    // Insert into Supabase
    const { error } = await supabase.from('comms').insert(comm);
    if (error) {
      console.error('Failed to insert comm:', error);
      return res.status(500).json({ error: error.message });
    }

    // If matched to a deal, add to deal activity
    if (comm.deal_id) {
      const { data: deal } = await supabase.from('deals').select('activity').eq('id', comm.deal_id).single();
      if (deal) {
        const activity = deal.activity || [];
        activity.unshift({ date: comm.date, text: `Email: ${comm.subject || 'Forwarded email'}` });
        await supabase.from('deals').update({ activity }).eq('id', comm.deal_id);
      }
    }

    return res.status(200).json({ ok: true, id: comm.id, deal_matched: comm.deal_id || null });
  } catch (err: any) {
    console.error('Webhook error:', err);
    return res.status(500).json({ error: err.message });
  }
}
