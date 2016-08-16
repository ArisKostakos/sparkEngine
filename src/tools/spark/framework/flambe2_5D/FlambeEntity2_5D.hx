/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, November 2014
 */

package tools.spark.framework.flambe2_5D;

import flambe.Component;
import flambe.display.EmitterMold;
import flambe.display.EmitterSprite;
import flambe.display.FillSprite;
import flambe.display.Font;
import flambe.display.ImageSprite;
import flambe.display.Sprite;
import flambe.display.TextSprite;
import flambe.Entity;
import flambe.input.PointerEvent;
import flambe.math.Rectangle;
import flambe.math.FMath;
import flambe.swf.Library;
import flambe.swf.MoviePlayer;
import nape.shape.Shape;
import tools.spark.framework.flambe2_5D.components.PlanetComponent;
import tools.spark.framework.flambe2_5D.spritesheet.SpriteSheetPlayer;
import tools.spark.framework.space2_5D.core.AEntity2_5D;
import tools.spark.framework.space2_5D.interfaces.IEntity2_5D;
import tools.spark.framework.space2_5D.interfaces.IView2_5D;
import flambe.display.BlendMode;
import tools.spark.sliced.core.Sliced;
import tools.spark.sliced.services.std.logic.gde.interfaces.EEventType;
import spriter.flambe.SpriterMovie;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;

//IF DEF THIS SHIT ONLY IF SPARK RUNTIME SUPPORTS NAPE
import tools.spark.framework.flambe2_5D.components.BodyComponent;
import tools.spark.framework.flambe2_5D.components.SpaceComponent;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.Material;
import nape.shape.Circle;
import nape.shape.Polygon;
import nape.space.Space;
import nape.phys.BodyType;

/**
 * ...
 * @author Aris Kostakos
 */
class FlambeEntity2_5D extends AEntity2_5D
{
	private var _instancesMesh:Map<IView2_5D,Sprite>;
	
	public function new(p_gameEntity:IGameEntity) 
	{
		super(p_gameEntity);
		_initFlambeEntity2_5D();
	}
	
	private function _initFlambeEntity2_5D()
	{
		_instancesMesh = new Map<IView2_5D,Sprite>();
		
		_updateStateFunctions['2DmeshType'] = _update2DMeshType; //this will also update nested states here like 2DMeshImageForm,..
		_updateStateFunctions['spaceX'] = _updatePositionX; //for pure 2d.. for 3d coordinates, its not that simple..
		_updateStateFunctions['spaceY'] = _updatePositionY; //for pure 2d.. for 3d coordinates, its not that simple..
		_updateStateFunctions['scaleX'] = _updateSizeX; //for pure 2d.. for 3d coordinates, its not that simple..
		_updateStateFunctions['scaleY'] = _updateSizeY; //for pure 2d.. for 3d coordinates, its not that simple..
		_updateStateFunctions['rotation'] = _updateRotation;
		
		_updateStateFunctions['animate_x'] = _updateAnimateX;
		_updateStateFunctions['animate_y'] = _updateAnimateY;
		_updateStateFunctions['animate_scaleX'] = _updateAnimateScaleX;
		_updateStateFunctions['animate_scaleY'] = _updateAnimateScaleY;
		_updateStateFunctions['animate_rotation'] = _updateAnimateRotation;
		_updateStateFunctions['blendMode'] = _updateBlendMode;
		
		_updateStateFunctions['touchable'] = _updateTouchable;
		_updateStateFunctions['visible'] = _updateVisible;
		_updateStateFunctions['opacity'] = _updateOpacity;
		_updateStateFunctions['animate_opacity'] = _updateAnimateOpacity;
		
		_updateStateFunctions['velocityX'] = _updateVelocityX;
		_updateStateFunctions['velocityY'] = _updateVelocityY;
		_updateStateFunctions['velocityAng'] = _updateVelocityAng;
		_updateStateFunctions['applyImpulseX'] = _updateApplyImpulseX;
		_updateStateFunctions['applyImpulseY'] = _updateApplyImpulseY;
		_updateStateFunctions['applyImpulseAngle'] = _updateApplyImpulseAngle;
		_updateStateFunctions['centerAnchor'] = _centerAnchor;
		_updateStateFunctions['physicsEntity'] = _updatePhysics;
		_updateStateFunctions['spaceWidth'] = _updateSpaceWidth;	//this is iffy.. should do it with forms instead
		_updateStateFunctions['spaceHeight'] = _updateSpaceHeight;	//this is iffy.. should do it with forms instead
		_updateStateFunctions['2DMeshImageForm'] = _update2DMeshImageForm;
		_updateStateFunctions['2DMeshTextForm'] = _update2DMeshTextForm;
		_updateStateFunctions['2DMeshSpriterForm'] = _update2DMeshSpriterForm;
		_updateStateFunctions['2DMeshSpritesheetForm'] = _update2DMeshSpritesheetForm;
		_updateStateFunctions['2DMeshAdobeAnimationForm'] = _update2DMeshAdobeAnimationForm;
		_updateStateFunctions['2DMeshParticleEmitterForm'] = _update2DMeshParticleEmitterForm;
		_updateStateFunctions['2DMeshFillRectForm'] = _update2DMeshFillRectForm;
		_updateStateFunctions['2DMeshSpriteForm'] = _update2DMeshSpriteForm;
		_updateStateFunctions['2DMeshSpriterAnimForm'] = _update2DMeshSpriterAnimForm;
		_updateStateFunctions['action_fire'] = _updateFireParticle;
		_updateStateFunctions['emitX'] = _updateEmitX;
		_updateStateFunctions['emitY'] = _updateEmitY;
		_updateStateFunctions['particleEnabled'] = _updateParticleEnabled;
		_updateStateFunctions['particleDuration'] = _updateParticleDuration;
		_updateStateFunctions['text'] = _updateText;
		_updateStateFunctions['font'] = _updateFont;
		_updateStateFunctions['align'] = _updateAlign;
		_updateStateFunctions['wrapWidth'] = _updateWrapWidth;
		_updateStateFunctions['letterSpacing'] = _updateLetterSpacing;
		_updateStateFunctions['lineSpacing'] = _updateLineSpacing;
		_updateStateFunctions['scissorRect'] = _updateScissorRect;
		_updateStateFunctions['command_zOrder'] = _updateZOrder;
		
		_queryFunctions['realWidth'] = _queryRealWidth;
		_queryFunctions['realHeight'] = _queryRealHeight;
		_queryFunctions['boundsWidth'] = _queryBoundsWidth;
		_queryFunctions['boundsHeight'] = _queryBoundsHeight;
		_queryFunctions['x'] = _queryRealX;
		_queryFunctions['y'] = _queryRealY;
		_queryFunctions['angle'] = _queryRealRotation;
	}
	
	
	override public function createInstance (p_view2_5D:IView2_5D):Dynamic
	{
		//If this works, do it for EEEEVERYTHING ELSE
		//The idea here is, we don't destroy instances on remove, so re-add them here if available
		Console.error("Creating: " + gameEntity.getState('name'));
		flambe.System.external.call("console.log", [_instances[p_view2_5D]]);
		
		
		//instances (and group instances I guess) will only be deleted when explicitly requested to be deleted.. not by a removeChild
		if (_instances[p_view2_5D] != null)
		{
			return _instances[p_view2_5D];
		}
		else
		{
			_instances[p_view2_5D] = new Entity();
			
			return super.createInstance(p_view2_5D);
		}
		
	}

	override private function _createChildOfInstance(p_childEntity:IEntity2_5D, p_view2_5D:IView2_5D, p_index:Int=-1):Void
	{
		//This is an 'instance' addChild... a flambe addChild..
		
		if (p_index == -1)
			_instances[p_view2_5D].addChild(cast(p_childEntity.createInstance(p_view2_5D), Entity));
		else
			_instances[p_view2_5D].addChild(cast(p_childEntity.createInstance(p_view2_5D), Entity), true, p_index);
			
		
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
	

	override public function update(?p_view2_5D:IView2_5D):Void
	{
		_updateState('2DmeshType', p_view2_5D); //THIS NEEDS TO BE FIRST AT THE UPDATE TO GET THE SPRITE!!!!!!
		_updateState('centerAnchor', p_view2_5D);
		_updateState('physicsEntity', p_view2_5D);
		
		if (gameEntity.getState('layoutable') == null || gameEntity.getState('layoutable') == false)
		{
			_updateState('spaceX',p_view2_5D);
			_updateState('spaceY', p_view2_5D);
			
			_updateState('animate_x', p_view2_5D);
			_updateState('animate_y', p_view2_5D);
		}
		//_updateState('spaceZ', p_view2_5D);
		
		_updateState('scaleX',p_view2_5D);
		_updateState('scaleY',p_view2_5D);
		//_updateState('scaleZ', p_view2_5D);
		
		_updateState('rotation', p_view2_5D);
		_updateState('blendMode', p_view2_5D);
		
		_updateState('animate_scaleX', p_view2_5D);
		_updateState('animate_scaleY', p_view2_5D);
		_updateState('animate_rotation', p_view2_5D);
		
		_updateState('touchable', p_view2_5D);
		
		_updateState('visible', p_view2_5D);
		
		_updateState('opacity', p_view2_5D);
		_updateState('animate_opacity', p_view2_5D);
		//_updateState('2DMeshImageForm', p_view2_5D); //this is nested.. not for global update i think
		//_updateState('2DMeshSpriterForm', p_view2_5D); //this is nested.. not for global update i think
		//more spriter nested things exist also don't update them

		
		
		//Update my layoutObject
		if (gameEntity.getState('layoutable') == true)
			_updateLayoutGroup(p_view2_5D);
		
		//Update Children
		for (f_childEntity in children)
			f_childEntity.update(p_view2_5D);
	}
	
	
	inline private function _update2DMeshType(p_2DMeshType:String, p_view2_5D:IView2_5D):Void
	{
		//Get the instance we're updating
		var l_instance:Entity = _instances[p_view2_5D];
		
		//If sprite already has a mesh and it's the same do nothing?? or maybe, update its form??
		//...
		
		//if sprite already has a different mesh, remove it as a component and discard previous..right? yes here yes... if not defined yet?
		//@todo: DISCARD PREVIOUS MESH INSTANCE AND EVERYTHING IN IT, IF ANY
		//if (_instancesMesh[p_view2_5D]!=null)
		//...
		
		//If there's actually a change from one meshtype, to another, after you've cleared all previous meshes and shit
		//see if we can actually create the mesh, if the property is also set
		switch (p_2DMeshType) //this is where our state nesting happens for diplay form stuff
		{
			case 'Image':
				_updateStateOfInstance('2DMeshImageForm', p_view2_5D);
			case 'Spriter':
				_updateStateOfInstance('2DMeshSpriterForm', p_view2_5D);
			case 'Spritesheet':
				_updateStateOfInstance('2DMeshSpritesheetForm', p_view2_5D);
			case 'AdobeAnimation':
				_updateStateOfInstance('2DMeshAdobeAnimationForm', p_view2_5D);
			case 'Particle Emitter':
				_updateStateOfInstance('2DMeshParticleEmitterForm', p_view2_5D);
			case 'FillRect':
				_updateStateOfInstance('2DMeshFillRectForm', p_view2_5D);
			case 'Sprite':
				_updateStateOfInstance('2DMeshSpriteForm', p_view2_5D);
			case 'Text':
				_updateStateOfInstance('2DMeshTextForm', p_view2_5D);
				//_updateState('text', p_view2_5D);
				_updateState('font', p_view2_5D);//its crazy that this works.. sometimes from form state sometimes from normal state.. messy stuff
				_updateState('align', p_view2_5D);
				_updateState('wrapWidth', p_view2_5D);
				_updateState('letterSpacing', p_view2_5D);
				_updateState('lineSpacing', p_view2_5D);
			case 'Undefined':
				Console.warn('Undefined 2DmeshType value');
			default:
				Console.warn('Unhandled 2DmeshType value: ' + p_2DMeshType);
		}
		
		//Feedback back to the game Entity about the Entities Size (lil bit of a hack, if many views render the same scene,
		//then this is updated with the last rendered view)
		_updateBounds(p_view2_5D);
		
		//@think: if old mesh is lost, should probably update touchable too, since signals would be lost as well
		//and again.. old signals MUST be disposed.. for memory leaks...
	}

	private function _update2DMeshImageForm(p_2DMeshImageForm:String, p_view2_5D:IView2_5D):Void
	{
		//If the Entity's mesh type is not image, ignore this update
		if (gameEntity.getState('2DmeshType') != 'Image')
			return;
			
		//If the Form Name is Undefined, ignore this update
		if (p_2DMeshImageForm == 'Undefined')
			return;
			
		//Get the instance we're updating
		var l_instance:Entity = _instances[p_view2_5D];
		
		var l_mesh:ImageSprite;
		
		if (_instancesMesh[p_view2_5D]!=null)	//Get it's existing mesh, if any
			l_mesh= cast(_instancesMesh[p_view2_5D],ImageSprite); //(the cast should always work due to logic.. but not very sure..)
		else
			l_mesh = null;
			
		//Get Image Url
		var l_imageUrl:String;
		if (p_2DMeshImageForm.charAt(0) == '[')
			l_imageUrl = gameEntity.gameForm.getState( p_2DMeshImageForm.substring(1, p_2DMeshImageForm.length-1) );
		else
			l_imageUrl = p_2DMeshImageForm;
			
		if (l_mesh == null)
		{
			l_mesh = new ImageSprite(Assets.getTexture(l_imageUrl));
			//l_mesh.blendMode = BlendMode.Copy;  //so... without resetingVars in WebGL Renderer, this now can't be copy..
			l_instance.add(l_mesh);
			_instancesMesh[p_view2_5D] = l_mesh;
		}
		else
		{
			l_mesh.texture = Assets.getTexture(l_imageUrl);	
			l_mesh.centerAnchor(); //recenter anchor
		}
	}
	
	private function _update2DMeshTextForm(p_2DMeshTextForm:String, p_view2_5D:IView2_5D):Void
	{
		//If the Entity's mesh type is not image, ignore this update
		if (gameEntity.getState('2DmeshType') != 'Text')
			return;
			
		//If the Form Name is Undefined, ignore this update
		if (p_2DMeshTextForm == 'Undefined')
			return;
			
		//Get the instance we're updating
		var l_instance:Entity = _instances[p_view2_5D];
		
		var l_mesh:TextSprite;
		
		if (_instancesMesh[p_view2_5D]!=null)	//Get it's existing mesh, if any
			l_mesh= cast(_instancesMesh[p_view2_5D],TextSprite); //(the cast should always work due to logic.. but not very sure..)
		else
			l_mesh = null;
			
			
		if (l_mesh == null)
		{
			var l_fontName:String;
			
			if (p_2DMeshTextForm.charAt(0) == '[')
				l_fontName = gameEntity.gameForm.getState( p_2DMeshTextForm.substring(1, p_2DMeshTextForm.length-1) );
			else
				l_fontName = p_2DMeshTextForm;
			
			var l_font:Font = new Font(Assets.getAssetPackOf(l_fontName+".fnt"), l_fontName);
			
			l_mesh = new TextSprite(l_font, gameEntity.getState('text'));
			//l_mesh.wrapWidth._ = 100;
			//l_mesh.
			//l_mesh.blendMode = BlendMode.Copy;  //so... without resetingVars in WebGL Renderer, this now can't be copy..
			l_instance.add(l_mesh);
			_instancesMesh[p_view2_5D] = l_mesh;
		}
		else
		{
			//l_mesh.texture = Assets.getTexture(gameEntity.gameForm.getState( p_2DMeshImageForm ));	
		}
	}
	
	private function _update2DMeshParticleEmitterForm(p_2DMeshParticleEmitterForm:String, p_view2_5D:IView2_5D):Void
	{
		//If the Entity's mesh type is not image, ignore this update
		if (gameEntity.getState('2DmeshType') != 'Particle Emitter')
			return;
			
		//If the Form Name is Undefined, ignore this update
		if (p_2DMeshParticleEmitterForm == 'Undefined')
			return;
			
		//Get the instance we're updating
		var l_instance:Entity = _instances[p_view2_5D];
		
		var l_mesh:EmitterSprite;
		
		if (_instancesMesh[p_view2_5D]!=null)	//Get it's existing mesh, if any
			l_mesh= cast(_instancesMesh[p_view2_5D],EmitterSprite); //(the cast should always work due to logic.. but not very sure..)
		else
			l_mesh = null;
			
			
		if (l_mesh == null)
		{
			var l_moldName:String;
			
			if (p_2DMeshParticleEmitterForm.charAt(0) == '[')
				l_moldName = gameEntity.gameForm.getState( p_2DMeshParticleEmitterForm.substring(1, p_2DMeshParticleEmitterForm.length-1) );
			else
				l_moldName = p_2DMeshParticleEmitterForm;
			
			//Emitter Mold
			var l_mold:EmitterMold = new EmitterMold(Assets.getAssetPackOf(l_moldName+".pex"), l_moldName);
			gameEntity.setState("feedback_mold", l_mold);
			
			//Emitter Sprite
			l_mesh = l_mold.createEmitter();
			l_mesh.enabled = gameEntity.getState("particleEnabled");
			l_mesh.duration = gameEntity.getState("particleDuration");
			//l_mesh.wrapWidth._ = 100;
			//l_mesh.
			//l_mesh.blendMode = BlendMode.Copy; //so.. COPY don't respect transparency and does no blending.. but its the only one that worked when mixing away3d and flambe..
			l_mesh.emitX._ = gameEntity.getState("emitX");
			l_mesh.emitY._ = gameEntity.getState("emitY");
			l_instance.add(l_mesh);
			_instancesMesh[p_view2_5D] = l_mesh;
		}
		else
		{
			//l_mesh.texture = Assets.getTexture(gameEntity.gameForm.getState( p_2DMeshImageForm ));	
		}
	}
	
	
	private function _update2DMeshSpriterForm(p_2DMeshSpriterForm:String, p_view2_5D:IView2_5D):Void
	{
		//If the Entity's mesh type is not spriter, ignore this update
		if (gameEntity.getState('2DmeshType') != 'Spriter')
			return;
			
		//If the Form Name is Undefined, ignore this update
		if (p_2DMeshSpriterForm == 'Undefined')
			return;
			
		//Get the instance we're updating
		var l_instance:Entity = _instances[p_view2_5D];
		
		//Get it's existing mesh, if any. Not sure if this mesh is guaranteed to be a mesh used previously by spriter, or something else.
		//should be fine due to logic but not sure. by logic i mean, if we update 2dmeshtype it will always reset mesh and stuff
		var l_mesh:Sprite = _instancesMesh[p_view2_5D];
		
		if (l_mesh == null)
		{
			l_mesh = new Sprite();
			var l_SpriterFormName:String;
			
			if (p_2DMeshSpriterForm.charAt(0) == '[')
				l_SpriterFormName = gameEntity.gameForm.getState( p_2DMeshSpriterForm.substring(1, p_2DMeshSpriterForm.length-1) );
			else
				l_SpriterFormName = p_2DMeshSpriterForm;
				
			//gameEntity.getState('Atlas Folder')
			var l_spriterMovie:SpriterMovie = new SpriterMovie(Assets.getAssetPackOf(l_SpriterFormName), l_SpriterFormName, gameEntity.getState('Atlas Folder'), null, gameEntity.getState('Animation Speed')); //this null thing is supposed to be character name (string).. doesn't work though... always plays first character found
			//l_mesh.blendMode = BlendMode.Copy;  //so... without resetingVars in WebGL Renderer, this now can't be copy..
			l_instance.add(l_mesh);
			l_instance.add( l_spriterMovie);
			_instancesMesh[p_view2_5D] = l_mesh;
			
			//Store
			gameEntity.setState('obj_player', l_spriterMovie);
			
			//Play Animation
			if (gameEntity.getState('Init Animation') != "Undefined")
				l_spriterMovie.playAnim(gameEntity.getState('Init Animation'));
		}
		else
		{
			//l_mesh.texture = Assets.getTexture(gameEntity.gameForm.getState( l_imageForm ));	
		}
		
		//Play Animation (nesting)
		//_updateStateOfInstance('2DMeshSpriterAnimForm', p_view2_5D);
	}
	
	private function _update2DMeshSpritesheetForm(p_2DMeshSpritesheetForm:String, p_view2_5D:IView2_5D):Void
	{
		//If the Entity's mesh type is not a spritesheet, ignore this update
		if (gameEntity.getState('2DmeshType') != 'Spritesheet')
			return;
			
		//If the Form Name is Undefined, ignore this update
		if (p_2DMeshSpritesheetForm == 'Undefined')
			return;
			
		//Get the instance we're updating
		var l_instance:Entity = _instances[p_view2_5D];
		
		//Get it's existing mesh, if any. Not sure if this mesh is guaranteed to be a mesh used previously by Spritesheet, or something else.
		//should be fine due to logic but not sure. by logic i mean, if we update 2dmeshtype it will always reset mesh and stuff
		var l_mesh:Sprite = _instancesMesh[p_view2_5D];
		
		if (l_mesh == null)
		{
			l_mesh = new Sprite();
			
			var l_SpritesheetFormName:String;
			
			if (p_2DMeshSpritesheetForm.charAt(0) == '[')
				l_SpritesheetFormName = gameEntity.gameForm.getState( p_2DMeshSpritesheetForm.substring(1, p_2DMeshSpritesheetForm.length-1) );
			else
				l_SpritesheetFormName = p_2DMeshSpritesheetForm;
			
			
			var l_spritesheetPlayer:SpriteSheetPlayer = new SpriteSheetPlayer(Assets.getAssetPackOf(l_SpritesheetFormName), l_SpritesheetFormName, gameEntity.getState('Atlas File'));
			
			//Store
			gameEntity.setState('obj_player', l_spritesheetPlayer);
			
			//l_mesh.blendMode = BlendMode.Copy;  //so... without resetingVars in WebGL Renderer, this now can't be copy..
			l_instance.add(l_mesh);
			l_instance.add( l_spritesheetPlayer);
			_instancesMesh[p_view2_5D] = l_mesh;
		}
		else
		{
			//l_mesh.texture = Assets.getTexture(gameEntity.gameForm.getState( l_imageForm ));	
		}
		
		//Play Animation (nesting)
		//_updateStateOfInstance('2DMeshSpriterAnimForm', p_view2_5D);
		var l_spritesheetPlayeTemp:SpriteSheetPlayer = l_instance.get(SpriteSheetPlayer);
		if (gameEntity.getState('AnimationLoop') == true)
			l_spritesheetPlayeTemp.loop();
		else
			l_spritesheetPlayeTemp.play();
		l_spritesheetPlayeTemp.setSpeed(gameEntity.getState('AnimationSpeed'));
	}
	
	private function _update2DMeshAdobeAnimationForm(p_2DMeshAdobeAnimationForm:String, p_view2_5D:IView2_5D):Void
	{
		//If the Entity's mesh type is not an AdobeAnimation, ignore this update
		if (gameEntity.getState('2DmeshType') != 'AdobeAnimation')
			return;
			
		//If the Form Name is Undefined, ignore this update
		if (p_2DMeshAdobeAnimationForm == 'Undefined')
			return;
			
		//Get the instance we're updating
		var l_instance:Entity = _instances[p_view2_5D];
		
		//Get it's existing mesh, if any. Not sure if this mesh is guaranteed to be a mesh used previously by Spritesheet, or something else.
		//should be fine due to logic but not sure. by logic i mean, if we update 2dmeshtype it will always reset mesh and stuff
		var l_mesh:Sprite = _instancesMesh[p_view2_5D];
		
		if (l_mesh == null)
		{
			l_mesh = new Sprite();
			
			var l_AdobeAnimationFormName:String;
			
			if (p_2DMeshAdobeAnimationForm.charAt(0) == '[')
				l_AdobeAnimationFormName = gameEntity.gameForm.getState( p_2DMeshAdobeAnimationForm.substring(1, p_2DMeshAdobeAnimationForm.length-1) );
			else
				l_AdobeAnimationFormName = p_2DMeshAdobeAnimationForm;
			
			var l_library = new Library(Assets.getAssetPackOf(l_AdobeAnimationFormName), l_AdobeAnimationFormName, gameEntity.getState('Atlas Folder'));
			var l_moviePlayer:MoviePlayer = new MoviePlayer(l_library);
			
			if (gameEntity.getState('Init Animation Loop')==true)
				l_moviePlayer.loop(gameEntity.getState('Init Animation'));
			else
				l_moviePlayer.play(gameEntity.getState('Init Animation')); //Actually this will result in an error, cause apparently you can't play an anim without a looping anim first. But dont remove me to prevent DCE from killing .play()
			
			
			
			
			var l_movieEntity:Entity = new Entity().add(l_moviePlayer);
			
			//Store
			gameEntity.setState('obj_player', l_moviePlayer);
			
			//l_mesh.blendMode = BlendMode.Copy;  //so... without resetingVars in WebGL Renderer, this now can't be copy..
			l_instance.add(l_mesh);
			
			l_instance.addChild(l_movieEntity);
			
			_instancesMesh[p_view2_5D] = l_mesh;
		}
		else
		{
			//l_mesh.texture = Assets.getTexture(gameEntity.gameForm.getState( l_imageForm ));	
		}
		/*
		//Play Animation (nesting)
		//_updateStateOfInstance('2DMeshSpriterAnimForm', p_view2_5D);
		var l_spritesheetPlayeTemp:SpriteSheetPlayer = l_instance.get(SpriteSheetPlayer);
		if (gameEntity.getState('AnimationLoop') == true)
			l_spritesheetPlayeTemp.loop();
		else
			l_spritesheetPlayeTemp.play();
		l_spritesheetPlayeTemp.setSpeed(gameEntity.getState('AnimationSpeed'));
		*/
	}
	
	
	private function _update2DMeshFillRectForm(p_2DMeshFillRectForm:String, p_view2_5D:IView2_5D):Void
	
	{
		//If the Entity's mesh type is not image, ignore this update
		if (gameEntity.getState('2DmeshType') != 'FillRect')
			return;
			
		//If the Form Name is Undefined, ignore this update
		if (p_2DMeshFillRectForm == 'Undefined')
			return;
			
		//Get the instance we're updating
		var l_instance:Entity = _instances[p_view2_5D];
		
		var l_mesh:FillSprite;
		
		if (_instancesMesh[p_view2_5D]!=null)	//Get it's existing mesh, if any
			l_mesh= cast(_instancesMesh[p_view2_5D],FillSprite); //(the cast should always work due to logic.. but not very sure..)
		else
			l_mesh = null;
			
		
		//Get Image Url
		var l_color:Int;
		if (p_2DMeshFillRectForm.charAt(0) == '[')
			l_color = gameEntity.gameForm.getState( p_2DMeshFillRectForm.substring(1, p_2DMeshFillRectForm.length-1) );
		else
			l_color = Std.parseInt(p_2DMeshFillRectForm);
		
		if (l_mesh == null)
		{
			//do Layout Call??????????????
			//...
			
			//if (gameEntity.getState('layoutable') == true)
				//l_mesh = new FillSprite(gameEntity.gameForm.getState( p_2DMeshFillRectForm ),groupInstances[p_view2_5D].width, groupInstances[p_view2_5D].height);
			l_mesh = new FillSprite(l_color,gameEntity.getState( 'spaceWidth' ), gameEntity.getState( 'spaceHeight' ));
			l_mesh.scissor = new Rectangle(0, 0, gameEntity.getState( 'spaceWidth' ), gameEntity.getState( 'spaceHeight' ));
			//l_mesh.blendMode = BlendMode.Copy;  //so... without resetingVars in WebGL Renderer, this now can't be copy..
			l_instance.add(l_mesh);
			_instancesMesh[p_view2_5D] = l_mesh;
		}
		else
		{
			
			l_mesh.color = l_color;
			//l_mesh.setSize = 
		}
	}
	
	
	private function _updateScissorRect(p_scissorRect:Dynamic, p_view2_5D:IView2_5D):Void
	{
		//Get Mesh
		var l_mesh:Sprite = _instancesMesh[p_view2_5D];
		
		if (l_mesh != null) 
		{
			if (l_mesh.scissor == null)
				l_mesh.scissor = new Rectangle(p_scissorRect.x, p_scissorRect.y, p_scissorRect.width, p_scissorRect.height);
			else
			{
				l_mesh.scissor.x = p_scissorRect.x;
				l_mesh.scissor.y = p_scissorRect.y;
				l_mesh.scissor.width = p_scissorRect.width;
				l_mesh.scissor.height = p_scissorRect.height;
			}
			
		}
	}
	
	private function _update2DMeshSpriteForm(p_2DMeshSpriteForm:String, p_view2_5D:IView2_5D):Void
	{
		//If the Entity's mesh type is not image, ignore this update
		if (gameEntity.getState('2DmeshType') != 'Sprite')
			return;
			
		//If the Form Name is Undefined, ignore this update  FUCK THIS SHIT.... grmf.. for now..
		//if (p_2DMeshSpriteForm == 'Undefined')
			//return;
			
		//Get the instance we're updating
		var l_instance:Entity = _instances[p_view2_5D];
		
		var l_mesh:Sprite;

		if (_instancesMesh[p_view2_5D]!=null)	//Get it's existing mesh, if any
			l_mesh= cast(_instancesMesh[p_view2_5D],Sprite); //(the cast should always work due to logic.. but not very sure..)
		else
			l_mesh = null;
			
			
		if (l_mesh == null)
		{
			l_mesh = new Sprite();
			//l_mesh.blendMode = BlendMode.Copy;  //so... without resetingVars in WebGL Renderer, this now can't be copy..
			//do Layout Call??????????????
			//...
			//if (gameEntity.getState('layoutable') == true)

				
			l_instance.add(l_mesh);
			_instancesMesh[p_view2_5D] = l_mesh;
		}
		else
		{
			//l_mesh.color =
			//l_mesh.setSize = 
		}
	}
	
	private function _update2DMeshSpriterAnimForm(p_2DMeshSpriterAnimForm:String, p_view2_5D:IView2_5D):Void
	{
		//If the Entity's mesh type is not spriter, ignore this update
		if (gameEntity.getState('2DmeshType') != 'Spriter')
			return;
			
		//If the Entity's mesh type is not spriter, ignore this update
		if (gameEntity.getState('2DMeshSpriterForm') == 'Undefined')
			return;
			
		//If the Form Name is Undefined, ignore this update
		if (p_2DMeshSpriterAnimForm == 'Undefined')
			return;
			
		//Get the instance we're updating
		var l_instance:Entity = _instances[p_view2_5D];
		
		//Get it's existing mesh, if any. Not sure if this mesh is guaranteed to be a mesh used previously by spriter, or something else.
		//should be fine due to logic but not sure. by logic i mean, if we update 2dmeshtype it will always reset mesh and stuff
		var l_spriterMovie:SpriterMovie = l_instance.get(SpriterMovie);
		
		if (l_spriterMovie != null)
		{
			l_spriterMovie.playAnim(gameEntity.gameForm.getState( p_2DMeshSpriterAnimForm ));
		}
	}
	
	inline private function _updateAnimateX(p_animate:Dynamic, p_view2_5D:IView2_5D):Void
	{
		//Get Mesh
		var l_mesh:Sprite = _instancesMesh[p_view2_5D];
		
		if (p_animate != null)
		{
			if (gameEntity.getState('physicsEntity')==null || gameEntity.getState('physicsEntity')==false)
			{
				if (p_animate.type==null  || p_animate.type=="normal")
					l_mesh.x.animate(p_animate.from, p_animate.to, p_animate.seconds, p_animate.easing);
				else if (p_animate.type == "to")
					l_mesh.x.animateTo(p_animate.to, p_animate.seconds, p_animate.easing);
				else if (p_animate.type == "by")
					l_mesh.x.animateBy(p_animate.by, p_animate.seconds, p_animate.easing);
				else
					Console.warn("Unknown animate method");
			}
		}
	}
	
	inline private function _updateAnimateY(p_animate:Dynamic, p_view2_5D:IView2_5D):Void
	{
		//Get Mesh
		var l_mesh:Sprite = _instancesMesh[p_view2_5D];
		
		if (p_animate != null)
		{
			if (gameEntity.getState('physicsEntity')==null || gameEntity.getState('physicsEntity')==false)
			{
				if (p_animate.type==null  || p_animate.type=="normal")
					l_mesh.y.animate(p_animate.from, p_animate.to, p_animate.seconds, p_animate.easing);
				else if (p_animate.type == "to")
					l_mesh.y.animateTo(p_animate.to, p_animate.seconds, p_animate.easing);
				else if (p_animate.type == "by")
					l_mesh.y.animateBy(p_animate.by, p_animate.seconds, p_animate.easing);
				else
					Console.warn("Unknown animate method");
			}
		}
	}
	
	inline private function _updateAnimateScaleX(p_animate:Dynamic, p_view2_5D:IView2_5D):Void
	{
		//Get Mesh
		var l_mesh:Sprite = _instancesMesh[p_view2_5D];
		
		if (p_animate != null)
		{
			if (p_animate.type==null  || p_animate.type=="normal")
				l_mesh.scaleX.animate(p_animate.from, p_animate.to, p_animate.seconds, p_animate.easing);
			else if (p_animate.type == "to")
				l_mesh.scaleX.animateTo(p_animate.to, p_animate.seconds, p_animate.easing);
			else if (p_animate.type == "by")
				l_mesh.scaleX.animateBy(p_animate.by, p_animate.seconds, p_animate.easing);
			else
				Console.warn("Unknown animate method");
		}
		
		//Must Also Update Physics component, if entity is physics enabled
	}
	
	inline private function _updateAnimateScaleY(p_animate:Dynamic, p_view2_5D:IView2_5D):Void
	{
		//Get Mesh
		var l_mesh:Sprite = _instancesMesh[p_view2_5D];
		
		if (p_animate != null)
		{
			if (p_animate.type==null  || p_animate.type=="normal")
				l_mesh.scaleY.animate(p_animate.from, p_animate.to, p_animate.seconds, p_animate.easing);
			else if (p_animate.type == "to")
				l_mesh.scaleY.animateTo(p_animate.to, p_animate.seconds, p_animate.easing);
			else if (p_animate.type == "by")
				l_mesh.scaleY.animateBy(p_animate.by, p_animate.seconds, p_animate.easing);
			else
				Console.warn("Unknown animate method");
		}
		
		//Must Also Update Physics component, if entity is physics enabled
	}
	
	inline private function _updateAnimateRotation(p_animate:Dynamic, p_view2_5D:IView2_5D):Void
	{
		//Get Mesh
		var l_mesh:Sprite = _instancesMesh[p_view2_5D];
		
		if (p_animate != null)
		{
			if (gameEntity.getState('physicsEntity')==null || gameEntity.getState('physicsEntity')==false)
			{
				if (p_animate.type==null  || p_animate.type=="normal")
					l_mesh.rotation.animate(p_animate.from, p_animate.to, p_animate.seconds, p_animate.easing);
				else if (p_animate.type == "to")
					l_mesh.rotation.animateTo(p_animate.to, p_animate.seconds, p_animate.easing);
				else if (p_animate.type == "by")
					l_mesh.rotation.animateBy(p_animate.by, p_animate.seconds, p_animate.easing);
				else
					Console.warn("Unknown animate method");
			}
		}
	}
		
	//@todo: for pure 2d.. for 3d coordinates, its not that simple..
	inline private function _updatePositionX(p_newPos:Int, p_view2_5D:IView2_5D):Void
	{
		//Get Mesh
		var l_mesh:Sprite = _instancesMesh[p_view2_5D];
		
		//if (l_mesh != null) //this really nesseccery?
		//{
			if (gameEntity.getState('physicsEntity'))
			{
				if (gameEntity.getState('physicsType')!="Static")
					cast(gameEntity.getState('physicsBody'), Body).position.x = p_newPos; //should also check if NOT Static
			}
			else
				l_mesh.x._ = p_newPos;
		//}
	}
	
	//@todo: for pure 2d.. for 3d coordinates, its not that simple..
	inline private function _updatePositionY(p_newPos:Int, p_view2_5D:IView2_5D):Void
	{
		//Get Mesh
		var l_mesh:Sprite = _instancesMesh[p_view2_5D];
	
		//if (l_mesh != null) //this really nesseccery?
		//{
			if (gameEntity.getState('physicsEntity'))
			{
				if (gameEntity.getState('physicsType')!="Static")
					cast(gameEntity.getState('physicsBody'), Body).position.y = p_newPos; //should also check if NOT Static
			}
			else
				l_mesh.y._ = p_newPos;
		//}
	}
	
	//@todo: for pure 2d.. for 3d coordinates, its not that simple..
	inline private function _updateSizeX(p_newScale:Float, p_view2_5D:IView2_5D):Void
	{
		//Get Mesh
		var l_mesh:Sprite = _instancesMesh[p_view2_5D];
		
		if (l_mesh != null)
		{
			l_mesh.scaleX._ = p_newScale;
		}
		
		//Must Also Update Physics component, if entity is physics enabled
	}
	
	//@todo: for pure 2d.. for 3d coordinates, its not that simple..
	inline private function _updateSizeY(p_newScale:Float, p_view2_5D:IView2_5D):Void
	{
		//Get Mesh
		var l_mesh:Sprite = _instancesMesh[p_view2_5D];
		
		if (l_mesh != null)
			l_mesh.scaleY._ = p_newScale;
			
		//Must Also Update Physics component, if entity is physics enabled
	}
	
	//@todo: for pure 2d.. for 3d coordinates, its not that simple..
	inline private function _updateRotation(p_newRotation:Float, p_view2_5D:IView2_5D):Void
	{
		//Get Mesh
		var l_mesh:Sprite = _instancesMesh[p_view2_5D];
		
		//if (l_mesh != null) //this really nesseccery?
		//{
			if (gameEntity.getState('physicsEntity'))
			{
				if (gameEntity.getState('physicsType')!="Static")
					cast(gameEntity.getState('physicsBody'), Body).rotation = FMath.toRadians(p_newRotation); //should also check if NOT Static
			}
			else
				l_mesh.rotation._ = p_newRotation;
		//}
	}
	
	
	private function _updateVisible(p_visibleFlag:Bool, p_view2_5D:IView2_5D):Void
	{
		//Get Mesh
		var l_mesh:Sprite = _instancesMesh[p_view2_5D];
		
		if (l_mesh != null)
		{
			l_mesh.visible = p_visibleFlag;
		}
	}
	
	private function _updateOpacity(p_opacity:Float, p_view2_5D:IView2_5D):Void
	{
		//Get Mesh
		var l_mesh:Sprite = _instancesMesh[p_view2_5D];
		
		if (l_mesh != null)
		{
			l_mesh.setAlpha(p_opacity);
		}
	}
	
	private function _updateBlendMode(p_blendMode:String, p_view2_5D:IView2_5D):Void
	{
		//Get Mesh
		var l_mesh:Sprite = _instancesMesh[p_view2_5D];
		
		if (l_mesh != null)
		{
			if (p_blendMode != "Undefined")
			{
				if (p_blendMode == "Mask")
					l_mesh.blendMode = BlendMode.Mask;
				else if (p_blendMode == "Normal")
					l_mesh.blendMode = BlendMode.Normal;
				else if (p_blendMode == "Add")
					l_mesh.blendMode = BlendMode.Add;
				else if (p_blendMode == "Copy")
					l_mesh.blendMode = BlendMode.Copy;
				else if (p_blendMode == "Multiply")
					l_mesh.blendMode = BlendMode.Multiply;
				else if (p_blendMode == "Screen")
					l_mesh.blendMode = BlendMode.Screen;
			}
		}
	}
	
	private function _updateAnimateOpacity(p_animate:Dynamic, p_view2_5D:IView2_5D):Void
	{
		//Get Mesh
		var l_mesh:Sprite = _instancesMesh[p_view2_5D];
		
		if (p_animate != null)
		{
			if (p_animate.type==null  || p_animate.type=="normal")
				l_mesh.alpha.animate(p_animate.from, p_animate.to, p_animate.seconds, p_animate.easing);
			else if (p_animate.type == "to")
				l_mesh.alpha.animateTo(p_animate.to, p_animate.seconds, p_animate.easing);
			else if (p_animate.type == "by")
				l_mesh.alpha.animateBy(p_animate.by, p_animate.seconds, p_animate.easing);
			else
				Console.warn("Unknown animate method");
		}
	}
	
	private function _updateFireParticle(p_par:Bool, p_view2_5D:IView2_5D):Void
	{
		//Get Mesh
		var l_mesh:EmitterSprite = cast(_instancesMesh[p_view2_5D],EmitterSprite);
		
		if (l_mesh != null)
		{
			if (p_par == true)
			{
				//Fire Particle
				l_mesh.restart();
				
				//Toggle action flag OFF
				gameEntity.setStateSilent("action_fire", false);
			}
		}
	}
	
	private function _updateEmitX(p_par:Float, p_view2_5D:IView2_5D):Void
	{
		//Get Mesh
		var l_mesh:EmitterSprite = cast(_instancesMesh[p_view2_5D],EmitterSprite);
		
		if (l_mesh != null)
		{
			l_mesh.emitX._ = p_par;
		}
	}
	
	private function _updateEmitY(p_par:Float, p_view2_5D:IView2_5D):Void
	{
		//Get Mesh
		var l_mesh:EmitterSprite = cast(_instancesMesh[p_view2_5D],EmitterSprite);
		
		if (l_mesh != null)
		{
			l_mesh.emitY._ = p_par;
		}
	}
	
	private function _updateParticleEnabled(p_par:Bool, p_view2_5D:IView2_5D):Void
	{
		//Get Mesh
		var l_mesh:EmitterSprite = cast(_instancesMesh[p_view2_5D],EmitterSprite);
		
		if (l_mesh != null)
		{
			l_mesh.enabled = p_par;
		}
	}
	
	private function _updateParticleDuration(p_par:Float, p_view2_5D:IView2_5D):Void
	{
		//Get Mesh
		var l_mesh:EmitterSprite = cast(_instancesMesh[p_view2_5D],EmitterSprite);
		
		if (l_mesh != null)
		{
			l_mesh.duration = p_par;
		}
	}
	
	private function _updateText(p_par:String, p_view2_5D:IView2_5D):Void
	{
		//Get Mesh
		var l_mesh:TextSprite = cast(_instancesMesh[p_view2_5D],TextSprite);
		
		if (l_mesh != null)
		{
			l_mesh.text = p_par;
		}
	}
	
	private function _updateFont(p_par:String, p_view2_5D:IView2_5D):Void
	{
		//Get Mesh
		var l_mesh:TextSprite = cast(_instancesMesh[p_view2_5D],TextSprite);
		
		if (l_mesh != null)
		{
			l_mesh.font = new Font(Assets.getAssetPackOf(p_par+".fnt"), p_par);
		}
	}
	
	private function _updateAlign(p_par:String, p_view2_5D:IView2_5D):Void
	{
		//Get Mesh
		var l_mesh:TextSprite = cast(_instancesMesh[p_view2_5D],TextSprite);
		
		if (l_mesh != null)
		{
			switch (p_par)
			{
				case "Left": l_mesh.setAlign(TextAlign.Left);
				case "Center": l_mesh.setAlign(TextAlign.Center);
				case "Right": l_mesh.setAlign(TextAlign.Right);
				default:
			}
			
		}
	}
	
	private function _updateWrapWidth(p_par:Float, p_view2_5D:IView2_5D):Void
	{
		//Get Mesh
		var l_mesh:TextSprite = cast(_instancesMesh[p_view2_5D],TextSprite);
		
		if (l_mesh != null)
		{
			l_mesh.setWrapWidth(p_par);
		}
	}
	
	private function _updateLetterSpacing(p_par:Float, p_view2_5D:IView2_5D):Void
	{
		//Get Mesh
		var l_mesh:TextSprite = cast(_instancesMesh[p_view2_5D],TextSprite);
		
		if (l_mesh != null)
		{
			l_mesh.setLetterSpacing(p_par);
		}
	}
	
	private function _updateLineSpacing(p_par:Float, p_view2_5D:IView2_5D):Void
	{
		//Get Mesh
		var l_mesh:TextSprite = cast(_instancesMesh[p_view2_5D],TextSprite);
		
		if (l_mesh != null)
		{
			l_mesh.setLineSpacing(p_par);
		}
	}
	
	private function _updateZOrder(p_zOrder:Int, p_view2_5D:IView2_5D):Void
	{
		//Center Anchor State doesn't exist yet, we do it for everyone
		var l_instance:Entity = _instances[p_view2_5D];
		
		l_instance.setZOrder(p_zOrder);
	}

	private function _centerAnchor(p_centerAnchorFlag:Dynamic, p_view2_5D:IView2_5D):Void
	{
		//Center Anchor State doesn't exist yet, we do it for everyone
		var l_instance:Entity = _instances[p_view2_5D];
		var l_mesh:Sprite = _instancesMesh[p_view2_5D];
		
		if (l_mesh != null)
		{
			l_mesh.centerAnchor();
			
			if (gameEntity.getState('anchorX') != null && gameEntity.getState('anchorX') != "Undefined")
				l_mesh.anchorX._ = gameEntity.getState('anchorX');
				
			if (gameEntity.getState('anchorY') != null && gameEntity.getState('anchorY') != "Undefined")
				l_mesh.anchorY._ = gameEntity.getState('anchorY');
		}
	}
	
	private function _updatePhysics(p_physicsFlag:Bool, p_view2_5D:IView2_5D):Void
	{
		//Get Mesh
		var l_instance:Entity = _instances[p_view2_5D];
		var l_mesh:Sprite = _instancesMesh[p_view2_5D];
		
		if (l_mesh != null)
		{
			if (p_physicsFlag)
			{
				//Console.error("UPDATING PHYSICS ENTITY: " + gameEntity.getState('name') + ": " + gameEntity.getState('physicsType'));

				if (parentScene != null)
				{
					//Console.error("update2");
					if (parentScene.gameEntity.getState('physicsScene'))
					{
						//Console.error("update3");
						var l_sceneInstance:Entity = parentScene.getInstance(p_view2_5D);
						
						//Center Anchor (Only for physics objects)
						//l_mesh.centerAnchor();
						
						//Add a child
						var bodyType:BodyType;
						if (gameEntity.getState('physicsType') == "Static")
							bodyType = BodyType.STATIC;
						else if (gameEntity.getState('physicsType') == "Kinematic")
							bodyType = BodyType.KINEMATIC;
						else if (gameEntity.getState('physicsType') == "Dynamic")
							bodyType = BodyType.DYNAMIC;
						else
							bodyType = BodyType.STATIC;
							
						var body:Body = new Body(bodyType);
						
						var l_material:Material;
						
						switch (gameEntity.getState('physicsMaterial'))
						{
							case "Glass":
								l_material = Material.glass();
							case "Ice":
								l_material = Material.ice();
							case "Rubber":
								l_material = Material.rubber();
							case "Sand":
								l_material = Material.sand();
							case "Steel":
								l_material = Material.steel();
							case "Wood":
								l_material = Material.wood();
							case "Ellastic":
								l_material = new Material(1, 0, 0, 1, 0);
							case "Biped":
								l_material = new Material(0, 1, 2, 10, 0.001);
							default:
								l_material = Material.wood();
						}
						//(elasticity:Float=0.0,dynamicFriction:Float=1.0,staticFriction:Float=2.0,density:Float=1,rollingFriction:Float=0.001)
						
						var l_meshWidth:Float = Sprite.getBounds(l_instance).width*gameEntity.getState('scaleX');	// l_mesh.getNaturalWidth();
						var l_meshHeight:Float = Sprite.getBounds(l_instance).height*gameEntity.getState('scaleY');	// l_mesh.getNaturalHeight();
						//get bounds gets scaled mesh, so no need to multiply scale below
						
						if (gameEntity.getState('2DmeshType') != 'Spriter')
						{
							var l_shape:Shape;
							switch (gameEntity.getState('physicsShape'))
							{
								case "Circle":
									//I take the medium between width and hight (w+h)/2 and then divide by 2 cause we need radius which is half
									var l_radious = (l_meshWidth + l_meshHeight ) / 4;
									l_shape = new Circle(l_radious, l_material);
								case "Polygon":
									l_shape = new Polygon(Polygon.box(l_meshWidth, l_meshHeight), l_material);
								case "Triangle":
									var l_verts : Array<Vec2> = Polygon.regular( l_meshWidth * .5, l_meshHeight, 4, -Math.PI * .5 );
									l_verts.splice( 2, 1 );
									for (f_vert in l_verts)
										f_vert.y += l_meshHeight/2;
									l_shape = new Polygon( l_verts );
								default:
									l_shape = new Polygon(Polygon.box(l_meshWidth, l_meshHeight), l_material);
							}
							
							//IsSensor
							l_shape.sensorEnabled = gameEntity.getState('physicsSensorFlag');
						
							body.shapes.add(l_shape);
							
							body.allowRotation = gameEntity.getState('allowRotation');
						}
						else
						{
							if (gameEntity.getState('physicsShape') == "Biped")
							{	
								Console.error("LOOOK AT l_mesh.scaleX._: " + l_mesh.scaleX._);
								body.shapes.add(new Polygon(Polygon.rect(0,0,203, 573), l_material));
								//we multiply with scale here, since we don't use the getBounds method
								//_appendPhysicsBipedShapes(body, 263, 573, l_mesh.scaleX._, 0, -0.49, l_material);
								
								body.allowRotation = false;
							}
							else
							{
								//Default..
								body.shapes.add(new Polygon(Polygon.box(100, 100), l_material));
							}
						}
						
						
						//Inertia
						if (gameEntity.getState('inertia') != 12345)
							body.inertia = gameEntity.getState('inertia');
						
						//Body CbType
						//body.cbTypes.add
						
						//Store body
						gameEntity.setState('physicsBody', body);
						
						//Position
						//body.position = new Vec2(l_mesh.x._, l_mesh.y._);
						body.position = new Vec2(gameEntity.getState('spaceX'), gameEntity.getState('spaceY')); //My only chance to set position of a static object
						body.rotation = FMath.toRadians(gameEntity.getState('rotation'));
						
						//Initial Velocity
						if (gameEntity.getState('physicsType') == "Dynamic" || gameEntity.getState('physicsType') == "Kinematic")
						{
							body.velocity = new Vec2(gameEntity.getState('velocityX'), gameEntity.getState('velocityY'));
							body.angularVel = FMath.toRadians(gameEntity.getState('velocityAng'));
						}
						
						//body.rotation = Math.random() * 2*FMath.PI;
						body.space = l_sceneInstance.get(SpaceComponent).space;
						
						body.userData.gameEntity = gameEntity;
						

						l_instance.add(new BodyComponent(body));
						
						//if (gameEntity.getState('physicsPlanet') == true)
						//	l_instance.add(new PlanetComponent(body));
							
						//var childEntity:Entity = new Entity().add(new BodyComponent(body));
						//childEntity.add(new FillSprite(0x00ff00, 64, 64).centerAnchor());
					}
					else
					{
						gameEntity.setState('physicsEntity', false);
						Console.warn("Entity " + gameEntity.getState('name') + " failed to become a physics object. ParentScene not physics");
					}
				}
				else
				{
					gameEntity.setState('physicsEntity', false);
					Console.warn("Entity " + gameEntity.getState('name') + " failed to become a physics object. ParentScene null");
				}
			}
			else //physics flag is false
			{
				if (gameEntity.getState('physicsBody') != null)
				{
					Console.de('Removing physics body thing');
					gameEntity.setState('physicsBody', null);
					
					l_instance.remove(l_instance.get(BodyComponent));
				}
			}
		}
	}
	
	private function _appendPhysicsBipedShapes(p_body:Body, p_width:Float, p_height:Float, ?p_scale:Float = 1, ?p_offsetX:Float = 0, ?p_offsetY:Float = 0, p_bodyMaterial:Material, p_feetMaterial:Material=null, p_headMaterial:Material=null):Void
	{
		var l_widthScaled:Float = p_width*p_scale;
		var l_heightScaled:Float = p_height*p_scale;
		var l_offsetXScaled:Float = p_offsetX *l_widthScaled;
		var l_offsetYScaled:Float = p_offsetY * l_heightScaled;
		
		var l_circleRadious:Float = l_widthScaled / 2;
		var l_rectHeight:Float = l_heightScaled - l_circleRadious * 2;
		
		var l_head:Circle = new Circle(l_circleRadious, new Vec2(l_offsetXScaled, -l_rectHeight / 2 + l_offsetYScaled), p_bodyMaterial);
		var l_main:Polygon = new Polygon(Polygon.rect( -l_widthScaled / 2 + l_offsetXScaled, -l_rectHeight / 2 + l_offsetYScaled, l_widthScaled, l_rectHeight), p_bodyMaterial);
		var l_feet:Circle = new Circle(l_circleRadious, new Vec2(l_offsetXScaled, l_rectHeight / 2 + l_offsetYScaled), p_bodyMaterial);
		var l_feetSensor:Polygon = new Polygon(Polygon.rect( -l_widthScaled/2 / 2 + l_offsetXScaled, l_rectHeight / 2 + l_offsetYScaled + l_circleRadious - l_heightScaled*0.05/2, l_widthScaled/2, l_heightScaled*0.05), p_bodyMaterial);
		
		l_feetSensor.sensorEnabled = true;
		l_feetSensor.cbTypes.add(FlambeScene2_5D.BIPED_FEET);
		
		p_body.shapes.add(l_head);
		p_body.shapes.add(l_main);
		p_body.shapes.add(l_feet);
		p_body.shapes.add(l_feetSensor);
		
		//gameEntity.setState('physicsBody', p_body);
	}
	
	
	inline private function _updateVelocityX(p_newVel:Float, p_view2_5D:IView2_5D):Void
	{
		//Get Mesh
		var l_instance:Entity = _instances[p_view2_5D];
		//var l_mesh:Sprite = _instancesMesh[p_view2_5D];
		
		if (l_instance.get(BodyComponent) == null) return;
		
		var body:Body = l_instance.get(BodyComponent).body;
		
		body.velocity.x = p_newVel;
	}
	
	inline private function _updateVelocityY(p_newVel:Float, p_view2_5D:IView2_5D):Void
	{
		//Get Mesh
		var l_instance:Entity = _instances[p_view2_5D];
		//var l_mesh:Sprite = _instancesMesh[p_view2_5D];
		
		if (l_instance.get(BodyComponent) == null) return;
		
		var body:Body = l_instance.get(BodyComponent).body;
		
		body.velocity.y = p_newVel;
	}
	
	inline private function _updateVelocityAng(p_newVel:Float, p_view2_5D:IView2_5D):Void
	{
		//Get Mesh
		var l_instance:Entity = _instances[p_view2_5D];
		//var l_mesh:Sprite = _instancesMesh[p_view2_5D];
		
		if (l_instance.get(BodyComponent) == null) return;
		
		var body:Body = l_instance.get(BodyComponent).body;
		
		body.angularVel = FMath.toRadians(p_newVel);
	}
	
	inline private function _updateApplyImpulseX(p_newVel:Float, p_view2_5D:IView2_5D):Void
	{
		//Get Mesh
		var l_instance:Entity = _instances[p_view2_5D];
		//var l_mesh:Sprite = _instancesMesh[p_view2_5D];
		
		if (l_instance.get(BodyComponent) == null) return;
		
		var body:Body = l_instance.get(BodyComponent).body;
		
		body.applyImpulse(Vec2.weak(p_newVel, 0));
	}
	
	inline private function _updateApplyImpulseY(p_newVel:Float, p_view2_5D:IView2_5D):Void
	{
		//Get Mesh
		var l_instance:Entity = _instances[p_view2_5D];
		//var l_mesh:Sprite = _instancesMesh[p_view2_5D];
		
		if (l_instance.get(BodyComponent) == null) return;
		
		var body:Body = l_instance.get(BodyComponent).body;
		
		body.applyImpulse(Vec2.weak(0, p_newVel));
	}
	
	inline private function _updateApplyImpulseAngle(p_newVel:Float, p_view2_5D:IView2_5D):Void
	{
		//Get Mesh
		var l_instance:Entity = _instances[p_view2_5D];
		//var l_mesh:Sprite = _instancesMesh[p_view2_5D];
		
		if (l_instance.get(BodyComponent) == null) return;
		
		var body:Body = l_instance.get(BodyComponent).body;
		
		body.applyAngularImpulse(p_newVel);
	}
	
	private function _updateTouchable(p_touchableFlag:Bool, p_view2_5D:IView2_5D):Void
	{
		//Gt Mesh
		var l_mesh:Sprite = _instancesMesh[p_view2_5D];
		
		if (l_mesh != null)
		{
			if (p_touchableFlag)
			{
				//@think: another way to do this without having a touchable flag it to check if there are triggers actually connected to the gameEntity that want these signals, ad play like that
				//also be sure to update if someone adds a trigger to the entity at runtime (do an addTrigger event, the same fashion you update states, childs, etc)
				l_mesh.pointerEnabled = true;
				
				if (!l_mesh.pointerIn.hasListeners())
					l_mesh.pointerIn.connect(_onPointerIn);
					
				if (!l_mesh.pointerMove.hasListeners())
					l_mesh.pointerMove.connect(_onPointerMove);
					
				if (!l_mesh.pointerOut.hasListeners())
					l_mesh.pointerOut.connect(_onPointerOut);
					
				if (!l_mesh.pointerDown.hasListeners())
					l_mesh.pointerDown.connect(_onPointerDown);
					
				if (!l_mesh.pointerUp.hasListeners())
					l_mesh.pointerUp.connect(_onPointerUp);
			}
			else
			{
				//@todo: should really consider actually removing those listeners, here.... use the disposer component thing
				//if you don't want to store the signal Connections..and retrieve disposer here, from the entity. Disposer way looks better anyway...
				l_mesh.pointerEnabled = false;
				//Console.error("POINTER DISABLED");
			}
			
		}
	}
	
	
	private function _onPointerIn(p_pointerEvent:PointerEvent):Void
	{
		Sliced.input.pointer.submitPointerEvent(MOUSE_ENTERED, gameEntity);
	}
	
	private function _onPointerMove(p_pointerEvent:PointerEvent):Void
	{
		Sliced.input.pointer.submitPointerEvent(MOUSE_MOVED, gameEntity);
	}
	
	private function _onPointerOut(p_pointerEvent:PointerEvent):Void
	{
		Sliced.input.pointer.submitPointerEvent(MOUSE_LEFT, gameEntity);
	}
	
	private function _onPointerDown(p_pointerEvent:PointerEvent):Void
	{
		Sliced.input.pointer.submitPointerEvent(MOUSE_DOWN, gameEntity); //hmm
		
		//if (Sliced.input.mouse.isDown(flambe.input.MouseButton.Right))
		//	Sliced.input.pointer.submitPointerEvent(MOUSE_RIGHT_CLICK, gameEntity);
		
		gameEntity.setState('feedback_touchEvent', p_pointerEvent.clone());
		
		if (p_pointerEvent.source.getName() == "Mouse")
		{
			if (Sliced.input.mouse.isDown(flambe.input.MouseButton.Left))
				Sliced.input.pointer.submitPointerEvent(MOUSE_LEFT_CLICK, gameEntity);
		}
		else
		{
			Sliced.input.pointer.submitPointerEvent(MOUSE_LEFT_CLICK, gameEntity);
		}
	}
	
	private function _onPointerUp(p_pointerEvent:PointerEvent):Void
	{
		Sliced.input.pointer.submitPointerEvent(MOUSE_UP, gameEntity); //hmm
		
		
		if (p_pointerEvent.source.getName() == "Mouse")
			if (Sliced.input.mouse.lastMouseButton==flambe.input.MouseButton.Right)
				Sliced.input.pointer.submitPointerEvent(MOUSE_RIGHT_CLICK, gameEntity);
			//else
				//Sliced.input.pointer.submitPointerEvent(MOUSE_LEFT_CLICK, gameEntity);
			
			
		//Fucking iOS..
		#if html
			if (Sliced.sound.iOSPlayedBlankSound == false)
				Sliced.sound.iOSPlayBlankSound();
		#end
	}
	
	override public function setPosSize(?p_x:Null<Float>, ?p_y:Null<Float>, ?p_width:Null<Float>, ?p_height:Null<Float>, ?p_view:IView2_5D):Void
	{
		//Get Mesh
		var l_mesh:Sprite = _instancesMesh[p_view];
		Console.de("RESIZING: " + gameEntity.getState('name') + '. x: ' + p_x + ', y: ' + p_y);
		Console.de("RESIZING: " + gameEntity.getState('name') + '. width: ' + p_width + ', height: ' + p_height);
		
		if (l_mesh != null)		
		{
			if (p_x != null)
			{
				l_mesh.x._ = p_x;
				Console.de("wtfXX");
			}
			if (p_y != null)
			{
				l_mesh.y._ = p_y;
				Console.de("wtfYY");
			}
			//if (p_width != null) l_mesh.scissor.width = p_width;
			//if (p_height != null) l_mesh.scissor.height = p_height;
		}
		
		var l_instance:Entity = _instances[p_view];
		var l_fillSprite:FillSprite = l_instance.get(FillSprite);
		
		if (l_fillSprite != null) 
		{
			l_fillSprite.setSize(p_width, p_height);
			Console.de("wtfsetSize");
		}
		
		super.setPosSize(p_x,p_y,p_width,p_height,p_view);
	}
	
	private function _updateSpaceWidth(p_spaceWidth:Float, p_view2_5D:IView2_5D):Void
	{
		//Get Mesh
		var l_instance:Entity = _instances[p_view2_5D];
		var l_fillSprite:FillSprite = l_instance.get(FillSprite);
		
		if (l_fillSprite != null) 
		{
			l_fillSprite.width._ = p_spaceWidth;
			l_fillSprite.centerAnchor(); //eek
			l_fillSprite.scissor.width = p_spaceWidth; //uuk
		}
	}
	
	private function _updateSpaceHeight(p_spaceHeight:Float, p_view2_5D:IView2_5D):Void
	{
		//Get Mesh
		var l_instance:Entity = _instances[p_view2_5D];
		var l_fillSprite:FillSprite = l_instance.get(FillSprite);
		
		if (l_fillSprite != null) 
		{
			l_fillSprite.height._ = p_spaceHeight;
			l_fillSprite.centerAnchor(); //eek
			l_fillSprite.scissor.height = p_spaceHeight; //uuk
		}
	}
	
	//Feedback back to the game Entity
	private function _updateBounds(p_view2_5D:IView2_5D):Void
	{
		//Get Entity
		var l_instance:Entity = _instances[p_view2_5D];

		if (l_instance != null)
		{
			//Spriter hack
			if (gameEntity.getState('2DmeshType') == 'Spriter')
				gameEntity.setState('boundsRect', new Rectangle(-55,-112,140,190));
			else
			{
				//Console.error("Before: Update Bounds [" + gameEntity.getState('name') + "]: " + gameEntity.getState('boundsRect'));
				gameEntity.setState('boundsRect', Sprite.getBounds(l_instance));
				//Console.error("After: Update Bounds [" + gameEntity.getState('name') + "]: " + gameEntity.getState('boundsRect'));
			}
		}
		else
		{
			Console.error("Update Bounds: Instance is null");
		}
	}
	
	//QUERIES
	inline private function _queryRealWidth(p_queryArgument:Dynamic, p_view2_5D:IView2_5D):Dynamic
	{
		//Get Mesh
		var l_mesh:Sprite = _instancesMesh[p_view2_5D];
		
		return l_mesh.getNaturalWidth();
	}
	
	inline private function _queryRealHeight(p_queryArgument:Dynamic, p_view2_5D:IView2_5D):Dynamic
	{
		//Get Mesh
		var l_mesh:Sprite = _instancesMesh[p_view2_5D];
		
		return l_mesh.getNaturalHeight();
	}
	
	inline private function _queryBoundsWidth(p_queryArgument:Dynamic, p_view2_5D:IView2_5D):Dynamic
	{
		//Get Entity
		var l_instance:Entity = _instances[p_view2_5D];
		
		return Sprite.getBounds(l_instance).width;
	}
	
	inline private function _queryBoundsHeight(p_queryArgument:Dynamic, p_view2_5D:IView2_5D):Dynamic
	{
		//Get Entity
		var l_instance:Entity = _instances[p_view2_5D];
		
		return Sprite.getBounds(l_instance).height;
	}
	
	inline private function _queryRealX(p_queryArgument:Dynamic, p_view2_5D:IView2_5D):Dynamic
	{
		//Get Mesh
		var l_mesh:Sprite = _instancesMesh[p_view2_5D];
		
		return l_mesh.x._;
	}
	
	inline private function _queryRealY(p_queryArgument:Dynamic, p_view2_5D:IView2_5D):Dynamic
	{
		//Get Mesh
		var l_mesh:Sprite = _instancesMesh[p_view2_5D];
		
		return l_mesh.y._;
	}
	
	inline private function _queryRealRotation(p_queryArgument:Dynamic, p_view2_5D:IView2_5D):Dynamic
	{
		//Get Mesh
		var l_mesh:Sprite = _instancesMesh[p_view2_5D];
		
		return l_mesh.rotation;
	}
}