
// Import the functions you need from the SDKs you need
import { initializeApp } from "https://www.gstatic.com/firebasejs/10.12.2/firebase-app.js";
import { getAuth, signOut, signInWithEmailAndPassword } from "https://www.gstatic.com/firebasejs/10.12.2/firebase-auth.js";
// Your web app's Firebase configuration
const firebaseConfig = {
    apiKey: "AIzaSyDORrv2mlhnNGg7PukWVras0FdgDAt5_rQ",
    authDomain: "ha-sytem.firebaseapp.com",
    projectId: "ha-sytem",
    storageBucket: "ha-sytem.appspot.com",
    messagingSenderId: "650517979119",
    appId: "1:650517979119:web:2889e4ef2e82d89b79201a"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);

const auth = getAuth(app);

const logout = document.getElementById('logout');
logout.addEventListener("click", function (event) {
    event.preventDefault();

    signOut(auth).then(() => {
        alert("User signed out successfully");
        window.location.href = "login";
    }).catch((error) => {
        const errorMessage = error.message;
        alert(errorMessage);
        
    });
});