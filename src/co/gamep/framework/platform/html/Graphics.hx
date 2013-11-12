/* Copyright © Game Plus Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, November 2013
 */

package co.gamep.framework.platform.html;


#if includeAway3D
	import co.gamep.framework.platform.html.away3d.Subgraphics;
#else
	import co.gamep.framework.platform.html.flambe.Subgraphics;
#end


/**
 * ...
 * @author Aris Kostakos
 */
class Graphics
{	
	public static function init():Void
	{
		Subgraphics.init();
	}
	
	public static function createDisplayRenderers():Void
	{
		Subgraphics.createDisplayRenderers();
	}

}