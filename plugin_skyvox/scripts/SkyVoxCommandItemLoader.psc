scriptName SkyVoxCommandItemLoader extends SkyVoxCommandAlias hidden
{displays a multiple choice menu}

import Game
import SkyVoxCore

int property FORM_TYPE_SPELL = 22 autoreadonly

Form[] SAVED_ITEMS
Form[] SAVED_SETS_0
Form[] SAVED_SETS_1
Form[] SAVED_SETS_2
Form[] SAVED_SETS_3
Form[] SAVED_SETS_4
Form[] SAVED_SETS_5
Form[] SAVED_SETS_6
Form[] SAVED_SETS_7
Form[] SAVED_SETS_8
Form[] SAVED_SETS_9
Form[] SAVED_SETS_10
Form[] SAVED_SETS_11
Form[] SAVED_SETS_12
Form[] SAVED_SETS_13
Form[] SAVED_SETS_14
Form[] SAVED_SETS_15
Form[] SAVED_SETS_16
Form[] SAVED_SETS_17
Form[] SAVED_SETS_18
Form[] SAVED_SETS_19
Form[] SAVED_SETS_20
Form[] SAVED_SETS_21
Form[] SAVED_SETS_22
Form[] SAVED_SETS_23
Form[] SAVED_SETS_24
Form[] SAVED_SETS_25
Form[] SAVED_SETS_26
Form[] SAVED_SETS_27
Form[] SAVED_SETS_28
Form[] SAVED_SETS_29
Form[] SAVED_SETS_30
Form[] SAVED_SETS_31
Form[] SAVED_SETS_32
Form[] SAVED_SETS_33
Form[] SAVED_SETS_34
Form[] SAVED_SETS_35
Form[] SAVED_SETS_36
Form[] SAVED_SETS_37
Form[] SAVED_SETS_38
Form[] SAVED_SETS_39
Form[] SAVED_SETS_40
Form[] SAVED_SETS_41
Form[] SAVED_SETS_42
Form[] SAVED_SETS_43
Form[] SAVED_SETS_44
Form[] SAVED_SETS_45
Form[] SAVED_SETS_46
Form[] SAVED_SETS_47
Form[] SAVED_SETS_48
Form[] SAVED_SETS_49
Form[] SAVED_SETS_50
Form[] SAVED_SETS_51
Form[] SAVED_SETS_52
Form[] SAVED_SETS_53
Form[] SAVED_SETS_54
Form[] SAVED_SETS_55
Form[] SAVED_SETS_56
Form[] SAVED_SETS_57
Form[] SAVED_SETS_58
Form[] SAVED_SETS_59
Form[] SAVED_SETS_60
Form[] SAVED_SETS_61
Form[] SAVED_SETS_62
Form[] SAVED_SETS_63
Form[] SAVED_SETS_64
Form[] SAVED_SETS_65
Form[] SAVED_SETS_66
Form[] SAVED_SETS_67
Form[] SAVED_SETS_68
Form[] SAVED_SETS_69
Form[] SAVED_SETS_70
Form[] SAVED_SETS_71
Form[] SAVED_SETS_72
Form[] SAVED_SETS_73
Form[] SAVED_SETS_74
Form[] SAVED_SETS_75
Form[] SAVED_SETS_76
Form[] SAVED_SETS_77
Form[] SAVED_SETS_78
Form[] SAVED_SETS_79
Form[] SAVED_SETS_80
Form[] SAVED_SETS_81
Form[] SAVED_SETS_82
Form[] SAVED_SETS_83
Form[] SAVED_SETS_84
Form[] SAVED_SETS_85
Form[] SAVED_SETS_86
Form[] SAVED_SETS_87
Form[] SAVED_SETS_88
Form[] SAVED_SETS_89
Form[] SAVED_SETS_90
Form[] SAVED_SETS_91
Form[] SAVED_SETS_92
Form[] SAVED_SETS_93
Form[] SAVED_SETS_94
Form[] SAVED_SETS_95
Form[] SAVED_SETS_96
Form[] SAVED_SETS_97
Form[] SAVED_SETS_98
Form[] SAVED_SETS_99

event OnInit()    
	;RegisterForModEvent("SkyVoxCommand", "OnSkyVoxCommand")
	print("init item loader")	
	Initialize()
endevent 

Event OnPlayerLoadGame()
	;RegisterForModEvent("SkyVoxCommand", "OnSkyVoxCommand")
	print("game item loader")	
	;Initialize()
endEvent



; -------------------------------------
;
; > load        spell     [id spell]         <hand-left|hand-double>
; > [load|save] [item]    [sword|shield|bow] [id slot]
; > [load|save] [set]     [id slot]
;	
event OnSkyVoxCommand(string[] args)
	if(args[0] == "load")
        processLoad(args)
	elseif(args[0] == "save")
        processSave(args)
	EndIf
endevent

Function processShout(string[] args) 
	if Game.GetPlayer().GetVoiceRecoveryTime()  == 0
		int idShout = args[1] as int
		int nthSpell = args[2] as int
		Shout shoutFound = SkyVoxCore.GetFormById(idShout) as Shout
		if Game.GetPlayer().HasSpell(shoutFound)
			Game.GetPlayer().DoCombatSpellApply(shoutFound.GetNthSpell(nthSpell), none)
			Game.GetPlayer().SetVoiceRecoveryTime(shoutFound.GetNthRecoveryTime(nthSpell))
		endif
	endif
EndFunction

Function processLoad(string[] args) 
    if(args[1] == "spell")
    	int idSpell = args[2] as int
    	Spell spellFound = SkyVoxCore.GetFormById(idSpell) as Spell
    	if spellFound && Game.GetPlayer().HasSpell(spellFound)
	    	if args.Length >= 4
	    		if args[3] == "hand-left"
	    			setLeftHand(Game.GetPlayer(), spellFound)
				elseif args[3] == "hand-double"
	    			setLeftHand(Game.GetPlayer(), spellFound)
					setRightHand(Game.GetPlayer(), spellFound)
				else
		    		setRightHand(Game.GetPlayer(), spellFound)
		    	endif
	    	else
		    	setRightHand(Game.GetPlayer(), spellFound)
		    endif
		elseif !spellFound
			print("Missing a plugin or extension for this spell.... " )
		Else
			print("You don't have the spell " + spellFound.GetName())
		endif
    elseif(args[1] == "item")
        Form item = SAVED_ITEMS[args[3] as int]
        if args[2]  == "shield" 
	        setLeftHand(Game.GetPlayer(), item)
	    Else
	    	setRightHand(Game.GetPlayer(), item)
        endif
    elseif(args[1] == "set")
        LoadItemSet(args[2] as int)
    endif
EndFunction

Function processSave(string[] args) 
    if(args[1] == "item")
		print(args[2] + " saved")
    	if(args[2] == "SHIELD" || args[2] == "torch")
    		SAVED_ITEMS[args[3] as int] = Game.GetPlayer().getEquippedObject(0)
    	else
    		SAVED_ITEMS[args[3] as int] = Game.GetPlayer().getEquippedObject(1)
    	endif
    elseif(args[1] == "set")
		print("set "+ args[2] + " saved")
		SaveCurrentItemSet(args[2] as int)
    endif
EndFunction

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


Function Initialize()
	SAVED_ITEMS = new Form[100]
	SAVED_SETS_0 = new Form[62]
	SAVED_SETS_1 = new Form[62]
	SAVED_SETS_2 = new Form[62]
	SAVED_SETS_3 = new Form[62]
	SAVED_SETS_4 = new Form[62]
	SAVED_SETS_5 = new Form[62]
	SAVED_SETS_6 = new Form[62]
	SAVED_SETS_7 = new Form[62]
	SAVED_SETS_8 = new Form[62]
	SAVED_SETS_9 = new Form[62]
	SAVED_SETS_10 = new Form[62]
	SAVED_SETS_11 = new Form[62]
	SAVED_SETS_12 = new Form[62]
	SAVED_SETS_13 = new Form[62]
	SAVED_SETS_14 = new Form[62]
	SAVED_SETS_15 = new Form[62]
	SAVED_SETS_16 = new Form[62]
	SAVED_SETS_17 = new Form[62]
	SAVED_SETS_18 = new Form[62]
	SAVED_SETS_19 = new Form[62]
	SAVED_SETS_20 = new Form[62]
	SAVED_SETS_21 = new Form[62]
	SAVED_SETS_22 = new Form[62]
	SAVED_SETS_23 = new Form[62]
	SAVED_SETS_24 = new Form[62]
	SAVED_SETS_25 = new Form[62]
	SAVED_SETS_26 = new Form[62]
	SAVED_SETS_27 = new Form[62]
	SAVED_SETS_28 = new Form[62]
	SAVED_SETS_29 = new Form[62]
	SAVED_SETS_30 = new Form[62]
	SAVED_SETS_31 = new Form[62]
	SAVED_SETS_32 = new Form[62]
	SAVED_SETS_33 = new Form[62]
	SAVED_SETS_34 = new Form[62]
	SAVED_SETS_35 = new Form[62]
	SAVED_SETS_36 = new Form[62]
	SAVED_SETS_37 = new Form[62]
	SAVED_SETS_38 = new Form[62]
	SAVED_SETS_39 = new Form[62]
	SAVED_SETS_40 = new Form[62]
	SAVED_SETS_41 = new Form[62]
	SAVED_SETS_42 = new Form[62]
	SAVED_SETS_43 = new Form[62]
	SAVED_SETS_44 = new Form[62]
	SAVED_SETS_45 = new Form[62]
	SAVED_SETS_46 = new Form[62]
	SAVED_SETS_47 = new Form[62]
	SAVED_SETS_48 = new Form[62]
	SAVED_SETS_49 = new Form[62]
	SAVED_SETS_50 = new Form[62]
	SAVED_SETS_51 = new Form[62]
	SAVED_SETS_52 = new Form[62]
	SAVED_SETS_53 = new Form[62]
	SAVED_SETS_54 = new Form[62]
	SAVED_SETS_55 = new Form[62]
	SAVED_SETS_56 = new Form[62]
	SAVED_SETS_57 = new Form[62]
	SAVED_SETS_58 = new Form[62]
	SAVED_SETS_59 = new Form[62]
	SAVED_SETS_60 = new Form[62]
	SAVED_SETS_61 = new Form[62]
	SAVED_SETS_62 = new Form[62]
	SAVED_SETS_63 = new Form[62]
	SAVED_SETS_64 = new Form[62]
	SAVED_SETS_65 = new Form[62]
	SAVED_SETS_66 = new Form[62]
	SAVED_SETS_67 = new Form[62]
	SAVED_SETS_68 = new Form[62]
	SAVED_SETS_69 = new Form[62]
	SAVED_SETS_70 = new Form[62]
	SAVED_SETS_71 = new Form[62]
	SAVED_SETS_72 = new Form[62]
	SAVED_SETS_73 = new Form[62]
	SAVED_SETS_74 = new Form[62]
	SAVED_SETS_75 = new Form[62]
	SAVED_SETS_76 = new Form[62]
	SAVED_SETS_77 = new Form[62]
	SAVED_SETS_78 = new Form[62]
	SAVED_SETS_79 = new Form[62]
	SAVED_SETS_80 = new Form[62]
	SAVED_SETS_81 = new Form[62]
	SAVED_SETS_82 = new Form[62]
	SAVED_SETS_83 = new Form[62]
	SAVED_SETS_84 = new Form[62]
	SAVED_SETS_85 = new Form[62]
	SAVED_SETS_86 = new Form[62]
	SAVED_SETS_87 = new Form[62]
	SAVED_SETS_88 = new Form[62]
	SAVED_SETS_89 = new Form[62]
	SAVED_SETS_90 = new Form[62]
	SAVED_SETS_91 = new Form[62]
	SAVED_SETS_92 = new Form[62]
	SAVED_SETS_93 = new Form[62]
	SAVED_SETS_94 = new Form[62]
	SAVED_SETS_95 = new Form[62]
	SAVED_SETS_96 = new Form[62]
	SAVED_SETS_97 = new Form[62]
	SAVED_SETS_98 = new Form[62]
	SAVED_SETS_99 = new Form[62]

EndFunction

Function SaveCurrentItemSet(int idSet)
	print("saving")
	Form[] currentSet = GetItemsSet(idSet)
	int thisSlot = 0x01
	int idPos = 0
	Form f
    while (thisSlot < 0x80000000)
	    f=Game.GetPlayer().GetWornForm(thisSlot)
    	currentSet[idPos] = f
        thisSlot *= 2 ;double the number to move on to the next slot
        idPos +=1
    endWhile
endfunction

Function LoadItemSet(int idSet)
	Form[] currentSet = GetItemsSet(idSet)
	int thisSlot = 0x01
	int idPos = 0
	Form itemEquipped
    while (thisSlot < 0x80000000)
	    itemEquipped = Game.GetPlayer().GetWornForm(thisSlot)
    	if itemEquipped
    		if !currentSet[idPos] || itemEquipped.GetFormID() != currentSet[idPos].GetFormID()
    			Game.GetPlayer().unEquipItemEx(itemEquipped)
    		endif
    	endif
    	if Game.GetPlayer().GetItemCount(currentSet[idPos]) > 0
	    	if currentSet[idPos] && (!itemEquipped || currentSet[idPos].GetFormID() != itemEquipped.GetFormID()) 
	   			Game.GetPlayer().equipItemEx(currentSet[idPos])
	   		endif
   		endif
        thisSlot *= 2 ;double the number to move on to the next slot
        idPos +=1
    endWhile
endfunction

;     Equipment registration
;================================

Form[] Function GetItemsSet(int idSet) 
	if idSet == 0
	    return SAVED_SETS_0
	elseif idSet == 1
	    return SAVED_SETS_1
	elseif idSet == 2
	    return SAVED_SETS_2
	elseif idSet == 3
	    return SAVED_SETS_3
	elseif idSet == 4
	    return SAVED_SETS_4
	elseif idSet == 5
	    return SAVED_SETS_5
	elseif idSet == 6
	    return SAVED_SETS_6
	elseif idSet == 7
	    return SAVED_SETS_7
	elseif idSet == 8
	    return SAVED_SETS_8
	elseif idSet == 9
	    return SAVED_SETS_9
	elseif idSet == 10
	    return SAVED_SETS_10
	elseif idSet == 11
	    return SAVED_SETS_11
	elseif idSet == 12
	    return SAVED_SETS_12
	elseif idSet == 13
	    return SAVED_SETS_13
	elseif idSet == 14
	    return SAVED_SETS_14
	elseif idSet == 15
	    return SAVED_SETS_15
	elseif idSet == 16
	    return SAVED_SETS_16
	elseif idSet == 17
	    return SAVED_SETS_17
	elseif idSet == 18
	    return SAVED_SETS_18
	elseif idSet == 19
	    return SAVED_SETS_19
	elseif idSet == 20
	    return SAVED_SETS_20
	elseif idSet == 21
	    return SAVED_SETS_21
	elseif idSet == 22
	    return SAVED_SETS_22
	elseif idSet == 23
	    return SAVED_SETS_23
	elseif idSet == 24
	    return SAVED_SETS_24
	elseif idSet == 25
	    return SAVED_SETS_25
	elseif idSet == 26
	    return SAVED_SETS_26
	elseif idSet == 27
	    return SAVED_SETS_27
	elseif idSet == 28
	    return SAVED_SETS_28
	elseif idSet == 29
	    return SAVED_SETS_29
	elseif idSet == 30
	    return SAVED_SETS_30
	elseif idSet == 31
	    return SAVED_SETS_31
	elseif idSet == 32
	    return SAVED_SETS_32
	elseif idSet == 33
	    return SAVED_SETS_33
	elseif idSet == 34
	    return SAVED_SETS_34
	elseif idSet == 35
	    return SAVED_SETS_35
	elseif idSet == 36
	    return SAVED_SETS_36
	elseif idSet == 37
	    return SAVED_SETS_37
	elseif idSet == 38
	    return SAVED_SETS_38
	elseif idSet == 39
	    return SAVED_SETS_39
	elseif idSet == 40
	    return SAVED_SETS_40
	elseif idSet == 41
	    return SAVED_SETS_41
	elseif idSet == 42
	    return SAVED_SETS_42
	elseif idSet == 43
	    return SAVED_SETS_43
	elseif idSet == 44
	    return SAVED_SETS_44
	elseif idSet == 45
	    return SAVED_SETS_45
	elseif idSet == 46
	    return SAVED_SETS_46
	elseif idSet == 47
	    return SAVED_SETS_47
	elseif idSet == 48
	    return SAVED_SETS_48
	elseif idSet == 49
	    return SAVED_SETS_49
	elseif idSet == 50
	    return SAVED_SETS_50
	elseif idSet == 51
	    return SAVED_SETS_51
	elseif idSet == 52
	    return SAVED_SETS_52
	elseif idSet == 53
	    return SAVED_SETS_53
	elseif idSet == 54
	    return SAVED_SETS_54
	elseif idSet == 55
	    return SAVED_SETS_55
	elseif idSet == 56
	    return SAVED_SETS_56
	elseif idSet == 57
	    return SAVED_SETS_57
	elseif idSet == 58
	    return SAVED_SETS_58
	elseif idSet == 59
	    return SAVED_SETS_59
	elseif idSet == 60
	    return SAVED_SETS_60
	elseif idSet == 61
	    return SAVED_SETS_61
	elseif idSet == 62
	    return SAVED_SETS_62
	elseif idSet == 63
	    return SAVED_SETS_63
	elseif idSet == 64
	    return SAVED_SETS_64
	elseif idSet == 65
	    return SAVED_SETS_65
	elseif idSet == 66
	    return SAVED_SETS_66
	elseif idSet == 67
	    return SAVED_SETS_67
	elseif idSet == 68
	    return SAVED_SETS_68
	elseif idSet == 69
	    return SAVED_SETS_69
	elseif idSet == 70
	    return SAVED_SETS_70
	elseif idSet == 71
	    return SAVED_SETS_71
	elseif idSet == 72
	    return SAVED_SETS_72
	elseif idSet == 73
	    return SAVED_SETS_73
	elseif idSet == 74
	    return SAVED_SETS_74
	elseif idSet == 75
	    return SAVED_SETS_75
	elseif idSet == 76
	    return SAVED_SETS_76
	elseif idSet == 77
	    return SAVED_SETS_77
	elseif idSet == 78
	    return SAVED_SETS_78
	elseif idSet == 79
	    return SAVED_SETS_79
	elseif idSet == 80
	    return SAVED_SETS_80
	elseif idSet == 81
	    return SAVED_SETS_81
	elseif idSet == 82
	    return SAVED_SETS_82
	elseif idSet == 83
	    return SAVED_SETS_83
	elseif idSet == 84
	    return SAVED_SETS_84
	elseif idSet == 85
	    return SAVED_SETS_85
	elseif idSet == 86
	    return SAVED_SETS_86
	elseif idSet == 87
	    return SAVED_SETS_87
	elseif idSet == 88
	    return SAVED_SETS_88
	elseif idSet == 89
	    return SAVED_SETS_89
	elseif idSet == 90
	    return SAVED_SETS_90
	elseif idSet == 91
	    return SAVED_SETS_91
	elseif idSet == 92
	    return SAVED_SETS_92
	elseif idSet == 93
	    return SAVED_SETS_93
	elseif idSet == 94
	    return SAVED_SETS_94
	elseif idSet == 95
	    return SAVED_SETS_95
	elseif idSet == 96
	    return SAVED_SETS_96
	elseif idSet == 97
	    return SAVED_SETS_97
	elseif idSet == 98
	    return SAVED_SETS_98
	else
	    return SAVED_SETS_99
	endif
endfunction

;====================================
;     Debugging and notification
function dbg(string m) Global
	if !Debug.traceUser("SkyVox", m)
		Debug.openUserLog("SkyVox")
		if !Debug.traceUser("SkyVox", m)
			Debug.trace("SkyVox: " + m)
		endif
	endif
endfunction

function print(string m) Global
	Debug.notification(m)
	dbg(m)
endfunction
;     Debugging and notification
;====================================



; If(StringUtil.Find(command, "moveto") == 0)
;			If(StringUtil.Find(command, "maison") > 0);
;				Game.GetPlayer().MoveTo(_HomeHijerim);
;			elseIf(StringUtil.Find(command, "maison blancherive") > 0)
;				Game.GetPlayer().MoveTo(_HomeHijerim)
	;		elseIf(StringUtil.Find(command, "blanche rive") > 0)
;				Game.GetPlayer().MoveTo(_WhiteRun)
;			EndIf
;		
;		elseIf(StringUtil.Find(command, "shout") == 0)
 ;       ;Game.GetPlayer().DoCombatSpellApply(_SHOUT_LOKVAHKOOR, Game.GetPlayer())

  ;  else