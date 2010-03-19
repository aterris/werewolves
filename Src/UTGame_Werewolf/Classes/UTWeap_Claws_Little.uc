//**********************************************************************************//
//Weapon: Custom Claws
//Created For: Werewolf Mod
//Created By: Andrew Terris
//
//Overview: Primary fire hits players with his claws
//
//**********************************************************************************//

class UTWeap_Claws_Little extends UTWeap_ImpactHammer;


defaultproperties
{

SelfDamageScale=0.000000
   MinDamage=16.0000
   MaxDamage=16.0000
   MinForce=80000.000000
   MaxForce=80000.000000
   MinSelfDamage=0.000000
   MaxChargeTime=.1
   MinChargeTime=.01
   EMPDamage=0.0000000
   InventoryGroup=1
   InstantHitDamage(0)=16.000000
   InstantHitDamage(1)=16.000000
   //InstantHitDamageTypes(0)=Class'UTGame.UTDmgType_Claws'
   //InstantHitDamageTypes(1)=Class'UTGame.UTDmgType_Claws'
   InstantHitDamageTypes(2)=None
   //InstantHitDamageTypes(3)=Class'UTGame.UTDmgType_Claws'
   FireOffset=(X=20.000000,Y=0.000000,Z=0.000000)
   bCanThrow=False
   bInstantHit=True
   bMeleeWeapon=True
   WeaponRange=130.000000
}




