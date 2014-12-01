/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, November 2014
 */

package tools.spark.framework.flambe2_5D;

import flambe.display.ImageSprite;
import flambe.Entity;
import tools.spark.framework.space2_5D.core.AEntity2_5D;
import tools.spark.framework.space2_5D.interfaces.IView2_5D;

/**
 * ...
 * @author Aris Kostakos
 */
class FlambeEntity2_5D extends AEntity2_5D
{
	private var _instances:Map<IView2_5D,Entity>;
	
	public function new() 
	{
		super();
		_initFlambeEntity2_5D();
	}
	
	private function _initFlambeEntity2_5D()
	{
		_instances = new Map<IView2_5D,Entity>();
	}
	
	override public function createInstance (p_view2_5D:IView2_5D):Dynamic
	{
		var l_entity:Entity = new Entity();
		var l_entityImageSprite:ImageSprite = new ImageSprite(Assets.getTexture("assets/images/Ball.png"));
				
		l_entity.add(l_entityImageSprite);

		l_entityImageSprite.x._ = x;
		l_entityImageSprite.y._ = y;
			
		_instances[p_view2_5D] = l_entity;
		
		return l_entity;
	}
	
	override public function updateInstances():Void
	{
		for (f_entity in _instances)
		{
			var l_entityImageSprite:ImageSprite = f_entity.get(ImageSprite);
				
			l_entityImageSprite.x._ = x;
			l_entityImageSprite.y._ = y;
		}
	}
}