<?php $__env->startSection('content'); ?>
<script type="module" src="<?php echo e(asset('js/dashboard.js')); ?>" defer></script>

<h3 class="fw-bold fs-4 my-3">Users</h3>
<div class="row">
    <div class="col-12">
        <table class="table table-striped">
            <thead>
                <tr class="highlight">
                    <th scope="col">#</th>
                    <th scope="col">Name</th>
                    <th scope="col">Email</th>
                    <th scope="col">Actions</th>
                </tr>
            </thead>
            <tbody id="userTableBody">
                <?php if(isset($users)): ?>
                    <?php $__empty_1 = true; $__currentLoopData = $users; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $user): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); $__empty_1 = false; ?>
                        <tr>
                            <th scope="row"><?php echo e($loop->iteration); ?></th>
                            <td><?php echo e($user->displayName); ?></td>
                            <td><?php echo e($user->email); ?></td>
                            <td>
                                <a href="<?php echo e(route('users.edit', $user->uid)); ?>" class="btn btn-sm btn-primary">Edit</a>
                                <form action="<?php echo e(route('users.destroy', $user->uid)); ?>" method="POST" style="display: inline;">
                                    <?php echo csrf_field(); ?>
                                    <?php echo method_field('DELETE'); ?>
                                    <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Are you sure you want to delete this user?')">Delete</button>
                                </form>
                            </td>
                        </tr>
                    <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); if ($__empty_1): ?>
                        <tr>
                            <td colspan="4">No users found.</td>
                        </tr>
                    <?php endif; ?>
                <?php endif; ?>
            </tbody>
        </table>
    </div>
</div>
<?php $__env->stopSection(); ?>

<?php echo $__env->make('layouts.layout', \Illuminate\Support\Arr::except(get_defined_vars(), ['__data', '__path']))->render(); ?><?php /**PATH C:\Users\Paris Buroko\Documents\School Matters\Third year\Semester One\ICS Project I\App Develop\flutter_project\admin\resources\views/welcome.blade.php ENDPATH**/ ?>