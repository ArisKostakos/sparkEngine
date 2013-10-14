/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, September 2013
 */

package org.gamepl.coreservices.services.std.display.renderers.interfaces;
import org.gamepl.coreservices.services.std.display.interfaces.IScene;
import org.gamepl.coreservices.services.std.display.interfaces.IObject;

/**
 * ...
 * @author Aris Kostakos
 */
interface IRenderer
{
	var sceneSet( default, null ):Array<IScene>;
	var scenePointerSet( default, null ):Map<IScene,Dynamic>;
	var objectPointerSet( default, null ):Map<IObject,Dynamic>;
	
	function addScene(scene:IScene, index:Int):Void;
	function removeScene(scene:IScene):Void;
	function update();
}