#pragma comment(lib,"ws2_32.lib")
#include <windows.h>
#include <chrono>
#include <sstream>
#include <vector>
#include <regex>
#include "Shrek2DirectX.h"
#include "Shrek2ModdingSDK.h"
#include "ModManager.h"
#include "../Server/Connection.h"
#include "../Server/JsonParsing.hpp"

Shrek2 Game = Shrek2();

int connState = STATE_DISC;
int id;

SOCKET s;
int slen;
struct sockaddr_in si_other;
char buf[BUFLEN];
DWORD timeout = 10 * 1000;

std::string commandBuffer;
bool lastFrameConsole = false;
bool currentFrameConsole = false;

std::string targetActor = "";

std::vector<Client> clientList;

int lastUpdate = lastUpdate;

void sendMessage(std::string message) {
	memset(buf, ' ', BUFLEN);
	strcpy_s(buf, message.c_str());
	if (sendto(s, buf, BUFLEN, 0, (struct sockaddr*)&si_other, slen) == SOCKET_ERROR)
	{
		Game.LogToConsole("sendto() failed with error code : " + WSAGetLastError());
	}
}

void sendJson(json message) {
	sendMessage(message.dump());
}

void disconnectFromServer() {
	Game.LogToConsole("Disconnecting.");
	json message = {
		{"code", CLIENT_DISC},
		{"id", id}
	};
	sendJson(message);
	connState = STATE_DISC;

	for (int i = 0; i < clientList.size(); i++) {
		if (clientList[i].id == id) {
			continue;
		}
		
		Shrek2ActorCharacter* actor = Game.Actors.GetCharacter(clientList[i].actor.name);

		actor->Position = Shrek2Vector3(-1000, -1000, -1000);
	}

	closesocket(s);
	WSACleanup();
}

void connectToServer(std::string ipAddress, int port) {
	Game.LogToConsole("Trying to connect to server.");

	s, slen = sizeof(si_other);
	WSADATA wsa;

	//Initialise winsock
	Game.LogToConsole("Initialising Winsock...");
	if (WSAStartup(MAKEWORD(2, 2), &wsa) != 0)
	{
		Game.LogToConsole("Failed. Error Code : " + WSAGetLastError());
		return;
	}
	Game.LogToConsole("Initialised.");

	//create socket
	if ((s = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)) == SOCKET_ERROR)
	{
		Game.LogToConsole("socket() failed with error code : " + WSAGetLastError());
		return;
	}
	u_long mode = 1;  // 1 to enable non-blocking socket

	if (ioctlsocket(s, FIONBIO, &mode) == SOCKET_ERROR)
	{
		Game.LogToConsole("socket() failed with error code : " + WSAGetLastError());
		return;
	}

	if (setsockopt(s, SOL_SOCKET, SO_RCVTIMEO, (const char*)&timeout, sizeof timeout) == SOCKET_ERROR)
	{
		Game.LogToConsole("socket() failed with error code : " + WSAGetLastError());
		return;
	}

	//setup address structure
	memset((char*)&si_other, 0, sizeof(si_other));
	si_other.sin_family = AF_INET;
	si_other.sin_port = htons(port);
	si_other.sin_addr.S_un.S_addr = inet_addr(ipAddress.c_str());

	std::string charName = Game.Variables.GetCurrentCharacter();

	json message = {
		{"code", CLIENT_ACC},
		{"id", id},
		{"name", charName}
	};

	Game.LogToConsole(message.dump());
	sendJson(message);

	lastUpdate = std::chrono::duration_cast<std::chrono::seconds>(
		std::chrono::system_clock::now().time_since_epoch()
	).count();
	connState = STATE_AWAITING;
}

void handleConnect(std::string commandBuffer, std::vector<std::string> partList) {
	Game.LogToConsole("Command 'mm_connect' was called by the user: " + commandBuffer);

	if (connState) {
		Game.LogToConsole("Client is already connected to a server");
		return;
	}

	if (partList.size() < 3) {
		Game.LogToConsole("Wrong amount of parameters");
		return;
	}

	std::string address = partList[1];
	int port = std::stoi(partList[2]);

	if (!std::regex_match(address, std::regex("^([0-2]?[0-9]?[0-9]\.){3}([0-2]?[0-9]?[0-9])$"))) {
		Game.LogToConsole("Address malformed");
		return;
	}

	if (port < 0 || port > 65535) {
		Game.LogToConsole("Port out of range");
		return;
	}

	connectToServer(address, port);
}

void handleDisconnect(std::string commandBuffer) {
	Game.LogToConsole("Command 'mm_disconnect' was called by the user: " + commandBuffer);

	if (connState == STATE_DISC) {
		Game.LogToConsole("Client is not connected");
		return;
	}

	disconnectFromServer();
}

void switchActor(std::string currentName, std::string newName) {
	Shrek2ActorCharacter* currentActor = Game.Actors.GetCharacter(currentName);
	Shrek2ActorCharacter* newActor = Game.Actors.GetCharacter(newName);

	Shrek2Vector3 tempPos = newActor->Position;

	newActor->Position = currentActor->Position;
	newActor->Rotation = currentActor->Rotation;

	currentActor->Position = tempPos;

	std::string command = "SwitchControlToPawn " + newName;

	Game.LogToConsole("Executing: " + command);
	Game.Functions.CC(command);
}

void OnTick()
{
	if (connState == STATE_CONN) {

		if (Shrek2Utils::DoesEqual(Game.Variables.GetCurrentCharacter(), targetActor)) {
			//Send player data
			std::string map = Game.Variables.GetCurrentMap();
			std::string playerChar = Game.Variables.GetCurrentCharacter();

			Client data;
			data.id = id;
			data.actor.name = playerChar;
			data.actor.position = Game.Variables.GetPosition();
			data.actor.velocity = Game.Variables.GetVelocity();
			data.actor.rotation = Game.Variables.GetRotation();
			data.actor.acceleration = Game.Variables.GetAcceleration();
			data.actor.isInAir = Game.Variables.GetIsInAir();

			if (map != "Book_FrontEnd.unr") {
				json message = {
					{"code", CLIENT_UPDATE},
					{"id", id},
					{"data", data}
				};

				sendJson(message);
			}
		}
	}

	if (connState > STATE_DISC) {
		int bytesReceived = recvfrom(s, buf, BUFLEN, 0, (struct sockaddr*)&si_other, &slen);
		if (bytesReceived == SOCKET_ERROR) {
			if (WSAGetLastError() == WSAEWOULDBLOCK) {
				// no data to receive
			}
			else {
				// handle error
			}
		}
		else {
			lastUpdate = std::chrono::duration_cast<std::chrono::seconds>(
				std::chrono::system_clock::now().time_since_epoch()
			).count();

			json response = json::parse(buf);

			//Game.LogToConsole("Recieved Data" + response.dump());

			switch (response.at("code").get<int>())
			{
			case SERVER_ACC: {
				if (connState == STATE_AWAITING) {
					connState = STATE_CONN;
				}

				std::string currentName = Game.Variables.GetCurrentCharacter();
				std::string newName = response.at("name").get<std::string>();

				targetActor = newName;

				if (!Shrek2Utils::DoesEqual(currentName, newName)) {
					Game.LogToConsole("New Name");
					switchActor(currentName, newName);
				}

				break;
			}
			case SERVER_UPDATE: {

				if (!Shrek2Utils::DoesEqual(Game.Variables.GetCurrentCharacter(), targetActor)) {
					break;
				}

				clientList = response.at("data").get<std::vector<Client>>();

				for (int i = 0; i < clientList.size(); i++) {
					if (clientList[i].id == id) {
						continue;
					}

					Shrek2ActorCharacter* player = Game.Actors.GetCharacter(clientList[i].actor.name);
					float offset = (player->Position - clientList[i].actor.position).length();
					Game.LogToConsole("Offset: " + std::to_string(offset));

					if (player) {
						if (offset > 5) {
							player->Position = clientList[i].actor.position;
						}
						player->Rotation = clientList[i].actor.rotation;
						player->Acceleration = clientList[i].actor.acceleration;
						player->Velocity = clientList[i].actor.velocity;
						player->IsInAir = clientList[i].actor.isInAir;
					}
				}
				break;
			}
			default:
				break;
			}
		}

		int currentTime = std::chrono::duration_cast<std::chrono::seconds>(
			std::chrono::system_clock::now().time_since_epoch()
		).count();

		if (currentTime - lastUpdate > 10) {
			Game.LogToConsole("Timeout");
			disconnectFromServer();
		}
	}

	lastFrameConsole = currentFrameConsole;
	currentFrameConsole = Game.Variables.GetIsConsoleOpen();
	
	std::string currentCommand = Game.Variables.GetCurrentConsoleCommand();
	if (currentCommand != "") {
		commandBuffer = currentCommand;
	}

	if (lastFrameConsole && !currentFrameConsole) {

		if (commandBuffer != "") {
			Game.LogToConsole("Intercepted command: " + commandBuffer);
			std::stringstream stream(commandBuffer);
			std::string segment;
			std::vector<std::string> partList;

			while (std::getline(stream, segment, ' '))
			{
				partList.push_back(segment);
			}

			std::string command = Shrek2Utils::StringToLower(partList[0]);

			if (Shrek2Utils::DoesEqual(command, "mm_connect")) {
				handleConnect(commandBuffer, partList);
			}
			else if (Shrek2Utils::DoesEqual(command, "mm_disconnect")) {
				handleDisconnect(commandBuffer);
			}
		}

		commandBuffer = "";
	}

	if (Game.IsGameFocused) {
		if (Game.Input.OnKeyPress(Shrek2Input::G)) {

			Game.LogToConsole("Pressed G");

			if (connState) {
				disconnectFromServer();
			}
			else {
				connectToServer(SERVER, PORT);
			}
		}
	}
	
}

void RenderUI()
{
	Shrek2UI::TriggerReset();

	Shrek2Rect rect = Shrek2Rect(10, 10, 100, 100);
	std::string message = "Test";

	Shrek2UI::RenderText(rect, message, Shrek2UI::GetColor(255, 0, 0), true);

	Shrek2UI::RenderRectangle(rect, Shrek2UI::GetColor(255, 0, 0));	

	Game.LogToConsole("RENDER");

}

void OnStart()
{
	id = std::chrono::duration_cast<std::chrono::seconds>(
		std::chrono::system_clock::now().time_since_epoch()
	).count();
	Shrek2UI::GameWindowSize = Game.GameWindowSize;
	Shrek2UI::RenderUI = RenderUI;
	Shrek2UI::Initialize();
}

DWORD WINAPI InitializationThread(HINSTANCE hModule)
{
	Game.Events.OnStart = OnStart;
	Game.Events.OnTick = OnTick;

	Game.Initialize("Michiocre's Magnificent Multiplayer Mod", true);

	FreeLibraryAndExitThread(hModule, 0);
	return 0;
}

BOOL APIENTRY DllMain(HMODULE hModule, DWORD ul_reason_for_call, LPVOID lpReserved)
{
	switch (ul_reason_for_call)
	{
	case DLL_PROCESS_ATTACH:
		Game.SetDllHandle(hModule);
		CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)InitializationThread, NULL, 0, NULL);
	case DLL_THREAD_ATTACH:
	case DLL_THREAD_DETACH:
		break;
	case DLL_PROCESS_DETACH:
		closesocket(s);
		WSACleanup();
		if (Game.IsModRunning) {
			Game.IsModRunning = false;
			Shrek2UI::StopUI();
			Sleep(1000);
		}
		break;
	}
	return TRUE;
}