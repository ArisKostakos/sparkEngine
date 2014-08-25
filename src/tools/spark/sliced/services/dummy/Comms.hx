/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, August 2013
 */

package tools.spark.sliced.services.dummy;

import tools.spark.sliced.interfaces.IComms;
import tools.spark.sliced.core.AService;

/**
 * ...
 * @author Aris Kostakos
 */
class Comms extends AService implements IComms
{
	public function new() 
	{
		super();
		_init();
	}
	
	private function _init():Void
	{
		Console.log("Init Comms Dummy Service...");
	}
	
}