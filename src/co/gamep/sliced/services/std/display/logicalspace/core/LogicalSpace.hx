/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, November 2013
 */

package co.gamep.sliced.services.std.display.logicalspace.core;

import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalCamera;
import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalScene;
import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalSpace;
import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalStage;

/**
 * ...
 * @author Aris Kostakos
 */
class LogicalSpace extends ALogicalComponent implements ILogicalSpace
{
	public var logicalStage(default, default):ILogicalStage;
	public var logicalSceneSet(default, null):Array<ILogicalScene>;
	public var logicalCameraSet(default, null):Array<ILogicalCamera>;
	
	public function new() 
	{
		super();
		
		_init();
	}
	
	inline private function _init():Void
	{
		logicalSceneSet = new Array<ILogicalScene>();
		logicalCameraSet = new Array<ILogicalCamera>();
	}
}