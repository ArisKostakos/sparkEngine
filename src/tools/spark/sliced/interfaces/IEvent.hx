/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, August 2013
 */

package tools.spark.sliced.interfaces;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameTrigger;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;
import tools.spark.sliced.services.std.logic.gde.interfaces.EEventType;

/**
 * ...
 * @author Aris Kostakos
 */
interface IEvent extends IService
{
	function update():Void;
	function addTrigger(p_gameTrigger:IGameTrigger):Void;
	function raiseEvent(p_eventType:EEventType, ?p_eventTarget:IGameEntity, ?p_eventParameter:Dynamic):Void;
}