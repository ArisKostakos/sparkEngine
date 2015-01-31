/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, January 2015
 */

package tools.spark.framework.space2_5D.layout.core;
import tools.spark.framework.layout.containers.Group;
import tools.spark.framework.space2_5D.interfaces.IEntity2_5D;
import tools.spark.framework.space2_5D.interfaces.IScene2_5D;
import tools.spark.framework.space2_5D.interfaces.IView2_5D;
import tools.spark.framework.layout.layouts.ALayoutBase;
import tools.spark.framework.space2_5D.layout.interfaces.ILayoutable;

/**
 * ...
 * @author Aris Kostakos
 */
class GroupSpace2_5D implements ILayoutable
{
	public var group( default, null ):Group;
	public var children( default, null ):ILayoutable;
	
	
	
	public var layout( default, set ):ALayoutBase;
	
	public var width( default, default ):Int;
	public var height( default, default ):Int;
	
	private var _attachedView:IView2_5D;
	
	private var _view2_5D:IView2_5D;
	private var _scene2_5D:IScene2_5D;
	private var _entity2_5D:IEntity2_5D;
	private var _type:String;
	
	public function new(p_type:String, p_attachedView:IView2_5D, ?p_viewObject:IView2_5D, ?p_sceneObject:IScene2_5D, ?p_entityObject:IEntity2_5D) 
	{
		_type = p_type;
		_attachedView = p_attachedView;
		switch (_type)
		{
			case "view":
				_view2_5D = p_viewObject;
			case "scene":
				_scene2_5D = p_sceneObject;
			case "entity":
				_entity2_5D = p_entityObject;
		}
		
		//width = flambe.System.stage.width;
		//height = flambe.System.stage.height;
		_init();
	}
	
	inline private function _init():Void
	{
		
	}
	
	
	private function set_layout( p_value : ALayoutBase ) : ALayoutBase 
	{
		//If the layout is already attached to this Group, do nothing
		if (layout == p_value)
			return layout;
			
		layout = p_value;
		
		return layout;
	}
	
	public function measure():Void
	{
		layout.measure();
	}
	
	public function updateDisplayList(p_width:Float, p_height:Float):Void
    {
		layout.updateDisplayList(p_width, p_height);
    }
}