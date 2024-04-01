import pyrebase

config = {
  "apiKey": "AIzaSyDEKK8d_j9x3to4ClXvMKRmJRyHubpagPE",
  "authDomain": "tigas-2939a.firebaseapp.com",
  "projectId": "tigas-2939a",
  "databaseURL": "https://tigas-2939a-default-rtdb.asia-southeast1.firebasedatabase.app/",
  "storageBucket": "tigas-2939a.appspot.com",
  "messagingSenderId": "878287150120",
  "appId": "1:878287150120:web:a965330b9f279ff075291d"
}

firebase = pyrebase.initialize_app(config)
database = firebase.database()
