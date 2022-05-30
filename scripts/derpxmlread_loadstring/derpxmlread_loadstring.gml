/// @description  DerpXmlRead_LoadFromString(xmlString)
/// @param xmlString
function DerpXmlRead_LoadString(argument0) {
	//
	//  Loads XML contained in a string. e.g. "<a>derp</a>"

	var xmlString = argument0

	with objDerpXmlRead {
	    self.xmlString = xmlString
	    readMode = readMode_String
    
	    stringPos = 0
	    currentType = DerpXmlType_StartOfFile
	    currentValue = ""
	    currentRawValue = ""
	    lastReadEmptyElement = false
	}



}
