import utils from './utils.js';
import { S2Server } from './server.js';
import { S2Client } from './client.js';
import { performance } from 'perf_hooks';

let server = {};
let client = {};

let tickStartTime;

let folderPath = './S2Multi/'
if (process.argv.length > 2) {
   folderPath = process.argv[2];
}

let eventWriteQueue = [];

setInterval(async () => {
    tickStartTime = performance.now()
    main();
}, Math.floor(1000 / 60));

async function main() {
    utils.insistentReadFile(folderPath + 'ClientLevel.S2M', (err, levelData, message) => {
        if (err) {
            console.log(message);
            return;
        };

        utils.insistentReadFile(folderPath + 'ClientPlayers.S2M', (err, playerData, message) => {
            if (err) {
                console.log(message);
                return;
            };

            sendData(JSON.stringify({
                type: 'general',
                level: levelData,
                player: playerData
            }));
            //console.log(`Reading Client took ${performance.now() - tickStartTime} milliseconds`)
        });
    });

    utils.insistentReadFile(folderPath + 'Events.S2M', (err, data, message) => {
        if (err) {
            console.log(message);
            return;
        };

        let lines = data.split('\n').concat(eventWriteQueue);
        eventWriteQueue = [];
        let newLines = [];
        for (let line of lines) {
            if (line[0] == '#') {
                let response = handleEvent(line);
                if (response) {
                    newLines.push(response);
                }
            } else {
                newLines.push(line);
            }
        }

        let newData = newLines.join('\n');
        if (newData != data) {
            console.log(JSON.stringify(newData.trim() + '\n'));

            utils.insistentWriteFile(folderPath + 'Events.S2M', newData.trim(), (err, message) => {
                if (err) {
                    console.error('!!!could not write to the events file', message);
                    return; 
                };
            });
        }
    });
}

function sendData(data) {
    if (server?.running) {
        server.sendData(data);
    }
    if (client?.running) {
        client.sendData(data);
    }
}

function eventCallback(event) {
    console.log('Writing "', event, '" to the events file');
    eventWriteQueue.push(event);
}

function handleEvent(event) {
    let args = event.trim().split(' ');
    if (args[0] == '#Start') {
        if (server?.running || client?.running) {
            console.log('There is already a connection');
            return '!Error Start';
        }

        server = new S2Server(args[1] || 8989, folderPath, eventCallback);
        return;
    }

    if (args[0] == '#Stop') {
        if (!server?.running) {
            console.log('there is no running server');
            return '!Stop';
        }
        server.stopServer();
        return '!Stop';
    }

    if (args[0] == '#Connect') {
        if (server?.running || client?.running) {
            console.log('there is already a connection');
            return '!Connect Error';
        }
        client = new S2Client(args[1] || '127.0.0.1', args[2] || 8989, folderPath, eventCallback);

        return;

        // fs.readFile(folderPath + 'InitClient.S2M', 'utf8', (err, data) => {
        //     if (err) {
        //         return console.log('File couldnt be opened, try again next tick.');
        //     };

        //     client.sendData('initClient', data);
        // });
    }

    if (args[0] == '#Ping') {
        if (!server?.running && !client?.running) {
            console.log('there is no connection');
            return '!Error Ping';
        }

        sendData(JSON.stringify({
            type: 'ping'
        }));
        return '!Ping';
    }

    if (args[0] == '#Disconnect') {
        if (!server?.running && !client?.running) {
            console.log('there is no connection');
            return '!Error Disconnect';
        }
        client.disconnect();
        return '!Disconnected'; 
    }
}