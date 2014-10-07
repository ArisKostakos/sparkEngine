/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, August 2014
 */

package tools.spark.sliced.services.std.display.active_displayentity_references.core;

import tools.spark.sliced.services.std.display.active_displayentity_references.interfaces.IActiveViewReference;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;
import tools.spark.sliced.services.std.display.renderers.interfaces.IRenderer;
import tools.spark.sliced.core.Sliced;

/**
 * ...
 * @author Aris Kostakos
 */
class ActiveViewReference implements IActiveViewReference
{
	public var viewEntity( default, null ):IGameEntity;
	public var renderer( default, null ):IRenderer;
	
	public function new(p_viewEntity:IGameEntity) 
	{
		viewEntity = p_viewEntity;
		
		_init();
	}
	
	inline private function _init():Void
	{
		Console.log("View " + viewEntity.getState('name') + " is now Active!");
		
		//renderer?
		//@FIX NOW: When renderer selection is done, fix this so it picks the appropriate renderer. Now it will always assign every view to the first one found!
		if (viewEntity.getState('name')=="GUI View")
			renderer = Sliced.display.platformRendererSet[0];
		else
			renderer = Sliced.display.platformRendererSet[1];
		
		//This is huge... starting to talk to renderers here!! right place to do that???
		renderer.addView(viewEntity);
	}
}