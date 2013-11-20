/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, November 2013
 */

 package co.gamep.sliced.services.std.display.renderers.core;

import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalView;
import co.gamep.sliced.services.std.display.renderers.interfaces.IRenderer;

/**
 * ...
 * @author Aris Kostakos
 */
class Away3DFlashRenderer extends AAway3DRenderer
{
	public function new() 
	{
		super();
		
		_init();
	}
	
	inline private function _init():Void
	{
		Console.info("Creating Away3D Flash Renderer...");
	}
	
	override public function update ():Void
	{
		super.update();
	}
	
	/*
	override public function render ( p_logicalView:ILogicalView):Void
	{
		//render a view
		
	}
	*/
}