/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, November 2014
 */

package tools.spark.framework.flambe2_5D;

import flambe.display.FillSprite;
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
	private var _instancesMesh:Map<IView2_5D,Sprite>;
	
	public function new(p_gameEntity:IGameEntity) 
	{
		super(p_gameEntity);
		_initFlambeEntity2_5D();
	}
	
	private function _initFlambeEntity2_5D()
	{
		_instances = new Map<IView2_5D,Entity>();
		_instancesMesh = new Map<IView2_5D,Sprite>();
	}
	
	override public function createInstance (p_view2_5D:IView2_5D):Dynamic
	{
		var l_entity:Entity = new Entity();
		
		_instances[p_view2_5D] = l_entity;
		
		return l_entity;
	}


	override public function update(?p_view2_5D:IView2_5D):Void
	{
		_updateState('2DmeshType', p_view2_5D); //THIS NEEDS TO BE FIRST AT THE UPDATE TO GET THE SPRITE!!!!!!
		
		
		_updateState('spaceX',p_view2_5D);
		_updateState('spaceY',p_view2_5D);
		//_updateState('spaceZ', p_view2_5D);
		
		_updateState('scaleX',p_view2_5D);
		_updateState('scaleY',p_view2_5D);
		//_updateState('scaleZ', p_view2_5D);
		
		_updateState('touchable', p_view2_5D);
		
		//_updateState('2DMeshImageForm', p_view2_5D); //this is nested.. not for global update i think
		//_updateState('2DMeshSpriterForm', p_view2_5D); //this is nested.. not for global update i think
		//more spriter nested things exist also don't update them
	}
	
	
	//For optimization purposes.. to be able to inline the publics
	private function _updateState(p_state:String, ?p_view2_5D:IView2_5D):Void
	{
		updateState(p_state,p_view2_5D);
	}
	
	inline public function updateState(p_state:String, ?p_view2_5D:IView2_5D):Void
	{
		if (p_view2_5D == null)
		{
			//do for all instances
			for (f_view in _instances.keys())
				_updateStateOfInstance(p_state, f_view);
		}
		else
		{
			//do for p_View2_5D instance
			_updateStateOfInstance(p_state, p_view2_5D);
		}
	}
	
	
	inline private function _updateStateOfInstance(p_state:String, p_view2_5D:IView2_5D):Void
	{
		switch (p_state)
		{
			case '2DmeshType':
				_update2DMeshType(gameEntity.getState(p_state),p_view2_5D); //this will also update nested states here like 2DMeshImageForm,..
			case 'spaceX':
				_updatePosition("x", gameEntity.getState(p_state), p_view2_5D); //for pure 2d.. for 3d coordinates, its not that simple..
			case 'spaceY':
				_updatePosition("y", gameEntity.getState(p_state), p_view2_5D); //for pure 2d.. for 3d coordinates, its not that simple..
			case 'scaleX':
				_updateSize("x", gameEntity.getState(p_state), p_view2_5D); //for pure 2d.. for 3d coordinates, its not that simple..
			case 'scaleY':
				_updateSize("y", gameEntity.getState(p_state), p_view2_5D); //for pure 2d.. for 3d coordinates, its not that simple..
			case 'touchable':
				_updateTouchable(gameEntity.getState(p_state), p_view2_5D);
			case '2DMeshImageForm':
				_update2DMeshImageForm(gameEntity.getState(p_state),p_view2_5D);
			case '2DMeshSpriterForm':
				_update2DMeshSpriterForm(gameEntity.getState(p_state), p_view2_5D);
			case '2DMeshFillRectForm':
				_update2DMeshFillRectForm(gameEntity.getState(p_state), p_view2_5D);
			case '2DMeshSpriteForm':
				_update2DMeshSpriteForm(gameEntity.getState(p_state), p_view2_5D);
			case '2DMeshSpriterAnimForm':
				_update2DMeshSpriterAnimForm(gameEntity.getState(p_state),p_view2_5D);
		}
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
			case 'FillRect':
				_updateStateOfInstance('2DMeshFillRectForm', p_view2_5D);
			case 'Sprite':
				_updateStateOfInstance('2DMeshSpriteForm', p_view2_5D);
			case 'Undefined':
				Console.warn('Undefined 2DmeshType value');
			default:
				Console.warn('Unhandled 2DmeshType value: ' + p_2DMeshType);
		}
		
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
			
			
		if (l_mesh == null)
		{
			l_mesh = new ImageSprite(Assets.getTexture(gameEntity.gameForm.getState( p_2DMeshImageForm )));
			l_mesh.blendMode = BlendMode.Copy;
			l_instance.add(l_mesh);
			_instancesMesh[p_view2_5D] = l_mesh;
		}
		else
		{
			l_mesh.texture = Assets.getTexture(gameEntity.gameForm.getState( p_2DMeshImageForm ));	
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
			var l_SpriterFormName:String = gameEntity.gameForm.getState( p_2DMeshSpriterForm );
			var l_spriterMovie:SpriterMovie = new SpriterMovie(Assets.getAssetPackOf(l_SpriterFormName), l_SpriterFormName, null); //this null thing is supposed to be character name (string).. doesn't work though... always plays first character found
			l_mesh.blendMode = BlendMode.Copy;
			l_instance.add(l_mesh);
			l_instance.add( l_spriterMovie);
			_instancesMesh[p_view2_5D] = l_mesh;
		}
		else
		{
			//l_mesh.texture = Assets.getTexture(gameEntity.gameForm.getState( l_imageForm ));	
		}
		
		//Play Animation (nesting)
		_updateStateOfInstance('2DMeshSpriterAnimForm', p_view2_5D);
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
			
			
		if (l_mesh == null)
		{
			l_mesh = new FillSprite(0xff0000,100,100);
			l_mesh.blendMode = BlendMode.Copy;
			l_instance.add(l_mesh);
			_instancesMesh[p_view2_5D] = l_mesh;
		}
		else
		{
			//l_mesh.color =
			//l_mesh.setSize = 
		}
	}
	
	private function _update2DMeshSpriteForm(p_2DMeshSpriteForm:String, p_view2_5D:IView2_5D):Void
	{
		//If the Entity's mesh type is not image, ignore this update
		if (gameEntity.getState('2DmeshType') != 'Sprite')
			return;
			
		//If the Form Name is Undefined, ignore this update
		if (p_2DMeshSpriteForm == 'Undefined')
			return;
			
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
			l_mesh.blendMode = BlendMode.Copy;
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
	

	//@todo: for pure 2d.. for 3d coordinates, its not that simple.. if you want to use the same function for 3d,
	//use p_axis to specifiy "both", or "all 3d" something like that. and ofc make sure you update once, no matter how many setState Events where made
	inline private function _updatePosition(p_axis:String, p_newPos:Int, p_view2_5D:IView2_5D):Void
	{
		//Get Mesh
		var l_mesh:Sprite = _instancesMesh[p_view2_5D];
		
		if (l_mesh != null)
		{
			//@todo: I AM NOT LIKING THIS.. updatePosition should be REALLLLLYYYYYYYYY optimized.. and here I'm comparing strings ://// jeez..
			//maybe just create different inline functions alltogether for updateX and updateY..
			//look it up when you're also doing 2_5D Positioning...
			switch (p_axis)
			{
				case "x":
					l_mesh.x._ = p_newPos;
				case "y":
					l_mesh.y._ = p_newPos;
			}
		}
	}
	
	//@todo: for pure 2d.. for 3d coordinates, its not that simple..
	inline private function _updateSize(p_axis:String, p_newScale:Float, p_view2_5D:IView2_5D):Void
	{
		//Get Mesh
		var l_mesh:Sprite = _instancesMesh[p_view2_5D];
		
		if (l_mesh != null)
		{
			//@todo: Not too crazy about this one either:P scale doesn't hapen often for 2d without 2.5 simulation stuff tho.. so it's not that bad here:)
			switch (p_axis)
			{
				case "x":
					l_mesh.scaleX._ = p_newScale;
				case "y":
					l_mesh.scaleY._ = p_newScale;
			}
		}
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
					
				if (!l_mesh.pointerOut.hasListeners())
					l_mesh.pointerOut.connect(_onPointerOut);
			}
			else
			{
				//@todo: should really consider actually removing those listeners, here.... use the disposer component thing
				//if you don't want to store the signal Connections..and retrieve disposer here, from the entity. Disposer way looks better anyway...
				l_mesh.pointerEnabled = false;
			}
			
		}
	}
	
	inline private function _updateRotation():Void
	{
		
	}
	
	
	private function _onPointerIn(p_pointerEvent:PointerEvent):Void
	{
		Sliced.input.pointer.submitPointerEvent(MOUSE_ENTERED, gameEntity);
	}
	
	private function _onPointerOut(p_pointerEvent:PointerEvent):Void
	{
		Sliced.input.pointer.submitPointerEvent(MOUSE_LEFT, gameEntity);
	}
}