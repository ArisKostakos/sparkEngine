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
		Console.debug("OpenFl Renderer Initiated");
	}
	
	//Should be overriden
	override private function _renderScene(scene:IScene):Void
	{
		if (scenePointerSet.exists(scene)==false)
		{
			Console.debug("OpenFl Renderer: Creating Scene as flash.Sprite...");
			
			var sprite:Sprite = new Sprite();
			Lib.current.stage.addChild(sprite);
			
			//set x,y,width,height
			
			scenePointerSet.set(scene, sprite);
		}
		
		super._renderScene(scene);
	}
	
	//Should be overriden
	override private function _renderObject(object:IObject):Void
	{
		if (objectPointerSet.exists(object)==false)
		{
			Console.debug("OpenFl Renderer: Creating Object as flash.Sprite...");
			
			var sprite:Sprite = new Sprite();
			Lib.current.stage.addChild(sprite);  //fix me!
			
			//Let's play
			var bitmap:Bitmap = new Bitmap(openfl.Assets.getBitmapData( "assets/overlay/buttons/BackOver.png" ));
			sprite.addChild(bitmap);
			sprite.x = 100;
			sprite.y = 100;
			//set x,y,width,height
			
			
			objectPointerSet.set(object, sprite);
		}
		
		
		super._renderObject(object);
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