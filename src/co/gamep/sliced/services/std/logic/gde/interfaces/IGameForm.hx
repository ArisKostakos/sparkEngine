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
}