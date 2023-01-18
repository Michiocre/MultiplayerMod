/*
	Copyright (c) 2021 Kevin J. Petersen https://github.com/kevinjpetersen/
*/

#pragma once
class Shrek2Pointers
{
public:
	float GetPlayerHealth();
	bool SetPlayerHealth(float PlayerHealth);

	float GetPositionX();
	bool SetPositionX(float PositionX);

	float GetPositionY();
	bool SetPositionY(float PositionY);

	float GetPositionZ();
	bool SetPositionZ(float PositionZ);

	Shrek2Vector3 GetPosition();
	bool SetPosition(Shrek2Vector3 position);

	float GetVelocityX();
	bool SetVelocityX(float VelocityX);

	float GetVelocityY();
	bool SetVelocityY(float VelocityY);

	float GetVelocityZ();
	bool SetVelocityZ(float VelocityZ);

	Shrek2Vector3 GetVelocity();
	bool SetVelocity(Shrek2Vector3 Velocity);

	short int GetRotationX();
	bool SetRotationX(short int RotationX);

	short int GetRotationY();
	bool SetRotationY(short int RotationY);

	short int GetRotationZ();
	bool SetRotationZ(short int RotationZ);

	Shrek2Vector3Int GetRotation();
	bool SetRotation(Shrek2Vector3Int rotation);

	bool GetGodMode();
	bool SetGodMode(bool GodMode);

	int GetFatalFallDistance();
	bool SetFatalFallDistance(int FatalFallDistance);

	bool GetShrink();
	bool SetShrink(bool Shrink);

	bool GetInvisible();
	bool SetInvisible(bool Invisible);

	float GetInvisibilityPercent();
	bool SetInvisibilityPercent(float InvisibilityPercent);

	bool GetHasStrengthPotion();
	bool SetHasStrengthPotion(bool HasStrengthPotion);

	int GetStrengthPotionScale();
	bool SetStrengthPotionScale(int StrengthPotionScale);

	float GetShrinkSpeed();
	bool SetShrinkSpeed(float ShrinkSpeed);

	float GetShrinkLimit();
	bool SetShrinkLimit(float ShrinkLimit);

	float GetPotionScale();
	bool SetPotionScale(float PotionScale);

	bool GetUseJumpMagnet();
	bool SetUseJumpMagnet(bool UseJumpMagnet);

	bool GetUseBouncePad();
	bool SetUseBouncePad(bool UseBouncePad);

	float GetKnockBackDistance();
	bool SetKnockBackDistance(float KnockBackDistance);

	float GetJumpAttackFallSpeed();
	bool SetJumpAttackFallSpeed(float JumpAttackFallSpeed);

	float GetJumpAttackBoostHeight();
	bool SetJumpAttackBoostHeight(float JumpAttackBoostHeight);

	bool GetJumpAttackToggle();
	bool SetJumpAttackToggle(bool JumpAttackToggle);

	int GetMaxCombatants();
	bool SetMaxCombatants(int MaxCombatants);

	int GetNumberofCombatants();

	bool GetKnockbackToggle();
	bool SetKnockbackToggle(bool KnockbackToggle);

	bool GetSayCombatDialog();
	bool SetSayCombatDialog(bool SayCombatDialog);

	float GetAttackMoveAhead();
	bool SetAttackMoveAhead(float AttackMoveAhead);

	float GetJumpAttackMoveAhead();
	bool SetJumpAttackMoveAhead(float JumpAttackMoveAhead);

	bool GetFrontEndPlayer();
	bool SetFrontEndPlayer(bool FrontEndPlayer);

	float GetBaseEyeHeight();
	bool SetBaseEyeHeight(float BaseEyeHeight);

	float GetEyeHeight();

	float GetCollisionHeight();
	bool SetCollisionHeight(float CollisionHeight);

	float GetCollisionRadius();
	bool SetCollisionRadius(float CollisionRadius);

	float GetDoubleJumpHeight();
	bool SetDoubleJumpHeight(float DoubleJumpHeight);

	float GetJumpHeight();
	bool SetJumpHeight(float JumpHeight);

	float GetMaxSlopeAngle();
	bool SetMaxSlopeAngle(float MaxSlopeAngle);

	bool GetIsClimbing();

	int GetIsInAir();

	bool GetIsInGhost();

	bool GetIsBigMount();

	bool GetIsLadderOrShimmeyPipe();

	float GetMovementAnimationSpeed();
	bool SetMovementAnimationSpeed(float MovementAnimationSpeed);

	float GetMovementAnimationTransitionSpeed();
	bool SetMovementAnimationTransitionSpeed(float MovementAnimationTransitionSpeed);

	float GetMovementSpeed();
	bool SetMovementSpeed(float MovementSpeed);

	float GetCurrentMovementSpeed();
	bool SetCurrentMovementSpeed(float CurrentMovementSpeed);

	int GetTurningSpeed();
	bool SetTurningSpeed(int TurningSpeed);

	bool GetAmbientGlow();
	bool SetAmbientGlow(bool AmbientGlow);

	bool GetUnlit();
	bool SetUnlit(bool Unlit);

	float GetVisualScale();
	bool SetVisualScale(float VisualScale);

	float GetVisualScaleX();
	bool SetVisualScaleX(float VisualScaleX);

	float GetVisualScaleY();
	bool SetVisualScaleY(float VisualScaleY);

	float GetVisualScaleZ();
	bool SetVisualScaleZ(float VisualScaleZ);

	float GetPrePivotX();
	bool SetPrePivotX(float PrePivotX);

	float GetPrePivotY();
	bool SetPrePivotY(float PrePivotY);

	float GetPrePivotZ();
	bool SetPrePivotZ(float PrePivotZ);

	bool GetResetRotation();
	bool SetResetRotation(bool ResetRotation);

	bool GetIsInWater();

	float GetWaterSpeed();
	bool SetWaterSpeed(float WaterSpeed);

	float GetWaterSpeed2();
	bool SetWaterSpeed2(float WaterSpeed2);

	float GetNoclipSpeed();
	bool SetNoclipSpeed(float NoclipSpeed);

	float GetLadderSpeed();
	bool SetLadderSpeed(float LadderSpeed);

	float GetAccelerationRate();
	bool SetAccelerationRate(float AccelerationRate);

	float GetAirControl();
	bool SetAirControl(float AirControl);

	float GetAttackDistance();
	bool SetAttackDistance(float AttackDistance);

	float GetAttackHeight();
	bool SetAttackHeight(float AttackHeight);

	float GetAttackAngle();
	bool SetAttackAngle(float AttackAngle);

	float GetSpecialAttackTime();
	bool SetSpecialAttackTime(float SpecialAttackTime);

	float GetTerminalVelocity();
	bool SetTerminalVelocity(float TerminalVelocity);

	float GetFriction();
	bool SetFriction(float Friction);

	float GetInGameTimer();
	bool SetInGameTimer(float InGameTimer);

	float GetGravityX();
	bool SetGravityX(float GravityX);

	float GetGravityY();
	bool SetGravityY(float GravityY);

	float GetGravityZ();
	bool SetGravityZ(float GravityZ);

	float GetGameSpeed();
	bool SetGameSpeed(float GameSpeed);

	float GetChangeTo0ToCrash();
	bool SetChangeTo0ToCrash(float ChangeTo0ToCrash);

	float GetCamPositionX();
	bool SetCamPositionX(float CamPositionX);

	float GetCamPositionY();
	bool SetCamPositionY(float CamPositionY);

	float GetCamPositionZ();
	bool SetCamPositionZ(float CamPositionZ);

	short int GetCamRotationX();
	bool SetCamRotationX(short int CamRotationX);

	short int GetCamRotationY();
	bool SetCamRotationY(short int CamRotationY);

	short int GetCamRotationZ();
	bool SetCamRotationZ(short int CamRotationZ);

	float GetDesiredLookDistance();
	bool SetDesiredLookDistance(float DesiredLookDistance);

	float GetCamSmoothing();
	bool SetCamSmoothing(float CamSmoothing);

	float GetCamSensitivity();
	bool SetCamSensitivity(float CamSensitivity);

	float GetCamHorizontalSpeed();
	bool SetCamHorizontalSpeed(float CamHorizontalSpeed);

	float GetCamVerticalSpeed();
	bool SetCamVerticalSpeed(float CamVerticalSpeed);

	float GetCamHorizontalSensitivity();
	bool SetCamHorizontalSensitivity(float CamHorizontalSensitivity);

	float GetCamVerticalSensitivity();
	bool SetCamVerticalSensitivity(float CamVerticalSensitivity);

	float GetCamMinimumPitch();
	bool SetCamMinimumPitch(float CamMinimumPitch);

	float GetCamMaximumPitch();
	bool SetCamMaximumPitch(float CamMaximumPitch);

	bool GetCamCollisionToggle();
	bool SetCamCollisionToggle(bool CamCollisionToggle);

	float GetDonkeySwampPositionX();
	bool SetDonkeySwampPositionX(float DonkeySwampPositionX);

	float GetDonkeySwampPositionY();
	bool SetDonkeySwampPositionY(float DonkeySwampPositionY);

	float GetDonkeySwampPositionZ();
	bool SetDonkeySwampPositionZ(float DonkeySwampPositionZ);

	std::string GetCurrentMap();
	std::string GetCurrentCharacter();

	short int GetRotationRateX();
	bool SetRotationRateX(short int RotationRateX);

	short int GetRotationRateY();
	bool SetRotationRateY(short int RotationRateY);

	short int GetRotationRateZ();
	bool SetRotationRateZ(short int RotationRateZ);

	float GetFOV();
	bool SetFOV(float FOV);

	float GetAccelerationX();
	bool SetAccelerationX(float AccelerationX);

	float GetAccelerationY();
	bool SetAccelerationY(float AccelerationY);

	float GetAccelerationZ();
	bool SetAccelerationZ(float AccelerationZ);

	Shrek2Vector3 GetAcceleration();
	bool SetAcceleration(Shrek2Vector3 Acceleration);

	float GetCamAngleX();

	float GetCamAngleY();

	float GetCamAngleZ();

	bool SetCameraBehavior_LockCameraLook();
	bool SetCameraBehavior_LockCameraMovement();
	bool SetCameraBehavior_LockCameraMovementAndLook();
	bool SetCameraBehavior_Normal();
	int GetCameraBehavior();

	std::string GetCurrentConsoleCommand();
	bool GetIsConsoleOpen();
};

