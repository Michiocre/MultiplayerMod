import fs from 'fs';
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
                return console.log('there was a error parsing json: ', error);
            }

            if (packet.type == 'ping') {
                return console.log('pong');
            }

            
            fs.readFile(folderPath + 'ServerLevel.S2M', (err, data) => {
                if (err) {
                    return console.log('ServerLevel.S2M couldnt be oppened, try again next tick.');
                };
                fs.writeFile(folderPath + 'ServerLevel.S2M', (data + packet.level).trim() + '\r\n' , (err) => {
                    if (err) {
                        return console.error('!!could not write to the ServerLevel.S2M file');
                    };
                });
            });

            fs.readFile(folderPath + 'ServerPlayers.S2M', (err, data) => {
                if (err) {
                    return console.log('ServerPlayers.S2M couldnt be oppened, try again next tick.');
                };
                fs.writeFile(folderPath + 'ServerPlayers.S2M', (data + packet.player).trim() + '\r\n' , (err) => {
                    if (err) {
                        return console.error('!!could not write to the ServerPlayers.S2M file');
                    };
                });
            });

            if (packet.type == 'initServer') {
                fs.writeFile(folderPath + 'InitServerLevel.S2M', packet.level.trim() + '\r\n', (err) => {
                    if (err) {
                        eventCallback('!Error Connect');
                        return console.error('!!could not write to the InitServerLevel.S2M file');
                    };
    
                    fs.writeFile(folderPath + 'InitServerPlayers.S2M', packet.player.trim() + '\r\n', (err) => {
                        if (err) {
                            eventCallback('!Error Connect');
                            return console.error('!!could not write to the InitServerPlayers.S2M file');
                        };

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
        if (!this.socket.destroyed) {
            this.socket.write(data, (err) => {
                if (err) {
                    console.log('there was an error writing data');
                }
            });
        }
    }
}

export { S2Client }