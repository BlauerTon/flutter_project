import { initializeApp } from "https://www.gstatic.com/firebasejs/10.12.2/firebase-app.js";
import { getFirestore, doc, deleteDoc } from "https://www.gstatic.com/firebasejs/10.12.2/firebase-firestore.js";

const admin = require('firebase-admin');

// Initialize Firebase Admin SDK
const serviceAccount = require('storage/app/user-signin-b9c08-firebase-adminsdk-qs7sz-c7faf2d09f.json'); // Path to your service account key file
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: 'https://user-signin-b9c08-default-rtdb.firebaseio.com/'
});

// Fetch list of users
admin.auth().listUsers()
  .then((userRecords) => {
    // Count number of users
    const totalUsers = userRecords.users.length;
    console.log('Total authenticated users:', totalUsers);

    // Optionally, you can send this totalUsers to your frontend or render it in your admin dashboard
  })
  .catch((error) => {
    console.error('Error fetching users:', error);
  });
