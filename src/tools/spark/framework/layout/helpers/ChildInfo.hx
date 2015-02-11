/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, February 2015
 */

package tools.spark.framework.layout.helpers ;
import tools.spark.framework.layout.containers.Group;

/**
 * ...
 * @author Aris Kostakos
 */
class ChildInfo
{
	public var size( default, default) :Float = 0;
	public var preferred( default, default) :Float = 0;
	public var flex( default, default) :Float = 0;
	public var percent( default, default) :Float;
	public var min( default, default) :Float;
	public var max( default, default) :Float;
	public var width( default, default) :Float;
	public var height( default, default) :Float;
	public var layoutElement( default, default) :Group;
	
	public function new() 
	{
		
	}
	
}