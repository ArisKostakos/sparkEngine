/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, November 2013
 */

package tools.spark.framework.platform.html.flambe2_5;
import flambe.platform.InternalRenderer;
import tools.spark.sliced.core.Sliced;
import tools.spark.sliced.services.std.display.renderers.core.platform.html.Flambe2_5DHtmlRenderer;
import tools.spark.sliced.services.std.display.renderers.interfaces.IRenderer;
import flambe.platform.html.HtmlPlatform;

/**
 * ...
 * @author Aris Kostakos
 */
class Subgraphics
{	
	private static var _flambeDisplaySystem:InternalRenderer<Dynamic>;
	
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
			//@todo WTF, two more ifs here, JUST to check if there are active Views available???? DO SOMETHING ABOUT THAT, THIS THING RUNS EVERY - SINGLE - FRAME
			if (Sliced.display.projectActiveSpaceReference!=null)
			{
				if (Sliced.display.projectActiveSpaceReference.activeStageReference!=null)
				{
					//for each Active View Reference (there are in z-order)
					for (activeViewReference in Sliced.display.projectActiveSpaceReference.activeStageReference.activeViewReferences)
					{
						//Render viewEntity
						activeViewReference.renderer.renderView(activeViewReference.viewEntity);
					}
				}
			}
		}
		
		//Flambe Finish Render
		_flambeDisplaySystem.didRender();
	}
}