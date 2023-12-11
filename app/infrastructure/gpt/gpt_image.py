from openai import OpenAI
from dotenv import load_dotenv
import sys
load_dotenv()
client = OpenAI()

if len(sys.argv) > 1:
    client = OpenAI()
    image_path = sys.argv[1]
    star_sign = sys.argv[2]
    response = client.chat.completions.create(
      model="gpt-4-vision-preview",
      messages=[
        {
          "role": "user",
          "content": [
            {"type": "text", "text": f"According to the animal image, what is the percentage of the person whose star sign is #{star_sign} likes this animal(the answer must contain a number) based on the animal breed? just guess and briefly explain the reason in 80 words."},
            {
              "type": "image_url",
              "image_url": {
                "url": image_path,
              },
            },
          ],
        }
      ],
      max_tokens=300,
    )
    print(response.choices[0])
else:
    print("No message received from Ruby.")




