class UTAmmo_SilverBolt extends UTAmmo_ShockRifle;


defaultproperties
{
   AmmoAmount=1
   TargetWeapon=Class'UTGame_Werewolf.UTWeap_SilverBullet'
   PickupMessage="Silver Bolt"
   Name="Default__UTAmmo_SilverBolt"

Begin Object StaticMeshComponent Name=AmmoMeshComp ObjName=AmmoMeshComp Archetype=StaticMeshComponent'UTGame.Default__UTAmmoPickupFactory:AmmoMeshComp'
      StaticMesh=StaticMesh'WW_Pickups.Meshes.Quiver_WW'
	Scale=26
      Translation=(X=0.000000,Y=0.000000,Z=-15.000000)
      ObjectArchetype=StaticMeshComponent'UTGame.Default__UTAmmoPickupFactory:AmmoMeshComp'
   End Object
   
}



