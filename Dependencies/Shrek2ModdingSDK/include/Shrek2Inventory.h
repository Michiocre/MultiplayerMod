#pragma once
class Shrek2Inventory
{
public:
	int GetCoins();
	int GetShamrocks();
	int GetStrengthPotions();
	int GetShrinkPotions();
	int GetInvisibilityPotions();
	int GetSleepPotions();
	int GetStinkPotions();
	int GetShrinkEnemeyPotions();
	int GetFreezePotions();
	int GetLovePotions();

	void SetCoins(int newValue);
	void SetShamrocks(int newValue);
	void SetStrengthPotions(int newValue);
	void SetShrinkPotions(int newValue);
	void SetInvisibilityPotions(int newValue);
	void SetSleepPotions(int newValue);
	void SetStinkPotions(int newValue);
	void SetShrinkEnemeyPotions(int newValue);
	void SetFreezePotions(int newValue);
	void SetLovePotions(int newValue);

private:
	int GetInventoryItem(Shrek2CollectionTypes itemType);
	bool SetInventoryItem(Shrek2CollectionTypes itemType, int newValue);
};

