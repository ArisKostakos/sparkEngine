/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, October 2013
 */

package org.gamepl.coreservices.services.std.display.interfaces;


/**
 * ...
 * @author Aris Kostakos
 */
interface IObject
{
	var objectSet( default, null ):Array<IObject>;
	var modifiedLastUpdate:Bool;
	
	function addObject(object:IObject):Void;
	function removeObject(object:IObject):Void;
}