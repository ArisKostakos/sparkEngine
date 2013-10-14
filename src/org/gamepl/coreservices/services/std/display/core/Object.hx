/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, October 2013
 */

package org.gamepl.coreservices.services.std.display.core;
import org.gamepl.coreservices.services.std.display.interfaces.IObject;
import org.gamepl.coreservices.services.std.display.renderers.core.OpenFlRenderer;
import org.gamepl.coreservices.services.std.display.renderers.interfaces.IRenderer;

/**
 * ...
 * @author Aris Kostakos
 */
class Object implements IObject
{
	public var rendererType( default, null ):String;
	public var renderer( default, null ):IRenderer;
	
	public var posX( default, null ):Int;
	public var posY( default, null ):Int;
	public var width( default, null ):Int;
	public var height( default, null ):Int;
	
	static inline private var _RENDERER_OPENFL:String = "openFl";

	public function new(p_rendererType:String, p_posX:Int, p_posY:Int, p_width:Int, p_height:Int) 
	{
		rendererType = p_rendererType;
		posX = p_posX;
		posY = p_posY;
		width = p_width;
		height = p_height;
 		
		if (p_rendererType == _RENDERER_OPENFL)
			renderer = new OpenFlRenderer(p_rendererType, p_posX, p_posY, p_width, p_height);
	}
	
}