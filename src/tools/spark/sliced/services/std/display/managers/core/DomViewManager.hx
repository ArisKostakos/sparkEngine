/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, January 2015
 */

 package tools.spark.sliced.services.std.display.managers.core;

import flambe.platform.InternalGraphics;
import tools.spark.framework.dom2_5D.DomView2_5D;
import tools.spark.sliced.services.std.display.renderers.interfaces.ILibrarySpecificRenderer;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameForm;

import tools.spark.sliced.services.std.display.managers.interfaces.IDisplayObjectManager;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;

/**
 * ...
 * @author Aris Kostakos
 */
class DomViewManager implements IDisplayObjectManager
{
	private var _renderer:ILibrarySpecificRenderer;
	
	public function new(p_renderer:ILibrarySpecificRenderer) 
	{
		_renderer = p_renderer;
	}
	
	public function create(p_gameEntity:IGameEntity):Dynamic 
	{
		//typecast?
		
		var l_view2_5D:DomView2_5D = new DomView2_5D(p_gameEntity);
		
		update(l_view2_5D, p_gameEntity);
		
		return l_view2_5D;
	}
	
	public function destroy(p_object:Dynamic):Void 
	{
		//typecast?
		
	}
	
	public function update(p_object:Dynamic, p_gameEntity:IGameEntity):Void
	{
		//typecast?
		
		updateState(p_object, p_gameEntity, 'scene');
		updateState(p_object, p_gameEntity, 'camera');
		updateState(p_object,p_gameEntity, 'visible');
	}
	
	public function updateState(p_object:Dynamic, p_gameEntity:IGameEntity, p_state:String):Void 
	{
		//typecast
		var l_view2_5D:DomView2_5D = cast(p_object, DomView2_5D);
		
		switch (p_state)
		{
			case 'scene':
				var l_sceneEntity:IGameEntity = p_gameEntity.getState(p_state);
				
				l_view2_5D.scene = _renderer.createScene(l_sceneEntity);
			case 'camera':
				var l_cameraEntity:IGameEntity = p_gameEntity.getState(p_state);
				
				l_view2_5D.camera = _renderer.createCamera(l_cameraEntity);
				
			default:
				l_view2_5D.updateState(p_state);
		}
	}
	
	public function updateFormState(p_object:Dynamic, p_gameForm:IGameForm, p_state:String):Void 
	{
		//typecast?
		
	}
	
	public function addTo(p_objectChild:Dynamic, p_objectParent:Dynamic):Void
	{
		//typecast?
		
	}
	
	public function insertTo(p_objectChild:Dynamic, p_objectParent:Dynamic, p_index:Int):Void
	{
		//typecast?
		
	}
	
	public function removeFrom(p_objectChild:Dynamic, p_objectParent:Dynamic):Void
	{
		//typecast?
		
	}
}