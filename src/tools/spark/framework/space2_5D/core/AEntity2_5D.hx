/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, November 2014
 */

package tools.spark.framework.space2_5D.core;

import tools.spark.framework.space2_5D.interfaces.IEntity2_5D;
import tools.spark.framework.space2_5D.interfaces.IView2_5D;

/**
 * ...
 * @author Aris Kostakos
 */
class AEntity2_5D extends AObjectContainer2_5D implements IEntity2_5D
{
	public var name( default, default ):String;
	public var spriteUrl( default, default ):String;
	public var modelUrl( default, default ):String;
	
	public function new() 
	{
		super();
		
	}
	
	public function createInstance (p_view2_5D:IView2_5D):Dynamic
	{
		//override me!!
		return null;
	}
	
	public function updateInstances(?updateState:String):Void
	{
		//override me!!
	}
}