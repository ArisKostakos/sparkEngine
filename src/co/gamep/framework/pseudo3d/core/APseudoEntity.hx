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
class APseudoEntity implements IPseudoEntity
{
	public var x( default, default ):Int;
	public var y( default, default ):Int;
	public var z( default, default ):Int;
	public var yaw( default, default ):Int;
	public var pitch( default, default ):Int;
	public var roll( default, default ):Int;
	
	public var realObject( default, default ):Dynamic;
	
	public function validate():Void
	{
		//override...
		
	}

	/*
	public var x( default, default ):Int;
	public var y( default, default ):Int;
	public var rotation( default, default ):Int;
	public var scale( default, default ):Float;
	public var distanceFromCamera( default, default ):Int;
	public var insideFieldOfView( default, default ):Bool;
	*/
	private function new() 
	{
		
	}
	
}