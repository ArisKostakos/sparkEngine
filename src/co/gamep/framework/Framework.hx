/* Copyright © Game Plus Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, November 2013
 */

package co.gamep.framework;
import flambe.System;

#if flash
	import co.gamep.framework.platform.flash.Graphics;
#else
	import co.gamep.framework.platform.html.Graphics;
#end

/**
 * ...
 * @author Aris Kostakos
 */
class Framework
{	
	public static function init():Void
	{
		//In case of html, fix the haxe/js bug to have external js code able to run
		#if html
			//fix the haxe/js bug before running any js code
			untyped __js__('if (Object.defineProperty) Object.defineProperty(Array.prototype, "__class__", {enumerable: false});');
		#end
		
		// Init Flambe
		System.init();
		
		//Init Platform Specific Graphics
		Graphics.init();
		
		//Init Assets System
		Assets.init();
	}
	
	public static function createDisplayRenderers():Void
	{
		Graphics.createDisplayRenderers();
	}
}