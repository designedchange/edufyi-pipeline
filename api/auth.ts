import type { VercelRequest, VercelResponse } from '@vercel/node';

// Simple hash function matching the client-side one
function hashPassword(input: string): number {
  let hash = 0;
  for (let i = 0; i < input.length; i++) {
    hash = ((hash << 5) - hash + input.charCodeAt(i)) | 0;
  }
  return hash;
}

// Generate a simple session token
function generateToken(): string {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  let token = '';
  for (let i = 0; i < 64; i++) {
    token += chars.charAt(Math.floor(Math.random() * chars.length));
  }
  return token;
}

// In-memory token store (resets on cold start, which is fine for single user)
// For production, store in Supabase or use JWT
const validTokens = new Set<string>();

export function validateToken(token: string): boolean {
  return validTokens.has(token);
}

export default async function handler(req: VercelRequest, res: VercelResponse) {
  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }

  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method not allowed' });
  }

  const { password } = req.body || {};
  if (!password) {
    return res.status(400).json({ error: 'Password required' });
  }

  const rawEnv = process.env.AUTH_PASSWORD_HASH || '';
  const expectedHash = rawEnv ? parseInt(rawEnv.trim()) : 1666762267;
  const inputHash = hashPassword(password);

  if (inputHash !== expectedHash) {
    return res.status(401).json({ error: 'Invalid password', debug: { inputHash, expectedHash, envSet: !!process.env.AUTH_PASSWORD_HASH, envLen: rawEnv.length } });
  }

  const token = generateToken();
  validTokens.add(token);

  // Clean up old tokens (keep last 10)
  if (validTokens.size > 10) {
    const arr = Array.from(validTokens);
    for (let i = 0; i < arr.length - 10; i++) {
      validTokens.delete(arr[i]);
    }
  }

  return res.status(200).json({ token });
}

// Export for use by other API routes
export { validTokens };
