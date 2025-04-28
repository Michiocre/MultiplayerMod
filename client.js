import utils from './utils.js';
import net from 'net';

class S2Client {
    constructor(host, port, eventCallback, dataHandler) {
        this.host = host;
        this.port = port;
        this.running = false;
        this.state = 'idle';

        this.connectedIds = new Set();

        this.socket = new net.Socket();
        console.log('Created new client')
        this.socket.connect(port, host, () => {
            console.log(`Connection established with ${host}:${port}`);
            this.running = true;
            this.state = 'init';
        });

        this.socket.on('data', dataHandler);
        
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