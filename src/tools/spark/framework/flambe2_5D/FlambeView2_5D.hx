/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, November 2014
 */

package tools.spark.framework.flambe2_5D;

import flambe.display.FillSprite;
import flambe.platform.InternalGraphics;
import flambe.math.Rectangle;
import tools.spark.framework.layout.containers.Group;
import tools.spark.framework.space2_5D.core.AView2_5D;
import flambe.Entity;
import flambe.display.Sprite;
import flambe.display.BlendMode;
import tools.spark.framework.space2_5D.interfaces.ICamera2_5D;
import tools.spark.framework.space2_5D.interfaces.IEntity2_5D;
import tools.spark.framework.space2_5D.interfaces.IScene2_5D;
import flambe.System;
import tools.spark.framework.space2_5D.interfaces.IView2_5D;
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
		Console.error("Creating View: " + gameEntity.getState('name'));
		//flambe.System.external.call("console.log", [_instances[p_view2_5D]]);
		
		_instanceView = new Entity();
		
		
		//var l_viewSprite:FillSprite = new FillSprite(0x00ff00,1024,580);
		var l_viewSprite:Sprite = new Sprite();
		//l_viewSprite.blendMode = BlendMode.Copy; //so... without resetingVars in WebGL Renderer, this now can't be copy.. COPY IS WAY MORE EXPENSIVE THAN NORMAL!!!!!!!!
		//l_viewSprite.scissor = new Rectangle(0, 0, 640, 480);
		//l_viewSprite.x._ = 100;
		//l_viewSprite.y._ = 0;
		_instanceView.add(l_viewSprite);
		
		//Add flambe views that are active on root, for mouse listeners, physics, etc.. make sure you remove them if hidden, not active. remember this is for physics/event listeners only.. view will still render and be visible even if removed from the root
		if (gameEntity.getState('visible'))
			System.root.addChild(_instanceView);
	}
	
	//some dirty fixing.. trying to not create new views each time i add/remove them from Stage/StageArea
	public function enableCachedViewBack():Void
	{
		System.root.addChild(_instanceView);
	}
	
	override public function destroy():Void
	{
		//until we actually destroy things, i just remove it from root (for physics etc).. its not getting rendered anyway if its activeViewReference gets removed..
		System.root.removeChild(_instanceView);
	}
	
	override public function render():Void
	{
		//render
		if (gameEntity.getState('visible'))	//I cannot describe how BAD this really is!
			Sprite.render(_instanceView, _flambeGraphics);
	}
	
	public function setVisible(p_value:Bool):Void
	{
		if (p_value)
			System.root.addChild(_instanceView);
		else
			System.root.removeChild(_instanceView);
	}
	
	//i think this belongs to AView2_5D instead.. i don't see any flambe relevant code...
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
			
		//attach camera
		camera = p_value;
		camera.attachToView(this);
		
		//UPDATE VIEW
		_updateCurrentView();
		
		return camera;
    }
	
	//i think this belongs to AView2_5D instead.. i don't see any flambe relevant code...
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
		if (scene!=null)
		{
			scene = null;
			_disposeCurrentScene();
		}
		
		//Instanciate current scene
		scene = p_value;
		_instanceScene = cast(scene.createInstance(this), Entity);
		
		//LAYOUT MANAGER
		//if (gameEntity.getState('layoutable') == true)
			//..
		
		//UPDATE VIEW
		_updateCurrentView();
		
        return scene;
    }
	
	//NEXT
	//then, see how we will add children when called by the renderers, dynamically.. later on..
	//END NEXT
	
	
	//i think this belongs to AView2_5D instead.. i don't see any flambe relevant code... or is there...
	//or maybe there is.. just override and keep the for loop in AView2_5D instead
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
			
			
		//Update it
		scene.update(this);
	}
	
	private function _disposeCurrentScene():Void
	{
		_instanceScene = null;
		
		//remove it from view
		_instanceView.disposeChildren(); //COMMENT THIS OUT??? 29-6-2016 , I'm trying to keep scenes for getting destroyed between tabs.. too hard! I give up for now..
	}
	
	override public function setPosSize(?p_x:Null<Float>, ?p_y:Null<Float>, ?p_width:Null<Float>, ?p_height:Null<Float>, ?p_view:IView2_5D):Void
	{
		var l_viewSprite:Sprite = _instanceView.get(Sprite);
		
		if (p_x != null) l_viewSprite.x._ = p_x;
		if (p_y != null) l_viewSprite.y._ = p_y;
		if (p_width != null && p_height != null)
			l_viewSprite.scissor = new Rectangle(0, 0, p_width, p_height);
		
		super.setPosSize(p_x,p_y,p_width,p_height,p_view);
	}
}