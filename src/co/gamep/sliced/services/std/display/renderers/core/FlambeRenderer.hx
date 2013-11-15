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
class FlambeRenderer extends ARenderer
{
	public function new() 
	{
		super();
		
		_init();
	}
	
	inline private function _init():Void
	{
		Console.info("Creating Flambe Renderer...");
		uses3DEngine = false;
	}
	
	override public function update ():Void
	{
		//update 'dirty' views
		
	}
	
	override public function render ( p_logicalView:ILogicalView):Void
	{
		//render a view
		
	}
}