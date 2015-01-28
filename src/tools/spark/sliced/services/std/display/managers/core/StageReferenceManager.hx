/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, October 2014
 */

 package tools.spark.sliced.services.std.display.managers.core;
import tools.spark.framework.layout.containers.Group;
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
		
		updateState(p_object, p_gameEntity, 'test');
		
		
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
		var l_activeStageReference:IActiveStageReference = cast(p_object, IActiveStageReference);
		
		switch (p_state)
		{
			case 'test':
				_createStageLayOutThing(l_activeStageReference, p_gameEntity);
		}
		
	}
	
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
	}
	
	private function _layoutManagerMeasure(p_Group:Group):Void
	{
		for (f_child in p_Group.children)
		{
			_layoutManagerMeasure(f_child);
		}
		
		//down here cause it's bottom-up
		//only measure if explicit not set?
		p_Group.measure();
	}
	
	private function _layoutManagerUpdateDisplayList(p_Group:Group):Void
	{
		//up here cause it's top to bottom
		p_Group.updateDisplayList(p_Group.preferredWidth, p_Group.preferredHeight);
		
		for (f_child in p_Group.children)
		{
			_layoutManagerUpdateDisplayList(f_child);
		}
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