@extends('layouts.layout')

@section('content')


<div class="page-content">
<div class="containter-fluid">

<div class="row">
    <div class="col-lg-6">
        <div class="card"><br>
<center>
            <img class="rounded-circle avatar-xl" src="{{ asset('images/account.png') }}" alt="card image cap">
</center>
            <div class="card-body">
                @csrf
                <h4 class="card-title">Name:<title></title></h4>
                <hr>
                <h4 class="card-title">User Email:  </h4>
                <hr>
                <h4 class="card-title">User Name: </h4>
                <hr>
                <a href="" class="btn btn-info btn-rounded waves-effect waves-light">Edit Profile</a>

            </div>
        </div>


    </div>
</div>
</div>
</div>


@endsection

<html>
<script type="module" src="{{ asset('js/profile.js') }}" defer></script>

<script src="https://www.gstatic.com/firebasejs/9.10.0/firebase-app.js"></script>
<script src="https://www.gstatic.com/firebasejs/9.10.0/firebase-auth.js"></script>

</html>
