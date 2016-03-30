/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, January 2015
 */

package tools.spark.framework.dom2_5D;

import flambe.math.Point;
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
		_updateStateFunctions['acceptsKeyboardInput'] = _updateAcceptsKeyboardInput;
		_updateStateFunctions['draggable'] = _updateDraggable;
		_updateStateFunctions['dropTarget'] = _updateDropTarget;
		_updateStateFunctions['NCstyleable'] = _updateNCstyleable;
		_updateStateFunctions['visibility'] = _updateVisibility;
		_updateStateFunctions['opacity'] = _updateOpacity;
		_updateStateFunctions['display'] = _updateDisplay;
		_updateStateFunctions['text'] = _updateText;
		_updateStateFunctions['fontColor'] = _updateFontColor;
		_updateStateFunctions['src'] = _updateImageSrc;
		_updateStateFunctions['fontSize'] = _updateFontSize;
		_updateStateFunctions['fontWeight'] = _updateFontWeight;
		_updateStateFunctions['overflow'] = _updateOverflow;
		_updateStateFunctions['width'] = _updateWidth;
		_updateStateFunctions['height'] = _updateHeight;
		_updateStateFunctions['top'] = _updateTop;
		_updateStateFunctions['left'] = _updateLeft;
		_updateStateFunctions['backgroundColor'] = _updateBackgroundColor;
		_updateStateFunctions['border'] = _updateBorder;
		_updateStateFunctions['borderColor'] = _updateBorderColor;
		
		_queryFunctions['globalPosition'] = _queryGlobalPosition;
		_queryFunctions['groupObject'] = _queryGroupObject;
	}
	
	
	override public function createInstance (p_view2_5D:IView2_5D):Dynamic
	{
		switch (gameEntity.getState( 'NCmeshType' ))
		{
			case "Div":
				_instances[p_view2_5D] = Browser.document.createDivElement();
			case "Input":
				_instances[p_view2_5D] = Browser.document.createInputElement();
				_instances[p_view2_5D].onchange = _onChange;
				_instances[p_view2_5D].style.outline = "0"; //remove blue border when selected.. it's a hack, fix me
			case "Button":
				//_instances[p_view2_5D] = Browser.document.createButtonElement();
				_instances[p_view2_5D] = Browser.document.createDivElement();
				_instances[p_view2_5D].style.outline = "0"; //remove blue border when selected.. it's a hack, fix me
			case "Image":
				_instances[p_view2_5D] = Browser.document.createImageElement();
			case "Ace":
				_instances[p_view2_5D] = Browser.document.createDivElement();
			case "Tree":
				_instances[p_view2_5D] = Browser.document.createDivElement();
			case "Scroller":
				_instances[p_view2_5D] = Browser.document.createDivElement();
			default:
				//@fixme: If this element was not meant to be rendered at all, don't let it create a DomEntity at all!!!
				Console.error("Unrecognised NCMeshType input. Creating a Div By Default.");
				_instances[p_view2_5D] = Browser.document.createDivElement();
		}
		
		_instances[p_view2_5D].style.position = "absolute";

		return super.createInstance(p_view2_5D);
	}

	override private function _createChildOfInstance(p_childEntity:IEntity2_5D, p_view2_5D:IView2_5D, p_index:Int=-1):Void
	{
		//This is an 'instance' addChild... a dom addChild..
		//@todo: do a insertBefore(this.children[p_index]) something, if p_index is not -1
		_instances[p_view2_5D].appendChild(cast(p_childEntity.createInstance(p_view2_5D), Element));
		
		super._createChildOfInstance(p_childEntity, p_view2_5D, p_index);
	}
	
	override private function _removeChildOfInstance(p_childEntity:IEntity2_5D, p_view2_5D:IView2_5D):Void
	{
		//This is an 'instance' removeChild... a dom removeChild..
		_instances[p_view2_5D].removeChild(cast(p_childEntity.getInstance(p_view2_5D), Element));
		
		super._removeChildOfInstance(p_childEntity, p_view2_5D);
	}
		
	override public function update(?p_view2_5D:IView2_5D):Void
	{
		//Temp way to batch everything together.. not good for updating individual properties, but good for implementing shit faast
		_updateState('NCmeshType', p_view2_5D); //this should nest all relevant attribute updates
		
		//Update Style
		if (gameEntity.getState('NCstyleable') == true)
		{
			_updateState('NCstyleable', p_view2_5D);
			_updateState('visibility', p_view2_5D);
			_updateState('opacity', p_view2_5D);
			_updateState('fontSize', p_view2_5D);
			_updateState('fontWeight', p_view2_5D);
			_updateState('fontColor', p_view2_5D);
			_updateState('overflow', p_view2_5D);
			_updateState('backgroundColor', p_view2_5D);
			_updateState('border', p_view2_5D);
			_updateState('borderColor', p_view2_5D);
		}
		
		//Update display Stuff
		_updateState('display', p_view2_5D);
		
		//Update Touchable Stuff
		_updateState('touchable', p_view2_5D);
		
		//Update Accepts Keyboard Input Stuff
		_updateState('acceptsKeyboardInput', p_view2_5D);
		
		//Update Draggable Stuff
		_updateState('draggable', p_view2_5D);
		
		//Update DropTarget Stuff
		_updateState('dropTarget', p_view2_5D);
		
		//Update Text Stuff
		if (gameEntity.getState('text')!=null)
			_updateState('text', p_view2_5D);
			
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
		var l_mesh:Element = _instances[p_view]; //So yeah... I guess setPos only works for 1 View.. haven't done it to support multiple views..
		
		if (l_mesh != null)		
		{
			if (p_x != null)  l_mesh.style.left = Std.string(p_x) + "px";
			if (p_y != null) l_mesh.style.top = Std.string(p_y) + "px";
			if (p_width != null) l_mesh.style.width = Std.string(p_width) + "px";
			if (p_height != null) l_mesh.style.height = Std.string(p_height) + "px";
		}
		
		super.setPosSize(p_x,p_y,p_width,p_height,p_view);
	}
	
	//Temp way to batch everything together.. not good for updating individual properties, but good for implementing shit faast
	inline private function _updateNCstyleable(p_NCstyleable:String, p_view2_5D:IView2_5D):Void
	{
		if (gameEntity.getState('borderRadius') != null && gameEntity.getState('borderRadius')!="Undefined")
			_instances[p_view2_5D].style.borderRadius = gameEntity.getState('borderRadius');
			
		if (gameEntity.getState('borderStyle') != null && gameEntity.getState('borderStyle')!="Undefined")
			_instances[p_view2_5D].style.borderStyle = gameEntity.getState('borderStyle');
			
		if (gameEntity.getState('borderWidth') != null && gameEntity.getState('borderWidth')!="Undefined")
			_instances[p_view2_5D].style.borderWidth = gameEntity.getState('borderWidth');
			
		if (gameEntity.getState('boxShadow') != null && gameEntity.getState('boxShadow')!="Undefined")
			_instances[p_view2_5D].style.boxShadow = gameEntity.getState('boxShadow');
			
		if (gameEntity.getState('fontFamily') != null && gameEntity.getState('fontFamily')!="Undefined")
			_instances[p_view2_5D].style.fontFamily = gameEntity.getState('fontFamily');
			
		if (gameEntity.getState('textAlign') != null && gameEntity.getState('textAlign')!="Undefined")
			_instances[p_view2_5D].style.textAlign = gameEntity.getState('textAlign');
			
		if (gameEntity.getState('textVerticalAlign') != null && gameEntity.getState('textVerticalAlign') != "Undefined")
		{	//Huge hack..:) but I'm ok with it..
			if (gameEntity.getState('textVerticalAlign')=='middle')
				_instances[p_view2_5D].style.lineHeight = gameEntity.getState('height') + "px";
		}
			
		if (gameEntity.getState('textIndent') != null && gameEntity.getState('textIndent')!="Undefined")
			_instances[p_view2_5D].style.textIndent = gameEntity.getState('textIndent');
			
		if (gameEntity.getState('cursor') != null && gameEntity.getState('cursor')!="Undefined")
			_instances[p_view2_5D].style.cursor = gameEntity.getState('cursor');
			
		if (gameEntity.getState('white-space') != null && gameEntity.getState('white-space')!="Undefined")
			_instances[p_view2_5D].style.whiteSpace = gameEntity.getState('white-space');
			
		if (gameEntity.getState('selectable') != null)
		{
			if (gameEntity.getState('selectable') == false)
			{
				_instances[p_view2_5D].style.setProperty("-webkit-user-select","none"); /* Chrome all / Safari all */
				_instances[p_view2_5D].style.setProperty("-moz-user-select","none"); /* Firefox all */
				_instances[p_view2_5D].style.setProperty("-ms-user-select","none"); /* IE 10+ */
				_instances[p_view2_5D].style.setProperty("user-select","none"); /* Likely future */        
			}
			else
			{
				_instances[p_view2_5D].style.setProperty("-webkit-user-select","initial"); /* Chrome all / Safari all */
				_instances[p_view2_5D].style.setProperty("-moz-user-select","initial"); /* Firefox all */
				_instances[p_view2_5D].style.setProperty("-ms-user-select","initial"); /* IE 10+ */
				_instances[p_view2_5D].style.setProperty("user-select","initial"); /* Likely future */ 
			}
		}
	}
	

	//much better way.. should be done for everything
	inline private function _updateImageSrc(p_src:String, p_view2_5D:IView2_5D):Void
	{
		//Get the instance we're updating
		var l_instance:ImageElement = _instances[p_view2_5D];
		
		if (p_src != "Undefined")
		{
			 //hack.. for full length dom image urls //CHECK IF THIS HACK NO LONGER REQUIRED. I DONT THINK I USE ../ FOR ANYTHING ANYMORE!!!
			if (p_src.indexOf('assets/') == -1)
			{
				if (p_src.indexOf('http') == -1)
				{
					//Normal loading (but not quite, still there's the SparkEditor:References hacky thing, for Dom stuff..)
					var l_asset:Asset = Project.main.modules["SparkEditor:References"].assets[p_src];
					l_instance.src = Project.main.getPath(l_asset.location, l_asset.type) +'/' + l_asset.url;
				}
				else
				{
					l_instance.src = p_src;
				}
			}
			else
			{
				//Temp thing for Cross Domain requests during TESTING //REMOVE ME ON RELEASE
				//pass whole url hack ( and another hack for relative url)
				//l_instance.src = "../" + p_src;
				l_instance.src = "http://130.211.172.86" + p_src;
				//END OF //Temp thing for Cross Domain requests during TESTING //REMOVE ME ON RELEASE
			}
		}
	}
	
	
	//much better way.. should be done for everything
	inline private function _updateWidth(p_width:String, p_view2_5D:IView2_5D):Void
	{
		if (gameEntity.getState('layoutable') == true)
		{
			//This is bad.. put it in Space2_5D for everyone..
			groupInstances[p_view2_5D].updateState('width');
			
			//Invalidate Layout (hack?)
			Sliced.display.projectActiveSpaceReference.activeStageReference.layoutManager.validated=false;
		}
		else
		{
			//..
		}
	}
	
	//much better way.. should be done for everything
	inline private function _updateHeight(p_height:String, p_view2_5D:IView2_5D):Void
	{
		if (gameEntity.getState('layoutable') == true)
		{
			//This is bad.. put it in Space2_5D for everyone..
			groupInstances[p_view2_5D].updateState('height');
			
			//Invalidate Layout (hack?)
			Sliced.display.projectActiveSpaceReference.activeStageReference.layoutManager.validated=false;
		}
		else
		{
			//..
		}
	}
	
	inline private function _updateTop(p_top:String, p_view2_5D:IView2_5D):Void
	{
		if (gameEntity.getState('layoutable') == true)
		{
			//This is bad.. put it in Space2_5D for everyone..
			groupInstances[p_view2_5D].updateState('top');
			
			//Invalidate Layout (hack?)
			Sliced.display.invalidateLayout();
		}
		else
		{
			//..
		}
	}
	
	inline private function _updateLeft(p_left:String, p_view2_5D:IView2_5D):Void
	{
		if (gameEntity.getState('layoutable') == true)
		{
			//This is bad.. put it in Space2_5D for everyone..
			groupInstances[p_view2_5D].updateState('left');
			
			//Invalidate Layout (hack?)
			Sliced.display.invalidateLayout();
		}
		else
		{
			//..
		}
	}
	
	//much better way.. should be done for everything
	inline private function _updateOverflow(p_overflow:String, p_view2_5D:IView2_5D):Void
	{
		if (p_overflow!="Undefined")
			_instances[p_view2_5D].style.overflow = p_overflow;
	}
	
	//much better way.. should be done for everything
	inline private function _updateFontSize(p_fontSize:String, p_view2_5D:IView2_5D):Void
	{
		if (p_fontSize!="Undefined")
			_instances[p_view2_5D].style.fontSize = p_fontSize;
	}
	
	//much better way.. should be done for everything
	inline private function _updateFontWeight(p_fontWeight:String, p_view2_5D:IView2_5D):Void
	{
		if (p_fontWeight!="Undefined")
			_instances[p_view2_5D].style.fontWeight = p_fontWeight;
	}
	
	//much better way.. should be done for everything
	inline private function _updateFontColor(p_fontColor:String, p_view2_5D:IView2_5D):Void
	{
		if (p_fontColor!="Undefined")
			_instances[p_view2_5D].style.color = p_fontColor;
	}
	
	//much better way.. should be done for everything (also visibility should be for all dom elements not just ncStylables
	inline private function _updateVisibility(p_visibility:String, p_view2_5D:IView2_5D):Void
	{
		_instances[p_view2_5D].style.visibility = p_visibility;
	}
	
	//much better way.. should be done for everything
	inline private function _updateOpacity(p_opacity:String, p_view2_5D:IView2_5D):Void
	{
		_instances[p_view2_5D].style.opacity= p_opacity;
	}
	
	//much better way.. should be done for everything
	inline private function _updateBackgroundColor(p_backgroundColor:String, p_view2_5D:IView2_5D):Void
	{
		if (p_backgroundColor!="Undefined")
			_instances[p_view2_5D].style.backgroundColor = p_backgroundColor;
	}
	
	inline private function _updateBorder(p_border:String, p_view2_5D:IView2_5D):Void
	{
		if (p_border!="Undefined")
			_instances[p_view2_5D].style.border = p_border;
	}
	
	inline private function _updateBorderColor(p_borderColor:String, p_view2_5D:IView2_5D):Void
	{
		if (p_borderColor!="Undefined")
			_instances[p_view2_5D].style.borderColor = p_borderColor;
	}
	
	//much better way.. should be done for everything
	inline private function _updateDisplay(p_display:String, p_view2_5D:IView2_5D):Void
	{
		_instances[p_view2_5D].style.display = p_display;
		/*
		if (p_display == "none")
			_instances[p_view2_5D].style.setProperty("pointer-events", "none");
		else
			_instances[p_view2_5D].style.setProperty("pointer-events", "auto");*/
	}
	
	//much better way.. should be done for everything (also visibility should be for all dom elements not just ncStylables
	inline private function _updateText(p_text:String, p_view2_5D:IView2_5D):Void
	{
		if (p_text!="Undefined")
			switch (gameEntity.getState( 'NCmeshType' ))
			{
				case "Div":
					_instances[p_view2_5D].innerHTML = p_text;
				case "Input":
					_instances[p_view2_5D].value = p_text;
				case "Button":
					_instances[p_view2_5D].innerHTML = p_text;
				default:
			}
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
				_updateImageSrc(gameEntity.getState('src') , p_view2_5D);
			case 'Ace':
				_updateAceProperties(p_view2_5D);
			case 'Tree':
				_updateTreeProperties(p_view2_5D);
			case 'Scroller':
				_updateScrollerProperties(p_view2_5D);
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
			l_instance.type = gameEntity.getState('type');
			
		if (gameEntity.getState('type') == "file")
			if (gameEntity.getState('accept') != null && gameEntity.getState('accept')!="Undefined")
				l_instance.accept = gameEntity.getState('accept');
	}
	
	
	//Temp way to batch everything together.. not good for updating individual properties, but good for implementing shit faast
	private function _updateButtonProperties( p_view2_5D:IView2_5D):Void
	{
		//Get the instance we're updating
		var l_instance:ButtonElement = _instances[p_view2_5D];

		if (gameEntity.getState('text') != null && gameEntity.getState('text')!="Undefined")
			l_instance.innerHTML = gameEntity.getState('text');
	}
	
	//Temp way to batch everything together.. not good for updating individual properties, but good for implementing shit faast
	private function _updateAceProperties( p_view2_5D:IView2_5D):Void
	{
		//Get the instance we're updating
		var l_instance:DivElement = _instances[p_view2_5D];

		l_instance.id = "editor";
		var editor:Dynamic = untyped ace.edit("editor");
		editor.setTheme("ace/theme/merbivore_soft");
		editor.getSession().setMode("ace/mode/xml");
		
		gameEntity.setState('aceObject', editor);
	}
	
	//Temp way to batch everything together.. not good for updating individual properties, but good for implementing shit faast
	private function _updateTreeProperties( p_view2_5D:IView2_5D):Void
	{
		//Get the instance we're updating
		var l_instance:DivElement = _instances[p_view2_5D];

		l_instance.id = "tree";
		var tree:Dynamic = untyped $('#tree');
		l_instance.style.overflowX = "hidden";
		l_instance.style.overflowY = "scroll";
		
		gameEntity.setState('treeObject', tree);
	}
	
	//Temp way to batch everything together.. not good for updating individual properties, but good for implementing shit faast
	private function _updateScrollerProperties( p_view2_5D:IView2_5D):Void
	{
		//Get the instance we're updating
		var l_instance:DivElement = _instances[p_view2_5D];
		
		//CSS
		//l_instance.className = "mCustomScrollbar";
		//l_instance.setAttribute('data-mcs-theme', 'dark');
		//l_instance.style.overflowX = "hidden";
		l_instance.style.overflowY = "auto";
		
		//JS
		//So apparently, I need to re-retrieve the div with jquery for some reason...
		//The random thing is so we can do this on many elements (do it for tree and ace too)
		var l_randomId:String = Std.string(Std.random(999999));
		l_instance.id = l_randomId;
		var l_element:Dynamic = untyped $('#'+l_randomId);
		
		//SPECIFIC API
		l_element.mCustomScrollbar({
			theme:"light-thick",
			scrollButtons:{
			  enable:true
			},
			autoHideScrollbar: true,
			autoExpandScrollbar: true
		  });
		
		  var l_containerElement:Element = l_instance.firstElementChild.firstElementChild;
		  l_containerElement.style.marginRight = "0";
		
		//STORE OBJECTS
		gameEntity.setState('scrollerObject', l_element);
		gameEntity.setState('scrollerContainerObject', l_containerElement);
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
				l_instance.oncontextmenu = _onMouseRightClick;
				l_instance.onmousedown = _onMouseDown;
				l_instance.onmouseup = _onMouseUp;
				l_instance.onmouseenter = _onMouseEnter;
				l_instance.onmouseleave = _onMouseLeave;
				l_instance.onwheel = _onScroll;
			}
			else
			{
				//@todo: should really consider actually removing those listeners, here.... use the disposer component thing
				//if you don't want to store the signal Connections..and retrieve disposer here, from the entity. Disposer way looks better anyway...
				//l_instance.pointerEnabled = false;
				
				
				//This should be on its own function...  or not.. in any case, we need this even if its not touchable.. for convenience i guess and it makes sense
				if (gameEntity.getState('preventDefaultEvents'))
				{
					l_instance.oncontextmenu = _preventDefault;
				}
			}
			
			
			
		}
	}
	
	private function _preventDefault():Bool
	{
		return false;
	}
	
	private function _updateAcceptsKeyboardInput(p_acceptsKeyboardInputFlag:Bool, p_view2_5D:IView2_5D):Void
	{
		//Gt Mesh
		var l_instance:Element = _instances[p_view2_5D];
		
		if (l_instance != null)
		{
			if (p_acceptsKeyboardInputFlag)
			{
				//@think: another way to do this without having a p_acceptsKeyboardInputFlag flag it to check if there are triggers actually connected to the gameEntity that want these signals, ad play like that
				//also be sure to update if someone adds a trigger to the entity at runtime (do an addTrigger event, the same fashion you update states, childs, etc)
				//l_instance.pointerEnabled = true;
				
				/*
				if (!l_instance.pointerIn.hasListeners())
					l_instance.pointerIn.connect(_onPointerIn);
					
				if (!l_instance.pointerOut.hasListeners())
					l_instance.pointerOut.connect(_onPointerOut);
				*/
				
				l_instance.onkeypress = _onKeyPress;
				l_instance.onkeyup = _onKeyRelease;
				l_instance.onkeydown = _onKeyDown;
				
				l_instance.tabIndex = 1;
			}
			else
			{
				//@todo: should really consider actually removing those listeners, here.... use the disposer component thing
				//if you don't want to store the signal Connections..and retrieve disposer here, from the entity. Disposer way looks better anyway...
				//l_instance.pointerEnabled = false;
			}
			
		}
	}
	
	private function _updateDraggable(p_flag:Bool, p_view2_5D:IView2_5D):Void
	{
		//Gt Mesh
		var l_instance:Element = _instances[p_view2_5D];
		
		if (l_instance != null)
		{
			if (p_flag)
			{
				l_instance.ondragstart = _onDragStart;
				l_instance.ondrag = _onDrag;
				l_instance.ondragend = _onDragEnd;
			}
			else
			{
				//@todo: should really consider actually removing those listeners, here....
			}
			
		}
	}
	
	//QUERIES
	inline private function _queryGlobalPosition(p_queryArgument:Dynamic, p_view2_5D:IView2_5D):Dynamic
	{
		var l_instance:Element = _instances[p_view2_5D];
		
		var l_top:Int = 0;
		var l_left:Int = 0;
		
		do {
			l_top += l_instance.offsetTop;
			l_left += l_instance.offsetLeft;
			l_instance = l_instance.offsetParent;
		} while (l_instance!=null);
	
	
		return new Point(l_left, l_top);
	}
	
	inline private function _queryGroupObject(p_queryArgument:Dynamic, p_view2_5D:IView2_5D):Dynamic
	{
		return groupInstances[p_view2_5D];
	}
	
	
	private function _onDragStart(p_event:Dynamic):Void
	{
		gameEntity.setState('eventObject', p_event);
		Sliced.event.raiseEvent(ON_DRAG_START, gameEntity);
	}
	
	private function _onDrag(p_event:Dynamic):Void
	{
		gameEntity.setState('eventObject', p_event);
		Sliced.event.raiseEvent(ON_DRAG, gameEntity);
	}
	
	private function _onDragEnd(p_event:Dynamic):Void
	{
		gameEntity.setState('eventObject', p_event);
		Sliced.event.raiseEvent(ON_DRAG_END, gameEntity);
	}
	
	
	private function _updateDropTarget(p_flag:Bool, p_view2_5D:IView2_5D):Void
	{
		//Gt Mesh
		var l_instance:Element = _instances[p_view2_5D];
		
		if (l_instance != null)
		{
			if (p_flag)
			{
				l_instance.ondragenter = _onDragEnter;
				l_instance.ondragover = _onDragOver;
				l_instance.ondragleave = _onDragLeave;
				l_instance.ondrop = _onDrop;
			}
			else
			{
				//@todo: should really consider actually removing those listeners, here....
			}
			
		}
	}
	
	private function _onDragEnter(p_event:Dynamic):Void
	{
		gameEntity.setState('eventObject', p_event);
		Sliced.event.raiseEvent(ON_DRAG_ENTER, gameEntity);
	}
	
	
	private function _onDragOver(p_event:Dynamic):Void
	{
		gameEntity.setState('eventObject', p_event);
		p_event.preventDefault();
		Sliced.event.raiseEvent(ON_DRAG_OVER, gameEntity);
	}
	
	private function _onDragLeave(p_event:Dynamic):Void
	{
		gameEntity.setState('eventObject', p_event);
		Sliced.event.raiseEvent(ON_DRAG_LEAVE, gameEntity);
	}
	
	private function _onDrop(p_event:Dynamic):Void
	{
		gameEntity.setState('eventObject', p_event);
		p_event.preventDefault();
		Sliced.event.raiseEvent(ON_DROP, gameEntity);
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
	
	
	private function _onKeyPress(p_event:Dynamic):Void
	{
		gameEntity.setState('eventObjectKeyPress', p_event);
		if (gameEntity.getState('preventDefaultEvents'))
			p_event.preventDefault();
		Sliced.event.raiseEvent(EEventType.KEY_PRESSED_LOCAL, gameEntity);
	}
	
	private function _onKeyRelease(p_event:Dynamic):Void
	{
		gameEntity.setState('eventObjectKeyRelease', p_event);
		if (gameEntity.getState('preventDefaultEvents'))
			p_event.preventDefault();
		Sliced.event.raiseEvent(EEventType.KEY_RELEASED_LOCAL, gameEntity);
	}
	
	private function _onKeyDown(p_event:Dynamic):Void
	{
		gameEntity.setState('eventObjectKeyDown', p_event);
		if (gameEntity.getState('preventDefaultEvents'))
			p_event.preventDefault();
		Sliced.event.raiseEvent(EEventType.KEY_DOWN_LOCAL, gameEntity);
	}
	
	private function _onPointerClick(p_event:Dynamic):Void
	{
		gameEntity.setState('eventObject', p_event);
		Sliced.input.pointer.submitPointerEvent(MOUSE_LEFT_CLICK, gameEntity);
	}
	
	private function _onMouseRightClick(p_event:Dynamic):Void
	{
		if (gameEntity.getState('preventDefaultEvents'))
			p_event.preventDefault();
			
		gameEntity.setState('eventObject', p_event);
		Sliced.input.pointer.submitPointerEvent(MOUSE_RIGHT_CLICK, gameEntity);
	}
	
	private function _onMouseDown(p_event:Dynamic):Void
	{
		gameEntity.setState('eventObject', p_event);
		Sliced.input.pointer.submitPointerEvent(MOUSE_DOWN, gameEntity);
	}
	
	private function _onMouseUp(p_event:Dynamic):Void
	{
		gameEntity.setState('eventObject', p_event);
		Sliced.input.pointer.submitPointerEvent(MOUSE_UP, gameEntity);
	}
	
	private function _onMouseEnter(p_event:Dynamic):Void
	{
		gameEntity.setState('eventObject', p_event);
		Sliced.input.pointer.submitPointerEvent(MOUSE_ENTERED, gameEntity);
	}
	
	private function _onMouseLeave(p_event:Dynamic):Void
	{
		gameEntity.setState('eventObject', p_event);
		Sliced.input.pointer.submitPointerEvent(MOUSE_LEFT, gameEntity);
	}
	
		private function _onScroll(p_event:Dynamic):Void
	{
		gameEntity.setState('eventObject', p_event);
		Sliced.input.pointer.submitPointerEvent(MOUSE_SCROLL, gameEntity);
	}
	
	private function _onChange(p_changeEvent:Dynamic):Void
	{
		//you should emit a spark event here at some point..
		if (gameEntity.getState('type') == "file")
		{
			gameEntity.setState('files', p_changeEvent.target.files);
			Sliced.input.pointer.submitPointerEvent(MOUSE_LEFT_CLICK, gameEntity);
		}
		else
		{
			gameEntity.setState('text', p_changeEvent.target.value);
			Sliced.event.raiseEvent(CHANGED, gameEntity);
		}
	}
}
