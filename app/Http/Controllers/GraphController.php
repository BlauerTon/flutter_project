<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Kreait\Firebase\Factory;
use Illuminate\Pagination\LengthAwarePaginator;
use App\Services\FirebaseServiceV2;

class DashboardController extends Controller
{
    private $firebaseService;

    public function __construct(FirebaseServiceV2 $firebaseService)
    {
        $this->firebaseService = $firebaseService;
    }

    public function index(Request $request)
    {
        $firebase = (new Factory)
            ->withServiceAccount(storage_path('app/user-signin-b9c08-firebase-adminsdk-qs7sz-c7faf2d09f.json'))
            ->withDatabaseUri('https://user-signin-b9c08-default-rtdb.firebaseio.com/');

        $auth = $firebase->createAuth();
        $users = $auth->listUsers();

        $userList = [];
        foreach ($users as $user) {
            $userList[] = [
                'uid' => $user->uid,
                'displayName' => $user->displayName,
                'email' => $user->email,
            ];
        }

        $users = collect($userList);
        $perPage = 10;
        $currentPage = LengthAwarePaginator::resolveCurrentPage();
        $currentPageItems = $users->slice(($currentPage - 1) * $perPage, $perPage)->all();
        $paginatedUsers = new LengthAwarePaginator($currentPageItems, $users->count(), $perPage);

        return view('dashboard.index', ['users' => $paginatedUsers]);
    }

    public function edit($userId)
    {
        $user = $this->firebaseService->getUser($userId);
        return view('dashboard.edit', compact('user'));
    }

    public function update(Request $request, $userId)
    {
        $this->firebaseService->updateUser($userId, $request->all());
        return redirect()->route('dashboard.index')->with('success', 'User updated successfully.');
    }

    public function destroy($userId)
    {
        $this->firebaseService->deleteUser($userId);
        return redirect()->route('dashboard.index')->with('success', 'User deleted successfully.');
    }
}
