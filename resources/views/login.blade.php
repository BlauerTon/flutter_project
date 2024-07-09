<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="{{ asset('css/app.css') }}">
    <script type="module" src="{{ asset('js/login.js') }}" defer></script>
    <script type="module" src="{{ asset('js/forgotpassword.js') }}" defer></script>
    <meta name="csrf-token" content="{{ csrf_token() }}">
</head>
<body>
    <div class="background">
        <div class="shape"></div>
        <div class="shape"></div>
    </div>

    <form id="login-form" method="POST" action="{{ route('login.authenticate') }}">
        
        <h3>Login</h3>

        <label for="email">Email
            <input type="email" placeholder="Email" name="email" id="email" required>
        </label>

        <label for="password">Password
            <input type="password" placeholder="Password" name="password" id="password" required>
        </label>

        <button id="submit" type="button">Log in</button>

        <div class="social">
            <div class="go">
                <i class="fab fa-google"></i>oogle
            </div>
            <div class="fb">
                <i class="fab fa-facebook"></i>acebook
            </div>
        </div>

        <div class="form">
            <p>Don't have an account? <a href="{{ route('register') }}">Create One</a></p>
            <p><a href="#" id="forgotpassword">Reset Password</a></p>
        </div>

        <input type="hidden" id="idToken" name="idToken">
    </form>


</body>
</html>
