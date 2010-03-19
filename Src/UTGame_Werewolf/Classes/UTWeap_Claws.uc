//**********************************************************************************//
//Weapon: Custom Claws
//Created For: Werewolf Mod
//Created By: Andrew Terris
//
//Overview: Primary fire hits players with his claws
//
//**********************************************************************************//

class UTWeap_Claws extends UTWeap_ImpactHammer;


defaultproperties
{


SelfDamageScale=0.000000
   MinDamage=35.0000
   MaxDamage=35.0000
   MinForce=100000.000000
   MaxForce=100000.000000
   MinSelfDamage=0.000000
   MaxChargeTime=.1
   MinChargeTime=.01
   EMPDamage=0.0000000
   InventoryGroup=1
   InstantHitDamage(0)=35.000000
   InstantHitDamage(1)=35.000000
   //InstantHitDamageTypes(0)=Class'UTGame.UTDmgType_Claws'
   //InstantHitDamageTypes(1)=Class'UTGame.UTDmgType_Claws'
   InstantHitDamageTypes(2)=None
   //InstantHitDamageTypes(3)=Class'UTGame.UTDmgType_Claws'
   FireOffset=(X=20.000000,Y=0.000000,Z=0.000000)
   bCanThrow=False
   bInstantHit=True
   bMeleeWeapon=True
   WeaponRange=130.000000
	PlayerViewOffset=(X=42.000000,Y=6.000000,Z=-14.000000)

	Begin Object UTSkeletalMeshComponent Name=FirstPersonMesh ObjName=FirstPersonMesh Archetype=UTSkeletalMeshComponent'UTGame.Default__UTWeapon:FirstPersonMesh'
	FOV=60.000000
	/*
	SkeletalMesh=SkeletalMesh'WW_WerewolfClawsWeapon.Mesh.WW_ClawsWeapon'
		//Begin Object Class=AnimNodeSequence Name=MeshSequenceA ObjName=MeshSequenceA Archetype=AnimNodeSequence'Engine.Default__AnimNodeSequence'
		//Name="MeshSequenceA"
		//ObjectArchetype=AnimNodeSequence'Engine.Default__AnimNodeSequence'
		//End Object
	Animations=AnimNodeSequence'UTGame.Default__UTWeap_ShockRifle:MeshSequenceA'
      	AnimSets(0)=AnimSet'WP_ShockRifle.Anim.K_WP_ShockRifle_1P_Base'
      	Rotation=(Pitch=0,Yaw=16384,Roll=0)
      	ObjectArchetype=UTSkeletalMeshComponent'UTGame.Default__UTWeapon:FirstPersonMesh'
  	End Object
	*/
}




