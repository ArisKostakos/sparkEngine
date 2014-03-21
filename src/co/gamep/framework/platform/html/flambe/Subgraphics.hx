/* Copyright © Game Plus Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, November 2013
 */

package co.gamep.framework.platform.html.flambe;
import co.gamep.sliced.core.Sliced;
import co.gamep.sliced.services.std.display.renderers.core.platform.html.Flambe2DHtmlRenderer;
import co.gamep.sliced.services.std.display.renderers.interfaces.IRenderer;
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
		Sliced.display.rendererSet.push(new Flambe2DHtmlRenderer());
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
			if (Sliced.display.space!=null)
			{
				//for each LogicalView
				for (viewEntity in Sliced.display.space.children)  //for (logicalView in logicalSpace.logicalStage.logicalViewSet)
				{
					//query Display what renderer has it
					var renderer:IRenderer = Sliced.display.viewToRenderer[viewEntity];
					
					//Render viewEntity
					renderer.render(viewEntity);
				}
			}
		}
		
		//Flambe Finish Render
		_flambeDisplaySystem.didRender();
	}
}