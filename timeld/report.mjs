import cp from 'child_process'
var spawn = cp.spawn;

var p = spawn('timeld',['open', 'timesheet']);

setTimeout(function() {
    p.stdout.on('data',function (data) {
        console.log(data.toString());
    });
    p.stdin.write("report\n");
    setTimeout(function() {
       p.stdin.write("exit\n");
       p.stdin.end();
    }, 3000);
}, 3000);

