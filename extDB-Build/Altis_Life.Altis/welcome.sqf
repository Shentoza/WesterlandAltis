/*
	File: welcomecredits.sqf
	Author: westerland-altislife.de
	Edit: by Lasdios
	Date: 14/12/2013
	Description:
	Creates an intro on the bottom-right hand corner of the screen.
*/

_onScreenTime = 8;

sleep 7; //Wait in seconds before the credits start after player is in-game
 
_role1 = "Willkommen auf dem Altis Life Server von:";
_role1names = ["westerland-altis.de"];
_role2 = "Eure Projektleitung";
_role2names = ["Felix/Slappy","Shentoza"];
_role3 = "Eure Admins";
_role3names = ["graVediga","K3V1N"];
_role4 = "Eure Supporter";
_role4names = ["BlackBlood","Fathach","Enrico","Dexton","Malu","AuRoRa"];
_role5 = "Eure Mapper";
_role5names = ["Cheng | DONAR"];
_role6 = "Eure Scripter";
_role6names = ["Shentoza","Cheng | DONAR"];
_role7 = "Website:";
_role7names = ["www.westerland-altis.de"];
_role8 = "Teamspeak:";
_role8names = ["ts.westerland-altis.de:9987"];
_role9 = "";
_role9names = [""];
{
sleep 2;
_memberFunction = _x select 0;
_memberNames = _x select 1;
_finalText = format ["<t size='0.90' color='#a6f20b' align='right'>%1<br /></t>", _memberFunction];
_finalText = _finalText + "<t size='0.75' color='#FFFFFF' align='right'>";
{_finalText = _finalText + format ["%1<br />", _x]} forEach _memberNames;
_finalText = _finalText + "</t>";
_onScreenTime + (((count _memberNames) - 1) * 0.9);
[
_finalText,
[safezoneX + safezoneW - 0.8,0.50], //DEFAULT: 0.5,0.35
[safezoneY + safezoneH - 0.8,0.7], //DEFAULT: 0.8,0.7
_onScreenTime,
0.5
] spawn BIS_fnc_dynamicText;
sleep (_onScreenTime);
} forEach [
//The list below should have exactly the same amount of roles as the list above
[_role1, _role1names],
[_role2, _role2names],
[_role3, _role3names],
[_role4, _role4names],
[_role5, _role5names],
[_role6, _role6names],
[_role7, _role7names],
[_role8, _role8names]
];
