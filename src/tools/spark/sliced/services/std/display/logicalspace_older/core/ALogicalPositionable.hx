/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, November 2013
 */

package tools.spark.sliced.services.std.display.logicalspace.core;

import tools.spark.sliced.services.std.display.logicalspace.interfaces.ILogicalPositionable;

/**
 * ...
 * @author Aris Kostakos
 */
class ALogicalPositionable extends ALogicalComponent implements ILogicalPositionable
{
	public var x( default, default ):Int;
	public var y( default, default ):Int;
	public var z( default, default ):Int;
	public var yaw( default, default ):Int;
	public var pitch( default, default ):Int;
	public var roll( default, default ):Int;
	
	//Abstract class, private constructor
	private function new() 
	{
		super();
	}
}