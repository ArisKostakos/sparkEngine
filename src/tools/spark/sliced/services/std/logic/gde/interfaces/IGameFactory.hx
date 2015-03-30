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
interface IGameFactory
{
	function createGameEntity(?p_gameClassName:String, ?p_gameClassNode:Xml):IGameEntity;
	function createGameEntityExtended(p_gameClassName:String, p_extendGameClassName:String):IGameEntity;

	/*
	function createGameForm(p_gameClassName:String):IGameForm;
	function createGameSpace(p_gameClassName:String):IGameSpace;
	function createGameState(p_gameClassName:String):IGameState;
	function createGameAction(p_gameClassName:String):IGameAction;
	*/
}