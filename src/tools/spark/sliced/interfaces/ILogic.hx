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
	//getAllEntitiesByName(p_stateName:String):Array<IGameEntity>;
	function registerEntityByName(p_entity:IGameEntity):Void;
}