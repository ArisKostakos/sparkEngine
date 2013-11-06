/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, August 2013
 */

package co.gamep.sliced.interfaces;
import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalSpace;


/**
 * ...
 * @author Aris Kostakos
 */
interface IDisplay extends IService
{
	var logicalSpace( default, default ):ILogicalSpace;

	//var rendererSet( default, null ):Array<IRenderer>;
	
	//function createRenderer(rendererName:String):IRenderer;
	//function createScene():IScene;
	//function createObject():IObject;
	
	//function addRenderer(renderer:IRenderer, index:Int):Void;
	//function removeRenderer(renderer:IRenderer):Void;
	function update():Void;
	
	function log(message:String):Void;
	function info(message:String):Void;
	function debug(message:String):Void;
	function warn(message:String):Void;
	function error(message:String):Void;
}