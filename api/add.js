export default function handler(req, res) {
  // URL 쿼리 파라미터에서 a와 b를 가져옵니다 (예: /api/add?a=1&b=2)
  const { a, b } = req.query;
  
  // 숫자로 변환하여 더하기
  const sum = Number(a) + Number(b);
  
  // JSON 형식으로 결과 반환
  res.status(200).json({ result: sum });
}
