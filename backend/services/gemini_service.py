import google.generativeai as genai
from PIL import Image
from dotenv import load_dotenv
import os

# 1. API 키 세팅
load_dotenv()
genai.configure(api_key=os.getenv("GEMINI_API_KEY"))

# 2. 모델 설정 (시각 인식 능력이 뛰어난 Flash 모델 추천)
model = genai.GenerativeModel('gemini-3-flash-preview')


def analyze_diet_for_hypertension(image_path):
    # 이미지 로드
    img = Image.open(image_path)

    # 3. 구체적인 프롬프트 작성 (역할 부여 및 출력 형식 지정)
    prompt = """
    당신은 전문 영양사입니다. 업로드된 사진 속의 음식을 분석하여 다음 정보를 제공해주세요:

    1. 식단 구성: 사진에 포함된 모든 음식의 이름을 나열하세요.
    2. 칼로리 추정: 각 음식별 예상 칼로리와 전체 총 칼로리를 계산하세요.
    3. 고혈압 환자 식단평: 
       - 나트륨 함량(예상)이 높은 음식을 지적하세요.
       - 고혈압 관리(DASH 식단 등) 관점에서 이 식단의 장단점을 설명하세요.
       - 고혈압 환자를 위한 개선 사항(예: '국물을 남기세요', '채소를 추가하세요')을 제안하세요.

    모든 답변은 한국어로 친절하게 작성해주세요.
    """

    # 4. 이미지와 프롬프트를 함께 전송
    response = model.generate_content([prompt, img])

    return response.text


# 사용 예시
result = analyze_diet_for_hypertension("mymeal_1.jpg")
print(result)