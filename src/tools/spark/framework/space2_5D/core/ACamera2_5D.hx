/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, November 2014
 */

package tools.spark.framework.space2_5D.core;

import tools.spark.framework.space2_5D.interfaces.ICamera2_5D;
import tools.spark.framework.space2_5D.interfaces.IView2_5D;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;

/**
 * ...
 * @author Aris Kostakos
 */
class ACamera2_5D extends AObject2_5D implements ICamera2_5D
{
	private var _attachedToViews:Map<IView2_5D,IView2_5D>;
	
	private function new(p_gameEntity:IGameEntity) 
	{
		super(p_gameEntity);
		_initACamera2_5D();
	}
	
	private function _initACamera2_5D()
	{
		_attachedToViews = new Map<IView2_5D,IView2_5D>();
	}
	
	public function attachToView(p_view2_5D:IView2_5D):Dynamic
	{
		_attachedToViews[p_view2_5D] = p_view2_5D;
		
		return null;
	}
	
	inline public function updateState(p_state:String, ?p_view2_5D:IView2_5D):Void
	{
		if (p_view2_5D == null)
		{
			//do for all instances
			for (f_view in _attachedToViews.keys())
				_updateStateForView(p_state, f_view);
		}
		else
		{
			//do for p_View2_5D instance
			_updateStateForView(p_state, p_view2_5D);
		}
	}
	
	//@think: inline here, good idea or not?
	inline private function _updateStateForView(p_state:String, p_view2_5D:IView2_5D):Void
	{
		switch (p_state)
		{
			case 'command_updateCamera':
				p_view2_5D.updateCamera();
				/*
			case 'captureAreaX':
				p_view2_5D.updateCamera();
			case 'captureAreaY':
				p_view2_5D.updateCamera();
			case 'captureAreaWidth':
				p_view2_5D.updateCamera();
			case 'captureAreaHeight':
				p_view2_5D.updateCamera();
			*/
			default:
				Console.warn('Unhandled Camera State value: ' + p_state);
		}
	}
}