/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, September 2013
 */

package org.gamepl.coreservices.services.std.display.renderers.core;
import org.gamepl.coreservices.services.std.display.interfaces.IScene;
import org.gamepl.coreservices.services.std.display.interfaces.IObject;
import flash.Lib;

/**
 * ...
 * @author Aris Kostakos
 */
class ThreeJsRenderer extends ARenderer
{
	public function new() 
	{
		super();
		Console.info("ThreeJs Renderer Initiated");
	}
	
	//Should be overriden
	override private function _updateScene(p_scene:IScene):Void
	{
		//Console.debug("OpenFl Renderer: Rendering Scene...");
		
		//Console.debug("Factory Width: " + _kernel.factory.width);
		//Console.debug("Factory Height: " + _kernel.factory.height);
		
		if (scenePointerSet.exists(p_scene)==false)
		{
			/*
			var sprite:Sprite = new Sprite();

			//Add to stage
			Lib.current.stage.addChild(sprite);
			
			//Let's play
			sprite.x = p_scene.posX;
			sprite.y = p_scene.posY;

			scenePointerSet.set(p_scene, sprite);
			*/
		}
		else
		{
			//Let's play
			//var sprite:Sprite = cast(scenePointerSet.get(p_scene),Sprite);
			//sprite.x = p_scene.posX;
			//sprite.y = p_scene.posY;
		}
		
		super._updateScene(p_scene);
	}
	
	//Should be overriden
	override private function _updateObject(parent:Dynamic, p_object:IObject):Void
	{
		if (objectPointerSet.exists(p_object)==false)
		{
			/*
			var sprite:Sprite = new Sprite();

			//Add to parent
			parent.addChild(sprite);
			
			//Let's play
			p_object.mesh = new Bitmap(openfl.Assets.getBitmapData(p_object.meshUrl));
			
			sprite.addChild(p_object.mesh);
			sprite.x = p_object.posX;
			sprite.y = p_object.posY;

			objectPointerSet.set(p_object, sprite);
			*/
		}
		else
		{
			//Let's play
			//var sprite:Sprite = cast(objectPointerSet.get(p_object),Sprite);
			//sprite.x = p_object.posX;
			//sprite.y = p_object.posY;
			
			//p_object.mesh.bitmapData = openfl.Assets.getBitmapData(p_object.meshUrl);
		}
		
		super._updateObject(parent, p_object);
	}
}