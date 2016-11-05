/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, November 2014
 */

package tools.spark.framework.flambe2_5D;

import flambe.Component;
import flambe.display.FillSprite;
import flambe.display.Sprite;
import flambe.display.BlendMode;
import flambe.Entity;
import flambe.math.Rectangle;
import tools.spark.framework.space2_5D.core.AScene2_5D;
import tools.spark.framework.space2_5D.interfaces.ICamera2_5D;
import tools.spark.framework.space2_5D.interfaces.IEntity2_5D;
import tools.spark.framework.space2_5D.interfaces.IView2_5D;
import tools.spark.sliced.services.std.logic.gde.core.GameEntity;
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
	//public static var COLLECTABLE = new CbType();
	//public static var PLAYER = new CbType();
	//public static var ENEMY = new CbType();
	//public static var SPIKE = new CbType();
	
	public function new(p_gameEntity:IGameEntity)
	{
		super(p_gameEntity);
		_initFlambeScene2_5D();
	}
	
	private function _initFlambeScene2_5D()
	{
		_updateStateFunctions['physicsScene'] = _updatePhysics;
		_updateStateFunctions['backgroundColor'] = _updateBackgroundColor;
		_updateStateFunctions['boundsWidth'] = _updateBoundsWidth;
		_updateStateFunctions['boundsHeight'] = _updateBoundsHeight;
		
		_queryFunctions['zoomX'] = _queryZoomX;
		_queryFunctions['zoomY'] = _queryZoomY;
		_queryFunctions['zoomScale'] = _queryZoomScale;
	}
	
	override public function createInstance (p_view2_5D:IView2_5D):Dynamic
	{
		//If this works, do it for EEEEVERYTHING ELSE
		//The idea here is, we don't destroy instances on remove, so re-add them here if available
		Console.error("Creating Scene: " + gameEntity.getState('name'));
		//flambe.System.external.call("console.log", [_instances[p_view2_5D]]);
		
		
		//instances (and group instances I guess) will only be deleted when explicitly requested to be deleted.. not by a removeChild
		if (_instances[p_view2_5D] != null)
		{
			return _instances[p_view2_5D];
		}
		else
		{
			_instances[p_view2_5D] = new Entity();
			
			_initScene(p_view2_5D);
			
			return super.createInstance(p_view2_5D);
		}
	}
	
	override public function update(?p_view2_5D:IView2_5D):Void
	{
		//_updateState('2DmeshType', p_view2_5D);
		//_updateState('spaceX',p_view2_5D);
		//_updateState('spaceY',p_view2_5D);
		//_updateState('spaceZ', p_view2_5D);
		
		_updateState('physicsScene', p_view2_5D);
		_updateState('backgroundColor', p_view2_5D);
		
		//Update Children
		for (f_childEntity in children)
			f_childEntity.update(p_view2_5D);
	}
	
	override private function _createChildOfInstance(p_childEntity:IEntity2_5D, p_view2_5D:IView2_5D, p_index:Int=-1):Void
	{
		/*
		//SUPER hack to add a 'background' object at the beginning of flambe's display array (I know, it's bad.. fix it by correctly implementing layers
		var appendChild:Bool = true;
		if (p_childEntity.gameEntity.getState('name') == "Background")
			appendChild = false;
		*/
		
		//This is an 'instance' addChild... a flambe addChild..
		
		//Console.warn("Insert Child at: " + p_index);
		
		if (p_index == -1)
			_instances[p_view2_5D].addChild(cast(p_childEntity.createInstance(p_view2_5D), Entity));
		else
			_instances[p_view2_5D].addChild(cast(p_childEntity.createInstance(p_view2_5D), Entity),true, p_index);
		
		super._createChildOfInstance(p_childEntity, p_view2_5D, p_index);
	}
	
	override private function _removeChildOfInstance(p_childEntity:IEntity2_5D, p_view2_5D:IView2_5D):Void
	{
		//This is an 'instance' removeChild... a flambe removeChild..
		var l_flambeEntity:Entity = cast(p_childEntity.getInstance(p_view2_5D), Entity);
		
		//Remove Physics Body
		var l_bodyComponent:Component = l_flambeEntity.get(BodyComponent);
		if (l_bodyComponent!=null) l_flambeEntity.remove(l_bodyComponent);
		
		//Remove the child
		if (l_flambeEntity.parent!=null) //just a check to not let it crash on weird circumstances.. not too crazy about it..
			_instances[p_view2_5D].removeChild(l_flambeEntity);
		
		super._removeChildOfInstance(p_childEntity, p_view2_5D);
	}
	
	override public function updateCamera(p_view:IView2_5D, p_camera:ICamera2_5D):Void
	{
		//Calculate temp values
		super.updateCamera(p_view, p_camera);
		
		//Get Mesh
		var l_instance:Entity = _instances[p_view];
		var l_sceneSprite:Sprite = l_instance.get(Sprite); //This will either be Sprite, or FillSprite.. we don't really care here
		
		//Apply temp values
		l_sceneSprite.setXY(_tempX, _tempY);
		l_sceneSprite.setScaleXY(_scaleX, _scaleY);
		
		//Console.error("UPDATING CAMERA X: " + _tempX);
		//Console.error("UPDATING CAMERA Y: " + _tempY);
		//Console.error("UPDATING CAMERA Scale: " + _scaleX);
		
		Sliced.event.raiseEvent(EEventType.CHANGED,gameEntity);
		
		//Clusterfuck hack to move background indepentantly
		//until layers are implemented..
		/*
		if (p_view.scene.gameEntity.getState('backgroundEntity') != null && p_camera.gameEntity.getState('name')!="Editor Scene Edit Camera")
		{
			var background:IGameEntity = cast(p_view.scene.gameEntity.getState('backgroundEntity'), IGameEntity);
			
			var backgroundWidth:Float = background.getState('boundsRect').width;
			var sceneMaxBounds:Float = p_view.scene.gameEntity.getState('boundsWidth');
			var viewWidth:Float = p_view.gameEntity.getState('feedbackWidth');
			var sceneBoundX:Float = p_view.scene.gameEntity.getState('boundsX') + sceneMaxBounds;
			
			var originPoint:Float = backgroundWidth / 2 - _tempX / _scaleX;
			var totalDistance:Float = (backgroundWidth - viewWidth / _scaleX);
			var cameraXMin:Float = p_view.scene.gameEntity.getState('boundsX');
			var cameraXMax:Float = sceneBoundX - p_camera.gameEntity.getState('captureAreaWidth');
			var cameraCurrent:Float =  _tempX / _scaleX * ( -1);
			var coveredPercent:Float = (cameraCurrent - cameraXMin) / (cameraXMax - cameraXMin);
			
			background.setState('spaceX', originPoint - totalDistance*coveredPercent);
			
			//background.setState('spaceX', backgroundWidth/2-_tempX/_scaleX); //0,0
			//background.setState('spaceX', backgroundWidth / 2 - _tempX / _scaleX - (backgroundWidth-viewWidth/_scaleX)); //end
			
			//Console.error("CAMERA _tempX: " + _tempX + ", spaceX: " + background.getState('spaceX') + ", _scaleX: " + _scaleX);
			//Console.error("CAMERA cameraXMin: " + cameraXMin+ ", cameraXMax: " + cameraXMax + ", _tempX: " + cameraCurrent);
			//Console.error("CAMERA coveredPercent: " + coveredPercent);
		}
		*/
	}
	
	private function _initScene(p_view2_5D:IView2_5D):Void
	{
		//Get Mesh
		var l_instance:Entity = _instances[p_view2_5D];
		
		//The Sprite component is added, in case we want to move/scale the entire scene by doing camera transformations
		var l_sceneSprite:Sprite = new Sprite(); //This may be replaced by FillSprite, if we want a background
		//l_sceneSprite.scissor = new Rectangle(0, 0, 100, 100);
		//l_sceneSprite.blendMode = BlendMode.Copy;  //so... without resetingVars in WebGL Renderer, this now can't be copy..
		l_sceneSprite.centerAnchor();//hmm
		l_instance.add(l_sceneSprite);
		
		//Create background and scissor here
		//or not..
	}
	
	private function _updatePhysics(p_physicsFlag:Bool, p_view2_5D:IView2_5D):Void
	{
		//Get Mesh
		var l_instance:Entity = _instances[p_view2_5D];
		
		if (p_physicsFlag)
		{
			//Console.error("UPDATING PHYSICS SCENE: " + gameEntity.getState('name'));
			//BodyComponent
			var spaceComponent:SpaceComponent = new SpaceComponent(gameEntity.getState('gravityX'),gameEntity.getState('gravityY'), gameEntity);
			l_instance.add(spaceComponent);
			_scenePhysicsInit(spaceComponent.space);
		}
	}
	
	private function _updateBackgroundColor(p_value:String, p_view2_5D:IView2_5D):Void
	{
		//Get Mesh
		var l_instance:Entity = _instances[p_view2_5D];
		
		Console.error("UPDATING Background Color of: " + gameEntity.getState('name'));
		
		//Get scene sprite (as a sprite)
		var l_sceneSprite = l_instance.get(Sprite);
			
		if (p_value!="Transparent")
		{
			//Parse color
			var l_color:Int = Std.parseInt(p_value);
			
			if (l_instance.has(FillSprite))
			{
				l_instance.get(FillSprite).color = l_color;
			}
			else
			{
				//switcheru (from Sprite to FillSprite)
				l_instance.remove(l_sceneSprite);
				
				var l_newSceneSprite:FillSprite = new FillSprite(l_color, gameEntity.getState( 'boundsWidth' ), gameEntity.getState( 'boundsHeight' ));
				l_newSceneSprite.setXY(l_sceneSprite.x._, l_sceneSprite.y._);
				l_newSceneSprite.setScaleXY(l_sceneSprite.scaleX._, l_sceneSprite.scaleY._);
				l_instance.add(l_newSceneSprite);
			}
		}
		else
		{
			if (l_instance.has(FillSprite))
			{
				//switcheru (from fillSprite to Sprite)
				l_instance.remove(l_sceneSprite);
				
				var l_newSceneSprite:Sprite = new Sprite();
				l_newSceneSprite.setXY(l_sceneSprite.x._, l_sceneSprite.y._);
				l_newSceneSprite.setScaleXY(l_sceneSprite.scaleX._, l_sceneSprite.scaleY._);
				l_instance.add(l_newSceneSprite);
			}
		}
		
		//Temp Scissoring THIS GOES TO CAMERA!
		/*
		if (gameEntity.getState('editorMode') == true)
		{
			var l_sceneSprite:Sprite = l_instance.get(Sprite);
			l_sceneSprite.scissor = new Rectangle(180, 80, 1920, 1280);
		}*/
		
		//var l_sceneSprite:Sprite = l_instance.get(Sprite);
		//l_sceneSprite.scissor = new Rectangle(180, 80, 1920, 1280);
	}
	
	private function _updateBoundsWidth(p_value:Float, p_view2_5D:IView2_5D):Void
	{
		//Get Mesh
		var l_instance:Entity = _instances[p_view2_5D];
		
		//If SceneSprite is a FillSprite
		if (l_instance.has(FillSprite))
			l_instance.get(FillSprite).width._ = p_value;
	}
	
	private function _updateBoundsHeight(p_value:Float, p_view2_5D:IView2_5D):Void
	{
		//Get Mesh
		var l_instance:Entity = _instances[p_view2_5D];
		
		//If SceneSprite is a FillSprite
		if (l_instance.has(FillSprite))
			l_instance.get(FillSprite).height._ = p_value;
	}
	
	
	private function _scenePhysicsInit(p_space:Space):Void
	{
		//p_space.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, CbType.ANY_BODY, CbType.ANY_BODY, _beginHandlerCollision));
		//p_space.listeners.add(new InteractionListener(CbEvent.END, InteractionType.COLLISION, CbType.ANY_BODY, CbType.ANY_BODY, _endHandlerCollision));
		
		p_space.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.ANY, CbType.ANY_BODY, CbType.ANY_BODY, _beginHandlerSensor));
		p_space.listeners.add(new InteractionListener(CbEvent.END, InteractionType.ANY, CbType.ANY_BODY, CbType.ANY_BODY, _endHandlerSensor));
		
		p_space.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.SENSOR, BIPED_FEET, CbType.ANY_BODY, _beginHandlerSensorFeet));
		p_space.listeners.add(new InteractionListener(CbEvent.END, InteractionType.SENSOR, BIPED_FEET, CbType.ANY_BODY, _endHandlerSensorFeet));
    }
	
	//Collision
	function _beginHandlerCollision(cb:InteractionCallback):Void
	{
		//kinda hacky way of stoing colliding object
		//cb.int1.userData.gameEntity.setState('collidedWith', cb.int2.userData.gameEntity);
		//cb.int2.userData.gameEntity.setState('collidedWith', cb.int1.userData.gameEntity);
		
		if (cb.int1.userData.gameEntity != null && cb.int2.userData.gameEntity != null) 
		{
			Sliced.event.raiseEvent(EEventType.PHYSICS_COLLISION_START, cb.int1.userData.gameEntity);
			Sliced.event.raiseEvent(EEventType.PHYSICS_COLLISION_START, cb.int2.userData.gameEntity);
			
			//Console.error("REAL COLLISION START!");
		}
	}
	
	function _endHandlerCollision(cb:InteractionCallback):Void
	{
		//kinda hacky way of stoing colliding object
		//cb.int1.userData.gameEntity.setState('collidedWith', cb.int2.userData.gameEntity);
		//cb.int2.userData.gameEntity.setState('collidedWith', cb.int1.userData.gameEntity);
		
		if (cb.int1.userData.gameEntity != null && cb.int2.userData.gameEntity != null) 
		{
			Sliced.event.raiseEvent(EEventType.PHYSICS_COLLISION_END, cb.int1.userData.gameEntity);
			Sliced.event.raiseEvent(EEventType.PHYSICS_COLLISION_END, cb.int2.userData.gameEntity);
			
			//Console.error("REAL COLLISION END!");
		}
	}
	
	//Sensor
	function _beginHandlerSensor(cb:InteractionCallback):Void
	{
		//kinda hacky way of stoing colliding object
		//cast(cb.int1.userData.gameEntity,IGameEntity).setState('collidedWith', cb.int2.userData.gameEntity);
		//cast(cb.int2.userData.gameEntity,IGameEntity).setState('collidedWith', cb.int1.userData.gameEntity);
		/*
		Console.error("SENSOR COLLISION preSTART!");
		if (cb.int1.userData.gameEntity!=null)
			Console.error("int1: " + cb.int1.userData.gameEntity.getState('name'));
			
		if (cb.int2.userData.gameEntity!=null)
		Console.error("int2: " + cb.int2.userData.gameEntity.getState('name'));
		*/
		//this is the shape.. get it's containing body
		//var int1Parent:Body = cb.int1;// .castShape.body;
		//Console.error("SENSOR STARTTTTTTTTTT: " + int1Parent.userData.gameEntity.getState('name'));
		
		if (cb.int1.userData.gameEntity != null && cb.int2.userData.gameEntity != null) 
		{
			Sliced.event.raiseEvent(EEventType.PHYSICS_SENSOR_START, cb.int1.userData.gameEntity);
			Sliced.event.raiseEvent(EEventType.PHYSICS_SENSOR_START, cb.int2.userData.gameEntity);
			
			//kinda hacky way of stoing colliding object
			cb.int1.userData.gameEntity.setState('collidedWith', cb.int2.userData.gameEntity);
			cb.int2.userData.gameEntity.setState('collidedWith', cb.int1.userData.gameEntity);
			
			//Console.error("SENSOR COLLISION START!");
		}
	}
	
	function _endHandlerSensor(cb:InteractionCallback):Void
	{
		//kinda hacky way of stoing colliding object
		//cb.int1.userData.gameEntity.setState('collidedWith', cb.int2.userData.gameEntity);
		//cb.int2.userData.gameEntity.setState('collidedWith', cb.int1.userData.gameEntity);
		
		//this is the shape.. get it's containing body
		//var int1Parent:Body = cb.int1;// .castShape.body;
		//Console.error("SENSOR ENDDDDDDDDDDD: " + int1Parent.userData.gameEntity.getState('name'));
		if (cb.int1.userData.gameEntity != null && cb.int2.userData.gameEntity != null) 
		{
			Sliced.event.raiseEvent(EEventType.PHYSICS_SENSOR_END, cb.int1.userData.gameEntity);
			Sliced.event.raiseEvent(EEventType.PHYSICS_SENSOR_END, cb.int2.userData.gameEntity);
			
			//Console.error("SENSOR COLLISION END!");
		}
	}
	
	//Sensor Feet
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
	
	//QUERIES
	inline private function _queryZoomX(p_queryArgument:Dynamic, p_view2_5D:IView2_5D):Dynamic
	{
		return _tempX;
	}
	
	inline private function _queryZoomY(p_queryArgument:Dynamic, p_view2_5D:IView2_5D):Dynamic
	{
		return _tempY;
	}
	inline private function _queryZoomScale(p_queryArgument:Dynamic, p_view2_5D:IView2_5D):Dynamic
	{
		return _scaleX;
	}
}