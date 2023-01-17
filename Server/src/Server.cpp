/*
	Simple UDP Server
*/

#include <iostream>
#include <string>
#include <stdio.h>
#include <winsock2.h>
#include <ws2tcpip.h>
#include "Shrek2ModdingSDK.h"
#include "../../shared/Connection.h"
#include "../../shared/jsonParsing.h"

SOCKET s;
struct sockaddr_in server, si_other;
int slen, recv_len;
char buf[BUFLEN];

std::vector<Client> clientList;

int sendMessage(std::string message) {
	memset(buf, ' ', BUFLEN);
	strcpy_s(buf, message.c_str());
	if (sendto(s, buf, BUFLEN, 0, (struct sockaddr*)&si_other, slen) == SOCKET_ERROR)
	{
		printf("sendto() failed with error code : %d", WSAGetLastError());
		exit(EXIT_FAILURE);
	}
}

int sendJson(json message) {
	std::string serialized = message.dump();
	sendMessage(serialized);
}

int main()
{
	WSADATA wsa;

	slen = sizeof(si_other);

	//Initialise winsock
	printf("\nInitialising Winsock...");
	if (WSAStartup(MAKEWORD(2, 2), &wsa) != 0)
	{
		printf("Failed. Error Code : %d", WSAGetLastError());
		exit(EXIT_FAILURE);
	}
	printf("Initialised.\n");

	//Create a socket
	if ((s = socket(AF_INET, SOCK_DGRAM, 0)) == INVALID_SOCKET)
	{
		printf("Could not create socket : %d", WSAGetLastError());
	}
	printf("Socket created.\n");

	//Prepare the sockaddr_in structure
	server.sin_family = AF_INET;
	server.sin_addr.s_addr = INADDR_ANY;
	server.sin_port = htons(PORT);

	//Bind
	if (bind(s, (struct sockaddr*)&server, sizeof(server)) == SOCKET_ERROR)
	{
		printf("Bind failed with error code : %d", WSAGetLastError());
		exit(EXIT_FAILURE);
	}
	puts("Bind done");

	//keep listening for data
	while (1)
	{
		fflush(stdout);

		//clear the buffer by filling null, it might have previously received data
		memset(buf, ' ', BUFLEN);

		//try to receive some data, this is a blocking call
		if ((recv_len = recvfrom(s, buf, BUFLEN, 0, (struct sockaddr*)&si_other, &slen)) == SOCKET_ERROR)
		{
			printf("recvfrom() failed with error code : %d", WSAGetLastError());
			exit(EXIT_FAILURE);
		}

		std::string message = std::string(buf);
		json parsed = json::parse(message);

		//print details of the client/peer and the data received
		char str[INET_ADDRSTRLEN];
		inet_ntop(AF_INET, &(si_other.sin_addr), str, INET_ADDRSTRLEN);
		printf("From [%s] [%d]: %s\n", str, ntohs(si_other.sin_port), message.c_str());

		switch (parsed.at("code").get<int>())
		{
		case CLIENT_ACC:
		{
			//This is the initial message
			int id = parsed.at("id").get<int>();

			Client client = { id };
			int index = -1;

			for (int i = 0; i < clientList.size(); i++) {
				if (clientList[i].id == id) {
					index = i;
					break;
				}
			}

			if (index < 0) {
				clientList.insert(clientList.end(), client);
			}

			json response = {
				{"code", SERVER_ACC},
				{"id", id}
			};

			sendJson(response);
			break;
		}
		case CLIENT_UPDATE: 
		{
			//Client movement
			int id = parsed.at("id").get<int>();

			int index = -1;

			for (int i = 0; i < clientList.size(); i++) {
				if (clientList[i].id == id) {
					index = i;
					break;
				}
			}

			if (index < 0) {
				json response = {
					{"code", SERVER_ERROR},
					{"data", "Id not found"}
				};

				sendJson(response);
			}
			else {
				clientList[index].actor.position = parsed.at("data").at("Position").get<Shrek2Vector3>();

				json response = {
					{"code", SERVER_UPDATE},
					{"id", id},
					{"data", clientList}
				};

				sendJson(response);
			}
			break;			
		}
		case CLIENT_DISC: {
			int id = parsed.at("id").get<int>();

			int index = -1;

			for (int i = 0; i < clientList.size(); i++) {
				if (clientList[i].id == id) {
					index = i;
					break;
				}
			}

			if (index > 0) {
				clientList[index].actor.position = Shrek2Vector3(0, 0, 0);
			}
			break;
		}
		default:
			printf("S{trange code\n");
			break;
		}
	}

	closesocket(s);
	WSACleanup();

	return 0;
}