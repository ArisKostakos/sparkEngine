/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, September 2013
 */

package org.gamepl.coreservices.services.std.display.renderers.core;
import org.gamepl.coreservices.services.std.display.renderers.interfaces.IRenderer;
import org.gamepl.coreservices.services.std.display.interfaces.IScene;
import org.gamepl.coreservices.services.std.display.interfaces.IObject;

/**
 * ...
 * @author Aris Kostakos
 */
class ARenderer implements IRenderer
{
	public var sceneSet( default, null ):Array<IScene>;
	public var scenePointerSet( default, null ):Map<IScene,Dynamic>;
	public var objectPointerSet( default, null ):Map<IObject,Dynamic>;
	
	//private sceneInvalidateFlagSet
	//private objectInvalidateFlagSet
	//@think: maybe more specific invalidate flags are required (z-order changed, an object was deleted, position of object was deleted, etc) or use interrupts
	
	private function new() 
	{
		_init();
	}
	
	private function _init():Void
	{
		Console.log("Init ARenderer...");
		sceneSet = new Array<IScene>();
		scenePointerSet = new Map<IScene,Dynamic>();
		objectPointerSet = new Map<IObject,Dynamic>();
	}
	
	public function addScene(scene:IScene, index:Int):Void
	{
		sceneSet.push(scene);
	}
	public function removeScene(scene:IScene):Void
	{
		sceneSet.remove(scene);
	}
	
	public function update():Void
	{
		for (scene in sceneSet)
		{
			_renderScene(scene);
		}
	}
	
	//Should be overriden
	private function _renderScene(scene:IScene):Void
	{
		for (object in scene.objectSet)
		{
			_renderObject(object);
		}
	}
	
	//Should be overriden
	private function _renderObject(object:IObject):Void
	{
		for (object in object.objectSet)
		{
			_renderObject(object);
		}
	}
}