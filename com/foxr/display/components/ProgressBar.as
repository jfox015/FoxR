package com.foxr.display.components 
{
	//import external classes
	import com.foxr.display.components.Component;
	import com.foxr.display.Element;
	import com.foxr.display.graphics.Box;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	/**
	 * Visually shows the progress of an action.
	 * 
	 * @author		Jeff Fox
	 *
	 * Copyright (c) 2009 Jeff Fox. Licensed under the MIT License.
	 * 
	 */
	public class ProgressBar extends Component {
		
		/*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/
		public static const DIRECTION_LEFT:String = 'left';
		public static const DIRECTION_RIGHT:String = 'right';
		
		public static const LABEL_ALIGN_LEFT:String = 'left';
		public static const LABEL_ALIGN_RIGHT:String = 'right';
		public static const LABEL_ALIGN_TOP:String = 'top';
		public static const LABEL_ALIGN_BOTTOm:String = 'bottom';
		
		protected var progressElem:Element = null;
		protected var barSolid:Box = null;
		protected var barHighlight:Box = null;
		protected var barShadow:Box = null;

		protected var _direction:String = null;
		protected var _labelAlign:String = LABEL_ALIGN_RIGHT;
		protected var _percentComplete:Number = 0;
		protected var _source:Object = null;
		protected var _max:Number = 100;
		protected var _min:Number = 0;
		
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Construct a new ProgressBar instance.
		 *
		 */
		public function ProgressBar() { 
			progressElem = addElement('progressElem', Element);
			barSolid = Box(progressElem.addElement('barSolid', Box ));
			barShadow = Box(progressElem.addElement('barShadow', Box, {visible: false}  ));
			barHighlight = Box(progressElem.addElement('barHighlight', Box, {visible: false} ));
			setChildIndex(txt,this.numChildren - 1);
		}
		/*--------------------------------------
		/	SET/GET FUNCTIONS
		/-------------------------------------*/
		/**
		 *	Sets the alpha of the main progress bar.
		 *  @since 1.2
		 *  @param		a	Alpha in 1.0 format
		 *  @return			Alpha in 1.0 format
		 */
		public override function get alpha():Number{ return barSolid.alpha; }
		public override function set alpha(a:Number):void { barSolid.alpha = a; }
		/**
		 *	Sets the color of the main progress bar.
		 *  @since 1.2
		 *  @param		c	Color in 0x000000 format
		 *  @return			Color in 0x000000 format
		 */
		public function get color():Number{ return barSolid.color; }
		public function set color(c:Number):void { barSolid.color = c; }
		/**
		 *	Sets the gradient style of the progress bar.
		 *  <br>
		 *  NOTE: This method will override the alpha or color properties if the have been applied.
		 *  @since 1.2
		 *  @param		g	Gradient Style object
		 *  @return			Gradient Style object
		 *  @see 			com.foxr.display.graphics.Graphic#gradientStyle
		 */
		public function set gradient(g:Object):void { 
			barSolid.gradientStyle = g; 
		}
		/**
		 *	Sets the direction property opf the object.
		 *  @since 1.2
		 *  @param		d	Progress Bars direction. Accepts right (default) and left
		 *  @return			The Progress Bars direction value.
		 */
		public function get direction():String{ return _direction; }
		public function set direction(d:String):void { _direction = d; }
		/**
		 * Changes the height of the object and child elements. 
		 * @since	1.0
		 * @param	b	The height in pixels
		 * @return		The height in pixels
		 */
		public override function set height(h:Number):void {
			super.height = h;
			barShadow.height = barHighlight.height = barSolid.height = progressElem.height = h - (borderWidth * 2);
			progressElem.y = borderWidth;
			update();
		}
		/**
		 *	Sets the alpha of the progress bars highlight.
		 *  @since 1.2
		 *  @param		a	Alpha in 1.0 format
		 *  @return			Alpha in 1.0 format
		 */
		public function get highlightAlpha():Number{ return barHighlight.alpha; }
		public function set highlightAlpha(a:Number):void { barHighlight.alpha = a; }
		/**
		 *	Sets the color of the progress bars highlight.
		 *  @since 1.2
		 *  @param		c	Color in 0x000000 format
		 *  @return			Color in 0x000000 format
		 */
		public override function get highlightColor():Number{ return barHighlight.color; }
		public override function set highlightColor(c:Number):void { barHighlight.color = c; if (!barHighlight.visible) barHighlight.visible = true;  }
		/**
		 *	Sets the gradient style of the progress bars highlight.
		 *  <br>
		 *  NOTE: This method will override the highlightAlpha or highlightColor properties if the have been applied
		 *  @since 1.2
		 *  @param		g	Gradient Style object
		 *  @return			Gradient Style object
		 *  @see 			com.foxr.display.graphics.Graphic#gradientStyle
		 */
		public function set highlightGradient(g:Object):void { 
			barHighlight.gradientStyle = g;
			if (!barHighlight.visible) barHighlight.visible = true; 
		}
		/**
		 *	Sets the alignment property of the progress bar label.
		 *  @since 1.2
		 *  @param		a	Progress Bar label alignment
		 *  @return			Progress Bar label alignment value
		 */
		public function get labelAlignment():String { return _labelAlign; }
		public function set labelAlignment(a:String):void { _labelAlign = a; update(); }
		/**
		 *	manually updates the percentage complete value of the progress bar and 
		 *  redraws the bar graphic. Valid values are 0-100.
		 *  @since 1.2
		 *  @param		pc	Progress Bar percentage complete value
		 *  @return			Progress Bar percentage complete value
		 */
		public function set percentComplete(pc:Number):void { 
			if (pc > -1 && pc < 101) {
				_percentComplete = pc; 
				var newWidth:Number = Math.min( (progressElem.width) / (_max - _min) * pc, progressElem.width);
				if(_direction == DIRECTION_LEFT) {
					barSolid.x = (progressElem.width - newWidth);
					if (barShadow.visible) barShadow.x = (progressElem.width - newWidth);
					if (barHighlight.visible) barHighlight.x = (progressElem.width - newWidth);
				} // END if
				barSolid.width = newWidth;
				if (barShadow.visible) barShadow.width = newWidth;
				if (barHighlight.visible) barHighlight.width = newWidth;
				txt.text = pc + "%";
			} else {
				gpm.log.error(this.name + ", percentComplete, invalid value received. The value received, " + pc + ", was not within the acceptable range of 0-100.");
			} // END if
			update();
		}
		/**
		 *	Sets the alpha of the progress bars shadow.
		 *  @since 1.2
		 *  @param		a	Alpha in 1.0 format
		 *  @return			Alpha in 1.0 format
		 */
		public function get shadowAlpha():Number{ return barShadow.alpha; }
		public function set shadowAlpha(a:Number):void { barShadow.alpha = a; }
		/**
		 *	Sets the color of the progress bars shadow.
		 *  @since 1.2
		 *  @param		c	Color in 0x000000 format
		 *  @return			Color in 0x000000 format
		 */
		public function get ShadowColor():Number{ return barShadow.color; }
		public function set ShadowColor(c:Number):void { barShadow.color = c; if (!barShadow.visible) barShadow.visible = true;  }
		/**
		 *	Sets the gradient style of the progress bars shadow.
		 *  <br>
		 *  NOTE: This method will override the shadowAlpha or ShadowColor properties if the have been applied.
		 *  @since 1.2
		 *  @param		g	Gradient Style object
		 *  @return			Gradient Style object
		 *  @see 			com.foxr.display.graphics.Graphic#gradientStyle
		 */
		public function set shadowGradient(g:Object):void { 
			barShadow.gradientStyle = g; 
			if (!barShadow.visible) barShadow.visible = true; 
		}
		/**
		 *	Gets or sets a reference to the content that is being loaded and for which the ProgressBar 
		 *  is measuring the progress of the load operation. A typical usage of this property is to set 
		 *  it to a UILoader component.
		 *  <p />
		 *  Use this property only in event mode and polled mode.
		 *  <p />
		 *  The default value is null.
		 *  
		 *  @since 1.0
		 *  @param		s	Valid source element, such as URLLoader
		 *  @return			Current source element
		 */
		public function set source(s:Object):void { 
			_source = s;
		}
		/**
		 * Changes the width of the object and child elements. 
		 * @since	1.0
		 * @param	b	The width in pixels
		 * @return		The width in pixels
		 */
		public override function set width(w:Number):void {
			super.width = w;
			progressElem.width = w - (borderWidth * 2);
			progressElem.x = borderWidth;
			update();
		}
		/*--------------------------------------
		/	PUBLIC FUNCTIONS
		/-------------------------------------*/
		/**
		 * Executes once they have been added to the movie stage.
		 * @since	1.0
		 */
		public override function objReady(e:Event):void {
			super.objReady(e);
			bkgd.visible = true;
			txt.visible = true;
			barSolid.visible = true;
			barSolid.width = barHighlight.width =  barShadow.width = 0;
		}
		/**
		 * Sets the state of the bar to reflect the amount of progress made when using manual mode. The 
		 * value argument is assigned to the value property and the maximum argument is assigned to the 
		 * maximum property. The minimum property is not altered.
		 * @param	pc	A value describing the progress that has been made.
		 * @since	1.0
		 */
		public function setProgress(pc:Number):void {
			barShadow.width = barHighlight.width = barSolid.width = Math.min( (progressElem.width) / (_max - _min) * pc, progressElem.width);
			txt.text = pc + "%";
		}
		/*--------------------------------------
		/	protected FUNCTIONS
		/-------------------------------------*/
		/**
		 * Redraws the layout of the component based on physical changes.
		 */
		protected function update():void {
			switch (_labelAlign) {
				case LABEL_ALIGN_LEFT:
					txt.x = 0;
					progressElem.x = (txt.textWidth + (_padding * 2));
					break;
				case LABEL_ALIGN_RIGHT:
					progressElem.x = 0;
					txt.x = (progressElem.width + (_padding * 2));
					break;
				case LABEL_ALIGN_TOP:
					txt.y = 0;
					progressElem.y = (txt.textHeight + _padding);
					break;
				case LABEL_ALIGN_BOTTOm:
					progressElem.y = 0;
					txt.y  = (progressElem.height + _padding);
					break;
			} // END switch
			if (_labelAlign == LABEL_ALIGN_LEFT || _labelAlign == LABEL_ALIGN_RIGHT) {
				if (progressElem.height > txt.textHeight) {
					txt.y = (progressElem.height / 2) - (txt.textHeight / 2);
				} else {
					txt.y = (txt.textHeight / 2) - (progressElem.height / 2);
				} // END if
			} else {
				txt.x = (progressElem.width / 2) - (txt.textWidth / 2);
			} // END if
		}
	}
}