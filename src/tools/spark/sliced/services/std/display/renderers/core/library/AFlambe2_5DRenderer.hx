/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, November 2013
 */

package tools.spark.sliced.services.std.display.renderers.core.library;

import flambe.platform.InternalGraphics;
import flambe.platform.Platform;
import tools.spark.framework.flambe2_5D.FlambeScene2_5D;
import tools.spark.framework.flambe2_5D.FlambeView2_5D;
import tools.spark.framework.flambe2_5D.FlambeCamera2_5D;
import tools.spark.framework.space2_5D.core.AObjectContainer2_5D;
import tools.spark.sliced.services.std.display.managers.core.Flambe2_5DCameraManager;
import tools.spark.sliced.services.std.display.managers.core.Flambe2_5DObjectManager;
import tools.spark.sliced.services.std.display.managers.core.Flambe2_5DSceneManager;
import tools.spark.sliced.services.std.display.managers.core.Flambe2_5DViewManager;
import tools.spark.sliced.services.std.display.renderers.core.dimension.A2_5DRenderer;
import tools.spark.sliced.services.std.display.renderers.interfaces.ILibrarySpecificRenderer;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;


/**
 * This abstraction level of the Renderer will always act as a mediator between its managers
 * @author Aris Kostakos
 */
class AFlambe2_5DRenderer extends A2_5DRenderer implements ILibrarySpecificRenderer
{
	private var _views:Map<IGameEntity,FlambeView2_5D>;
	private var _scenes:Map<IGameEntity,FlambeScene2_5D>;
	private var _cameras:Map<IGameEntity,FlambeCamera2_5D>;
	private var _objects:Map<IGameEntity,AObjectContainer2_5D>;
	
	private var _viewManager:Flambe2_5DViewManager;
	private var _sceneManager:Flambe2_5DSceneManager;
	private var _cameraManager:Flambe2_5DCameraManager;
	private var _objectManager:Flambe2_5DObjectManager;
	
	private var _platform:Platform;
	private var _internalGraphics:InternalGraphics;
	
	private function new()
	{
		//Abstract class, private constructor
		super();

		_aFlambe2_5dRendererInit();
	}

	inline private function _aFlambe2_5dRendererInit():Void
	{
        _internalGraphics = _platform.getRenderer().graphics;
		
		if (_internalGraphics == null)
		{
			Console.error("Flambe renderer does NOT have internal graphics!");
		}
		
		//@THINK: keep this? or just one map to rule them all??
		_views = new Map<IGameEntity,FlambeView2_5D>();
		_scenes = new Map<IGameEntity,FlambeScene2_5D>();
		_cameras = new Map<IGameEntity,FlambeCamera2_5D>();
		_objects = new Map<IGameEntity,AObjectContainer2_5D>();
		
		_viewManager = new Flambe2_5DViewManager(this,_internalGraphics);
		_sceneManager = new Flambe2_5DSceneManager(this);
		_cameraManager = new Flambe2_5DCameraManager(this);
		_objectManager = new Flambe2_5DObjectManager(this);
	}
	
	public function renderView ( p_viewEntity:IGameEntity):Void
	{
		//Console.warn("AFlambe2_5DRenderer rendering View: " + p_viewEntity.getState('name'));
		
		//render a view
		_views[p_viewEntity].render();
	}
	

	public function createView ( p_viewEntity:IGameEntity):Dynamic
	{
		if (_views[p_viewEntity] != null)
			Console.warn("View " + p_viewEntity.getState('name') + " has already been added to this Flambe2_5DRenderer. Ignoring...");
		else
			_views[p_viewEntity] = cast(_viewManager.create(p_viewEntity),FlambeView2_5D);
		
		return _views[p_viewEntity];
	}
	
	public function createScene ( p_sceneEntity:IGameEntity):Dynamic
	{
		if (_scenes[p_sceneEntity] != null)
			Console.warn("Scene " + p_sceneEntity.getState('name') + " has already been added to this Flambe2_5DRenderer. Ignoring...");
		else
			_scenes[p_sceneEntity] = cast(_sceneManager.create(p_sceneEntity),FlambeScene2_5D);
		
		return _scenes[p_sceneEntity];
	}
	
	public function createCamera ( p_cameraEntity:IGameEntity):Dynamic
	{
		if (_cameras[p_cameraEntity] != null)
			Console.warn("Camera " + p_cameraEntity.getState('name') + " has already been added to this Flambe2_5DRenderer. Ignoring...");
		else
			_cameras[p_cameraEntity] = cast(_cameraManager.create(p_cameraEntity),FlambeCamera2_5D);

		return _cameras[p_cameraEntity];
	}
	
	public function createObject ( p_objectEntity:IGameEntity):Dynamic
	{
		if (p_objectEntity.getState('displayType')=="Entity")
		{
			if (_objects[p_objectEntity] != null)
				Console.warn("Object " + p_objectEntity.getState('name') + " has already been added to this Flambe2_5DRenderer. Ignoring...");
			else
				_objects[p_objectEntity] = cast(_objectManager.create(p_objectEntity),AObjectContainer2_5D);
			
			return _objects[p_objectEntity];
		}
		else return null;
	}
	
	inline public function addChild ( p_parentEntity:IGameEntity, p_childEntity:IGameEntity):Void
	{
		//check the parent display type here.. For the childEntity, I'm ASSUMING it's an entity/object.. is that right??
		switch (p_parentEntity.getState('displayType'))
		{
			case "Scene":
				if (_scenes[p_parentEntity] != null)
					_sceneManager.addTo(createObject(p_childEntity), _scenes[p_parentEntity]);
			case "Entity":
				if (_objects[p_parentEntity] != null)
					_objectManager.addTo(createObject(p_childEntity), _objects[p_parentEntity]);
			default:
				Console.warn("AFlambe2_5DRenderer: Unhandled add child request: " + p_parentEntity.getState('displayType'));
		}
	}
	
	inline public function insertChild ( p_parentEntity:IGameEntity, p_childEntity:IGameEntity, p_index:Int):Void
	{
		Console.error("AFlambe2_5DRenderer: Insert Child NOT Supported yet!!!");
	}
	
	public function removeChild(p_parentEntity:IGameEntity, p_childEntity:IGameEntity):Void 
	{
		//check the parent display type here.. For the childEntity, I'm ASSUMING it's an entity/object.. is that right??
		//here i remove but not destroy.. think this over..
		switch (p_parentEntity.getState('displayType'))
		{
			case "Scene":
				if (_scenes[p_parentEntity] != null)
					_sceneManager.removeFrom(_objects[p_childEntity], _scenes[p_parentEntity]);
					
			case "Entity":
				if (_objects[p_parentEntity] != null)
					//_objectManager.addTo(createObject(p_childEntity), _objects[p_parentEntity]);
					Console.warn("FLAMBE RENDERER: REMOVING A CHILD FROM AN OBJECT NOT YET IMPLEMENTED");
			default:
				Console.warn("AFlambe2_5DRenderer: Unhandled remove child request: " + p_parentEntity.getState('displayType'));
		}
	}
	
	//CUT COSTS by unifying all maps (_objects,_views,etc) into one, deep in ARenderer, so you don't do the IF here for every updateState
	//also will help not rewritting several functions, since we can now move those deep in ARenderer somewhere..
	//what was I thinking.....
	inline public function updateState ( p_objectEntity:IGameEntity, p_state:String):Void
	{
		//maybe check its display type here..
		
		//is it object, do this:
		if (_objects[p_objectEntity] != null)
		{
			_objectManager.updateState(_objects[p_objectEntity], p_objectEntity, p_state);
		}
		//else if it's view, do this:
		else if (_views[p_objectEntity] != null)
		{
			_viewManager.updateState(_views[p_objectEntity], p_objectEntity, p_state);
		}
		//else if it's view, do this:
		else if (_cameras[p_objectEntity] != null)
		{
			_cameraManager.updateState(_cameras[p_objectEntity], p_objectEntity, p_state);
		}
	}
	
	override public function getRealObject(p_gameEntity:IGameEntity):Dynamic
	{
		//is it object, do this:
		if (_objects[p_gameEntity] != null)
		{
			return _objects[p_gameEntity];
		}
		//else if it's view, do this:
		else if (_views[p_gameEntity] != null)
		{
			return _views[p_gameEntity];
		}
		//else if it's view, do this:
		else if (_cameras[p_gameEntity] != null)
		{
			return _cameras[p_gameEntity];
		}
		//else if it's scene, do this:
		else if (_scenes[p_gameEntity] != null)
		{
			return _scenes[p_gameEntity];
		}
		else
		{
			return null;
		}
	}
	
	inline public function updateFormState ( p_objectEntity:IGameEntity, p_state:String):Void
	{
		//maybe check its display type here..
		
		//is it object, do this:
		if (_objects[p_objectEntity] != null)
		{
			_objectManager.updateFormState(_objects[p_objectEntity], p_objectEntity.gameForm, p_state);
		}
		
		//else, is it view, do this...  etc
	}
}