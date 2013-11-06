/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, November 2013
 */

package co.gamep.sliced.services.std.display.logicalspace.core;

import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalCamera;
import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalScene;
import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalView;

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
	
	public function new() 
	{
		super();
		
		_init();
	}
	
	inline private function _init():Void
	{
		
	}
}