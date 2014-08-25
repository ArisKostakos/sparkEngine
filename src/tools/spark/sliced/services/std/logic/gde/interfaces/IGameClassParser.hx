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
interface IGameClassParser
{
	function getGameNode(p_expectedNodeType:EGameType, ?p_gameClassName:String, ?p_gameClassNode:Xml):Xml;
	function parseGameNode(p_gameNode:Xml):Bool;
	function instantiateEntity(p_gameNode:Xml):IGameEntity;
	function instantiateForm(p_gameNode:Xml):IGameForm;
	function instantiateSpace(p_gameNode:Xml):IGameSpace;
	function instantiateState(p_gameNode:Xml):IGameState;
	function instantiateAction(p_gameNode:Xml):IGameAction;
	function instantiateTrigger(p_gameNode:Xml):IGameTrigger;
}