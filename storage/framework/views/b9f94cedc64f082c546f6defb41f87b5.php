<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Account</title>
    <link rel="stylesheet" href="<?php echo e(asset('css/app.css')); ?>">
    <script type="module" src="<?php echo e(asset('js/register.js')); ?>" defer></script>
    <meta name="csrf-token" content="<?php echo e(csrf_token()); ?>">
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
            <p>Have an account? <a href="<?php echo e('login'); ?>">Login Here</a></p>
        </div>
    </form>
</body>
</html>
<?php /**PATH C:\Users\Paris Buroko\Documents\School Matters\Third year\Semester One\ICS Project I\App Develop\flutter_project\admin\resources\views/register.blade.php ENDPATH**/ ?>