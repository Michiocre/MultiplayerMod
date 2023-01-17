#ifndef SERVER

#define SERVER "10.3.16.144"	//ip address of udp server
#define BUFLEN 512	//Max length of buffer
#define PORT 8888	//The port on which to listen for incoming data
#pragma comment(lib,"ws2_32.lib") //Winsock Library

#define CLIENT_ACC 0
#define SERVER_ACC 1
#define CLIENT_UPDATE 2
#define SERVER_UPDATE 3
#define SERVER_ERROR 4
#define CLIENT_DISC 5


struct Actor {
	std::string name;
	Shrek2Vector3 position;
};

struct Client {
	int id;
	Actor actor;
};

#endif