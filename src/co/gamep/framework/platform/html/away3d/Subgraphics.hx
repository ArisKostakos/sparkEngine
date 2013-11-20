/* Copyright © Game Plus Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, November 2013
 */

package co.gamep.framework.platform.html.away3d;
import co.gamep.sliced.services.std.display.renderers.core.Away3DHtmlRenderer;
import co.gamep.sliced.services.std.display.renderers.core.FlambeRenderer;
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
		
		//Create Away3D Renderer
		Sliced.display.rendererSet.push(new Away3DHtmlRenderer());
	}
	
	public static function init():Void
	{
		//If Away3d code is inside, it will be responsible for
		//drawing things, instead of
	}
}