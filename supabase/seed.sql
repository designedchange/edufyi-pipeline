-- EDU.FYI Pipeline — Seed Data
-- Run this AFTER schema.sql in Supabase SQL Editor

-- ============================================
-- DEALS
-- ============================================
INSERT INTO deals (id, org, type, description, stage, priority, owner, contact, next_step, next_date, products, notes, learners, fyi_link, activity) VALUES
('d1', 'Arden University', 'Education', 'UK-based university — full product suite', 'Conversation', 'High', 'Sean Hobson', '', 'Follow-up meeting', '', '["EDU.FYI","Agentic Self","Agentic Classroom"]', '', 2000, '', '[{"date":"2026-03-01","text":"Initial outreach sent"},{"date":"2026-02-20","text":"Created opportunity"}]'),
('d2', 'Compton College', 'Education', 'Community college — full suite', 'Conversation', 'High', 'will.i.am', '', 'Campus visit', '', '["EDU.FYI","Agentic Self","Agentic Classroom"]', '', 1500, '', '[{"date":"2026-03-02","text":"will.i.am intro call"},{"date":"2026-02-15","text":"Created opportunity"}]'),
('d3', 'AWS', 'Technology', 'Platform infrastructure partnership', 'Conversation', 'High', 'Sean Hobson', '', 'Technical alignment call', '', '["EDU.FYI"]', '', 0, '', '[{"date":"2026-02-28","text":"Intro meeting completed"}]'),
('d4', 'NVIDIA', 'Technology', 'AI compute & classroom tech', 'Active', 'High', 'Lee Chan', '', 'Quarterly review', '2026-04-01', '["EDU.FYI","Agentic Classroom"]', '', 0, '', '[{"date":"2026-03-01","text":"Partnership active"},{"date":"2026-02-01","text":"Agreement signed"}]'),
('d5', 'LG', 'Technology', 'Agentic Classroom hardware', 'Conversation', 'Medium', 'Sean Hobson', '', 'Product demo', '', '["Agentic Classroom"]', '', 0, '', '[{"date":"2026-02-25","text":"Initial conversation"}]'),
('d6', 'Qualcomm', 'Technology', '3-phase partnership: Edge AI curriculum + Snapdragon devices + Mobile/XR. Qualcomm provides hardware & AI certificate; EDU.FYI is the student platform. Key narrative: on-device AI making student agents faster, more private, more powerful.', 'Agreement', 'High', 'Lee Chan', 'Rodrigo Caruso Neves do Amaral', 'Alignment call to discuss counter-proposal & narrative framing', '2026-03-15', '["EDU.FYI","Agentic Self","Agentic Classroom"]', 'Phase 1: AI curriculum + Qualcomm Certificate (current semester) — counter: certificate should connect to EDU.FYI agent work, not standalone Snapdragon course. Phase 2: Device program (next semester) — counter: consider AI glasses/tablets instead of laptops (students already have laptops), lead with student use cases not hardware. Phase 3: Mobile + XR (2027) — counter: ground in learning scenarios (exam prep agents on phone, immersive nursing/engineering). Key contacts: John Smee, Rodrigo Amaral, Vijay Shirsathe, Hemanth Sampath, Patrick Costello.', 5000, '', '[{"date":"2026-03-05","text":"Counter-proposal sent by Lee Chan — reframe around student experience & EDU.FYI platform"},{"date":"2026-02-12","text":"Qualcomm sent 3-phase brief (Rodrigo Amaral) — AI curriculum, Snapdragon laptops, Mobile/XR"},{"date":"2026-03-03","text":"Moved to Agreement"},{"date":"2026-02-10","text":"Proposal submitted"}]'),
('d7', 'Oden College', 'Education', 'EDU.FYI platform adoption', 'Conversation', 'Medium', 'Sean Hobson', '', 'Initial pitch', '', '["EDU.FYI"]', '', 800, '', '[{"date":"2026-02-22","text":"Created opportunity"}]'),
('d8', 'Arizona State University', 'Education', 'Founding partner — full integration', 'Active', 'High', 'Sean Hobson', 'Michael Crow', 'Ongoing integration', '', '["EDU.FYI","Agentic Self","Agentic Classroom"]', '', 5000, '', '[{"date":"2026-03-01","text":"Spring semester active"},{"date":"2026-01-15","text":"Full launch"}]');

-- ============================================
-- COMMS
-- ============================================
INSERT INTO comms (id, type, deal_id, people, subject, direction, date, fyi_link, summary, followup) VALUES
('c1', 'Email', 'd1', 'Sean Hobson', 'Arden initial outreach', 'Outbound', '2026-03-01', '', 'Sent intro email with EDU.FYI overview deck.', ''),
('c2', 'Call', 'd2', 'will.i.am, Sean Hobson', 'Compton College intro call', 'Outbound', '2026-03-02', '', 'will.i.am connected with president. Strong interest in campus visit.', 'Schedule campus visit'),
('c3', 'Meeting', 'd6', 'Sean Hobson', 'Qualcomm terms review', 'Outbound', '2026-03-03', '', 'Reviewed partnership terms. Qualcomm aligned on full suite. Need to finalize rev share.', 'Send final terms doc'),
('c4', 'Email', 'd3', 'Sean Hobson', 'AWS technical discussion', 'Inbound', '2026-02-28', '', 'AWS team responded positively to infrastructure partnership proposal. Scheduling technical deep-dive.', ''),
('c5', 'Email', 'd6', 'Rodrigo Amaral, Lee Chan, John Smee, Vijay Shirsathe, Hemanth Sampath, Patrick Costello', 'ASU/FYI/Qualcomm 3-phase partnership brief', 'Inbound', '2026-02-12', '', 'Qualcomm sent formal 3-phase brief. Phase 1: AI curriculum + Qualcomm Certificate (current semester). Phase 2: Snapdragon laptop program (next semester). Phase 3: Mobile + XR exploration (2027). Rodrigo added Sean to the thread.', 'Review brief and prepare counter-proposal'),
('c6', 'Email', 'd6', 'Lee Chan, Sean Hobson, John Smee, Rodrigo Amaral', 'Counter-proposal: Reframe around student experience & EDU.FYI', 'Outbound', '2026-03-05', '', 'Lee sent counter-proposal. Key points: (1) Phase 1 certificate should connect to EDU.FYI agent work, not standalone Snapdragon course. (2) Phase 2: consider AI glasses/tablets instead of laptops. Lead with student use cases, not hardware specs. (3) Phase 3: ground Mobile/XR in learning scenarios. Overall narrative: center on student outcomes with EDU.FYI as the platform. Requested alignment call.', 'Schedule alignment call with Qualcomm team');

-- ============================================
-- PEOPLE
-- ============================================
INSERT INTO people (id, name, role, org, email, phone, notes) VALUES
('p1', 'Sean Hobson', 'AVP & Chief Design Officer', 'EdPlus at ASU', 'sean.hobson@asu.edu', '', 'EDU.FYI co-founder, leads biz dev'),
('p2', 'will.i.am', 'Co-founder', 'EDU.FYI / FYI.AI', '', '', 'Key evangelist, HBCUs & community colleges'),
('p3', 'Lee Chan', 'COO', 'FYI.AI', 'lee@fyi.fyi', '917.553.7533', 'Manages technology partnerships. Leading Qualcomm relationship.'),
('p4', 'Rodrigo Caruso Neves do Amaral', 'Partnership Lead', 'Qualcomm', 'amaral@qti.qualcomm.com', '', 'Primary Qualcomm contact for ASU/FYI collaboration.'),
('p5', 'John Smee', 'Executive', 'Qualcomm', 'jsmee@qti.qualcomm.com', '', 'Senior Qualcomm stakeholder on EDU.FYI partnership.'),
('p6', 'Vijay Shirsathe', 'Technical Lead', 'Qualcomm', 'vshirsat@qti.qualcomm.com', '', 'Qualcomm technical team.'),
('p7', 'Hemanth Sampath', 'Technical Lead', 'Qualcomm', 'hsampath@qti.qualcomm.com', '', 'Qualcomm technical team.'),
('p8', 'Patrick Costello', 'Team Member', 'Qualcomm', 'pcostell@qti.qualcomm.com', '', 'Qualcomm team.');

-- ============================================
-- TASKS
-- ============================================
INSERT INTO tasks (id, title, deal_id, owner, due, priority, status, notes) VALUES
('t1', 'Send Arden follow-up deck', 'd1', 'Sean Hobson', '2026-03-10', 'High', 'To Do', ''),
('t2', 'Schedule Compton campus visit', 'd2', 'will.i.am', '2026-03-15', 'High', 'To Do', ''),
('t3', 'Finalize Qualcomm terms', 'd6', 'Sean Hobson', '2026-03-15', 'High', 'In Progress', ''),
('t4', 'Prep ASU+GSV booth materials', '', 'Sean Hobson', '2026-03-25', 'High', 'To Do', ''),
('t5', 'AWS technical alignment call', 'd3', 'Sean Hobson', '2026-03-12', 'Medium', 'To Do', ''),
('t6', 'LG product demo prep', 'd5', 'Lee Chan', '2026-03-20', 'Medium', 'To Do', ''),
('t7', 'Schedule Qualcomm alignment call (Lee, Sean, Rodrigo, John)', 'd6', 'Lee Chan', '2026-03-10', 'High', 'To Do', 'Discuss counter-proposal narrative before taking partnership further'),
('t8', 'Prepare Qualcomm narrative deck — student outcomes + EDU.FYI platform story', 'd6', 'Sean Hobson', '2026-03-14', 'High', 'To Do', 'Reframe 3-phase plan around student experience.');

-- ============================================
-- EVENTS
-- ============================================
INSERT INTO events (id, name, date, end_date, location, notes, partners, pitch_plan, followups) VALUES
('e1', 'ASU+GSV Summit 2026', '2026-04-06', '2026-04-08', 'San Diego, CA', 'Major pitch event', '["Arden University","Compton College","AWS","Qualcomm"]', 'will.i.am keynote + booth demos', '[]'),
('e2', 'HBCU Roadshow', '2026-05-01', '2026-05-15', 'Multiple', 'will.i.am-led tour', '["Compton College"]', 'Campus visits with will.i.am', '[]');

-- ============================================
-- ASSETS
-- ============================================
INSERT INTO assets (id, name, type, audience, link, deal_id, notes) VALUES
('a1', 'EDU.FYI Master Pitch Deck', 'Pitch Deck', 'General', '', '', 'Main deck for all partners'),
('a2', 'Agentic Classroom One-Pager', 'One-Pager', 'Technology Partners', '', '', 'Hardware/tech focus'),
('a3', 'HBCU/Community College Brief', 'Brief', 'Education - HBCUs', '', 'd2', 'Tailored for will.i.am outreach'),
('a4', 'ASU Partnership SOW', 'SOW', 'Internal', '', 'd8', 'Active SOW template');

-- ============================================
-- TEMPLATES
-- ============================================
INSERT INTO templates (id, name, stage, type, subject, body) VALUES
('tm1', 'Initial Outreach — Education', 'Awareness', 'Education', 'EDU.FYI — Transforming [Institution] with AI-Powered Learning', E'Hi [Name],\n\nI''m reaching out from EDU.FYI, a platform co-founded by Michael Crow and will.i.am that''s reimagining how learners engage with education through agentic AI.\n\nWe''re working with institutions like ASU to deliver personalized, AI-native learning experiences at scale. Given [Institution]''s commitment to [specific initiative], I think there''s a compelling alignment.\n\nWould you have 20 minutes next week to explore this?\n\nBest,\n[Your name]'),
('tm2', 'Initial Outreach — Technology', 'Awareness', 'Technology', 'Partnership Opportunity — EDU.FYI x [Company]', E'Hi [Name],\n\nEDU.FYI is building the AI-native education platform — co-founded by ASU President Michael Crow and will.i.am. We''re scaling fast and looking for technology partners who share our vision.\n\n[Company]''s work in [area] aligns closely with what we''re building, particularly around [specific capability].\n\nI''d love to explore how we might work together. Free for a quick call?\n\nBest,\n[Your name]'),
('tm3', 'Follow-Up After Meeting', 'Conversation', '', 'Great connecting — next steps for EDU.FYI x [Partner]', E'Hi [Name],\n\nGreat speaking with you [today/yesterday]. I wanted to recap what we discussed and outline next steps:\n\n- [Key point 1]\n- [Key point 2]\n- [Key point 3]\n\nAs a next step, I''ll [action item]. On your end, it would be helpful to [their action item].\n\nLooking forward to moving this forward.\n\nBest,\n[Your name]'),
('tm4', 'Proposal Introduction', 'Proposal', '', 'EDU.FYI Partnership Proposal for [Partner]', E'Hi [Name],\n\nFollowing our alignment conversations, I''m pleased to share our partnership proposal for [Partner].\n\nThe attached outlines:\n- Scope of the partnership\n- Product suite and implementation timeline\n- Investment and economic model\n- Success metrics and milestones\n\nI''d suggest we schedule a call to walk through this together. How does [date] work?\n\nBest,\n[Your name]'),
('tm5', 'Event Pre-Meeting', '', '', 'See you at [Event] — EDU.FYI meeting request', E'Hi [Name],\n\nLooking forward to [Event] next [month]. I wanted to reach out ahead of time to set up a meeting.\n\nEDU.FYI has some exciting updates to share, including [teaser]. will.i.am will also be [presenting/available] and would love to connect.\n\nCould we block 30 minutes during the event? Happy to work around your schedule.\n\nBest,\n[Your name]'),
('tm6', 'HBCU / Community College Intro', 'Awareness', 'Education', 'will.i.am + EDU.FYI — Bringing AI Learning to [Institution]', E'Hi [Name],\n\nI''m writing on behalf of will.i.am and the EDU.FYI team. will.i.am has been deeply committed to expanding access to education through technology, and EDU.FYI is the platform making that vision real.\n\nWe''re specifically focused on partnering with institutions like [Institution] to bring AI-powered, personalized learning at an accessible price point.\n\nwill.i.am would love to visit campus and share the vision directly. Would there be interest in a conversation?\n\nBest,\n[Your name]');
