package com.foxr.display.components 
{
	//import external classes
	import com.foxr.display.components.ProgressBar;
	
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.events.Event;	
	import flash.geom.Matrix;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	/**
	 * An extention of ProgressBar which draws a vista style progress bar.
	 * <p />
	 * Bar drawing code adapted from the Progress bar object developed for the ActionScript 3 
	 * Toolkit, adventuresinactionscript.com.
	 * 
	 * @langversion 	ActionScript 3.0
	 * @playerversion 	Flash 9
	 * @author			Adventures In Actionscript AS3 Toolkit
	 * @author			Jeff Fox
	 * version 			1.1
	 *
	 * Copyright (c) 2009 Jeff Fox. Licensed under the MIT License.
	 * Portions Copyright (C) 2008 www.adventuresinactionscript.com
	 * 
	 */
	public class ProgressBarVista extends ProgressBar {
		
		/*--------------------------------------
		/	VARIABLES
		/-------------------------------------*/
		private var _barColors:Array = [0xC5FFC5, 0x95EBA6,0x00CB14,0x49EF5D];
		private var _barAlphas:Array = [1, 1, 1, 1];
		private var _barRatios:Array = [0, 0x6F, 0x80, 0xFF];
		
		private var _highlightColors:Array = [0xFFFFFF,0xFFFFFF,0xFFFFFF,0xFFFFFF];
		private var _highlightAlphas:Array = [0.7, 0.1, 0, 0];
		private var _highlightRatios:Array = [0x0, 0x30, 0x3F, 0xFF];
		
		private var _barShadowColors:Array = [0x444444,0x444444,0x444444,0x444444];
		private var _barShadowAlphas:Array = [0.2, 0, 0, 0.2];
		private var _barShadowRatios:Array = [0,0x07,0xF7,0xFF];
		/*--------------------------------------
		/	CONSTRUCTOR
		/-------------------------------------*/
		/**
		 * Construct a new ProgressBarVista instance.
		 *
		 */
		public function ProgressBarVista() { 
			super();
		}
		/*--------------------------------------
		/	SET/GET FUNCTIONS
		/-------------------------------------*/
		public override function set percentComplete(pc:Number):void { 
			_percentComplete = pc; 
		
			var matrix:Matrix = new Matrix();
			barSolid.graphics.clear();
			//draw highlightrect
			barSolid.graphics.lineStyle(1, 0xFFFFFF, 0.5);
			barSolid.graphics.drawRect(1, 1, progressElem.width, progressElem.height);
			//draw progress bar
			var drawBarWidth:int = Math.min( (progressElem.width) / (_max - _min) * pc, progressElem.width);
			matrix.createGradientBox(progressElem.width, progressElem.height, (90 / 180) * Math.PI, 0, 0);
			barSolid.graphics.lineStyle(0,0,0);
			barSolid.graphics.beginGradientFill(GradientType.LINEAR, _barColors, _barAlphas, _barRatios, matrix,SpreadMethod.PAD);
			barSolid.graphics.drawRect(1, 1, drawBarWidth, progressElem.height);
			barSolid.graphics.endFill();
			//draw bar shadow
			barSolid.graphics.lineStyle(0,0,0);
			matrix.createGradientBox(drawBarWidth, progressElem.height, (0 / 180) * Math.PI, 0, 0);
			barSolid.graphics.beginGradientFill(GradientType.LINEAR, _barShadowColors, _barShadowAlphas, _barRatios, matrix,SpreadMethod.PAD);
			barSolid.graphics.drawRect(1, 1, drawBarWidth, progressElem.height);
			barSolid.graphics.endFill();	
			//top highlight
			barSolid.graphics.lineStyle(0,0,0);
			matrix.createGradientBox(progressElem.width, progressElem.height, (90 / 180) * Math.PI, 0, 0);
			trace("matrix = " + matrix);
			barSolid.graphics.beginGradientFill(GradientType.LINEAR, _highlightColors, _highlightAlphas, _highlightRatios, matrix,SpreadMethod.PAD);
			barSolid.graphics.drawRect(1, 1, progressElem.width, progressElem.height);
			barSolid.graphics.endFill();	
			txt.text = pc + "%";
		}
		/*--------------------------------------
		/	PUBLIC FUNCTIONS
		/-------------------------------------*/
		/*--------------------------------------
		/	PRIVATE FUNCTIONS
		/-------------------------------------*/
		
	}
	
}