/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, August 2014
 */

 package tools.spark.sliced.services.std.display.managers.interfaces;
import tools.spark.sliced.interfaces.IDisplay;
import tools.spark.sliced.services.std.display.active_displayentity_references.interfaces.IActiveSpaceReference;
import tools.spark.sliced.services.std.display.active_displayentity_references.interfaces.IActiveStageReference;
import tools.spark.sliced.services.std.display.active_displayentity_references.interfaces.IActiveViewReference;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;
	
/**
 * @author Aris Kostakos
 */

interface IActiveReferenceMediator 
{
	var display( default, null ):IDisplay;
	var spaceReferenceManager( default, null ):IDisplayObjectManager;
	var stageReferenceManager( default, null ):IDisplayObjectManager;
	var viewReferenceManager( default, null ):IDisplayObjectManager;
	
  	function createStageReference(p_stageEntity:IGameEntity):IActiveStageReference;
	function createViewReference(p_viewEntity:IGameEntity):IActiveViewReference;
	
	function getActiveSpaceReference(p_spaceEntity:IGameEntity):IActiveSpaceReference;
	function getActiveStageReference(p_stageEntity:IGameEntity):IActiveStageReference;
	function getActiveViewReference(p_viewEntity:IGameEntity):IActiveViewReference;
}