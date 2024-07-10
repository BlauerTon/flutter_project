<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Auth;
use App\Services\FirebaseService;

class DataController extends Controller
{
    protected $firebaseService;

    public function __construct(FirebaseService $firebaseService)
    {
        $this->firebaseService = $firebaseService;
    }

    public function getData(Request $request)
    {
        $idToken = $request->bearerToken();

        if (!$idToken) {
            return response()->json(['error' => 'Unauthorized: No provided token'], 401);
        }

        $verifiedIdToken = $this->firebaseService->verifyIdToken($idToken);

        if (!$verifiedIdToken) {
            return response()->json(['error' => 'Unauthorized: Invalid token'], 401);
        }

        // Extract Firebase UID from token claims
        $firebaseUserId = $verifiedIdToken->claims()->get('sub');

        // Fetch or create the user in your application
        $user = User::where('firebase_uid', $firebaseUserId)->first();

        if (!$user) {
            // Create user based on Firebase details if not found
            $firebaseUser = $this->firebaseService->getUser($firebaseUserId);

            if (!$firebaseUser) {
                return response()->json(['error' => 'Unauthorized: Failed to fetch user details'], 401);
            }

            $user = User::create([
                'firebase_uid' => $firebaseUserId,
                'email' => $firebaseUser->email,
                'username' => $firebaseUser->displayName,
                // Add other fields as needed
            ]);
        }

        // Log in the user
        Auth::login($user);

        // Proceed with your business logic or return data
        return response()->json(['message' => 'Authenticated successfully', 'user' => $user]);
    }
}
