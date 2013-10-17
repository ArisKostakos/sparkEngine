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
			//if (scenePointerSet.exists(scene) == false || scene.modifiedLastUpdate == true)
			_updateScene(scene);
		}
	}
	
	//Should be overriden
	private function _updateScene(p_scene:IScene):Void
	{
		//override here...
		
		for (f_object in p_scene.objectSet)
		{
			_updateObject(scenePointerSet.get(p_scene), f_object);
		}
	}
	
	//Should be overriden
	private function _updateObject(parent:Dynamic, p_object:IObject):Void
	{
		//override here...
		
		for (f_object in p_object.objectSet)
		{
			_updateObject(objectPointerSet.get(p_object), f_object);
		}
	}
}