/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, October 2014
 */

package tools.spark.sliced.services.std.display.managers.core;
import tools.spark.sliced.services.std.display.active_displayentity_references.core.ActiveSpaceReference;
import tools.spark.sliced.services.std.display.active_displayentity_references.core.ActiveStageReference;
import tools.spark.sliced.services.std.display.active_displayentity_references.interfaces.IActiveSpaceReference;
import tools.spark.sliced.services.std.display.active_displayentity_references.interfaces.IActiveStageReference;
import tools.spark.sliced.services.std.display.managers.interfaces.IActiveReferenceMediator;
import tools.spark.sliced.services.std.display.managers.interfaces.IDisplayObjectManager;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;
import tools.spark.sliced.core.Sliced;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameForm;

/**
 * ...
 * @author Aris Kostakos
 */
class SpaceReferenceManager implements IDisplayObjectManager
{	
	private var _activeReferenceMediator:IActiveReferenceMediator;
	
	public function new(p_activeReferenceMediator:IActiveReferenceMediator) 
	{
		_activeReferenceMediator = p_activeReferenceMediator;
	}
	
	public function create(p_gameEntity:IGameEntity):Dynamic 
	{
		//typecast?
		
		var l_spaceReference:IActiveSpaceReference = new ActiveSpaceReference(p_gameEntity);
		
		return l_spaceReference;
	}
	
	public function destroy(p_object:Dynamic):Void 
	{
		//typecast?
		
	}
	
	public function update(p_object:Dynamic, p_gameEntity:IGameEntity):Void
	{
		//Check if this gameEntity was Active
		if (p_object == null) return;
		
		//typecast?
		
		updateState(p_object, p_gameEntity, 'stage');
	}
	
	public function updateState(p_object:Dynamic, p_gameEntity:IGameEntity, p_state:String):Void 
	{
		//Check if this gameEntity was Active
		if (p_object == null) return;
		
		//typecast?
		
		var l_spaceReference:IActiveSpaceReference = cast(p_object, ActiveSpaceReference);
		
		switch (p_state)
		{
			case 'stage':
				if (p_gameEntity.getState(p_state) != null)
				{
					_setStage(l_spaceReference,_activeReferenceMediator.createStageReference(p_gameEntity.getState(p_state)),p_gameEntity.getState(p_state));
				}
		}
	}
	
	private function _setStage(p_spaceReference:IActiveSpaceReference, p_stageReference:IActiveStageReference, p_stageEntity:IGameEntity):Void
	{
		if (_activeReferenceMediator.getActiveStageReference(p_stageEntity) != null)
		{
			Console.warn("This stage object [" + p_stageEntity.getState('name') + "] is already bound to the Active Space. Ignoring...");
			//in this case, the newly created stageReference pointer won't be held anywhere and the stageReference object will be garbage collected :/
		}
		else
		{
			if (_activeReferenceMediator.display.projectActiveSpaceReference.activeStageReference != null)
			{
				//@note if another stage already exists, maybe you can warn better the user, or take
					//other action. may need rerendering, changing renderers, etc, etc, etc
				Console.warn("Another stage object was already set to this Project! Resetting...");
			}
			
			p_spaceReference.activeStageReference = p_stageReference;
			_activeReferenceMediator.stageReferenceManager.update(p_stageReference, p_stageEntity);
		}
	}
	
	public function updateFormState(p_object:Dynamic, p_gameForm:IGameForm, p_state:String):Void 
	{
		//Check if this gameEntity was Active
		if (p_object == null) return;
		
		//typecast?
		
	}
	
	public function addTo(p_objectChild:Dynamic, p_objectParent:Dynamic):Void
	{
		//Check if this gameEntity was Active
		if (p_objectParent == null) return;
		
		//typecast?
		
	}
	
	public function removeFrom(p_objectChild:Dynamic, p_objectParent:Dynamic):Void
	{
		//Check if this gameEntity was Active
		if (p_objectParent == null) return;
		
		//typecast?
		
	}
}