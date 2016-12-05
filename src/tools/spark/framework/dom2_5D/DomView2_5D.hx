/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, January 2015
 */

package tools.spark.framework.dom2_5D;

import tools.spark.framework.layout.containers.Group;
import tools.spark.framework.space2_5D.core.AView2_5D;
import tools.spark.framework.space2_5D.interfaces.ICamera2_5D;
import tools.spark.framework.space2_5D.interfaces.IEntity2_5D;
import tools.spark.framework.space2_5D.interfaces.IScene2_5D;
import tools.spark.framework.space2_5D.interfaces.IView2_5D;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;
import tools.spark.sliced.core.Sliced;
import js.Browser;
import js.html.Document;
import js.html.Element;
import js.html.InputElement;
import js.html.DivElement;

/**
 * ...
 * @author Aris Kostakos
 */
class DomView2_5D extends AView2_5D
{
	private var _instanceView:DivElement;
	private var _instanceScene:DivElement;
	
	public function new(p_gameEntity:IGameEntity) 
	{
		super(p_gameEntity);
		
		_initDomView2_5D();
	}
	
	public function updateState(p_state:String):Void
	{
		switch (p_state)
		{
			case 'visible':
				if (gameEntity.getState(p_state)==true)
					_instanceView.style.display = "inline";
				else
					_instanceView.style.display = "none";
			case 'width':
					_updateWidth(gameEntity.getState(p_state));
			case 'height':
					_updateHeight(gameEntity.getState(p_state));
		}
	}
	
	private inline function _updateWidth(p_width:String):Void
	{
		if (gameEntity.getState('layoutable') == true)
		{
			//This is bad.. put it in Space2_5D for everyone..
			group.updateState('width');
			
			//Invalidate Layout (hack?)
			Sliced.display.projectActiveSpaceReference.activeStageReference.layoutManager.validated=false;
		}
		else
		{
			//..
		}
	}
	
	private inline function _updateHeight(p_height:String):Void
	{
		if (gameEntity.getState('layoutable') == true)
		{
			//This is bad.. put it in Space2_5D for everyone..
			group.updateState('height');
			
			//Invalidate Layout (hack?)
			Sliced.display.projectActiveSpaceReference.activeStageReference.layoutManager.validated=false;
		}
		else
		{

		}
	}
	
	private inline function _initDomView2_5D():Void
	{	
		var content:Element = Browser.document.getElementById("content");
		
		_instanceView = Browser.document.createDivElement();
		_instanceView.style.position = "absolute";
		_instanceView.style.setProperty('pointer-events', 'none'); //Don't pick up mouse events
		_instanceView.style.zIndex = "1000";
		
		//Add to 'stage'
		content.insertBefore(_instanceView, content.firstElementChild);
	}
	
	override public function destroy():Void
	{
		var content:Element = Browser.document.getElementById("content");
		
		//Remove from 'stage'
		content.removeChild(_instanceView);
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
		//if (scene!=null)
		//...
		
		//Instanciate current scene
		scene = p_value;
		_instanceScene = cast(scene.createInstance(this), DivElement);
		
		//LAYOUT MANAGER
		//if (gameEntity.getState('layoutable') == true)
			//..
		
		//UPDATE VIEW
		_updateCurrentView();
		
        return scene;
    }
	
	
	//i think this belongs to AView2_5D instead.. i don't see any flambe relevant code... or is there...
	//or maybe there is.. just override and keep the for loop in AView2_5D instead
	private function _updateCurrentView():Void
	{
		//If scene or camera is not found, if scene instance in on a view, remove it, then quit
		if (scene == null || camera == null)
		{
			//if it's added already, remove it
			if (_instanceView.firstElementChild!=null)
				_instanceView.removeChild(_instanceView.firstElementChild);
				
			return;
		}
		
		//Update Scene
		
		//If scene not added yet, add it
		if (_instanceView.firstElementChild==null)
			_instanceView.appendChild(_instanceScene);
			
			
		//Update it
		scene.update(this);
	}
	
	private function _disposeCurrentScene():Void
	{
		_instanceScene = null;
	}
	
	override public function setPosSize(?p_x:Null<Float>, ?p_y:Null<Float>, ?p_width:Null<Float>, ?p_height:Null<Float>, ?p_view:IView2_5D):Void
	{
		if (p_x != null) _instanceView.style.left = Std.string(p_x) + "px";
		if (p_y != null) _instanceView.style.top = Std.string(p_y) + "px";
		if (p_width != null) _instanceView.style.width = Std.string(p_width) + "px";
		if (p_height != null) _instanceView.style.height = Std.string(p_height) + "px";
		
		super.setPosSize(p_x,p_y,p_width,p_height,p_view);
	}
}