import { initializeApp } from "https://www.gstatic.com/firebasejs/10.12.2/firebase-app.js";
import { getAuth, createUserWithEmailAndPassword, sendEmailVerification } from "https://www.gstatic.com/firebasejs/10.12.2/firebase-auth.js";

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
    const submit = document.getElementById("submit");
    submit.addEventListener("click", function (event) {
        event.preventDefault();

        const name = document.getElementById("name").value;
        const email = document.getElementById("email").value;
        const password = document.getElementById("password").value;

        createUserWithEmailAndPassword(auth, email, password)
            .then((userCredential) => {
                const user = userCredential.user;

                sendEmailVerification(auth.currentUser)
                    .then(() => {
                        alert("Verification email sent. Please check your email.");

                        fetch("/register", {
                            method: "POST",
                            headers: {
                                "Content-Type": "application/json",
                                "X-CSRF-TOKEN": document.querySelector('meta[name="csrf-token"]').getAttribute("content"),
                            },
                            body: JSON.stringify({
                                name,
                                email,
                                firebase_uid: user.uid,
                            }),
                        })
                            .then((response) => {
                                if (!response.ok) {
                                    throw new Error("Network response was not ok");
                                }
                                return response.json();
                            })
                            .then((data) => {
                                if (data.success) {
                                    window.location.href = "/login";
                                } else {
                                    alert("There was an error registering the user.");
                                }
                            })
                            .catch((error) => {
                                console.error("Error registering user:", error);
                                alert("Error registering user.");
                            });
                    })
                    .catch((error) => {
                        console.error("Error sending email verification:", error);
                        alert("Error sending email verification.");
                    });
            })
            .catch((error) => {
                const errorCode = error.code;
                const errorMessage = error.message;
                alert(errorMessage);
                console.error("Registration error:", error);
            });
    });
});
