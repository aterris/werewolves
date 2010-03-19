class WW_PawnHuman extends WW_Pawn;


// Werewolf Scent Variables
var float                            fWWScentDist;
// End Werewolf Scent

// NOTE: this won't render the healthbar if actor isn't being rendered (eg. if actor is behind a wall and out of site)
simulated event PostRenderFor(PlayerController PC, Canvas Canvas, vector CameraPosition, vector CameraDir)
{
    local float Dist, HealthWidth, BarWidth, BarHeight;
    local vector ScreenLoc;
    //local vector tempCameraPosition;

    //CameraPosition = UTPlayerController(self.Controller).Camera.Location;
    CameraPosition = UTPlayerController(self.Controller).CalcViewLocation;
  
    if ( WorldInfo.GRI.OnSameTeam(self, PC) )
    {
        return;
    }
           /*
           Canvas.Font = class'Engine'.static.GetLargeFont();
        Canvas.DrawColor = RedColor;
        Canvas.SetPos(0.0, Canvas.ClipY * 0.5);
        Canvas.DrawText("SOME CAMPAIGN BOTS WERE NOT FOUND! CHECK LOG FOR DETAILS");
        */
  
    // translate the 3D location of the actor into 2D space using Project()
    // GetCollisionHeight() sets root of vector to above the actor's head
    screenLoc = Canvas.Project(Location + GetCollisionHeight()*vect(0,0,1));
  
    // make sure not clipped out
    if (screenLoc.X < 0 ||
        screenLoc.X >= Canvas.ClipX ||
        screenLoc.Y < 0 ||
        screenLoc.Y >= Canvas.ClipY)
    {
        return;
    }

    Dist = VSize(CameraPosition - Location); // size of vector that spans from this actor to the camera
    BarWidth = 60; // width of bar
    BarHeight = 30; // height of bar

    if ( Dist < fWWScentDist ) // if actor is close enough for the werewolf to "smell"
    {
        HealthWidth = BarWidth * FMin(1.0, Health/float(HealthMax)); // width is based on health
        // finally, draw the bar
        Class'UTHUD'.static.DrawHealth(ScreenLoc.X-0.5*BarWidth,ScreenLoc.Y-1.8*BarHeight, HealthWidth, BarWidth, BarHeight, Canvas);
    }
}




//GPM-This is a simple sprint function

//GPM-Simple sprint function//
exec function StartRunning()
{

	GotoState('Sprinting');

	//set the new groundspeed, change the 1.25 to change the speed of the sprint
	GroundSpeed = GroundSpeed * 1.25;

}

exec function EndRunning()
{
	GotoState('WeaponEquipping');
	GroundSpeed = default.GroundSpeed;
}

state Sprinting
{
	simulated function StartFire(byte FireModeNum)
	{
		//Do Nothing
		`log("You don't get to fire bitch!");
	}

}


defaultproperties
{
    // Werewolf Scent
    //fWWScentDist=700.000000 //how close actors must be before the werewolf can "smell" them
    
	///Player health///
	Health = 100
	HealthMax = 100
	
	///Player movement///
	//GPM-Keeping this function in just incase we want to
	//speed up the humans or take it away at anytime...
	
	//GPM-Might want to use a var so I can include sprinting
	//and walking better, will look into it later...
	GroundSpeed=420.0	///was 440.0
	
	///PLAYER INVENTORY///
	DefaultInventory(0)=class 'UTWeap_Crossbow'
	DefaultInventory(1)=class 'UTWeap_SilverBullet'
	
	//GPM-Puts Dodges to 0 until I can find a turn off function
	DodgeSpeed=0
  	DodgeSpeedZ=0
  	
  	//GPM-Takes away the second jump after the first one
	MaxMultiJump=0			// was 1
	MultiJumpRemaining=0		// was 1

	//Jump height
	JumpZ=322;				// was 322.0

	/** Visual Description ***/

	DefaultFamily=class'UTFamilyInfo_Ironguard_Male'
	DefaultMesh=SkeletalMesh'CH_IronGuard_Male.Mesh.SK_CH_IronGuard_MaleA'
	DefaultHeadPortrait=Texture'CH_IronGuard_Headshot.T_IronGuard_HeadShot_DM'

	DefaultTeamMaterials[0]=MaterialInterface'CH_IronGuard_Male.Materials.MI_CH_IronG_Mbody01_VRed'
	DefaultTeamHeadMaterials[0]=MaterialInterface'CH_IronGuard_Male.Materials.MI_CH_IronG_MHead01_VRed'
	DefaultTeamHeadPortrait[0]=Texture'CH_IronGuard_Headshot.T_IronGuard_HeadShot_Red'

	DefaultTeamMaterials[1]=MaterialInterface'CH_IronGuard_Male.Materials.MI_CH_IronG_Mbody01_VBlue'
	DefaultTeamHeadMaterials[1]=MaterialInterface'CH_IronGuard_Male.Materials.MI_CH_IronG_MHead01_VBlue'
	DefaultTeamHeadPortrait[1]=Texture'CH_IronGuard_Headshot.T_IronGuard_HeadShot_Blue'


}