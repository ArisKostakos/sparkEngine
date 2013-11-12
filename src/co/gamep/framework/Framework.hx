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
		// Init Flambe
		System.init();
		
		//Init Platform Specific Graphics
		Graphics.init();
	}
	
	public static function createDisplayRenderers():Void
	{
		Graphics.createDisplayRenderers();
	}
}