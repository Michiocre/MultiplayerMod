import { io } from "socket.io-client";
import fs from 'fs';

class S2Client {
    constructor(host, port, folderPath) {
        this.host = host;
        this.port = port;
        this.running = false;

        this.socket = io(`http://${host}:${port}`);
        this.socket.connect();

        this.socket.on("connect", () => {
            console.log(`Connection established with ${host}:${port}`);
            this.running = true;
        });

        this.socket.on('disconnect', () => {
            console.log(`Connection has ended`)
            this.running = false;
        });

        this.socket.on('message', (data) => {
            fs.writeFile(folderPath + 'Server.S2M', data, (err) => {
                if (err) throw err;
            });
        });
    }

    disconnect() {
        this.socket.disconnect();
    }

    sendData(data) {
        this.socket.emit('message', data);
    }
}

export { S2Client }