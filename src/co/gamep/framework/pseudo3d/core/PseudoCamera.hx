/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, December 2013
 */

package co.gamep.framework.pseudo3d.core;
import co.gamep.framework.pseudo3d.interfaces.IPseudoCamera;

/**
 * ...
 * @author Aris Kostakos
 */
class PseudoCamera implements IPseudoCamera
{
	public var x( default, default ):Float;
	public var y( default, default ):Float;
	public var z( default, default ):Float;
	public var rotationX( default, default ):Float;
	public var rotationY( default, default ):Float;
	public var rotationZ( default, default ):Float;
	public var fieldOfView( default, default ):Int;
	
	public function new() 
	{
		
	}
	
}