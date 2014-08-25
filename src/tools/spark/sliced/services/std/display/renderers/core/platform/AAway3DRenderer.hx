/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, November 2013
 */

 package tools.spark.sliced.services.std.display.renderers.core.platform;

import tools.spark.framework.Assets;

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
/*
import away3d.lights.DirectionalLight;
import away3d.materials.ColorMaterial;
import away3d.materials.lightpickers.StaticLightPicker;
import away3d.materials.MaterialBase;
import away3d.primitives.SphereGeometry;
import away3d.entities.Entity;
*/
import tools.spark.sliced.services.std.display.logicalspace.cameras.Camera3D;
import tools.spark.sliced.services.std.display.logicalspace.containers.Scene3D;
import tools.spark.sliced.services.std.display.logicalspace.containers.View3D;
import tools.spark.sliced.services.std.display.logicalspace.containers.ObjectContainer3D;
import tools.spark.sliced.services.std.display.logicalspace.entities.Mesh;
import tools.spark.sliced.services.std.display.renderers.core.A3DRenderer;

/**
 * ...
 * @author Aris Kostakos
 */
class AAway3DRenderer extends A3DRenderer
{

	private var _viewPointerSet:Map<View3D,away3d.containers.View3D>;
	private var _scenePointerSet:Map<Scene3D,away3d.containers.Scene3D>;
	private var _entityPointerSet:Map<ObjectContainer3D,away3d.containers.ObjectContainer3D>;
	private var _cameraPointerSet:Map<Camera3D,away3d.cameras.Camera3D>;
	
	/////DELETE ME SECTION
	
	private var _deleteMeTextureMaterial:away3d.materials.TextureMaterial;
	//private var _deleteMeTextureMaterial:away3d.materials.ColorMaterial;
	
	#if flash
		private var _textureLoader:Loader;
		
		private function _onTextureComplete(event:Event):Void
		{
			var image:Bitmap = cast(_textureLoader.content,Bitmap);
			var texture:away3d.textures.BitmapTexture = new away3d.textures.BitmapTexture(image.bitmapData);
			_deleteMeTextureMaterial = new away3d.materials.TextureMaterial(texture);

			Console.warn("asset loaded!");
		}
		
		private function _deleteMeInit():Void
		{
			//_textureLoader = new Loader();
			//_textureLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, _onTextureComplete);
			//_textureLoader.load(new URLRequest("assets/images/AtomBlue.png"));
			
			//var image:Bitmap = cast(Assets.images.getFile("AtomBlue"),Bitmap);
			
			var bitmapData:BitmapData = new BitmapData(10, 10);
			
			var byteArray:ByteArray = new ByteArray();
			byteArray.writeUTFBytes(Assets.images.getFile("AtomsFile").toString());
			bitmapData.setPixels(new Rectangle(0, 0, 10, 10), byteArray);
			
			//bitmapData.setPixels(new Rectangle(0, 0, 10, 10), Assets.images.getTexture("AtomBlue").readPixels(0,0,10,10).getData());
		}
		
	#else
		private var _textureLoader:IMGLoader;
		
		private function _initMaterial(event:Event):Void
		{
			var image:ImageElement = _textureLoader.image;
			var texture:HTMLImageElementTexture = new HTMLImageElementTexture(image, false); // Create a texture
			_deleteMeTextureMaterial = new away3d.materials.TextureMaterial(texture, true, true, false); // Create a material
		
			
		}
		
		private function _deleteMeInit():Void
		{
			_textureLoader = new IMGLoader ();
			_textureLoader.addEventListener (Event.COMPLETE, _initMaterial, this); // Add event listener for image complete
			_textureLoader.load (new URLRequest ("assets/images/AtomBlue.png")); // start loading
			
			
			//var image:ImageElement = cast(Assets.images.getFile("AtomBlue"),
		}
	
	#end
	
	////END OF DELETE ME SECTION
	
	private function new()
	{
		//Abstract class, private constructor
		super();
		
		_aAway3dRendererInit();
		
		//_deleteMeInit();
	}

	inline private function _aAway3dRendererInit():Void
	{
		_viewPointerSet = new Map<View3D,away3d.containers.View3D>();
		_scenePointerSet = new Map<Scene3D,away3d.containers.Scene3D>();
		_entityPointerSet = new Map<ObjectContainer3D,away3d.containers.ObjectContainer3D>();
		_cameraPointerSet = new Map<Camera3D,away3d.cameras.Camera3D>();
	}
	
	override public function render ( p_logicalView:View3D):Void
	{
		//render a view
		_viewPointerSet[p_logicalView].render();
		
		//Console.info("away3d render request");
	}
	
	
	override private function _createView(p_logicalView:View3D):Void
	{
		_viewPointerSet.set(p_logicalView, new away3d.containers.View3D());
		_viewPointerSet[p_logicalView].scene = _scenePointerSet[p_logicalView.scene];
		_viewPointerSet[p_logicalView].camera = _cameraPointerSet[p_logicalView.camera];
		
		//away3d ts bug?
		_viewPointerSet[p_logicalView].x = 0;// p_logicalView.x;
		_viewPointerSet[p_logicalView].y = 0;// p_logicalView.y;
		_viewPointerSet[p_logicalView].width = 640;// p_logicalView.width;
		_viewPointerSet[p_logicalView].height = 480;// p_logicalView.height;
	}
	
	override private function _validateView(p_logicalView:View3D):Void
	{
		//WHAT ABOUT X AND Y??????????
	}
	
	
	override private function _createScene(p_logicalScene:Scene3D):Void
	{
		_scenePointerSet.set(p_logicalScene, new away3d.containers.Scene3D());
	}
	
	override private function _validateScene(p_logicalScene:Scene3D):Void
	{
		
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
	
	private var _deleteMeMainLight:away3d.lights.DirectionalLight;
	private var _deleteMeMainLightpicker:away3d.materials.lightpickers.StaticLightPicker;
	
	private function _deletemeCreateLight(p_logicalScene:Scene3D):Void
	{
		var directionalLight:away3d.lights.DirectionalLight = new away3d.lights.DirectionalLight();
		directionalLight.ambientColor = 0xFFFFFF;
		directionalLight.color = 0xFFFFFF;
		directionalLight.ambient = 0.39;
		directionalLight.castsShadows = false;
		//directionalLight.shaderPickingDetails = false;
		directionalLight.specular = 0.8;
		directionalLight.diffuse = 0.6;
		directionalLight.name = "MainLight";
		directionalLight.direction = new Vector3D(-0.7376268918178536, -0.4171149406714452, -0.5309629881034924);
		_scenePointerSet[p_logicalScene].addChild(directionalLight);
		
		_deleteMeMainLight = directionalLight;
		
		_deleteMeMainLightpicker = new away3d.materials.lightpickers.StaticLightPicker([_deleteMeMainLight]);
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
		*/
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
		/*
		_entityPointerSet.get(p_logicalEntity).rotationZ=p_logicalEntity.yaw;
		_entityPointerSet.get(p_logicalEntity).rotationX=p_logicalEntity.pitch;
		_entityPointerSet.get(p_logicalEntity).roll(p_logicalEntity.roll);
		*/
	}
	
	override private function _hasView(p_logicalView:View3D):Bool { return _viewPointerSet.exists(p_logicalView); }
	override private function _hasScene(p_logicalScene:Scene3D):Bool { return _scenePointerSet.exists(p_logicalScene); }
	override private function _hasCamera(p_logicalCamera:Camera3D):Bool { return _cameraPointerSet.exists(p_logicalCamera); }
	override private function _hasEntity(p_logicalObjectContainer3D:ObjectContainer3D):Bool { return _entityPointerSet.exists(p_logicalObjectContainer3D); }
}