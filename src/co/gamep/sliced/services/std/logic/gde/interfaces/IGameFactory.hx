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
interface IGameFactory
{
	function createGameEntity(?p_gameClassName:String, ?p_gameClassNode:Xml):IGameEntity;
	/*
	function createGameForm(p_gameClassName:String):IGameForm;
	function createGameSpace(p_gameClassName:String):IGameSpace;
	function createGameState(p_gameClassName:String):IGameState;
	function createGameAction(p_gameClassName:String):IGameAction;
	*/
}