# MultiplayerMod

This branch is currently only serves as the external part of a proposed multiplayer mod.  
It only handles the communication between multiple clients and a server.  

The communication between the internal and external Part of the Mod is handled through a set of files.
Here is a overview:
- `ClientLevel.S2M` - From Internal to External - Contains new Information about the state of the Level
- `ClientPlayers.S2M` - From Internal to External - Contains new Information about the state of Players
- `InitServerLevel.S2M` - From Internal to External - Contains the Initial State of the Level to be sent on new connections
- `InitServerPlayers.S2M` - From Internal to External - Contains the Initial State of the Players to be sent on new connections
- `ServerLevel.S2M` - From External to Internal - Contains new incomming Information about the Level from other clients
- `ServerPlayers.S2M` - From External to Internal - Contains new incomming Information about the Players from other clients
- `Event.S2M` - Bidirectional - Contains Information about important events, like initializing or connecting to a server.

# Installation

Run `npm install`

# Usage

Run the application by starting `main.js` or just running `npm start`.  
The program will either look for the files in the `S2Multi` directory from where it is executed or it will search a path given as its first argument.  
`npm start "C:/Shrek/System/S2Multi/"`  

If you see the message `No file, so stopped retrying after 1 attempt` pop up a lot, that means one of the files could not be found.
When no message appears that means the application is running and waiting for a event from the internal part of the mod to start working.

When developing you can also try out the events yourself by just writing them into the `Events.S2M` file.  

Here is the list of commands:  

`#Host <port>`  
`#Connect <ip> <port>`  

The default values for `port` is `8989` and for ip is `127.0.0.1`.