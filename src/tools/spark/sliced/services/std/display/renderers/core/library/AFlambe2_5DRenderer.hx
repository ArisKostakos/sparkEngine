/* Copyritools.spark.sliced.services.std.display.renderers.core.libraryng of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, November 2013
 */

 package tools.spark.sliced.services.std.display.renderers.core.library;

//import tools.spark.framework.pseudo3d.flambe.FlambeView;
import tools.spark.sliced.services.std.display.renderers.core.dimension.A2_5DRenderer;
import flambe.platform.InternalGraphics;
import flambe.platform.Platform;
import flambe.platform.Renderer;
import tools.spark.sliced.services.std.display.renderers.interfaces.ILibrarySpecificRenderer;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;


/**
 * This abstraction level of the Renderer will always act as a mediator between its managers
 * @author Aris Kostakos
 */
class AFlambe2_5DRenderer extends A2_5DRenderer implements ILibrarySpecificRenderer
{
	private var _platform:Platform;
	private var _internalGraphics:InternalGraphics;
	
	//private var _viewPointerSet:Map<View3D,IPseudoView>;
	//private var _scenePointerSet:Map<Scene3D,IPseudoScene>;
	//private var _entityPointerSet:Map<ObjectContainer3D,IPseudoEntity>;
	//private var _cameraPointerSet:Map<Camera3D,IPseudoCamera>;
	
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
		
		//uses3DEngine = false;
		
		//_viewPointerSet = new Map<View3D,IPseudoView>();
		//_scenePointerSet = new Map<Scene3D,IPseudoScene>();
		//_entityPointerSet = new Map<ObjectContainer3D,IPseudoEntity>(); 
		//_cameraPointerSet = new Map<Camera3D,IPseudoCamera>();
	}
	
	public function renderView ( p_viewEntity:IGameEntity):Void
	{
		//render a view
		//_viewPointerSet[p_logicalView].render();
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
		return null;
	}
	
	public function createScene ( p_sceneEntity:IGameEntity):Dynamic
	{
		return null;
	}
	
	public function createCamera ( p_cameraEntity:IGameEntity):Dynamic
	{
		return null;
	}
	
	public function createObject ( p_objectEntity:IGameEntity):Dynamic
	{
		return null;
	}
	
	
	/*
	
	public function destroyView ( p_viewEntity:IGameEntity):Void
	{
		
	}
	
	override private function _createView(p_logicalView:View3D):Void
	{
		_viewPointerSet.set(p_logicalView, new FlambeView(_internalGraphics));
	}
	
	
	
	
	override private function _hasView(p_logicalView:View3D):Bool { return _viewPointerSet.exists(p_logicalView); }
	override private function _hasScene(p_logicalScene:Scene3D):Bool { return _scenePointerSet.exists(p_logicalScene); }
	override private function _hasCamera(p_logicalCamera:Camera3D):Bool { return _cameraPointerSet.exists(p_logicalCamera); }
	override private function _hasEntity(p_logicalObjectContainer:ObjectContainer3D):Bool { return _entityPointerSet.exists(p_logicalObjectContainer); }
	
	
	*/
	
	
	/*
	override private function _createCamera(p_logicalCamera:Camera3D):Void
	{
		_cameraPointerSet.set(p_logicalCamera, new PseudoCamera());
	}
	
	override private function _validateCamera(p_logicalCamera:Camera3D):Void
	{
		_cameraPointerSet[p_logicalCamera].x = p_logicalCamera.x;
		_cameraPointerSet[p_logicalCamera].y = p_logicalCamera.y;
		_cameraPointerSet[p_logicalCamera].z = p_logicalCamera.z;
		_cameraPointerSet[p_logicalCamera].rotationX = p_logicalCamera.rotationX;
		_cameraPointerSet[p_logicalCamera].rotationY = p_logicalCamera.rotationY;
		_cameraPointerSet[p_logicalCamera].rotationZ = p_logicalCamera.rotationZ;
		//_cameraPointerSet[p_logicalCamera].fieldOfView = p_logicalCamera.fieldOfView;
	}
	
	override private function _validateView(p_logicalView:View3D):Void
	{
		_viewPointerSet[p_logicalView].camera = _cameraPointerSet[p_logicalView.camera];
		_viewPointerSet[p_logicalView].scene = _scenePointerSet[p_logicalView.scene];
		_viewPointerSet[p_logicalView].width = p_logicalView.width;
		_viewPointerSet[p_logicalView].height = p_logicalView.height;
		_viewPointerSet[p_logicalView].x = p_logicalView.x;
		_viewPointerSet[p_logicalView].y = p_logicalView.y;

		_viewPointerSet[p_logicalView].validate();
		//temp add childs
		//_viewPointerSet[p_logicalView].addChild(_scenePointerSet[p_logicalView.logicalScene]);
	}
	
	override private function _createScene(p_logicalScene:Scene3D):Void
	{
		_scenePointerSet.set(p_logicalScene, new PseudoScene());
	}
	
	override private function _validateScene(p_logicalScene:Scene3D):Void
	{
		
	}
	
	//@todo: parent may be an entity too not just a scene
	override private function _createEntity(p_logicalEntity:ObjectContainer3D, p_logicalScene:Scene3D):Void
	{
		_entityPointerSet.set(p_logicalEntity, new PseudoEntity());
		_entityPointerSet[p_logicalEntity].spriteUrl = p_logicalEntity.assetType;
		_scenePointerSet[p_logicalScene].addChild(_entityPointerSet[p_logicalEntity]);
	}
	
	//@todo: parent may be an entity too not just a scene
	override private function _validateEntity(p_logicalEntity:ObjectContainer3D, p_logicalScene:Scene3D):Void
	{
		_entityPointerSet[p_logicalEntity].x = p_logicalEntity.x;
		_entityPointerSet[p_logicalEntity].y = p_logicalEntity.y;
		_entityPointerSet[p_logicalEntity].z = p_logicalEntity.z;
		_entityPointerSet[p_logicalEntity].rotationX = p_logicalEntity.rotationX;
		_entityPointerSet[p_logicalEntity].rotationY = p_logicalEntity.rotationY;
		_entityPointerSet[p_logicalEntity].rotationZ = p_logicalEntity.rotationZ;
		_entityPointerSet[p_logicalEntity].velX = p_logicalEntity.velX;
		_entityPointerSet[p_logicalEntity].velY = p_logicalEntity.velY;
		_entityPointerSet[p_logicalEntity].velZ = p_logicalEntity.velZ;
	}
	*/
}