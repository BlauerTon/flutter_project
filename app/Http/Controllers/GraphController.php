<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Kreait\Firebase\Factory;
use Kreait\Firebase\Exception\FirebaseException;
use App\Services\FirebaseServiceV2;

class GraphController extends Controller
{
    private $database;

    public function __construct()
    {
        $firebase = (new Factory)
            ->withServiceAccount(storage_path('app/user-signin-b9c08-firebase-adminsdk-qs7sz-c7faf2d09f.json'))
            ->withDatabaseUri('https://user-signin-b9c08-default-rtdb.firebaseio.com/');

        $this->database = $firebase->createDatabase();
    }

    public function index()
    {
        return view('graph');
    }

    public function getAuthenticatedUsers()
    {
        try {
            $snapshot = $this->database->getReference('user_counts')->getSnapshot();
            $data = $snapshot->getValue();

            if ($data === null) {
                return response()->json(['error' => 'No data found'], 404);
            }

            $totalUsers = count($data);

            return response()->json(['totalUsers' => $totalUsers]);
        } catch (FirebaseException $e) {
            return response()->json(['error' => $e->getMessage()], 500);
        }
    }
}
