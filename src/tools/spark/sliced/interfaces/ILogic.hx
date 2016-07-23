/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, August 2013
 */

package tools.spark.sliced.interfaces;
import flambe.subsystem.StorageSystem;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameFactory;
import tools.spark.sliced.services.std.logic.interpreter.interfaces.IInterpreter;
import tools.spark.sliced.services.std.logic.level_manager.core.LevelManager;
/**
 * ...
 * @author Aris Kostakos
 */
interface ILogic extends IService
{
	var rootGameEntitiesRunning( default, null ):Map<String, IGameEntity>;
	var rootGameEntitiesPaused( default, null ):Map<String, IGameEntity>;
	
	var scriptInterpreter( default, null ):IInterpreter;
	var gmlInterpreter( default, null ):IInterpreter;
	var gameFactory( default, null ):IGameFactory;
	var levelManager( default, null ):LevelManager;
	var pauseDt( default, default ):Float;
	var storage( get, null ):StorageSystem;
	
	function startAction(entity:IGameEntity, actionId:String):Bool;
	function update():Void;
	function createAndRun(p_gameEntityUrl:String):Void;
	function createAndPause(p_gameEntityUrl:String):Void;
	function create(p_gameEntityUrl:String, p_dontCache:Bool=false):IGameEntity;
	
	function getEntityByName(p_stateName:String):IGameEntity;
	function getAllEntitiesByName(p_stateName:String):Array<IGameEntity>;
	function registerEntityByName(p_entity:IGameEntity):Void;
	function queryGameEntity(p_gameEntity:IGameEntity, p_query:String, ?queryArgument:Dynamic, p_bAllRenderers:Bool = false, p_bAllInstances:Bool = false):Dynamic;
	
	//Helper Functions
	function replace(p_source:String, p_regex:String, p_regexParameters:String, p_replaceWith:String):String;
	function getDt():Float;
	function reflectField(p_object: Dynamic, p_field:String):Dynamic;
	function reflectFieldOfField(p_object: Dynamic, p_field:String, p_field2:String):Dynamic;
	function xmlToString(p_object:Dynamic):String;
	function xml_createElement(p_xmlNode:String, ?p_pcdataChild:String):Xml;
	
	function createInterpreters():Void;
}