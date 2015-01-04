/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, November 2013
 */

 package tools.spark.sliced.services.std.display.renderers.core.library;

 
import away3d.cameras.Camera3D;
import away3d.containers.ObjectContainer3D;
import away3d.containers.Scene3D;
import away3d.containers.View3D;
import away3d.entities.Mesh;
import away3d.lights.DirectionalLight;
import away3d.materials.ColorMaterial;
import away3d.materials.lightpickers.StaticLightPicker;
import away3d.primitives.SphereGeometry;
import tools.spark.framework.Assets;
import tools.spark.sliced.services.std.display.managers.core.Away3DCameraManager;
import tools.spark.sliced.services.std.display.managers.core.Away3DObjectManager;
import tools.spark.sliced.services.std.display.managers.core.Away3DSceneManager;
import tools.spark.sliced.services.std.display.managers.core.Away3DViewManager;
import tools.spark.sliced.services.std.display.renderers.core.dimension.A3DRenderer;
import tools.spark.sliced.services.std.display.renderers.interfaces.ILibrarySpecificRenderer;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;


#if flash
	import flash.display.Bitmap;
	import flash.net.URLRequest;
	import flash.geom.Vector3D;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
#else
	import js.html.ImageElement;
	import away3d.core.geom.Vector3D;
	import away3d.net.URLRequest;
	import away3d.net.IMGLoader;
	import away3d.events.Event;
	import away3d.textures.HTMLImageElementTexture;
#end





/**
 * This abstraction level of the Renderer will always act as a mediator between its managers
 * @author Aris Kostakos
 */
class AAway3DRenderer extends A3DRenderer implements ILibrarySpecificRenderer
{
	private var _views:Map<IGameEntity,View3D>;
	private var _scenes:Map<IGameEntity,Scene3D>;
	private var _cameras:Map<IGameEntity,Camera3D>;
	private var _objects:Map<IGameEntity,ObjectContainer3D>;
	
	private var _viewManager:Away3DViewManager;
	private var _sceneManager:Away3DSceneManager;
	private var _cameraManager:Away3DCameraManager;
	private var _objectManager:Away3DObjectManager;
	
	private function new()
	{
		//Abstract class, private constructor
		super();

		_aAway3dRendererInit();
	}

	inline private function _aAway3dRendererInit():Void
	{
		//@THINK: keep this? or just one map to rule them all??
		_views = new Map<IGameEntity,View3D>();
		_scenes = new Map<IGameEntity,Scene3D>();
		_cameras = new Map<IGameEntity,Camera3D>();
		_objects = new Map<IGameEntity,ObjectContainer3D>();
		
		_viewManager = new Away3DViewManager(this);
		_sceneManager = new Away3DSceneManager(this);
		_cameraManager = new Away3DCameraManager(this);
		_objectManager = new Away3DObjectManager(this);
	}
	
	public function renderView ( p_viewEntity:IGameEntity):Void
	{
		//Console.warn("AAway3DRenderer rendering View: " + p_viewEntity.getState('name'));
		
		//render a view
		_views[p_viewEntity].render();
	}
	

	public function createView ( p_viewEntity:IGameEntity):Dynamic
	{
		if (_views[p_viewEntity] != null)
			Console.warn("View " + p_viewEntity.getState('name') + " has already been added to this Away3DRenderer. Ignoring...");
		else
			_views[p_viewEntity] = cast(_viewManager.create(p_viewEntity),View3D);
		
		return _views[p_viewEntity];
	}
	
	public function createScene ( p_sceneEntity:IGameEntity):Dynamic
	{
		if (_scenes[p_sceneEntity] != null)
			Console.warn("Scene " + p_sceneEntity.getState('name') + " has already been added to this Away3DRenderer. Ignoring...");
		else
			_scenes[p_sceneEntity] = cast(_sceneManager.create(p_sceneEntity),Scene3D);
		
		return _scenes[p_sceneEntity];
	}
	
	public function createCamera ( p_cameraEntity:IGameEntity):Dynamic
	{
		if (_cameras[p_cameraEntity] != null)
			Console.warn("Camera " + p_cameraEntity.getState('name') + " has already been added to this Away3DRenderer. Ignoring...");
		else
			_cameras[p_cameraEntity] = cast(_cameraManager.create(p_cameraEntity),Camera3D);

		return _cameras[p_cameraEntity];
	}
	
	public function createObject ( p_objectEntity:IGameEntity):Dynamic
	{
		if (_objects[p_objectEntity] != null)
			Console.warn("Object " + p_objectEntity.getState('name') + " has already been added to this Away3DRenderer. Ignoring...");
		else
			_objects[p_objectEntity] = cast(_objectManager.create(p_objectEntity),ObjectContainer3D);
		
		return _objects[p_objectEntity];
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
				Console.warn("AAway3DRenderer: Unhandled add child request: " + p_parentEntity.getState('displayType'));
		}
	}
	
	inline public function updateState ( p_objectEntity:IGameEntity, p_state:String):Void
	{
		//maybe check its display type here..
		
		//is it object, do this:
		if (_objects[p_objectEntity] != null)
		{
			_objectManager.updateState(_objects[p_objectEntity], p_objectEntity, p_state);
		}
		
		//else, is it view, do this...  etc
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
	
	/*
	public function destroyView ( p_viewEntity:IGameEntity):Void
	{
		
	}
	*/

	
	
	
	
	
	/*
	private function _deleteMe(p_view3D:View3D):Void
	{
		//p_view3D.scene = new Scene3D();
		//p_view3D.camera = new Camera3D();
		
		//away3d ts bug?
		//p_view3D.x = 0;// p_logicalView.x;
		//p_view3D.y = 0;// p_logicalView.y;
		//p_view3D.width = 640;// p_logicalView.width;
		//p_view3D.height = 480;// p_logicalView.height;
		
		//if (_deleteMeMainLight == null) _deletemeCreateLight(p_view3D.scene);
		
		var l_geometry:SphereGeometry = new SphereGeometry();
		var l_material:ColorMaterial = new ColorMaterial(0xFF0000);
		//l_material.lightPicker = _deleteMeMainLightpicker;
		var l_mesh:Mesh = new Mesh(l_geometry, l_material);
		
		p_view3D.scene.addChild(l_mesh);
	}
	
	private var _deleteMeMainLight:DirectionalLight;
	private var _deleteMeMainLightpicker:StaticLightPicker;
	
	private function _deletemeCreateLight(p_myScene:Scene3D):Void
	{
		var directionalLight:DirectionalLight = new DirectionalLight();
		directionalLight.ambientColor = 0xFFFFFF;
		directionalLight.color = 0xFFFFFF;
		directionalLight.ambient = 0.39;
		directionalLight.castsShadows = false;
		//directionalLight.shaderPickingDetails = false;
		directionalLight.specular = 0.8;
		directionalLight.diffuse = 0.6;
		directionalLight.name = "MainLight";
		directionalLight.direction = new Vector3D(-0.7376268918178536, -0.4171149406714452, -0.5309629881034924);
		p_myScene.addChild(directionalLight);
		
		_deleteMeMainLight = directionalLight;
		
		_deleteMeMainLightpicker = new StaticLightPicker([_deleteMeMainLight]);
	}
	
	

	
	override private function _validateCamera(p_logicalCamera:Camera3D):Void
	{
		_cameraPointerSet.get(p_logicalCamera).x = p_logicalCamera.x;
		_cameraPointerSet.get(p_logicalCamera).y = p_logicalCamera.y;
		_cameraPointerSet.get(p_logicalCamera).z = p_logicalCamera.z;
		_cameraPointerSet.get(p_logicalCamera).lookAt(new Vector3D(0, 0, 0));
		//_cameraPointerSet.get(p_logicalCamera).yaw(p_logicalCamera.pitch);
		//_cameraPointerSet.get(p_logicalCamera).pitch( p_logicalCamera.pitch);
		//_cameraPointerSet.get(p_logicalCamera).roll(p_logicalCamera.roll);
	}
	
	
	
	//@todo: parent may be an entity too not just a scene
	override private function _createEntity(p_logicalObjectContainer3D:ObjectContainer3D, p_logicalScene:Scene3D):Void
	{
		//Console.warn("entity created");
		
		
		
		//var l_material:away3d.materials.TextureMaterial();
		
		if (_deleteMeTextureMaterial != null)
		{
			var l_sprite_3D:away3d.entities.Sprite3D;
			//var l_spriteMaterial:away3d.materials.TextureMaterial = new away3d.materials.TextureMaterial(_deleteMeTexture2DBase);
			l_sprite_3D = new away3d.entities.Sprite3D(_deleteMeTextureMaterial,100,100);
			
			_entityPointerSet.set(p_logicalObjectContainer3D, l_sprite_3D);
			_scenePointerSet[p_logicalScene].addChild(_entityPointerSet[p_logicalObjectContainer3D]);
			
			Console.warn("entity created FOR REAL");
		}
		*/
		/*
		if (_deleteMeMainLight == null) _deletemeCreateLight(p_logicalScene);
		
		var l_logicalMesh:Mesh = cast(p_logicalEntity, Mesh);
		Console.warn("meshType_3d: " + l_logicalMesh.meshType_3d);
		Console.warn("mesh_3d: " + l_logicalMesh.mesh_3d);
		
		Console.warn("materialType_3d: " + l_logicalMesh.materialType_3d);
		Console.warn("material_3d: " + l_logicalMesh.material_3d);
		
		var l_mesh:away3d.entities.Mesh;
		var l_geometry:away3d.core.base.Geometry=null;
		var l_material:away3d.materials.MaterialBase=null;
		
		if (l_logicalMesh.meshType_3d == "Primitive")
		{
			if (l_logicalMesh.mesh_3d == "Sphere")
			{
				l_geometry = new away3d.primitives.SphereGeometry();
			}
		}
		
		if (l_logicalMesh.materialType_3d == "Color")
		{
			l_material = new away3d.materials.ColorMaterial(Std.parseInt(l_logicalMesh.material_3d));
			l_material.lightPicker = _deleteMeMainLightpicker;
		}
		l_mesh = new Mesh(l_geometry, l_material);
		//l_mesh.visible = false;
		_entityPointerSet.set(p_logicalEntity, l_mesh);
		_scenePointerSet[p_logicalScene].addChild(_entityPointerSet[p_logicalEntity]);
		*//*
	}
	
	//@todo: parent may be an entity too not just a scene
	override private function _validateEntity(p_logicalObjectContainer3D:ObjectContainer3D, p_logicalScene:Scene3D):Void
	{
		//Console.warn("validating entity...");
		if (_deleteMeTextureMaterial == null) return;
		
		_entityPointerSet.get(p_logicalObjectContainer3D).x = p_logicalObjectContainer3D.x;
		_entityPointerSet.get(p_logicalObjectContainer3D).y = p_logicalObjectContainer3D.y;
		_entityPointerSet.get(p_logicalObjectContainer3D).z = p_logicalObjectContainer3D.z;
		//_entityPointerSet.get(p_logicalEntity).yaw(p_logicalEntity.yaw);
		//_entityPointerSet.get(p_logicalEntity).pitch(p_logicalEntity.pitch);
		//_entityPointerSet.get(p_logicalEntity).roll(p_logicalEntity.roll);
		*//*
		_entityPointerSet.get(p_logicalEntity).rotationZ=p_logicalEntity.yaw;
		_entityPointerSet.get(p_logicalEntity).rotationX=p_logicalEntity.pitch;
		_entityPointerSet.get(p_logicalEntity).roll(p_logicalEntity.roll);
		*//*
	}
	
	*/
}