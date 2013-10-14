/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, July 2013
 */

package org.gamepl.awe6.core;
import awe6.core.ASession;

/**
 * ...
 * @author Aris Kostakos
 */

class Session extends ASession 
{
	/* example:
	public var name:String;
	public var highScore:Int;
	public var isWin:Bool; // temporary
	*/

	override private function _init() 
	{
		_version = 1; // incremement this every time you make a structural change to the session (it will force a reset on all users' systems)
		super._init();
	}

	override private function _getter():Void 
	{
		super._getter();
		/* example:
		name = _data.name;
		highScore = _data.highScore;
		*/
	}

	override private function _setter():Void 
	{
		super._setter();
		/* example:
		_data.name = name;
		_data.highScore = highScore;
		*/
	}

	override private function _resetter():Void 
	{
		super._resetter();
		/* example:
		name = "???";
		highScore = 0;
		*/
	}

	override public function getPercentageComplete():Float 
	{
		return 0;
	}

}
