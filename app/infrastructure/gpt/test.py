from openai import OpenAI
from dotenv import load_dotenv
load_dotenv()
client = OpenAI()


# response = client.chat.completions.create(
#     model="gpt-4-vision-preview",
#     messages=[
#       {
#         "role": "user",
#         "content": [
#           {
#             "type": "text",
#             "text": "What are both dog species or cat species in the pictures? And if they are same species, please give me the similarity of two pictures(the answer must contain a percentage number,eg: 80% or 80 percent)",
#           },
#           {
#             "type": "image_url",
#             "image_url": {
#               "url": "https://img.alicdn.com/imgextra/i1/2335360675/O1CN01jygT7r1GrBsOnU8cU_!!2335360675-0-daren.jpg_960x960Q50s50.jpg",
#             },
#           },
#           {
#             "type": "image_url",
#             "image_url": {
#               "url": "https://img.alicdn.com/imgextra/i2/2335360675/O1CN010SlorB1GrBsPfPIqS_!!2335360675-0-daren.jpg_960x960Q50s50.jpg_.webp",
#             },
#           },
#         ],
#       }
#     ],
#     max_tokens=500,
#   )
# print(response.choices[0])
image_path = 'https://www.niusnews.com/upload/imgs/default/202207_Jennie/0701cat/03.JPG'
response = client.chat.completions.create(
      model="gpt-4-vision-preview",
      messages=[
        {
          "role": "user",
          "content": [
            {"type": "text", "text": f"According to the dog or cat species, give me some information about how to take care of this animal, and the information must be related to the animal species."},
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





