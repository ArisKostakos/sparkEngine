/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, November 2013
 */

package tools.spark.framework.platform.html;
import tools.spark.sliced.core.Sliced;

#if includeAway3D
	import tools.spark.framework.platform.html.away3d.Subgraphics;
#else
	import tools.spark.framework.platform.html.flambe2_5.Subgraphics;
#end

#if includeNativeComponents
	import tools.spark.sliced.services.std.display.renderers.core.platform.html.NativeControlsHtmlRenderer;
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
		
		#if includeNativeComponents
			//Create Dom Renderer
			Sliced.display.platformRendererSet["NativeControls"] = new NativeControlsHtmlRenderer();
		#end
	}

}