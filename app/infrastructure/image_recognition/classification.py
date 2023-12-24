import sys
from roboflow import Roboflow
import os


def predict_dog_breed(image_url):
    # Replace 'tvNfa4TcFQ57IGJvtQ9q' with your actual Roboflow API key
    rf = Roboflow(api_key="tvNfa4TcFQ57IGJvtQ9q")

    # Replace 'dog-breed-xpaq6' with your actual Roboflow project name
    project = rf.workspace().project("dog-breed-xpaq6")
    
    # Replace '1' with the version of the model you want to use
    model = project.version(1).model

    # Infer on an image hosted elsewhere

    # Assuming your code is in the home directory
    predictions = model.predict(image_url, hosted=True).json()
    output = predictions['predictions'][0]['predictions'][0]
    # Assuming your output string
    # Define a regular expression pattern to match the desired string
    # Search for the pattern in the output string
    if output['confidence'] >= 0.5 :
        output
    else : 
        output = {'class': 'hybrid', 'confidence': 1}
    # Add a default item if no items pass the condition

    print(output)
    return output


def predict_cat_breed(image_url):
    # Replace 'tvNfa4TcFQ57IGJvtQ9q' with your actual Roboflow API key
    rf = Roboflow(api_key="tvNfa4TcFQ57IGJvtQ9q")

    # Replace 'dog-breed-xpaq6' with your actual Roboflow project name
    #project = rf.workspace().project("cat-breed-classification")
    project = rf.workspace().project("cat-breeds-obw8e")
    model = project.version(2).model

    # Infer on an image hosted elsewhere

    # Assuming your code is in the home directory
    predictions = model.predict(image_url, hosted=False).json()
    output = predictions['predictions'][0]['predictions'][0]

    predictions = model.predict(image_url,hosted=True).json()
        
    output = [{'class': item['class'], 'confidence': item['confidence']} for item in predictions['predictions'] if item['confidence'] >= 0.5]

    # Add a default item if no items pass the condition
    output.append({'class': 'hybrid', 'confidence': 1} if not output else {})
    # Assuming your output string
    # Define a regular expression pattern to match the desired string
    # Search for the pattern in the output string
    if output['confidence'] >= 0.5 :
        output
    else : 
        output = {'class': 'hybrid', 'confidence': 1}
    # Add a default item if no items pass the condition

    print(output)
    return output

    print(output)
    return output


def predict_dog_or_cat(image_url):
    # Replace 'tvNfa4TcFQ57IGJvtQ9q' with your actual Roboflow API key
    rf = Roboflow(api_key="tvNfa4TcFQ57IGJvtQ9q")

    project = rf.workspace().project("cat-dog-classification-bglyr")


    # Replace '1' with the version of the model you want to use
    model = project.version(1).model

    # Infer on an image hosted elsewhere

    # Assuming your code is in the home directory
    predictions = model.predict(image_url,hosted=True).json()
    output = predictions['predictions'][0]['predictions'][0]['class']
    # Assuming your output string
    # Define a regular expression pattern to match the desired string
    # Search for the pattern in the output string
    if output == 'Dog':
        predict_dog_breed(image_url)
    elif output == 'Cat':
        predict_cat_breed(image_url)
    else:
        return 'classification error, wrong animal'






if __name__ == "__main__":
    # Check if the command line argument for image_url is provided
    if len(sys.argv) < 2:
        print("Usage: python script.py <image_url>")
        sys.exit(1)

    # Get the image_url from the command line argument
    image_url = os.path.sys.argv[1]
    # Call the predict_dog_breed function with the provided image_url
    predict_dog_or_cat(image_url)
