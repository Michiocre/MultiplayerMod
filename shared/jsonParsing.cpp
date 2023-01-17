#include "jsonParsing.h"

void to_json(json& j, const Shrek2Vector3& vector) {
	j = json{
		{"X", vector.X},
		{"Y", vector.Y},
		{"Z", vector.Z}
	};
}

void from_json(const json& j, Shrek2Vector3& vector) {
	j.at("X").get_to(vector.X);
	j.at("Y").get_to(vector.Y);
	j.at("Z").get_to(vector.Z);
}

void to_json(json& j, const Actor& actor) {
	j = json{
		{"name", actor.name},
		{"position", actor.position}
	};
}

void from_json(const json& j, Actor& actor) {
	j.at("name").get_to(actor.name);
	j.at("position").get_to(actor.position);
}

void to_json(json& j, const Client& client) {
	j = json{
		{"id", client.id},
		{"actor", client.actor}
	};
}

void from_json(const json& j, Client& client) {
	j.at("id").get_to(client.id);
	j.at("actor").get_to(client.actor);
}