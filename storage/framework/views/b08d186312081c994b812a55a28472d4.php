

<?php $__env->startSection('content'); ?>
    <div class="container">
        <h2>Edit User</h2>
        <form action="<?php echo e(route('users.update', $user->uid)); ?>" method="POST">
            <?php echo csrf_field(); ?>
            <?php echo method_field('PUT'); ?>
            <div class="mb-3">
                <label for="displayName" class="form-label">Display Name</label>
                <input type="text" class="form-control" id="displayName" name="displayName" value="<?php echo e($user->displayName); ?>">
            </div>
            <div class="mb-3">
                <label for="email" class="form-label">Email address</label>
                <input type="email" class="form-control" id="email" name="email" value="<?php echo e($user->email); ?>">
            </div>
            <button type="submit" class="btn btn-primary">Update User</button>
        </form>
    </div>
<?php $__env->stopSection(); ?>

<?php echo $__env->make('layouts.layout', \Illuminate\Support\Arr::except(get_defined_vars(), ['__data', '__path']))->render(); ?><?php /**PATH C:\Users\Paris Buroko\Documents\School Matters\Third year\Semester One\ICS Project I\App Develop\Admin\admin\resources\views/edit.blade.php ENDPATH**/ ?>