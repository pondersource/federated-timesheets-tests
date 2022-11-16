import cp from 'child_process'
var spawn = cp.spawn;

var p = spawn('timeld',['admin']);

setTimeout(function() {
    p.stdout.on('data',function (data) {
        console.log(data.toString());
    });
    p.stdin.write("add connector timeld-prejournal --ts timesheet --config.api 'http://prejournal.local/v1/' --config.user 'alice' --config.key 'alice123' --config.client 'Federated timesheets tests'\n");
    setTimeout(function() {
       p.stdin.write("exit\n");
       p.stdin.end();
    }, 3000);
}, 3000);
