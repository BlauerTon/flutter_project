

<?php $__env->startSection('content'); ?>
<script type="module" src="<?php echo e(asset('js/graph.js')); ?>" defer></script>
    <div class="container">
        <h2>Admin Dashboard</h2>
        <div class="row mb-4">
            <div class="col-md-4">
                <div class="card text-center" id="userCountCard" style="cursor: pointer;">
                    <div class="card-body">
                        <h5 class="card-title">Total Users</h5>
                        <p class="card-text" id="userCount">Loading...</p>
                    </div>
                </div>
            </div>
        </div>
        <button class="btn btn-primary mb-4" style="background-color: #0e2238; border-color: #0e2238;" onclick="downloadChartAsPDF()">Download</button>
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.4/Chart.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.4.0/jspdf.umd.min.js"></script>

    <canvas id="myChart" style="width:100%;max-width:700px"></canvas>

    <script>
        var xyValues = [{
                x: 'Day 1',
                y: 7
            },
            {
                x: 'Day 2',
                y: 8
            },
            {
                x: 'Day 3',
                y: 8
            },
            {
                x: 'Day 4',
                y: 9
            },
            {
                x: 'Day 5',
                y: 9
            },
            {
                x: 'Day 6',
                y: 9
            },
            {
                x: 'Day 7',
                y: 4
            },
            {
                x: 'Day 8',
                y: 11
            },
            {
                x: 'Day 9',
                y: 14
            },
            {
                x: 'Day 10',
                y: 0
            },
            {
                x: 'Day 11',
                y: 15
            },
            {
                x: 'Day 12',
                y: 16
            },
            {
                x: 'Day 13',
                y: 1
            },
            {
                x: 'Day 14',
                y: 18
            },
            {
                x: 'Day 15',
                y: 19
            },
            {
                x: 'Day 16',
                y: 9
            },
            {
                x: 'Day 17',
                y: 21
            },
            {
                x: 'Day 18',
                y: 22
            },
            {
                x: 'Day 19',
                y: 7
            },
            {
                x: 'Day 20',
                y: 24
            },
            {
                x: 'Day 21',
                y: 25
            },
            {
                x: 'Day 22',
                y: 6
            },
            {
                x: 'Day 23',
                y: 27
            },
            {
                x: 'Day 24',
                y: 17
            },
            {
                x: 'Day 25',
                y: 29
            },
            {
                x: 'Day 26',
                y: 30
            },
            {
                x: 'Day 27',
                y: 14
            },
            {
                x: 'Day 28',
                y: 32
            },
            {
                x: 'Day 29',
                y: 33
            },
            {
                x: 'Day 30',
                y: 20
            },
        ];

        new Chart("myChart", {
            type: "line", 
            data: {
                labels: xyValues.map(val => val.x), 
                datasets: [{
                    label: 'User Count Over Time',
                    backgroundColor: 'rgba(0, 0, 255, 0.1)', 
                    borderColor: 'rgb(0, 0, 255)', 
                    pointRadius: 4,
                    pointBackgroundColor: "rgb(0,0,255)",
                    data: xyValues.map(val => val.y) 
                }]
            },
            options: {
                legend: {
                    display: true
                },
                scales: {
                    xAxes: [{
                        type: 'category', 
                        ticks: {
                            beginAtZero: true,
                            autoSkip: false 
                        }
                    }],
                    yAxes: [{
                        ticks: {
                            beginAtZero: true,
                            autoSkip: false 
                        }
                    }],
                }
            }
        });

        function downloadChartAsPDF() {
            const canvas = document.getElementById('myChart');
            const canvasImg = canvas.toDataURL("image/png", 1.0);
            const {
                jsPDF
            } = window.jspdf;
            const pdf = new jsPDF();

            pdf.addImage(canvasImg, 'PNG', 10, 10, canvas.width * 0.15, canvas.height * 0.2);
            pdf.save('chart.pdf');
        }
    </script>
<?php $__env->stopSection(); ?>

<?php echo $__env->make('layouts.layout', \Illuminate\Support\Arr::except(get_defined_vars(), ['__data', '__path']))->render(); ?><?php /**PATH C:\Users\Paris Buroko\Documents\School Matters\Third year\Semester One\ICS Project I\App Develop\flutter_project\admin\resources\views/graph.blade.php ENDPATH**/ ?>