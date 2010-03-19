class UTGame_Werewolf extends UTTeamGame;

///Little Werewolf Pawn Var///
//var bool bUseLittleWerewolf;

var Controller MainWerewolf;

//GPM-Prof. Curry's Spawn Vars//
var class<Pawn> TeamPawnClass[2];
var float fTeamRespawnTimer[2];

/*
function ResetTeams()
{
	local PlayerController PC;
	local PlayerController highestKiller;
	local array<PlayerController> allPlayers;
	local int numberKills;
	local int i;	
	
	numberKills=0;
	
	foreach WorldInfo.AllControllers(class'PlayerController', PC)
	{
		//if ( (PC.PlayerReplicationInfo != None) && (PC.PlayerReplicationInfo.Team != None) )
		//{
			allPlayers[allPlayers.Length] = PC;
			
			if(WW_PlayerController(PC).countedKills>numberKills)
			{
				numberKills=WW_PlayerController(PC).countedKills;
				highestKiller=PC;
			}
		//}
	}
	for (i=0; i < allPlayers.Length; i++)
	{
		if(allPlayers[i]==highestKiller)
		{
			SetTeam(allPlayers[i], Teams[1], true);
		}
		else
		{
			SetTeam(allPlayers[i], Teams[0], true);
		}	
	}
	return;
}
*/

function InitGame( string Options, out string ErrorMessage )
{
	Super.InitGame(Options, ErrorMessage);  
}

function PostBeginPlay()
{
	Super.PostBeginPlay();
}



// PMC new function copied from http://forums.epicgames.com/archive/index.php?t-623343.html
//  Let's you define a new pawn class per player, and in our case we're defining a new class per team

//GPM-This is the basic way to give the two different teams two different pawns
//allowing us to create different 'Classes' of players like a Werewolf and a human with different
//Speeds, healths, jump height, etc.

//GPM-I created 2 pawns for the Werewolf Team, one is the main Werewolf while the other is a weaker version, we still need
//to test the healths, speeds, etc. of each and get balancing done....

//GPM-Also right now this just tests if the Werewolf team already has a werewolf then if the team has 1 person or more it makes everyone
//who spawns on the Werewolf team into a Little Werewolf, so if the big Werewolf dies he spawns as a little one, we need a way to fix this still...

function class<Pawn> GetDefaultPlayerClass(Controller C)
{
	local int TeamNum;

	TeamNum = C.GetTeamNum();

	if(TeamNum == 0)
	{
		return Class'UTGame_Werewolf.WW_PawnHuman';
	}
	else if(TeamNum == 1)
	{

		if(C == MainWerewolf)
		{
			return Class'UTGame_Werewolf.WW_PawnWerewolf';
		}
		else
		{
			return Class'UTGame_Werewolf.WW_PawnWerewolf_Little';	
		}
		
	}	
	else
	{
		// The code should never get here...
		return DefaultPawnClass;
	}	
}

// PMC - since our pawn classes have their own inventory contents we don't need this function to do anything
//  other than call the pawn's add inventory function
function AddDefaultInventory( pawn PlayerPawn )
{
	PlayerPawn.AddDefaultInventory();
	Teams[0].Score=Teams[0].Size;
	Teams[1].Score=Teams[1].Size;

	//GPM-Checks Werewolf team to find main werewolf
	CheckWerewolfTeam();
	
	
}


//GPM-This function was to force a team change for the players that are killed, it needs testing as
//it doesn't seem to be working correctly right now...

function Killed( Controller Killer, Controller KilledPlayer, Pawn KilledPawn, class<DamageType> damageType )
{
	local int TeamNum;
	
	TeamNum = KilledPlayer.GetTeamNum();
	
	//Count Kill if Human Kills Werewolf (should also if original werewolf kills human)
	if(Killer.GetTeamNum()==0)
	{
		WW_PlayerController(Killer).countedKills++;
	}
	
	if(TeamNum == 1)
	{	
		//Do Nothing
	}
	else if(TeamNum == 0)
	{
		//ChangeTeam(KilledPlayer,1,true);
		SetTeam(KilledPlayer, Teams[1], true); // PMC -- this works for me instead of ChangeTeam

		CheckHumanTeam();//GPM-I'm calling my CheckHumanTeam here everytime a Human player is killed to see if the round is over
	}
	else
	{
		// The code should never get here...
	}	
    
	//then finish the rest of the Killed-related stuff: 
	Super.Killed(Killer, KilledPlayer, KilledPawn, damageType);
	
	Teams[0].Score=Teams[0].Size;
	Teams[1].Score=Teams[1].Size;
	
}

// PMC -- custom balancing function, will start the game with one player on blue
function BalanceTeams(optional bool bForceBalance)
{
local Controller PC;
	//local int RedCount, BlueCount, i; //MoveCount, 
	//local array<Controller> RedPlayers, BluePlayers;
	//local UniqueNetId ZeroNetId;

	// PMC this makes it where the players are never balanced...
	//return;
	//

	if (true) // !bPlayersVsBots && (bPlayersBalanceTeams || bForceBalance) && SinglePlayerMissionID == INDEX_NONE && (WorldInfo.NetMode != NM_Standalone) )
	{
		// re-balance teams
		// first - count humans on each team
		
		
		foreach WorldInfo.AllControllers(class'Controller', PC)
		{
			//SetTeam(PC,Teams[0],true);
			
			if ( (PC.PlayerReplicationInfo != None) && (PC.PlayerReplicationInfo.Team.TeamIndex == 0) )
			{
				SetTeam(PC,Teams[1],false);
			}
			else//if on team[1]
			{
				SetTeam(PC,Teams[0],false);
			}
		}

		return;
		
	}
}

// PMC -- force all bots to spawn on a specific team
function UTTeamInfo GetBotTeam(optional int TeamBots,optional bool bUseTeamIndex, optional int TeamIndex)
{
	return Teams[0];
}

// PMC -- this seems like a dangerous hack, but it works.
function bool TooManyBots(Controller botToRemove)
{
	return false;
}

//GPM-This function checks to see if the Human team has either 1 or less then one player left, 
//if they do the game is over and the last person on red wins...
function CheckHumanTeam()
{
	if(Teams[0].Size <= 1)
	{
		Teams[0].score += 1000; // Give's The Human Team A ton of points!
		EndGame(None,"LastMan");
	}


}

//GPM-This is really just a hack to test both pawns
function CheckWerewolfTeam()
{
	local Controller AC;
	local array<Controller> allPlayers;
	local int i;	
	
	if(Teams[1].Size == 1)
	{
		
		foreach WorldInfo.AllControllers(class'Controller', AC)
		{
			allPlayers[allPlayers.Length] = AC;
		}
		
		for (i=0; i < allPlayers.Length; i++)
		{
			if(allPlayers[i].PlayerReplicationInfo.Team.TeamIndex==1)
			{
				MainWerewolf = allPlayers[i];
				`log("Werewolf Selected!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
				`log(MainWerewolf);
			}
		}
		
	}


}

//AT
function byte PickTeam(byte num, Controller C)
{
	local UTTeamInfo humanTeam, werewolfTeam, newTeam;
	//local Controller B; // COMMENTED B/C OF BUILD WARNING
	//local int BigTeamBots, SmallTeamBots; // COMMENTED B/C OF BUILD WARNING

	//Get Teams
	humanTeam = Teams[0];
	werewolfTeam = Teams[1];

	//Allow Specific Team Setting
	if ( num < 2 )
	{
		newTeam = Teams[num];
	}

	//Default Set Team
	if ( newTeam == None )
	{
		if(humanTeam.size>0 || werewolfTeam.size>0)
		{
			newTeam=humanTeam;
		}
		else
		{
			newTeam=werewolfTeam;
		}
	}

	return newTeam.TeamIndex;
}

function bool CheckEndGame(PlayerReplicationInfo Winner, string Reason)
{
	local Controller P;
    //local bool bLastMan; // COMMENTED B/C OF BUILD WARNING

	//Get All Player
	
	//If Only 1 Human Left
	if(Teams[0].size==1)
	{
		foreach WorldInfo.AllControllers(class'Controller', P)
		{
			if (P.PlayerReplicationInfo.Team.TeamIndex==0)
			{
				SetEndGameFocus(P.PlayerReplicationInfo);
			}
		}
		//SetEndGameFocus(P.PlayerReplicationInfo);
		return true;
	}
	return false;
}


function determineAwards()
{/*
	//Variables
	local Controller P;
	local array<PlayerController> allPlayers;
	
	//Iterate
	foreach WorldInfo.AllControllers(class'PlayerController', P)
	{
		//Last Man Standing
	}
*/		
}
defaultproperties
{
	MapPrefixes[0]="DM"
	
	MapPrefixes[1]="WW" //GPM-When creating maps place the Prefix as WW infront of the map name as "WW-Village" and it will be in our start up levels
	Acronym="WW"

	//GPM-This shows what player controller the game should use
	PlayerControllerClass= class'UTGame_Werewolf.WW_PlayerController'
	
	//This should allow unbalanced teams, has to be tested...
	//GPM-Aparently this does nothing, still looking for something that works to unbalance teams...

	bPlayersBalanceTeams = false
	HUDType=Class'WW_UTHUD'

	//Level must use team starts now
	bSpawnInTeamArea=True

	// Respawn Timers for each team
	fTeamRespawnTimer(0)=0.0
	fTeamRespawnTimer(1)=10.0
}