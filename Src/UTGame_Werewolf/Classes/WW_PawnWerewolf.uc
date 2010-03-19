class WW_PawnWerewolf extends WW_Pawn;

defaultproperties
{
	///Player Health///
	Health = 500
	HealthMax = 500 //Was 300 before...
	
	///Player movement//
	GroundSpeed=500	///was 440.0
	
	///PLAYER INVENTORY///
	DefaultInventory(1)=class 'UTWeap_Claws'
	
	// Takes away the second jump after the first one
	MaxMultiJump=1			// was 1
	MultiJumpRemaining=1		// was 1
	
	//Jump Height
	JumpZ=460				// was 322.0

	/** Visual Description ***/

	//I think this is what goes here.... (Chase)
	
	DefaultFamily=class'UTFamilyInfo_Krall_Male'
	DefaultMesh=SkeletalMesh'CH_werewold_Character_ww.Meshes.CH_werewolfChar_ww'

	//DefaultTeamMaterials[0]=MaterialInterface'CH_werewold_Character_ww.Materials.M_werewolfBody_ww'
	//DefaultTeamHeadMaterials[0]=MaterialInterface'CH_werewold_Character_ww.Materials.M_werewolfFace_ww'	
	

	

	
}