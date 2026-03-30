import { Redis } from '@upstash/redis';

const redis = Redis.fromEnv();

export default async function handler(req, res) {
  const { a, b } = req.query;
  const sum = Number(a || 0) + Number(b || 0);

  await redis.lpush('logs', JSON.stringify({
    a, b, result: sum, time: new Date().toISOString()
  }));

  res.status(200).json({ result: sum });
}
