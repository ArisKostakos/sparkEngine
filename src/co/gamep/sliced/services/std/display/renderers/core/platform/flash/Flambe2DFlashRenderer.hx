/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, November 2013
 */

 package co.gamep.sliced.services.std.display.renderers.core.platform.flash;


import co.gamep.sliced.services.std.display.renderers.core.platform.AFlambe2DRenderer;
import flambe.platform.flash.FlashPlatform;


/**
 * ...
 * @author Aris Kostakos
 */
class Flambe2DFlashRenderer extends AFlambe2DRenderer
{
	public function new() 
	{
		_platform = FlashPlatform.instance;
		
		super();
		
		_flambe2DFlashRendererInit();
	}
	
	inline private function _flambe2DFlashRendererInit():Void
	{
		Console.info("Creating Flambe 2D Flash Renderer...");
	}
}