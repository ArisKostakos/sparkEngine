/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, November 2013
 */

package co.gamep.sliced.services.std.display.logicalspace.core;
import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalComponent;

/**
 * ...
 * @author Aris Kostakos
 */
@:keepSub class ALogicalComponent implements ILogicalComponent
{
	public var name( default, default ):String;
	public var parent( default, default ):ILogicalComponent;
	
	//Abstract class, private constructor
	private function new() 
	{
		
	}
}