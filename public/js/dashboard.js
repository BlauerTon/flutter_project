import { initializeApp } from "https://www.gstatic.com/firebasejs/10.12.2/firebase-app.js";
import { getFirestore, doc, deleteDoc } from "https://www.gstatic.com/firebasejs/10.12.2/firebase-firestore.js";


const app = initializeApp(firebaseConfig);
const db = getFirestore(app);

async function handleEditUser(event) {
    const userId = event.target.getAttribute('data-id');
    window.location.href = `/users/${userId}/edit`;
}

async function handleDeleteUser(event) {
    const userId = event.target.getAttribute('data-id');
    if (confirm("Are you sure you want to delete this user?")) {
        await deleteDoc(doc(db, 'users', userId));
        alert("User deleted successfully.");
        location.reload(); 
    }
}

document.addEventListener('DOMContentLoaded', () => {
    document.querySelectorAll('.edit-btn').forEach(button => {
        button.addEventListener('click', handleEditUser);
    });

    document.querySelectorAll('.delete-btn').forEach(button => {
        button.addEventListener('click', handleDeleteUser);
    });
});
