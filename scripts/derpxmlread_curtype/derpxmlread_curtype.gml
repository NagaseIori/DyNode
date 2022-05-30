/// @description  DerpXmlRead_CurType()
function DerpXmlRead_CurType() {
	//
	//  Returns the type of the current node, as a DerpXmlType macro.
	//
	//  DerpXmlType_OpenTag     - Opening tag <tag>
	//  DerpXmlType_CloseTag    - Closing tag </tag>
	//  DerpXmlType_Text        - Text inside an element <a>TEXT</a>
	//  DerpXmlType_Whitespace  - Whitespace between elements "    "
	//  DerpXmlType_StartOfFile - Start of document, no reads performed yet
	//  DerpXmlType_EndOfFile   - End of document

	return objDerpXmlRead.currentType



}
