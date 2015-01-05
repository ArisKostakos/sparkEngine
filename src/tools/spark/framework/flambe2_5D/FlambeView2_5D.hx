/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, November 2014
 */

package tools.spark.framework.flambe2_5D;

import flambe.display.FillSprite;
import flambe.platform.InternalGraphics;
import flambe.math.Rectangle;
import tools.spark.framework.space2_5D.core.AView2_5D;
import flambe.Entity;
import flambe.display.Sprite;
import flambe.display.BlendMode;
import tools.spark.framework.space2_5D.interfaces.ICamera2_5D;
import tools.spark.framework.space2_5D.interfaces.IEntity2_5D;
import tools.spark.framework.space2_5D.interfaces.IScene2_5D;
import flambe.System;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;

/**
 * ...
 * @author Aris Kostakos
 */
class FlambeView2_5D extends AView2_5D
{
	private var _flambeGraphics:InternalGraphics;
	private var _instanceView:Entity;
	private var _instanceScene:Entity;
	
	public function new(p_gameEntity:IGameEntity, p_flambeGraphics:InternalGraphics) 
	{
		super(p_gameEntity);
		
		_flambeGraphics = p_flambeGraphics;
		
		_initFlambeView2_5D();
	}
	
	private inline function _initFlambeView2_5D():Void
	{
		_instanceView = new Entity();
		
		//var l_viewSprite:FillSprite = new FillSprite(0x00ff00,1024,580);
		var l_viewSprite:Sprite = new Sprite();
		l_viewSprite.blendMode = BlendMode.Copy;
		//l_viewSprite.scissor = new Rectangle(0, 0, 640, 480);
		//l_viewSprite.x._ = 0;
		//l_viewSprite.y._ = 0;
		_instanceView.add(l_viewSprite);
		
		//Add flambe views that are active on root, for mouse listeners, physics, etc.. make sure you remove them if hidden, not active. remember this is for physics/event listeners only.. view will still render and be visible even if removed from the root
		System.root.addChild(_instanceView);
	}
	
	override public function render():Void
	{
		//render
		Sprite.render(_instanceView, _flambeGraphics);
	}
	
	override private function set_camera( p_value : ICamera2_5D ) : ICamera2_5D 
	{
		//If the camera is already attached to this view, do nothing
		if (camera == p_value)
			return camera;
			
		if (p_value == null)
		{
			camera = null;
			//_disposeCurrentCamera();
			_updateCurrentView();
			return null;
		}
			
		//instanciate camera
		camera = p_value;
		camera.createInstance(this);
		
		//UPDATE VIEW
		_updateCurrentView();
		
		return camera;
    }
	
	override private function set_scene( p_value : IScene2_5D ) : IScene2_5D 
	{
		//If the scene is already attached to this view, do nothing
		if (scene == p_value)
			return scene;
		
		//This means, everything should be destroyed.. except, if you want to keep them and just 'remove them from stage'
		if (p_value == null)
		{
			scene = null;
			_disposeCurrentScene();
			_updateCurrentView();
			return null;
		}
			
		//@todo: remove previous scene, possibly dispose a lot of stuff..
		//if I actually do NOT remove the entity instances of a scene of a view here, then when that scene is readded below,
		//check if their entities correspond with this view before creating them again
		//if (scene!=null)
		//...
		
		//Instanciate
		scene = p_value;
		_instanciateCurrentScene();
		
		//UPDATE VIEW
		_updateCurrentView();
		
        return scene;
    }
	
	
	private function _instanciateCurrentScene():Void
	{
		_instanceScene = cast(scene.createInstance(this), Entity);
		
		for (f_childEntity in scene.children)
		{
			_instanceScene.addChild(cast(f_childEntity.createInstance(this),Entity));
		}
	}
	
	private function _updateCurrentView():Void
	{
		//If scene or camera is not found, if scene instance in on a view, remove it, then quit
		if (scene == null || camera == null)
		{
			//if it's added already, remove it
			if (_instanceView.firstChild!=null)
				_instanceView.removeChild(_instanceView.firstChild);
				
			return;
		}
		
		//Update Scene
		
		//If scene not added yet, add it
		if (_instanceView.firstChild==null)
			_instanceView.addChild(_instanceScene);
			
		//Update all of this view instances for its scene's children
		for (f_childEntity in scene.children)
		{
			f_childEntity.update(this);
		}
	}
	
	private function _disposeCurrentScene():Void
	{
		_instanceScene = null;
	}
}