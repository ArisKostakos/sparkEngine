/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, July 2013
 */

 package org.gamepl.awe6.core;

/**
 * ...
 * @author ...
 */
class Kernel extends awe6.core.Kernel
{

	override private function _init():Void
	{
		super._init();
		_removeProcess( _inputManager );
		inputs = _inputManager = new InputManager( _kernel );
		_addProcess( _inputManager );
	}
}