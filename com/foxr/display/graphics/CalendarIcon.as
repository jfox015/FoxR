package com.foxr.display.graphics {
	
	import com.foxr.display.graphics.Graphic;
	
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	* 
	* Dynamically draws a vector calendar icon used by the DateSelector object.
	* 
	* @author Jeff Fox
	* @version 0.1
	* @see	com.foxr.display.components.DateSelector DateSelector
	 *
	 * Copyright (c) 2009 Jeff Fox. Licensed under the MIT License.
	*/
	public class CalendarIcon extends Graphic {
			
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Constructs a new CalendarIcon instance.
		 *
		 */
		public function CalendarIcon() {}
		/*--------------------------------------
		/	PUBLIC FUNCTIONS
		/-------------------------------------*/
		/**
		 * Overrides the default objReady method and calls the <i>draw()</i> method.
		 * @since	1.0
		 */
		public override function objReady(e:Event):void{
			super.objReady(e);
			super.height = 13;
			super.width = 16;
			draw();
		}
		/**
		 * Overrides default draw method and draws the calendar icon.
		 * @since	1.0
		 */
		public override function draw():void {
			while (numChildren > 0) {
				removeChildAt(0);
			} // END while
			var comps:Object = {
				item1: { color: 0x333399,x:0,y:0,w:16,h:13 },
				item2: { color: 0xCCCCCC,x:1,y:3,w:14,h:11 },
				item3: { color: 0x999999,x:0,y:3,w:1,h:11 },
				item4: { color: 0x999999,x:15,y:3,w:1,h:11 },
				item5: { color: 0x999999,x:1,y:14,w:14,h:1 },
				item6: { color: 0x333333,x:2,y:15,w:14,h:1 },
				item7: { color: 0x333333,x:16,y:4,w:1,h:11 },
				item8: { color: 0x333333,x:14,y:4,w:1,h:1 }
			};
			for (var item:String in comps) {
				var grphc:Sprite = new Sprite();
				grphc.graphics.beginFill(comps[item].color);
				grphc.graphics.drawRect(comps[item].x,comps[item].y,comps[item].w,comps[item].h);
				grphc.graphics.endFill();
				addChild(grphc);
			} // END for
			
			for (var i:Number=0; i<5; i++) {
				for (var j:Number=0; j<4; j++) {
					var grphc2:Sprite = new Sprite();
					grphc2.graphics.beginFill(0xffffff);
					grphc2.graphics.drawRect(((i*3)+1),((j*3)+3),2,2);
					grphc2.graphics.endFill();
					addChild(grphc2);
				} // END for
			} // END for 
		}
	} // END class
} // END package