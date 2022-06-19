/// @description  DerpXmlWrite_New()
function DerpXmlWrite_New() {
	//
	//  Starts a new empty xml string.

	with objDerpXmlWrite {
	    writeString = ""
	    currentIndent = 0
	    lastWriteType = DerpXmlType_StartOfFile
	    lastWriteEmptyElement = false
	}



}
