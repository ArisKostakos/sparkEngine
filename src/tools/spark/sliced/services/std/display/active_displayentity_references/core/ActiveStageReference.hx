/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, August 2014
 */

package tools.spark.sliced.services.std.display.active_displayentity_references.core;

import tools.spark.sliced.services.std.display.active_displayentity_references.interfaces.IActiveStageReference;
import tools.spark.sliced.services.std.display.active_displayentity_references.interfaces.IActiveViewReference;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;

/**
 * ...
 * @author Aris Kostakos
 */
class ActiveStageReference implements IActiveStageReference
{
	public var activeViewReferences (default, null ):Array<IActiveViewReference>;
	public var stageEntity( default, null ):IGameEntity;
	
	public function new(p_stageEntity:IGameEntity) 
	{
		stageEntity = p_stageEntity;
		
		_init();
	}
	
	inline private function _init():Void
	{
		activeViewReferences = new Array<IActiveViewReference>();
	}
	
	public function logViewReferences():Void
	{
		Console.log("Printing Active Views");
		Console.log("---------------------");
		for (activeViewReference in activeViewReferences)
		{
			Console.log("View " + activeViewReference.viewEntity.getState('name') + " Index: " + activeViewReference.viewEntity.getState('zIndex'));
		}
	}
	
	public function addView(p_viewReference:IActiveViewReference):Void
	{
		//Push the new View Reference
		activeViewReferences.push(p_viewReference);
		
		//Reorder View References
		activeViewReferences.sort(_orderViews);
	}
	
	private function _orderViews(viewReference1:IActiveViewReference, viewReference2:IActiveViewReference):Int
	{
		if (viewReference1.viewEntity.getState('zIndex')>viewReference2.viewEntity.getState('zIndex')) return 1;
		else if (viewReference1.viewEntity.getState('zIndex') < viewReference2.viewEntity.getState('zIndex')) return -1;
		else return 0;
	}
}