import utils from './utils.js';
import net from 'net';

class S2Client {
    constructor(host, port, folderPath, eventCallback) {
        this.host = host;
        this.port = port;
        this.running = false;
        this.folderPath = folderPath;

        this.connectedIds = new Set();

        this.socket = new net.Socket();
        this.socket.connect(port, host, () => {
            console.log(`Connection established with ${host}:${port}`);
            this.running = true;
        });

        this.socket.on('data', (data) => {
            let packet;
            try {
                packet = JSON.parse(data);
            } catch (error) {
                console.log('There was a error parsing json: ', error, data);
                return;
            }
            console.log(packet);

            if (packet.type == 'ping') {
                console.log('pong');
                return;
            }

            if (packet.type == 'event') {
                utils.insistentAppend(folderPath + 'Events.S2M', packet.message, (err, message) => {
                    if (err) {
                        console.log(message);
                        return;
                    }
                });
                return;
            }

            utils.insistentAppend(this.folderPath + 'ServerLevel.S2M', packet.level, (err, message) => {
                if (err) {
                    console.log(message);
                    return;
                }
            });

            utils.insistentAppend(this.folderPath + 'ServerPlayers.S2M', packet.player, (err, message) => {
                if (err) {
                    console.log(message);
                    return;
                }
            });

            if (packet.type == 'initServer') {
                let lines = packet.player.split('\r\n');
                for (const line of lines) {
                    let id = line.split('#')[1];
                    this.connectedIds.add(id);
                }

                console.log('Recieved initServer')
                utils.insistentWriteFile(this.folderPath + 'InitServerLevel.S2M', packet.level, (err, message) => {
                    if (err) {
                        eventCallback('!Error Connect');
                        console.error('!!could not write to the InitServerLevel.S2M file', message);
                        return;
                    }
    
                    utils.insistentWriteFile(this.folderPath + 'InitServerPlayers.S2M', packet.player, (err, message) => {
                        if (err) {
                            eventCallback('!Error Connect');
                            console.error('!!could not write to the InitServerPlayers.S2M file', message);
                            return;
                        }
                        eventCallback('!Connected');
                    });
                });
            }
        });
        
        this.socket.on('error', (err) => {
            console.log('Event Error: ', err);
        });

        this.socket.on('end', () => {
            console.log(`Connection has ended`)
            this.running = false;
        });
    }

    disconnect() {
        this.socket.end();
    }

    sendData(data) {
        if (data.type == 'general') {
            let lines = data.player.split('\r\n');
            for (const line of lines) {
                let id = line.split('#')[1];
                if (!this.connectedIds.has(id)) {
                    utils.insistentAppend(this.folderPath + 'InitServerPlayers.S2M', line, (err, message) => {
                        if (err) {
                            console.error('!!could not append new player to the InitServerPlayers.S2M file', message);
                            return;
                        }
                        
                        this.connectedIds.add(id);
                        this.socket.write(JSON.stringify({
                            type: 'newPlayer',
                            player: line
                        }), (err) => {
                            if (err) {
                                console.log('There was an error writing data');
                                return;
                            }
                        });
                    });
                }
            }
        }

        console.log("Data being sent: " + JSON.stringify(data))

        if (!this.socket.destroyed) {
            this.socket.write(JSON.stringify(data), (err) => {
                if (err) {
                    console.log('There was an error writing data');
                    return;
                }
            });
        }
    }
}

export { S2Client }