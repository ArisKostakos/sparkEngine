/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, November 2013
 */

 package tools.spark.sliced.services.std.display.renderers.core;

import tools.spark.sliced.services.std.display.renderers.interfaces.IRenderer;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;

/**
 * ...
 * @author Aris Kostakos
 */
class ARenderer implements IRenderer
{
	private function new() 
	{
		_aRendererInit();
	}

	inline private function _aRendererInit():Void
	{
		
	}
	
	
	//abstract functions
	public function renderView ( p_viewEntity:IGameEntity):Void { }
	public function addView ( p_viewEntity:IGameEntity):Void { }
	public function removeView ( p_viewEntity:IGameEntity):Void { }
}