/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, August 2014
 */

package tools.spark.sliced.services.std.display.active_displayentity_references.core;

import tools.spark.sliced.services.std.display.active_displayentity_references.interfaces.IActiveStageReference;
import tools.spark.sliced.services.std.display.active_displayentity_references.interfaces.IActiveViewReference;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;
import tools.spark.framework.layout.containers.Group;
import tools.spark.framework.layout.managers.LayoutManager;
import tools.spark.framework.space2_5D.layout.core.StageArea;

/**
 * ...
 * @author Aris Kostakos
 */
class ActiveStageReference implements IActiveStageReference
{
	public var activeViewReferences (default, null ):Array<IActiveViewReference>;
	
	//a map of stageAraReferences with their names and such..? and no fucking nesting
	//yes! why.. cause if we nest shit inside stage, validating if the object is actually an ACTIVE reference
	//is gonna be a thriller...
	
	//so... a stage can have kids that are either...  views or StageAreas
	//a stage area cannot have children... it's just an information block that says things.. and has a name too
	//a view if it has a stageArea option, that will be its parent on the layout tree..
	//otherwise it's parent is...? a stageArea again... the default full screen one
	//do we need an active reference for it...????? for consistency maybe? hmfhmfhmfhmfm
	//yes.. and why not make changes to it too if we want to.. right?
	//ehmm...
	//right.. i think...
	//this stage object should and will have width,height.. and that's it.. and that's fine..
	//and will also auto create a stage area that will take full size.
	//but we should be able to customiii? eh,, BUT
	//the main stagearea has the layout of the thing that caannnoot be moved.. so?
	//how about, main stageArea cannot. but noone is assigned to that..
	//defaults all children to mainStageArea.
	//so.. in any case.. mainrootstagearea is fucking immovable.. and always full screen.. deal with it
	//if i want things inside something in part of screen, create your stageArea gmls
	//otherwise... its static.. good for performance im sure
	//implement..
	
	public var stageAreaRoot( default, default ):StageArea;
	
	
	public var stageEntity( default, null ):IGameEntity;
	public var layoutRoot( default, default ):Group;
	public var layoutManager( default, null ):LayoutManager;
	
	public function new(p_stageEntity:IGameEntity) 
	{
		stageEntity = p_stageEntity;
		
		_init();
	}
	
	inline private function _init():Void
	{
		activeViewReferences = new Array<IActiveViewReference>();
		
		//the idea is, if this reference gets disposed so are all the layout references with it, even the manager
		layoutManager = new LayoutManager();
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