class WW_Pawn extends UTPawn;

/** Default inventory added via AddDefaultInventory() */
var array< class<Inventory> >	DefaultInventory;

// PMC -- in OneFlag the pawns have their own default inventory
//  So we use this method in the base class to assign it.
function AddDefaultInventory()
{
	local int i;

	for (i=0; i<DefaultInventory.Length; i++)
	{
		// Ensure we don't give duplicate items
		if (FindInventoryType( DefaultInventory[i] ) == None)
		{
			// Only activate the first weapon
			CreateInventory(DefaultInventory[i], (i > 0));
		}
	}	
}

//GPM-Right now this is in here just so Werewolves don't have the ability to pick up dropped weapons...
// PMC -- don't ever toss/drop your current weapon
function TossWeapon(Weapon Weap, optional vector ForceVelocity)
{
	// do nothing
}


// Epic: This will determine and then return the FamilyInfo for this pawn
// PMC -- simplified this to always return the default
simulated function class<UTFamilyInfo> GetFamilyInfo()
{
	// just return the game's default family...
	return DefaultFamily;
}


// PMC - this function is called to setup the appearance of the characters
//  I've modified it to always make the character appear with the default mesh/material/anims
//  Even though it's called "notify team changed", it's also called when the team is set at the beginning
//  of the game.  So if you want to set the appearance of a character based on his/her team, this is the
//  place to do it.
// This also happens to be the only function/method to use DefaultMesh (that I know of)
/*
simulated function NotifyTeamChanged()
{
        local UTPlayerReplicationInfo PRI;
        local byte TeamNum;
        local bool bMeshChanged, bPhysicsAssetChanged;
        local PhysicsAsset OldPhysAsset;
        local int i;
        //--unused-- local class<UTFamilyInfo> Family;

        // set mesh to the one in the PRI, or default for this team if not found
        PRI = UTPlayerReplicationInfo(PlayerReplicationInfo);
        if (PRI == None && DrivenVehicle != None)
        {
                PRI = UTPlayerReplicationInfo(DrivenVehicle.PlayerReplicationInfo);
        }
        if (PRI != None)
        {
                if ( (PRI.Team != None) && !IsHumanControlled() || !IsLocallyControlled()  )
                {
                        LightEnvironment.LightDesaturation = 1.0;
                }

                // PMC -- This block of code makes the character always use the default meshes correctly
                // Family = class'UTCustomChar_Data'.static.FindFamilyInfo(PRI.CharacterData.FamilyID);
                // --unused-- Family = DefaultFamily;
                PRI.CharacterMesh = DefaultMesh;
                // end PMC

                // deleted unreachabled code...
                //if (True)
                //{
                        // force proper LOD levels for default mesh (hack code fix)
                        for ( i=0; i<DefaultMesh.LODInfo.Length; i++ )
                        {
                                DefaultMesh.LODInfo[i].DisplayFactor = FMax(0.0, 0.6 - 0.2*i);
                        }
                        
                        bMeshChanged = (DefaultMesh != Mesh.SkeletalMesh);
                        OldPhysAsset = Mesh.PhysicsAsset;

                        SetInfoFromFamily(DefaultFamily, DefaultMesh);

                        if(Mesh.PhysicsAsset != OldPhysAsset)
                        {
                                bPhysicsAssetChanged = TRUE;
                        }

                        if (OverlayMesh != None)
                        {
                                OverlayMesh.SetSkeletalMesh(DefaultMesh);
                        }

                        if (TRUE) // PMC -- WorldInfo.NetMode != NM_DedicatedServer && (!bReceivedValidTeam || bMeshChanged))
                        {
                                TeamNum = GetTeamNum();
                                VerifyBodyMaterialInstance();
                                BodyMaterialInstances[0].SetParent((TeamNum < DefaultTeamHeadMaterials.length) ? DefaultTeamHeadMaterials[TeamNum] : DefaultMesh.Materials[0]);
                                BodyMaterialInstances[1].SetParent((TeamNum < DefaultTeamMaterials.length) ? DefaultTeamMaterials[TeamNum] : DefaultMesh.Materials[1]);

                                // Assign fallback portrait.
                                PRI.CharPortrait = (TeamNum < DefaultTeamHeadPortrait.length) ? DefaultTeamHeadPortrait[TeamNum] : DefaultHeadPortrait;
                        }
                //}
				
                if (bMeshChanged && WorldInfo.NetMode != NM_DedicatedServer)
                {
                        // refresh weapon attachment
                        if (CurrentWeaponAttachmentClass != None)
                        {
                                // recreate weapon attachment in case the socket on the new mesh is in a different place
                                if (CurrentWeaponAttachment != None)
                                {
                                        CurrentWeaponAttachment.DetachFrom(Mesh);
                                        CurrentWeaponAttachment.Destroy();
                                        CurrentWeaponAttachment = None;
                                }
                                WeaponAttachmentChanged();
                        }
                        // refresh overlay
                        if (OverlayMaterialInstance != None)
                        {
                                SetOverlayMaterial(OverlayMaterialInstance);
                        }
                }

                // Make sure physics is in the correct state.
                if(bPhysicsAssetChanged || bMeshChanged)
                {
                        // Rebuild array of bodies to not apply joint drive to.
                        NoDriveBodies.length = 0;
                        for( i=0; i<Mesh.PhysicsAsset.BodySetup.Length; i++)
                        {
                                if(Mesh.PhysicsAsset.BodySetup[i].bAlwaysFullAnimWeight)
                                {
                                        NoDriveBodies.AddItem(Mesh.PhysicsAsset.BodySetup[i].BoneName);
                                }
                        }

                        // Reset physics state.
                        bIsHoverboardAnimPawn = FALSE;
                        ResetCharPhysState();
                }

                // Update first person arms
                NotifyArmMeshChanged(PRI);
        }

        if (!bReceivedValidTeam)
        {
                SetTeamColor();
                bReceivedValidTeam = (GetTeam() != None);
        }
}*/

defaultproperties
{

}