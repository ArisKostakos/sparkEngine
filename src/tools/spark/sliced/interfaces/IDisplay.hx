/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, August 2013
 */

package tools.spark.sliced.interfaces;
import tools.spark.sliced.services.std.display.active_displayentity_references.interfaces.IActiveSpaceReference;
import tools.spark.sliced.services.std.display.active_displayentity_references.interfaces.IActiveStageReference;
import tools.spark.sliced.services.std.display.active_displayentity_references.interfaces.IActiveViewReference;
import tools.spark.sliced.services.std.display.renderers.interfaces.IPlatformSpecificRenderer;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;



/**
 * ...
 * @author Aris Kostakos
 */
interface IDisplay extends IService
{	
	var projectActiveSpaceReference( default, null ):IActiveSpaceReference;
	var platformRendererSet( default, null ):Array<IPlatformSpecificRenderer>;
	
	function setActiveSpace(p_spaceEntity:IGameEntity):Bool;
	function addDisplayObjectChild(p_gameEntityParent:IGameEntity, p_gameEntityChild:IGameEntity):Void;
	function updateDisplayObjectState(p_gameEntity:IGameEntity, p_state:String):Void;
	function updateDisplayObjectFormState(p_gameEntity:IGameEntity, p_state:String):Void;
	
	
	function update():Void;
	
	function log(message:String):Void;
	function info(message:String):Void;
	function debug(message:String):Void;
	function warn(message:String):Void;
	function error(message:String):Void;
}