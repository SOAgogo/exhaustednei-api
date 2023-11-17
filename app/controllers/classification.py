import sys
from roboflow import Roboflow

def predict_dog_breed(image_url):
    # Replace 'tvNfa4TcFQ57IGJvtQ9q' with your actual Roboflow API key
    rf = Roboflow(api_key="tvNfa4TcFQ57IGJvtQ9q")

    # Replace 'dog-breed-xpaq6' with your actual Roboflow project name
    project = rf.workspace().project("dog-breed-xpaq6")
    
    # Replace '1' with the version of the model you want to use
    model = project.version(1).model

    # Infer on an image hosted elsewhere
    result = model.predict(image_url, hosted=True).json()
    
    return result

if __name__ == "__main__":
    # Check if the command line argument for image_url is provided
    if len(sys.argv) < 2:
        print("Usage: python script.py <image_url>")
        sys.exit(1)

    # Get the image_url from the command line argument
    image_url = sys.argv[1]

    # Call the predict_dog_breed function with the provided image_url
    prediction_result = predict_dog_breed(image_url)
    print(prediction_result)
