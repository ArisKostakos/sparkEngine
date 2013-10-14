/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, August 2013
 */

package org.gamepl.coreservices.interfaces;
import awe6.interfaces.EKey;

/**
 * ...
 * @author Aris Kostakos
 */
interface IInput extends IService
{
	function update():Void;
	function isKeyPressed( type:EKey ):Bool;
	function isKeyReleased( type:EKey ):Bool;
	function registerKeyEvent(p_keyCode:Int, p_keyDown: Bool):Void;
}