<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use App\Services\FirebaseService;
use Illuminate\Support\Facades\Auth;
use App\Models\User;
use Illuminate\Support\Facades\Log;

class FirebaseAuth
{
    protected $firebaseService;

    public function __construct(FirebaseService $firebaseService)
    {
        $this->firebaseService = $firebaseService;
    }

    public function handle(Request $request, Closure $next)
    {
        $idToken = $request->bearerToken();

        if (!$idToken) {
            Log::error('No Firebase ID Token provided');
            return response()->json(['error' => 'Unauthorized no provided token'], 401);
        }

        Log::info('Firebase ID Token received: ' . $idToken);

        $verifiedIdToken = $this->firebaseService->verifyIdToken($idToken);

        if (!$verifiedIdToken) {
            Log::error('Invalid Firebase ID Token');
            return response()->json(['error' => 'Unauthorized'], 401);
        }

        $firebaseUserId = $verifiedIdToken->claims()->get('sub');
        
        $user = User::where('firebase_uid', $firebaseUserId)->first();

        if (!$user) {
            
            $firebaseUser = $this->firebaseService->getUser($firebaseUserId);

            if (!$firebaseUser) {
                Log::error('Failed to retrieve user details from Firebase for UID: ' . $firebaseUserId);
                return response()->json(['error' => 'Unauthorized'], 401);
            }

            $user = User::create([
                'firebase_uid' => $firebaseUserId,
                'email' => $firebaseUser->email,
                'username' => $firebaseUser->displayName,
                
            ]);
        }

        Auth::login($user);

        return $next($request);
    }
}