/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, September 2013
 */

package org.gamepl.coreservices.services.std.display.renderers.core;
import flash.Lib;
import flash.display.Sprite;

/**
 * ...
 * @author Aris Kostakos
 */
class OpenFlRenderer extends ARenderer
{
	public function new(p_rendererType:String, p_posX:Int, p_posY:Int, p_width:Int, p_height:Int) 
	{
		super(p_rendererType, p_posX, p_posY, p_width, p_height);
		Console.debug("OpenFl Renderer Initiated");
		
		var l_sprite:Sprite = new Sprite();
		l_sprite.x = posX;
		l_sprite.y = posY;
		l_sprite.width = width;
		l_sprite.height = height;
		Lib.current.stage.addChild(l_sprite);
		
		
	}
	
}