/*
	Copyright (c) 2021 Kevin J. Petersen https://github.com/kevinjpetersen/
*/

#pragma once
class Shrek2Texture
{
public:
	std::string TextureFileLocation;
	IDirect3DTexture8* Texture;

	Shrek2Texture() {

	}

	Shrek2Texture(std::string textureFileLocation) {
		TextureFileLocation = textureFileLocation;
	}

	void SetIDirect3DTexture(IDirect3DDevice8* pDevice);
};

