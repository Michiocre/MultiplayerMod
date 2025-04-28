import utils from './utils.js';
import { S2Server } from './server.js';
import { S2Client } from './client.js';
import { Actor } from './actor.js';
import { performance } from 'perf_hooks';

let server = {};
let client = {};

let playerState = null;
let actorState = [];
let tickState = 0;

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

utils.insistentWriteFile(folderPath + 'Output.S2M', '');
utils.insistentWriteFile(folderPath + 'Input.S2M', '');
utils.insistentWriteFile(folderPath + 'EventInput.S2M', '');

let eventWriteQueue = [];
let mainLock = false;

setInterval(async () => {
    tickStartTime = performance.now();
    if (!mainLock) {
        main();
    }

    if (server?.running) {
        serverMain();
    }
    if (client?.running) {
        clientMain();
    }
}, Math.floor(1000 / 60));

function main() {
    mainLock = true;
    utils.insistentReadFile(folderPath + 'EventOutput.S2M', (err, data, message) => {
        if (err) {
            mainLock = false;
            console.log(message);
            return;
        }

        let lines = data.split('\r\n');
        for (let line of lines) {
            if (line[0] == '#') {
                console.log(line)
                let response = handleEvent(line);
                if (response) {
                    eventWriteQueue.push(response);
                }
            }
        }
        
        if (!(lines[0] == '' && lines[1] == '')) {            
            utils.insistentWriteFile(folderPath + 'EventOutput.S2M', '', (err, message) => {
                if (err) {
                    console.error('!!!could not write to the events file', message);
                    mainLock = false;
                    return;
                }
                mainLock = false;
            });
        } else {
            mainLock = false;
        }

        utils.insistentReadFile(folderPath + 'EventInput.S2M', (err, data, message) => {
            if (err) {
                console.log(message);
                return;
            }
            let lines = data.split('\r\n').concat(eventWriteQueue).filter(el => el.trim() != '').join('\r\n');
            if ((lines + '\r\n') != data) {
                console.log("Contents for eventFile: " + JSON.stringify(lines.trim() + '\r\n'))
                utils.insistentWriteFile(folderPath + 'EventInput.S2M', lines.trim(), (err, message) => {
                    if (err) {
                        console.error('!!!could not write to the events file', message);
                        mainLock = false;
                        return; 
                    };
                });
                eventWriteQueue = [];
            }
        });
    });
}

async function serverMain() {
    utils.insistentReadFile(folderPath + 'Output.S2M', (err, data, message) => {
        if (err) {
            console.log(message);
            return;
        };

        let lines = data.split('\r\n');
        let tick = Number.parseInt(lines.shift().split('#')[1]);

        if (tick <= tickState) {
            return;
        }

        let actors = lines.filter(line => line.trim() != '').map(line => new Actor(line));
        let deletedActors = [];

        // Identify new Actors
        for (const actor of actors) {
            let found = actorState.find(oldActor => oldActor.name === actor.name);
            if (found != undefined) {
                actor.uuid = found.uuid;
                actor.type = found.type;
                found.event = 'found';
            } else {
                actor.uuid = crypto.randomUUID();
                actor.event = 'new';
            }
        }

        for (const oldActor of actorState) {
            if (oldActor.event != 'found') {
                deletedActors.push(oldActor);
            }
        }

        // Try match actors to playerState
        if (playerState.uuid == null) {
            let found = actors.find(actor => actor.name = playerState.actorId);
            if (found) {
                playerState.uuid = found.uuid;
                found.type = playerState.name;
            }
        }
        
        if (sendNext || unlock) {
            sendNext = false;
            sendData({
                type: 'general',
                actors: actors,
                deletedActors: deletedActors
            });
        }

        
        actorState = actors;
        tickState = tick;
        
        if (tick % 600 == 0) {
            console.log({
                actorState,
                playerState,
                tickState
            });
        }
        //console.log(`Reading Client took ${performance.now() - tickStartTime} milliseconds`)
    });
}

async function clientMain() {
    if (client.state == 'idle') {
        return;
    }
    utils.insistentReadFile(folderPath + 'Output.S2M', (err, data, message) => {
        if (err) {
            console.log(message);
            return;
        };

        let lines = data.split('\r\n');
        let tick = Number.parseInt(lines.shift().split('#')[1]);

        if (tick <= tickState) {
            return;
        }

        let actors = lines.filter(line => line.trim() != '').map(line => new Actor(line));
        let deletedActors = [];

        // Identify new Actors
        for (const actor of actors) {
            let found = actorState.find(oldActor => oldActor.name === actor.name);
            if (found != undefined) {
                actor.uuid = found.uuid;
                actor.type = found.type;
                found.event = 'found';
            } else {
                if (client.state != 'init') {
                    actor.uuid = crypto.randomUUID();
                    actor.event = 'new';
                }
            }
        }

        for (const oldActor of actorState) {
            if (oldActor.event != 'found') {
                deletedActors.push(oldActor);
            }
        }

        // Try match actors to playerState
        if (playerState.uuid == null) {
            let found = actors.find(actor => actor.name = playerState.actorId);
            if (found) {
                playerState.uuid = found.uuid;
                found.type = playerState.name;

                client.state = 'connecting';
            }
        }
        
        if (client.state == 'running') {
            if (sendNext || unlock) {
                sendNext = false;
                sendData({
                    type: 'general',
                    actors: actors,
                    deletedActors: deletedActors
                });
            }
        }
        
        actorState = actors;
        tickState = tick;
        
        if (tick % 600 == 0) {
            console.log({
                actorState,
                tickState
            });
        }
        //console.log(`Reading Client took ${performance.now() - tickStartTime} milliseconds`)
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

        tickState = 0;
        actorState = [];

        playerState = {
            name: args[2],
            actorId: args[3]
        };

        server = new S2Server(Number.parseInt(args[1]) || 6400, eventCallback, (data) => {
            let packet;
            try {
                packet = JSON.parse(data);
            } catch (error) {
                console.log('There was a error parsing json: ', error, data);
                return;
            }
            //console.log(packet);

            if (packet.type == 'ping') {
                console.log('pong');
                return;
            }

            if (packet.type == 'event') {
                eventCallback(packet.message);
                return;
            }

            if (packet.type == 'newPlayer') {
                eventCallback('!ClientConnected\r\n!Chat#Server#New Client Connected');
                return;
            }
            
            utils.insistentAppend(folderPath + 'ServerLevel.S2M', packet.level, (err, message) => {
                if (err) {
                    console.log(message);
                    return;
                }
            });

        });
        
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

        console.log(args);

        tickState = 0;
        actorState = [];

        playerState = {
            name: args[3],
            actorId: args[4]
        };

        client = new S2Client(args[1] || '127.0.0.1', args[2] || 8989, eventCallback, (data) => {
            if (client.state == 'idle' || client.state == 'init' || client.state == 'connecting2') {
                return;
            }

            let packet;
            try {
                packet = JSON.parse(data);
            } catch (error) {
                console.log('There was a error parsing json: ', error, data);
                return;
            }
            //console.log(packet);

            if (packet.type == 'ping') {
                console.log('pong');
                return;
            }

            if (packet.type == 'event') {
                eventCallback(packet.message);
                return;      
            }

            console.log(packet);
            if (client.state == 'connecting') {
                client.state = 'connecting2'
            }
        });

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
    
            sendData({
                type: 'event',
                message: message
            });
        }
        return;
    }

    if (args[0].startsWith('#CLIENT_DESTROY')) {
        if (client?.running) {
            let message = "!" + args.join('#').substring(1);

            // DO i have to do this???? how ? translate ??
            // utils.removeLineByStart(folderPath + 'InitServerLevel.S2M', args[0].split('#')[2], (err, message) => {
            //     if (err) {
            //         console.log(message);
            //     }
            // });
    
            sendData({
                type: 'event',
                message: message
            });
        }
        return;
    }

    if (args[0].startsWith('#CLIENT_CREATE')) {
        if (client?.running) {
            let message = "!" + args.join('#').substring(1);
    
            sendData({
                type: 'event',
                message: message
            });
        }
        return;
    }

    if (args[0].startsWith('#HOST_CREATE')) {
        if (server?.running) {
            let message = "!" + args.join('#').substring(1);
    
            sendData({
                type: 'event',
                message: message
            });
        }
        return;
    }

    console.log('New unhandled event message: ' + event)
}