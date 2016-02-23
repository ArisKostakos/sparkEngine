/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, October 2014
 */

 package tools.spark.sliced.services.std.display.managers.core;
import tools.spark.framework.layout.containers.Group;
import tools.spark.sliced.services.std.display.active_displayentity_references.core.ActiveStageReference;
import tools.spark.sliced.services.std.display.active_displayentity_references.interfaces.IActiveStageAreaReference;
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
		
		//typecast
		var l_stageReference:IActiveStageReference = cast(p_object, IActiveStageReference);
		
		updateState(l_stageReference, p_gameEntity, 'test');
		updateState(l_stageReference, p_gameEntity, 'width');
		updateState(l_stageReference, p_gameEntity, 'height');
		
		//Update my layoutObject
		l_stageReference.layoutRoot.update();
		
		//this.. yeah....hmm
		l_stageReference.layoutRoot.explicitWidth = flambe.System.stage.width;
		l_stageReference.layoutRoot.explicitHeight = flambe.System.stage.height;
		
		//FOR ALL CHILDREN
		//@FIX ME VERY VERY SOON!: OMG, if I keep updating the Stage it will keep adding the same views and stageAreas!! REMOVE THEM FIRST!!!!!!!! or smth..
		for (f_stageChildEntity in p_gameEntity.getChildren())
		{
			addTo(f_stageChildEntity,l_stageReference);
		}
	}
	
	public function updateState(p_object:Dynamic, p_gameEntity:IGameEntity, p_state:String):Void 
	{
		//Check if this gameEntity was Active
		if (p_object == null) return;
		
		//typecast?
		var l_activeStageReference:IActiveStageReference = cast(p_object, IActiveStageReference);
		
		switch (p_state)
		{
			//case 'test':
				//_createStageLayOutThing(l_activeStageReference, p_gameEntity);
			case 'width':
				//_createStageLayOutThing(l_activeStageReference, p_gameEntity);
			case 'height':
				//_createStageLayOutThing(l_activeStageReference, p_gameEntity);
		}
		
	}
	/*
	private function _createStageLayOutThing(p_activeStageReference:IActiveStageReference, p_gameEntity:IGameEntity):Void
	{
		//i guess we create our thing on the activeStageRegerence eyh? where else..
		
		var fullStage:Group = new Group();
		
		//give skata real stage width and stuff..
		fullStage.explicitWidth = flambe.System.stage.width;
		fullStage.explicitHeight = flambe.System.stage.height;
		
		//add substages and stuff
		//..
		
		//add test children
		var childOne:Group = new Group();
		childOne.horizontalCenter = 0;
		
		var childOneInChildOne:Group = new Group();
		
		childOneInChildOne.explicitWidth = 50;
		childOneInChildOne.explicitHeight = 50;
		childOneInChildOne.left = 200;
		childOneInChildOne.top = 200;
		
		childOne.children.push(childOneInChildOne);
		
		
		fullStage.children.push(childOne);
		
		
		
		//So now if we measure everything, ChildOne's width and height were not explicit (like everything else)
		//so they should be measured as 250,250
		_layoutManagerMeasure(fullStage);
		
		//let's try this shit...
		Console.error('====================================================');
		Console.error("Full Stage Preferred Width: " + fullStage.preferredWidth);
		Console.error("Full Stage Preferred Height: " + fullStage.preferredHeight);
		Console.error("Child One Preferred Width: " + childOne.preferredWidth);
		Console.error("Child One Preferred Height: " + childOne.preferredHeight);
		Console.error("childOneInChildOne Preferred Width: " + childOneInChildOne.preferredWidth);
		Console.error("childOneInChildOne Preferred Height: " + childOneInChildOne.preferredHeight);
		Console.error('====================================================');
		
		//fuck yeah..
		
		//now layout manager actually positions layouts..
		_layoutManagerUpdateDisplayList(fullStage);
		
		
		//when it doesnt crash, trace some x,y,width,height of our groups
		//on init they are 0 but updatedisplaylist updates them all
		Console.error('----------------full stage----------------');
		Console.error("Full Stage REAL x: " + fullStage.x);
		Console.error("Full Stage REAL y: " + fullStage.y);
		Console.error("Full Stage REAL Width: " + fullStage.width);
		Console.error("Full Stage REAL Height: " + fullStage.height);
		Console.error('----------------Child One----------------');
		Console.error("Child One REAL x: " + childOne.x);
		Console.error("Child One REAL y: " + childOne.y);
		Console.error("Child One REAL Width: " + childOne.width);
		Console.error("Child One REAL Height: " + childOne.height);
		Console.error('----------------childOneInChildOne----------------');
		Console.error("childOneInChildOne REAL x: " + childOneInChildOne.x);
		Console.error("childOneInChildOne REAL y: " + childOneInChildOne.y);
		Console.error("childOneInChildOne REAL Width: " + childOneInChildOne.width);
		Console.error("childOneInChildOne REAL Height: " + childOneInChildOne.height);
		Console.error('-------------------------------------------------');
	}*/
	
	
	public function addTo(p_objectChild:Dynamic, p_objectParent:Dynamic):Void
	{
		//Check if this gameEntity was Active
		if (p_objectParent == null) return;
		
		//typecast?

		var l_stageReference:IActiveStageReference = cast(p_objectParent, ActiveStageReference);
		var l_stageChildEntity:IGameEntity = cast(p_objectChild, GameEntity);
		
		if (l_stageChildEntity.getState('displayType') == "View") //weak typecasting
			_addView(l_stageReference, _activeReferenceMediator.createViewReference(l_stageChildEntity), l_stageChildEntity);
		else if (l_stageChildEntity.getState('displayType') == "StageArea") //weak typecasting
			_addStageArea(l_stageReference,_activeReferenceMediator.createStageAreaReference(l_stageChildEntity),l_stageChildEntity);
		else
			Console.warn("A child of a Stage gameEntity is NOT a View or a StageArea! Ignoring...");
	}
	
	public function insertTo(p_objectChild:Dynamic, p_objectParent:Dynamic, p_index:Int):Void
	{
		//typecast?
		
	}
	
	public function removeFrom(p_objectChild:Dynamic, p_objectParent:Dynamic):Void
	{
		//Check if this gameEntity was Active
		if (p_objectParent == null) return;
		
		//typecast?
		
		var l_stageReference:IActiveStageReference = cast(p_objectParent, ActiveStageReference);
		var l_stageChildEntity:IGameEntity = cast(p_objectChild, GameEntity);
		
		if (l_stageChildEntity.getState('displayType') == "View") //weak typecasting
			_removeView(l_stageReference, l_stageChildEntity);
		else if (l_stageChildEntity.getState('displayType') == "StageArea") //weak typecasting
			_removeStageArea(l_stageReference, l_stageChildEntity);
		else
			Console.warn("A child of a Stage gameEntity is NOT a View or a StageArea! Ignoring...");
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
	
	private function _addStageArea(p_stageReference:IActiveStageReference, p_stageAreaReference:IActiveStageAreaReference, p_stageAreaEntity:IGameEntity):Void
	{
		//somewhere around here, you should make sure if the stageArea being added previously belonged somewhere else, it should get removed from that place
		
		if (_activeReferenceMediator.getActiveStageAreaReference(p_stageAreaEntity) != null)
		{
			Console.warn("This stageArea object [" + p_stageAreaEntity.getState('name') + "] is already bound to the Active Stage. Ignoring...");
			//in this case, the newly created stageAreaReference pointer won't be held anywhere and the stageAreaReference object will be garbage collected :/
		}
		else
		{
			p_stageReference.addStageArea(p_stageAreaReference);
			_activeReferenceMediator.stageAreaReferenceManager.update(p_stageAreaReference, p_stageAreaEntity);
		}
	}
	
	private function _removeView(p_stageReference:IActiveStageReference, p_viewEntity:IGameEntity):Void
	{
		var l_activeViewReference = _activeReferenceMediator.getActiveViewReference(p_viewEntity);
		
		if (l_activeViewReference == null)
		{
			Console.warn("This view object [" + p_viewEntity.getState('name') + "] is not bound to the Active Stage. Ignoring Remove View...");
			//in this case, the newly created viewReference pointer won't be held anywhere and the viewRererence object will be garbage collected :/
		}
		else
		{
			//Btw, we handle removing the view, but we leave scene and camera alone..
			//because it may still be used elsewhere.. but figure out how to easily handle scene/camera removal too.. someplace..
			
			p_stageReference.removeView(l_activeViewReference);
			_activeReferenceMediator.viewReferenceManager.destroy(l_activeViewReference);
		}
	}
	
	private function _removeStageArea(p_stageReference:IActiveStageReference, p_stageAreaEntity:IGameEntity):Void
	{
		var l_activeStageAreaReference = _activeReferenceMediator.getActiveStageAreaReference(p_stageAreaEntity);
		
		if (l_activeStageAreaReference == null)
		{
			Console.warn("This stageArea object [" + p_stageAreaEntity.getState('name') + "] is not bound to the Active Stage. Ignoring Remove StageArea...");
			//in this case, the newly created stageAreaReference pointer won't be held anywhere and the stageAreaReference object will be garbage collected :/
		}
		else
		{
			p_stageReference.removeStageArea(l_activeStageAreaReference);
			//_activeReferenceMediator.stageAreaReferenceManager.destroy(p_stageAreaReference); //add me
		}
	}
}