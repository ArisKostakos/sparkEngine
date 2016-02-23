/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, January 2015
 */

 package tools.spark.sliced.services.std.display.renderers.core.platform.html;


import tools.spark.framework.dom2_5D.DomCamera2_5D;
import tools.spark.framework.dom2_5D.DomScene2_5D;
import tools.spark.framework.dom2_5D.DomView2_5D;
import tools.spark.framework.space2_5D.core.AObjectContainer2_5D;
import tools.spark.sliced.services.std.display.managers.core.DomCameraManager;
import tools.spark.sliced.services.std.display.managers.core.DomObjectManager;
import tools.spark.sliced.services.std.display.managers.core.DomSceneManager;
import tools.spark.sliced.services.std.display.managers.core.DomViewManager;
import tools.spark.sliced.services.std.display.renderers.core.library.ANativeControls2_5DRenderer;
import tools.spark.sliced.services.std.display.renderers.interfaces.IPlatformSpecificRenderer;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;


/**
 * ...
 * @author Aris Kostakos
 * 
 */
class NativeControlsHtmlRenderer extends ANativeControls2_5DRenderer implements IPlatformSpecificRenderer
{
	private var _views:Map<IGameEntity,DomView2_5D>;
	private var _scenes:Map<IGameEntity,DomScene2_5D>;
	private var _cameras:Map<IGameEntity,DomCamera2_5D>;
	private var _objects:Map<IGameEntity,AObjectContainer2_5D>;

	private var _viewManager:DomViewManager;
	private var _sceneManager:DomSceneManager;
	private var _cameraManager:DomCameraManager;
	private var _objectManager:DomObjectManager;
	
	public function new() 
	{
		super();
		
		_nativeControlsHtmlRendererInit();
	}
	
	inline private function _nativeControlsHtmlRendererInit():Void
	{
		Console.info("Creating Native Controls Html (DOM) Renderer...");
		
		//@THINK: keep this? or just one map to rule them all??
		_views = new Map<IGameEntity,DomView2_5D>();
		_scenes = new Map<IGameEntity,DomScene2_5D>();
		_cameras = new Map<IGameEntity,DomCamera2_5D>();
		_objects = new Map<IGameEntity,AObjectContainer2_5D>();
		
		_viewManager = new DomViewManager(this);
		_sceneManager = new DomSceneManager(this);
		_cameraManager = new DomCameraManager(this);
		_objectManager = new DomObjectManager(this);
	}
	
	
	override public function renderView ( p_viewEntity:IGameEntity):Void
	{
		//Console.warn("AFlambe2_5DRenderer rendering View: " + p_viewEntity.getState('name'));
		
		//render a view
		_views[p_viewEntity].render();
	}
	

	override public function createView ( p_viewEntity:IGameEntity):Dynamic
	{
		if (_views[p_viewEntity] != null)
			Console.warn("View " + p_viewEntity.getState('name') + " has already been added to this NativeControlsHtmlRenderer. Ignoring createView...");
		else
			_views[p_viewEntity] = cast(_viewManager.create(p_viewEntity),DomView2_5D);
		
		return _views[p_viewEntity];
	}
	
	//Right now, this doesn't destroy anything, just removes objects and references..
	//add a flag, to completely destroy objects
	//so it doesn't get lost... somehow mark a view as alive, but not added.. stuff like that u know...
	override public function destroyView ( p_viewEntity:IGameEntity):Void
	{
		if (_views[p_viewEntity] == null)
			Console.warn("View " + p_viewEntity.getState('name') + " has not been added to this NativeControlsHtmlRenderer. Ignoring destroyView...");
		else
		{
			_viewManager.destroy(_views[p_viewEntity]);
			_views[p_viewEntity] = null;
		}
	}
	
	override public function createScene ( p_sceneEntity:IGameEntity):Dynamic
	{
		if (_scenes[p_sceneEntity] != null)
			Console.warn("Scene " + p_sceneEntity.getState('name') + " has already been added to this NativeControlsHtmlRenderer. Ignoring...");
		else
			_scenes[p_sceneEntity] = cast(_sceneManager.create(p_sceneEntity),DomScene2_5D);
		
		return _scenes[p_sceneEntity];
	}
	
	override public function createCamera ( p_cameraEntity:IGameEntity):Dynamic
	{
		if (_cameras[p_cameraEntity] != null)
			Console.warn("Camera " + p_cameraEntity.getState('name') + " has already been added to this NativeControlsHtmlRenderer. Ignoring...");
		else
			_cameras[p_cameraEntity] = cast(_cameraManager.create(p_cameraEntity),DomCamera2_5D);

		return _cameras[p_cameraEntity];
	}
	
	override public function createObject ( p_objectEntity:IGameEntity):Dynamic
	{
		if (p_objectEntity.getState('displayType')=="Entity")
		{
			if (_objects[p_objectEntity] != null)
				Console.warn("Object " + p_objectEntity.getState('name') + " has already been added to this NativeControlsHtmlRenderer. Ignoring...");
			else
				_objects[p_objectEntity] = cast(_objectManager.create(p_objectEntity),AObjectContainer2_5D);
			
			return _objects[p_objectEntity];
		}
		else return null;
	}
	
	override inline public function addChild ( p_parentEntity:IGameEntity, p_childEntity:IGameEntity):Void
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
				Console.warn("NativeControlsHtmlRenderer: Unhandled add child request: " + p_parentEntity.getState('displayType'));
		}
	}
	
	override inline public function insertChild ( p_parentEntity:IGameEntity, p_childEntity:IGameEntity, p_index:Int):Void
	{
		//check the parent display type here.. For the childEntity, I'm ASSUMING it's an entity/object.. is that right??
		switch (p_parentEntity.getState('displayType'))
		{
			case "Scene":
				if (_scenes[p_parentEntity] != null)
					_sceneManager.insertTo(createObject(p_childEntity), _scenes[p_parentEntity], p_index);
			case "Entity":
				if (_objects[p_parentEntity] != null)
					_objectManager.insertTo(createObject(p_childEntity), _objects[p_parentEntity], p_index);
			default:
				Console.warn("NativeControlsHtmlRenderer: Unhandled insert child request: " + p_parentEntity.getState('displayType'));
		}
	}
	
	override inline public function removeChild ( p_parentEntity:IGameEntity, p_childEntity:IGameEntity):Void
	{
		//check the parent display type here.. For the childEntity, I'm ASSUMING it's an entity/object.. is that right??
		switch (p_parentEntity.getState('displayType'))
		{
			case "Scene":
				if (_scenes[p_parentEntity] != null)
					_sceneManager.removeFrom(_objects[p_childEntity], _scenes[p_parentEntity]);
			case "Entity":
				if (_objects[p_parentEntity] != null) //createObject here is wrong.. just take value from array instead
					_objectManager.removeFrom(_objects[p_childEntity], _objects[p_parentEntity]);
			default:
				Console.warn("NativeControlsHtmlRenderer: Unhandled remove child request: " + p_parentEntity.getState('displayType'));
		}
		
		//_objects[p_childEntity] = null; Want to try to start on garbage collect
		//but I guess I should do this on destroy, not just remove?
		//and destroy all its children too..
		//this needs to be done much more carefuly than this:)
	}
	
	override inline public function updateState ( p_objectEntity:IGameEntity, p_state:String):Void
	{
		//maybe check its display type here..
		
		//is it object, do this:
		if (_objects[p_objectEntity] != null)
		{
			_objectManager.updateState(_objects[p_objectEntity], p_objectEntity, p_state);
		}//else, is it view, do this...  etc
		else if (_views[p_objectEntity] != null)
		{
			_viewManager.updateState(_views[p_objectEntity], p_objectEntity, p_state);
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
	
	override inline public function updateFormState ( p_objectEntity:IGameEntity, p_state:String):Void
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