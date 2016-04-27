scriptName SkyVoxPlugin   extends Quest
{displays a multiple choice menu}
import Utility
import StringUtil
import Game
import SkyVoxScript

string output
ObjectReference Property _WhiteRun Auto
ObjectReference Property _HomeHijerim Auto
int property FORM_TYPE_SPELL = 22 autoreadonly

Form[] SAVED_ARC
Form[] SAVED_EPEE
Form[] SAVED_SHIELD
Form[] SAVED_SPELLS
string Function SkyPop() global native

event OnInit()    	
	print("game init") 
	initializeDatas()    
	run()
endevent 

Event OnPlayerLoadGame()
	print("game loaded") 
	run()
endEvent

function run()
	Actor player = Game.GetPlayer()	
   	While(True)

		output = SkyVoxScript.SkyPop()
   		;print(output) 
   		If(StringUtil.Find(output, "moveto") == 0)
   			If(StringUtil.Find(output, "maison") > 0)
   				Game.GetPlayer().MoveTo(_HomeHijerim)
   			elseIf(StringUtil.Find(output, "maison blancherive") > 0)
   				Game.GetPlayer().MoveTo(_HomeHijerim)
   			elseIf(StringUtil.Find(output, "blanche rive") > 0)
   				Game.GetPlayer().MoveTo(_WhiteRun)
   			EndIf
   		
   		elseIf(StringUtil.Find(output, "shout") == 0)
            ;Game.GetPlayer().DoCombatSpellApply(_SHOUT_LOKVAHKOOR, Game.GetPlayer())

        elseif(StringUtil.Find(output, "load") == 0)
            processLoad( StringUtil.SubString(output, 5) )
        elseif(StringUtil.Find(output, "save") == 0)
            processSave( StringUtil.SubString(output, 5) )
   		EndIf
    	Utility.Wait(0.02)
   	EndWhile
endfunction

Function processLoad(string data)
    print(data)
    if StringUtil.find(data, "arc") == 0
        int itemIdx = StringUtil.Substring(data, 4) as int
        setLeftHand(Game.GetPlayer(), SAVED_ARC[itemIdx])
    elseif StringUtil.find(data, "epee") == 0
        int itemIdx = StringUtil.Substring(data, 5) as int
        setRightHand(Game.GetPlayer(), SAVED_EPEE[itemIdx])
    elseif StringUtil.find(data, "bouclier") == 0
        int itemIdx = StringUtil.Substring(data, 9)  as int
        setLeftHand(Game.GetPlayer(), SAVED_SHIELD[itemIdx])
    elseif StringUtil.find(data, "spell") == 0
        int itemIdx = StringUtil.Substring(data, 6) as int
		if StringUtil.find(data, "double") > 0
	        setRightHand(Game.GetPlayer(), SAVED_SPELLS[itemIdx])
		    setLeftHand(Game.GetPlayer(), SAVED_SPELLS[itemIdx])
	    elseif StringUtil.find(data, "left") > 0
   		    setLeftHand(Game.GetPlayer(), SAVED_SPELLS[itemIdx])
	    else
	        setRightHand(Game.GetPlayer(), SAVED_SPELLS[itemIdx])
        endif
    endif
EndFunction


Function processSave(string data)
    print(data)
    if StringUtil.find(data, "arc") == 0
        int itemIdx = StringUtil.Substring(data, 4) as int 
        SAVED_ARC[itemIdx] = Game.GetPlayer().getEquippedObject(1)
    elseif StringUtil.find(data, "epee") == 0
        int itemIdx = StringUtil.Substring(data, 5)  as int 
        SAVED_EPEE[itemIdx] = Game.GetPlayer().getEquippedObject(1)
    elseif StringUtil.find(data, "bouclier") == 0
        int itemIdx = StringUtil.Substring(data, 9) as int 
        SAVED_SHIELD[itemIdx] = Game.GetPlayer().getEquippedObject(0)
    elseif StringUtil.find(data, "spell") == 0
        ;print(data)
        int itemIdx = StringUtil.Substring(data, 6)  as int 
        ;print(itemIdx)
        SAVED_SPELLS[itemIdx] = Game.GetPlayer().getEquippedObject(1)
    endif
EndFunction

function initializeDatas()
	SAVED_ARC = new Form[100]
    SAVED_EPEE = new Form[100]
    SAVED_SHIELD = new Form[100]
	SAVED_SPELLS = new Form[100]
endfunction

function setLeftHand(Actor a, Form f, int h = 0)
	Form cf = a.getEquippedObject(0)
	if f == None
		if cf.getType() == FORM_TYPE_SPELL
			a.unequipSpell(cf as Spell, 0)
		else
			a.unequipItemEx(cf, 2)
		endif
	elseif h != 0
		if cf != f || a.getEquippedItemId(0) != h
			a.equipItemById(f, h, 2)
		endif
	elseif cf != f
		if f.getType() == FORM_TYPE_SPELL
			a.equipSpell(f as Spell, 0)
		else
			a.equipItemEx(f, 2)
		endif
	endif
endfunction

function setRightHand(Actor a, Form f, int h = 0)
	Form cf = a.getEquippedObject(1)
	if f == None
		if cf.getType() == FORM_TYPE_SPELL
			a.unequipSpell(cf as Spell, 1)
		else
			a.unequipItemEx(cf, 1)
		endif
	elseif h != 0
		if cf != f || a.getEquippedItemId(0) != h
			a.equipItemById(f, h, 1)
		endif
	elseif cf != f
		if f.getType() == FORM_TYPE_SPELL
			a.equipSpell(f as Spell, 1)
		else
			a.equipItemEx(f, 1)
		endif
	endif
endfunction




;====================================
;     Debugging and notification
function dbg(string m)
	if !Debug.traceUser("SkyVox", m)
		Debug.openUserLog("SkyVox")
		if !Debug.traceUser("SkyVox", m)
			Debug.trace("SkyVox: " + m)
		endif
	endif
endfunction

function print(string m)
	Debug.notification(m)
	dbg(m)
endfunction
;     Debugging and notification
;====================================