class UTAmmo_Bolt extends UTAmmo_ShockRifle;

defaultproperties
{
   AmmoAmount=8
   TargetWeapon=Class'UTGame_Werewolf.UTWeap_Crossbow'
   PickupMessage="Bolts"
   Name="Default__UTAmmo_Bolt"
	bRotatingPickup=True
	YawRotationRate=24000.000000

	

   Begin Object StaticMeshComponent Name=AmmoMeshComp ObjName=AmmoMeshComp Archetype=StaticMeshComponent'UTGame.Default__UTAmmoPickupFactory:AmmoMeshComp'
      StaticMesh=StaticMesh'WW_Pickups.Meshes.Quiver_WW'
	Scale=26
      Translation=(X=0.000000,Y=0.000000,Z=-15.000000)
      ObjectArchetype=StaticMeshComponent'UTGame.Default__UTAmmoPickupFactory:AmmoMeshComp'
   End Object


}
