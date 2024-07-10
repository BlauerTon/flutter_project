<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class LoginController extends Controller
{
    public function login()
    {
        return view('login');
    }

    public function authenticate(Request $request)
    {
        $validated = $request->validate([
            'email' => 'required|email',
            'password' => 'required',
        ]);

        // Attempt to authenticate user with Laravel's Auth
        if (Auth::attempt($validated)) {
            $user = Auth::user();

            // Check if email is verified
            if (!$user->email_verified_at) {
                Auth::logout();
                return response()->json(['success' => false, 'error' => 'Please verify your email before logging in.']);
            }

            // Return success response
            return response()->json(['success' => true]);
        }

        // Return error response for invalid credentials
        return response()->json(['success' => false, 'error' => 'Invalid credentials']);
    }
}
