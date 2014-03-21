/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, August 2013
 */

package co.gamep.sliced.interfaces;
import co.gamep.sliced.services.std.display.renderers.interfaces.IRenderer;
import co.gamep.sliced.services.std.logic.gde.interfaces.IGameEntity;



/**
 * ...
 * @author Aris Kostakos
 */
interface IDisplay extends IService
{	
	var space( default, default ):IGameEntity;
	//function set_space(p_gameEntity:IGameEntity):IGameEntity; //cast the gameEntity, and complain if space already set.
	
	var rendererSet( default, null ):Array<IRenderer>;
	
	//var logicalViewsOrder (default, null ):Array<View3D>;
	var viewToRenderer (default, null ):Map<IGameEntity,IRenderer>;
	
	
	/*
	function createSpace():ILogicalSpace;
	function createStage():ILogicalStage;
	function createScene():Scene3D;
	function createCamera():Camera3D;
	function createView():View3D;
	function createEntity():Entity;
	function createMesh():Mesh;
	function createDirectionalLight():DirectionalLight;
	*/
	function update():Void;
	
	function log(message:String):Void;
	function info(message:String):Void;
	function debug(message:String):Void;
	function warn(message:String):Void;
	function error(message:String):Void;
}