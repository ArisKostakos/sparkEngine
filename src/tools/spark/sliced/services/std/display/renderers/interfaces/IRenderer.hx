/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, November 2013
 */

package tools.spark.sliced.services.std.display.renderers.interfaces;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;

/**
 * ...
 * @author Aris Kostakos
 */
interface IRenderer
{
	//var name( default, null ):String;
	//var uses3DEngine( default, null ):Bool;
	
	function renderView ( p_viewEntity:IGameEntity):Void;
	function addView ( p_viewEntity:IGameEntity):Void;
	function removeView ( p_viewEntity:IGameEntity):Void;
}