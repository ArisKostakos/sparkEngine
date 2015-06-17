/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, January 2015
 */

package tools.spark.framework.layout.containers;
import tools.spark.framework.layout.interfaces.EColumnAlign;
import tools.spark.framework.layout.interfaces.EHorizontalAlign;
import tools.spark.framework.layout.interfaces.ERowAlign;
import tools.spark.framework.layout.interfaces.ETileOrientation;
import tools.spark.framework.layout.interfaces.EVerticalAlign;
import tools.spark.framework.layout.layouts.ALayoutBase;
import tools.spark.framework.layout.layouts.BasicLayout;
import tools.spark.framework.layout.layouts.HorizontalLayout;
import tools.spark.framework.layout.layouts.TileLayout;
import tools.spark.framework.layout.layouts.VerticalLayout;
import tools.spark.sliced.services.std.logic.gde.interfaces.IGameEntity;

/**
 * ...
 * @author Aris Kostakos
 */
class Group
{
	public var layout( default, set ):ALayoutBase;
	

	//public var minWidth( default, default ):Float;
	//public var minHeight( default, default ):Float;
	//public var maxWidth( default, default ):Null<Float>;
	//public var maxHeight( default, default ):Null<Float>;

	public var includeInLayout( default, default ):Bool;
	
	//ACTUAL SHIT
	//positions
	public var x( default, default ):Float;
	public var y( default, default ):Float;
	//sizes
	public var width( default, default ):Null<Float>;
	public var height( default, default ):Null<Float>;
	
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

	//HORIZONTAL-VERTICAL-TILE
	public var paddingLeft( default, default ):Float;
	public var paddingRight( default, default ):Float;
	public var paddingTop( default, default ):Float;
	public var paddingBottom( default, default ):Float;
	public var horizontalAlign( default, default ):EHorizontalAlign;
	public var verticalAlign( default, default ):EVerticalAlign;
	
	//HORIZONTAL-VERTICAL
	public var gap( default, default ):Float;
	
	//HORIZONTAL-TILE
	public var columnWidth( default, default ):Null<Float>;
	public var requestedColumnCount( default, default ):Int;
	
	//HORIZONTAL
	public var requestedMaxColumnCount( default, default ):Int;
	public var requestedMinColumnCount( default, default ):Int;
	public var variableColumnWidth( default, default ):Bool;
	
	//VERTICAL-TILE
	public var rowHeight( default, default ):Null<Float>;
	public var requestedRowCount( default, default ):Int;
	
	//VERTICAL
	public var requestedMaxRowCount( default, default ):Int;
	public var requestedMinRowCount( default, default ):Int;
	public var variableRowHeight( default, default ):Bool;
	
	//TILE
	public var horizontalGap( default, default ):Float;
	public var verticalGap( default, default ):Float;
	public var rowAlign( default, default ):ERowAlign;
	public var columnAlign( default, default ):EColumnAlign;
	public var orientation( default, default ):ETileOrientation;
	//(small warning, tile defaults for horizontalAlign & verticalAlign should be justify, but they're not)
	
	//Tile Misc	//read only(not in xml)
	public var tileWidthCached( default, default ):Null<Float>;
	public var tileHeightCached( default, default ):Null<Float>;
    public var numElementsCached( default, default ):Int;
	public var visibleStartIndex( default, default ):Int;   // dataProvider/layout element index 
	public var visibleEndIndex( default, default ):Int;     // ...
	public var visibleStartX( default, default ):Float;     // first tile/cell origin
	public var visibleStartY( default, default ):Float;     // ...
	
	public var explicitColumnWidth( default, default ):Null<Float>;
	public var explicitRowHeight( default, default ):Null<Float>;
	public var explicitHorizontalGap( default, default ):Float;
	public var explicitVerticalGap( default, default ):Float;
	
	public var rowCount( default, default ):Int;
	public var columnCount( default, default ):Int;
	
	//children (if this group is a container)
	public var children( default, null):Array<Group>;
	
	public var layoutableEntity ( default, null):IGameEntity;
	public var layoutableInstanceType (default, null):String;
	public var layoutableInstance (default, default):Dynamic;
	
	
	
	public function new(p_layoutableEntity : IGameEntity, p_layoutableInstanceType:String, p_layoutableInstance:Dynamic) 
	{
		layoutableEntity = p_layoutableEntity;
		layoutableInstanceType = p_layoutableInstanceType;
		layoutableInstance = p_layoutableInstance;
		
		_init();
	}
	
	inline private function _init():Void
	{
		children = new Array<Group>();
		
		x = y = width = height = 0;
		visibleStartX = visibleStartY = 0;
		visibleStartIndex = visibleEndIndex = numElementsCached = -1;
		tileWidthCached = tileHeightCached = null;
		rowCount = columnCount = -1;
	}
	
	public function update():Void
	{
		//@fixme soon: i guess here if soemething called update, somehow layoutmanager should get invalidated.
		//maybe pass all updates and even add childs through layout manager after all... so we can invalidate as well
		//seems about right....
		
		//layout
		updateState('layout');
		updateState('includeInLayout');
		
		//absolute
		updateState('x');
		updateState('y');
		
		//width stuff
		updateState('width');
		updateState('height');
		
		//normal constraints
		updateState('left');
		updateState('top');
		updateState('right');
		updateState('bottom');
		updateState('horizontalCenter');
		updateState('verticalCenter');
		
		//horizontal-vertical
		if (layout != null)
		{
			if (layout.layoutType != "Basic")
			{
				updateState('paddingLeft');
				updateState('paddingRight');
				updateState('paddingTop');
				updateState('paddingBottom');
				updateState('horizontalAlign');
				updateState('verticalAlign');
				
				if (layout.layoutType == "Horizontal" || layout.layoutType == "Vertical")
					updateState('gap');
				
				if (layout.layoutType == "Horizontal" || layout.layoutType == "Tile")
				{
					updateState('columnWidth');
					updateState('requestedColumnCount');
				}
					
				if (layout.layoutType == "Horizontal")
				{
					updateState('requestedMaxColumnCount');
					updateState('requestedMinColumnCount');
					updateState('variableColumnWidth');
				}
				
				if (layout.layoutType == "Vertical" || layout.layoutType == "Tile")
				{
					updateState('rowHeight');
					updateState('requestedRowCount');
				}
				
				if (layout.layoutType == "Vertical")
				{
					updateState('requestedMaxRowCount');
					updateState('requestedMinRowCount');
					updateState('variableRowHeight');
				}
				
				if (layout.layoutType == "Tile")
				{
					updateState('horizontalGap');
					updateState('verticalGap');
					updateState('rowAlign');
					updateState('columnAlign');
					updateState('orientation');
				}
			}
		}
	}
	
	public function updateState(p_state:String):Void
	{
		switch (p_state)
		{
			//Layout
			case "layout":
				_updateLayout(layoutableEntity.getState(p_state));
				
			case "includeInLayout":
				includeInLayout = layoutableEntity.getState(p_state);
				
			//Basic
			case "x":
				if (!Math.isNaN(layoutableEntity.getState(p_state))) 
					x = layoutableEntity.getState(p_state);
			case "y":
				if (!Math.isNaN(layoutableEntity.getState(p_state))) 
					y = layoutableEntity.getState(p_state);
			case "width":
				_updateExplicitSize(layoutableEntity.getState(p_state), "width");
			case "height":
				_updateExplicitSize(layoutableEntity.getState(p_state), "height");
			case "left":
				if (!Math.isNaN(layoutableEntity.getState(p_state))) 
					left = layoutableEntity.getState(p_state);
			case "top":
				if (!Math.isNaN(layoutableEntity.getState(p_state))) 
					top = layoutableEntity.getState(p_state);
			case "right":
				if (!Math.isNaN(layoutableEntity.getState(p_state))) 
					right = layoutableEntity.getState(p_state);
			case "bottom":
				if (!Math.isNaN(layoutableEntity.getState(p_state))) 
					bottom = layoutableEntity.getState(p_state);
			case "horizontalCenter":
				if (!Math.isNaN(layoutableEntity.getState(p_state))) 
					horizontalCenter = layoutableEntity.getState(p_state);
			case "verticalCenter":
				if (!Math.isNaN(layoutableEntity.getState(p_state))) 
					verticalCenter = layoutableEntity.getState(p_state);
					
			//Horizontal/Vertical/Tile
			case "paddingLeft":
				paddingLeft = layoutableEntity.getState(p_state);
			case "paddingRight":
				paddingRight = layoutableEntity.getState(p_state);
			case "paddingTop":
				paddingTop = layoutableEntity.getState(p_state);
			case "paddingBottom":
				paddingBottom = layoutableEntity.getState(p_state);
			case "gap":
				gap = layoutableEntity.getState(p_state);
			case "horizontalAlign":
				var s_horAlignStr:String = layoutableEntity.getState(p_state);
				if (s_horAlignStr == "left") horizontalAlign = EHorizontalAlign.LEFT;
				else if (s_horAlignStr == "center") horizontalAlign = EHorizontalAlign.CENTER;
				else if (s_horAlignStr == "right") horizontalAlign = EHorizontalAlign.RIGHT;
				else if (s_horAlignStr == "justify") horizontalAlign = EHorizontalAlign.JUSTIFY;
				else if (s_horAlignStr == "contentJustify") horizontalAlign = EHorizontalAlign.CONTENT_JUSTIFY;
			case "verticalAlign":
				var s_verAlignStr:String = layoutableEntity.getState(p_state);
				if (s_verAlignStr == "top") verticalAlign = EVerticalAlign.TOP;
				else if (s_verAlignStr == "middle") verticalAlign = EVerticalAlign.MIDDLE;
				else if (s_verAlignStr == "bottom") verticalAlign = EVerticalAlign.BOTTOM;
				else if (s_verAlignStr == "justify") verticalAlign = EVerticalAlign.JUSTIFY;
				else if (s_verAlignStr == "contentJustify") verticalAlign = EVerticalAlign.CONTENT_JUSTIFY;
				
			//Horizontal
			case "columnWidth":
				var s_columnWidth:String = layoutableEntity.getState(p_state);
				if (s_columnWidth == "calculated")
					columnWidth = explicitColumnWidth = null;
				else
					columnWidth = explicitColumnWidth = Std.parseFloat(s_columnWidth);
			case "requestedColumnCount":
				requestedColumnCount = layoutableEntity.getState(p_state);
			case "requestedMaxColumnCount":
				requestedMaxColumnCount = layoutableEntity.getState(p_state);
			case "requestedMinColumnCount":
				requestedMinColumnCount = layoutableEntity.getState(p_state);
			case "variableColumnWidth":
				variableColumnWidth = layoutableEntity.getState(p_state);
				
			//Vertical
			case "rowHeight":
				var s_rowHeight:String = layoutableEntity.getState(p_state);
				if (s_rowHeight == "calculated")
					rowHeight = explicitRowHeight = null;
				else
					rowHeight = explicitRowHeight = Std.parseFloat(s_rowHeight);
			case "requestedRowCount":
				requestedRowCount = layoutableEntity.getState(p_state);
			case "requestedMaxRowCount":
				requestedMaxRowCount = layoutableEntity.getState(p_state);
			case "requestedMinRowCount":
				requestedMinRowCount = layoutableEntity.getState(p_state);
			case "variableRowHeight":
				variableRowHeight = layoutableEntity.getState(p_state);
				
			//Tile
			case "horizontalGap":
				horizontalGap = explicitHorizontalGap = layoutableEntity.getState(p_state);
			case "verticalGap":
				verticalGap = explicitVerticalGap = layoutableEntity.getState(p_state);
			case "rowAlign":
				var s_rowAlignStr:String = layoutableEntity.getState(p_state);
				if (s_rowAlignStr == "top") rowAlign = ERowAlign.TOP;
				else if (s_rowAlignStr == "justifyUsingHeight") rowAlign = ERowAlign.JUSTIFY_USING_HEIGHT;
				else if (s_rowAlignStr == "justifyUsingGap") rowAlign = ERowAlign.JUSTIFY_USING_GAP;
			case "columnAlign":
				var s_columnAlignStr:String = layoutableEntity.getState(p_state);
				if (s_columnAlignStr == "left") columnAlign = EColumnAlign.LEFT;
				else if (s_columnAlignStr == "justifyUsingWidth") columnAlign = EColumnAlign.JUSTIFY_USING_WIDTH;
				else if (s_columnAlignStr == "justifyUsingGap") columnAlign = EColumnAlign.JUSTIFY_USING_GAP;
			case "orientation":
				var s_orientationStr:String = layoutableEntity.getState(p_state);
				if (s_orientationStr == "rows") orientation = ETileOrientation.ROWS;
				else if (s_orientationStr == "columns") orientation = ETileOrientation.COLUMNS;
		}
	}
	
	private function _updateLayout(p_stateValue:String):Void
	{
		if (p_stateValue == "Basic")
		{
			if (layout == null)
				layout = new BasicLayout();
			else
				if (layout.layoutType != p_stateValue)
					layout = new BasicLayout();
		}
		else if (p_stateValue == "Horizontal")
		{
			if (layout == null)
				layout = new HorizontalLayout();
			else
				if (layout.layoutType != p_stateValue)
					layout = new HorizontalLayout();
		}
		else if (p_stateValue == "Vertical")
		{
			if (layout == null)
				layout = new VerticalLayout();
			else
				if (layout.layoutType != p_stateValue)
					layout = new VerticalLayout();
		}
		else if (p_stateValue == "Tile")
		{
			if (layout == null)
				layout = new TileLayout();
			else
				if (layout.layoutType != p_stateValue)
					layout = new TileLayout();
		}
		
		layout.target = this;
	}
	
	private function _updateExplicitSize(p_stateValue:String, p_dimension:String):Void
	{
		var l_explicitSize:Null<Float>=null;
		var l_percentSize:Null<Float>=null;
		//Console.error("updating " + p_dimension + " of entity: " + layoutableEntity.getState('name') + ", which is: " + p_stateValue);
		
		if (p_stateValue != "Implicit")
		{
			if (p_stateValue.indexOf("%") != -1)
				l_percentSize = Std.parseFloat(p_stateValue);
			else
				l_explicitSize = Std.parseFloat(p_stateValue);
		}
		
		
		if (p_dimension == "width")
		{
			explicitWidth = l_explicitSize;
			percentWidth = l_percentSize;
		}
		else
		{
			explicitHeight = l_explicitSize;
			percentHeight = l_percentSize;
		}
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
	
	public function updateDisplayList(p_width:Null<Float>, p_height:Null<Float>):Void
    {
		layout.updateDisplayList(p_width, p_height);
    }
	/*
	public function setActualSize(?p_width:Float, ?p_height:Float):Void
	{
		if (p_width == null && p_height == null)
		{
			width = preferredWidth;
			height = preferredHeight;
		}
		else
		{
			if (p_width != null) width = p_width;
			if (p_height != null) height = p_height;
		}
	}*/
	
	//the horror......
	public function setActualSize(?p_width:Null<Float>, ?p_height:Null<Float>):Void
	{
		//Width
		if (explicitWidth != null)
		{
			width = explicitWidth;
		}
		else
		{
			if (p_width != null && p_width != 0)
			{
				width = p_width;
				measuredWidth = p_width;
			}
			else
			{
				if (preferredWidth != 0)
				{
					width = preferredWidth;
				}
			}
		}
		
		//Height
		if (explicitHeight != null)
		{
			height = explicitHeight;
		}
		else
		{
			if (p_height != null && p_height != 0)
			{
				height = p_height;
				measuredHeight = p_height;
			}
			else
			{
				if (preferredHeight != 0)
				{
					height = preferredHeight;
				}
			}
		}
	}
	
	public function get_preferredWidth():Null<Float>
    {
        return explicitWidth==null ? measuredWidth : explicitWidth;
    }
	
	public function get_preferredHeight():Null<Float>
    {
        return explicitHeight==null ? measuredHeight : explicitHeight;
    }
	
	public function get_preferredMinWidth():Null<Float>
    {
        return explicitMinWidth==null ? measuredMinWidth : explicitMinWidth;
    }
	
	public function get_preferredMinHeight():Null<Float>
    {
        return explicitMinHeight==null ? measuredMinHeight : explicitMinHeight;
    }
	
	public function get_preferredMaxWidth():Null<Float>
    {
        return explicitMaxWidth==null ? measuredMaxWidth : explicitMaxWidth;
    }
	
	public function get_preferredMaxHeight():Null<Float>
    {
        return explicitMaxHeight==null ? measuredMaxHeight : explicitMaxHeight;
    }
}