/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, November 2014
 */

package tools.spark.framework.flambe2_5D;

import flambe.display.Sprite;
import flambe.display.BlendMode;
import flambe.Entity;
import tools.spark.framework.space2_5D.core.AScene2_5D;
import tools.spark.framework.space2_5D.interfaces.ICamera2_5D;
import tools.spark.framework.space2_5D.interfaces.IEntity2_5D;
import tools.spark.framework.space2_5D.interfaces.IView2_5D;
import tools.spark.sliced.services.std.logic.gde.interfaces.EEventType;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;
import tools.spark.sliced.core.Sliced;

//IF DEF THIS SHIT ONLY IF SPARK RUNTIME SUPPORTS NAPE
import tools.spark.framework.flambe2_5D.components.BodyComponent;
import tools.spark.framework.flambe2_5D.components.SpaceComponent;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.Material;
import nape.shape.Circle;
import nape.shape.Polygon;
import nape.space.Space;
import nape.callbacks.CbEvent;
import nape.callbacks.CbType;
import nape.callbacks.InteractionType;
import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionListener;


/**
 * ...
 * @author Aris Kostakos
 */
class FlambeScene2_5D extends AScene2_5D
{
	public static var BIPED_FEET = new CbType();
	
	public function new(p_gameEntity:IGameEntity)
	{
		super(p_gameEntity);
		_initFlambeScene2_5D();
	}
	
	private function _initFlambeScene2_5D()
	{
		_updateStateFunctions['physicsScene'] = _updatePhysics;
	}
	
	override public function createInstance (p_view2_5D:IView2_5D):Dynamic
	{
		_instances[p_view2_5D] = new Entity();

		//The Sprite component is added, in case we want to move/scale the entire scene by doing camera transformations
		//Might become deprecated if the camera affects only individual 'layer entities' instead of the entire scene..
		//If that happens, remove the sprite component from here..
		var l_sceneSprite:Sprite = new Sprite();
		l_sceneSprite.blendMode = BlendMode.Copy;
		l_sceneSprite.centerAnchor();//hmm
		_instances[p_view2_5D].add(l_sceneSprite);
		
		return super.createInstance(p_view2_5D);
	}
	
	override public function update(?p_view2_5D:IView2_5D):Void
	{
		//_updateState('2DmeshType', p_view2_5D);
		//_updateState('spaceX',p_view2_5D);
		//_updateState('spaceY',p_view2_5D);
		//_updateState('spaceZ', p_view2_5D);
		
		_updateState('physicsScene', p_view2_5D);
		
		//Update Children
		for (f_childEntity in children)
			f_childEntity.update(p_view2_5D);
	}
	
	override private function _createChildOfInstance(p_childEntity:IEntity2_5D, p_view2_5D:IView2_5D):Void
	{
		//This is an 'instance' addChild... a flambe addChild..
		_instances[p_view2_5D].addChild(cast(p_childEntity.createInstance(p_view2_5D), Entity));
		
		super._createChildOfInstance(p_childEntity, p_view2_5D);
	}
	
	override private function _removeChildOfInstance(p_childEntity:IEntity2_5D, p_view2_5D:IView2_5D):Void
	{
		//This is an 'instance' removeChild... a flambe removeChild..
		_instances[p_view2_5D].removeChild(cast(p_childEntity.getInstance(p_view2_5D), Entity));
		
		super._removeChildOfInstance(p_childEntity, p_view2_5D);
	}
	
	override public function updateCamera(p_view:IView2_5D, p_camera:ICamera2_5D):Void
	{
		//Calculate temp values
		super.updateCamera(p_view, p_camera);
		
		//Get Mesh
		var l_instance:Entity = _instances[p_view];
		var l_instanceSprite:Sprite = l_instance.get(Sprite);
		
		//Apply temp values
		l_instanceSprite.setXY(_tempX, _tempY);
		l_instanceSprite.setScaleXY(_scaleX, _scaleY);
	}
	
	private function _updatePhysics(p_physicsFlag:Bool, p_view2_5D:IView2_5D):Void
	{
		//Get Mesh
		var l_instance:Entity = _instances[p_view2_5D];
		
		if (p_physicsFlag)
		{
			Console.error("UPDATING PHYSICS SCENE: " + gameEntity.getState('name'));
			//BodyComponent
			var spaceComponent:SpaceComponent = new SpaceComponent(gameEntity.getState('gravityX'),gameEntity.getState('gravityY'));
			l_instance.add(spaceComponent);
			_scenePhysicsInit(spaceComponent.space);
		}
	}
	
	private function _scenePhysicsInit(p_space:Space):Void
	{
		p_space.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, CbType.ANY_BODY, CbType.ANY_BODY, _beginHandlerCollision));
		p_space.listeners.add(new InteractionListener(CbEvent.END, InteractionType.COLLISION, CbType.ANY_BODY, CbType.ANY_BODY, _endHandlerCollision));
		
		p_space.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.SENSOR, BIPED_FEET, CbType.ANY_BODY, _beginHandlerSensorFeet));
		p_space.listeners.add(new InteractionListener(CbEvent.END, InteractionType.SENSOR, BIPED_FEET, CbType.ANY_BODY, _endHandlerSensorFeet));
    }
	
	function _beginHandlerCollision(cb:InteractionCallback):Void
	{
		if (cb.int1.userData.gameEntity!= null) Sliced.event.raiseEvent(EEventType.PHYSICS_COLLISION_START, cb.int1.userData.gameEntity);
		if (cb.int2.userData.gameEntity!= null) Sliced.event.raiseEvent(EEventType.PHYSICS_COLLISION_START, cb.int2.userData.gameEntity);
	}
	
	function _endHandlerCollision(cb:InteractionCallback):Void
	{
		if (cb.int1.userData.gameEntity!= null) Sliced.event.raiseEvent(EEventType.PHYSICS_COLLISION_END, cb.int1.userData.gameEntity);
		if (cb.int2.userData.gameEntity!= null) Sliced.event.raiseEvent(EEventType.PHYSICS_COLLISION_END, cb.int2.userData.gameEntity);
	}
	
	function _beginHandlerSensorFeet(cb:InteractionCallback):Void
	{
		//this is the shape.. get it's containing body
		var int1Parent:Body = cb.int1.castShape.body;
		
		if (int1Parent.userData.gameEntity!= null) Sliced.event.raiseEvent(EEventType.PHYSICS_SENSOR_START_BIPED_FEET, int1Parent.userData.gameEntity);
		if (cb.int2.userData.gameEntity!= null) Sliced.event.raiseEvent(EEventType.PHYSICS_SENSOR_START_BIPED_FEET, cb.int2.userData.gameEntity);
	}
	
	function _endHandlerSensorFeet(cb:InteractionCallback):Void
	{
		//this is the shape.. get it's containing body
		var int1Parent:Body = cb.int1.castShape.body;
		
		if (int1Parent.userData.gameEntity!= null) Sliced.event.raiseEvent(EEventType.PHYSICS_SENSOR_END_BIPED_FEET, int1Parent.userData.gameEntity);
		if (cb.int2.userData.gameEntity!= null) Sliced.event.raiseEvent(EEventType.PHYSICS_SENSOR_END_BIPED_FEET, cb.int2.userData.gameEntity);
	}
	
}