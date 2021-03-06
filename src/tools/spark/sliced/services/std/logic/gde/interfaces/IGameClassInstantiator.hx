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
interface IGameClassInstantiator
{
	function instantiateEntity(p_gameNode:Xml, ?p_parentEntity:IGameEntity):IGameEntity;
	function instantiateForm(p_gameNode:Xml, ?p_parentEntity:IGameEntity):IGameForm;
	function instantiateSpace(p_gameNode:Xml, ?p_parentEntity:IGameEntity):IGameSpace;
	function instantiateState(p_gameNode:Xml, ?p_parentEntity:IGameEntity):IGameState;
	function instantiateAction(p_gameNode:Xml, ?p_parentEntity:IGameEntity):IGameAction;
	function instantiateTrigger(p_gameNode:Xml, ?p_parentEntity:IGameEntity):IGameTrigger;
}
