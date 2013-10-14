/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, September 2013
 */

package org.gamepl.coreservices.services.std.display.renderers.core;
import org.gamepl.coreservices.services.std.display.renderers.interfaces.IRenderer;

/**
 * ...
 * @author Aris Kostakos
 */
class ARenderer implements IRenderer
{
	public var rendererType( default, null ):String;
	
	public var posX( default, null ):Int;
	public var posY( default, null ):Int;
	public var width( default, null ):Int;
	public var height( default, null ):Int;
	
	private function new(p_rendererType:String, p_posX:Int, p_posY:Int, p_width:Int, p_height:Int) 
	{
		rendererType = p_rendererType;
		posX = p_posX;
		posY = p_posY;
		width = p_width;
		height = p_height;
	}
	
}