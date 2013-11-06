/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, November 2013
 */

package co.gamep.sliced.services.std.display.logicalspace.core;

import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalEntity;
import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalMesh;

/**
 * ...
 * @author Aris Kostakos
 */
class LogicalMesh extends LogicalEntity implements ILogicalMesh
{
	public function new() 
	{
		super();
		
		_init();
	}
	
	inline private function _init():Void
	{
		
	}
}