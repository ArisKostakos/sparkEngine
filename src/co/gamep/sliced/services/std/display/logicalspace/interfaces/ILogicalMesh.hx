/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, November 2013
 */

package co.gamep.sliced.services.std.display.logicalspace.interfaces;

/**
 * Logical space stands to ‘reality’, the existence and non-existence of states of affairs (TLP 2.05), as the potential to the actual. 
 * The term conveys the idea that logical possibilities form a ‘logical scaffolding’ (TLP 3.42), a systematic manifold akin to a coordinate system. 
 * The world is the ‘facts in logical space’ (TLP 1.13), since the contingent existence of states of affairs is embedded in an a priori order of possibilities.
 * @author Aris Kostakos
 */
interface ILogicalMesh extends ILogicalEntity
{
	var meshType_2d( default, default ):String;		// "not_available", "url", "primitive", "clone"
	var mesh_2d( default, default ):String;			// "assets/lion", "circle", "cloneName"
	var worldSizeX_2d( default, default ):Int;		// 50
	
	var meshType_3d( default, default ):String;		// "not_available", "url", "primitive", "clone"
	var mesh_3d( default, default ):String;			// "assets/lion", "sphere", "cloneName"
	var worldSizeX_3d( default, default ):Int;		// 50
	var materialType_3d( default, default ):String;	// "color", "texture"
	var material_3d( default, default ):String;		// "0xff0000", "assets/lionTexture"
}