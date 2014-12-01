/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, November 2014
 */

package tools.spark.framework.space2_5D.core;

import tools.spark.framework.space2_5D.interfaces.ICamera2_5D;

/**
 * ...
 * @author Aris Kostakos
 */
class Camera2_5D extends AObject2_5D implements ICamera2_5D
{
	public var name( default, default ):String;
	
	public function new() 
	{
		super();
		
	}
	
}