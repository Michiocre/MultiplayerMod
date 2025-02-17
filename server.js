import utils from './utils.js';
import net from 'net';
import fs from 'fs';

class S2Server {
    constructor(port, folderPath, eventCallback) {
        this.sockets = new Set();
        this.running = false;

        this.server = net.createServer((socket) => {
            console.log('Connection from', socket.remoteAddress, 'port', socket.remotePort);
            this.sockets.add(socket);

            utils.insistentReadFile(folderPath + 'InitServerLevel.S2M', (err, levelData, message) => {
                if (err) {
                    console.log(message);
                    return;
                };

                utils.insistentReadFile(folderPath + 'InitServerPlayers.S2M', (err, playerData, message) => {
                    if (err) {
                        console.log(message);
                        return;
                    };
                    
                    socket.write(
                        JSON.stringify({
                            type: 'initServer',
                            level: levelData,
                            player: playerData
                        })
                    );
                });
            });

            socket.on('data', (data) => {
                this.sockets.forEach(other => {
                    if (other != socket) {
                        other.write(data);
                    }
                });
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
                    eventCallback(packet.message);
                    return;
                }

                if (packet.type == 'newPlayer') {
                    utils.insistentAppend(folderPath + 'InitServerPlayers.S2M', packet.player, (err, message) => {
                        if (err) {
                            console.log(message);
                            return;
                        }
                    });

                    eventCallback('!ClientConnected\r\n!Chat#Server#New Client Connected');
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
            })

            socket.on('end', () => {
                console.log('Closed', socket.remoteAddress, 'port', socket.remotePort)
                this.sockets.delete(socket);
            });

            socket.on('error', (err) => {
                console.log('Socket Event Error: ', err);
                this.sockets.delete(socket);
            });
        });

        this.server.listen(port, '127.0.0.1', 10, () => {
            eventCallback('!Start')
            console.log(`Listening on port ${port}`);
            this.running = true;
        });
    }

    stopServer() {
        this.sockets.forEach(socket => {
            socket.end();
        });
        this.server.close();
        this.running = false;
        console.log('Server has been stopped');
    }

    sendData(data) {
        this.sockets.forEach(socket => {
            socket.write(JSON.stringify(data));
        });
    }
}

export { S2Server }