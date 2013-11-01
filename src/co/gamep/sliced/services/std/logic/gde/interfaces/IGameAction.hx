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
interface IGameAction extends IGameBase
{
	var id( default, default ):String;
	var gameStateSet( default, null ):Map<String,IGameState>;
	var concurrency( default, default ):EConcurrencyType;
	var scriptSet( default, null ):Array<Int>;
	var userEntity( default, default ):IGameEntity;
	
	//var userEntity( default, null ):IGameEntity;
	//var targetEntity( default, null ):IGameEntity;
	//var targetSet( default, null ):Map<String,IGameEntity>;
	
	//var the metadata stuff(the state modifications for the GOAP)
	
	
	
	//uses IGameState   (through the IGameEntity references)
	
	
	function addState(gameState:IGameState):Void;
	function doPass():Void;
}