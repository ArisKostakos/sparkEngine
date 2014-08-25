/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, November 2013
 */

package tools.spark.sliced.services.std.display.logicalspace.core;

import tools.spark.sliced.services.std.display.logicalspace.cameras.Camera3D;
import tools.spark.sliced.services.std.display.logicalspace.containers.Scene3D;
import tools.spark.sliced.services.std.display.logicalspace.interfaces.ILogicalSpace;
import tools.spark.sliced.services.std.display.logicalspace.interfaces.ILogicalStage;

/**
 * ...
 * @author Aris Kostakos
 */
@:keep class LogicalSpace implements ILogicalSpace
{
	public var name( default, default ):String;
	public var logicalStage(default, default):ILogicalStage;
	public var logicalSceneSet(default, null):Map<String,Scene3D>;
	public var logicalCameraSet(default, null):Map<String,Camera3D>;
	//create here a place to put assets in
	//things like entities that are not created at the beginning
	//or textures, materials, etc...
	//all scenes should be able to access these
	
	public function new() 
	{
		_init();
	}
	
	inline private function _init():Void
	{
		logicalSceneSet = new Map<String,Scene3D>();
		logicalCameraSet = new Map<String,Camera3D>();
	}
	
	public function setStage( p_stage:ILogicalStage ):Void
	{
		//@note if another stage already exists, maybe you can warn the user, or take
			//other action. may need rerendering, changing renderers, etc, etc, etc
		
		logicalStage = p_stage;
	}
	
	public function addScene( p_scene:Scene3D ):Void
	{
		logicalSceneSet[p_scene.name] = p_scene;
	}
	
	public function removeScene( p_scene:Scene3D ):Void
	{
		logicalSceneSet.remove(p_scene.name);
	}
	
	public function getScene( p_sceneName:String ):Scene3D
	{
		return logicalSceneSet[p_sceneName];
	}
	
	
	public function addCamera( p_camera:Camera3D ):Void
	{
		logicalCameraSet[p_camera.name]=p_camera;
	}
	
	public function removeCamera( p_camera:Camera3D ):Void
	{
		logicalCameraSet.remove(p_camera.name);
	}
	
	public function getCamera( p_cameraName:String ):Camera3D
	{
		return logicalCameraSet[p_cameraName];
	}
}