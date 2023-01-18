/*
	Copyright (c) 2021 Kevin J. Petersen https://github.com/kevinjpetersen/
*/

#pragma once
class Shrek2Textures
{
public:
	Shrek2Textures() {

	}

	static bool AddTexture(std::string path, std::string alias);
	static bool RemoveTexture(std::string alias);
	static Shrek2Texture GetTexture(std::string alias);

	static void InitializeTextures(IDirect3DDevice8* pDevice);
	static void ReleaseTextures();

	static inline std::map<std::string, Shrek2Texture> AddedTextures;
	static bool AliasExist(std::string alias);
	static inline bool InitializedTextures;
};

