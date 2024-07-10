<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;

class ProfileController extends Controller
{
    public function __construct()
    {
        $this->middleware('firebase.auth'); // Apply FirebaseAuth middleware to all methods
    }

    public function profile(Request $request)
    {
        // Firebase UID should be available from the middleware
        $firebaseUserId = $request->header('Firebase-UID');

        // Retrieve user based on Firebase UID
        $user = User::where('firebase_uid', $firebaseUserId)->first();

        if (!$user) {
            // Handle case where user is not found (though ideally, this should not happen)
            return response()->json(['error' => 'User not found'], 404);
        }

        return view('profile', compact('user'));
    }
}
