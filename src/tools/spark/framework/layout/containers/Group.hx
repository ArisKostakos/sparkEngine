/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, January 2015
 */

package tools.spark.framework.layout.containers;
import tools.spark.framework.layout.layouts.ALayoutBase;
import tools.spark.framework.layout.layouts.BasicLayout;

/**
 * ...
 * @author Aris Kostakos
 */
class Group
{
	public var layout( default, set ):ALayoutBase;
	
	//public var width( default, default ):Int;
	//public var height( default, default ):Int;
	//public var minWidth( default, default ):Float;
	//public var minHeight( default, default ):Float;
	//public var maxWidth( default, default ):Null<Float>;
	//public var maxHeight( default, default ):Null<Float>;

	//ACTUAL SHIT
	//positions
	public var x( default, default ):Float;
	public var y( default, default ):Float;
	//sizes
	public var width( default, default ):Float;
	public var height( default, default ):Float;
	
	//SIZES
	//auto-calculated size stuff
	public var measuredWidth( default, default ):Null<Float>;
	public var measuredHeight( default, default ):Null<Float>;
	
	public var preferredWidth( get, null ):Null<Float>;
	public var preferredHeight( get, null ):Null<Float>;
	
	//user input size stuff
	public var explicitWidth( default, default ):Null<Float>;
	public var explicitHeight( default, default ):Null<Float>;
	
	//MIN MAX SIZES
	////auto-calculated Min Max Size stuff
	public var measuredMinWidth( default, default ):Null<Float>;
	public var measuredMinHeight( default, default ):Null<Float>;
	public var measuredMaxWidth( default, default ):Null<Float>;
	public var measuredMaxHeight( default, default ):Null<Float>;

	
	public var preferredMinWidth( get, null ):Null<Float>;
	public var preferredMinHeight( get, null ):Null<Float>;
	public var preferredMaxWidth( get, null ):Null<Float>;
	public var preferredMaxHeight( get, null ):Null<Float>;
	
	//user input Min Max Size stuff
	public var explicitMinWidth( default, default ):Null<Float>;
	public var explicitMinHeight( default, default ):Null<Float>;
	public var explicitMaxWidth( default, default ):Null<Float>;
	public var explicitMaxHeight( default, default ):Null<Float>;
	
	
	//CONSTRAINTS
	public var left( default, default ):Null<Float>;
	public var right( default, default ):Null<Float>;
	public var top( default, default ):Null<Float>;
	public var bottom( default, default ):Null<Float>;
	
	public var horizontalCenter( default, default ):Null<Float>;
	public var verticalCenter( default, default ):Null<Float>;
	
	public var percentWidth( default, default ):Null<Float>;
	public var percentHeight( default, default ):Null<Float>;
	
	//children (if this group is a container)
	public var children( default, null):Array<Group>;
	
	
	public function new(?p_layout : ALayoutBase) 
	{
		if (p_layout!=null)
			layout = p_layout;
		else
			layout = new BasicLayout();
			
		_init();
	}
	
	inline private function _init():Void
	{
		children = new Array<Group>();
		
		x = y = width = height = 0;
		
		layout.target = this;
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
	
	public function setActualSize(?p_width:Float, ?p_height:Float):Void
	{
		if (p_width == null && p_height == null)
		{
			width = preferredWidth;
			height = preferredHeight;
		}
	}
	
	public function get_preferredWidth():Float
    {
        return explicitWidth==null ? measuredWidth : explicitWidth;
    }
	
	public function get_preferredHeight():Float
    {
        return explicitHeight==null ? measuredHeight : explicitHeight;
    }
	
	public function get_preferredMinWidth():Float
    {
        return explicitMinWidth==null ? measuredMinWidth : explicitMinWidth;
    }
	
	public function get_preferredMinHeight():Float
    {
        return explicitMinHeight==null ? measuredMinHeight : explicitMinHeight;
    }
	
	public function get_preferredMaxWidth():Float
    {
        return explicitMaxWidth==null ? measuredMaxWidth : explicitMaxWidth;
    }
	
	public function get_preferredMaxHeight():Float
    {
        return explicitMaxHeight==null ? measuredMaxHeight : explicitMaxHeight;
    }
}