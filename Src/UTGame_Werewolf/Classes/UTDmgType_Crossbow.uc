/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */

class UTDmgType_Crossbow extends UTDamageType
	abstract;

defaultproperties
{
   DamageBodyMatColor=(R=40.000000,G=0.000000,B=50.000000,A=1.000000)
   DamageOverlayTime=0.300000
   DeathOverlayTime=0.600000
   GibPerterbation=0.750000
   DamageWeaponClass=Class'UTGame_Werewolf.UTWeap_Crossbow'
   DamageCameraAnim=CameraAnim'Camera_FX.ShockRifle.C_WP_ShockRifle_Hit_Shake'
   NodeDamageScaling=0.800000
   KillStatsName="KILLS_CROSSBOW"
   DeathStatsName="DEATHS_CROSSBOW"
   SuicideStatsName="SUICIDES_CROSSBOW"
   CustomTauntIndex=4
   DeathString="`o was impaled by `k's crossbow."
   FemaleSuicide="`o crossbowed herself."
   MaleSuicide="`o crossbowed himself."
   KDamageImpulse=1500.000000
   VehicleDamageScaling=0.700000
   VehicleMomentumScaling=2.000000
   Name="Default__UTDmgType_Crossbow"
   ObjectArchetype=UTDamageType'UTGame.Default__UTDamageType'
}
