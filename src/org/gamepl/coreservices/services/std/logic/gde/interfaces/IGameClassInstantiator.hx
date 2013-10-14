/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, August 2013
 */

package org.gamepl.coreservices.services.std.logic.gde.interfaces;

/**
 * ...
 * @author Aris Kostakos
 */
interface IGameClassInstantiator
{
	function instantiateEntity(p_gameNode:Xml):IGameEntity;
	function instantiateForm(p_gameNode:Xml):IGameForm;
	function instantiateSpace(p_gameNode:Xml):IGameSpace;
	function instantiateState(p_gameNode:Xml):IGameState;
	function instantiateAction(p_gameNode:Xml):IGameAction;
	function instantiateTrigger(p_gameNode:Xml):IGameTrigger;
}
