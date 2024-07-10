<?php

namespace App\Services;

use Kreait\Firebase\Factory;
use Kreait\Firebase\Auth as FirebaseAuth;
use Kreait\Firebase\Exception\Auth\InvalidIdToken;

class FirebaseService
{
    private $firebaseAuth;

    public function __construct()
    {
        $factory = (new Factory)
            ->withServiceAccount(storage_path('app/ha-sytem-firebase-adminsdk-wgcw9-5375815a33.json'))
            ->createAuth();

        $this->firebaseAuth = $factory;
    }

    public function verifyIdToken($idToken)
    {
        try {
            return $this->firebaseAuth->verifyIdToken($idToken);
        } catch (InvalidIdToken $e) {
            return false;
        }
    }

    public function getUser($firebaseUserId)
    {
        try {
            return $this->firebaseAuth->getUser($firebaseUserId);
        } catch (\Kreait\Firebase\Exception\Auth\UserNotFound $e) {
            return null;
        }
    }
}