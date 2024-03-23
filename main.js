import fs from 'fs';
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

setInterval(async () => {
    tickStartTime = performance.now()
    main();
}, Math.floor(1000 / 60));

async function main() {
    fs.readFile(folderPath + 'Client.S2M', 'utf8', (err, data) => {
        if (err) throw err;
        sendData(data);
        //console.log(`Reading Client took ${performance.now() - tickStartTime} milliseconds`)
    });

    fs.readFile(folderPath + 'Events.S2M', 'utf8', (err, data) => {
        if (err) throw err;
        let lines = data.split('\n');
        for (let i = 0; i < lines.length; i++) {
            if (lines[i][0] == '#') {
            let event = lines[i].substring(1);
            handleEvent(event);
            lines[i] = '!' + event;
            }
        }
        let newData = lines.join('\n');
        if (newData != data) {
            fs.writeFile(folderPath + 'Events.S2M', newData, (err) => {
                if (err) throw err;
            });
        }
    });
}

async function sendData(data) {
    if (server?.running) {
        server.sendData(data);
    }
    if (client?.running) {
        client.sendData(data);
    }
}

async function handleEvent(event) {
  if (event.startsWith('host')) {
    if (server?.running || client?.running) {
        console.log('there is already a connection');
        return;
    }
    server = new S2Server(8989, folderPath);
    return
  }

  if (event.startsWith('stop')) {
    server.stopServer();
    return; 
  }

  if (event.startsWith('connect')) {
    if (server?.running || client?.running) {
        console.log('there is already a connection');
        return;
    }
    client = new S2Client('127.0.0.1', 8989, folderPath);
    return; 
  }

  if (event.startsWith('disconnect')) {
    client.disconnect();
    return; 
  }
}