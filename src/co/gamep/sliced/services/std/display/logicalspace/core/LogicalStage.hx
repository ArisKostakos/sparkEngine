/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, November 2013
 */

package co.gamep.sliced.services.std.display.logicalspace.core;

import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalStage;
import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalView;

/**
 * ...
 * @author Aris Kostakos
 */
class LogicalStage extends ALogicalComponent implements ILogicalStage
{
	public var logicalViewSet( default, null ):Map<String,ILogicalView>;
	public var width( default, default ):Int;
	public var height( default, default ):Int;
	
	public function new() 
	{
		super();
		
		_init();
	}
	
	inline private function _init():Void
	{
		logicalViewSet = new Map<String,ILogicalView>();
	}
	
	public function addView( p_view:ILogicalView ):Void
	{
		p_view.parent = this;
		logicalViewSet[p_view.name]=p_view;
	}
	
	public function removeView( p_view:ILogicalView ):Void
	{
		logicalViewSet.remove(p_view.name);
	}
}