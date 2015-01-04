/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, November 2014
 */

package tools.spark.framework.flambe2_5D;

import flambe.display.ImageSprite;
import flambe.display.Sprite;
import flambe.Entity;
import flambe.input.PointerEvent;
import tools.spark.framework.space2_5D.core.AEntity2_5D;
import tools.spark.framework.space2_5D.interfaces.IView2_5D;
import flambe.display.BlendMode;
import tools.spark.sliced.core.Sliced;
import tools.spark.sliced.services.std.logic.gde.interfaces.EEventType;
import spriter.flambe.SpriterMovie;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;

/**
 * ...
 * @author Aris Kostakos
 */
class FlambeEntity2_5D extends AEntity2_5D
{
	private var _instances:Map<IView2_5D,Entity>;
	
	public function new(p_gameEntity:IGameEntity) 
	{
		super(p_gameEntity);
		_initFlambeEntity2_5D();
	}
	
	private function _initFlambeEntity2_5D()
	{
		_instances = new Map<IView2_5D,Entity>();
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
	
	private function _createInstanceSpriter(p_view2_5D:IView2_5D):Dynamic
	{
		var eSpriter:Entity = new Entity();
		var l_entitySprite:Sprite = new Sprite();
		var l_entitySpriterMovie:SpriterMovie = new SpriterMovie(Assets.getAssetPackOf("SpriterTest/Spriter.scml"), "SpriterTest/Spriter.scml", "fgfdgfdg").playAnim("Walk");
		
		eSpriter.add( l_entitySprite );
		eSpriter.add( l_entitySpriterMovie);

		l_entitySprite.blendMode = BlendMode.Copy;


		l_entitySprite.x._ = x;
		l_entitySprite.y._ = y;
		
		l_entitySprite.scaleX._ = 0.4;
		l_entitySprite.scaleY._ = 0.4;
		
		_instances[p_view2_5D] = eSpriter;
		
		l_entitySprite.pointerIn.connect(_onPointerIn);
		l_entitySprite.pointerOut.connect(_onPointerOut);
		
		
		return eSpriter;
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
				if (spriteUrl != "spriter")
					l_entityImageSprite.texture = Assets.getTexture(spriteUrl);
			}
		}
	}
	
	override public function update(?p_view2_5D:IView2_5D):Void
	{
		_updateState('spaceX',p_view2_5D);
		_updateState('spaceY',p_view2_5D);
		_updateState('spaceZ',p_view2_5D);
		
		_updateFormState('SpriteUrl',p_view2_5D);
		_updateFormState('ModelUrl',p_view2_5D);
	}
	
	
	//For optimization purposes.. to be able to inline the publics
	private function _updateState(p_state:String, ?p_view2_5D:IView2_5D):Void
	{
		updateState(p_state,p_view2_5D);
	}
	
	//For optimization purposes.. to be able to inline the publics
	private function _updateFormState(p_formState:String, ?p_view2_5D:IView2_5D):Void
	{
		updateFormState(p_state,p_view2_5D);
	}
	
	inline public function updateState(p_state:String, ?p_view2_5D:IView2_5D):Void
	{
		if (p_view2_5D == null)
		{
			//do for all instances
			for (f_view in _instances.keys)
				_updateViewInstance(f_view);
		}
		else
		{
			//do for p_View2_5D instance
			_updateViewInstance(p_view2_5D);
		}
	}
	
	inline public function updateFormState(p_formState:String, ?p_view2_5D:IView2_5D):Void
	{
		if (p_view2_5D == null)
		{
			//do for all instances
			for (f_view in _instances.keys)
				_updateViewInstance(f_view);
		}
		else
		{
			//do for p_View2_5D instance
			_updateViewInstance(p_view2_5D);
		}
	}
	
	inline private function _updateStateOfInstance(p_state:String, p_view2_5D:IView2_5D):Void
	{
		switch (p_state)
		{
			case 'spaceX':
				l_entity2_5D.x = p_gameEntity.getState(p_state);
			case 'spaceY':
				l_entity2_5D.y = p_gameEntity.getState(p_state);
			case 'spaceZ':
				l_entity2_5D.z = p_gameEntity.getState(p_state);
		}
	}
	
	inline private function _updateFormStateOfInstance(p_formState:String, p_view2_5D:IView2_5D):Void
	{
		switch (p_formState)
		{
			case 'SpriteUrl':
				l_entity2_5D.spriteUrl = p_gameForm.getState(p_state);
				l_entity2_5D.updateInstances(p_state);
				//Console.error("updating sprite url of: " + l_entity2_5D.name + "to: " + p_gameForm.getState(p_state));
			case 'ModelUrl':
				l_entity2_5D.modelUrl = p_gameForm.getState(p_state);
		}
	}
	
	inline private function _updateSprite():Void
	{
		
	}

	inline private function _updatePosition():Void
	{
		
	}
	
	inline private function _updateRotation():Void
	{
		
	}
	
	inline private function _updateScale():Void
	{
		
	}
}