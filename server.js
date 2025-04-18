import net from 'net';

class S2Server {
    constructor(port, eventCallback, dataHandler) {
        this.sockets = new Set();
        this.running = false;

        this.server = net.createServer((socket) => {
            console.log('Connection from', socket.remoteAddress, 'port', socket.remotePort);
            this.sockets.add(socket);

            socket.on('data', dataHandler);

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