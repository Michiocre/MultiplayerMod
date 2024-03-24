import utils from './utils.js';
import net from 'net';

class S2Client {
    constructor(host, port, folderPath, eventCallback) {
        this.host = host;
        this.port = port;
        this.running = false;

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

            if (packet.type == 'ping') {
                console.log('pong');
                return;
            }

            utils.insistentAppend(folderPath + 'ServerLevel.S2M', packet.level, (err, message) => {
                if (err) {
                    console.log(message);
                    return;
                }
            });

            utils.insistentAppend(folderPath + 'ServerPlayers.S2M', packet.player, (err, message) => {
                if (err) {
                    console.log(message);
                    return;
                }
            });

            if (packet.type == 'initServer') {
                utils.insistentWriteFile(folderPath + 'InitServerLevel.S2M', packet.level.trim(), (err, message) => {
                    if (err) {
                        eventCallback('!Error Connect');
                        console.error('!!could not write to the InitServerLevel.S2M file', message);
                        return;
                    }
    
                    utils.insistentWriteFile(folderPath + 'InitServerPlayers.S2M', packet.player.trim(), (err, message) => {
                        if (err) {
                            eventCallback('!Error Connect');
                            console.error('!!could not write to the InitServerPlayers.S2M file', message);
                            return;
                        }

                        eventCallback('!Connected');
                    })
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
        if (!this.socket.destroyed) {
            this.socket.write(data, (err) => {
                if (err) {
                    console.log('There was an error writing data');
                    return;
                }
            });
        }
    }
}

export { S2Client }