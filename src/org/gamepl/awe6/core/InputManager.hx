/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, September 2013
 */

 package org.gamepl.awe6.core;

/**
 * ...
 * @author Aris Kostakos
 */
class InputManager extends awe6.core.InputManager
{
	override private function _init():Void 
	{
		super._init();
		_inputKeyboard.dispose();
		keyboard = _inputKeyboard = new InputKeyboard( _kernel );
	}
}