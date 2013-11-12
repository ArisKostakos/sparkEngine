/* Copyright © Game Plus Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, November 2013
 */

package co.gamep.framework.platform.html.flambe;
import co.gamep.sliced.core.Sliced;
import co.gamep.sliced.services.std.display.renderers.core.FlambeRenderer;

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

	}
	

}