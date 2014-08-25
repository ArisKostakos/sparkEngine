/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, November 2013
 */

package tools.spark.framework.platform.flash;


#if includeAway3D
	import tools.spark.framework.platform.flash.away3d.Subgraphics;
#else
	import tools.spark.framework.platform.flash.flambe2_5.Subgraphics;
#end


/**
 * ...
 * @author Aris Kostakos
 */
class Graphics
{	
	public static function init():Void
	{
		Subgraphics.init();
	}
	
	public static function createDisplayRenderers():Void
	{
		Subgraphics.createDisplayRenderers();
	}

}