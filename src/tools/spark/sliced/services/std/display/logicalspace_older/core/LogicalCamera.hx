/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, November 2013
 */

package tools.spark.sliced.services.std.display.logicalspace.core;

import tools.spark.sliced.services.std.display.logicalspace.interfaces.ILogicalCamera;

/**
 * ...
 * @author Aris Kostakos
 */
class LogicalCamera extends ALogicalPositionable implements ILogicalCamera
{
	public var fieldOfView( default, default ):Int;
	
	public function new() 
	{
		super();
	}
}