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
	public var x( default, default ):Int;
	public var y( default, default ):Int;
	public var z( default, default ):Int;
	public var yaw( default, default ):Int;
	public var pitch( default, default ):Int;
	public var roll( default, default ):Int;
	public var fieldOfView( default, default ):Int;
	
	public function new() 
	{
		
	}
	
}