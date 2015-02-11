/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, January 2015
 */

package tools.spark.framework.dom2_5D;

import js.html.DivElement;
import js.html.InputElement;
import js.html.ImageElement;
import js.html.ButtonElement;
import js.html.Element;
import js.Browser;
import tools.spark.framework.assets.Asset;
import tools.spark.framework.space2_5D.core.AEntity2_5D;
import tools.spark.framework.space2_5D.interfaces.IEntity2_5D;
import tools.spark.framework.space2_5D.interfaces.IView2_5D;
import tools.spark.sliced.core.Sliced;
import tools.spark.sliced.services.std.logic.gde.interfaces.EEventType;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;

/**
 * ...
 * @author Aris Kostakos
 */
class DomEntity2_5D extends AEntity2_5D
{
	public function new(p_gameEntity:IGameEntity) 
	{
		super(p_gameEntity);
		_initDomEntity2_5D();
	}
	
	private function _initDomEntity2_5D()
	{
		_updateStateFunctions['NCmeshType'] = _updateNCmeshType;
		_updateStateFunctions['touchable'] = _updateTouchable;
		_updateStateFunctions['NCstyleable'] = _updateNCstyleable;
	}
	
	
	override public function createInstance (p_view2_5D:IView2_5D):Dynamic
	{
		switch (gameEntity.getState( 'NCmeshType' ))
		{
			case "Div":
				_instances[p_view2_5D] = Browser.document.createDivElement();
				//_instances[p_view2_5D].style.backgroundColor = "green";
			case "Input":
				_instances[p_view2_5D] = Browser.document.createInputElement();
			case "Button":
				_instances[p_view2_5D] = Browser.document.createButtonElement();
			case "Image":
				_instances[p_view2_5D] = Browser.document.createImageElement();
			default:
				//@fixme: If this element was not meant to be rendered at all, don't let it create a DomEntity at all!!!
				Console.error("Unrecognised NCMeshType input. Creating a Div By Default.");
				_instances[p_view2_5D] = Browser.document.createDivElement();
		}
		
		_instances[p_view2_5D].style.position = "absolute";

		return super.createInstance(p_view2_5D);
	}

	override private function _createChildOfInstance(p_childEntity:IEntity2_5D, p_view2_5D:IView2_5D):Void
	{
		//This is an 'instance' addChild... a flambe addChild..
		_instances[p_view2_5D].appendChild(cast(p_childEntity.createInstance(p_view2_5D), Element));
		
		super._createChildOfInstance(p_childEntity, p_view2_5D);
	}

	override public function update(?p_view2_5D:IView2_5D):Void
	{
		//Temp way to batch everything together.. not good for updating individual properties, but good for implementing shit faast
		_updateState('NCmeshType', p_view2_5D); //this should nest all relevant attribute updates
		
		//Update Style
		if (gameEntity.getState('NCstyleable') == true)
			_updateState('NCstyleable', p_view2_5D);
		
		//Update Touchable Stuff
		_updateState('touchable', p_view2_5D);
			
		//Update my layoutObject
		if (gameEntity.getState('layoutable') == true)
			_updateLayoutGroup(p_view2_5D);
		
		//Update Children
		for (f_childEntity in children)
			f_childEntity.update(p_view2_5D);
	}
	
	override public function setPosSize(?p_x:Null<Float>, ?p_y:Null<Float>, ?p_width:Null<Float>, ?p_height:Null<Float>, ?p_view:IView2_5D):Void
	{
		//Get Mesh
		var l_mesh:Element = _instances[p_view];
		
		if (l_mesh != null)		
		{
			if (p_x != null) l_mesh.style.left = Std.string(p_x) + "px";
			if (p_y != null) l_mesh.style.top = Std.string(p_y) + "px";
			if (p_width != null) l_mesh.style.width = Std.string(p_width) + "px";
			if (p_height != null) l_mesh.style.height = Std.string(p_height) + "px";
		}
	}
	
	//Temp way to batch everything together.. not good for updating individual properties, but good for implementing shit faast
	inline private function _updateNCstyleable(p_NCstyleable:String, p_view2_5D:IView2_5D):Void
	{
		if (gameEntity.getState('backgroundColor') != null && gameEntity.getState('backgroundColor')!="Undefined")
			_instances[p_view2_5D].style.backgroundColor = gameEntity.getState('backgroundColor');
		
		if (gameEntity.getState('border') != null && gameEntity.getState('border')!="Undefined")
			_instances[p_view2_5D].style.border = gameEntity.getState('border');
			
		if (gameEntity.getState('borderRadius') != null && gameEntity.getState('borderRadius')!="Undefined")
			_instances[p_view2_5D].style.borderRadius = gameEntity.getState('borderRadius');
			
		if (gameEntity.getState('boxShadow') != null && gameEntity.getState('boxShadow')!="Undefined")
			_instances[p_view2_5D].style.boxShadow = gameEntity.getState('boxShadow');
			
		if (gameEntity.getState('fontFamily') != null && gameEntity.getState('fontFamily')!="Undefined")
			_instances[p_view2_5D].style.fontFamily = gameEntity.getState('fontFamily');
			
		if (gameEntity.getState('fontSize') != null && gameEntity.getState('fontSize')!="Undefined")
			_instances[p_view2_5D].style.fontSize = gameEntity.getState('fontSize');
			
		if (gameEntity.getState('fontColor') != null && gameEntity.getState('fontColor')!="Undefined")
			_instances[p_view2_5D].style.color = gameEntity.getState('fontColor');
			
		if (gameEntity.getState('textIndent') != null && gameEntity.getState('textIndent')!="Undefined")
			_instances[p_view2_5D].style.textIndent = gameEntity.getState('textIndent');
	}
	
	//Temp way to batch everything together.. not good for updating individual properties, but good for implementing shit faast
	inline private function _updateNCmeshType(p_NCmeshType:String, p_view2_5D:IView2_5D):Void
	{
		switch (p_NCmeshType)
		{
			case 'Div':
				//...
			case 'Button':
				_updateButtonProperties(p_view2_5D);
			case 'Input':
				_updateInputProperties(p_view2_5D);
			case 'Image':
				_updateImageProperties(p_view2_5D);
			case 'Undefined':
				Console.warn('Undefined NCmeshType value');
			default:
				Console.warn('Unhandled NCmeshType value: ' + p_NCmeshType);
		}
	}
	
	//Temp way to batch everything together.. not good for updating individual properties, but good for implementing shit faast
	private function _updateInputProperties( p_view2_5D:IView2_5D):Void
	{
		//Get the instance we're updating
		var l_instance:InputElement = _instances[p_view2_5D];
		
		if (gameEntity.getState('text') != null && gameEntity.getState('text')!="Undefined")
			l_instance.value = gameEntity.getState('text');
		
		if (gameEntity.getState('placeholder') != null && gameEntity.getState('placeholder')!="Undefined")
			l_instance.placeholder = gameEntity.getState('placeholder');
			
		if (gameEntity.getState('type') != null && gameEntity.getState('type')!="Undefined")
			l_instance.type= gameEntity.getState('type');
	}
	
	//Temp way to batch everything together.. not good for updating individual properties, but good for implementing shit faast
	private function _updateImageProperties( p_view2_5D:IView2_5D):Void
	{
		//Get the instance we're updating
		var l_instance:ImageElement = _instances[p_view2_5D];
		
		if (gameEntity.getState('src') != null && gameEntity.getState('src') != "Undefined")
		{
			var l_asset:Asset = Project.modules["DoNotLoad"].assets[gameEntity.getState('src')];
			l_instance.src = Project.getPath(l_asset.location, l_asset.type) + l_asset.url;
		}
	}
	
	//Temp way to batch everything together.. not good for updating individual properties, but good for implementing shit faast
	private function _updateButtonProperties( p_view2_5D:IView2_5D):Void
	{
		//Get the instance we're updating
		var l_instance:ButtonElement = _instances[p_view2_5D];

		if (gameEntity.getState('text') != null && gameEntity.getState('text')!="Undefined")
			l_instance.innerText = gameEntity.getState('text');
	}
	
	
	private function _updateTouchable(p_touchableFlag:Bool, p_view2_5D:IView2_5D):Void
	{
		//Gt Mesh
		var l_instance:Element = _instances[p_view2_5D];
		
		if (l_instance != null)
		{
			if (p_touchableFlag)
			{
				//@think: another way to do this without having a touchable flag it to check if there are triggers actually connected to the gameEntity that want these signals, ad play like that
				//also be sure to update if someone adds a trigger to the entity at runtime (do an addTrigger event, the same fashion you update states, childs, etc)
				//l_instance.pointerEnabled = true;
				
				/*
				if (!l_instance.pointerIn.hasListeners())
					l_instance.pointerIn.connect(_onPointerIn);
					
				if (!l_instance.pointerOut.hasListeners())
					l_instance.pointerOut.connect(_onPointerOut);
				*/
				
				l_instance.onclick = _onPointerClick;
			}
			else
			{
				//@todo: should really consider actually removing those listeners, here.... use the disposer component thing
				//if you don't want to store the signal Connections..and retrieve disposer here, from the entity. Disposer way looks better anyway...
				//l_instance.pointerEnabled = false;
			}
			
		}
	}
	/*
	private function _onPointerIn(p_pointerEvent:PointerEvent):Void
	{
		Sliced.input.pointer.submitPointerEvent(MOUSE_ENTERED, gameEntity);
	}
	
	private function _onPointerOut(p_pointerEvent:PointerEvent):Void
	{
		Sliced.input.pointer.submitPointerEvent(MOUSE_LEFT, gameEntity);
	}
	*/
	private function _onPointerClick(p_pointerEvent:Dynamic):Void
	{
		Sliced.input.pointer.submitPointerEvent(MOUSE_LEFT_CLICK, gameEntity);
	}
}