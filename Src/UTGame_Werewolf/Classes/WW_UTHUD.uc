class WW_UTHUD extends UTHUD;

// Werewolf Scent Variables
var float fWWScentDist;
var int   WW_RespawnCountDown; // this should match fTeamRespawnTimer(1) in UTGame_Werewolf
// End Werewolf Scent Variables

// Werewolf Custom Hud Variables
var const Texture2D CustomHudTexture;
// End Werewolf Custom Hud Variables

/* Werewolf Custom Hud requires the following Epic variables and functions */
var bool bShowDirectional;
var int LastScores[2];
var int ScoreTransitionTime[2];
var vector2D TeamIconCenterPoints[2];
var float LeftTeamPulseTime, RightTeamPulseTime;
var float OldLeftScore, OldRightScore;

// The scaling modifier will be applied to the widget that coorsponds to the player's team
var() float TeamScaleModifier;

var bool bScoreDebug;

exec function ToggleScoreDebug()
{
	bScoreDebug = !bScoreDebug;
}

function DisplayScoring()
{
	Super.DisplayScoring();

		DisplayTeamScore();
}

function Actor GetDirectionalDest(byte TeamIndex)
{
	return none;
}

function DisplayTeamLogos(byte TeamIndex, vector2d POS, optional float DestScale=1.0)
{
	if ( bShowDirectional && !bIsSplitScreen )
	{
		DisplayDirectionIndicator(TeamIndex, POS, GetDirectionalDest(TeamIndex), DestScale );
	}
}

function DisplayDirectionIndicator(byte TeamIndex, vector2D POS, Actor DestActor, float DestScale)
{
	local rotator Dir,Angle;
	local vector start;

	if ( DestActor != none )
	{
		Start = (PawnOwner != none) ? PawnOwner.Location : UTPlayerOwner.Location;
		Dir  = Rotator(DestActor.Location - Start);
		Angle.Yaw = (Dir.Yaw - PlayerOwner.Rotation.Yaw) & 65535;


		// Boost the colors a bit to make them stand out
		Canvas.DrawColor = WhiteColor;
		Canvas.SetPos(POS.X - (28.5 * DestScale * ResolutionScaleX), POS.Y - (26 * DestScale * ResolutionScale));
		Canvas.DrawRotatedTile( AltHudTexture, Angle, 57 * DestScale * ResolutionScaleX, 52 * DestScale * ResolutionScale, 897, 452, 43, 43);
	}
}
/* End Werewolf Custom Hud Epic */

// This function is modified to allow for custom win/lose messages
function DrawPostGameHud()
{
	local bool bWinner;

	if (WorldInfo.GRI != None 
		&& PlayerOwner.PlayerReplicationInfo != None 
		&& !PlayerOwner.PlayerReplicationInfo.bOnlySpectator
		&& !PlayerOwner.IsInState('InQueue') )
	{
		if ( UTPlayerReplicationInfo(WorldInfo.GRI.Winner) != none )
		{
			bWinner = UTPlayerReplicationInfo(WorldInfo.GRI.Winner) == UTOwnerPRI;
		}
		// automated testing will not have a valid winner
		else if( WorldInfo.GRI.Winner != none )
		{
			bWinner = WorldInfo.GRI.Winner.GetTeamNum() == UTPlayerOwner.GetTeamNum();
		}

		DisplayHUDMessage((bWinner ? YouHaveWon : YouHaveLost));
	}

	DisplayConsoleMessages();
} // DrawPostGameHud()

// This function is modified to allow for custom respawn messages
function DrawGameHud()
{
    local float xl, yl, ypos;
    local float TempResScale;
    local Pawn P;
    local int i, len;
    local UniqueNetId OtherPlayerNetId;
    
    local Controller AC;
    local array<Controller> allPlayers;

	//Get All Controllers
	i = 0;
	foreach WorldInfo.AllControllers(class'Controller', AC)
	{		
		if(AC.PlayerReplicationInfo.Team.TeamIndex==0)
		{
			allPlayers[i] = AC;
			i++;
		}
	}

    // Draw any spectator information
    if (UTOwnerPRI != None)
    {
        if (UTOwnerPRI.bOnlySpectator || UTPlayerOwner.IsInState('Spectating'))
        {
            P = Pawn(UTPlayerOwner.ViewTarget);
            if (P != None && P.PlayerReplicationInfo != None && P.PlayerReplicationInfo != UTOwnerPRI )
            {
                if (  UTPlayerOwner.bBehindView )
                {
                    DisplayHUDMessage(SpectatorMessage @ "-" @ P.PlayerReplicationInfo.GetPlayerAlias(), 0.05, 0.15);
                }
            }
            else
            {
                DisplayHUDMessage(SpectatorMessage, 0.05, 0.15);
            }
        }
        else if ( UTOwnerPRI.bIsSpectator )
        {
            if (UTGRI != None && UTGRI.bMatchHasBegun)
            {
                DisplayHUDMessage(PressFireToBegin);
            }
            else
            {
                DisplayHUDMessage(WaitingForMatch);
            }

        }
        else if ( UTPlayerOwner.IsDead() )
        {
			if(WW_RespawnCountDown > 0)
			{
				DisplayHUDMessage( UTPlayerOwner.bFrozen ? DeadMessage : "You will be reborn in " $ WW_RespawnCountDown );
			}
			else
			{
				DisplayHUDMessage( FireToRespawnMessage );
			}
        }
        else
        {
			if(allPlayers.Length == 2)
			{
				DisplayHUDMessage("Who will survive? " $ allPlayers[0].PlayerReplicationInfo.PlayerName $ " or " $ allPlayers[1].PlayerReplicationInfo.PlayerName $ "? Wage your bets now!");
			}
			else
			{
				// DisplayHUDMessage(allPlayers.Length $ " humans left!");
			}
		}
    }

    // Draw the Warmup if needed
    if (UTGRI != None && UTGRI.bWarmupRound)
    {
        Canvas.Font = GetFontSizeIndex(2);
        Canvas.DrawColor = WhiteColor;
        Canvas.StrLen(WarmupString, XL, YL);
        Canvas.SetPos((Canvas.ClipX - XL) * 0.5, Canvas.ClipY * 0.175);
        Canvas.DrawText(WarmupString);
    }

    if ( bCrosshairOnFriendly )
    {
        // verify that crosshair trace might hit friendly
        bGreenCrosshair = CheckCrosshairOnFriendly();
        bCrosshairOnFriendly = false;
    }
    else
    {
        bGreenCrosshair = false;
    }

    if ( bShowDebugInfo )
    {
        Canvas.Font = GetFontSizeIndex(0);
        Canvas.DrawColor = ConsoleColor;
        Canvas.StrLen("X", XL, YL);
        YPos = 0;
        PlayerOwner.ViewTarget.DisplayDebug(self, YL, YPos);

        if (ShouldDisplayDebug('AI') && (Pawn(PlayerOwner.ViewTarget) != None))
        {
            DrawRoute(Pawn(PlayerOwner.ViewTarget));
        }
        return;
    }

    if (bShowAllAI)
    {
        DrawAIOverlays();
    }

    if ( WorldInfo.Pauser != None )
    {
        Canvas.Font = GetFontSizeIndex(2);
        Canvas.Strlen(class'UTGameViewportClient'.default.LevelActionMessages[1],xl,yl);
        Canvas.SetDrawColor(255,255,255,255);
        Canvas.SetPos(0.5*(Canvas.ClipX - XL), 0.44*Canvas.ClipY);
        Canvas.DrawText(class'UTGameViewportClient'.default.LevelActionMessages[1]);
    }

    DisplayLocalMessages();
    DisplayConsoleMessages();

    Canvas.Font = GetFontSizeIndex(1);

    // Check if any remote players are using VOIP
    if ( (CharPRI == None) && (PlayerOwner.VoiceInterface != None) && (WorldInfo.NetMode != NM_Standalone)
        && (WorldInfo.GRI != None) )
    {
        len = WorldInfo.GRI.PRIArray.Length;
        for ( i=0; i<len; i++ )
        {
            OtherPlayerNetId = WorldInfo.GRI.PRIArray[i].UniqueID;
            if ( PlayerOwner.VoiceInterface.IsRemotePlayerTalking(OtherPlayerNetId)
                && (WorldInfo.GRI.PRIArray[i] != PlayerOwner.PlayerReplicationInfo)
                && (UTPlayerReplicationInfo(WorldInfo.GRI.PRIArray[i]) != None)
                && (PlayerOwner.GameplayVoiceMuteList.Find('Uid', OtherPlayerNetId.Uid) == INDEX_NONE) )
            {
                ShowPortrait(UTPlayerReplicationInfo(WorldInfo.GRI.PRIArray[i]));
                break;
            }
        }
    }

    // Draw the character portrait
    if ( CharPRI != None  )
    {
        DisplayPortrait(RenderDelta);
    }

    if ( bShowClock && !bIsSplitScreen )
    {
           DisplayClock();
       }

    if (bIsSplitScreen && bShowScoring)
    {
        DisplayScoring();
    }

    // If the player isn't dead, draw the living hud
    if ( !UTPlayerOwner.IsDead() )
    {
        DrawLivingHud();
    }

    if ( bHasMap && bShowMap )
    {
        TempResScale = ResolutionScale;
        if (bIsSplitScreen)
        {
            ResolutionScale *=2;
        }
        DisplayMap();
        ResolutionScale = TempResScale;
    }

    DisplayDamage();

    if (UTPlayerOwner.bIsTyping && WorldInfo.NetMode != NM_Standalone)
    {
        DrawMicIcon();
    }

    if ( bShowQuickPick )
    {
        DisplayQuickPickMenu();
    }
} // DrawGameHud()

// Werewolf Scent uses this function to draw health bars above players
function DrawLivingHud()
{
    local UTWeapon Weapon;
    local float Alpha;
    
    // Werewolf Scent
    local WW_PawnHuman p;
	local float Dist, HealthWidth, BarWidth, BarHeight;
	local vector ScreenLoc, CameraPosition, camFacing;
	local float playerHP;
	local vector VecToOther;
	//local float i; // debug

	//i = 0; // debug
	WW_RespawnCountDown = 10; // init countdown timer

	CameraPosition = UTPlayerController(PlayerOwner).CalcViewLocation; // our cam

	foreach WorldInfo.AllActors(class 'WW_PawnHuman', p) // loop through all the actors
	{	  
		// translate the 3D location of the actor into 2D space using Project()
		// GetCollisionHeight() sets root of vector to above the actor's head
		screenLoc = Canvas.Project(p.Location + p.GetCollisionHeight()*vect(0,0,1));		
	  
		// make sure not clipped out
		if (screenLoc.X < 0 ||
			screenLoc.X >= Canvas.ClipX ||
			screenLoc.Y < 0 ||
			screenLoc.Y >= Canvas.ClipY)
		{
			// DON'T DRAW THIS HEALTH BAR
		}
		else
		{
			if(p.Health < 25)
			{
			playerHP = 100/25;
			}
			else
			{
			playerHP = 100/p.Health;
			}
			
			VecToOther = CameraPosition - p.Location;
			camFacing = Normal(Vector(UTPlayerController(PlayerOwner).Rotation));
			
			if ((camFacing dot VecToOther) < 0.0)
			{
				/* old...
				Dist = VSize(VecToOther); // size of vector that spans from this actor to the camera
				// make the bar porpotional to the distance
				BarWidth = 15000 / Dist; // width of bar
				BarHeight = 5000 / Dist; // height of bar
				// however there is a limit to how big it can get
				if (BarWidth >= 80 || BarHeight >= 20) {
					BarWidth = 80;
					BarHeight = 30;
				}
				*/
				
				Dist = VSize(VecToOther); // size of vector that spans from this actor to the camera
				BarWidth = 20 * (1000/Dist); // width of bar
				BarHeight = 6 * (1000/Dist); // height of bar
				
				
				/*
				// Debug text
				Canvas.Font = class'Engine'.static.GetLargeFont();
				Canvas.DrawColor = RedColor;
				Canvas.SetPos(0.0, Canvas.ClipY * 0.5 + i);
				Canvas.DrawText("SUCCESS: " $ Dist);
				i+=20;
				*/

				if ( Dist < playerHP*fWWScentDist ) // if actor is close enough for the werewolf to "smell"
				{
					HealthWidth = BarWidth * FMin(1.0, p.Health/float(p.HealthMax)); // width is based on health
					// finally, draw the bar
					Class'UTHUD'.static.DrawHealth(ScreenLoc.X-0.5*BarWidth,ScreenLoc.Y-1.8*BarHeight, HealthWidth, BarWidth, BarHeight, Canvas);
				}
			}
		}
	}
	// End Werewolf Scent
	
	if ( !bIsSplitScreen && bShowScoring )
	{
		DisplayScoring();
	}

	// Pawn Doll
	if ( bShowDoll && UTPawnOwner != none )
	{
		DisplayPawnDoll();
	}

	// If we are driving a vehicle, give it hud time
	if ( bShowVehicle && UTVehicleBase(PawnOwner) != none )
	{
		UTVehicleBase(PawnOwner).DisplayHud(self, Canvas, VehiclePosition);
	}

	// Powerups
	if ( bShowPowerups && UTPawnOwner != none && UTPawnOwner.InvManager != none )
	{
		DisplayPowerups();
	}

	// Manage the weapon.  NOTE: Vehicle weapons are managed by the vehicle
	// since they are integrated in to the vehicle health bar
	if( PawnOwner != none )
	{
		Alpha = TeamHUDColor.A;
		if ( bShowWeaponBar )
    	{
			DisplayWeaponBar();
		}
		else if ( (Vehicle(PawnOwner) != None) && (PawnOwner.Weapon != LastSelectedWeapon) )
		{
			LastSelectedWeapon = PawnOwner.Weapon;
			PlayerOwner.ReceiveLocalizedMessage( class'UTWeaponSwitchMessage',,,, LastSelectedWeapon );
		}
		else if ( (PawnOwner.InvManager != None) && (PawnOwner.InvManager.PendingWeapon != None) && (PawnOwner.InvManager.PendingWeapon != LastSelectedWeapon) )
		{
			LastSelectedWeapon = PawnOwner.InvManager.PendingWeapon;
			PlayerOwner.ReceiveLocalizedMessage( class'UTWeaponSwitchMessage',,,, LastSelectedWeapon );
		}

		// The weaponbar potentially tweaks TeamHUDColor's Alpha.  Reset it here
		TeamHudColor.A = Alpha;

		if ( bShowAmmo )
		{
			Weapon = UTWeapon(PawnOwner.Weapon);
			if ( Weapon != none && UTVehicleWeapon(Weapon) == none )
			{
				DisplayAmmo(Weapon);
			}
		}

		if ( UTGameReplicationInfo(WorldInfo.GRI).bHeroesAllowed )
		{
			DisplayHeroMeter();
		}
	}
} // DrawLivingHud()

// Werewolf Custom Hud uses this function to get a custom team score
function int GetTeamScore(byte TeamIndex)
{
	/*if( (TeamIndex == 0 || TeamIndex == 1) && (UTGRI != None) && (UTGRI.Teams[TeamIndex] != None) )
	{
		LastScores[TeamIndex] = UTGRI.Teams[TeamIndex].Size;
		return UTGRI.Teams[TeamIndex].Size;
	}
	else
	{
		return 0;
	}*/

    if( (TeamIndex == 0 || TeamIndex == 1) && (UTGRI != None) && (UTGRI.Teams[TeamIndex] != None) )
    {
        return INT(UTGRI.Teams[TeamIndex].Score);
    }
    else
    {
        return 0;
    }

} // GetTeamScore()

// Werewolf Custom Hud uses this function to draw the top score area
function DisplayTeamScore()
{
	local float DestScale, W, H, POSX;
	local vector2d Logo;
	local byte TeamIndex;
	local LinearColor TeamLC;
	local color TextC;
	local int NewScore;
	local bool bShowIndicatorIcons;
	local int SavedOrgY;
	local float RightTeamScale;

	// If in split screen, don't draw the indicators and team logos.  We only want the score.
	bShowIndicatorIcons = true;
	if ( bIsSplitScreen )
	{
		// only draw on first player, since it bridges the gap
		if (!bIsFirstPlayer)
		{
			return;
		}

		// move down to bridge the gap
		SavedOrgY = Canvas.OrgY;
		Canvas.OrgY += Canvas.ClipY - 30 * ResolutionScale;
	}

	Canvas.DrawColor = WhiteColor;
    	W = 200;// * ResolutionScaleX;
    	H = 60;// * ResolutionScale;

	// left side is player's team, and is full size
	RightTeamScale = 1.0;

	// get player's team
	TeamIndex = UTPlayerOwner.GetTeamNum();

	// spectator or splitscreen (shared scores)
	if (TeamIndex == 255 || bIsSplitScreen)
	{
		TeamIndex = 0;
		RightTeamScale = 1.0;
	}

	// Draw the Left Team Indicator
	POSX = Canvas.ClipX * 0.5 - (W/2);

	Canvas.SetPos(POSX, 0);
	if ( bShowIndicatorIcons )
	{
		Canvas.DrawTile(CustomHudTexture, W, H, 0, 0, 393,107);
	}

	NewScore = GetTeamScore(1);

	if ( NewScore != OldLeftScore )
	{
		LeftTeamPulseTime = WorldInfo.TimeSeconds;
	}
	OldLeftScore = NewScore;

	Canvas.SetDrawColor(63,39,2,160);
	Canvas.Font=Font'TownTestMeshes_WW.WW_GothicFont';
	Canvas.SetPos(POSX + (W/2)-75 ,3);
	Canvas.DrawText(string(NewScore));

	// Draw the Right Team Indicator
	DestScale = RightTeamScale;
	TeamIndex = 1 - TeamIndex;
	GetTeamColor(TeamIndex, TeamLC, TextC);
	//POSX = Canvas.ClipX * 0.51;

	NewScore = GetTeamScore(0);

	if ( NewScore != OldRightScore )
	{
		RightTeamPulseTime = WorldInfo.TimeSeconds;
	}
	OldRightScore = NewScore;

	Canvas.SetPos(POSX,0);
	if ( bShowIndicatorIcons )
	{
		//Canvas.DrawColorizedTile(IconHudTexture, W * DestScale, H * DestScale, 0, 582, 214, 87, TeamLC);
	}
	Canvas.DrawColor = WhiteColor;

	Canvas.SetDrawColor(63,39,2,160);
	Canvas.Font=Font'TownTestMeshes_WW.WW_GothicFont';
	
	Canvas.SetPos(POSX + (W/2)+52 ,3);
	Canvas.DrawText(string(NewScore));
	
	if ( bShowIndicatorIcons )
	{
		if (DestScale < 1.0)
		{
			Logo.X = (POSX + (TeamIconCenterPoints[1].X) * DestScale * ResolutionScaleX) + (30 * ResolutionScaleX);
			Logo.Y = ((TeamIconCenterPoints[1].Y) * DestScale * ResolutionScale) + (27.5 * ResolutionScale);
   			DisplayTeamLogos(TeamIndex,Logo, 1.0);
		}
		else
		{
			Logo.X = (POSX + 15 * DestScale * ResolutionScaleX) + (30 * ResolutionScaleX);
			Logo.Y = (27 * DestScale * ResolutionScale) + (27.5 * ResolutionScale);
	   		DisplayTeamLogos(TeamIndex, Logo, 1.5);
		}
	}

	if ( bIsSplitScreen )
	{
		Canvas.OrgY = SavedOrgY;
	}
} // DisplayTeamScore()

// Werewolf Custom Hud uses this function to draw the lower left health
function DisplayPawnDoll()
{
	local vector2d POS;
	local int Health;
	local float xl,yl;
	local float ArmorAmount;
	local linearcolor ScaledWhite, ScaledTeamHUDColor;

	POS = ResolveHudPosition(DollPosition,216, 115);
	Canvas.DrawColor = WhiteColor;

	// should doll be visible?
	ArmorAmount = UTPawnOwner.ShieldBeltArmor + UTPawnOwner.VestArmor + UTPawnOwner.HelmetArmor + UTPawnOwner.ThighpadArmor;

	if ( (ArmorAmount > 0) || (UTPawnOwner.JumpbootCharge > 0) )
	{
		DollVisibility = FMin(DollVisibility + 3.0 * (WorldInfo.TimeSeconds - LastDollUpdate), 1.0);
	}
	else
	{
		DollVisibility = FMax(DollVisibility - 3.0 * (WorldInfo.TimeSeconds - LastDollUpdate), 0.0);
	}
	LastDollUpdate = WorldInfo.TimeSeconds;

	POS.X = POS.X + (DollVisibility - 1.0)*HealthOffsetX*ResolutionScale;
	ScaledWhite = LC_White;
	ScaledWhite.A = DollVisibility;
	ScaledTeamHUDColor = TeamHUDColor;
	ScaledTeamHUDColor.A = FMin(DollVisibility, TeamHUDColor.A);

	// First, handle the Pawn Doll
	if ( DollVisibility > 0.0 )
	{
		// The Background
		Canvas.SetPos(POS.X,POS.Y);
		Canvas.DrawColorizedTile(AltHudTexture, PawnDollBGCoords.UL * ResolutionScale, PawnDollBGCoords.VL * ResolutionScale, PawnDollBGCoords.U, PawnDollBGCoords.V, PawnDollBGCoords.UL, PawnDollBGCoords.VL, ScaledTeamHUDColor);

		// The ShieldBelt/Default Doll
		Canvas.SetPos(POS.X + (DollOffsetX * ResolutionScale), POS.Y + (DollOffsetY * ResolutionScale));
		if ( UTPawnOwner.ShieldBeltArmor > 0.0f )
		{
			DrawTileCentered(AltHudTexture, DollWidth * ResolutionScale, DollHeight * ResolutionScale, 71, 224, 56, 109,ScaledWhite);
		}
		else
		{
			DrawTileCentered(AltHudTexture, DollWidth * ResolutionScale, DollHeight * ResolutionScale, 4, 224, 56, 109, ScaledTeamHUDColor);
		}

		if ( UTPawnOwner.VestArmor > 0.0f )
		{
			Canvas.SetPos(POS.X + (VestX * ResolutionScale), POS.Y + (VestY * ResolutionScale));
			DrawTileCentered(AltHudTexture, VestWidth * ResolutionScale, VestHeight * ResolutionScale, 132, 220, 46, 28, ScaledWhite);
		}

		if (UTPawnOwner.ThighpadArmor > 0.0f )
		{
			Canvas.SetPos(POS.X + (ThighX * ResolutionScale), POS.Y + (ThighY * ResolutionScale));
			DrawTileCentered(AltHudTexture, ThighWidth * ResolutionScale, ThighHeight * ResolutionScale, 134, 263, 42, 28, ScaledWhite);
		}

		if (UTPawnOwner.HelmetArmor > 0.0f )
		{
			Canvas.SetPos(POS.X + (HelmetX * ResolutionScale), POS.Y + (HelmetY * ResolutionScale));
			DrawTileCentered(AltHudTexture, HelmetHeight * ResolutionScale, HelmetWidth * ResolutionScale, 193, 265, 22, 25, ScaledWhite);
		}

		if (UTPawnOwner.JumpBootCharge > 0 )
		{
			Canvas.SetPos(POS.X + BootX*ResolutionScale, POS.Y + BootY*ResolutionScale);
			DrawTileCentered(AltHudTexture, BootWidth * ResolutionScale, BootHeight * ResolutionScale, 222, 263, 54, 26, ScaledWhite);

			Canvas.Strlen(string(UTPawnOwner.JumpBootCharge),XL,YL);
			Canvas.SetPos(POS.X + (BootX-1)*ResolutionScale - 0.5*XL, POS.Y + (BootY+3)*ResolutionScale - 0.5*YL);
			Canvas.DrawTextClipped( UTPawnOwner.JumpBootCharge, false, 1.0, 1.0 );
		}
	}

	// Next, the health and Armor widgets
	
	// Werewolf Custom Hud
	Canvas.SetPos(POS.X + HealthBGOffsetX * ResolutionScale,POS.Y + HealthBGOffsetY * ResolutionScale);
	
	Canvas.DrawColor = WhiteColor;
	Canvas.DrawTile(CustomHudTexture, (HealthBGCoords.UL) * ResolutionScale, HealthBGCoords.VL * ResolutionScale, 0, 115, 195,97);
	

	// Draw the Health Text
	Health = UTPawnOwner.Health;

	// Figure out if we should be pulsing
	if ( Health > LastHealth )
	{
		HealthPulseTime = WorldInfo.TimeSeconds;
	}
	LastHealth = Health;

	Canvas.SetDrawColor(63,39,2,160);
	Canvas.Font=Font'TownTestMeshes_WW.WW_GothicFont';
	Canvas.SetPos((POS.X + HealthTextX * ResolutionScale)-60,(POS.Y + HealthTextY * ResolutionScale)+8);
	Canvas.DrawText(string(Health));
	
	// End Werewolf Custom Hud
} // DisplayPawnDoll()

// Werewolf Custom Hud uses this function to draw the lower right ammo
function DisplayAmmo(UTWeapon Weapon)
{
	local vector2d POS;
	local string Amount;
	local float BarWidth;
	local float PercValue;
	local int AmmoCount;
	local int AmmoOffset;

	if ( Weapon.AmmoDisplayType == EAWDS_None )
	{
		return;
	}

	// Resolve the position
	POS = ResolveHudPosition(AmmoPosition,AmmoBGCoords.UL,AmmoBGCoords.VL);

	if ( Weapon.AmmoDisplayType != EAWDS_BarGraph )
	{
		// Figure out if we should be pulsing
		AmmoCount = Weapon.GetAmmoCount();

		if ( AmmoCount > LastAmmoCount && LastWeapon == Weapon )
		{
			AmmoPulseTime = WorldInfo.TimeSeconds;
		}

		LastWeapon = Weapon;
		LastAmmoCount = AmmoCount;	
	
		// Draw the background
		Canvas.DrawColor = WhiteColor; 
		if(UTWeap_Crossbow(Weapon).showAltFire)
		{
			//Draw Background
			Canvas.SetPos(POS.X,POS.Y - (AmmoBarOffsetY * ResolutionScale));
			Canvas.DrawTile(CustomHudTexture, AmmoBGCoords.UL * ResolutionScale, AmmoBGCoords.VL * ResolutionScale, 198, 118, 284, 93);
			
			//Draw Icon
			if(UTWeap_Crossbow(Weapon).bAllowPush)
			{
				Canvas.SetPos(POS.X+110,POS.Y - (AmmoBarOffsetY * ResolutionScale));
				Canvas.DrawTile(CustomHudTexture, 52, AmmoBGCoords.VL * ResolutionScale, 397, 10, 89, 87);
			}
			AmmoOffset=0;
		}
		else
		{
			//Draw Background
			Canvas.SetPos(POS.X+52,POS.Y - (AmmoBarOffsetY * ResolutionScale));
			Canvas.DrawTile(CustomHudTexture, AmmoBGCoords.UL * ResolutionScale, AmmoBGCoords.VL * ResolutionScale, 198, 118, 284, 93);
			AmmoOffset=52;
		}

		// Draw the amount
		if(UTWeap_Crossbow(Weapon).silverBullets!=0)
		{
			Amount = ""$AmmoCount$"+"$UTWeap_Crossbow(Weapon).silverBullets;
			AmmoTextOffsetX=13+AmmoOffset;
		}
		else
		{
			Amount = ""$AmmoCount;
			AmmoTextOffsetX=38+AmmoOffset;
		}
		
		//Adjust for Number of Digits
		if(AmmoCount<10)
			AmmoTextOffsetX+=7;
		else if(AmmoCount>99)
			AmmoTextOffsetX-=9;
		
		//Canvas.DrawColor = WhiteColor; 
		//Canvas.Font=HudFonts(0)=MultiFont'UI_Fonts_Final.HUD.MF_Small'

		//DrawGlowText(Amount, POS.X + (AmmoTextOffsetX * ResolutionScale), POS.Y - ((AmmoBarOffsetY + AmmoTextOffsetY) * ResolutionScale), 58 * ResolutionScale, AmmoPulseTime,true);
		
		//changes ammottextoffset in defaults
		Canvas.SetPos(POS.X + (AmmoTextOffsetX * ResolutionScale) ,POS.Y - ((AmmoBarOffsetY + AmmoTextOffsetY) * ResolutionScale));
		Canvas.SetDrawColor(63,39,2,160);
		Canvas.Font=Font'TownTestMeshes_WW.WW_GothicFont';
		Canvas.DrawText(Amount);
	}

	// If we have a bar graph display, do it here
	if ( Weapon.AmmoDisplayType != EAWDS_Numeric )
	{
		PercValue = Weapon.GetPowerPerc();

		Canvas.SetPos(POS.X + (40 * ResolutionScale), POS.Y - 8 * ResolutionScale);
		Canvas.DrawColorizedTile(AltHudTexture, 76 * ResolutionScale, 18 * ResolutionScale, 376,458, 88, 14, LC_White);

		BarWidth = 70 * ResolutionScale;
		DrawHealth(POS.X + (43 * ResolutionScale), POS.Y - 4 * ResolutionScale, BarWidth * PercValue,  BarWidth, 16, Canvas);
	}
} // DisplayAmmo()

// Werewolf Custom Hud requires this function to be nullified
function DisplayFragCount(vector2d POS)
{
	// disable this function!
} // DisplayFragCount()

// Custom Respawn Count Down Timer...
simulated event Timer()
{
	if(UTPlayerOwner.IsDead())
	{
		WW_RespawnCountDown--; // increment CountDown timer
	}
	
	Super.Timer();
	if ( WorldInfo.GRI != None )
	{
		WorldInfo.GRI.SortPRIArray();
	}
} // Timer()

defaultproperties
{
	// Werewolf Scent
    fWWScentDist=1000.000000 // how close actors must be before the werewolf can "smell" them

   TeamIconCenterPoints(0)=(X=140.000000,Y=27.000000)
   TeamIconCenterPoints(1)=(X=5.000000,Y=13.000000)
   TeamScaleModifier=0.750000
   bHasLeaderboard=False
   ScoreboardSceneTemplate=UTUIScene_TeamScoreboard'UI_Scenes_Scoreboards.sbTeamDM'
   CustomHudTexture=Texture2D'TownTestMeshes_WW.HUD.WerewolfHud'
   Name="Default__WW_UTHUD"
   ObjectArchetype=UTHUD'UTGame.Default__UTHUD'
   
   WarmupString="Warmup Round"
   WaitingForMatch="A full moon is approaching fast... Prepare yourself!"
   PressFireToBegin="Press [FIRE] to Begin..."
   SpectatorMessage="Spectator"
   DeadMessage="Death hath become you!"
   FireToRespawnMessage="Press [FIRE] to respawn."
   YouHaveWon="Congrats! You will now become the Werewolf."
   YouHaveLost="You have lost."
}