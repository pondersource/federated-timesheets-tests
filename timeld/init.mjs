import cp from 'child_process'
import fetch from 'node-fetch'
var spawn = cp.spawn;

var a = spawn('timeld',['config', '--gateway', 'http://timeld-gateway.local:8080']);
var b = spawn('timeld',['config', '--user', 'prejournal']);
setTimeout(function() {
    var p = spawn('timeld',['admin']);
    p.stdout.on('data',function (data) {
    });

    p.stdin.write('yvo@muze.nl\n');

    setTimeout(function() {
        fetch("http://mailhog.local:8025/api/v2/messages")
        .then(function(response) {
            return response.json();
        })
        .then(function(messages) {
            var message = messages.items.pop();
            var body = message.Content.Body;
            var code = body.match(/code is (\d+)/)[1];
            return code;
        })
        .then(function(code) {
            p.stdin.write(code + "\n");
            setTimeout(function() {
                p.stdout.on('data',function (data) {
                    console.log(data.toString())
                        p.stdout.on('data',function (data) {
                    });
                });
                p.stdin.write("key\n");
                p.stdin.write("exit\n");
                p.stdin.end();
            }, 1000);
        });
    }, 4000);
}, 2000);
