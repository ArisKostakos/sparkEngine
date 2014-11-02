/* Copyritools.spark.sliced.services.std.display.renderers.core.libraryng of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, November 2013
 */

 package tools.spark.sliced.services.std.display.renderers.core.library;

import tools.spark.framework.pseudo3d.core.PseudoCamera;
import tools.spark.framework.pseudo3d.core.PseudoEntity;
import tools.spark.framework.pseudo3d.core.PseudoScene;
import tools.spark.framework.pseudo3d.flambe.FlambeView;
import tools.spark.framework.pseudo3d.interfaces.IPseudoCamera;
import tools.spark.framework.pseudo3d.interfaces.IPseudoEntity;
import tools.spark.framework.pseudo3d.interfaces.IPseudoScene;
import tools.spark.framework.pseudo3d.interfaces.IPseudoView;
import tools.spark.sliced.services.std.display.renderers.core.dimension.A2_5DRenderer;
import flambe.platform.InternalGraphics;
import flambe.platform.Platform;
import flambe.platform.Renderer;
import tools.spark.sliced.services.std.display.renderers.interfaces.ILibrarySpecificRenderer;
import tools.spark.sliced.services.std.logic.gde.core.GameEntity;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;


/**
 * This abstraction level of the Renderer will always act as a mediator between its managers
 * @author Aris Kostakos
 */
class AFlambe2_5DRenderer extends A2_5DRenderer implements ILibrarySpecificRenderer
{
	private var _platform:Platform;
	private var _internalGraphics:InternalGraphics;
	
	private var _views:Map<IGameEntity,FlambeView>;
	private var _scenes:Map<IGameEntity,PseudoScene>;
	private var _objects:Map<IGameEntity,PseudoEntity>;
	private var _cameras:Map<IGameEntity,PseudoCamera>;
	
	private function new() 
	{
		super();
		
		_flambeRendererInit();
	}
	
	inline private function _flambeRendererInit():Void
	{
        _internalGraphics = _platform.getRenderer().graphics;
		
		if (_internalGraphics == null)
		{
			Console.error("Flambe renderer does NOT have internal graphics!");
		}
		
		
		_views = new Map<IGameEntity,FlambeView>();
		_scenes = new Map<IGameEntity,PseudoScene>();
		_objects = new Map<IGameEntity,PseudoEntity>(); 
		_cameras = new Map<IGameEntity,PseudoCamera>();
	}
	
	public function renderView ( p_viewEntity:IGameEntity):Void
	{
		//render a view
		_views[p_viewEntity].render();
		//Console.warn("A2_5DRenderer rendering View: " + p_viewEntity.getState('name'));
		
		//TODO NEXT!!!!!!!!!!!!!!!!!!!!!
		//this will now render properly. put some entities to test it out and maybe override this for flambe 2.5 html, and make use of space2.5. Take snippets from Flambe View but be careful!
		//The way i link flambe view to the flambe 2.5html renderer right now is in AFlambe2_5renderer. do something similar. Also, mind invalidation this time!
	}
	
	public function updateState ( p_objectEntity:IGameEntity, p_state:String):Void
	{
		
	}

	
	
	public function createView ( p_viewEntity:IGameEntity):Dynamic
	{
		if (_views[p_viewEntity] != null)
			Console.warn("View " + p_viewEntity.getState('name') + " has already been added to this FlambeRenderer. Ignoring...");
		else
			_views[p_viewEntity] = new FlambeView(_internalGraphics);
		
			
		_views[p_viewEntity].camera = createCamera(new GameEntity());
		_views[p_viewEntity].scene = createScene(new GameEntity());
		_views[p_viewEntity].width = 640;
		_views[p_viewEntity].height = 480;
		_views[p_viewEntity].x = 0;
		_views[p_viewEntity].y = 0;

		_views[p_viewEntity].validate();
			
		return _views[p_viewEntity];
	}
	
	public function createScene ( p_sceneEntity:IGameEntity):Dynamic
	{
		if (_scenes[p_sceneEntity] != null)
			Console.warn("Scene " + p_sceneEntity.getState('name') + " has already been added to this FlambeRenderer. Ignoring...");
		else
			_scenes[p_sceneEntity] = new PseudoScene();
			
		_scenes[p_sceneEntity].addChild(createObject(new GameEntity()));
		
		return _scenes[p_sceneEntity];
	}
	
	public function createCamera ( p_cameraEntity:IGameEntity):Dynamic
	{
		if (_cameras[p_cameraEntity] != null)
			Console.warn("Camera " + p_cameraEntity.getState('name') + " has already been added to this FlambeRenderer. Ignoring...");
		else
			_cameras[p_cameraEntity] = new PseudoCamera();

		_cameras[p_cameraEntity].x = 0;
		_cameras[p_cameraEntity].y = 0;
		_cameras[p_cameraEntity].z = -300;
		_cameras[p_cameraEntity].rotationX = 0;
		_cameras[p_cameraEntity].rotationY = 0;
		_cameras[p_cameraEntity].rotationZ = 0;
		//_cameraPointerSet[p_logicalCamera].fieldOfView = p_logicalCamera.fieldOfView;
		
		
		return _cameras[p_cameraEntity];
	}
	
	public function createObject ( p_objectEntity:IGameEntity):Dynamic
	{
		if (_objects[p_objectEntity] != null)
			Console.warn("Object " + p_objectEntity.getState('name') + " has already been added to this FlambeRenderer. Ignoring...");
		else
			_objects[p_objectEntity] = new PseudoEntity();
		
		_objects[p_objectEntity].spriteUrl = "Ball.png";
		//_scenePointerSet[p_logicalScene].addChild(_objects[p_objectEntity]);
		
		_objects[p_objectEntity].x = 0;
		_objects[p_objectEntity].y = 0;
		_objects[p_objectEntity].z = 0;
		_objects[p_objectEntity].rotationX =0;
		_objects[p_objectEntity].rotationY = 0;
		_objects[p_objectEntity].rotationZ =0;
		_objects[p_objectEntity].velX = 0;
		_objects[p_objectEntity].velY =0;
		_objects[p_objectEntity].velZ =0;
		
		
		return _objects[p_objectEntity];
	}
	
	

	
}