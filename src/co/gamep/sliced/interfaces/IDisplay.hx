/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, August 2013
 */

package co.gamep.sliced.interfaces;
import co.gamep.sliced.services.std.display.logicalspace.cameras.Camera3D;
import co.gamep.sliced.services.std.display.logicalspace.containers.Scene3D;
import co.gamep.sliced.services.std.display.logicalspace.containers.View3D;
import co.gamep.sliced.services.std.display.logicalspace.entities.Entity;
import co.gamep.sliced.services.std.display.logicalspace.entities.Mesh;
import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalSpace;
import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalStage;
import co.gamep.sliced.services.std.display.logicalspace.lights.DirectionalLight;
import co.gamep.sliced.services.std.display.renderers.interfaces.IRenderer;



/**
 * ...
 * @author Aris Kostakos
 */
interface IDisplay extends IService
{	
	var logicalSpace( default, default ):ILogicalSpace;
	
	var rendererSet( default, null ):Array<IRenderer>;
	
	var logicalViewsOrder (default, null ):Array<View3D>;
	var logicalViewRendererAssignments (default, null ):Map<View3D,IRenderer>;
	
	function setSpace( p_space:ILogicalSpace ):Void;
	
	function createSpace():ILogicalSpace;
	function createStage():ILogicalStage;
	function createScene():Scene3D;
	function createCamera():Camera3D;
	function createView():View3D;
	function createEntity():Entity;
	function createMesh():Mesh;
	function createDirectionalLight():DirectionalLight;
	
	function update():Void;
	
	function log(message:String):Void;
	function info(message:String):Void;
	function debug(message:String):Void;
	function warn(message:String):Void;
	function error(message:String):Void;
}