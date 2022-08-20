
function sTimingPoint(_time, _beatlength, _beats) constructor {
    time = _time;
    beatLength = _beatlength;
    meter = _beats;             // x/4
}

enum OPERATION_TYPE {
    MOVE,
    ADD,
    REMOVE,
    TPADD,
    TPREMOVE,
    OFFSET
}

function sOperation(_type, _from, _to) constructor {
    opType = _type;
    fromProp = _from;
    toProp = _to;
}