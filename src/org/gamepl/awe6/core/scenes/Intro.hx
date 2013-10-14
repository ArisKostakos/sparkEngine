/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, July 2013
 */

 package org.gamepl.awe6.core.scenes;

/**
 * ...
 * @author Aris Kostakos
 */

class Intro extends AScene 
{
	override private function _init():Void 
	{
		super._init();
		// extend / addentities
		_title.text = "INTRO";
	}

	override private function _updater( p_deltaTime:Int = 0 ):Void 
	{
		super._updater( p_deltaTime );
		// example:
		if ( _kernel.inputs.keyboard.getIsKeyRelease( _kernel.factory.keyNext ) ) 
		{
			_kernel.scenes.next();
		}
	}
}
