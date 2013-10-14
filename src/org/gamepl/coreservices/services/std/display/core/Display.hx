/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, September 2013
 */

package org.gamepl.coreservices.services.std.display.core;

import awe6.core.Context;
import awe6.interfaces.IKernel;
import flash.display.Bitmap;
import flash.geom.Rectangle;
import org.gamepl.coreservices.interfaces.IDisplay;
import org.gamepl.coreservices.core.AService;
import org.gamepl.coreservices.services.std.display.interfaces.IScene;
import org.gamepl.coreservices.services.std.display.core.Scene;
import flash.Lib;
/**
 * ...
 * @author Aris Kostakos
 */
class Display extends AService implements IDisplay
{
	public var sceneSet( default, null ):Array<IScene>;

	public function new(p_kernel:IKernel) 
	{
		super(p_kernel);
		
		_init();
	}
	
	private function _init():Void
	{
		Console.log("Init Display std Service...");
		sceneSet = new Array<IScene>();
	}
	
	public function createScene(p_rendererType:String, p_posX:Int, p_posY:Int, p_width:Int, p_height:Int):IScene
	{
		var scene:IScene = new Scene(p_rendererType, p_posX, p_posY, p_width, p_height);
		sceneSet.push(scene);
		return scene;
	}
	
	//remove us when done
	//okaaaayy?? good!
	/*
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
	
	public function log(message:String):Void
	{
		Console.log(message);
	}
	
	public function info(message:String):Void
	{
		Console.info(message);
	}
	
	public function debug(message:String):Void
	{
		Console.debug(message);
	}
	
	public function warn(message:String):Void
	{
		Console.warn(message);
	}
	
	public function error(message:String):Void
	{
		Console.error(message);
	}
}