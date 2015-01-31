/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, January 2015
 */

package tools.spark.framework.space2_5D.layout.core;
import tools.spark.framework.layout.containers.Group;
import tools.spark.framework.space2_5D.layout.interfaces.ILayoutable;

/**
 * ...
 * @author Aris Kostakos
 */
class StageArea implements ILayoutable
{
	public var group( default, null ):Group;
	public var children( default, null ):ILayoutable;
	
	public function new() 
	{
		_init();
	}
	
	inline private function _init():Void
	{
		
	}
	
}