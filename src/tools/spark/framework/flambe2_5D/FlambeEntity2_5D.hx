/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, November 2014
 */

package tools.spark.framework.flambe2_5D;

import flambe.display.ImageSprite;
import flambe.Entity;
import flambe.input.PointerEvent;
import tools.spark.framework.space2_5D.core.AEntity2_5D;
import tools.spark.framework.space2_5D.interfaces.IView2_5D;
import flambe.display.BlendMode;
import tools.spark.sliced.core.Sliced;
import tools.spark.sliced.services.std.logic.gde.interfaces.EEventType;

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
	
	private function _onPointerIn(p_pointerEvent:PointerEvent):Void
	{
		Sliced.input.pointer.submitPointerEvent(MOUSE_ENTERED, gameEntity);
	}
	
	private function _onPointerOut(p_pointerEvent:PointerEvent):Void
	{
		Sliced.input.pointer.submitPointerEvent(MOUSE_LEFT, gameEntity);
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
				l_entityImageSprite.texture = Assets.getTexture(spriteUrl);
			}
		}
	}
}