<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Account</title>
    <link rel="stylesheet" href="{{ asset('css/app.css') }}">
    <script type="module" src="{{ asset('js/register.js') }}" defer></script>
    <meta name="csrf-token" content="{{ csrf_token() }}">
</head>
<body>
    <div class="background">
        <div class="shape"></div>
        <div class="shape"></div>
    </div>

    <form id="registerForm">
        <h3>Create Account</h3>

        <label for="name">Name
            <input type="text" id="name" name="name" placeholder="Full name" required>
        </label>

        <label for="email">Email
            <input type="email" id="email" name="email" placeholder="Email address" required>
        </label>

        <label for="password">Password
            <input type="password" id="password" name="password" placeholder="Password" required>
        </label>

        <button type="submit">Create Account</button>

        <div class="form">
            <p>Have an account? <a href="{{ 'login'}}">Login Here</a></p>
        </div>
    </form>
</body>
</html>
