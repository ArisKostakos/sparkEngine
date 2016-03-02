/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, January 2015
 */

package tools.spark.framework.layout.layouts;
import tools.spark.framework.layout.containers.Group;

/**
 * The BasicLayout class arranges the layout elements according to their individual settings, independent of each-other.
 * BasicLayout, also called absolute layout, requires that you explicitly position each container child. 
 * You can use the x and y properties of the child, or constraints to position each child.
 * @author Aris Kostakos
 */
class BasicLayout extends ALayoutBase
{

	public function new() 
	{
		super();
		layoutType = "Basic";
	}
	
	private static function _constraintsDetermineWidth(p_group:Group):Bool
    {
        return p_group.percentWidth!=null ||
               p_group.left!=null &&
               p_group.right!=null;
    }

    private static function _constraintsDetermineHeight(p_group:Group):Bool
    {
        return p_group.percentHeight!=null ||
               p_group.top!=null &&
               p_group.bottom!=null;
    }
	
	
	/**
     *  @return Returns the maximum value for an element's dimension so that the component doesn't
     *  spill out of the container size. Calculations are based on the layout rules.
     *  Pass in unscaledWidth, hCenter, left, right, childX to get a maxWidth value.
     *  Pass in unscaledHeight, vCenter, top, bottom, childY to get a maxHeight value.
     */
    static private function _maxSizeToFitIn(p_totalSize:Float,
                                           p_center:Null<Float>,
                                           p_lowConstraint:Null<Float>,
                                           p_highConstraint:Null<Float>,
                                           p_position:Float):Float
    {
        if (p_center!=null)
        {
            // (1) x == (totalSize - childWidth) / 2 + hCenter
            // (2) x + childWidth <= totalSize
            // (3) x >= 0
            //
            // Substitue x in (2):
            // (totalSize - childWidth) / 2 + hCenter + childWidth <= totalSize
            // totalSize - childWidth + 2 * hCenter + 2 * childWidth <= 2 * totalSize
            // 2 * hCenter + childWidth <= totalSize se we get:
            // (3) childWidth <= totalSize - 2 * hCenter
            //
            // Substitute x in (3):
            // (4) childWidth <= totalSize + 2 * hCenter
            //
            // From (3) & (4) above we get:
            // childWidth <= totalSize - 2 * abs(hCenter)

            return p_totalSize - 2 * Math.abs(p_center);
        }
        else if (p_lowConstraint!=null)
        {
            // childWidth + left <= totalSize
            return p_totalSize - p_lowConstraint;
        }
        else if (p_highConstraint!=null)
        {
            // childWidth + right <= totalSize
            return p_totalSize - p_highConstraint;
        }
        else
        {
            // childWidth + childX <= totalSize
            return p_totalSize - p_position;
        }
    }
	
	
	override public function measure():Void
	{
        var l_width:Float = 0;
        var l_height:Float = 0;
		var l_minWidth:Float = 0;
        var l_minHeight:Float = 0;

        for (f_child in target.children)
        {
            if (f_child==null || f_child.includeInLayout==false)
                continue;
				
            // Extents of the element - how much additional space (besides its own width/height)
            // the element needs based on its constraints.
            var f_extX:Float;
            var f_extY:Float;

			//LETS DO X
			if (f_child.left!=null && f_child.right!=null)
            {
                // If both left & right are set, then the extents is always
                // left + right so that the element is resized to its preferred
                // size (if it's the one that pushes out the default size of the container).
                f_extX = f_child.left + f_child.right;                
            }
			else if (f_child.horizontalCenter!=null)
            {
                // If we have horizontalCenter, then we want to have at least enough space
                // so that the element is within the parent container.
                // If the element is aligned to the left/right edge of the container and the
                // distance between the centers is hCenter, then the container width will be
                // parentWidth = 2 * (abs(hCenter) + elementWidth / 2)
                // <=> parentWidth = 2 * abs(hCenter) + elementWidth
                // Since the extents is the additional space that the element needs
                // extX = parentWidth - elementWidth = 2 * abs(hCenter)
                f_extX = Math.abs(f_child.horizontalCenter) * 2;
            }
            else if (f_child.left!=null || f_child.right!=null)
            {
                f_extX = f_child.left == null ? 0 : f_child.left;
                f_extX += f_child.right == null ? 0 : f_child.right;
            }
            else
            {
                f_extX = f_child.x;
            }
            
            if (f_child.top!=null && f_child.bottom!=null)
            {
                // If both top & bottom are set, then the extents is always
                // top + bottom so that the element is resized to its preferred
                // size (if it's the one that pushes out the default size of the container).
                f_extY = f_child.top + f_child.bottom;                
            }
            else if (f_child.verticalCenter!=null)
            {
                // If we have verticalCenter, then we want to have at least enough space
                // so that the element is within the parent container.
                // If the element is aligned to the top/bottom edge of the container and the
                // distance between the centers is vCenter, then the container height will be
                // parentHeight = 2 * (abs(vCenter) + elementHeight / 2)
                // <=> parentHeight = 2 * abs(vCenter) + elementHeight
                // Since the extents is the additional space that the element needs
                // extY = parentHeight - elementHeight = 2 * abs(vCenter)
                f_extY = Math.abs(f_child.verticalCenter) * 2;
            }
            else if (f_child.top!=null || f_child.bottom!=null)
            {
                f_extY = f_child.top == null ? 0 : f_child.top;
                f_extY += f_child.bottom == null ? 0 : f_child.bottom;
            }
            else
            {
                f_extY = f_child.y;
            }
			
            l_width = Math.max(l_width, f_extX + f_child.preferredWidth);
            l_height = Math.max(l_height, f_extY + f_child.preferredHeight);
			
			// Find the minimum default extents, we take the minimum width/height only
            // when the element size is determined by the parent size
            var l_elementMinWidth:Float =
                _constraintsDetermineWidth(f_child) ? f_child.preferredMinWidth :
                                                           f_child.preferredWidth;
            var l_elementMinHeight:Float =
                _constraintsDetermineHeight(f_child) ? f_child.preferredMinHeight : 
                                                            f_child.preferredHeight;

            l_minWidth = Math.max(l_minWidth, f_extX + l_elementMinWidth);
            l_minHeight = Math.max(l_minHeight, f_extY + l_elementMinHeight);
		}

		// Use Math.ceil() to make sure that if the content partially occupies
        // the last pixel, we'll count it as if the whole pixel is occupied.
        target.measuredWidth = Math.ceil(Math.max(l_width, l_minWidth));
        target.measuredHeight = Math.ceil(Math.max(l_height, l_minHeight));
		target.measuredMinWidth = Math.ceil(l_minWidth);
        target.measuredMinHeight = Math.ceil(l_minHeight);
		
		//aris addition so things start make some sense... not good ofc. without it results are same so far
		target.measuredMaxWidth = 999999;
		target.measuredMaxHeight = 999999;
		//target.measuredMaxWidth = target.measuredWidth;
		//target.measuredMaxHeight = target.measuredHeight;
	}
	
	override public function updateDisplayList(p_unscaledWidth:Float, p_unscaledHeight:Float):Void
    {
        var l_maxX:Float = 0;
        var l_maxY:Float = 0;
		//Console.error(target.layoutableEntity.getState('name') + " updateDisplayList(w:"+p_unscaledWidth+",h:"+p_unscaledHeight+"):");
        for (f_child in target.children)
        {
			if (f_child==null || f_child.includeInLayout==false)
				continue;
				
            var f_elementMaxWidth:Null<Float> = null; 
            var f_elementMaxHeight:Null<Float> = null;

            // Calculate size
            var f_childWidth:Null<Float> = null;
            var f_childHeight:Null<Float> = null;
			
			if (f_child.percentWidth!=null)
            {
                var f_availableWidth:Float = p_unscaledWidth;
                if (f_child.left!=null)
                    f_availableWidth -= f_child.left;
                if (f_child.right!=null)
                     f_availableWidth -= f_child.right;
				
                f_childWidth = Math.round(f_availableWidth * Math.min(f_child.percentWidth * 0.01, 1));
                f_elementMaxWidth = Math.min(f_child.preferredMaxWidth,
                    _maxSizeToFitIn(p_unscaledWidth, f_child.horizontalCenter, f_child.left, f_child.right, f_child.x));
					
            }
            else if (f_child.left!=null && f_child.right!=null)
            {
                f_childWidth = p_unscaledWidth - f_child.right - f_child.left;
            }

            if (f_child.percentHeight!=null)
            {
                var f_availableHeight:Float = p_unscaledHeight;
                if (f_child.top!=null)
                    f_availableHeight -= f_child.top;
                if (f_child.bottom!=null)
                    f_availableHeight -= f_child.bottom;    
                    
                f_childHeight = Math.round(f_availableHeight * Math.min(f_child.percentHeight * 0.01, 1));
                f_elementMaxHeight = Math.min(f_child.preferredMaxHeight,
                    _maxSizeToFitIn(p_unscaledHeight, f_child.verticalCenter, f_child.top, f_child.bottom, f_child.y));
            }
            else if (f_child.top!=null && f_child.bottom!=null)
            {
                f_childHeight = p_unscaledHeight - f_child.bottom - f_child.top;
            }

            // Apply min and max constraints, make sure min is applied last. In the cases
            // where childWidth and childHeight are NaN, setLayoutBoundsSize will use preferredSize
            // which is already constrained between min and max.
            if (f_childWidth!=null)
            {
                if (f_elementMaxWidth==null)
                    f_elementMaxWidth = f_child.preferredMaxWidth;
                f_childWidth = Math.max(f_child.preferredMinWidth, Math.min(f_elementMaxWidth, f_childWidth));
            }
            if (f_childHeight!=null)
            {
                if (f_elementMaxHeight==null)
                    f_elementMaxHeight = f_child.preferredMaxHeight;
                f_childHeight = Math.max(f_child.preferredMinHeight, Math.min(f_elementMaxHeight, f_childHeight));
            }

            // Set the size.

            //layoutElement.setLayoutBoundsSize(childWidth, childHeight);
			f_child.setActualSize(f_childWidth, f_childHeight);
			
            var f_elementWidth:Float = f_child.width;
            var f_elementHeight:Float = f_child.height;

            var f_childX:Null<Float> = null;
            var f_childY:Null<Float> = null;
            
            // Horizontal position
            if (f_child.horizontalCenter!=null)
                f_childX = Math.round((p_unscaledWidth - f_elementWidth) / 2 + f_child.horizontalCenter);
            else if (f_child.left!=null)
                f_childX = f_child.left;
            else if (f_child.right!=null)
                f_childX = p_unscaledWidth - f_elementWidth - f_child.right;
            else
                f_childX = f_child.x;

            // Vertical position
            if (f_child.verticalCenter!=null)
                f_childY = Math.round((p_unscaledHeight - f_elementHeight) / 2 + f_child.verticalCenter);
            else if (f_child.top!=null)
                f_childY = f_child.top;
            else if (f_child.bottom!=null)
                f_childY = p_unscaledHeight - f_elementHeight - f_child.bottom;
            else
                f_childY = f_child.y;

            // Set position
            //layoutElement.setLayoutBoundsPosition(childX, childY);
			f_child.x = f_childX;
			f_child.y = f_childY;

            // update content limits
            l_maxX = Math.max(l_maxX, f_childX + f_elementWidth);
            l_maxY = Math.max(l_maxY, f_childY + f_elementHeight);
        }

        // Make sure that if the content spans partially over a pixel to the right/bottom,
        // the content size includes the whole pixel.
        //layoutTarget.setContentSize(Math.ceil(maxX), Math.ceil(maxY));
		//target.width = Math.ceil(l_maxX);
		//target.height = Math.ceil(l_maxY);

		//target.width = target.explicitWidth==null ? Math.ceil(l_maxX) : target.explicitWidth;
		//target.height = target.explicitHeight == null ? Math.ceil(l_maxY) : target.explicitHeight;
		//target.setActualSize(Math.ceil(l_maxX), Math.ceil(l_maxY));
		//OK THIS ONE NEEDS WORK...
		target.width = Math.ceil(p_unscaledWidth);
		target.height = Math.ceil(p_unscaledHeight);
    }   
}