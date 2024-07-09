<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Kreait\Firebase\Factory;
use Illuminate\Support\Facades\Auth;
use App\Models\User;
use Illuminate\Support\Facades\Log;

class FirebaseAuth
{
    protected $firebaseAuth;

    public function __construct()
    {
        $this->firebaseAuth = (new Factory)
            ->withServiceAccount(storage_path('app/user-signin-b9c08-firebase-adminsdk-qs7sz-c7faf2d09f.json'))
            ->createAuth();
    }

    public function handle(Request $request, Closure $next)
    {
        $idToken = $request->header('Authorization');

        if (!$idToken) {
            Log::error('No Firebase ID Token provided');
            return response()->json(['error' => 'Unauthorized: No token provided'], 401);
        }

        try {
            $verifiedIdToken = $this->firebaseAuth->verifyIdToken($idToken);
            $firebaseUserId = $verifiedIdToken->claims()->get('sub');

            $user = User::where('firebase_uid', $firebaseUserId)->first();
            if (!$user) {
                $firebaseUser = $this->firebaseAuth->getUser($firebaseUserId);
                $user = User::create([
                    'firebase_uid' => $firebaseUserId,
                    'email' => $firebaseUser->email,
                    'username' => $firebaseUser->displayName,
                ]);
            }

            Auth::login($user);

            return $next($request);
        } catch (\Exception $e) {
            Log::error('Invalid Firebase ID Token');
            return response()->json(['error' => 'Unauthorized: Invalid token'], 401);
        }
    }
}
