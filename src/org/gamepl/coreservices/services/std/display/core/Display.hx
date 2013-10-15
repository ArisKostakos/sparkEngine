/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, September 2013
 */

package org.gamepl.coreservices.services.std.display.core;

import awe6.interfaces.IKernel;
import org.gamepl.coreservices.interfaces.IDisplay;
import org.gamepl.coreservices.core.AService;
import org.gamepl.coreservices.services.std.display.interfaces.IScene;
import org.gamepl.coreservices.services.std.display.interfaces.IObject;
import org.gamepl.coreservices.services.std.display.renderers.interfaces.IRenderer;
import org.gamepl.coreservices.services.std.display.renderers.core.OpenFlRenderer;  //todo: remove this. Use Reflection

/**
 * ...
 * @author Aris Kostakos
 */
class Display extends AService implements IDisplay
{
	public var rendererSet( default, null ):Array<IRenderer>;

	//todo: somewhere here, add a filtering mechanism for choosing the appropriate renderer
	//do this by enumerating all the available renderers added for the current platform
	//and start disqualifing renderers due to platform requirements and restrictions
	//order by gRenderer request, then chose the top one
	
	public function new(p_kernel:IKernel) 
	{
		super(p_kernel);
		
		_init();
	}
	
	private function _init():Void
	{
		Console.log("Init Display std Service...");
		rendererSet = new Array<IRenderer>();
	}
	
	public function createRenderer():IRenderer
	{
		//@todo: Reflection needed here!!! See above todo
		return new OpenFlRenderer();
	}
	
	//@think: this is a nice way to check if a new scene has been created, instead of itterating the logical world. The Renderer may find this useful.
	public function createScene():IScene
	{
		return new Scene();
	}
	
	//@think: this is a nice way to check if a new object has been created, instead of itterating the logical world. The Renderer may find this useful.
	public function createObject():IObject
	{
		return new Object();
	}
	
	public function addRenderer(renderer:IRenderer, index:Int):Void
	{
		rendererSet.push(renderer);
	}
	
	public function removeRenderer(renderer:IRenderer):Void
	{
		rendererSet.remove(renderer);
	}
	public function update():Void
	{
		for (renderer in rendererSet)
		{
			renderer.update();
		}
	}
	
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