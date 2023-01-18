#ifndef SERVER
#define SERVER "10.3.16.144"	//ip address of udp server
#define BUFLEN 1024	//Max length of buffer
#define PORT 8888	//The port on which to listen for incoming data

#define CLIENT_ACC 0
#define SERVER_ACC 1
#define CLIENT_UPDATE 2
#define SERVER_UPDATE 3
#define SERVER_ERROR 4
#define CLIENT_DISC 5
#define SERVER_ACTOR 6
#endif

struct Actor {
	std::string name;
	Shrek2Vector3 position;
	Shrek2Vector3 velocity;
	Shrek2Vector3Int rotation;
	Shrek2Vector3 acceleration;
	bool isInAir;
};

struct Client {
	int id;
	bool active;
	Actor actor;
};
