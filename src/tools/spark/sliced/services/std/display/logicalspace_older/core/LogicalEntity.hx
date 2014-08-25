/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, November 2013
 */

package tools.spark.sliced.services.std.display.logicalspace.core;

import tools.spark.sliced.services.std.display.logicalspace.interfaces.ILogicalEntity;

/**
 * ...
 * @author Aris Kostakos
 */
class LogicalEntity extends ALogicalPositionable implements ILogicalEntity
{
	public var logicalEntitySet( default, null ):Array<ILogicalEntity>;
	
	public function new() 
	{
		super();
		
		_init();
	}
	
	inline private function _init():Void
	{
		logicalEntitySet = new Array<ILogicalEntity>();
	}
}