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
interface IGameForm extends IGameBase
{
	var gameStateSet( default, null ):Map<String,IGameState>;
	var gameSpace( default, default ):IGameSpace;
	//contains Mesh(es), or nothing at all?
	
	
	function addState(gameState:IGameState):Void;
	
	// Set/Get State Value
	function getState(p_stateId:String):Dynamic;
	function setState(p_stateId:String, p_value:Dynamic):Dynamic;
}