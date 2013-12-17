/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, November 2013
 */

package co.gamep.sliced.services.std.display.logicalspace.core;

import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalEntity;
import co.gamep.sliced.services.std.display.logicalspace.interfaces.ILogicalMesh;

/**
 * ...
 * @author Aris Kostakos
 */
class LogicalMesh extends LogicalEntity implements ILogicalMesh
{
	public var meshType_2d( default, default ):String;		// "not_available", "url", "primitive", "clone"
	public var mesh_2d( default, default ):String;			// "assets/lion", "circle", "cloneName"
	public var worldSizeX_2d( default, default ):Int;		// 50
	
	public var meshType_3d( default, default ):String;		// "not_available", "url", "primitive", "clone"
	public var mesh_3d( default, default ):String;			// "assets/lion", "sphere", "cloneName"
	public var worldSizeX_3d( default, default ):Int;		// 50
	public var materialType_3d( default, default ):String;	// "color", "texture"
	public var material_3d( default, default ):String;		// "0xff0000", "assets/lionTexture"
	
	public function new() 
	{
		super();
	}
}