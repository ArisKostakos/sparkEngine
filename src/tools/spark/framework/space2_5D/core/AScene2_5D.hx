/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, November 2014
 */

package tools.spark.framework.space2_5D.core;

import tools.spark.framework.space2_5D.interfaces.IEntity2_5D;
import tools.spark.framework.space2_5D.interfaces.IScene2_5D;

/**
 * ...
 * @author Aris Kostakos
 */
class AScene2_5D implements IScene2_5D
{
	public var name( default, default ):String;
	public var children( default, null ):Array<IEntity2_5D>;
	
	public function new() 
	{
		children = new Array<IEntity2_5D>();
	}
	
	public function addChild( p_entity2_5D:IEntity2_5D):Void
	{
		children.push(p_entity2_5D);
	}
}