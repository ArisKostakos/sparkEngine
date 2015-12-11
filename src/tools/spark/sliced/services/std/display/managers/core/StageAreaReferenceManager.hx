/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, October 2014
 */

 package tools.spark.sliced.services.std.display.managers.core;
import tools.spark.sliced.services.std.display.active_displayentity_references.core.ActiveStageAreaReference;
import tools.spark.sliced.services.std.display.active_displayentity_references.interfaces.IActiveStageAreaReference;
import tools.spark.sliced.services.std.display.managers.interfaces.IActiveReferenceMediator;
import tools.spark.sliced.services.std.display.managers.interfaces.IDisplayObjectManager;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameForm;

/**
 * ...
 * @author Aris Kostakos
 */
class StageAreaReferenceManager implements IDisplayObjectManager
{	
	private var _activeReferenceMediator:IActiveReferenceMediator;
	
	public function new(p_activeReferenceMediator:IActiveReferenceMediator) 
	{
		_activeReferenceMediator = p_activeReferenceMediator;
	}
	
	public function create(p_gameEntity:IGameEntity):Dynamic 
	{
		//typecast?
		
		var l_stageAreaReference:IActiveStageAreaReference = new ActiveStageAreaReference(p_gameEntity);
		
		return l_stageAreaReference;
	}
	
	public function destroy(p_object:Dynamic):Void 
	{
		//typecast?
		
	}
	
	public function update(p_object:Dynamic, p_gameEntity:IGameEntity):Void
	{
		//Check if this gameEntity was Active
		if (p_object == null) return;
		
		//typecast
		var l_stageAreaReference:IActiveStageAreaReference = cast(p_object, IActiveStageAreaReference);
		
		//Update my layoutObject
		l_stageAreaReference.layoutElement.update();
	}
	
	public function updateState(p_object:Dynamic, p_gameEntity:IGameEntity, p_state:String):Void 
	{
		//Check if this gameEntity was Active
		if (p_object == null) return;
		
		//typecast
		var l_stageAreaReference:IActiveStageAreaReference = cast(p_object, IActiveStageAreaReference);
		
		l_stageAreaReference.layoutElement.updateState(p_state);
	}
	
	public function addTo(p_objectChild:Dynamic, p_objectParent:Dynamic):Void
	{
		//Check if this gameEntity was Active
		if (p_objectParent == null) return;
		
		//StageArea doesn't have children..
		
	}
	
	public function insertTo(p_objectChild:Dynamic, p_objectParent:Dynamic, p_index:Int):Void
	{
		//typecast?
		
	}
	
	public function removeFrom(p_objectChild:Dynamic, p_objectParent:Dynamic):Void
	{
		//Check if this gameEntity was Active
		if (p_objectParent == null) return;
		
		//StageArea doesn't have children..
		
	}
}