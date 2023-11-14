from roboflow import Roboflow

rf = Roboflow(api_key="tvNfa4TcFQ57IGJvtQ9q")
project = rf.workspace().project("dog-breed-xpaq6")
model = project.version(1).model

# infer on an image hosted elsewhere
print(model.predict("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQfoj6fo3z61ZH59hgmndWSs1h082AfOAeZKw&usqp=CAU", hosted=True).json())

