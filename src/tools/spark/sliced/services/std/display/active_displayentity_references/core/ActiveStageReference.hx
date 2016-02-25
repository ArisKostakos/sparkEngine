/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, August 2014
 */

package tools.spark.sliced.services.std.display.active_displayentity_references.core;

import tools.spark.sliced.services.std.display.active_displayentity_references.interfaces.IActiveStageReference;
import tools.spark.sliced.services.std.display.active_displayentity_references.interfaces.IActiveStageAreaReference;
import tools.spark.sliced.services.std.display.active_displayentity_references.interfaces.IActiveViewReference;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;
import tools.spark.framework.layout.containers.Group;
import tools.spark.framework.layout.managers.LayoutManager;

/**
 * ...
 * @author Aris Kostakos
 */
class ActiveStageReference implements IActiveStageReference
{
	public var activeViewReferences (default, null ):Array<IActiveViewReference>;
	public var activeStageAreaReferences (default, null ):Array<IActiveStageAreaReference>;
	public var stageEntity( default, null ):IGameEntity;
	public var layoutRoot( default, null ):Group;
	public var layoutManager( default, null ):LayoutManager;
	
	public function new(p_stageEntity:IGameEntity) 
	{
		stageEntity = p_stageEntity;
		
		_init();
	}
	
	inline private function _init():Void
	{
		activeViewReferences = new Array<IActiveViewReference>();
		activeStageAreaReferences = new Array<IActiveStageAreaReference>();
		
		//A brand new root Group is created..
		layoutRoot = new Group(stageEntity, "Stage", this);
		
		//the idea is, the stageEntity might give instructions for a specific layout manager, although right now we just have the one
		//also since we give the manager a rootElement on constructor, discard the whole manager if we change activeStage
		layoutManager = new LayoutManager(layoutRoot);
		
		//not sure if I should put this here... it's the flambe's native resize event..
		// System.stage.resize is a Signal, listen to it.
		flambe.System.stage.resize.connect(_onResize);
	}

	private function _onResize()
	{
		//this is a new low of sloppiness.. fix plzz... soon
		#if html
			layoutRoot.explicitWidth = js.Browser.window.innerWidth;
			layoutRoot.explicitHeight = js.Browser.window.innerHeight;
		#else
			layoutRoot.explicitWidth = flambe.System.stage.width;
			layoutRoot.explicitHeight = flambe.System.stage.height;
		#end

		//Console.error("*****WIDTH******: " + layoutRoot.explicitWidth);
		//Console.error("*****HEIGHT******: " + layoutRoot.explicitHeight);
		layoutManager.validated = false;
	}
	
	public function logViewReferences():Void
	{
		Console.info("Printing Active Views");
		Console.info("---------------------");
		for (activeViewReference in activeViewReferences)
		{
			Console.info("View " + activeViewReference.viewEntity.getState('name') + " Index: " + activeViewReference.viewEntity.getState('zIndex'));
		}
	}
	
	public function addView(p_viewReference:IActiveViewReference):Void
	{
		//Push the new View Reference
		activeViewReferences.push(p_viewReference);
		
		//Reorder View References
		activeViewReferences.sort(_orderViews);
		
		//update layout tree as well
		_addLayoutElement(p_viewReference.layoutElement);
	}
	
	public function addStageArea(p_stageAreaReference:IActiveStageAreaReference):Void
	{
		//Push the new StageArea Reference
		activeStageAreaReferences.push(p_stageAreaReference);
		
		//update layout tree as well
		_addLayoutElement(p_stageAreaReference.layoutElement);
	}
	
	public function removeView(p_viewReference:IActiveViewReference):Void
	{
		//Push the new View Reference
		activeViewReferences.remove(p_viewReference);
		
		//update layout tree as well
		_removeLayoutElement(p_viewReference.layoutElement);
	}
	
	public function removeStageArea(p_stageAreaReference:IActiveStageAreaReference):Void
	{
		//Push the new StageArea Reference
		activeStageAreaReferences.remove(p_stageAreaReference);
		
		//update layout tree as well
		_removeLayoutElement(p_stageAreaReference.layoutElement);
	}
	
	private function _addLayoutElement(p_layoutElement:Group):Void
	{
		if (p_layoutElement.layoutableEntity.getState('parent') == "Implicit")
		{
			layoutRoot.children.push(p_layoutElement);
		}
		else
		{
			for (activeStageAreaReference in activeStageAreaReferences)
			{
				if (activeStageAreaReference.stageAreaEntity.getState('name') == p_layoutElement.layoutableEntity.getState('parent'))
				{
					activeStageAreaReference.layoutElement.children.push(p_layoutElement);
					break;
				}
			}
		}
	}
	
	private function _removeLayoutElement(p_layoutElement:Group):Void
	{
		if (p_layoutElement.layoutableEntity.getState('parent') == "Implicit")
		{
			layoutRoot.children.remove(p_layoutElement);
		}
		else
		{
			for (activeStageAreaReference in activeStageAreaReferences)
			{
				if (activeStageAreaReference.stageAreaEntity.getState('name') == p_layoutElement.layoutableEntity.getState('parent'))
				{
					activeStageAreaReference.layoutElement.children.remove(p_layoutElement);
					break;
				}
			}
		}
	}
	
	private function _orderViews(viewReference1:IActiveViewReference, viewReference2:IActiveViewReference):Int
	{
		if (viewReference1.viewEntity.getState('zIndex')>viewReference2.viewEntity.getState('zIndex')) return 1;
		else if (viewReference1.viewEntity.getState('zIndex') < viewReference2.viewEntity.getState('zIndex')) return -1;
		else return 0;
	}
}