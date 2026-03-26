export default function handler(req, res) {
  const { a, b } = req.query;
  const sum = Number(a || 0) + Number(b || 0);
  res.status(200).json({ result: sum });
}
