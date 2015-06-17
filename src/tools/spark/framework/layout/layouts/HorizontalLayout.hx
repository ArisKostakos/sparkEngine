/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, February 2015
 */

package tools.spark.framework.layout.layouts;
import tools.spark.framework.layout.containers.Group;
import tools.spark.framework.layout.helpers.ChildInfo;
import tools.spark.framework.layout.helpers.LayoutHelper;
import tools.spark.framework.layout.helpers.SizesAndLimit;
import tools.spark.framework.layout.interfaces.EHorizontalAlign;
import tools.spark.framework.layout.interfaces.EVerticalAlign;

/**
 * The HorizontalLayout class arranges the layout elements in a horizontal sequence, left to right, with optional gaps between the elements and optional padding around the elements.
 * The horizontal position of the elements is determined by arranging them in a horizontal sequence, left to right, taking into account the padding before the first element and the gaps between the elements.
 * The vertical position of the elements is determined by the layout's verticalAlign property.
 * @author Aris Kostakos
 */
class HorizontalLayout extends ALayoutBase
{

	public function new() 
	{
		super();
		layoutType = "Horizontal";
	}
	
	 /**
     *  @private
     *  @return columns to measure based on elements in layout and any requested/min/max rowCount settings. 
     */
    private function _getColumsToMeasure(p_numElementsInLayout:Int):Int
    {
        var l_columnsToMeasure:Int;
        if (target.requestedColumnCount != -1)
            l_columnsToMeasure = target.requestedColumnCount;
        else
        {
            l_columnsToMeasure = p_numElementsInLayout;
            if (target.requestedMaxColumnCount != -1)
                l_columnsToMeasure = Std.int(Math.min(target.requestedMaxColumnCount, l_columnsToMeasure));
            if (target.requestedMinColumnCount != -1)
                l_columnsToMeasure = Std.int(Math.max(target.requestedMinColumnCount, l_columnsToMeasure));
        }
        return l_columnsToMeasure;
    }
	
	
    /**
     *  @private
     *  Fills in the result with preferred and min sizes of the element.
     */
    private function _getElementWidth(p_element:Group, p_fixedColumnWidth:Null<Float>, p_result:SizesAndLimit):Void
    {
        // Calculate preferred width first, as it's being used to calculate min width
        var l_elementPreferredWidth:Float = p_fixedColumnWidth==null ? Math.ceil(p_element.preferredWidth) :
                                                                     p_fixedColumnWidth;
        // Calculate min width
        var l_flexibleWidth:Bool = p_element.percentWidth != null;
        var l_elementMinWidth:Float = l_flexibleWidth ? Math.ceil(p_element.preferredMinWidth) : 
                                                     l_elementPreferredWidth;
        p_result.preferredSize = l_elementPreferredWidth;
        p_result.minSize = l_elementMinWidth;
    }
    
    /**
     *  @private
     *  Fills in the result with preferred and min sizes of the element.
     */
    private function _getElementHeight(p_element:Group, p_justify:Bool, p_result:SizesAndLimit):Void
    {
        // Calculate preferred height first, as it's being used to calculate min height below
        var l_elementPreferredHeight:Float = Math.ceil(p_element.preferredHeight);
        
        // Calculate min height
        var l_flexibleHeight:Bool = (p_element.percentHeight != null) || p_justify;
        var l_elementMinHeight:Float = l_flexibleHeight ? Math.ceil(p_element.preferredMinHeight) : 
                                                       l_elementPreferredHeight;
        p_result.preferredSize = l_elementPreferredHeight;
        p_result.minSize = l_elementMinHeight;
    }
	
	private static function _pinBetween(p_val:Float, p_min:Float, p_max:Float):Float
    {
        return Math.min(p_max, Math.max(p_min, p_val));
    }
	
	private static function _calculatePercentHeight(p_layoutElement:Group, p_height:Float):Float
    {
        var l_percentHeight:Float;

		l_percentHeight = _pinBetween(Math.min(Math.round(p_layoutElement.percentHeight * 0.01 * p_height), p_height),
													   p_layoutElement.preferredMinHeight,
													   p_layoutElement.preferredMaxHeight );
		return l_percentHeight;
    }
	
	
    private static function _sizeLayoutElement(p_layoutElement:Group, p_height:Float, 
                                              p_verticalAlign:EVerticalAlign, p_restrictedHeight:Float, 
                                              p_width:Null<Float>, p_variableColumnWidth:Bool, 
                                              p_columnWidth:Float):Void
    {
        var l_newHeight:Null<Float> = null;
        
        // if verticalAlign is "justify" or "contentJustify", 
        // restrict the height to restrictedHeight.  Otherwise, 
        // size it normally
        if (p_verticalAlign == EVerticalAlign.JUSTIFY ||
            p_verticalAlign == EVerticalAlign.CONTENT_JUSTIFY)
        {
            l_newHeight = p_restrictedHeight;
        }
        else
        {
            if (p_layoutElement.percentHeight!=null)
               l_newHeight = _calculatePercentHeight(p_layoutElement, p_height);   
        }
        
        if (p_variableColumnWidth)
            //p_layoutElement.setLayoutBoundsSize(p_width, l_newHeight);
			p_layoutElement.setActualSize(p_width, l_newHeight);
        else
            //p_layoutElement.setLayoutBoundsSize(p_columnWidth, l_newHeight);
			p_layoutElement.setActualSize(p_columnWidth, l_newHeight);
    }
	
	
    /**
     *  @private
     * 
     *  This function sets the width of each child
     *  so that the widths add up to <code>width</code>. 
     *  Each child is set to its preferred width
     *  if its percentWidth is zero.
     *  If its percentWidth is a positive number,
     *  the child grows (or shrinks) to consume its
     *  share of extra space.
     *  
     *  The return value is any extra space that's left over
     *  after growing all children to their maxWidth.
     */
    private function _distributeWidth(p_width:Float,
                                     p_height:Float,
                                     p_restrictedHeight:Float):Float
    {
        var l_spaceToDistribute:Float = p_width;
        var l_totalPercentWidth:Float = 0;
        var l_childInfoArray:Array<ChildInfo> = new Array<ChildInfo>();
        var l_childInfo:ChildInfo;
        var l_newHeight:Float;
        var l_layoutElement:Group;
        
        // columnWidth can be expensive to compute
        var l_cw:Float = (target.variableColumnWidth) ? 0 : Math.ceil(target.columnWidth);
        var l_totalCount:Int = target.children.length; // number of elements to use in gap calculation
        
        // If the child is flexible, store information about it in the
        // childInfoArray. For non-flexible children, just set the child's
        // width and height immediately.
        for (f_child in target.children)
        {
            if (f_child==null || f_child.includeInLayout==false)
            {
                l_totalCount--;
                continue;
            }
            
            if (f_child.percentWidth!=null && target.variableColumnWidth)
            {
                l_totalPercentWidth += f_child.percentWidth;

                l_childInfo = new ChildInfo();
                l_childInfo.layoutElement = f_child;
                l_childInfo.percent    = f_child.percentWidth;
                l_childInfo.min        = f_child.preferredMinWidth;
                l_childInfo.max        = f_child.preferredMaxWidth;
                
                l_childInfoArray.push(l_childInfo);                
            }
            else
            {
                _sizeLayoutElement(f_child, p_height, target.verticalAlign, 
                                  p_restrictedHeight, null, target.variableColumnWidth, l_cw);
                
                l_spaceToDistribute -= Math.ceil(f_child.width);
            } 
        }
        
        if (l_totalCount > 1)
            l_spaceToDistribute -= (l_totalCount-1) * target.gap;

        // Distribute the extra space among the flexible children
        if (l_totalPercentWidth!=0)
        {
            LayoutHelper.flexChildrenProportionally(p_width,
                                            l_spaceToDistribute,
                                            l_totalPercentWidth,
                                            l_childInfoArray);
            var l_roundOff:Float = 0;
            for (f_childInfo in l_childInfoArray)
            {
                // Make sure the calculated percentages are rounded to pixel boundaries
                var l_childSize:Int = Math.round(f_childInfo.size + l_roundOff);
                l_roundOff += f_childInfo.size - l_childSize;

                _sizeLayoutElement(f_childInfo.layoutElement, p_height, target.verticalAlign, 
                                  p_restrictedHeight, l_childSize, 
                                  target.variableColumnWidth, l_cw);
                l_spaceToDistribute -= l_childSize;
            }
        }
        return l_spaceToDistribute;
    }
	
	 /**
     *  @private
     * 
     *  Compute exact values for measuredWidth,Height and  measuredMinWidth,Height.
     *  
     *  Measure each of the layout elements.  If requestedColumnCount >= 0 we 
     *  consider the height and width of as many layout elements, padding with 
     *  typicalLayoutElement if needed, starting with index 0. We then only 
     *  consider the height of the elements remaining.
     * 
     *  If requestedColumnCount is -1, we consider width/height of each element.
     */
	override public function measure():Void
	{
		var l_size:SizesAndLimit          = new SizesAndLimit();
        var l_justify:Bool	              = target.verticalAlign == EVerticalAlign.JUSTIFY;
        var l_numElements:Int             = target.children.length;     // How many elements there are in the target
        var l_numElementsInLayout:Int     = l_numElements;                  // How many elements have includeInLayout == true, start off with numElements.
        var l_requestedColumnCount:Int    = target.requestedColumnCount;
        var l_columnsMeasured:Int         = 0;                            // How many columns have been measured
        
        var l_preferredHeight:Float      = 0; // sum of the elt preferred heights
        var l_preferredWidth:Float       = 0; // max of the elt preferred widths
        var l_minHeight:Float            = 0; // sum of the elt minimum heights
        var l_minWidth:Float             = 0; // max of the elt minimum widths
        
        var l_fixedColumnWidth:Null<Float> = null;
        if (!target.variableColumnWidth)
			if (target.columnWidth == null)
				l_fixedColumnWidth = typicalLayoutElement.preferredWidth;  // query typicalLayoutElement, elt at index=0
			else
				l_fixedColumnWidth = target.columnWidth;
        
        // Get the numElementsInLayout clamped to requested min/max
        var l_columnsToMeasure:Int = _getColumsToMeasure(l_numElementsInLayout);

        for (f_child in target.children)
        {
			if (f_child==null || f_child.includeInLayout==false)
            {
                l_numElementsInLayout--;
                continue;
            }
			
			// Consider the height of each element, inclusive of those outside
			// the requestedColumnCount range.
			_getElementHeight(f_child, l_justify, l_size);
			l_preferredHeight = Math.max(l_preferredHeight, l_size.preferredSize);
			l_minHeight = Math.max(l_minHeight, l_size.minSize);

            
            // Can we measure the width of this column?
            if (l_columnsMeasured < l_columnsToMeasure)
            {
                _getElementWidth(f_child, l_fixedColumnWidth, l_size);
                l_preferredWidth += l_size.preferredSize;
                l_minWidth += l_size.minSize;
                l_columnsMeasured++;
            }
        }
        
        // Calculate the total number of columns to measure again, since numElementsInLayout may have changed 
        l_columnsToMeasure = _getColumsToMeasure(l_numElementsInLayout);

        // Do we need to measure more columns?
        if (l_columnsMeasured < l_columnsToMeasure)
        {
            // Use the typical element
            var l_element:Group = typicalLayoutElement;
            if (l_element!=null)
            {
				// Height
				_getElementHeight(l_element, l_justify, l_size);
				l_preferredHeight = Math.max(l_preferredHeight, l_size.preferredSize);
				l_minHeight = Math.max(l_minHeight, l_size.minSize);
    
                // Width
                _getElementWidth(l_element, l_fixedColumnWidth, l_size);
                l_preferredWidth += l_size.preferredSize * (l_columnsToMeasure - l_columnsMeasured);
                l_minWidth += l_size.minSize * (l_columnsToMeasure - l_columnsMeasured);
                l_columnsMeasured = l_columnsToMeasure;
            }
        }

        // Add gaps
        if (l_columnsMeasured > 1)
        { 
            var l_hgap:Float = target.gap * (l_columnsMeasured - 1);
            l_preferredWidth += l_hgap;
            l_minWidth += l_hgap;
        }
        
        var l_hPadding:Float = target.paddingLeft + target.paddingRight;
        var l_vPadding:Float = target.paddingTop + target.paddingBottom;
        
        target.measuredHeight = Math.ceil(l_preferredHeight + l_vPadding);
        target.measuredWidth = Math.ceil(l_preferredWidth + l_hPadding);
        target.measuredMinHeight = Math.ceil(l_minHeight + l_vPadding);
        target.measuredMinWidth  = Math.ceil(l_minWidth + l_hPadding);
		
		//aris addition so things start make some sense... not good ofc. without it results are same so far
		target.measuredMaxWidth = 999999;
		target.measuredMaxHeight = 999999;
	}
	
	override public function updateDisplayList(p_unscaledWidth:Float, p_unscaledHeight:Float):Void
    {
        if ((target.children.length == 0) || (p_unscaledWidth == 0) || (p_unscaledHeight == 0))
        {
/*
            setColumnCount(0);
            setIndexInView(-1, -1);
*/
            if (target.children.length == 0)
			{
				target.width = Math.ceil(target.paddingLeft + target.paddingRight);
				target.height = Math.ceil(target.paddingTop + target.paddingBottom);
			}
            return;         
        }
		
        var l_targetWidth:Float = Math.max(0, target.width - target.paddingLeft - target.paddingRight);
        var l_targetHeight:Float = Math.max(0, target.height - target.paddingTop - target.paddingBottom);
        
        
        // If verticalAlign is top, we don't need to figure out the contentHeight.
        // Otherwise the contentHeight is used to position the element and even size 
        // the element if it's "contentJustify" or "justify".
        var l_containerHeight:Float = l_targetHeight;
        if (target.verticalAlign == EVerticalAlign.CONTENT_JUSTIFY /*||
           (clipAndEnableScrolling && (target.verticalAlign == EVerticalAlign.MIDDLE ||
                                       target.verticalAlign == EVerticalAlign.BOTTOM))*/) 
        {
            for (f_child in target.children)
            {
				if (f_child==null || f_child.includeInLayout==false)
					continue;
                
                var l_layoutElementHeight:Float;
                if (f_child.percentHeight!=null)
                    l_layoutElementHeight = _calculatePercentHeight(f_child, l_targetHeight);
                else
                    l_layoutElementHeight = f_child.preferredHeight;
                    
                l_containerHeight = Math.max(l_containerHeight, Math.ceil(l_layoutElementHeight));
            }
        }

        var l_excessWidth:Float = _distributeWidth(l_targetWidth, l_targetHeight, l_containerHeight);
        
        // default to top (0)
        var l_vAlign:Float = 0;
        if (target.verticalAlign == EVerticalAlign.MIDDLE)
            l_vAlign = .5;
        else if (target.verticalAlign == EVerticalAlign.BOTTOM)
            l_vAlign = 1;
/*
        // If columnCount wasn't set, then as the LayoutElements are positioned
        // we'll count how many columns fall within the layoutTarget's scrollRect
        var visibleColumns:uint = 0;
        var minVisibleX:Number = layoutTarget.horizontalScrollPosition;
        var maxVisibleX:Number = minVisibleX + targetWidth
*/
        // Finally, position the LayoutElements and find the first/last
        // visible indices, the content size, and the number of 
        // visible elements. 
        var l_x:Float = target.paddingLeft;
        var l_y0:Float = target.paddingTop;
        var l_maxX:Float = target.paddingLeft;
        var l_maxY:Float = target.paddingTop; 
/*
        var firstColInView:int = -1;
        var lastColInView:int = -1;
*/
        // Take horizontalAlign into account
        if (l_excessWidth > 0 || true/*!clipAndEnableScrolling*/)
        {
            var l_hAlign:EHorizontalAlign = target.horizontalAlign;
            if (l_hAlign == EHorizontalAlign.CENTER)
            {
                l_x = target.paddingLeft + Math.round(l_excessWidth / 2);   
            }
            else if (l_hAlign == EHorizontalAlign.RIGHT)
            {
                l_x = target.paddingLeft + l_excessWidth;   
            }
        }

		for (f_child in target.children)
        {
			if (f_child==null || f_child.includeInLayout==false)
				continue;

            // Set the layout element's position
            var l_dx:Float = Math.ceil(f_child.width);
            var l_dy:Float = Math.ceil(f_child.height);

            var l_y:Float;

			l_y = l_y0 + (l_containerHeight - l_dy) * l_vAlign;
			// In case we have VerticalAlign.MIDDLE we have to round
			if (l_vAlign == 0.5)
				l_y = Math.round(l_y);

			
            //layoutElement.setLayoutBoundsPosition(x, y);
			f_child.x = l_x;
			f_child.y = l_y;

            // Update maxX,Y, first,lastVisibleIndex, and x
            l_maxX = Math.max(l_maxX, l_x + l_dx);
            l_maxY = Math.max(l_maxY, l_y + l_dy);   
/*
            if (!clipAndEnableScrolling || 
                ((x < maxVisibleX) && ((x + dx) > minVisibleX)) || 
                ((dx <= 0) && ((x == maxVisibleX) || (x == minVisibleX))))
            {
                visibleColumns += 1;
                if (firstColInView == -1)
                   firstColInView = lastColInView = index;
                else
                   lastColInView = index;
			}
*/          
            l_x += l_dx + target.gap;
        }
/*
        setColumnCount(visibleColumns);  
        setIndexInView(firstColInView, lastColInView);
*/ 
        // Make sure that if the content spans partially over a pixel to the right/bottom,
        // the content size includes the whole pixel.
       // layoutTarget.setContentSize(Math.ceil(maxX + paddingRight),
        //                            Math.ceil(maxY + paddingBottom));
		
		//OK THIS ONE NEEDS WORK...
		target.width = Math.ceil(p_unscaledWidth);
		target.height = Math.ceil(p_unscaledHeight);
    }
}