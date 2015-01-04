/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, November 2014
 */

package tools.spark.framework.flambe2_5D;

import tools.spark.framework.space2_5D.core.ACamera2_5D;
import tools.spark.framework.space2_5D.interfaces.IView2_5D;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;

/**
 * ...
 * @author Aris Kostakos
 */
class FlambeCamera2_5D extends ACamera2_5D
{
	private var _addedToViews:Map<IView2_5D,IView2_5D>;
	
	public function new(p_gameEntity:IGameEntity)
	{
		super(p_gameEntity);
		_initFlambeCamera2_5D();
	}
	
	private function _initFlambeCamera2_5D()
	{
		_addedToViews = new Map<IView2_5D,IView2_5D>();
	}
	
	override public function createInstance (p_view2_5D:IView2_5D):Dynamic
	{
		if (spriteUrl == "spriter") return _createInstanceSpriter(p_view2_5D);
		
		var l_entity:Entity = new Entity();
		
		var l_entityImageSprite:ImageSprite = new ImageSprite(Assets.getTexture(spriteUrl));
		l_entityImageSprite.blendMode = BlendMode.Copy;
		l_entity.add(l_entityImageSprite);

		l_entityImageSprite.x._ = x;
		l_entityImageSprite.y._ = y;
		
		_instances[p_view2_5D] = l_entity;
		
		//@todo: Now this is bad.. It registers event listeners for every single sprite.. it should do this ONLY if this gameEntity
		//has triggers that require these signals... since now you carry the gameEntity in here, it will be much easier to do this..
		//be sure to update if someone adds a trigger to the entity at runtime (do an addTrigger event, the same fashion you update states, childs, etc)
		l_entityImageSprite.pointerIn.connect(_onPointerIn);
		l_entityImageSprite.pointerOut.connect(_onPointerOut);

		return l_entity;
	}
	
	//This is all terrible of course...
	override public function updateInstances(?updateState:String):Void
	{
		for (f_entity in _instances)
		{
			var l_entityImageSprite:ImageSprite = f_entity.get(ImageSprite);
				
			l_entityImageSprite.x._ = x;
			l_entityImageSprite.y._ = y;
			
			if (updateState == "SpriteUrl")
			{
				if (spriteUrl != "spriter")
					l_entityImageSprite.texture = Assets.getTexture(spriteUrl);
			}
		}
	}
}