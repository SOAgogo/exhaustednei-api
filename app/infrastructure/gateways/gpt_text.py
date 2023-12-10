from openai import OpenAI
from dotenv import load_dotenv
import sys
load_dotenv()

if len(sys.argv) > 1:
    client = OpenAI()
    message_from_ruby = sys.argv[1]
    completion = client.chat.completions.create(
      model="gpt-3.5-turbo",
      messages=[
        {"role": "system", "content": message_from_ruby},
      ]
    )
    print(completion.choices[0].message)
else:
    print("No message received from Ruby.")






