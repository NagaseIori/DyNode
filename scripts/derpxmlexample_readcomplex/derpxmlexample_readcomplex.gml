function DerpXmlExample_ReadComplex() {
	// Read an XML file. (more complex)

	var xmlString = @"
	<root>
	  <pets>
	    <cat id="+"\""+@"1"+"\""+@">=^.^=</cat>
	    <fish id="+"\""+@"2"+"\""+@">}{}</fish>
	    <cat id="+"\""+@"3"+"\""+@">~(=^.w.^)</cat>
	    <cat id="+"\""+@"4"+"\""+@">hi im a cat</cat>
	    <fish id="+"\""+@"5"+"\""+@">{}{</fish>
	  </pets>
	</root>
	"

	/* output: 

	cat! #1
	cat looks like: =^.^=
	created cat
	fish! #2
	fish looks like: }{}
	created fish
	cat! #3
	cat looks like: ~(=^.w.^)
	created cat
	cat! #4
	cat looks like: hi im a cat
	created cat
	fish! #5
	fish looks like: {}{
	created fish

	*/



	DerpXml_Init() // call this just once at the start of your game
	DerpXmlRead_LoadString(xmlString)
	var inCat = false
	var inFish = false
	var petText = ""

	while DerpXmlRead_Read() {

	    switch DerpXmlRead_CurType() {
    
	    case DerpXmlType_OpenTag:
	        switch DerpXmlRead_CurValue() {
	        case "cat":
	            show_debug_message("cat! #"+DerpXmlRead_CurGetAttribute("id"))
	            inCat = true
	            break
	        case "fish":
	            show_debug_message("fish! #"+DerpXmlRead_CurGetAttribute("id"))
	            inFish = true
	            break
	        }
	        break
    
	    case DerpXmlType_Text:
	        if inCat {
	            petText = DerpXmlRead_CurValue()
	            show_debug_message("cat looks like: "+petText)
	        }
	        if inFish {
	            petText = DerpXmlRead_CurValue()
	            show_debug_message("fish looks like: "+petText)
	        }
	        break
    
	    case DerpXmlType_CloseTag:
	        if inCat {
	            /*with instance_create(100, 100, objCat) {
	                text = petText
	            }*/
	            show_debug_message("created cat")
	            inCat = false
	        }
	        if inFish {
	            /*with instance_create(100, 100, objFish) {
	                text = petText
	            }*/
	            show_debug_message("created fish")
	            inFish = false
	        }
	        break
        
	    }
	}
	DerpXmlRead_UnloadString()



}
