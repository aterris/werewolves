class WW_PlayerController extends UTPlayerController;

var bool bSenseOn;

//GPM-Added the counted Kills var because it was missing and I wanted to test out the spawn timer, still getting warnings but this should at least let it compile//
var int countedKills;

//This is prof. Curry's code from his One Flag game type with the example code, 
//here he creates a spawn timer that we can easily change the spawn per pawn by changing the default properties in the pawn class

//START PROF. CURRY'S CODE//

// Respawn Timer Variables
var		int		iTicksToWaitBeforeRespawn;
var		int		iMaxTicksToWaitBeforeRespawn;
var		int		DeathCount;

state Dead
{
	reliable server function ServerReStartPlayer()
	{
		if ( WorldInfo.NetMode == NM_Client )
			return;

		// PMC new
		if (iTicksToWaitBeforeRespawn == 0)
		{
			ClearTimer('RespawnDelayTimer');
			// end PMC -- the indent below is mine...

			// If we're still attached to a Pawn, leave it
			if ( Pawn != None )
			{
				UnPossess();
			}

			WorldInfo.Game.RestartPlayer( Self );

		// PMC new
		}
		// end PMC
	}

	/** forces player to respawn if it is enabled */
	function DoForcedRespawn()
	{	
		if (PlayerReplicationInfo.bOnlySpectator)
		{
			ClearTimer('DoForcedRespawn');
		}
		// PMC -- don't ever force respawn
		return;
		/***
		else
		{
			ServerRestartPlayer();
		}
		***/
		// end PMC
	}

	// PMC -- new function to tick the respawn timer...
	function RespawnDelayTimer()
	{
		if (iTicksToWaitBeforeRespawn > 0)
		{
			iTicksToWaitBeforeRespawn--;
		}
	}

	function BeginState(Name PreviousStateName)
	{
		local UTGame_Werewolf WerewolfGame;

		// count how many times we've died
		DeathCount++;

		if (Role == ROLE_Authority) // && UTGame(WorldInfo.Game) != None && UTGame(WorldInfo.Game).ForceRespawn())
		{
			WerewolfGame = UTGame_Werewolf(WorldInfo.Game);
			if (WerewolfGame != None && PlayerReplicationInfo != None && PlayerReplicationInfo.Team != None)
			{
				if (PlayerReplicationInfo.Team.TeamIndex == 1)
				{
					// punish defenders for death by making them wait longer to respawn...
					iTicksToWaitBeforeRespawn = WerewolfGame.fTeamRespawnTimer[PlayerReplicationInfo.Team.TeamIndex];
				}
				else
				{
					iTicksToWaitBeforeRespawn = WerewolfGame.fTeamRespawnTimer[PlayerReplicationInfo.Team.TeamIndex];
				}
			}
			else
			{
				iTicksToWaitBeforeRespawn = iMaxTicksToWaitBeforeRespawn;
			}
			SetTimer(1.0, true, 'RespawnDelayTimer');
		}
		Super.BeginState(PreviousStateName);
	}

	function EndState(name NextStateName)
	{
		bUsePhysicsRotation = false;
		Super.EndState(NextStateName);
		SetBehindView(false);
		StopViewShaking();
		ClearTimer('PopupMap');
		ClearTimer('DoForcedRespawn');
		// PMC
		ClearTimer('DoForcedRespawn');
		// end PMC
	}
}

//END PROF. CURRY'S CODE//

exec function WerewolfSB()
{
	if(bSenseOn == false)
	{
		`log( "Sense ON!" );
		bSenseOn=true;
	}
	else
	{
		`log( "Sense OFF!" );
		bSenseOn=false;
	}
	
}

defaultproperties
{
	
	iTicksToWaitBeforeRespawn=0				// Set this to zero so you can spawn at the beginning of the match
	iMaxTicksToWaitBeforeRespawn=10
	DeathCount=0
	countedKills=0
	//GPM-This tells the game to use our Inputclass for our gametype, allowing us to
	//change the use of buttons, if you want to change a button do it in the ww_PlayerInput code.

	InputClass=class'UTGame_Werewolf.WW_PlayerInput'

	//GPM-Counted Kills Setting it to 0 at the begining of the match
}
