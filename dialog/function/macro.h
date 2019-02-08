//Define for limiting the speed at which you can repeatedly call a script.
#define fileName (__FILE__ select [28, count __FILE__ - 33])
#define scriptAvailable(cooldownTime) (cooldownTime call {_zindex = life_scriptCooldowns find fileName; _zret = false;if(_zindex != -1) then {if((life_scriptCooldowns select (_zindex + 1)) > (time - _this)) then {_zret = true;}else{life_scriptCooldowns set [(_zindex + 1),time];}}else{life_scriptCooldowns pushBack fileName;life_scriptCooldowns pushBack time;};_zret})

//Control (aka dialog) Macros
#define getControl(disp,ctrl) ((findDisplay ##disp) displayCtrl ##ctrl)
#define getSelData(ctrl) (lbData[##ctrl,(lbCurSel ##ctrl)])