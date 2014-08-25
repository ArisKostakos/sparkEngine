/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, November 2013
 */

 package tools.spark.sliced.services.std.display.renderers.core.platform.flash;


import tools.spark.sliced.services.std.display.renderers.core.platform.AFlambe2DRenderer;
import flambe.platform.flash.FlashPlatform;


/**
 * ...
 * @author Aris Kostakos
 */
class Flambe2_5DFlashRenderer extends AFlambe2DRenderer
{
	public function new() 
	{
		_platform = FlashPlatform.instance;
		
		super();
		
		_flambe2DFlashRendererInit();
	}
	
	inline private function _flambe2DFlashRendererInit():Void
	{
		Console.info("Creating Flambe 2_5D Flash Renderer...");
	}
}