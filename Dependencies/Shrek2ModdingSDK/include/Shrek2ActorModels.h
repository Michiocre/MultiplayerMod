#pragma once
#define STR_MERGE_IMPL(a, b) a##b
#define STR_MERGE(a, b) STR_MERGE_IMPL(a, b)
#define MAKE_PAD(size) STR_MERGE(_pad, __COUNTER__)[size]
#define DEFINE_MEMBER_N(type, name, offset) struct {unsigned char MAKE_PAD(offset); type name;}

class Shrek2ActorClassInfo
{
public:
	union {
		DEFINE_MEMBER_N(INT32, ClassID, 0x14);
	};
};

class Shrek2Actor
{
public:
	union {
		DEFINE_MEMBER_N(Shrek2ActorClassInfo*, ClassInfo, 0x24);
		DEFINE_MEMBER_N(Shrek2Vector3, Position, 0x150);
		DEFINE_MEMBER_N(Shrek2Vector3Int, Rotation, 0x15C);
		DEFINE_MEMBER_N(WCHAR*, Label, 0x364);
	};

	Shrek2Actor() {

	}

	std::string GetLabel()
	{
		try {
			if (!Label) return "";

			std::wstring str = reinterpret_cast<wchar_t*>(Label);
			if (!str.empty())
			{
				return Shrek2Utils::WS2String(str);
			}
			return "";
		}
		catch (std::exception& ex)
		{
			Shrek2Logging::LogError("Shrek2Actor::GetLabel", ex.what());
			return "";
		}
	}
};

class Shrek2AnyCollection
{
public:
	union {
		DEFINE_MEMBER_N(INT32, Items, 0x43C);
	};
};

class Shrek2CoinCollection
{
public:
	union {
		DEFINE_MEMBER_N(INT32, Coins, 0x43C);
	};
};

class Shrek2ActorCutController
{
public:
	union {
		DEFINE_MEMBER_N(Shrek2ActorClassInfo*, ClassInfo, 0x24);
		DEFINE_MEMBER_N(Shrek2Vector3, Position, 0x150);
		DEFINE_MEMBER_N(WCHAR*, Tag, 0x76C);
		DEFINE_MEMBER_N(void*, CurrentAction1, 0x754);
		DEFINE_MEMBER_N(void*, CurrentAction2, 0x7DC);
		DEFINE_MEMBER_N(void*, CurrentAnimation, 0x760);

	};

	Shrek2ActorCutController() {

	}

	void CancelAnimation()
	{
		if (Shrek2Utils::DoesEqual(GetTag(), "MAIN")) return;
		std::cout << "CANCELANIMATION -- Called Get Tag" << std::endl;

		CurrentAction1 = CurrentAnimation;
		std::cout << "CANCELANIMATION -- Called CurrentAction 1" << std::endl;

		CurrentAction2 = CurrentAnimation;
		std::cout << "CANCELANIMATION -- Called CurrentAction 2" << std::endl;

	}

	std::string GetTag()
	{
		try {
			if (!Tag) return "";

			std::wstring str = reinterpret_cast<wchar_t*>(Tag);
			if (!str.empty())
			{
				return Shrek2Utils::WS2String(str);
			}
			return "";
		}
		catch (std::exception& ex)
		{
			Shrek2Logging::LogError("Shrek2Actor::GetTag", ex.what());
			return "";
		}
	}
};

class Shrek2ActorCharacter
{
public:
	union {
		DEFINE_MEMBER_N(WCHAR*, Name, 0x364);
		DEFINE_MEMBER_N(Shrek2ActorClassInfo*, ClassInfo, 0x24);
		DEFINE_MEMBER_N(Shrek2Vector3, Position, 0x150);
		DEFINE_MEMBER_N(Shrek2Vector3, Velocity, 0x168);
		DEFINE_MEMBER_N(Shrek2Vector3, Acceleration, 0x174);
		DEFINE_MEMBER_N(Shrek2Vector3Int, Rotation, 0x15C);
		DEFINE_MEMBER_N(FLOAT, VisualScaleAll, 0x268);
		DEFINE_MEMBER_N(Shrek2Vector3, VisualScale, 0x26C);
		DEFINE_MEMBER_N(FLOAT, Health, 0x4E0);
		DEFINE_MEMBER_N(BOOL, GodMode, 0x14A0);
		DEFINE_MEMBER_N(INT32, FatalFallDistance, 0x149C);
		DEFINE_MEMBER_N(BOOL, Shrink, 0x1500);
		DEFINE_MEMBER_N(FLOAT, ShrinkSpeed, 0x1508);
		DEFINE_MEMBER_N(FLOAT, ShrinkSize, 0x150C);
		DEFINE_MEMBER_N(BOOL, IgnoredByEnemies, 0x14D0);
		DEFINE_MEMBER_N(FLOAT, KnockBackDistance, 0x1480);
		DEFINE_MEMBER_N(FLOAT, JumpAttackFallSpeed, 0x1290);
		DEFINE_MEMBER_N(FLOAT, JumpAttackBoostHeight, 0x128C);
		DEFINE_MEMBER_N(BOOL, AllowJumpAttack, 0x1278);
		DEFINE_MEMBER_N(INT32, MaxCombatants, 0x1214);
		DEFINE_MEMBER_N(INT32, NumberOfCombatants, 0x1210);
		DEFINE_MEMBER_N(FLOAT, AttackMoveAhead, 0x11D0);
		DEFINE_MEMBER_N(FLOAT, JumpAttackMoveAhead, 0x11D4);
		DEFINE_MEMBER_N(FLOAT, CollisionHeight, 0x2E0);
		DEFINE_MEMBER_N(FLOAT, CollisionRadius, 0x2D8);
		DEFINE_MEMBER_N(FLOAT, JumpHeight, 0x47C);
		DEFINE_MEMBER_N(FLOAT, DoubleJumpHeight, 0xEFC);
		DEFINE_MEMBER_N(FLOAT, MaxSlopeAngle, 0x49C);
		DEFINE_MEMBER_N(FLOAT, IsInAir, 0x538);
		DEFINE_MEMBER_N(FLOAT, MovementAnimationSpeed, 0x5BC);
		DEFINE_MEMBER_N(FLOAT, MovementAnimationTransitionSpeed, 0x5D8);
		DEFINE_MEMBER_N(FLOAT, MovementSpeed, 0xB40);
		DEFINE_MEMBER_N(FLOAT, CurrentMovementSpeed, 0x468);
		DEFINE_MEMBER_N(INT32, TurningSpeed, 0x314);
		DEFINE_MEMBER_N(UINT8, Unlit, 0x2BC);
		DEFINE_MEMBER_N(Shrek2Vector3, PrePivot, 0x278);
		DEFINE_MEMBER_N(BOOL, IsInWater, 0x1084);
		DEFINE_MEMBER_N(FLOAT, WaterSpeed, 0x1088);
		DEFINE_MEMBER_N(FLOAT, WaterSpeed2, 0x46C);
		DEFINE_MEMBER_N(FLOAT, NoclipSpeed, 0x470);
		DEFINE_MEMBER_N(FLOAT, LadderSpeed, 0x474);
		DEFINE_MEMBER_N(FLOAT, AccelerationRate, 0x478);
		DEFINE_MEMBER_N(FLOAT, AirControl, 0x480);
		DEFINE_MEMBER_N(FLOAT, AttackDistance, 0x109C);
		DEFINE_MEMBER_N(FLOAT, AttackHeight, 0x10A0);
		DEFINE_MEMBER_N(FLOAT, AttackAngle, 0x10A4);
		DEFINE_MEMBER_N(FLOAT, SpecialAttackTime, 0x10A8);
		DEFINE_MEMBER_N(INT32, LastState, 0x5A4);
		DEFINE_MEMBER_N(void*, CarriedActor, 0x888);
	};

	void SetUnlit(bool isUnlit)
	{
		Unlit = isUnlit ? 129 : 128;
	}

	std::string GetName()
	{
		try {
			if (!Name) return "";

			std::wstring str = reinterpret_cast<wchar_t*>(Name);
			if (!str.empty())
			{
				return Shrek2Utils::WS2String(str);
			}
			return "";
		}
		catch (std::exception& ex)
		{
			Shrek2Logging::LogError("Shrek2ActorCharacter::GetName", ex.what());
			return "";
		}
	}
};