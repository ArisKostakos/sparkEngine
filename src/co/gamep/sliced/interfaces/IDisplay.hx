/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, August 2013
 */

package co.gamep.sliced.interfaces;
import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalCamera;
import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalEntity;
import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalLight;
import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalMesh;
import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalScene;
import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalSpace;
import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalStage;
import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalView;
import co.gamep.sliced.services.std.display.renderers.interfaces.IRenderer;

/**
 * ...
 * @author Aris Kostakos
 */
interface IDisplay extends IService
{
	var logicalSpace( default, default ):ILogicalSpace;

	var rendererSet( default, null ):Array<IRenderer>;
	
	var logicalViewsOrder (default, null ):Array<ILogicalView>;
	var logicalViewRendererAssignments (default, null ):Map<ILogicalView,IRenderer>;
	
	function setSpace( p_space:ILogicalSpace ):Void;
	
	function createSpace():ILogicalSpace;
	function createStage():ILogicalStage;
	function createScene():ILogicalScene;
	function createCamera():ILogicalCamera;
	function createView():ILogicalView;
	function createEntity():ILogicalEntity;
	function createMesh():ILogicalMesh;
	function createLight():ILogicalLight;
	
	function update():Void;
	
	function log(message:String):Void;
	function info(message:String):Void;
	function debug(message:String):Void;
	function warn(message:String):Void;
	function error(message:String):Void;
}