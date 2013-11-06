/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, November 2013
 */

package co.gamep.sliced.services.std.display.logicalspace.core;

import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalCamera;

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
		
		_init();
	}
	
	inline private function _init():Void
	{
		
	}
}