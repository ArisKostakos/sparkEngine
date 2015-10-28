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
interface IGameEntity extends IGameBase
{
	var gameStateSet( default, null ):Map<String,IGameState>;
	var gameForm( default, default ):IGameForm;
	var possibleActionSet( default, null ):Map<String,IGameAction>;
	var currentActionSet( default, null ):Map < String, Array<IGameAction> > ;
	var children ( get, never ):Array<IGameEntity>;
	var uid ( default, null ):Int;
	//uses IGameSpace
	//uses IGameEntity (through IGameSpace)
	
	
	/**
	 * Does a pass on every Current Action inside the entity.
	 * Also iterates the Logical Space and calls doActions()
	 * for each Entity found.
	 */
	function doActions():Void;
	
	function addState(gameState:IGameState):Void;
	function addAction(gameAction:IGameAction):Void;
	
	function getAction(p_actionId:String):IGameAction;
	function forceAction(p_actionId:String):Void;
	
	function startAction(actionId:String):Bool;
	function stopAction(actionId:String):Bool;
	
	// Set/Get State Value
	function getState(p_stateId:String):Dynamic;
	function setState(p_stateId:String, p_value:Dynamic):Dynamic;
	
	function getChildren():Array<IGameEntity>;
}