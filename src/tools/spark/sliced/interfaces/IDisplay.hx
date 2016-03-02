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
	var platformRendererSet( default, null ):Map<String, IPlatformSpecificRenderer>;
	
	function setActiveSpace(p_spaceEntity:IGameEntity):Bool;
	function addDisplayObjectChild(p_gameEntityParent:IGameEntity, p_gameEntityChild:IGameEntity):Void;
	function insertDisplayObjectChild(p_gameEntityParent:IGameEntity, p_gameEntityChild:IGameEntity, p_index:Int):Void;
	function removeDisplayObjectChild(p_gameEntityParent:IGameEntity, p_gameEntityChild:IGameEntity):Void;
	function updateDisplayObjectState(p_gameEntity:IGameEntity, p_state:String):Void;
	function updateDisplayObjectFormState(p_gameEntity:IGameEntity, p_state:String):Void;
	function getSpace2_5Object(p_gameEntity:IGameEntity, p_bAllRenderers:Bool = false):Dynamic;
	
	function update():Void;
	function invalidateLayout():Void;
	
	function log(message:String, ?args:Array<Dynamic>):Void;
	function warn(message:String, ?args:Array<Dynamic>):Void;
	function error(message:String, ?args:Array<Dynamic>):Void;
	function dl(message:String, ?args:Array<Dynamic>):Void;
	function dw(message:String, ?args:Array<Dynamic>):Void;
	function de(message:String, ?args:Array<Dynamic>):Void;
}