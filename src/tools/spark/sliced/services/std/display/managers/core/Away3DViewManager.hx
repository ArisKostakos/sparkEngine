/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, October 2014
 */

 package tools.spark.sliced.services.std.display.managers.core;
import away3d.containers.View3D;
import away3d.core.managers.Stage3DManager;
import tools.spark.sliced.services.std.display.renderers.interfaces.ILibrarySpecificRenderer;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameForm;

import tools.spark.sliced.services.std.display.managers.interfaces.IDisplayObjectManager;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;

import tools.spark.framework.layout.containers.Group;
import tools.spark.sliced.core.Sliced;

/**
 * ...
 * @author Aris Kostakos
 */
class Away3DViewManager implements IDisplayObjectManager
{
	private var _renderer:ILibrarySpecificRenderer;
	
	public function new(p_renderer:ILibrarySpecificRenderer) 
	{
		_renderer = p_renderer;
	}
	
	/* INTERFACE tools.spark.sliced.services.std.display.managers.interfaces.IDisplayObjectManager */
	
	public function create(p_gameEntity:IGameEntity):Dynamic 
	{
		//typecast?
		
		var l_view3D:View3D = new View3D();
		
		var l_group:Group = Sliced.display.projectActiveSpaceReference.activeStageReference.layoutManager.getViewGroupByGameEntity(p_gameEntity);
		//Console.error("did recursion while looking for: " + gameEntity.getState('name') + ", and found this: " + group.layoutableEntity.getState('name'));
		l_group.layoutableInstance = this;
		
		var stage3Dmanager:Stage3DManager = Stage3DManager.getInstance(l_view3D.stage);
		l_view3D.stage3DProxy = stage3Dmanager.getStage3DProxy(0);
		l_view3D.shareContext = true;// false;
		l_view3D.layeredView =  true;// false;

		Console.error("CREATED VIEW 3D WITH A GROUP ON THE VIEW MANAGER!!");
		Console.log("away html new view created. Num of Stage3DProxies: " + stage3Dmanager.numProxySlotsUsed);
		stage3Dmanager.iRemoveStage3DProxy(stage3Dmanager.getStage3DProxy(1));
		Console.log("away html view removed. Num of Stage3DProxies: " + stage3Dmanager.numProxySlotsUsed);

		//l_view3D.backgroundColor = 0xff0000;
		update(l_view3D, p_gameEntity);
		
		return l_view3D;
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
		//typecast?
		
		switch (p_state)
		{
			case 'scene':
				var l_sceneEntity:IGameEntity = p_gameEntity.getState(p_state);
		
				p_object.scene = _renderer.createScene(l_sceneEntity);
			case 'camera':
				var l_cameraEntity:IGameEntity = p_gameEntity.getState(p_state);
		
				p_object.camera = _renderer.createCamera(l_cameraEntity);
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