/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, December 2014
 */

package tools.spark.sliced.services.std.input.devices.interfaces;
import tools.spark.sliced.services.std.logic.gde.interfaces.EEventType;

/**
 * @author Aris Kostakos
 */

interface IInputDevice 
{
  function update():Void;
  function registerTrigger(p_eventType:EEventType, p_eventFilter:Dynamic):Void;
}