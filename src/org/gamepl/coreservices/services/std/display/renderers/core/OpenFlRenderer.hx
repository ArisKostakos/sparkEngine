/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, September 2013
 */

package org.gamepl.coreservices.services.std.display.renderers.core;
import flash.display.Bitmap;
import org.gamepl.coreservices.services.std.display.interfaces.IScene;
import org.gamepl.coreservices.services.std.display.interfaces.IObject;
import flash.Lib;
import flash.display.Sprite;

/**
 * ...
 * @author Aris Kostakos
 */
class OpenFlRenderer extends ARenderer
{
	public function new() 
	{
		super();
		Console.log("OpenFl Renderer Initiated");
	}
	
	//Should be overriden
	override private function _updateScene(p_scene:IScene):Void
	{
		//Console.debug("OpenFl Renderer: Rendering Scene...");
		
		if (scenePointerSet.exists(p_scene)==false)
		{
			var sprite:Sprite = new Sprite();
			
			//Add to stage
			Lib.current.stage.addChild(sprite);
			
			//Let's play
			sprite.x = p_scene.posX;
			sprite.y = p_scene.posY;
			

			//sprite.scaleX = 2;
			//sprite.scaleY = 2;
			//sprite.rotation = -60;
			//sprite.width = 100;
			//sprite.height = 100;
			//set x,y,width,height
			//Console.warn('Sprite width: ' + sprite.width + ' and Sprite height: ' + sprite.height);
			scenePointerSet.set(p_scene, sprite);
		}
		else
		{
			//Let's play
			scenePointerSet.get(p_scene).x = p_scene.posX;
			scenePointerSet.get(p_scene).y = p_scene.posY;
			//Console.debug("OpenFl Renderer: X: " + p_scene.posX + ", Y: " + p_scene.posY);
		}
		
		super._updateScene(p_scene);
	}
	
	//Should be overriden
	override private function _updateObject(parent:Dynamic, p_object:IObject):Void
	{
		if (objectPointerSet.exists(p_object)==false)
		{
			//Console.debug("OpenFl Renderer: Creating Object as flash.Sprite...");
			
			var sprite:Sprite = new Sprite();
			
			//Add to parent
			parent.addChild(sprite);
			
			//Let's play
			//if (p_object.meshUrl == null) p_object.meshUrl = "assets/overlay/buttons/BackOver.png";
			p_object.mesh = new Bitmap(openfl.Assets.getBitmapData(p_object.meshUrl));
			
			sprite.addChild(p_object.mesh);
			sprite.x = p_object.posX;
			sprite.y = p_object.posY;
			
			//sprite.rotation = 60;
			//set x,y,width,height
			
			
			objectPointerSet.set(p_object, sprite);
		}
		else
		{
			//Let's play
			objectPointerSet.get(p_object).x = p_object.posX;
			objectPointerSet.get(p_object).y = p_object.posY;
			p_object.mesh.bitmapData = openfl.Assets.getBitmapData(p_object.meshUrl);
			//Console.debug("OpenFl Renderer: X: " + p_scene.posX + ", Y: " + p_scene.posY);
		}
		
		super._updateObject(parent, p_object);
	}
}

/*
	public function createScene(p_rendererType:String, p_posX:Int, p_posY:Int, p_width:Int, p_height:Int):IScene
	{
		var scene:IScene = new Scene(p_rendererType, p_posX, p_posY, p_width, p_height);
		sceneSet.push(scene);
		return scene;
	}
	
	//remove us when done
	//okaaaayy?? good!
	
	private var _testBitmap:Bitmap;
	
	public function test():Void
	{
		_testBitmap = new Bitmap();
		_testBitmap.x = 100;
		_testBitmap.y = 100;

		Lib.current.stage.addChild(_testBitmap);
		_testBitmap.bitmapData = openfl.Assets.getBitmapData( "assets/overlay/buttons/BackOver.png" );
		
		Console.debug("Factory Width: " + _kernel.factory.width);
		Console.debug("Factory Height: " + _kernel.factory.height);
	}
	
	public function testMove(dir:String):Void
	{
		if (dir == "left") _testBitmap.x -= 1;
		else if (dir == "right") _testBitmap.x += 1;
		else if (dir == "up") _testBitmap.y -= 1;
		else if (dir == "down") _testBitmap.y += 1;
	}
	*/