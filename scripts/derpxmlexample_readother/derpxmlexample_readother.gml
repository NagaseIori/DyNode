function DerpXmlExample_ReadOther() {
	// Use the raw value script, and handle when attributes don't exist.

	/* Outputs:
	<a cat="bag" />
	attribute is undefined
	*/

	DerpXml_Init() // call this just once at the start of your game
	DerpXmlRead_LoadString("<a cat=\"bag\" />")

	DerpXmlRead_Read()
	show_debug_message(DerpXmlRead_CurRawValue())
	var undefinedVal = DerpXmlRead_CurGetAttribute("catttttt")
	if is_undefined(undefinedVal) {
	    show_debug_message("attribute is undefined")
	}

	DerpXmlRead_UnloadString()





	// Demonstrate all the read types.

	/* Outputs:
	StartOfFile, 
	OpenTag, a
	Whitespace,    
	OpenTag, b
	Text, derp
	CloseTag, b
	Whitespace,    
	OpenTag, c
	CloseTag, c
	Whitespace,    
	Comment, d
	Whitespace,  
	CloseTag, a
	EndOfFile, 
	*/

	DerpXml_Init() // call this just once at the start of your game
	DerpXmlRead_LoadString(
	@"<a>
	  <b>derp</b>
	  <c/>
	  <!--d-->
	</a>"
	)
	show_debug_message(DerpXmlRead_CurType()+", "+DerpXmlRead_CurValue())
	while DerpXmlRead_Read() {
	    show_debug_message(DerpXmlRead_CurType()+", "+DerpXmlRead_CurValue())
	}
	show_debug_message(DerpXmlRead_CurType()+", "+DerpXmlRead_CurValue())
	DerpXmlRead_UnloadString()



}
