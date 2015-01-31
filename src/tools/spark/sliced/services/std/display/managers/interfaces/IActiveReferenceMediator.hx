/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, August 2014
 */

 package tools.spark.sliced.services.std.display.managers.interfaces;
import tools.spark.sliced.interfaces.IDisplay;
import tools.spark.sliced.services.std.display.active_displayentity_references.interfaces.IActiveSpaceReference;
import tools.spark.sliced.services.std.display.active_displayentity_references.interfaces.IActiveStageAreaReference;
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
	var stageAreaReferenceManager( default, null ):IDisplayObjectManager;
	
	function createSpaceReference(p_spaceEntity:IGameEntity):IActiveSpaceReference;
  	function createStageReference(p_stageEntity:IGameEntity):IActiveStageReference;
	function createViewReference(p_viewEntity:IGameEntity):IActiveViewReference;
	function createStageAreaReference(p_stageAreaEntity:IGameEntity):IActiveStageAreaReference;
	
	function getActiveSpaceReference(p_spaceEntity:IGameEntity):IActiveSpaceReference;
	function getActiveStageReference(p_stageEntity:IGameEntity):IActiveStageReference;
	function getActiveViewReference(p_viewEntity:IGameEntity):IActiveViewReference;
	function getActiveStageAreaReference(p_stageAreaEntity:IGameEntity):IActiveStageAreaReference;
}