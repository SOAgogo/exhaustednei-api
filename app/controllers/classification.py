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

# Example usage:
image_url = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQfoj6fo3z61ZH59hgmndWSs1h082AfOAeZKw&usqp=CAU"
prediction_result = predict_dog_breed(image_url)
print(prediction_result)
