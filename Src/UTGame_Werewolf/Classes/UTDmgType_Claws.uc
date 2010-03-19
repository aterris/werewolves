/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */

class UTDmgType_Claws extends UTDamageType
	abstract;

defaultproperties
{

   GibPerterbation=0.500000
   DamageWeaponClass=Class'UTGame_Werewolf.UTWeap_Claws'
   DamageWeaponFireMode=2
   DeathCameraEffectInstigator=Class'UTGame.UTEmitCameraEffect_BloodSplatter'
   DamageCameraAnim=CameraAnim'Camera_FX.ImpactHammer.C_WP_ImpactHammer_Primary_Fire_GetHit_Shake'
   KillStatsName="KILLS_Claws"
   DeathStatsName="DEATHS_Claws"
   SuicideStatsName="SUICIDES_Claws"
   CustomTauntIndex=5
   DeathString="`o was mauled by `k."
   FemaleSuicide="`o clawed herself."
   MaleSuicide="`o clawed himself."
   bAlwaysGibs=False
   KDamageImpulse=10000.000000
   VehicleDamageScaling=0.200000
   Name="Default__UTDmgType_Claws"
   ObjectArchetype=UTDamageType'UTGame.Default__UTDamageType'
}
