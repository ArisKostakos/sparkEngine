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
	var mesh( default, default ):Dynamic;  //this should be an array, or split to meshUrl2d, meshUrl3d at least
	var meshUrl( default, default ):String;  //this should be an array, or split to meshUrl2d, meshUrl3d at least
	
	var posX( default, default ):Int;
	var posY( default, default ):Int;
	
	var objectSet( default, null ):Array<IObject>;
	var modifiedLastUpdate( default, default ):Bool;
	
	function addObject(object:IObject):Void;
	function removeObject(object:IObject):Void;
}