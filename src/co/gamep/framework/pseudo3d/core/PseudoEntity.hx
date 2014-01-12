/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, December 2013
 */

package co.gamep.framework.pseudo3d.core;
import co.gamep.framework.pseudo3d.interfaces.IPseudoEntity;

/**
 * ...
 * @author Aris Kostakos
 */
class PseudoEntity implements IPseudoEntity
{
	public var x( default, default ):Float;
	public var y( default, default ):Float;
	public var z( default, default ):Float;
	public var rotationX( default, default ):Float;
	public var rotationY( default, default ):Float;
	public var rotationZ( default, default ):Float;

	/*
	public var x( default, default ):Int;
	public var y( default, default ):Int;
	public var rotation( default, default ):Int;
	public var scale( default, default ):Float;
	public var distanceFromCamera( default, default ):Int;
	public var insideFieldOfView( default, default ):Bool;
	*/
	public var pseudoEntitySet:Array<IPseudoEntity>;
	
	public function new() 
	{
		pseudoEntitySet = new Array<IPseudoEntity>();
	}
	
	public function addChild(p_pseudoEntity:IPseudoEntity):Void
	{
		pseudoEntitySet.push(p_pseudoEntity);
	}
	
}