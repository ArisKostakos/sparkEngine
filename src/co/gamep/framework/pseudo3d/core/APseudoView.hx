/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, December 2013
 */

package co.gamep.framework.pseudo3d.core;
import co.gamep.framework.pseudo3d.interfaces.IPseudoCamera;
import co.gamep.framework.pseudo3d.interfaces.IPseudoScene;
import co.gamep.framework.pseudo3d.interfaces.IPseudoView;

/**
 * ...
 * @author Aris Kostakos
 */
class APseudoView implements IPseudoView
{
	public var camera( default, default ):IPseudoCamera;
	public var scene( default, set ):IPseudoScene;
	public var x( default, default ):Int;
	public var y( default, default ):Int;
	public var width( default, default ):Int;
	public var height( default, default ):Int;
	
	public function validate():Void
	{
		//override...
		
	}
	
	private function new() 
	{
		
	}
	
	public function render():Void
	{
		//override...
		
	}
	
	public function set_scene( v:IPseudoScene):IPseudoScene
	{
		//override ahead
		
		return scene = v;
	}
	
}