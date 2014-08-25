/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, November 2013
 */

package tools.spark.framework.platform.html.flambe2_5;
import tools.spark.sliced.core.Sliced;
import tools.spark.sliced.services.std.display.renderers.core.platform.html.Flambe2_5DHtmlRenderer;
import tools.spark.sliced.services.std.display.renderers.interfaces.IRenderer;
import flambe.platform.Renderer;
import flambe.platform.html.HtmlPlatform;

/**
 * ...
 * @author Aris Kostakos
 */
class Subgraphics
{	
	private static var _flambeDisplaySystem:Renderer;
	
	public static function createDisplayRenderers():Void
	{
		//Create Flambe Renderer
		Sliced.display.platformRendererSet.push(new Flambe2_5DHtmlRenderer());
	}
	
	
	public static function init():Void
	{
		//Flambe Init
		_flambeDisplaySystem = HtmlPlatform.instance.getRenderer();
	}
	

	public static function onRender():Void
	{
		//Flambe Prepare Render
		_flambeDisplaySystem.willRender();
		
		//query display for views in order (far away first)
		if (Sliced.display!=null)
		{
			/*@FIX RIGHT NOW
			if (Sliced.display.activeViewsOrder!=null)
			{
				//for each LogicalView
				for (viewEntity in Sliced.display.activeViewsOrder)
				{
					//query Display what renderer has it
					var renderer:IRenderer = Sliced.display.viewToRenderer[viewEntity];
					
					//Render viewEntity
					renderer.renderView(viewEntity);
				}
			}
			*/
		}
		
		//Flambe Finish Render
		_flambeDisplaySystem.didRender();
	}
}