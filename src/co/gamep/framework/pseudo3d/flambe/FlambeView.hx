/* Copyright © Lazy Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, December 2013
 */

package co.gamep.framework.pseudo3d.flambe;
import co.gamep.framework.pseudo3d.core.APseudoView;
import co.gamep.framework.pseudo3d.interfaces.IPseudoScene;
import flambe.Entity;
import flambe.platform.InternalGraphics;
import flambe.display.Sprite;

/**
 * ...
 * @author Aris Kostakos
 */
class FlambeView extends APseudoView
{
	private var _flambeView:Entity;
	private var _flambeGraphics:InternalGraphics;
	
	public function new(p_flambeGraphics:InternalGraphics) 
	{
		super();
		
		_flambeGraphics = p_flambeGraphics;
		
		_flambeViewInit();
	}
	
	private inline function _flambeViewInit():Void
	{
		_flambeView = new Entity().add(new Sprite());
	}
	
	override public function render():Void
	{
		//calculate positions (update dirty entities)?
		//scene.validate(camera);
		
		//update dirty camera (calculate all positions)?
		
		//render
		Sprite.render(_flambeView, _flambeGraphics);
	}
	
	override public function set_scene( v:IPseudoScene):IPseudoScene
	{
		//override ahead
		_flambeView.addChild(v.realObject);
		
		return super.set_scene(v);
	}
	
	override public function validate():Void
	{
		var l_sprite:Sprite = _flambeView.get(Sprite);
		l_sprite.x._ = x;
		l_sprite.y._ = y;
	}
	
}