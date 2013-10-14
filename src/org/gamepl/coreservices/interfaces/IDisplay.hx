/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, August 2013
 */

package org.gamepl.coreservices.interfaces;
import awe6.core.Context;
import org.gamepl.coreservices.services.std.display.interfaces.IScene;

/**
 * ...
 * @author Aris Kostakos
 */
interface IDisplay extends IService
{
	var sceneSet( default, null ):Array<IScene>;
	
	function createScene(p_rendererType:String, p_posX:Int, p_posY:Int, p_width:Int, p_height:Int):IScene;
	
	
	function log(message:String):Void;
	function info(message:String):Void;
	function debug(message:String):Void;
	function warn(message:String):Void;
	function error(message:String):Void;
}