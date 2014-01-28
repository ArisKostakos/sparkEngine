/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, August 2013
 */

package co.gamep.sliced.services.dummy;

import co.gamep.sliced.interfaces.IDisplay;
import co.gamep.sliced.core.AService;
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
class Display extends AService implements IDisplay
{
	public function new() 
	{
		super();
		_init();
	}
	
	private function _init():Void
	{
		Console.log("Init Display Dummy Service...");
	}
	
	public var logicalSpace( default, default ):ILogicalSpace;
	
	public var rendererSet( default, null ):Array<IRenderer>;
	
	public var logicalViewsOrder (default, null ):Array<View3D>;
	public var logicalViewRendererAssignments (default, null ):Map<View3D,IRenderer>;
	
	public function setSpace( p_space:ILogicalSpace ):Void { }
	
	public function createSpace():ILogicalSpace { return null; }
	public function createStage():ILogicalStage { return null; }
	public function createScene():Scene3D { return null; }
	public function createCamera():Camera3D { return null; }
	public function createView():View3D { return null; }
	public function createEntity():Entity { return null; }
	public function createMesh():Mesh { return null; }
	public function createDirectionalLight():DirectionalLight { return null; }
	
	public function update():Void { }
	
	public function log(message:String):Void { }
	public function info(message:String):Void { }
	public function debug(message:String):Void { }
	public function warn(message:String):Void { }
	public function error(message:String):Void { }
}