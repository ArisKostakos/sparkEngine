/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, October 2014
 */

 package tools.spark.sliced.services.std.display.managers.core;
import tools.spark.sliced.services.std.display.active_displayentity_references.core.ActiveStageReference;
import tools.spark.sliced.services.std.display.active_displayentity_references.interfaces.IActiveStageReference;
import tools.spark.sliced.services.std.display.active_displayentity_references.interfaces.IActiveViewReference;
import tools.spark.sliced.services.std.display.managers.interfaces.IActiveReferenceMediator;
import tools.spark.sliced.services.std.display.managers.interfaces.IDisplayObjectManager;
import tools.spark.sliced.services.std.logic.gde.core.GameEntity;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameForm;

/**
 * ...
 * @author Aris Kostakos
 */
class StageReferenceManager implements IDisplayObjectManager
{	
	private var _activeReferenceMediator:IActiveReferenceMediator;
	
	public function new(p_activeReferenceMediator:IActiveReferenceMediator) 
	{
		_activeReferenceMediator = p_activeReferenceMediator;
	}
	
	public function create(p_gameEntity:IGameEntity):Dynamic 
	{
		//typecast?
		
		var l_stageReference:IActiveStageReference = new ActiveStageReference(p_gameEntity);
		
		return l_stageReference;
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
		
		//updateState(p_object, p_gameEntity, 'stage properties');
		
		
		//FOR ALL CHILDREN
		//@FIX ME VERY VERY SOON!: OMG, if I keep updating the Stage it will keep adding the same views!! REMOVE THEM FIRST!!!!!!!! or smth..
		for (f_viewEntity in p_gameEntity.getChildren())
		{
			addTo(f_viewEntity,p_object);
		}
	}
	
	public function updateState(p_object:Dynamic, p_gameEntity:IGameEntity, p_state:String):Void 
	{
		//Check if this gameEntity was Active
		if (p_object == null) return;
		
		//typecast?
		
		/*
		switch (p_state)
		{

		}
		*/
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

		var l_stageReference:IActiveStageReference = cast(p_objectParent, ActiveStageReference);
		var l_viewEntity:IGameEntity = cast(p_objectChild, GameEntity);
		
		if (l_viewEntity.getState('displayType') == "View") //weak typecasting
			_addView(l_stageReference,_activeReferenceMediator.createViewReference(l_viewEntity),l_viewEntity);
		else
			Console.warn("A child of a Stage gameEntity is NOT a View! Ignoring...");
	}
	
	public function removeFrom(p_objectChild:Dynamic, p_objectParent:Dynamic):Void
	{
		//Check if this gameEntity was Active
		if (p_objectParent == null) return;
		
		//typecast?
		
	}
	
	private function _addView(p_stageReference:IActiveStageReference, p_viewReference:IActiveViewReference, p_viewEntity:IGameEntity):Void
	{
		//somewhere around here, you should make sure if the view being added previously belonged somewhere else, it should get removed from that place
		
		if (_activeReferenceMediator.getActiveViewReference(p_viewEntity) != null)
		{
			Console.warn("This view object [" + p_viewEntity.getState('name') + "] is already bound to the Active Stage. Ignoring...");
			//in this case, the newly created viewReference pointer won't be held anywhere and the viewRererence object will be garbage collected :/
		}
		else
		{
			if (p_viewEntity.getState('scene') == null || p_viewEntity.getState('camera') == null)
			{
				//weakly typecast scene and camera?
				
				Console.warn("This view object [" + p_viewEntity.getState('name') + "] is not ready yet (missing camera or scene). Ignoring...");
				//in this case, the newly created viewReference pointer won't be held anywhere and the viewRererence object will be garbage collected :/
			}
			else
			{
				p_stageReference.addView(p_viewReference);
				_activeReferenceMediator.viewReferenceManager.update(p_viewReference, p_viewEntity);
			}
		}
	}
}