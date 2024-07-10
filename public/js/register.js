// Import Firebase modules
import { initializeApp } from "https://www.gstatic.com/firebasejs/10.12.2/firebase-app.js";
import { getAuth, createUserWithEmailAndPassword } from "https://www.gstatic.com/firebasejs/10.12.2/firebase-auth.js";

// Your web app's Firebase configuration
const firebaseConfig = {
    apiKey: "AIzaSyDORrv2mlhnNGg7PukWVras0FdgDAt5_rQ",
    authDomain: "ha-sytem.firebaseapp.com",
    projectId: "ha-sytem",
    storageBucket: "ha-sytem.appspot.com",
    messagingSenderId: "650517979119",
    appId: "1:650517979119:web:2889e4ef2e82d89b79201a",
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const auth = getAuth(app);

document.addEventListener("DOMContentLoaded", function () {
    const registerForm = document.getElementById("registerForm");
    registerForm.addEventListener("submit", function (event) {
        event.preventDefault();

        const name = registerForm.name.value;
        const email = registerForm.email.value;
        const password = registerForm.password.value;

        // Create user with email and password
        createUserWithEmailAndPassword(auth, email, password)
            .then((userCredential) => {
                const user = userCredential.user;
                alert("Registration successful. Please login.");

                // Optionally, you can redirect to login page after successful registration
                window.location.href = "/login";
            })
            .catch((error) => {
                const errorCode = error.code;
                const errorMessage = error.message;
                alert(errorMessage);
                console.error("Registration error:", error);
            });
    });
});
