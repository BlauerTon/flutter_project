<?php
// FirebaseServiceV2.php

namespace App\Services;

use Kreait\Firebase\Factory;
use Kreait\Firebase\Auth as FirebaseAuth;
use Kreait\Firebase\Exception\Auth\UserNotFound;

class FirebaseServiceV2
{
    private $firebaseAuth;

    public function __construct()
    {
        $factory = (new Factory)
            ->withServiceAccount(storage_path('app/user-signin-b9c08-firebase-adminsdk-qs7sz-c7faf2d09f.json'))
            ->createAuth();

        $this->firebaseAuth = $factory;
    }

    public function getAllUsers()
    {
        $users = [];
        $paged = $this->firebaseAuth->listUsers();
        foreach ($paged as $user) {
            $users[] = $user;
        }
        return $users;
    }

    public function getUser($userId)
    {
        try {
            return $this->firebaseAuth->getUser($userId);
        } catch (UserNotFound $e) {
            return null;
        }
    }

    public function updateUser($userId, array $data)
    {
        // Update user details in Firebase
        $user = $this->firebaseAuth->getUser($userId);
        $this->firebaseAuth->updateUser($userId, [
            'email' => $data['email'],
            'displayName' => $data['displayName'],
        ]);
    }

    public function deleteUser($userId)
    {
        $this->firebaseAuth->deleteUser($userId);
    }
}