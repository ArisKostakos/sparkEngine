/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, September 2013
 */

package org.gamepl.coreservices.services.std.display.interfaces;

/**
 * ...
 * @author Aris Kostakos
 */
interface IScene
{
	var objectSet( default, null ):Array<IObject>;
	var modifiedLastUpdate:Bool;
	//camera?
	
	function addObject(object:IObject):Void;
	function removeObject(object:IObject):Void;
}