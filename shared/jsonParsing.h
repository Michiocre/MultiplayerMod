#pragma once
#include <string>
#include "Shrek2ModdingSDK.h"
#include "Connection.h"

void to_json(json& j, const Shrek2Vector3& vector);
void from_json(const json& j, Shrek2Vector3& vector);
void to_json(json& j, const Actor& actor);
void from_json(const json& j, Actor& actor);
void to_json(json& j, const Client& client);
void from_json(const json& j, Client& client);