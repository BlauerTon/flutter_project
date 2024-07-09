<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Account</title>
    <link rel="preconnect" href="https://fonts.gstatic.com"> 
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="{{ asset('css/app.css') }}">
    <script type="module" src="{{ asset('js/register.js') }}" defer></script>
    <meta name="csrf-token" content="{{ csrf_token() }}">

</head>
<body>
    <div class="background">
        <div class="shape"> </div>
        <div class="shape"> </div>
    </div>

    <form>
        <h3>Create Account</h3>

        <label for="name"> Name 
            <input type="name" placeholder="Full name" id="name" required>
        </label>

        <label for="username"> Email 
            <input type="email" placeholder="Email or Phone" id="email" required>
        </label>

        <label for="password">Password 
            <input type="password" placeholder="Password" id="password" required>
        </label>

        <button id="submit" type="submit">Create Account</button>

        <div class="social">
            <div class="go" id="google">
                <i class="fab fa-google"></i>oogle
            </div>
            <div class="fb" id="facebook">
            <i class="fab fa-facebook"></i>acebook
            </div>
        </div>

        <div class="form">
            <p>Have an account? <a href="{{'login'}}">Login Here</a></p>
        </div>
    </form>
</body>
</html>
