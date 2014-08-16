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
	var space( default, null ):IGameEntity;
	
	var rendererSet( default, null ):Array<IRenderer>;
	
	var activeViewsOrder (default, null ):Array<IGameEntity>;
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
	function validate():Void;
	function invalidate():Void;
	function isValidated():Bool;
	function isCurrentSpace(p_gameEntity:IGameEntity):Bool;
	function setSpace(p_gameEntity:IGameEntity):IGameEntity; //cast the gameEntity, and complain if space already set.
	
	function log(message:String):Void;
	function info(message:String):Void;
	function debug(message:String):Void;
	function warn(message:String):Void;
	function error(message:String):Void;
}