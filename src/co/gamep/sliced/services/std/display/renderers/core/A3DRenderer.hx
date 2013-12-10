/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, December 2013
 */

package co.gamep.sliced.services.std.display.renderers.core;

/**
 * ...
 * @author Aris Kostakos
 */
class A3DRenderer extends ARenderer
{

	private function new() 
	{
		super();
		
		_a3DRendererInit();
	}
	
	
	inline private function _a3DRendererInit():Void
	{
		uses3DEngine = true;
	}	
	
}