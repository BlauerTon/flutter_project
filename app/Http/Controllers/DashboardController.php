<?php
// DashboardController.php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Services\FirebaseServiceV2;

class DashboardController extends Controller
{
    private $firebaseService;

    public function __construct(FirebaseServiceV2 $firebaseService)
    {
        $this->firebaseService = $firebaseService;
    }

    public function index()
    {
        $users = $this->firebaseService->getAllUsers();
        return view('welcome', compact('users'));
    }

    public function edit($userId)
    {
        $user = $this->firebaseService->getUser($userId);
        return view('edit', compact('user'));
    }

    public function update(Request $request, $userId)
    {
        $this->firebaseService->updateUser($userId, $request->all());
        return redirect()->route('dashboard')->with('success', 'User updated successfully.');
    }

    public function destroy($userId)
    {
        $this->firebaseService->deleteUser($userId);
        return redirect()->route('dashboard')->with('success', 'User deleted successfully.');
    }
}
