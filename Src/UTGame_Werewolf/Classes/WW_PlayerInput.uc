class WW_PlayerInput extends UTPlayerInput within WW_PlayerController;

//GPM-This is the new bindings for our players, all new buttons or changed buttons from
//unreal place here. If you look into "PlayerInput.ini"(I think its player input) in
//your MyDocs/MyGames/UT3/(Something else, idk)/There should be a file called Config 
//Here there should be tons of button commands for unreal, just c and p here with 
//your new functions added to them. It should just over-ride the original buttons
//from unreal and add ours in that will just work for our game type...
 
defaultproperties
{
	//Bindings(137)=(Name="LeftShift",Command="StartRunning | OnRelease EndRunning")

}