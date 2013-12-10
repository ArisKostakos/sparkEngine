/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, December 2013
 */

package co.gamep.framework.pseudo3d.core;
import co.gamep.framework.pseudo3d.interfaces.IPseudoEntity;
import co.gamep.framework.pseudo3d.interfaces.IPseudoScene;

/**
 * ...
 * @author Aris Kostakos
 */
class APseudoScene implements IPseudoScene
{
	public var realObject( default, default ):Dynamic;
	
	private function new() 
	{
		
	}
	
	public function addChild(p_pseudoEntity:IPseudoEntity):Void
	{
		//override
	}
}