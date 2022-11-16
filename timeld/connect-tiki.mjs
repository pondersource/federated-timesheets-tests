import cp from 'child_process'
var spawn = cp.spawn;

var p = spawn('timeld',['admin']);

setTimeout(function() {
    p.stdout.on('data',function (data) {
        console.log(data.toString());
    });
    p.stdin.write("add connector timeld-tiki --ts timesheet --config.api 'http://tikiwiki.local/api/trackers/1/items' --config.token 'testnet-supersecret-token'\n");
    setTimeout(function() {
       p.stdin.write("exit\n");
       p.stdin.end();
    }, 3000);
}, 3000);
