@extends('layouts.layout')

@section('content')
    <div class="container">
        <h2>Edit User</h2>
        <form action="{{ route('users.update', $user->uid) }}" method="POST">
            @csrf
            @method('PUT')
            <div class="mb-3">
                <label for="displayName" class="form-label">Display Name</label>
                <input type="text" class="form-control" id="displayName" name="displayName" value="{{ $user->displayName }}">
            </div>
            <div class="mb-3">
                <label for="email" class="form-label">Email address</label>
                <input type="email" class="form-control" id="email" name="email" value="{{ $user->email }}">
            </div>
            <button type="submit" class="btn btn-primary">Update User</button>
        </form>
    </div>
@endsection
