﻿/*
	File: fn_welcomeNotification.sqf
	
	Description:
	Called upon first spawn selection and welcomes our player.
*/

_l1 = parseText "Du bist auf dem Server von Westerland.<br />    Unsere Ts3-IP: ts.westerland-altis.de";
_l2 = parseText "!!!Marktplatz Kavala ist eine Safezone!!!<br />Troller werden direkt gebannt!";
_l3 = parseText "Falls weitere Fragen bestehen, kannst du gerne einen<br />    Admin kontaktieren!<br />";
_l4 = parseText "Wir wünschen euch viel Spaß auf dem Server. <br />Euer Westerland Team<br />";



format[" Willkommen %1",name player] hintC [_l1,_l2,_l3,_l4];


hintC_arr_EH = findDisplay 72 displayAddEventHandler ["unload", {
	0 = _this spawn {
		_this select 0 displayRemoveEventHandler ["unload", hintC_arr_EH];
		hintSilent "";
	};
}];

	