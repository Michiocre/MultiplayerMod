import readline from 'node:readline';
import { S2Server } from './server.js';
import { S2Client } from './client.js';
import fs from 'fs';
import { EOL } from 'os';

let server = {};
let client = {};

let outFile;

function watchFile(filename) {
    let fileSize = fs.statSync(filename).size;
    fs.watchFile(filename, {interval: 10}, (current, previous) => {
        if (current.mtime <= previous.mtime) return;

        let newFileSize = fs.statSync(filename).size;
        let sizeDiff = newFileSize - fileSize;

        if (sizeDiff < 0) {
            fileSize = 0;
            sizeDiff = newFileSize;
        }

        let buffer = Buffer.alloc(sizeDiff);
        let file = fs.openSync(filename, 'r');
        fs.readSync(file, buffer, 0, sizeDiff, fileSize);
        fs.closeSync(file);

        fileSize = newFileSize;

        newData(buffer);
    });
}

if (process.argv.length > 2) {
    try {
        watchFile(process.argv[2]);
        console.log(`Started the process while also watching the file ${process.argv[2]}`)
    } catch (error) {
        console.log(`The file ${process.argv[2]} could not be found, the process has started without watching a file`)
        console.log(`To start watching a file use the "tail" command`);
        console.log(error);
    }
}

if (process.argv.length > 3) {
    try {
        outFile = fs.openSync(process.argv[3], 'w');
        console.log(`Opened file ${process.argv[3]} as the output for incomming messages`)
    } catch (error) {
        console.log(`The file ${process.argv[3]} could not be found, the process has started without outputing to a file`)
        console.log(`To add a file use the "writeTo" command`);
        console.log(error);
    }
}

const consoleIn = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
});

function parseOptions(args, options, freeArgsNeeded) {
    let newOptions = {};
    let argCounter = 1;
    for (let option of options) {
        let i = args.indexOf(option.name);
        if (option.value) {
            if (i != -1) {
                let val = args[i+1];
                newOptions[option.name] = val
                argCounter +=2;
            } else {
                newOptions[option.name] = option.default;
            }
        } else {
            newOptions[option.name] = i != -1;
            argCounter++;
        }

        if (option.required && newOptions[option.name] == null) {
            return [false, null];
        }
    }
    if (args.length - argCounter < freeArgsNeeded) {
        return [false, null];
    }

    return [true, newOptions];
}

function hostAction(args, options) {
    if (!outFile) {
        console.log('You have not specified a file to use as the output of the server, use the command "writeTo"');
        return;
    }
    if (!server?.running && !client?.running) {
        server = new S2Server(options['-p'], outFile);
    } else {
        console.log(`You are currently already a either running a server or connected, stop the current connection before hosting a new server`);
    }
};

function stopAction(args, options) {
    if (server?.running) {
        server.stopServer();
    } else {
        console.log('There is currently no server running');
    }
};

function connectAction(args, options) {
    if (!outFile) {
        console.log('You have not specified a file to use as the output of the client, use the command "writeTo"');
        return;
    }
    if (!server?.running && !client?.running) {
        client = new S2Client(options['-h'], options['-p'], outFile);
    } else {
        console.log(`You are currently already a either running a server or connected, stop the current connection before hosting a new server`);
    }
}

function disconnectAction(args, options) {
    if (client?.running) {
        client.disconnect();
    } else {
        console.log('Currently not connected');
    }
}

function tailAction(args, options) {
    try {
        watchFile(args[1]);
        console.log(`Successfully started watching the file ${args[1]}`)
    } catch (error) {
        console.log(`The file ${args[1]} could not be found`)
    }
}

function writeToAction(args, options) {
    fs.closeSync(outFile);
    try {
        outFile = fs.openSync(args[1], 'w');
        console.log(`Opened file ${args[1]} as the output for incomming messages`)
        if (server?.running) {
            server.setOutFile(outFile);
        }
        if (client?.running) {
            client.setOutFile(outFile);
        }
    } catch (error) {
        console.log(`The file ${args[1]} could not be found`)
    }
}

function newData(data) {
    if (server?.running) {
        server.message(data.toString());
    }

    if (client?.running) {
        client.message(data.toString());
    }
}

let commands = {
    'help': {
        help: '\nUsage: help [command]\n\n' +
            'Arguments:\n' +
            '  command          name of the command you want help with',
        generalHelp: 'help [command]       display help for command',
        options: [],
        action: (args, options) => {
            if (args.length <= 1) {
                console.log('Commands:\n');
                for (let [key, value] of Object.entries(commands)) {
                    console.log('  ' + value.generalHelp);
                }
            } else {
                console.log(commands[args[1]].help);
            }
        }
    },
    'host': {
        help: '\nUsage: host -p <number>\n\n' +
            'Options:\n' +
            '  -p        port the server should start on',
        generalHelp: 'host [options]       starts up a shrek2mp server instance',
        options: [
            {
                name: '-p',
                required: true,
                value: true,
                default: '6000'
            }
        ],
        action: hostAction
    },
    'stop': {
        help: '\nUsage: stop\n',
        generalHelp: 'stop                 stops the currently running server',
        options: [],
        action: stopAction
    },
    'connect': {
        help: '\nUsage: connect -h <host-address> -p <port>\n\n' +
        'Options:\n' +
        '  -h        ip address of the host you want to connect to\n' +
        '  -p        port the server should start on',
        generalHelp: 'connect [options]    connect as a client to a running server',
        options: [
            {
                name: '-h',
                required: true,
                value: true,
                default: 'localhost'
            },
            {
                name: '-p',
                required: true,
                value: true,
                default: '6000'
            }
        ],
        action: connectAction
    },
    'disconnect': {
        help: '\nUsage: disconnect\n',
        generalHelp: 'disconnect           ends the current connection',
        options: [],
        action: disconnectAction
    },
    'tail': {
        help: '\nUsage: tail [filename]\n' +
            '\nArguments:\n' +
            '  tail [filename]  name of the file to be watched',
        generalHelp: 'tail [arguments]     starts watching a file for changes',
        options: [],
        freeArgsNeeded: 1,
        action: tailAction
    },
    'writeTo': {
        help: '\nUsage: writeTo [filename]\n' +
            '\nArguments:\n' +
            '  writeTo [filename]  name of the new output file',
        generalHelp: 'writeTo [arguments]  opens a file as the output for incomming messages',
        options: [],
        freeArgsNeeded: 1,
        action: writeToAction
    },
}

function recursiveCLI() {
    consoleIn.question(`> `, input => {
        if (input.trim() == '') {
            recursiveCLI();
            return;
        }
        let args = input.split(/\s/);
        let command = commands[args[0]];
        if (command == null) {
            console.log('Command "' + args[0] + '" not found\n');
            commands['help'].action(['help']);
        } else {
            let [success, options] = parseOptions(args, command.options, command.freeArgsNeeded || 0);
            if (!success) {
                console.log('Options could not be parsed')
                commands['help'].action(['help', args[0]]);
            } else {
                command.action(args, options);
            }
        }

        recursiveCLI();
    });
}

recursiveCLI();