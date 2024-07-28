
// Input Update
if(global.__InputManager != undefined)
	global.__InputManager.step();

// GUI Update
if(global.__GUIManager != undefined) {
	global.__GUIManager.step();
}

// DyCore Update
if(global.__DyCore_Manager != undefined) {
	global.__DyCore_Manager.step();
}