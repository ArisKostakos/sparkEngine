/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, November 2013
 */

package tools.spark.framework.platform.flash.flambe2_5;
import tools.spark.sliced.services.std.display.renderers.core.platform.flash.Flambe2_5DFlashRenderer;
import tools.spark.sliced.services.std.display.renderers.interfaces.IRenderer;
import flash.events.Event;
import flash.Lib;
import flambe.platform.flash.FlashPlatform;
import flambe.platform.Renderer;
import flambe.display.Sprite;
import flambe.System;
import tools.spark.sliced.core.Sliced;

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
		Sliced.display.rendererSet.push(new Flambe2_5DFlashRenderer());
	}
	
	public static function init():Void
	{
		//Flambe Init
		_flambeDisplaySystem = FlashPlatform.instance.getRenderer();
		
		//The Render Call  (Event.ENTER_FRAME, OR Event.RENDER?)
		Lib.current.stage.addEventListener(Event.RENDER, _onRender);
	}
	
    private static function _onRender (_)
    {
		//Flambe Prepare Render
		_flambeDisplaySystem.willRender();
		
		//query display for views in order (far away first)
		if (Sliced.display!=null)
		{
			//for each LogicalView
			for (logicalView in Sliced.display.activeViewsOrder)
			{
				//query Display what renderer has it
				var renderer:IRenderer = Sliced.display.logicalViewRendererAssignments[logicalView];
				
				//renderer.render(logicalView)
				renderer.render(logicalView);
			}
		}
		
		//Flambe Finish Render
		_flambeDisplaySystem.didRender();
    }

}