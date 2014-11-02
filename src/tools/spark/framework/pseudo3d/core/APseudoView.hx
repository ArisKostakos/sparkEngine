/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, December 2013
 */

package tools.spark.framework.pseudo3d.core;
import tools.spark.framework.pseudo3d.interfaces.IPseudoCamera;
import tools.spark.framework.pseudo3d.interfaces.IPseudoScene;
import tools.spark.framework.pseudo3d.interfaces.IPseudoView;

/**
 * ...
 * @author Aris Kostakos
 */
class APseudoView implements IPseudoView
{
	public var camera( default, default ):IPseudoCamera;
	public var scene( default, default ):IPseudoScene;
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
	
	
}