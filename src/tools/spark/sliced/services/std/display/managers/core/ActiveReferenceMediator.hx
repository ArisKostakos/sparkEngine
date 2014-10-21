/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, August 2014
 */

 package tools.spark.sliced.services.std.display.managers.core;

import tools.spark.sliced.interfaces.IDisplay;
import tools.spark.sliced.services.std.display.active_displayentity_references.interfaces.IActiveSpaceReference;
import tools.spark.sliced.services.std.display.active_displayentity_references.interfaces.IActiveStageReference;
import tools.spark.sliced.services.std.display.active_displayentity_references.interfaces.IActiveViewReference;
import tools.spark.sliced.services.std.display.managers.interfaces.IActiveReferenceMediator;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;
import tools.spark.sliced.services.std.display.active_displayentity_references.core.ActiveSpaceReference;
import tools.spark.sliced.services.std.display.active_displayentity_references.core.ActiveStageReference;
import tools.spark.sliced.services.std.display.active_displayentity_references.core.ActiveViewReference;
import tools.spark.sliced.services.std.display.managers.interfaces.IDisplayObjectManager;

/**
 * ...
 * @author Aris Kostakos
 */
class ActiveReferenceMediator implements IActiveReferenceMediator
{
	public var display( default, null ):IDisplay;
	public var spaceReferenceManager( default, null ):IDisplayObjectManager;
	public var stageReferenceManager( default, null ):IDisplayObjectManager;
	public var viewReferenceManager( default, null ):IDisplayObjectManager;
	
	public function new(p_display:IDisplay) 
	{
		display = p_display;
		
		_init();
	}
	
	inline private function _init():Void
	{
		//Display Entity Reference Managers
		spaceReferenceManager = new SpaceReferenceManager(this);
		stageReferenceManager = new StageReferenceManager(this);
		viewReferenceManager = new ViewReferenceManager(this);
	}
	
	public function createStageReference(p_stageEntity:IGameEntity):IActiveStageReference
	{
		return cast(stageReferenceManager.create(p_stageEntity), ActiveStageReference);
	}
	
	public function createViewReference(p_viewEntity:IGameEntity):IActiveViewReference
	{
		return cast(viewReferenceManager.create(p_viewEntity), ActiveViewReference);
	}
	
	public function getActiveSpaceReference(p_spaceEntity:IGameEntity):IActiveSpaceReference
	{
		if (display.projectActiveSpaceReference == null) return null;
		
		if (p_spaceEntity == display.projectActiveSpaceReference.spaceEntity)
			return display.projectActiveSpaceReference;
		else
			return null;
	}
	
	public function getActiveStageReference(p_stageEntity:IGameEntity):IActiveStageReference
	{
		if (display.projectActiveSpaceReference == null) return null;
		else if (display.projectActiveSpaceReference.activeStageReference == null) return null;
		
		if (p_stageEntity == display.projectActiveSpaceReference.activeStageReference.stageEntity)
			return display.projectActiveSpaceReference.activeStageReference;
		else
			return null;
	}
	
	public function getActiveViewReference(p_viewEntity:IGameEntity):IActiveViewReference
	{
		if (display.projectActiveSpaceReference == null) return null;
		else if (display.projectActiveSpaceReference.activeStageReference == null) return null;
		
		for (f_activeViewReference in display.projectActiveSpaceReference.activeStageReference.activeViewReferences)
		{
			if (f_activeViewReference.viewEntity == p_viewEntity)
				return f_activeViewReference;
		}
		
		return null;
	}
}