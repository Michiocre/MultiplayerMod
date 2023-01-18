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

void to_json(json& j, const Shrek2Vector3Int& vector) {
	j = json{
		{"X", vector.X},
		{"Y", vector.Y},
		{"Z", vector.Z}
	};
}
void from_json(const json& j, Shrek2Vector3Int& vector) {
	j.at("X").get_to(vector.X);
	j.at("Y").get_to(vector.Y);
	j.at("Z").get_to(vector.Z);
}

void to_json(json& j, const Actor& actor) {
	j = json{
		{"name", actor.name},
		{"position", actor.position},
		{"velocity", actor.velocity},
		{"rotation", actor.rotation},
		{"acceleration", actor.acceleration},
		{"isInAir", actor.isInAir}
	};
}
void from_json(const json& j, Actor& actor) {
	j.at("name").get_to(actor.name);
	j.at("position").get_to(actor.position);
	j.at("velocity").get_to(actor.velocity);
	j.at("rotation").get_to(actor.rotation);
	j.at("acceleration").get_to(actor.acceleration);
	j.at("isInAir").get_to(actor.isInAir);
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