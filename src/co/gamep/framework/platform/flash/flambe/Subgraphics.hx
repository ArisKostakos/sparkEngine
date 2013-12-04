/* Copyright © Game Plus Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, November 2013
 */

package co.gamep.framework.platform.flash.flambe;
import co.gamep.sliced.services.std.display.renderers.core.platform.flash.Flambe2DFlashRenderer;
import co.gamep.sliced.services.std.display.renderers.interfaces.IRenderer;
import flash.events.Event;
import flash.Lib;
import flambe.platform.flash.FlashPlatform;
import flambe.platform.Renderer;
import flambe.display.Sprite;
import flambe.System;
import co.gamep.sliced.core.Sliced;

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
		Sliced.display.rendererSet.push(new Flambe2DFlashRenderer());
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
			for (logicalView in Sliced.display.logicalViewsOrder)
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