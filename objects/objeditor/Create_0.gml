/// @description 
// visible = false;

depth = -500000000;

// Editors
editorMode = 5;                             // 1 note 2 chain 3 hold 4 view 5 play 0 copy
editorModeBeforeCopy = 5;
editorSide = 0;                             // 0 down 1 left 2 right
editorLastSide = 0;
editorNoteAttaching = -1;                   // instances that attached to cursor now
editorNoteAttachingCenter = 0;           // attached instances' center

// Width for different modes
editorDefaultWidth = [
	1.0,
	1.0,
	[1.0, 1.0],
	[1.0, 1.0, 1.0]
	];
editorDefaultWidthModeName = [
	"default_width_mode_name_1",
	"default_width_mode_name_2",
	"default_width_mode_name_3",
	"default_width_mode_name_4"
	];
editorDefaultWidthMode = 0;

editorSelectSingleTarget = -999;            // instance for single selection target
editorSelectSingleTargetInbound = -999;
editorSelectOccupied = false;               // selecting note
editorSelectCount = 0;  
editorSelectMultiple = false;               // selecting multiple notes
editorSelectDragOccupied = false;           // dragging notes 
editorSelectArea = false;                   // selecting area
editorSelectAreaPosition = undefined;
editorSelectInbound = false;                // if at least mouse is inbound one selected note
editorSelectResetRequest = false;
editorNoteSortRequest = false;

editorHighlightLine = false;
editorHighlightLineEnabled = true;
editorHighlightTime = 0;
editorHighlightPosition = 0;
editorHighlightSide = 0;

editorWidthAdjustTime = 9999;
editorWidthAdjustTimeThreshold = 300;

    // Grid Settings
    editorGridXEnabled = true;
    editorGridYEnabled = true;
    editorGridWidthEnabled = true;

// Timings
timingPoints = [];

// Highlight lines
highlightLineColorDownA = scribble_rgb_to_bgr(0xb6ffff);
highlightLineColorDownB = scribble_rgb_to_bgr(0x81d4fa);
highlightLineColorSideA = scribble_rgb_to_bgr(0xffc1e3);
highlightLineColorSideB = scribble_rgb_to_bgr(0xce93d8);

// Beatlines
enum BeatlineStyles {
	BS_DEFAULT,
	BS_MONOLONG,
	BS_MONO,
	BS_LONG,
};

#macro BEATLINE_STYLES_COUNT 4

beatlineStylesName = [];
beatlineStylesName[BeatlineStyles.BS_DEFAULT] = "beatline_style_default";
beatlineStylesName[BeatlineStyles.BS_MONOLONG] = "beatline_style_monolong";
beatlineStylesName[BeatlineStyles.BS_MONO] = "beatline_style_mono";
beatlineStylesName[BeatlineStyles.BS_LONG] = "beatline_style_long";

beatlineStyleCurrent = global.beatlineStyle;

beatlineSurf = -1;
beatlineColors = [0, 0xffffff, 0x3643f4, 0xb0279c, 0xf39621,
    0x6abb66, 0x889600, 0x757575, 0x3bebff,
    0, 0x33cac0, 0, 0x37405d,
    0, 0x414c6d, 0, 0x921b31,
    0, 0, 0, 0x00b3ff,
    0, 0, 0, 0,
    0, 0, 0, 0x7a6e54]; // 1/1, 1/2, 1/3 ...
beatlineLengthOffset = [
    0,
    0,
    -30,    // 2
    -30,    // 3
    -60,    // 4
    -30,    // 5
    -60,    // 6
    -30,
    -90,
    0,
    -60,
    0,
    -120,
    0,
    -60,
    0,
    -120,   // 16
    0, 0, 0, -120, // 20
    0, 0, 0, 0, 0, 0, 0, -120];
beatlineModes = [
    [
        [1],
        [1, 2],
        [1, 3],
        [1, 2, 4],
        [1, 3, 6],
        [1, 2, 4, 8],
        [1, 2, 4, 8, 16],
        [1, 3, 6, 12], 
        [1, 2, 4, 8, 16],
        [1, 2, 4, 8, 16],
        [1, 2, 4, 8, 16]
    ],
    [
        [1],
        [1, 5],
        [1, 7],
        [1, 5, 10],
        [1, 7, 14],
        [1, 5, 10, 20],
        [1, 7, 14, 28]
    ]
];
beatlineDivs = [[1, 2, 3, 4, 6, 8, 16, 12, 32, 64, 128], [1, 5, 7, 10, 14, 20, 28]];
beatlineNowGroup = 0;
beatlineNowMode = 3;
beatlineEnabled = array_create(28, 0);

beatlineHardWidth = 6;
beatlineWidth = 3;
beatlineHardLength = global.resolutionW * 0.9;
beatlineLength = global.resolutionW * 0.75;
beatlineLengthLong = global.resolutionW - objMain.targetLineBeside * 2;
beatlineHardHeight = (global.resolutionH - objMain.targetLineBeside) * 0.95;
beatlineHeight = (global.resolutionH - objMain.targetLineBeside) * 0.90;
beatlineAlpha = [0, 0, 0];
beatlineAlphaMul = 0;
beatlineSideInfoX = resor_to_x(0.5)+beatlineHardLength/2;
beatlineSideInfoDivWidth = 100;

animSpeed = 0.4;
animBeatlineTargetAlpha = [0, 0, 0];
animBeatlineTargetAlphaM = 0;

// Copy & Paste

copyStack = [];

// Undo & Redo

operationStack = [];
operationStackStep = [];
operationPointer = -1;
operationCount = 0;
operationSyncTime = [INF, -INF];		// The earliest operated instance's time on last step