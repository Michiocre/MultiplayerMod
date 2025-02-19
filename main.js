import utils from './utils.js';
import { S2Server } from './server.js';
import { S2Client } from './client.js';
import { performance } from 'perf_hooks';

let server = {};
let client = {};

let tickStartTime;
let sendNext = false;
let unlock = false;

let folderPath = './S2Multi/'
if (process.argv.length > 2) {
    folderPath = process.argv[2];

    let stdin = process.openStdin();
    stdin.addListener("data", function(d) {
        let input = d.toString().trim();

        if (input == 'send') {
            sendNext = true;
        }
        if (input == 'unlock') {
            unlock = true;
        }
        if (input == 'lock') {
            unlock = false;
        }
    });
}

utils.insistentWriteFile(folderPath + 'Events.S2M', '');
utils.insistentWriteFile(folderPath + 'ServerLevel.S2M', '');
utils.insistentWriteFile(folderPath + 'ServerPlayers.S2M', '');

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


            if (sendNext || unlock) {
                sendNext = false;
                sendData({
                    type: 'general',
                    level: levelData,
                    player: playerData
                });
            }
            //console.log(`Reading Client took ${performance.now() - tickStartTime} milliseconds`)
        });
    });

    utils.insistentReadFile(folderPath + 'Events.S2M', (err, data, message) => {
        if (err) {
            console.log(message);
            return;
        };

        let lines = data.split('\r\n').concat(eventWriteQueue);
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

        let newData = newLines.join('\r\n');

        if (newData != data) {
            console.log("Contents for eventFile: " + JSON.stringify(newData.trim() + '\r\n'))
            utils.insistentWriteFile(folderPath + 'Events.S2M', newData, (err, message) => {
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
            return '!Chat#Server#Could not start the server';
        }

        server = new S2Server(Number.parseInt(args[1]) || 8989, folderPath, eventCallback);
        
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
    }

    if (args[0] == '#Ping') {
        if (!server?.running && !client?.running) {
            console.log('there is no connection');
            return '!Error Ping';
        }

        sendData({
            type: 'ping'
        });
        return '!Ping';
    }

    if (args[0] == '#Disconnect') {
        if (!server?.running && !client?.running) {
            console.log('there is no connection');
            return;
        }

        if (client?.running) {
            client.disconnect();
            return '!Disconnected';
        } 
    }

    if (args[0].startsWith('#Chat')) {
        let message = "!" + args.join(' ').substring(1);

        sendData({
            type: 'event',
            message: message
        });
        return;
    }

    if (args[0].startsWith('#GCC')) {
        let message = "!" + args.join(' ').substring(1);

        eventWriteQueue.push(message);

        sendData({
            type: 'event',
            message: message
        });
        return;
    }

    if (args[0].startsWith('#HOST_DESTROY')) {
        if (server?.running) {
            let message = "!" + args.join('#').substring(1);

            utils.removeLineByStart(folderPath + 'InitServerLevel.S2M', args[0].split('#')[2], (err, message) => {
                if (err) {
                    console.log(message);
                }
            });
    
            if (server?.running) {
                sendData({
                    type: 'event',
                    message: message
                });
            }
        }
        return;
    }

    console.log('New unhandled event message: ' + event)
}