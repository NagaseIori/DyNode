/// @description  DerpXMlWrite_LeafElement(tagName, text)
/// @param tagName
/// @param  text
function DerpXmlWrite_LeafElement(argument0, argument1) {
	//
	//  Writes an element with no children, e.g. <tagName>text</tagName>
	//  If you supply '' as text, the empty element syntax will be used, e.g. <tagName/>

	var tagName = argument0
	var text = argument1

	if text != "" {
	    DerpXmlWrite_OpenTag(tagName)
	    DerpXmlWrite_Text(text)
	    DerpXmlWrite_CloseTag()
	}
	else {
	    with objDerpXmlWrite {
	        if lastWriteType == DerpXmlType_OpenTag {
	            currentIndent += 1
	        }
        
	        writeString += newlineString
	        repeat currentIndent {
	            writeString += indentString
	        }
        
	        writeString += "<"+tagName+"/>"
	        lastWriteType = DerpXmlType_CloseTag
	        lastWriteEmptyElement = true
	    }
	}



}
