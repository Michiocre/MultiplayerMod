import express from 'express';
import http from 'http';
import fs from 'fs';
import { Server } from 'socket.io';

class S2Server {
    constructor(port, outFile) {
        this.app = express();
        this.server = http.createServer(this.app);
        this.io = new Server(this.server);
        this.outFile = outFile;

        this.sockets = new Set();
        this.running = false;

        this.io.on('connection', (socket) => {
            console.log(`User with id [${socket.id}] has connected`);
            this.sockets.add(socket);

            socket.on('disconnect', (reason) => {
                console.log(`User with id [${socket.id}] has disconnected due to "${reason}"`);
                this.sockets.delete(socket);
            });

            socket.on('message', (data) => {
                socket.broadcast.emit('message', data);
                fs.writeSync(this.outFile, data);
            })
        });

        this.server.listen(port, () => {
            console.log(`listening on port ${port}`);
            this.running = true;
        }).on('error', (error) => {
            console.log('Could not start server');
            console.log(`Error Code: ${error.code}`);
        });
    }

    stopServer() {
        this.sockets.forEach(socket => {
            socket.disconnect();
        });
        this.server.close();
        this.running = false;
        console.log('Server has been stopped');
    }

    message(data) {
        this.io.emit('message', data);
    }

    setOutFile(outFile) {
        this.outFile = outFile;
    }
}

export { S2Server }