@extends('layouts.layout')

@section('content')

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-10"> 
            <div class="card">
                <section style="background-color:#eee;">
                    <div class="container py-2">
                        <div class="row">
                            <div class="col-lg-4">
                                <div class="card mb-4">
                                    <div class="card-body text-center">
                                        <img src="{{ asset('images/account.png') }}" alt="Profile Picture" class="rounded-circle img-fluid" style="width: 150px;">
                                        <h5 class="my-3">{{ $user->name }}</h5>
                                        <p class="text-muted mb-1">{{ $user->email }}</p>
                                        <div class="d-flex justify-content-center mb-2"></div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-lg-8">
                                <div class="card mb-4">
                                    <div class="card-body">
                                        <div class="row">
                                            <div class="col-sm-3">
                                                <p class="mb-0">Name</p>
                                            </div>
                                            <div class="col-sm-9">
                                                <p class="text-muted mb-0">{{ $user->name }}</p>
                                            </div>
                                        </div>
                                        <hr>
                                        <div class="row">
                                            <div class="col-sm-3">
                                                <p class="mb-0">Username</p>
                                            </div>
                                            <div class="col-sm-9">
                                                <p class="text-muted mb-0">{{ $user->username }}</p>
                                            </div>
                                        </div>
                                        <hr>
                                        <div class="row">
                                            <div class="col-sm-3">
                                                <p class="mb-0">Email</p>
                                            </div>
                                            <div class="col-sm-9">
                                                <p class="text-muted mb-0">{{ $user->email }}</p>
                                            </div>
                                        </div>
                                        <hr>
                                        <div class="row">
                                            <div class="col-sm-3">
                                                <p class="mb-0">Phone Number</p>
                                            </div>
                                            <div class="col-sm-9">
                                                <p class="text-muted mb-0"> 0748567890</p>
                                            </div>
                                        </div>
                                        <hr>
                                        <div class="row">
                                            <div class="col-sm-3">
                                                <p class="mb-0">Address</p>
                                            </div>
                                            <div class="col-sm-9">
                                                <p class="text-muted mb-0">Mbagathi way</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>
            </div>
        </div>
    </div>
</div>
@endsection