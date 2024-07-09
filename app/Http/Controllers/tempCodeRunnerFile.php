<?php

namespace App\Http\Controllers;

use App\Services\FirebaseService;
use Illuminate\Support\Facades\Auth;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use App\Models\User;

class ProfileController extends Controller
{
    protected $firebaseService;

    public function __construct(FirebaseService $firebaseService)
    {
        $this->firebaseService = $firebaseService;
    }


    public function profile()
    {
        $user = Auth::user();
        dd($user);

        if (!$user) {
            // Retrieve the user from Firebase
            $firebaseUser = $this->getFirebaseUser();
            if ($firebaseUser) {
                // Create a new user in the database
                $user = User::create([
                    'firebase_uid' => $firebaseUser->uid,
                    'name' => $firebaseUser->displayName,
                    'email' => $firebaseUser->email,
                ]);
                Auth::login($user);
            } else {
                // Handle the case where the user is not found in Firebase
                return redirect()->route('login')->withErrors([
                    'email' => 'User not found'
                ]);
            }
        }

        return view('profile', compact('user'));
    }

    private function getFirebaseUser()
    {
        $firebaseUserId = Auth::user()->firebase_uid;
        return $this->firebaseService->getUser($firebaseUserId);
    }
}