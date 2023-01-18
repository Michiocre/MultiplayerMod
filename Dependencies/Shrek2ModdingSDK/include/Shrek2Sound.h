/*
	Copyright (c) 2021 Kevin J. Petersen https://github.com/kevinjpetersen/
*/

#pragma once
class Shrek2Sound
{
public:
	Shrek2Sound() {}
	Shrek2Sound(std::string dllPath) {
		DllPath = dllPath;
	}

	void AddSound(std::string soundFile, std::string alias);
	void Play(std::string alias);
	void PlayLoop(std::string alias);
	void Stop(std::string alias);
private:
	std::map<std::string, std::string> AddedSounds;
	std::string DllPath;
};

