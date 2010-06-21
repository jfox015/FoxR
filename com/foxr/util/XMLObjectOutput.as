package com.foxr.util {
	
	import com.adobe.utils.XMLUtil;
	import com.foxr.util.Utils;
	/** 
	 * This class is used to covert XML objects into simple object types. This is
	 * useful for easy access to node values and attributes of the XML object by using
	 * the node names instead of firstChild, nextNode etc. From AS2 and children()[x] 
	 * notation in AS3 E4X. 
	 * <p />
	 * This class also features function to trace arrays and objects in a clear 
	 * presentation of the structure.
	 * <p />
	 * This class was originally written or ActionScript 2.0/Flex and converted 
	 * to support ActionScript 3.0. This file now has a dependancy on the Adobe 
	 * XMLUtil class for XML validation support.
	 *
	 * @author		Jeff Fox
	 * @version 	2.1
	 * @see  		com.adobe.utils.XMLUtil	
	 */
	public class XMLObjectOutput {
		
		/*------------------------------
		/	VARIABLES
		/-----------------------------*/
		private var nameProp:Boolean = false;
		/*------------------------------
		/	C'TOR
		/------------------------------*/
		/**
		 * Creates a new instance of XMLObjectOutput.
		 * <p />
		 * Some MXML types require the string value of the node to display information 
		 * (example: Tree).  If this is needed you can set the first argument to true 
		 * to append a property called .nodeName to the created object that will 
		 * contain the string nodeName. The default value is false.
		 * 
		 * @param objNameProp Optional: This parameter will add a nodeName property to the create object
		 */
		public function XMLObjectOutput(o:Boolean = false) {
			// Enable .nodeName to object conversion if true
			if(o) nameProp = true; // END if
		}
		/*------------------------------
		/	PUBLIC FUNCTIONS
		/-----------------------------*/
		/**
		 * This method walks the entire XML tree and converts the node names to properties. 
		 * XMLToObject method only accepts an XML or XMLNode Object.  
		 * <p />
		 * If the XML node contains an attribute, then the method will create a child
		 * property of the node name called attributes.  Attributes will hold any
		 * attribute and its value.
		 * <p />
		 * If the XML node has a text node, then the method will create a child property
		 * called value and will store the text node value in this property.
		 * <p />
		 * The generated object has a property called __error hung off the root. If the 
		 * value is true this means an error occured and a __errorMsg property exists
		 * explaining the cause of the error.
		 * <p />
		 * 
		 * @param xmlObj This parameter is the XML Object or XMLNode to be converted.
		 * @return This method will return type Object.
		 * @since	1.0
		 */
		public function XMLToObject(xmlObj:XML):Object {
			
			var outputObj:Object = new Object();
			// verify that we have an XML object and that it is valid
			if (xmlObj is XML || XMLUtil.isValidXML(xmlObj.toString())) {
				// no error
				outputObj.__error = false;
				// get the first child of the XML tag (note: the first child in an XML object is the <xml> tag		
				// check to see if we have a XML Object or Node.  If a Node do not get the first child.
				var currNode:XMLList = XMLList(xmlObj);
					
				// call our recursive parser
				if (currNode != null) buildObj(currNode, outputObj);
				else {
					// wrong type passed, set error cancel method
					outputObj.__error = true;
					outputObj.__errorMsg = "The root node returned null.";
					return outputObj;
				}
			} else {
				// wrong type passed, set error cancel method
				outputObj.__error = true;
				outputObj.__errorMsg = "Object was not XML or not valid XML.";
				return outputObj;
			}		
			// return the now create Object
			return outputObj;
		}
		
		/** 
		 * TraceObject walks Objects and displays their content inside the output window
		 * using trace() statements.
		 * <p />
		 * NOTE: Objects are displayed from the bottom up and Arrays are displayed top down.
		 * <p />
		 * 
		 * @param objToTrace 	Accepts any type of Object.
		 * @param objName 		(Optional) Accepts a String identifier to be displayed in the output.
		 * 
		 */
		public function traceObject(objToTrace:Object, objName:String = ''):void {
			// check to see if objName exist, use default text if not passed
			objName = String((objName == '')? "Object: " : (objName + " "));
			trace(objName);
			
			// call recursive output method, set spacer formating
			trObj(objToTrace, " |-- ");		
		}
		/*------------------------------
		/	PRIVATE FUNCTIONS
		/-----------------------------*/
		/**
		 * This function uses recursion to walk through the XML document.  This allows 
		 * us to reuse the code and lets the function determine when everything has 
		 * been parsed correctly.
		 * 
		 * @param 		currNode	XML List object of node to be parsed
		 * @param 		currObj		The parent object this node will be appended to
		 * @return 		Simple Object of XML node structure
		 * 
		 */
		private function buildObj(currNode:XMLList, currObj:Object):Object {
			// verify that this is not a text node (value would be 3 if it is)
			if (currNode.nodeKind() == 'element') {
				// this is an element node
				// grab the child node and create a new Object
				//var childNum:Number = currNode.children().length();
				var newNode:XMLList = currNode.children();	
				// check if current node name exists?
				var cObj:Object = currObj[currNode.localName()];
				var newObj:Object = null;
				
				if (cObj == null) {
					// we do not have a duplicate node name
					currObj[currNode.localName()] = new Object();
					newObj = currObj[currNode.localName()];
				} else {
					// node name exist, we need to convert to an array if not aleady
					if(cObj is Array) {
						// array already exist, add new object
						cObj.push(new Object());
						newObj = currObj[currNode.localName()][(cObj.length-1)];
					} else {
						// array does not exist, save current value and create a new Array
						currObj[currNode.localName()] = new Array(cObj);
						currObj[currNode.localName()].push(new Object());
						newObj = currObj[currNode.localName()][(currObj[currNode.localName()].length-1)];
					}
				}
				
				// check for attributes
				var attNamesList:XMLList = currNode.@*;
				if (attNamesList is XMLList && attNamesList.length() > 0) {
					if(newObj.attributes == null)
						newObj.attributes = new Object(); // END if
					for (var c:int = 0; c < attNamesList.length(); c++)
					    newObj.attributes[attNamesList[c].name().toString()] = attNamesList[c].toString(); // END for
				} // END if
				
				// check for name property
				if (nameProp)
					newObj.localName = currNode.localName();
				
				// walk the children and then look into them
				//trace("checking children for tag " + currNode.localName());
				for (var i:Number = 0; i < newNode.length(); i++) {
					//trace("Testing child " + i);
					if(newNode[i].nodeKind() == 'element') {
						newObj[newNode[i].localName()] = buildObj(XMLList(newNode[i]), newObj);					
						//newNode = XMLList(newNode[i+1]);
					} else {
						newObj.value = newNode[i].toString();
					} // END if
				} // END for
				// return the created complex object for nested children
				return currObj[currNode.localName()];
			}
			return null;
		}
		/**
		 * Recusive method used to output and format the object
		 * <p />
		 * @param 		obj			Object to be traced
		 * @param 		spacer		Custom spacer string
		 * 
		 */
		private static function trObj(obj:Object, spacer:String):void {
			// format differently for Array structures
			var nSpace:String = "      " + spacer;
			if(obj is Array) {
				// walk the array
				for(var i:Number=0; i < obj.length; i++) {
					switch(true) {
						case(obj[i] is Object):
							trace(spacer + "[" + i + "]" + " [object]");
							trObj(obj[i], nSpace);
							break;
						default:
							trace(spacer + "[" + i + "]"+ ": " + obj[i]);
					} // END switch
				} // END for
			} else {
				// use for in for object
				for(var j:String in obj) {
					// see if it is an object?
					switch(true) {
						case (obj[j] is Array):
							// call recursion
							trace(spacer + j + " [array]");
							trObj(obj[j], nSpace);
							break;
							
						case (obj[j] is Object):
							// call recursion
	
							trace(spacer + j + " [object]");
							trObj(obj[j], nSpace);
							break;
						default:
							trace(spacer + j + ": " + obj[j]);
					} // END switch
				} // END for
			} // END if
		} // END function
		/**
		 * Recusive method used to output and format the object as XML
		 * <p />
		 * @param 		obj			Object to be converted
		 * @param 		spacer		Custom spacer string
		 * @return					XML String
		 * 
		 */
		public static function objectToXML(obj:Object,spacer:String = "    "):String {
			// format differently for Array structures
			var nSpace:String = "      " + spacer;
			var x:String = '';
			// format differently for Array structures
			if(obj is Array) {
				// walk the array
				for(var i:Number=0; i < obj.length; i++) {
					x += spacer + "<" + i + ">";
					if ((obj[i] is Object || obj[j] is Array) && obj[j].toString() == '[object Object]') {
						x += XMLObjectOutput.objectToXML(obj[i], nSpace);
					} else {
						x += obj[i];
					}
					x += "</" + i + ">";
				} // END for
			} else {
				// use for in for object
				for (var j:String in obj) {
					// see if it is an object?
					x += spacer + "<" + j + ">";
					if ((obj[j] is Object || obj[j] is Array) && obj[j].toString() == '[object Object]') {
						x += XMLObjectOutput.objectToXML(obj[j], nSpace);
					} else {
						x += obj[j];
					}
					x += "</" + j + ">";
				} // END for
			} // END if
			return x;
		} // END function
		
	} // END class
} // END package

