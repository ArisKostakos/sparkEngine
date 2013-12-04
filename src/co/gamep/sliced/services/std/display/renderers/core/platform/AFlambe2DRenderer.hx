/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, November 2013
 */

 package co.gamep.sliced.services.std.display.renderers.core.platform;

import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalView;
import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalScene;
import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalCamera;
import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalEntity;
import co.gamep.sliced.services.std.display.renderers.core.ARenderer;
import co.gamep.sliced.services.std.display.renderers.interfaces.IRenderer;
import flambe.display.ImageSprite;
import flambe.Entity;
import flambe.platform.InternalGraphics;
import flambe.platform.Platform;
import flambe.platform.Renderer;
import flambe.display.Sprite;
import flambe.System;
import flambe.display.BlendMode;
import co.gamep.framework.Assets;


/**
 * ...
 * @author Aris Kostakos
 */
class AFlambe2DRenderer extends ARenderer
{
	private var _viewPointerSet:Map<ILogicalView,Entity>;
	private var _scenePointerSet:Map<ILogicalScene,Entity>;
	private var _entityPointerSet:Map<ILogicalEntity,Entity>;
	private var _cameraPointerSet:Map<ILogicalCamera,Entity>;
	private var _platform:Platform;
	private var _internalGraphics:InternalGraphics;
	
	public function new() 
	{
		super();
		
		_flambeRendererInit();
	}
	
	inline private function _flambeRendererInit():Void
	{
		uses3DEngine = false;
		
		_viewPointerSet = new Map<ILogicalView,Entity>();
		_scenePointerSet = new Map<ILogicalScene,Entity>();
		_entityPointerSet = new Map<ILogicalEntity,Entity>();
		_cameraPointerSet = new Map<ILogicalCamera,Entity>();
		
        _internalGraphics = _platform.getRenderer().graphics;
		
		if (_internalGraphics == null)
		{
			Console.error("Flambe renderer does NOT have internal graphics!");
		}
	}
	
	override public function render ( p_logicalView:ILogicalView):Void
	{
		//render a view
		Sprite.render(_viewPointerSet[p_logicalView], _internalGraphics);
		
		//Console.info("Flambe render request");
	}
	
	
	override private function _createView(p_logicalView:ILogicalView):Void
	{
		_viewPointerSet.set(p_logicalView, new Entity());
		//_viewPointerSet[p_logicalView].camera = _cameraPointerSet[p_logicalView.logicalCamera];
		//_viewPointerSet[p_logicalView].width = p_logicalView.width;
		//_viewPointerSet[p_logicalView].height = p_logicalView.height;
		//WHAT ABOUT X AND Y??????????

		//temp add childs
		_viewPointerSet[p_logicalView].addChild(_scenePointerSet[p_logicalView.logicalScene]);
		
		//@todo: IS THIS NEEDED?????????????????????????
		//System.root.addChild(_viewPointerSet[p_logicalView]);
	}
	
	override private function _validateView(p_logicalView:ILogicalView):Void
	{
		//WHAT ABOUT X AND Y??????????
	}
	
	
	override private function _createScene(p_logicalScene:ILogicalScene):Void
	{
		_scenePointerSet.set(p_logicalScene, new Entity());
	}
	
	override private function _validateScene(p_logicalScene:ILogicalScene):Void
	{
		
	}
	
	override private function _createCamera(p_logicalCamera:ILogicalCamera):Void
	{
		//_cameraPointerSet.set(p_logicalCamera, new Camera3D());
	}
	
	override private function _validateCamera(p_logicalCamera:ILogicalCamera):Void
	{
		/*
		_cameraPointerSet.get(p_logicalCamera).x = p_logicalCamera.x;
		_cameraPointerSet.get(p_logicalCamera).y = p_logicalCamera.y;
		_cameraPointerSet.get(p_logicalCamera).z = p_logicalCamera.z;
		_cameraPointerSet.get(p_logicalCamera).yaw(p_logicalCamera.yaw);
		_cameraPointerSet.get(p_logicalCamera).pitch( p_logicalCamera.pitch);
		_cameraPointerSet.get(p_logicalCamera).roll(p_logicalCamera.roll);
		*/
	}
	
	//@todo: parent may be an entity too not just a scene
	override private function _createEntity(p_logicalEntity:ILogicalEntity, p_logicalScene:ILogicalScene):Void
	{
		_entityPointerSet.set(p_logicalEntity, new Entity().add(new ImageSprite(Assets.images.getTexture("ball"))));
		_scenePointerSet[p_logicalScene].addChild(_entityPointerSet[p_logicalEntity]);
		
		var myImage:ImageSprite = new ImageSprite(Assets.images.getTexture("lion"));
		myImage.setScale(0.1);
		myImage.blendMode = BlendMode.Copy;
		_entityPointerSet[p_logicalEntity].addChild(new Entity().add(myImage)); // add on top of stage
	}
	
	//@todo: parent may be an entity too not just a scene
	override private function _validateEntity(p_logicalEntity:ILogicalEntity, p_logicalScene:ILogicalScene):Void
	{
        var l_sprite:Sprite = _entityPointerSet[p_logicalEntity].get(Sprite);
		
		l_sprite.x._ = p_logicalEntity.x;
		l_sprite.y._ = p_logicalEntity.y;
		//l_sprite.z._ = p_logicalEntity.z;

		//_entityPointerSet.get(p_logicalEntity).yaw(p_logicalEntity.yaw);
		//_entityPointerSet.get(p_logicalEntity).pitch(p_logicalEntity.pitch);
		//_entityPointerSet.get(p_logicalEntity).roll(p_logicalEntity.roll);
		
		//_entityPointerSet.get(p_logicalEntity).rotationZ=p_logicalEntity.yaw;
		//_entityPointerSet.get(p_logicalEntity).rotationX=p_logicalEntity.pitch;
		//_entityPointerSet.get(p_logicalEntity).roll(p_logicalEntity.roll);
	}
	
	override private function _hasView(p_logicalView:ILogicalView):Bool { return _viewPointerSet.exists(p_logicalView); }
	override private function _hasScene(p_logicalScene:ILogicalScene):Bool { return _scenePointerSet.exists(p_logicalScene); }
	override private function _hasCamera(p_logicalCamera:ILogicalCamera):Bool { return _cameraPointerSet.exists(p_logicalCamera); }
	override private function _hasEntity(p_logicalEntity:ILogicalEntity):Bool { return _entityPointerSet.exists(p_logicalEntity); }
}