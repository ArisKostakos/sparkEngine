/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, May 2015
 */

package tools.spark.framework.layout.layouts;
import tools.spark.framework.layout.containers.Group;
import tools.spark.framework.layout.interfaces.EColumnAlign;
import tools.spark.framework.layout.interfaces.EHorizontalAlign;
import tools.spark.framework.layout.interfaces.ERowAlign;
import tools.spark.framework.layout.interfaces.ETileOrientation;
import tools.spark.framework.layout.interfaces.EVerticalAlign;

/**
 * The TileLayout class arranges layout elements in columns and rows of equally-sized cells.
 * The TileLayout class uses a number of properties that control orientation, count, size, gap 
 * and justification of the columns and the rows as well as element alignment within the cells.
 * @author Aris Kostakos
 */
class TileLayout extends ALayoutBase
{

	public function new() 
	{
		super();
		layoutType = "Tile";
	}
	
	
	 /**
     *  @private
     *  Returns true, if the dimensions (colCount1, rowCount1) are more square than (colCount2, rowCount2).
     *  Squareness is the difference between width and height of a tile layout
     *  with the specified number of columns and rows.
     */
    private function _closerToSquare(p_colCount1:Int, p_rowCount1:Int, p_colCount2:Int, p_rowCount2:Int):Bool
    {
        var l_difference1:Float = Math.abs(p_colCount1 * (target.columnWidth + target.horizontalGap) - target.horizontalGap - 
                                          p_rowCount1 * (target.rowHeight   +   target.verticalGap) + target.verticalGap);
        var l_difference2:Float = Math.abs(p_colCount2 * (target.columnWidth + target.horizontalGap) - target.horizontalGap - 
                                          p_rowCount2 * (target.rowHeight   +   target.verticalGap) + target.verticalGap);
        
        return l_difference1 < l_difference2 || (l_difference1 == l_difference2 && p_rowCount1 <= p_rowCount2);
    }

    /**
     *  @private
     *  Calculates _columnCount and _rowCount based on width, height,
     *  orientation, _requestedColumnCount, _requestedRowCount, _columnWidth, _rowHeight.
     *  _columnWidth and _rowHeight must be valid before calling.
     * 
     *  The width and height should not include padding.
     */
    private function _calculateColumnAndRowCount(p_width:Null<Float>, p_height:Null<Float>, p_elementCount:Int):Void
    {
        target.columnCount = target.rowCount = -1;
		//Console.warn("p_width: " + p_width);
		//Console.warn("p_height: " + p_height);
		if (p_width <= 0) p_width = null;
		if (p_height <= 0) p_height = null;
		
		
        if (-1 != target.requestedColumnCount || -1 != target.requestedRowCount)
        {
            if (-1 != target.requestedRowCount)
                target.rowCount = Std.int(Math.max(1, target.requestedRowCount));

            if (-1 != target.requestedColumnCount)
                target.columnCount = Std.int(Math.max(1, target.requestedColumnCount));
        }
        // Figure out number of columns or rows based on the explicit size along one of the axes
        else if (p_width!=null && (target.orientation == ETileOrientation.ROWS || p_height==null))
        {
            if (target.columnWidth + target.explicitHorizontalGap > 0)
                target.columnCount = Std.int(Math.max(1, Math.floor((p_width + target.explicitHorizontalGap) / (target.columnWidth + target.explicitHorizontalGap))));
            else
                target.columnCount = 1;
        }
        else if (p_height!=null && (target.orientation == ETileOrientation.COLUMNS || p_width==null))
        {
            if (target.rowHeight + target.explicitVerticalGap > 0)
                target.rowCount = Std.int(Math.max(1, Math.floor((p_height + target.explicitVerticalGap) / (target.rowHeight + target.explicitVerticalGap))));
            else
                target.rowCount = 1;
        }
        else // Figure out the number of columns and rows so that pixels area occupied is as square as possible
        {
            // Calculate number of rows and columns so that
            // pixel area is as square as possible
            var l_hGap:Float = target.explicitHorizontalGap;
            var l_vGap:Float = target.explicitVerticalGap;

            // 1. columnCount * (columnWidth + hGap) - hGap == rowCount * (rowHeight + vGap) - vGap
            // 1. columnCount * (columnWidth + hGap) == rowCount * (rowHeight + vGap) + hGap - vGap
            // 1. columnCount == (rowCount * (rowHeight + vGap) + hGap - vGap) / (columnWidth + hGap)
            // 2. columnCount * rowCount == elementCount
            // substitute 1. in 2.
            // rowCount * rowCount + (hGap - vGap) * rowCount - elementCount * (columnWidth + hGap ) == 0

            var l_a:Float = Math.max(0, (target.rowHeight + l_vGap));
            var l_b:Float = (l_hGap - l_vGap);
            var l_c:Float = -p_elementCount * (target.columnWidth + l_hGap);
            var l_d:Float = l_b * l_b - 4 * l_a * l_c; // Always guaranteed to be greater than zero, since c <= 0
            l_d = Math.sqrt(l_d);

            // We are guaranteed that we have only one positive root, since d >= b:
            var l_rowCount:Float = (l_a != 0) ? (l_b + l_d) / (2 * l_a) : p_elementCount;

            // To get integer count for the columns/rows we round up and down so
            // we get four possible solutions. Then we pick the best one.
            var l_row1:Int = Std.int(Math.max(1, Math.floor(l_rowCount)));
            var l_col1:Int = Std.int(Math.max(1, Math.ceil(p_elementCount / l_row1)));
            l_row1 = Std.int(Math.max(1, Math.ceil(p_elementCount / l_col1)));

            var l_row2:Int = Std.int(Math.max(1, Math.ceil(l_rowCount)));
            var l_col2:Int = Std.int(Math.max(1, Math.ceil(p_elementCount / l_row2)));
            l_row2 = Std.int(Math.max(1, Math.ceil(p_elementCount / l_col2)));

            var l_col3:Int = Std.int(Math.max(1, Math.floor(p_elementCount / l_rowCount)));
            var l_row3:Int = Std.int(Math.max(1, Math.ceil(p_elementCount / l_col3)));
            l_col3 = Std.int(Math.max(1, Math.ceil(p_elementCount / l_row3)));

            var l_col4:Int = Std.int(Math.max(1, Math.ceil(p_elementCount / l_rowCount)));
            var l_row4:Int = Std.int(Math.max(1, Math.ceil(p_elementCount / l_col4)));
            l_col4 = Std.int(Math.max(1, Math.ceil(p_elementCount / l_row4)));

            if (_closerToSquare(l_col3, l_row3, l_col1, l_row1))
            {
                l_col1 = l_col3;
                l_row1 = l_row3;
            }

            if (_closerToSquare(l_col4, l_row4, l_col2, l_row2))
            {
                l_col2 = l_col4;
                l_row2 = l_row4;
            }

            if (_closerToSquare(l_col1, l_row1, l_col2, l_row2))
            {
                target.columnCount = l_col1;
                target.rowCount = l_row1;
            }
            else
            {
                target.columnCount = l_col2;
                target.rowCount = l_row2;
            }
        }

		//Console.warn("p_elementCount: " + p_elementCount);
		//Console.warn("target.columnCount: " + target.columnCount);
		//Console.warn("sooo: " + Std.int(Math.max(1, Math.ceil(p_elementCount / target.columnCount))));
		
        // In case we determined only columns or rows (from explicit overrides or explicit width/height)
        // calculate the other from the number of elements
        if (-1 == target.rowCount)
            target.rowCount = Std.int(Math.max(1, Math.ceil(p_elementCount / target.columnCount)));
        if (-1 == target.columnCount)
            target.columnCount = Std.int(Math.max(1, Math.ceil(p_elementCount / target.rowCount)));
    }
	
	
	
	/**
     *  @private
     *  Increases the gap so that elements are justified to exactly fit totalSize
     *  leaving no partially visible elements in view.
     *  @return Returs the new gap size.
     */
    private function _justifyByGapSize(p_totalSize:Float, p_elementSize:Float,
                                      p_gap:Float, p_elementCount:Int):Float
    {
        // If element + gap collapses to zero, then don't adjust the gap.
        if (p_elementSize + p_gap <= 0)
            return p_gap;

        // Find the number of fully visible elements
        var l_visibleCount:Int =
            Std.int(Math.min(p_elementCount, Math.floor((p_totalSize + p_gap) / (p_elementSize + p_gap))));

        // If there isn't even a singel fully visible element, don't adjust the gap
        if (l_visibleCount < 1)
            return p_gap;

        // Special case: if there's a singe fully visible element and a partially
        // visible element, then make the gap big enough to push out the partially
        // visible element out of view.
        if (l_visibleCount == 1)
            return p_elementCount > 1 ? Math.max(p_gap, p_totalSize - p_elementSize) : p_gap;

        // Now calculate the gap such that the fully visible elements and gaps
        // add up exactly to totalSize:
        // <==> totalSize == visibleCount * elementSize + (visibleCount - 1) * gap
        // <==> totalSize - visibleCount * elementSize == (visibleCount - 1) * gap
        // <==> (totalSize - visibleCount * elementSize) / (visibleCount - 1) == gap
        return (p_totalSize - l_visibleCount * p_elementSize) / (l_visibleCount - 1);
    }

    /**
     *  @private
     *  Increases the element size so that elements are justified to exactly fit
     *  totalSize leaving no partially visible elements in view.
     *  @return Returns the the new element size.
     */
    private function _justifyByElementSize(p_totalSize:Float, p_elementSize:Float,
                                          p_gap:Float, p_elementCount:Int):Float
    {
        var l_elementAndGapSize:Float = p_elementSize + p_gap;
        var l_visibleCount:Int = 0;
        // Find the number of fully visible elements
        if (l_elementAndGapSize == 0)
            l_visibleCount = p_elementCount;
        else
            l_visibleCount = Std.int(Math.min(p_elementCount, Math.floor((p_totalSize + p_gap) / l_elementAndGapSize)));

        // If there isn't event a single fully visible element, don't adjust
        if (l_visibleCount < 1)
            return p_elementSize;

        // Now calculate the elementSize such that the fully visible elements and gaps
        // add up exactly to totalSize:
        // <==> totalSize == visibleCount * elementSize + (visibleCount - 1) * gap
        // <==> totalSize - (visibleCount - 1) * gap == visibleCount * elementSize
        // <==> (totalSize - (visibleCount - 1) * gap) / visibleCount == elementSize
        return (p_totalSize - (l_visibleCount - 1) * p_gap) / l_visibleCount;
    }
	
	/**
     *  @private
     *  For normal layout return the number of non-null includeInLayout=true
     *  layout elements, for virtual layout just return the number of layout
     *  elements.
     */
    private function _calculateElementCount():Int
    {
        if (-1 != target.numElementsCached)
            return target.numElementsCached;
        
        target.numElementsCached = target.children.length;
		for (f_child in target.children)
        {
			if (f_child==null || f_child.includeInLayout==false)
                target.numElementsCached--;
        }

        return target.numElementsCached;
    }
	
	
	/**
     *  @private
     *  Calculates _columnWidth and _rowHeight from maximum of
     *  elements preferred size and any explicit overrides.
     */
    private function _calculateTileSize():Void
    {
        target.columnWidth = target.tileWidthCached;
        target.rowHeight = target.tileHeightCached;
        if (target.columnWidth!=null && target.rowHeight!=null)
            return;

        // Are both dimensions explicitly set?
        target.columnWidth = target.tileWidthCached = target.explicitColumnWidth;
        target.rowHeight = target.tileHeightCached = target.explicitRowHeight;
        if (target.columnWidth!=null && target.rowHeight!=null)
            return;

        // Find the maxmimums of element's preferred sizes
        var l_columnWidth:Float = 0;
        var l_rowHeight:Float = 0;

		
        // Remember the number of includeInLayout elements
        target.numElementsCached = target.children.length;
		for (f_child in target.children)
        {
			if (f_child==null || f_child.includeInLayout==false)
            {
                target.numElementsCached--;
                continue;
            }

            if (target.columnWidth==null)
                l_columnWidth = Math.max(l_columnWidth, f_child.preferredWidth);
            if (target.rowHeight==null)
                l_rowHeight = Math.max(l_rowHeight, f_child.preferredHeight);
        }

        if (target.columnWidth==null)
            target.columnWidth = target.tileWidthCached = l_columnWidth;
        if (target.rowHeight==null)
            target.rowHeight = target.tileHeightCached = l_rowHeight;
    }
	
	
	/**
     *  This method is called from measure() and updateDisplayList() to calculate the
     *  actual values for columnWidth, rowHeight, columnCount, rowCount, horizontalGap and verticalGap.
     *  The width and height should include padding because the padding is accounted for in
     *  the calculations.
     *
     *  @param width - the width during measure() is the layout target explicitWidth or NaN
     *  and during updateDisplayList() is the unscaledWidth.
     *  @param height - the height during measure() is the layout target explicitHeight or NaN
     *  and during updateDisplayList() is the unscaledHeight.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    private function _updateActualValues(p_width:Float, p_height:Float):Void
    {
        var l_widthMinusPadding:Float = p_width - target.paddingLeft - target.paddingRight;
        var l_heightMinusPadding:Float = p_height - target.paddingTop - target.paddingBottom;
        
        // First, figure the tile size
        _calculateTileSize();

        // Second, figure out number of rows/columns
        var l_elementCount:Int = _calculateElementCount();
        _calculateColumnAndRowCount(l_widthMinusPadding, l_heightMinusPadding, l_elementCount);

        // Third, adjust the gaps and column and row sizes based on justification settings
        target.horizontalGap = target.explicitHorizontalGap;
        target.verticalGap = target.explicitVerticalGap;

        // Justify
		if (target.width!=null)
		{
            switch (target.columnAlign)
            {
                case EColumnAlign.JUSTIFY_USING_GAP:
                    target.horizontalGap = _justifyByGapSize(l_widthMinusPadding, target.columnWidth, target.horizontalGap, target.columnCount);
                case EColumnAlign.JUSTIFY_USING_WIDTH:
                    target.columnWidth = _justifyByElementSize(l_widthMinusPadding, target.columnWidth, target.horizontalGap, target.columnCount);
				default:
					
	        }
		}

		if (target.height!=null)
		{
            switch (target.rowAlign)
            {
                case ERowAlign.JUSTIFY_USING_GAP:
                    target.verticalGap = _justifyByGapSize(l_heightMinusPadding, target.rowHeight, target.verticalGap, target.rowCount);
                case ERowAlign.JUSTIFY_USING_HEIGHT:
                    target.rowHeight = _justifyByElementSize(l_heightMinusPadding, target.rowHeight, target.verticalGap, target.rowCount);
				default:
					
	        }
		}

        // Last, if we have explicit overrides for both rowCount and columnCount, then
        // make sure that column/row count along the minor axis reflects the actual count.
        if (-1 != target.requestedColumnCount && -1 != target.requestedRowCount)
        {
            if (target.orientation == ETileOrientation.ROWS)
                target.rowCount = Std.int(Math.max(1, Math.ceil(l_elementCount / Math.max(1, target.requestedColumnCount))));
            else
                target.columnCount = Std.int(Math.max(1, Math.ceil(l_elementCount / Math.max(1, target.requestedRowCount))));
        }
    }
	
	 /**
     *  @private
     *  This method computes values for visibleStartX,Y, visibleStartIndex, and 
     *  visibleEndIndex based on the TileLayout geometry values, like _columnWidth
     *  and _rowHeight, computed by calculateActualValues().
     * 
     *  If useVirtualLayout=false, then visibleStartX,Y=0 and visibleStartIndex=0
     *  and visibleEndIndex=layoutTarget.numElements-1.
     * 
     *  If useVirtualLayout=true and orientation=ROWS then visibleStartIndex is the 
     *  layout element index of the item at first visible row relative to the scrollRect, 
     *  column 0.  Note that we're using column=0 instead of the first visible column
     *  to simplify the iteration logic in updateDisplayList().  This is optimal 
     *  for the common case where the entire row is visible.   Optimally handling 
     *  the case where orientation=ROWS and each row is only partially visible is 
     *  doable but adds some complexity to the main loop.
     * 
     *  The logic for useVirtualLayout=true and orientation=COLS is similar.
     */
    private function _calculateDisplayParameters(p_unscaledWidth:Int, p_unscaledHeight:Int):Void
    {
		//DO WE NEED THIS CALL HERE???
		//If we dont remove it, also remove visible stuff completely, no need for them either
        _updateActualValues(p_unscaledWidth, p_unscaledHeight);

        var l_eltCount:Int = target.children.length;
        target.visibleStartX = target.paddingLeft;   // initial values for xPos,yPos in updateDisplayList
        target.visibleStartY = target.paddingTop;
        target.visibleStartIndex = 0;
        target.visibleEndIndex = l_eltCount - 1;
    }
	
	/**
     *  Sets the size and the position of the specified layout element and cell bounds.
     *  @param element - the element to resize and position.
     *  @param cellX - the x coordinate of the cell.
     *  @param cellY - the y coordinate of the cell.
     *  @param cellWidth - the width of the cell.
     *  @param cellHeight - the height of the cell.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    private function _sizeAndPositionElement(p_element:Group,
                                              p_cellX:Int,
                                              p_cellY:Int,
                                              p_cellWidth:Int,
                                              p_cellHeight:Int):Void
    {
        var l_childWidth:Null<Float> = null;
        var l_childHeight:Null<Float> = null;

        // Determine size of the element
        if (target.horizontalAlign == EHorizontalAlign.JUSTIFY)
            l_childWidth = p_cellWidth;
        else if (p_element.percentWidth!=null)
            l_childWidth = Math.round(p_cellWidth * p_element.percentWidth * 0.01);
        else
            l_childWidth = p_element.preferredWidth;

        if (target.verticalAlign == EVerticalAlign.JUSTIFY)
            l_childHeight = p_cellHeight;
        else if (p_element.percentHeight!=null)
            l_childHeight = Math.round(p_cellHeight * p_element.percentHeight * 0.01);
        else
            l_childHeight = p_element.preferredHeight;

        // Enforce min and max limits
        var l_maxChildWidth:Float = Math.min(p_element.preferredMaxWidth, p_cellWidth);
        var l_maxChildHeight:Float = Math.min(p_element.preferredMaxHeight, p_cellHeight);
        // Make sure we enforce element's minimum last, since it has the highest priority
        l_childWidth = Math.max(p_element.preferredMinWidth, Math.min(l_maxChildWidth, l_childWidth));
        l_childHeight = Math.max(p_element.preferredMinHeight, Math.min(l_maxChildHeight, l_childHeight));

        // Size the element
        //p_element.setLayoutBoundsSize(l_childWidth, l_childHeight);
		p_element.setActualSize(l_childWidth, l_childHeight);

        var l_x:Float = p_cellX;
        switch (target.horizontalAlign)
        {
            case EHorizontalAlign.RIGHT:
                l_x += p_cellWidth - p_element.width;
            case EHorizontalAlign.CENTER:
                // Make sure division result is integer - Math.floor() the result.
                l_x = p_cellX + Math.floor((p_cellWidth - p_element.width) / 2);
			default:
			
        }

        var l_y:Float = p_cellY;
        switch (target.verticalAlign)
        {
            case EVerticalAlign.BOTTOM:
                l_y += p_cellHeight - p_element.height;
            case EVerticalAlign.MIDDLE:
                // Make sure division result is integer - Math.floor() the result.
                l_y += Math.floor((p_cellHeight - p_element.height) / 2);
			default:
			
        }

        // Position the element
        //p_element.setLayoutBoundsPosition(l_x, l_y);
		p_element.x = l_x;
		p_element.y = l_y;
    }
	
	override public function measure():Void
	{
		// Save and restore these values so they're not modified 
        // as a sideeffect of measure().
        var l_savedColumnCount:Int = target.columnCount;
        var l_savedRowCount:Int = target.rowCount;
        var l_savedHorizontalGap:Float = target.horizontalGap;
        var l_savedVerticalGap:Float = target.verticalGap;
        var l_savedColumnWidth:Null<Float> = target.columnWidth;
        var l_savedRowHeight:Null<Float> = target.rowHeight; 
        
        _updateActualValues(target.explicitWidth, target.explicitHeight);

        // For measure, any explicit overrides for rowCount and columnCount take precedence
        var l_columnCount:Int = target.requestedColumnCount != -1 ? Std.int(Math.max(1, target.requestedColumnCount)) : target.columnCount;
        var l_rowCount:Int = target.requestedRowCount != -1 ? Std.int(Math.max(1, target.requestedRowCount)) : target.rowCount;
        
        var l_measuredWidth:Float = 0;
        var l_measuredMinWidth:Float = 0;
        var l_measuredHeight:Float = 0;
        var l_measuredMinHeight:Float = 0;
        
        if (l_columnCount > 0)
        {
            l_measuredWidth = Math.ceil(l_columnCount * (target.columnWidth + target.horizontalGap) - target.horizontalGap);
            // measured min size is guaranteed to have enough columns to fit all elements
            l_measuredMinWidth = Math.ceil(target.columnCount * (target.columnWidth + target.horizontalGap) - target.horizontalGap);
        }
            
        if (l_rowCount > 0)
        {
            l_measuredHeight = Math.ceil(l_rowCount * (target.rowHeight + target.verticalGap) - target.verticalGap);
            // measured min size is guaranteed to have enough rows to fit all elements
            l_measuredMinHeight = Math.ceil(target.rowCount * (target.rowHeight + target.verticalGap) - target.verticalGap);
        }
		target.numElementsCached = -1;
        
        var l_hPadding:Float = target.paddingLeft + target.paddingRight;
        var l_vPadding:Float = target.paddingTop + target.paddingBottom;

        target.measuredWidth = l_measuredWidth + l_hPadding;
        target.measuredMinWidth = l_measuredMinWidth + l_hPadding;
        target.measuredHeight = l_measuredHeight + l_vPadding;
        target.measuredMinHeight = l_measuredMinHeight + l_vPadding;

		//aris addition so things start make some sense... not good ofc. without it results are same so far
		target.measuredMaxWidth = 999999;	//comment out?
		target.measuredMaxHeight = 999999;	//comment out?

        target.columnCount = l_savedColumnCount;
        target.rowCount = l_savedRowCount;
        target.horizontalGap = l_savedHorizontalGap;
        target.verticalGap = l_savedVerticalGap;
        target.columnWidth = l_savedColumnWidth;
        target.rowHeight = l_savedRowHeight; 
	}
	
	override public function updateDisplayList(p_unscaledWidth:Float, p_unscaledHeight:Float):Void
    {
        _calculateDisplayParameters(Std.int(p_unscaledWidth), Std.int(p_unscaledHeight));
        
        // Upper right hand corner of first (visibleStartIndex) tile/cell
        var l_xPos:Float = target.visibleStartX;  // paddingLeft if useVirtualLayout=false
        var l_yPos:Float = target.visibleStartY;  // paddingTop if useVirtualLayout=false
                
        // Use MajorDelta when moving along the major axis
        var l_xMajorDelta:Float;
        var l_yMajorDelta:Float;

        // Use MinorDelta when moving along the minor axis
        var l_xMinorDelta:Float;
        var l_yMinorDelta:Float;

        // Use counter and counterLimit to track when to move along the minor axis
        var l_counter:Int = 0;
        var l_counterLimit:Int;

        // Setup counterLimit and deltas based on orientation
        if (target.orientation == ETileOrientation.ROWS)
        {
            l_counterLimit = target.columnCount;
            l_xMajorDelta = target.columnWidth + target.horizontalGap;
            l_xMinorDelta = 0;
            l_yMajorDelta = 0;
            l_yMinorDelta = target.rowHeight + target.verticalGap;
        }
        else
        {
            l_counterLimit = target.rowCount;
            l_xMajorDelta = 0;
            l_xMinorDelta = target.columnWidth + target.horizontalGap;
            l_yMajorDelta = target.rowHeight + target.verticalGap;
            l_yMinorDelta = 0;
        }

        //for (var index:int = visibleStartIndex; index <= visibleEndIndex; index++)
		for (f_el in target.children)
        {
			if (f_el==null || f_el.includeInLayout==false)
                continue;

            // To calculate the cell extents as integers, first calculate
            // the extents and then use Math.round()
            var l_cellX:Int = Math.round(l_xPos);
            var l_cellY:Int = Math.round(l_yPos);
            var l_cellWidth:Int = Math.round(l_xPos + target.columnWidth) - l_cellX;
            var l_cellHeight:Int = Math.round(l_yPos + target.rowHeight) - l_cellY;

            _sizeAndPositionElement(f_el, l_cellX, l_cellY, l_cellWidth, l_cellHeight);

            // Move along the major axis
            l_xPos += l_xMajorDelta;
            l_yPos += l_yMajorDelta;

            // Move along the minor axis
            if (++l_counter >= l_counterLimit)
            {
                l_counter = 0;
                if (target.orientation == ETileOrientation.ROWS)
                {
                    l_xPos = target.paddingLeft;
                    l_yPos += l_yMinorDelta;
                }
                else
                {
                    l_xPos += l_xMinorDelta;
                    l_yPos = target.paddingTop;
                }
            }
        }

        var l_hPadding:Float = target.paddingLeft + target.paddingRight;
        var l_vPadding:Float = target.paddingTop + target.paddingBottom;
        
        // Make sure that if the content spans partially over a pixel to the right/bottom,
        // the content size includes the whole pixel.
        //target.setContentSize(Math.ceil(_columnCount * (_columnWidth + _horizontalGap) - _horizontalGap) + hPadding,
        //                            Math.ceil(_rowCount * (_rowHeight + _verticalGap) - _verticalGap) + vPadding);
		
		//OK THIS ONE NEEDS WORK...
		target.width = Math.ceil(p_unscaledWidth);
		target.height = Math.ceil(p_unscaledHeight);
		//target.width = Math.ceil(target.columnCount * (target.columnWidth + target.horizontalGap) - target.horizontalGap) + l_hPadding;
		//target.height =  Math.ceil(target.rowCount * (target.rowHeight + target.verticalGap) - target.verticalGap) + l_vPadding;

        // Reset the cache
        target.tileWidthCached = target.tileHeightCached = null;
        target.numElementsCached = -1;
               

        // If actual values have chnaged, notify listeners
        //dispatchEventsForActualValueChanges();
    }   
}