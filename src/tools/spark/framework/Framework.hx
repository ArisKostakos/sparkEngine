/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, November 2013
 */

package tools.spark.framework;
import flambe.System;

#if flash
	import tools.spark.framework.platform.flash.Graphics;
#else
	import tools.spark.framework.platform.html.Graphics;
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