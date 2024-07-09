import { initializeApp } from "https://www.gstatic.com/firebasejs/10.12.2/firebase-app.js";
import { getAuth } from "https://www.gstatic.com/firebasejs/10.12.2/firebase-auth.js";

const firebaseConfig = {
    apiKey: "AIzaSyDORrv2mlhnNGg7PukWVras0FdgDAt5_rQ",
    authDomain: "ha-sytem.firebaseapp.com",
    projectId: "ha-sytem",
    storageBucket: "ha-sytem.appspot.com",
    messagingSenderId: "650517979119",
    appId: "1:650517979119:web:2889e4ef2e82d89b79201a"
};

const app = initializeApp(firebaseConfig);
const auth = getAuth(app);

function fetchUserData(idToken) {
    fetch('https://127.0.0.1:8000/api/profile', {
      method: 'GET',
      headers: {
        'Authorization': 'Bearer ' + idToken
      }
    })
    .then(response => response.json())
    .then(data => console.log(data))
    .catch(error => console.error('Error:', error));
  }