scriptName SkyVoxCommandFollowers extends SkyVoxCommandAlias hidden

import SkyVoxCore

; -------------------------------------
;
; > followers  [all]  [summon|follow|stealth|wait|relax|attack]
;	
function OnSkyVoxCommand(string[] args)
	if(args[0] == "followers")
        processFollowers(args)
	EndIf
endfunction


Function processFollowers(string[] args) 
	TweakFollowerScript tweakFollowersScript = Game.GetFormFromFile(0x020012CE,"AmazingFollowerTweaks.esp")   As TweakFollowerScript
	if !tweakFollowersScript
		print("error tweak...")
	endif
	print(args[0] + " " + args[1] + " " + args[2])
	if args[2] == "summon"
		tweakFollowersScript.GetFollowersHelper(Game.GetPlayer())
	elseif args[2] == "follow"
		tweakFollowersScript.GetFollowersHelper(Game.GetPlayer())
		tweakFollowersScript.AllFollowersFollow()
	elseif args[2] == "wait"
		tweakFollowersScript.AllFollowersWait()
	elseif args[2] == "relax"
		tweakFollowersScript.AllFollowersRelax()
	elseif args[2] == "stealth"
		tweakFollowersScript.Stealth()
	elseif args[2] == "attack"
		tweakFollowersScript.AllAttack()
		(tweakFollowersScript.DialogueFollower as TweakDFScript).FollowerFollow()
	endif
EndFunction