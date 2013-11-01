/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, August 2013
 */

package co.gamep.sliced.services.std.logic.gde.interfaces;

/**
 * ...
 * @author Aris Kostakos
 */
interface IGameEntity extends IGameBase
{
	var gameStateSet( default, null ):Map<String,IGameState>;
	var gameForm( default, default ):IGameForm;
	var possibleActionSet( default, null ):Map<String,IGameAction>;
	var currentActionSet( default, null ):Map<String,Array<IGameAction>>;
	
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
	
	function startAction(actionId:String):Bool;
	function stopAction(actionId:String):Bool;
}