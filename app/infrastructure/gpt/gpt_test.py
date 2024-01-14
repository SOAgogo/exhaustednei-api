from openai import OpenAI
from dotenv import load_dotenv
import sys
import os
import time
import pdb

load_dotenv()
openai_api_key = os.getenv("OPENAI_API_KEY")
client = OpenAI(api_key=openai_api_key)

if len(sys.argv) == 2:
    image_path = sys.argv[1]
    
    # Chunk your request into parts
    request_chunks = [
        {"type": "text", "text": f"According to the dog or cat species, give me some information about how to take care of this animal, and the information must be related to the animal species, the words must be less than 70 words."},
        {"type": "image_url", "image_url": {"url": image_path}},
    ]

    total_tokens = 0

    for chunk in request_chunks:
        response = client.chat.completions.create(
            model="gpt-4-vision-preview",
            messages=[{"role": "user", "content": request_chunks[:request_chunks.index(chunk) + 1]}],
            max_tokens=4096,
        )


        pdb.set_trace() 
        # Update total tokens consumed
        total_tokens += response['usage']['total_tokens']

        # Calculate progress as a percentage
        progress_percentage = (total_tokens / 4096) * 100

        # Print or log the progress
        print(f"Progress: {progress_percentage}%")

        # You can also update a progress bar or any other UI element

        # Introduce a delay between requests
        time.sleep(5)  # Adjust the delay as needed
else:
    print("No message received from Ruby.")
