/* Copyright © Game Plus Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, November 2013
 */

package co.gamep.framework.platform.flash.flambe;
import co.gamep.sliced.services.std.display.renderers.core.FlambeRenderer;
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
	public static function createDisplayRenderers():Void
	{
		//Create Flambe Renderer
		Sliced.display.rendererSet.push(new FlambeRenderer());
	}
	
	public static function init():Void
	{
		//The Render Call  (Event.ENTER_FRAME, OR Event.RENDER?)
		Lib.current.stage.addEventListener(Event.RENDER, _onRender);
	}
	
    private static function _onRender (_)
    {
		var renderer:Renderer = FlashPlatform.instance.getRenderer();
		
        var graphics = renderer.graphics;
        if (graphics != null) {
            renderer.willRender();
            Sprite.render(System.root, graphics);
            renderer.didRender();
        }
    }

}