/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, November 2013
 */

 package tools.spark.sliced.services.std.display.renderers.core.platform;

 
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
import tools.spark.sliced.services.std.display.renderers.core.A3DRenderer;
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
 * ...
 * @author Aris Kostakos
 */
class AAway3DRenderer extends A3DRenderer
{
	private var _views:Map<IGameEntity,View3D>;
	private var _scenes:Map<IGameEntity,Scene3D>;
	private var _cameras:Map<IGameEntity,Camera3D>;
	private var _objectContainers:Map<IGameEntity,ObjectContainer3D>;
	
	
	
	private function new()
	{
		//Abstract class, private constructor
		super();

		_aAway3dRendererInit();
	}

	inline private function _aAway3dRendererInit():Void
	{
		_views = new Map<IGameEntity,View3D>();
		_scenes = new Map<IGameEntity,Scene3D>();
		_cameras = new Map<IGameEntity,Camera3D>();
		_objectContainers = new Map<IGameEntity,ObjectContainer3D>();
	}
	
	override public function renderView ( p_viewEntity:IGameEntity):Void
	{
		Console.warn("AAway3DRenderer rendering View: " + p_viewEntity.getState('name'));
		
		//render a view
		_views[p_viewEntity].render();
	}
	
	////////////////////////////////////////// VIEW //////////////////////////////////////////
	
	override public function addView ( p_viewEntity:IGameEntity):Void
	{
		if (_views[p_viewEntity] != null)
		{
			Console.warn("View " + p_viewEntity.getState('name') + " has already been added to this Away3DRenderer. Ignoring...");
		}
		else
		{
			_views[p_viewEntity] = _createView(p_viewEntity);
		}
	}
	
	private function _createView(p_viewEntity:IGameEntity):View3D
	{
		var l_view3D:View3D = new View3D();
		
		_updateView(l_view3D, p_viewEntity);
		
		return l_view3D;
	}
	
	inline private function _updateView(l_view3D:View3D,p_viewEntity:IGameEntity):Void
	{
		_updateViewState_scene(l_view3D, p_viewEntity);
		_updateViewState_camera(l_view3D, p_viewEntity);
	}
	
	inline private function _updateViewState_scene(l_view3D:View3D,p_viewEntity:IGameEntity):Void
	{
		var l_sceneEntity:IGameEntity = p_viewEntity.getState('scene');
		
		//If the Scene doesn't exist, create it
		if (_scenes[l_sceneEntity] == null) 
		{
			_scenes[l_sceneEntity] = _createScene(l_sceneEntity);
		}
		
		l_view3D.scene = _scenes[l_sceneEntity];
	}
	
	inline private function _updateViewState_camera(l_view3D:View3D,p_viewEntity:IGameEntity):Void
	{
		var l_cameraEntity:IGameEntity = p_viewEntity.getState('camera');
		
		//If the Camera doesn't exist, create it
		if (_cameras[l_cameraEntity] == null) 
		{
			_cameras[l_cameraEntity] = _createCamera(l_cameraEntity);
		}
		
		l_view3D.camera = _cameras[l_cameraEntity];
	}
	

	////////////////////////////////////////// SCENE //////////////////////////////////////////
	
	//You can't add/remove a Scene, just assign it to a View (so, updateViewState covers that)
	
	private function _createScene(p_sceneEntity:IGameEntity):Scene3D
	{
		var l_scene3D:Scene3D = new Scene3D();
		
		
		//FOR EACH ENTITY CHILD INSIDE SCENE
			//addEntity    (which in turn does a _createEntity..)
		
		//delete me
		
		var l_geometry:SphereGeometry = new SphereGeometry();
		var l_material:ColorMaterial = new ColorMaterial(0xFF0000);
		var l_mesh:Mesh = new Mesh(l_geometry, l_material);
		
		l_scene3D.addChild(l_mesh);
		
		//end of delete me
		
		return l_scene3D;
	}
	
	////////////////////////////////////////// CAMERA //////////////////////////////////////////
	
	//You can't add/remove a Camera, just assign it to a View (so, updateViewState covers that)
	
	private function _createCamera(p_cameraEntity:IGameEntity):Camera3D
	{
		var l_create3D:Camera3D = new Camera3D();
		
		
		return l_create3D;
	}
	
	////////////////////////////////////////// OBJECT CONTAINER //////////////////////////////////////////
	
	public function addObjectContainer( p_rootEntity:IGameEntity):Void
	{
		
	}
	
	
	
	
	
	
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
	
	
	public function render ( p_viewEntity:IGameEntity):Void
	{
		//render a view
		//_viewPointerSet[p_logicalView].render();
		//Console.warn("2.5 ARenderer rendering View: " + p_viewEntity.getState('name'));
		//Console.info("away3d render request");
	}
	
	
	override private function _createScene(p_logicalScene:Scene3D):Void
	{
		_scenePointerSet.set(p_logicalScene, new away3d.containers.Scene3D());
	}
	

	override private function _createCamera(p_logicalCamera:Camera3D):Void
	{
		_cameraPointerSet.set(p_logicalCamera, new away3d.cameras.Camera3D());
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