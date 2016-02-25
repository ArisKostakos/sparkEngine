/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, September 2013
 */

package tools.spark.sliced.services.std.input.core;

import tools.spark.sliced.services.std.input.devices.core.KeyboardDevice;
import tools.spark.sliced.services.std.input.devices.core.MouseDevice;
import tools.spark.sliced.services.std.input.devices.core.PointerDevice;
import tools.spark.sliced.interfaces.IInput;
import tools.spark.sliced.core.AService;

/**
 * ...
 * @author Aris Kostakos
 */
class Input extends AService implements IInput
{
	public var keyboard( default, null ):KeyboardDevice;
	public var pointer( default, null ):PointerDevice;
	public var mouse( default, null ):MouseDevice;
	
	public function new() 
	{
		super();
		
		_init();
	}
	
	private function _init():Void
	{
		Console.info("Init Input std Service...");
		
		keyboard = new KeyboardDevice();
		pointer = new PointerDevice();
		mouse = new MouseDevice();
	}
	
	public function update():Void
	{
		keyboard.update();
		pointer.update();
		mouse.update();
	}
}