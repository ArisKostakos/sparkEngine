/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, November 2013
 */

 package tools.spark.sliced.services.std.display.renderers.core.platform.html;


import tools.spark.sliced.services.std.display.renderers.core.library.AFlambe2_5DRenderer;
import flambe.platform.html.HtmlPlatform;
import tools.spark.sliced.services.std.display.renderers.interfaces.IPlatformSpecificRenderer;


/**
 * ...
 * @author Aris Kostakos
 * 
 */
class Flambe2_5DHtmlRenderer extends AFlambe2_5DRenderer implements IPlatformSpecificRenderer
{
	public function new() 
	{
		_platform = HtmlPlatform.instance;
		
		super();
		
		_flambe2DHtmlRendererInit();
	}
	
	inline private function _flambe2DHtmlRendererInit():Void
	{
		Console.log("Creating Flambe 2_5D Html Renderer...");
	}
}