/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, November 2014
 */

package tools.spark.framework.flambe2_5D;

import flambe.display.FillSprite;
import flambe.platform.InternalGraphics;
import flambe.math.Rectangle;
import tools.spark.framework.space2_5D.core.AView2_5D;
import flambe.Entity;
import flambe.display.Sprite;
import tools.spark.framework.space2_5D.interfaces.ICamera2_5D;
import tools.spark.framework.space2_5D.interfaces.IEntity2_5D;
import tools.spark.framework.space2_5D.interfaces.IScene2_5D;

/**
 * ...
 * @author Aris Kostakos
 */
class FlambeView2_5D extends AView2_5D
{
	private var _flambeGraphics:InternalGraphics;
	private var _flambeView:Entity;
	
	public function new(p_flambeGraphics:InternalGraphics) 
	{
		super();
		
		_flambeGraphics = p_flambeGraphics;
		
		_flambeView2_5DInit();
	}
	
	private inline function _flambeView2_5DInit():Void
	{
		_flambeView = new Entity();

		//color
		var l_bakcgroundColor:Int;
		l_bakcgroundColor = 0x00ff00;
		
		var l_viewSprite:FillSprite = new FillSprite(l_bakcgroundColor, 640, 480);
		//var l_viewSprite:Sprite = new Sprite();
		l_viewSprite.scissor = new Rectangle(0, 0, 640, 480);
		l_viewSprite.x._ = 0;
		l_viewSprite.y._ = 0;
		_flambeView.add(l_viewSprite);
	}
	
	override public function render():Void
	{
		//Console.warn("Rendering a brand new flambe 2.5 View, yeah boy!");
		
		//calculate positions (update dirty entities)?
		//scene.validate(camera);
		
		//update dirty camera (calculate all positions)?
		
		//validate
		//validate();
		
		//render
		Sprite.render(_flambeView, _flambeGraphics);
	}
	
	override private function set_camera( v : ICamera2_5D ) : ICamera2_5D {
        return camera = v;
    }
	
	override private function set_scene( v : IScene2_5D ) : IScene2_5D 
	{
		for (f_childEntity in v.children)
		{
			Console.error(f_childEntity.name);
			_flambeView.addChild(cast(f_childEntity.createInstance(this),Entity));
		}
		
        return scene = v;
    }
}