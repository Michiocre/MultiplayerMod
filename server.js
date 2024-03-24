import fs from 'fs';
import net from 'net';

class S2Server {
    constructor(port, folderPath, eventCallback) {
        this.sockets = new Set();
        this.running = false;

        this.server = net.createServer((socket) => {
            console.log('Connection from', socket.remoteAddress, 'port', socket.remotePort);
            this.sockets.add(socket);

            fs.readFile(folderPath + 'InitServerLevel.S2M', 'utf8', (err, levelData) => {
                if (err) {
                    return console.log('InitServerLevel.S2M couldnt be opened, try again next tick.');
                };
                fs.readFile(folderPath + 'InitServerPlayers.S2M', 'utf8', (err, playerData) => {
                    if (err) {
                        return console.log('InitServerPlayers.S2M couldnt be opened, try again next tick.');
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
                    return console.log('there was a error parsing json: ', error);
                }

                if (packet.type == 'ping') {
                    console.log('pong');
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
            socket.write(data);
        });
    }
}

export { S2Server }