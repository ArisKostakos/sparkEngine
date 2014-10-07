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
		_updateViewReferences();
		_logViewReferences();
	}
	
	//Here, it's important before reseting this area, to let the renderers know if a view they have been assigned to is being discarded.
		//this is important since some renderers will keep data of their own that cache a specific view (for example, 2_5 space, flambe's or away3d's internal data)
	private function _updateViewReferences():Void
	{
		activeViewReferences = new Array<IActiveViewReference>();
		
		for (f_viewEntity in stageEntity.getChildren())
		{
			if (f_viewEntity.getState('displayType') == "View") //weak typecasting
			{
				if (f_viewEntity.getState('active') == true)
				{
					activeViewReferences.push(new ActiveViewReference(f_viewEntity));
				}
				else
				{
					Console.log("View Entity not activated yet. Ignoring...");
				}
			}
			else
			{
				Console.warn("A child of a Stage gameEntity is NOT a View! Ignoring...");
			}
		}
		
		//Reorder View References
		activeViewReferences.sort(_orderViews);
	}
	
	private function _logViewReferences():Void
	{
		Console.log("Printing Active Views");
		Console.log("---------------------");
		for (activeViewReference in activeViewReferences)
		{
			Console.log("View " + activeViewReference.viewEntity.getState('name') + " Index: " + activeViewReference.viewEntity.getState('zIndex'));
		}
	}
	
	private function _orderViews(viewReference1:IActiveViewReference, viewReference2:IActiveViewReference):Int
	{
		if (viewReference1.viewEntity.getState('zIndex')>viewReference2.viewEntity.getState('zIndex')) return 1;
		else if (viewReference1.viewEntity.getState('zIndex') < viewReference2.viewEntity.getState('zIndex')) return -1;
		else return 0;
	}
}