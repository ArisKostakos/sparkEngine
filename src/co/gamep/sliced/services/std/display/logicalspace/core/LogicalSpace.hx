/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, November 2013
 */

package co.gamep.sliced.services.std.display.logicalspace.core;

import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalCamera;
import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalScene;
import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalSpace;
import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalStage;

/**
 * ...
 * @author Aris Kostakos
 */
class LogicalSpace extends ALogicalComponent implements ILogicalSpace
{
	public var logicalStage(default, default):ILogicalStage;
	public var logicalSceneSet(default, null):Map<String,ILogicalScene>;
	public var logicalCameraSet(default, null):Map<String,ILogicalCamera>;
	//create here a place to put assets in
	//things like entities that are not created at the beginning
	//or textures, materials, etc...
	//all scenes should be able to access these
	
	public function new() 
	{
		super();
		
		_init();
	}
	
	inline private function _init():Void
	{
		logicalSceneSet = new Map<String,ILogicalScene>();
		logicalCameraSet = new Map<String,ILogicalCamera>();
	}
	
	public function setStage( p_stage:ILogicalStage ):Void
	{
		//@note if another stage already exists, maybe you can warn the user, or take
			//other action. may need rerendering, changing renderers, etc, etc, etc
		
		p_stage.parent = this;
		logicalStage = p_stage;
	}
	
	public function addScene( p_scene:ILogicalScene ):Void
	{
		p_scene.parent = this;
		logicalSceneSet[p_scene.name] = p_scene;
	}
	
	public function removeScene( p_scene:ILogicalScene ):Void
	{
		logicalSceneSet.remove(p_scene.name);
	}
	
	public function getScene( p_sceneName:String ):ILogicalScene
	{
		return logicalSceneSet[p_sceneName];
	}
	
	
	public function addCamera( p_camera:ILogicalCamera ):Void
	{
		p_camera.parent = this;
		logicalCameraSet[p_camera.name]=p_camera;
	}
	
	public function removeCamera( p_camera:ILogicalCamera ):Void
	{
		logicalCameraSet.remove(p_camera.name);
	}
	
	public function getCamera( p_cameraName:String ):ILogicalCamera
	{
		return logicalCameraSet[p_cameraName];
	}
}