import { io } from "socket.io-client";
import fs from 'fs';

class S2Client {
    constructor(host, port, outFile) {
        this.host = host;
        this.port = port;
        this.running = false;
        this.outFile = outFile;

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
            console.log(data);
            fs.writeSync(this.outFile, data);
        });
    }

    disconnect() {
        this.socket.disconnect();
    }

    message(data) {
        console.log('Sending:     ' + data);
        this.socket.emit('message', data);
    }
}

export { S2Client }