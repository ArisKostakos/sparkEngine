/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, July 2013
 */

 package org.gamepl.awe6.core.scenes;
import org.gamepl.awe6.core.GDE;

/**
 * ...
 * @author Aris Kostakos
 */

class Game extends AScene 
{
	override private function _init():Void 
	{
		super._init();
		isPauseable = true;
		// extend / addentities
		_title.text = "SLICED";
		addEntity( new GDE( _kernel ),true);
	}

}
