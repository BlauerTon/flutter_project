<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\RegisterController;
use App\Http\Controllers\LoginController;
use App\Http\Controllers\ProfileController;
use App\Http\Controllers\DashboardController;
use App\Http\Controllers\GraphController;
use App\Http\Middleware\FirebaseAuth;

Route::get('/', function () {
    return redirect()->route('login');
});
Route::get('/login', [LoginController::class, 'login'])->name('login');
Route::post('/authenticate', [LoginController::class, 'authenticate'])->name('login.authenticate');

Route::get('/dashboard', [DashboardController::class, 'index'])->name('dashboard');
Route::get('/users/{userId}/edit', [DashboardController::class, 'edit'])->name('users.edit');
Route::put('/users/{userId}', [DashboardController::class, 'update'])->name('users.update');
Route::delete('/users/{userId}', [DashboardController::class, 'destroy'])->name('users.destroy');

Route::get('/register', [RegisterController::class, 'register'])->name('register');
Route::post('/register', [RegisterController::class, 'store'])->name('register.store');

Route::get('/profile', [ProfileController::class, 'profile'])->name('profile');

Route::get('/get-authenticated-users', [GraphController::class, 'getAuthenticatedUsers']);
Route::get('/graph', [GraphController::class, 'index'])->name('graph');