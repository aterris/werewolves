class WW_PawnWerewolf_Little extends WW_Pawn;

defaultproperties
{
	///Player Health///
	Health = 80
	HealthMax = 80
	
	///Player movement//
	GroundSpeed=550	///was 440.0
	
	///PLAYER INVENTORY///
	DefaultInventory(1)=class 'UTWeap_Claws_Little'
	
	// Takes away the second jump after the first one
	MaxMultiJump=1			// was 1
	MultiJumpRemaining=1		// was 1
	
	//Jump Height
	JumpZ=460;				// was 322.0

	/** Visual Description ***/

	//I think this is what goes here.... (Chase)
	//DefaultMeshScale=0.75000
	//DrawScale=0.75000
	//BaseTranslationOffset=42.000000 //Was At 6.0
	
	
	DefaultFamily=class'UTFamilyInfo_Krall_Male'
	DefaultMesh=SkeletalMesh'CH_Skeletons.Mesh.SK_CH_Skeleton_Krall_Male'

	//DefaultTeamMaterials[0]=MaterialInterface'CH_werewold_Character_ww.Materials.M_werewolfBody_ww'
	//DefaultTeamHeadMaterials[0]=MaterialInterface'CH_werewold_Character_ww.Materials.M_werewolfFace_ww'	
	

	
}