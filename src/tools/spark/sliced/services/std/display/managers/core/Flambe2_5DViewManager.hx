/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, October 2014
 */

 package tools.spark.sliced.services.std.display.managers.core;

import flambe.platform.InternalGraphics;
import tools.spark.framework.flambe2_5D.FlambeView2_5D;
import tools.spark.sliced.services.std.display.renderers.interfaces.ILibrarySpecificRenderer;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameForm;

import tools.spark.sliced.services.std.display.managers.interfaces.IDisplayObjectManager;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;

/**
 * ...
 * @author Aris Kostakos
 */
class Flambe2_5DViewManager implements IDisplayObjectManager
{
	private var _renderer:ILibrarySpecificRenderer;
	private var _flambeGraphics:InternalGraphics;
	
	public function new(p_renderer:ILibrarySpecificRenderer, p_flambeGraphics:InternalGraphics) 
	{
		_renderer = p_renderer;
		
		_flambeGraphics = p_flambeGraphics;
	}
	
	public function create(p_gameEntity:IGameEntity):Dynamic 
	{
		//typecast?
		
		var l_view2_5D:FlambeView2_5D = new FlambeView2_5D(_flambeGraphics);
		l_view2_5D.name = p_gameEntity.getState('name');
		
		
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
		updateState(p_object,p_gameEntity,'camera');
	}
	
	public function updateState(p_object:Dynamic, p_gameEntity:IGameEntity, p_state:String):Void 
	{
		//typecast
		var l_view2_5D:FlambeView2_5D = cast(p_object, FlambeView2_5D);
		
		switch (p_state)
		{
			case 'scene':
				var l_sceneEntity:IGameEntity = p_gameEntity.getState(p_state);
				
				l_view2_5D.scene = _renderer.createScene(l_sceneEntity);
				Console.error("Scene Name: " + l_view2_5D.scene.name);
			case 'camera':
				var l_cameraEntity:IGameEntity = p_gameEntity.getState(p_state);
				
				l_view2_5D.camera = _renderer.createCamera(l_cameraEntity);
				Console.error("Camera Name: " + l_view2_5D.camera.name);
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
	
	public function removeFrom(p_objectChild:Dynamic, p_objectParent:Dynamic):Void
	{
		//typecast?
		
	}
}