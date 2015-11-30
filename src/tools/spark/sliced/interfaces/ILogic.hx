/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, August 2013
 */

package tools.spark.sliced.interfaces;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameFactory;
import tools.spark.sliced.services.std.logic.interpreter.interfaces.IInterpreter;
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
	function startAction(entity:IGameEntity, actionId:String):Bool;
	function update():Void;
	function createAndRun(p_gameEntityUrl:String):Void;
	function createAndPause(p_gameEntityUrl:String):Void;
	
	function getEntityByName(p_stateName:String):IGameEntity;
	function getAllEntitiesByName(p_stateName:String):Array<IGameEntity>;
	function registerEntityByName(p_entity:IGameEntity):Void;
	
	//Helper Functions
	function replace(p_source:String, p_regex:String, p_regexParameters:String, p_replaceWith:String):String;
	function getDt():Float;
	function reflectField(p_object: Dynamic, p_field:String):Dynamic;
	function reflectFieldOfField(p_object: Dynamic, p_field:String, p_field2:String):Dynamic;
	function xmlToString(p_object:Dynamic):String;
	function xml_createElement(p_xmlNode:String, ?p_pcdataChild:String):Xml;
	
	function createInterpreters():Void;
}