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
 * The VerticalLayout class arranges the layout elements in a vertical sequence, top to bottom, with optional gaps between the elements and optional padding around the sequence of elements.
 * The vertical position of the elements is determined by arranging them in a vertical sequence, top to bottom, taking into account the padding before the first element and the gaps between the elements.
 * The horizontal position of the elements is determined by the layout's horizontalAlign property.
 * @author Aris Kostakos
 */
class VerticalLayout extends ALayoutBase
{

	public function new() 
	{
		super();
		layoutType = "Vertical";
	}
	
	    /**
     *  @private
     *  @return rows to measure based on elements in layout and any requested/min/max rowCount settings. 
     */
    private function _getRowsToMeasure(p_numElementsInLayout:Int):Int
    {
        var l_rowsToMeasure:Int;
        if (target.requestedRowCount != -1)
            l_rowsToMeasure = target.requestedRowCount;
        else
        {
            l_rowsToMeasure = p_numElementsInLayout;
            if (target.requestedMaxRowCount != -1)
                l_rowsToMeasure = Std.int(Math.min(target.requestedMaxRowCount, l_rowsToMeasure));
            if (target.requestedMinRowCount != -1)
                l_rowsToMeasure = Std.int(Math.max(target.requestedMinRowCount, l_rowsToMeasure));
        }
        return l_rowsToMeasure;
    }
	
	
	/**
     *  @private
     *  Fills in the result with preferred and min sizes of the element.
     */
    private function _getElementWidth(p_element:Group, p_justify:Bool, p_result:SizesAndLimit):Void
    {
        // Calculate preferred width first, as it's being used to calculate min width
        var l_elementPreferredWidth:Float = Math.ceil(p_element.preferredWidth);
        
        // Calculate min width
        var l_flexibleWidth:Bool = (p_element.percentWidth != null) || p_justify;
        var l_elementMinWidth:Float = l_flexibleWidth ? Math.ceil(p_element.preferredMinWidth) : 
                                                     l_elementPreferredWidth;
        p_result.preferredSize = l_elementPreferredWidth;
        p_result.minSize = l_elementMinWidth;
    }
	
	/**
     *  @private
     *  Fills in the result with preferred and min sizes of the element.
     */
    private function _getElementHeight(p_element:Group, p_fixedRowHeight:Null<Float>, p_result:SizesAndLimit):Void
    {
        // Calculate preferred height first, as it's being used to calculate min height below
        var l_elementPreferredHeight:Float = p_fixedRowHeight==null ? Math.ceil(p_element.preferredHeight) :
                                                                    p_fixedRowHeight;
        // Calculate min height
        var l_flexibleHeight:Bool = p_element.percentHeight != null;
        var l_elementMinHeight:Float = l_flexibleHeight ? Math.ceil(p_element.preferredMinHeight) : 
                                                       l_elementPreferredHeight;
        p_result.preferredSize = l_elementPreferredHeight;
        p_result.minSize = l_elementMinHeight;
    }
	
	private static function _pinBetween(p_val:Float, p_min:Float, p_max:Float):Float
    {
        return Math.min(p_max, Math.max(p_min, p_val));
    }
	
    private static function _calculatePercentWidth(p_layoutElement:Group, p_width:Float):Float
    {
        var l_percentWidth:Float;

		l_percentWidth = _pinBetween(Math.min(Math.round(p_layoutElement.percentWidth * 0.01 * p_width), p_width),
													  p_layoutElement.preferredMinWidth,
													  p_layoutElement.preferredMaxWidth );
		return l_percentWidth;
    }
	
    private static function _sizeLayoutElement(p_layoutElement:Group, 
                                              p_width:Float, 
                                              p_horizontalAlign:EHorizontalAlign, 
                                              p_restrictedWidth:Float, 
                                              p_height:Null<Float>, 
                                              p_variableRowHeight:Bool, 
                                              p_rowHeight:Float):Void
    {
        var l_newWidth:Null<Float> = null;
        
        // if horizontalAlign is "justify" or "contentJustify", 
        // restrict the width to restrictedWidth.  Otherwise, 
        // size it normally
        if (p_horizontalAlign == EHorizontalAlign.JUSTIFY ||
            p_horizontalAlign == EHorizontalAlign.CONTENT_JUSTIFY)
        {
            l_newWidth = p_restrictedWidth;
        }
        else
        {
            if (p_layoutElement.percentWidth!=null)
               l_newWidth = _calculatePercentWidth(p_layoutElement, p_width);
        }
        
        if (p_variableRowHeight)
            //layoutElement.setLayoutBoundsSize(newWidth, height);
			p_layoutElement.setActualSize(l_newWidth, p_height);
        else
            //layoutElement.setLayoutBoundsSize(newWidth, rowHeight);
			p_layoutElement.setActualSize(l_newWidth, p_rowHeight);
    }
	
	
	
	/**
     *  @private
     * 
     *  This function sets the height of each child
     *  so that the heights add up to <code>height</code>. 
     *  Each child is set to its preferred height
     *  if its percentHeight is zero.
     *  If its percentHeight is a positive number,
     *  the child grows (or shrinks) to consume its
     *  share of extra space.
     *  
     *  The return value is any extra space that's left over
     *  after growing all children to their maxHeight.
     */
    private function _distributeHeight(p_width:Float, 
                                      p_height:Float, 
                                      p_restrictedWidth:Float):Float
    {
        var l_spaceToDistribute:Float = p_height;
        var l_totalPercentHeight:Float = 0;
        var l_childInfoArray:Array<ChildInfo> = new Array<ChildInfo>();
        var l_childInfo:ChildInfo;
        var l_layoutElement:Group;
        
        // rowHeight can be expensive to compute
        var l_rh:Float = (target.variableRowHeight) ? 0 : Math.ceil(target.rowHeight);
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
            
            if (f_child.percentHeight!=null && target.variableRowHeight)
            {
                l_totalPercentHeight += f_child.percentHeight;

                l_childInfo = new ChildInfo();
                l_childInfo.layoutElement = f_child;
                l_childInfo.percent    = f_child.percentHeight;
                l_childInfo.min        = f_child.preferredMinHeight;
                l_childInfo.max        = f_child.preferredMaxHeight;
                
                l_childInfoArray.push(l_childInfo);                
            }
            else
            {
                _sizeLayoutElement(f_child, p_width, target.horizontalAlign, 
                               p_restrictedWidth, null, target.variableRowHeight, l_rh);
                
                l_spaceToDistribute -= Math.ceil(f_child.height);
            } 
        }
        
        if (l_totalCount > 1)
            l_spaceToDistribute -= (l_totalCount-1) * target.gap;

        // Distribute the extra space among the flexible children
        if (l_totalPercentHeight!=0)
        {
            LayoutHelper.flexChildrenProportionally(p_height,
                                            l_spaceToDistribute,
                                            l_totalPercentHeight,
                                            l_childInfoArray);

            var l_roundOff:Float = 0;            
            for (f_childInfo in l_childInfoArray)
            {
                // Make sure the calculated percentages are rounded to pixel boundaries
                var l_childSize:Int = Math.round(f_childInfo.size + l_roundOff);
                l_roundOff += f_childInfo.size - l_childSize;

                _sizeLayoutElement(f_childInfo.layoutElement, p_width, target.horizontalAlign, 
                               p_restrictedWidth, l_childSize, 
                               target.variableRowHeight, l_rh);
                l_spaceToDistribute -= l_childSize;
            }
        }
        return l_spaceToDistribute;
    }
	
    /**
     *  @private
     * 
     *  Compute exact values for measuredWidth,Height and measuredMinWidth,Height.
     * 
     *  Measure each of the layout elements.  If requestedRowCount >= 0 we 
     *  consider the height and width of as many layout elements, padding with 
     *  typicalLayoutElement if needed, starting with index 0. We then only 
     *  consider the width of the elements remaining.
     * 
     *  If requestedRowCount is -1, we measure all of the layout elements.
     */
	override public function measure():Void
	{
		var l_size:SizesAndLimit 		= new SizesAndLimit();
        var l_justify:Bool 				= target.horizontalAlign == EHorizontalAlign.JUSTIFY;
        var l_numElements:Int 			= target.children.length; // How many elements there are in the target
        var l_numElementsInLayout:Int 	= l_numElements;      // How many elements have includeInLayout == true, start off with numElements.
        var l_requestedRowCount:Int		= target.requestedRowCount;
        var l_rowsMeasured:Int			= 0;                       // How many rows have been measured
        
        var l_preferredHeight:Float 	= 0; // sum of the elt preferred heights
        var l_preferredWidth:Float 		= 0; // max of the elt preferred widths
        var l_minHeight:Float 			= 0; // sum of the elt minimum heights
        var l_minWidth:Float 			= 0; // max of the elt minimum widths
        
        var l_fixedRowHeight:Null<Float> = null;
        if (!target.variableRowHeight)
			if (target.rowHeight == null)
				l_fixedRowHeight = typicalLayoutElement.preferredHeight;  // query typicalLayoutElement, elt at index=0
			else
				l_fixedRowHeight = target.rowHeight;
        
        // Get the numElementsInLayout clamped to requested min/max
        var l_rowsToMeasure:Int = _getRowsToMeasure(l_numElementsInLayout);

        for (f_child in target.children)
        {
			if (f_child==null || f_child.includeInLayout==false)
            {
                l_numElementsInLayout--;
                continue;
            }
            
            // Can we measure this row height?
            if (l_rowsMeasured < l_rowsToMeasure)
            {
                _getElementHeight(f_child, l_fixedRowHeight, l_size);
                l_preferredHeight += l_size.preferredSize;
                l_minHeight += l_size.minSize;
                l_rowsMeasured++;
            }
            
            // Consider the width of each element, inclusive of those outside
            // the requestedRowCount range.
            _getElementWidth(f_child, l_justify, l_size);
            l_preferredWidth = Math.max(l_preferredWidth, l_size.preferredSize);
            l_minWidth = Math.max(l_minWidth, l_size.minSize);
        }
        
        // Calculate the total number of rows to measure again, since numElementsInLayout may have changed
        l_rowsToMeasure = _getRowsToMeasure(l_numElementsInLayout);

        // Do we need to measure more rows?
        if (l_rowsMeasured < l_rowsToMeasure)
        {
            // Use the typical element
            var l_element:Group = typicalLayoutElement;
            if (l_element!=null)
            {
                // Height
                _getElementHeight(l_element, l_fixedRowHeight, l_size);
                l_preferredHeight += l_size.preferredSize * (l_rowsToMeasure - l_rowsMeasured);
                l_minHeight += l_size.minSize * (l_rowsToMeasure - l_rowsMeasured);
    
                // Width
                _getElementWidth(l_element, l_justify, l_size);
                l_preferredWidth = Math.max(l_preferredWidth, l_size.preferredSize);
                l_minWidth = Math.max(l_minWidth, l_size.minSize);
                l_rowsMeasured = l_rowsToMeasure;
            }
        }

        // Add gaps
        if (l_rowsMeasured > 1)
        { 
            var l_vgap:Float = target.gap * (l_rowsMeasured - 1);
            l_preferredHeight += l_vgap;
            l_minHeight += l_vgap;
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
            setRowCount(0);
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
        
        // If horizontalAlign is left, we don't need to figure out the contentWidth
        // Otherwise the contentWidth is used to position the element and even size 
        // the element if it's "contentJustify" or "justify".
        var l_containerWidth:Float = l_targetWidth;        
        if (target.horizontalAlign == EHorizontalAlign.CONTENT_JUSTIFY /*||
           (clipAndEnableScrolling && (target.horizontalAlign == EHorizontalAlign.CENTER ||
                                       target.horizontalAlign == EHorizontalAlign.RIGHT))*/) 
        {
            for (f_child in target.children)
            {
				if (f_child==null || f_child.includeInLayout==false)
					continue;

                var l_layoutElementWidth:Float;
                if (f_child.percentWidth!=null)
                    l_layoutElementWidth = _calculatePercentWidth(f_child, l_targetWidth);
                else
                    l_layoutElementWidth = f_child.preferredWidth;
                
                l_containerWidth = Math.max(l_containerWidth, Math.ceil(l_layoutElementWidth));
            }
        }

        var l_excessHeight:Float = _distributeHeight(l_targetWidth, l_targetHeight, l_containerWidth);
        
        // default to left (0)
        var l_hAlign:Float = 0;
        if (target.horizontalAlign == EHorizontalAlign.CENTER)
            l_hAlign = .5;
        else if (target.horizontalAlign == EHorizontalAlign.RIGHT)
            l_hAlign = 1;
/*
        // As the layoutElements are positioned, we'll count how many rows 
        // fall within the layoutTarget's scrollRect
        var visibleRows:uint = 0;
        var minVisibleY:Number = layoutTarget.verticalScrollPosition;
        var maxVisibleY:Number = minVisibleY + targetHeight;
*/
        // Finally, position the layoutElements and find the first/last
        // visible indices, the content size, and the number of 
        // visible elements.    
        var l_x0:Float = target.paddingLeft;
        var l_y:Float = target.paddingTop;
        var l_maxX:Float = target.paddingLeft;
        var l_maxY:Float = target.paddingTop;
/*
        var firstRowInView:int = -1;
        var lastRowInView:int = -1;
*/
        // Take verticalAlign into account
        if (l_excessHeight > 0 || true/*!clipAndEnableScrolling*/)
        {
            var l_vAlign:EVerticalAlign = target.verticalAlign;
            if (l_vAlign == EVerticalAlign.MIDDLE)
            {
                l_y = target.paddingTop + Math.round(l_excessHeight / 2);   
            }
            else if (l_vAlign == EVerticalAlign.BOTTOM)
            {
                l_y = target.paddingTop + l_excessHeight;   
            }
        }

		for (f_child in target.children)
        {
			if (f_child==null || f_child.includeInLayout==false)
				continue;
                
            // Set the layout element's position
            var l_dx:Float = Math.ceil(f_child.width);
            var l_dy:Float = Math.ceil(f_child.height);

            var l_x:Float = l_x0 + (l_containerWidth - l_dx) * l_hAlign;
            // In case we have HorizontalAlign.CENTER we have to round
            if (l_hAlign == 0.5)
                l_x = Math.round(l_x);
				
            //layoutElement.setLayoutBoundsPosition(x, y);
			f_child.x = l_x;
			f_child.y = l_y;
                            
            // Update maxX,Y, first,lastVisibleIndex, and y
            l_maxX = Math.max(l_maxX, l_x + l_dx);
            l_maxY = Math.max(l_maxY, l_y + l_dy);
/*
            if (!clipAndEnableScrolling ||
                ((y < maxVisibleY) && ((y + dy) > minVisibleY)) || 
                ((dy <= 0) && ((y == maxVisibleY) || (y == minVisibleY))))
            {
                visibleRows += 1;
                if (firstRowInView == -1)
                   firstRowInView = lastRowInView = index;
                else
                   lastRowInView = index;
            }
*/  
            l_y += l_dy + target.gap;
        }
/*
        setRowCount(visibleRows);
        setIndexInView(firstRowInView, lastRowInView);
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