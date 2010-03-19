//**********************************************************************************//
//Weapon: SilverBullet Crossbow
//Created For: Werewolf Mod
//Created By: Andrew Terris
//
//Overview: Primary fire shoots an instant hit crossbow dart.
//			Secondary fire is a melee that pushes friendlies down but does no damage
//
//**********************************************************************************//


class UTWeap_SilverBullet extends UTWeapon;


//**** Global Variables ****//
var bool bAllowPush;
var bool bUseSilver;
var float pushTimer;
var int pushDistance;
var int silverBullets;
var bool showAltFire;


//**** Functions ****//
//** InstantFire **//
simulated function InstantFire()
{
	//Local Variables
	
	//local float HitDist;
	//local vector Dir;
	//local array ImpactList;
	
	//Primary Fire (Crossbow dart)
	if(CurrentFireMode==0)
	{
		Super.InstantFire();
	}
}


//** PlayFiringSound() **//
simulated function PlayFiringSound()
{
	if (CurrentFireMode<WeaponFireSnd.Length)
	{
		//Play Fire Sound (Only if Allowed)
		if ( WeaponFireSnd[CurrentFireMode] != None && bAllowPush )
		{
			MakeNoise(1.0);
			WeaponPlaySound( WeaponFireSnd[CurrentFireMode] );
		}
	}
}

//** StartFire **//
simulated function StartFire(byte FireModeNum)
{
	if(FireModeNum==0)
		Super.StartFire(FireModeNum);
}


//** Use GetPhysicalFireStartLoc() instead of Instigator.GetWeaponStartTraceLocation() **//
simulated function vector InstantFireStartTrace()
{
	return GetPhysicalFireStartLoc();
}

/** Skip over the Instagib rifle code **/
simulated function SetSkin(Material NewMaterial)
{
	Super(UTWeapon).SetSkin(NewMaterial);
}

simulated function AttachWeaponTo(SkeletalMeshComponent MeshCpnt, optional name SocketName)
{
	Super(UTWeapon).AttachWeaponTo(MeshCpnt, SocketName);
}


//**** Default Properties ****//
defaultproperties
{ 
   //Ammo Setup
   AmmoCount=0
   LockerAmmoCount=1
   MaxAmmoCount=3
   ShotCost(0)=1
   
   //Firing Details
   WeaponFireTypes(0)=EWFT_InstantHit
   FireInterval(0)=0.770000
   FireInterval(1)=1.000000
   
   //Damage Setup
   InstantHitDamage(0)=300.000000
   InstantHitMomentum(0)=60000.000000
   InstantHitDamageTypes(0)=Class'UTGame_Werewolf.UTDmgType_Crossbow'
   InstantHitDamageTypes(1)=Class'UTGame_Werewolf.UTDmgType_Crossbow'
   
   //Sounds
   WeaponFireSnd(0)=SoundCue'TownTestMeshes_WW.crossbowFireSoundCue'
   WeaponFireSnd(1)=SoundCue'TownTestMeshes_WW.pushFireSoundCue'
   WeaponPutDownSnd=SoundCue'A_Weapon_ShockRifle.Cue.A_Weapon_SR_LowerCue'
   WeaponEquipSnd=SoundCue'A_Weapon_ShockRifle.Cue.A_Weapon_SR_RaiseCue'
   
   //Other
   InventoryGroup=2
   bUseSilver=true
   showAltFire=true;
   
   bSniping=True
   bTargetFrictionEnabled=True
   bTargetAdhesionEnabled=True
   FireCameraAnim(0)=None
   FireCameraAnim(1)=CameraAnim'Camera_FX.ShockRifle.C_WP_ShockRifle_Alt_Fire_Shake'
   WeaponFireWaveForm=ForceFeedbackWaveform'UTGame.Default__UTWeap_ShockRifle:ForceFeedbackWaveformShooting1'
   IconX=400
   IconY=129
   IconWidth=22
   IconHeight=48
   IconCoordinates=(U=728.000000,V=382.000000,UL=162.000000,VL=45.000000)
   CrossHairCoordinates=(U=256.000000,V=0.000000)
   AttachmentClass=Class'UTGame.UTAttachment_ShockRifle'
   GroupWeight=0.500000
   QuickPickGroup=0
   QuickPickWeight=0.900000
   WeaponFireAnim(1)="WeaponAltFire"
   WeaponColor=(B=255,G=0,R=160,A=255)
   MuzzleFlashSocket="MF"
   MuzzleFlashPSCTemplate=ParticleSystem'WP_ShockRifle.Particles.P_ShockRifle_MF_Alt'
   MuzzleFlashAltPSCTemplate=ParticleSystem'WP_ShockRifle.Particles.P_ShockRifle_MF_Alt'
   MuzzleFlashColor=(B=255,G=120,R=200,A=255)
   MuzzleFlashLightClass=Class'UTGame.UTShockMuzzleFlashLight'
   PlayerViewOffset=(X=14.000000,Y=6.000000,Z=-14.000000)
   LockerRotation=(Pitch=32768,Yaw=0,Roll=16384)
   CurrentRating=0.650000
   ShouldFireOnRelease(1)=1
   FireOffset=(X=20.000000,Y=5.000000,Z=0.000000)
   bInstantHit=True
   Begin Object UTSkeletalMeshComponent Name=FirstPersonMesh ObjName=FirstPersonMesh Archetype=UTSkeletalMeshComponent'UTGame.Default__UTWeapon:FirstPersonMesh'
      FOV=60.000000
      SkeletalMesh=SkeletalMesh'crossbow_package_ww.crossbow_ww'
      Begin Object Class=AnimNodeSequence Name=MeshSequenceA ObjName=MeshSequenceA Archetype=AnimNodeSequence'Engine.Default__AnimNodeSequence'
         Name="MeshSequenceA"
         ObjectArchetype=AnimNodeSequence'Engine.Default__AnimNodeSequence'
      End Object
      Animations=AnimNodeSequence'UTGame.Default__UTWeap_ShockRifle:MeshSequenceA'
      AnimSets(0)=AnimSet'WP_ShockRifle.Anim.K_WP_ShockRifle_1P_Base'
      Rotation=(Pitch=0,Yaw=16384,Roll=0)
      ObjectArchetype=UTSkeletalMeshComponent'UTGame.Default__UTWeapon:FirstPersonMesh'
   End Object
   Mesh=FirstPersonMesh
   Priority=4.200000
   AIRating=0.650000
   ItemName="Silver Bolt"
   MaxDesireability=0.650000
   PickupMessage="Silver Bolt"
   PickupSound=SoundCue'A_Pickups.Weapons.Cue.A_Pickup_Weapons_Shock_Cue'
   Begin Object SkeletalMeshComponent Name=PickupMesh ObjName=PickupMesh Archetype=SkeletalMeshComponent'UTGame.Default__UTWeapon:PickupMesh'
      SkeletalMesh=SkeletalMesh'crossbow_package_ww.crossbow_ww'
      ObjectArchetype=SkeletalMeshComponent'UTGame.Default__UTWeapon:PickupMesh'
   End Object
   DroppedPickupMesh=PickupMesh
   PickupFactoryMesh=PickupMesh
   Name="Default__UTWeap_SilverBullet"
   ObjectArchetype=UTWeapon'UTGame.Default__UTWeapon'
}
