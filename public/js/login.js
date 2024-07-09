// Import Firebase modules
import { initializeApp } from "https://www.gstatic.com/firebasejs/10.12.2/firebase-app.js";
import {
    getAuth,
    signInWithEmailAndPassword,
} from "https://www.gstatic.com/firebasejs/10.12.2/firebase-auth.js";

// Your web app's Firebase configuration (replace with your own)
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

// Event listener for login form submission
document.addEventListener("DOMContentLoaded", function () {
    const submit = document.getElementById("submit");
    submit.addEventListener("click", function (event) {
        event.preventDefault();

        // Get form inputs
        const email = document.getElementById("email").value;
        const password = document.getElementById("password").value;

        // Sign in user with email and password
        signInWithEmailAndPassword(auth, email, password)
            .then((userCredential) => {
                const user = userCredential.user;

                // Check if email is verified
                if (!user.emailVerified) {
                    alert("Please verify your email before logging in.");
                    return;
                }

                // Retrieve the ID token
                user.getIdToken()
                    .then((idToken) => {
                        // Store the ID token in local storage
                        localStorage.setItem("firebaseIdToken", idToken);

                        // Send ID token to Laravel backend for verification
                        fetch("/authenticate", {
                            method: "POST",
                            headers: {
                                "Content-Type": "application/json",
                                "X-CSRF-TOKEN": document.querySelector('meta[name="csrf-token"]').getAttribute("content"),
                            },
                            body: JSON.stringify({
                                email,
                                password,
                            }),
                        })
                        .then((response) => {
                            console.log(response); // Log the raw response object for debugging
                        
                            if (!response.ok) {
                                throw new Error("Network response was not ok");
                            }
                        
                            return response.json(); // Parse response as JSON
                        })
                        .then((data) => {
                            if (data.success) {
                                window.location.href = "/dashboard";
                            } else {
                                alert(data.error || "Invalid credentials");
                            }
                        })
                        .catch((error) => {
                            console.error("Error logging in:", error);
                            alert("Error logging in.");
                        });
                    })
                    .catch((error) => {
                        console.error("Error retrieving ID token:", error);
                        alert("Error retrieving ID token.");
                    });
            })
            .catch((error) => {
                const errorCode = error.code;
                const errorMessage = error.message;
                alert(errorMessage);
                console.error("Login error:", error);
            });
    });
});
