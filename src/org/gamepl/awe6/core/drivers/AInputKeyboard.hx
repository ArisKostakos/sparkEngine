/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, September 2013
 */

 package org.gamepl.awe6.core.drivers;
import org.gamepl.coreservices.core.Game;

/**
 * ...
 * @author Aris Kostakos
 */
class AInputKeyboard extends awe6.core.drivers.AInputKeyboard
{
	override private function _onDown( p_keyCode ):Void
	{
		Game.input.registerKeyEvent(p_keyCode, true);
		
		super._onDown( p_keyCode );
	}
	
	override private function _onUp( p_keyCode:Int ):Void
	{
		Game.input.registerKeyEvent(p_keyCode, false);
		
		super._onUp( p_keyCode );
	}
}