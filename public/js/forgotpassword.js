// Import the functions you need from the SDKs you need
import { initializeApp } from "https://www.gstatic.com/firebasejs/10.12.2/firebase-app.js";
import { getAuth, sendPasswordResetEmail } from "https://www.gstatic.com/firebasejs/10.12.2/firebase-auth.js";

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

const forgetPassword = document.getElementById('forgotpassword');
const emailInput = document.getElementById('email');

forgetPassword.addEventListener("click", function(event){
    event.preventDefault();

    const email = emailInput.value;

    if (email) {
        sendPasswordResetEmail(auth, email)
            .then(() => {
                alert("A password reset link has been sent to your email");
            })
            .catch((error) => {
                console.error(error.code, error.message);
                alert("Error: " + error.message);
            });
    } else {
        alert("Please enter your email address");
    }
});
