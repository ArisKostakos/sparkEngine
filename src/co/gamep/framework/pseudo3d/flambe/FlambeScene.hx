/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, December 2013
 */

package co.gamep.framework.pseudo3d.flambe;
import co.gamep.framework.pseudo3d.core.APseudoScene;
import co.gamep.framework.pseudo3d.interfaces.IPseudoEntity;
import flambe.Entity;

/**
 * ...
 * @author Aris Kostakos
 */
class FlambeScene extends APseudoScene
{
	private var _flambeScene:Entity;
	
	public function new() 
	{
		super();
		
		_flambeSceneInit();
	}
	
	private inline function _flambeSceneInit():Void
	{
		_flambeScene = new Entity();
		
		realObject = _flambeScene;
	}

	override public function addChild(p_pseudoEntity:IPseudoEntity):Void
	{
		_flambeScene.addChild(p_pseudoEntity.realObject);
	}
}