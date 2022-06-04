/// @description 
// visible = false;

// Timings
timingPoints = [];

// Beatlines
beatlineSurf = -1;
beatlineColors = [0, 0xffffff, 0x3643f4, 0xb0279c, 0xf39621,
    0, 0x889600, 0, 0x3bebff,
    0, 0, 0, 0,
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
    0,
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
    [1, 2, 4, 8, 16]
    ];
beatlineNowMode = 2;
beatlineEnabled = array_create(20, 0);

beatlineHardWidth = 8;
beatlineWidth = 3;
beatlineHardLength = global.resolutionW * 0.9;
beatlineLength = global.resolutionW * 0.75;
beatlineAlpha = [0, 0, 0];

animSpeed = 0.4;
animBeatlineTargetAlpha = [0, 0, 0];