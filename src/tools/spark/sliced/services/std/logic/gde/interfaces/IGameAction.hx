/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, August 2013
 */

package tools.spark.sliced.services.std.logic.gde.interfaces;

/**
 * ...
 * @author Aris Kostakos
 */
interface IGameAction extends IGameBase
{
	var id( default, default ):String;
	var gameStateSet( default, null ):Map<String,IGameState>;
	var concurrency( default, default ):EConcurrencyType;
	var scriptSet( default, null ):Array<Int>;

	//var targetEntity( default, null ):IGameEntity;
	//var targetSet( default, null ):Map<String,IGameEntity>;
	
	//var the metadata stuff(the state modifications for the GOAP)
	
	
	
	//uses IGameState   (through the IGameEntity references)
	
	
	function addState(gameState:IGameState):Void;
	function doPass():Void;
	
	// Set/Get State Value
	function getState(p_stateId:String):Dynamic;
	function setState(p_stateId:String, p_value:Dynamic):Dynamic;
	
	function clone(?p_parentEntity:IGameEntity):IGameAction;
}