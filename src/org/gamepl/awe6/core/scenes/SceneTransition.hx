/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, July 2013
 */

 package org.gamepl.awe6.core.scenes;
import awe6.interfaces.IKernel;

/**
 * ...
 * @author Aris Kostakos
 */

class SceneTransition extends awe6.core.SceneTransition 
{
	public function new( p_kernel:IKernel ) 
	{
		var l_duration:Int = 200;
		super( p_kernel, l_duration );
	}

	override private function _init():Void 
	{
		super._init();
		// extend
	}

	override private function _updater( p_deltaTime:Int = 0 ):Void 
	{
		super._updater( p_deltaTime );
		//extend
	}

	override private function _disposer():Void 
	{
		//extend
		super._disposer();
	}
}
