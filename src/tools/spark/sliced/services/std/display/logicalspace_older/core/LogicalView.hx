/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, November 2013
 */

package tools.spark.sliced.services.std.display.logicalspace.core;

import tools.spark.sliced.services.std.display.logicalspace.interfaces.ILogicalCamera;
import tools.spark.sliced.services.std.display.logicalspace.interfaces.ILogicalScene;
import tools.spark.sliced.services.std.display.logicalspace.interfaces.ILogicalView;

/**
 * ...
 * @author Aris Kostakos
 */
class LogicalView extends ALogicalComponent implements ILogicalView
{
	public var logicalScene( default, default ):ILogicalScene;
	public var logicalCamera( default, default ):ILogicalCamera;
	public var x( default, default ):Int;
	public var y( default, default ):Int;
	public var width( default, default ):Int;
	public var height( default, default ):Int;
	public var zIndex( default, default ):Int;
	public var requests3DEngine( default, default ):Bool;
	
	public function new() 
	{
		super();
	}
}