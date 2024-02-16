# MultiplayerMod

This branch is currently only serves as the external part of a proposed multiplayer mod.  
It only handles the communication between multiple clients and a server.  

Since the input and output of the internal part of the mod is file based this application first starts watching for changes in a given input file.  
When a change is detected we can then send the new content of the file to all the other connected clients.  
This clients will then write the recieved data into their respective output files. These files will then be read by the internal part of the mod.

The communication between clients is handled using socket.io.

# Installation

Run `npm install`

# Usage

Both the server and the client use the same application.  
Start the application using `npm start`. You can hand in the filenames of the input/output files when starting.  

`npm start input.txt output.txt`

You can also bind them after the application has started by typing `tail` or `writeTo` followed by a filename.

You can then start either host or client mode by typing `host` or `connect` followed by the respective ip addresses and port, by default the port will be `6000` and the ip address will be `localhost`.

For more info on all the commands you can type `help` or `help` followed by the name of a command