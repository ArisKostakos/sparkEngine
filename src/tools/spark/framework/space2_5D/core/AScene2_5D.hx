/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, November 2014
 */

package tools.spark.framework.space2_5D.core;

import tools.spark.framework.space2_5D.interfaces.ICamera2_5D;
import tools.spark.framework.space2_5D.interfaces.IEntity2_5D;
import tools.spark.framework.space2_5D.interfaces.IScene2_5D;
import tools.spark.framework.space2_5D.interfaces.IView2_5D;
import tools.spark.framework.layout.containers.Group;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;
import tools.spark.sliced.core.Sliced;

/**
 * ...
 * @author Aris Kostakos
 */
class AScene2_5D extends AInstantiable2_5D implements IScene2_5D
{
	private var _tempX:Float;
	private var _tempY:Float;
	private var _scaleX:Float;
	private var _scaleY:Float;
	
	private function new(p_gameEntity:IGameEntity) 
	{
		_tempX = 0;
		_tempY = 0;
		_scaleX = 1;
		_scaleY = 1;
		
		super(p_gameEntity);
	}
	
	override public function createInstance (p_view2_5D:IView2_5D):Dynamic
	{
		return super.createInstance(p_view2_5D);
	}
	
	override private function _createChildOfInstance(p_childEntity:IEntity2_5D, p_view2_5D:IView2_5D):Void
	{
		if (p_childEntity.gameEntity.getState('layoutable') == true)
			p_view2_5D.group.children.push(p_childEntity.groupInstances[p_view2_5D]);
			
		p_childEntity.parentScene = this;
	}
	
	override private function _removeChildOfInstance(p_childEntity:IEntity2_5D, p_view2_5D:IView2_5D):Void
	{
		if (p_childEntity.gameEntity.getState('layoutable') == true)
			p_view2_5D.group.children.remove(p_childEntity.groupInstances[p_view2_5D]);
	}
	
	public function updateCamera(p_view:IView2_5D, p_camera:ICamera2_5D):Void
	{
		var l_captureAreaX:Float = p_camera.gameEntity.getState('captureAreaX');
		var l_captureAreaY:Float = p_camera.gameEntity.getState('captureAreaY');
		var l_captureAreaWidth:Float = p_camera.gameEntity.getState('captureAreaWidth');
		var l_captureAreaHeight:Float = p_camera.gameEntity.getState('captureAreaHeight');
		
		//if camera x is whatever and y whatever and size whatever and view width, x, y, whatever, then.... scene's instance x and y must be : X, Y
		var l_scale = p_view.gameEntity.getState('feedbackWidth') / l_captureAreaWidth;
		
		//after calculations, store them somewhere privately and let the overriding function actually do it (good enough for now..:/)
		//set scale
		_scaleX = _scaleY = l_scale;
		
		//set pos
		_tempX = -l_captureAreaX * l_scale;
		_tempY = -l_captureAreaY * l_scale;
	}
}