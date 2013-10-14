/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, August 2013
 */

package org.gamepl.coreservices.interfaces;
import org.gamepl.coreservices.services.std.logic.gde.interfaces.IGameTrigger;
import org.gamepl.coreservices.services.std.logic.gde.interfaces.EEventType;

/**
 * ...
 * @author Aris Kostakos
 */
interface IEvent extends IService
{
	function update():Void;
	function addTrigger(p_gameTrigger:IGameTrigger):Void;
	function raiseEvent(p_eventType:EEventType, ?p_eventFilter:Dynamic):Void;
}