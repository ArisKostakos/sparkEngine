/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, November 2013
 */

package co.gamep.sliced.services.std.display.logicalspace.core;

import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalStage;
import co.gamep.sliced.services.std.display.logicalspace.containers.View3D;

/**
 * ...
 * @author Aris Kostakos
 */
@:keep class LogicalStage implements ILogicalStage
{
	public var name( default, default ):String;
	public var logicalViewSet( default, null ):Map<String,View3D>;
	public var width( default, default ):Int;
	public var height( default, default ):Int;
	
	public function new() 
	{
		_init();
	}
	
	inline private function _init():Void
	{
		logicalViewSet = new Map<String,View3D>();
	}
	
	public function addView( p_view:View3D):Void
	{
		logicalViewSet[p_view.name]=p_view;
	}
	
	public function removeView( p_view:View3D):Void
	{
		logicalViewSet.remove(p_view.name);
	}
}