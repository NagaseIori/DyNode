/// @description 
// visible = false;

depth = -500000000;

// Editors

editorMode = 5;                             // 1 note 2 chain 3 hold 4 view 5 play
editorSide = 0;                             // 0 down 1 left 2 right
editorNoteAttaching = -999;                 // instance that attached to cursor now
editorDefaultWidth = 1.0;
editorSelectSingleTarget = -999;            // instance for single selection target
editorSelectSingleTargetInbound = -999;
editorSelectOccupied = false;               // selecting note
editorSelectCount = 0;  
editorSelectMultiple = false;               // selecting multiple notes
editorSelectDragOccupied = false;           // dragging notes 
editorSelectArea = false;                   // selecting area
editorSelectAreaPosition = [0, 0, 0, 0];
editorSelectInbound = false;                // if at least mouse is inbound one selected note
editorSelectResetRequest = false;

editorHighlightLine = false;
editorHighlightLineEnabled = true;
editorHighlightTime = 0;
editorHighlightPosition = 0;
editorHighlightSide = 0;

    // Grid Settings
    editorGridXEnabled = true;
    editorGridYEnabled = true;
    editorGridWidthEnabled = true;

// Timings
timingPoints = [];

// Beatlines
beatlineSurf = -1;
beatlineColors = [0, 0xffffff, 0x3643f4, 0xb0279c, 0xf39621,
    0, 0x889600, 0, 0x3bebff,
    0, 0, 0, 0x37405d,
    0, 0, 0, 0x921b31]; // 1/1, 1/2, 1/3 ...
beatlineLengthOffset = [
    0,
    0,
    -30,
    -30,
    -60,
    0,
    -60,
    0,
    -90,
    0,
    0,
    0,
    -120,
    0,
    0,
    0,
    -120];
beatlineModes = [
    [1],
    [1, 2],
    [1, 3],
    [1, 2, 4],
    [1, 3, 6],
    [1, 2, 4, 8],
    [1, 2, 4, 8, 16],
    [1, 3, 6, 12], 
    [1, 2, 4, 8, 16]
    ];
beatlineDivs = [1, 2, 3, 4, 6, 8, 16, 12, 32];
beatlineNowMode = 3;
beatlineEnabled = array_create(20, 0);

beatlineHardWidth = 8;
beatlineWidth = 3;
beatlineHardLength = global.resolutionW * 0.9;
beatlineLength = global.resolutionW * 0.75;
beatlineHardHeight = (global.resolutionH - objMain.targetLineBeside) * 0.95;
beatlineHeight = (global.resolutionH - objMain.targetLineBeside) * 0.90;
beatlineAlpha = [0, 0, 0];

animSpeed = 0.4;
animBeatlineTargetAlpha = [0, 0, 0];