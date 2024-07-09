<?php
namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use App\Models\User;

class RegisterController extends Controller
{
    public function register()
    {
        return view('register');
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|min:3|max:40',
            'email' => 'required|email|unique:users,email',
            'firebase_uid' => 'required|unique:users,firebase_uid',
        ]);

        $user = User::create([
            'name' => $validated['name'],
            'email' => $validated['email'],
            'firebase_uid' => $validated['firebase_uid'],
            'password' => Hash::make(str_random(16)), // Temporary password
        ]);

        return response()->json(['success' => true]);
    }
}
