/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, August 2013
 */

package tools.spark.sliced.interfaces;
import flambe.input.Key;
import tools.spark.sliced.services.std.input.devices.core.KeyboardDevice;
import tools.spark.sliced.services.std.input.devices.core.PointerDevice;

/**
 * ...
 * @author Aris Kostakos
 */
interface IInput extends IService
{
	function update():Void;
	
	var keyboard( default, null ):KeyboardDevice;
	var pointer( default, null ):PointerDevice;
}