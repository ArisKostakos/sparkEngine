/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, February 2015
 */

package tools.spark.framework.layout.helpers;

/**
 * ...
 * @author Aris Kostakos
 */
class LayoutHelper
{
	/**
	 *  This function distributes excess space among the flexible children.
	 *  It does so with a view to keep the children's overall size
	 *  close the ratios specified by their percent.
	 *
	 *  @param spaceForChildren The total space for all children
	 *
	 *  @param spaceToDistribute The space that needs to be distributed
	 *  among the flexible children.
	 *
	 *  @param childInfoArray An array of Objects. When this function
	 *  is called, each object should define the following properties:
	 *  - percent: the percentWidth or percentHeight of the child (depending
	 *  on whether we're growing in a horizontal or vertical direction)
	 *  - min: the minimum width (or height) for that child
	 *  - max: the maximum width (or height) for that child
	 *
	 *  @return When this function finishes executing, a "size" property
	 *  will be defined for each child object. The size property contains
	 *  the portion of the spaceToDistribute to be distributed to the child.
	 *  Ideally, the sum of all size properties is spaceToDistribute.
	 *  If all the children hit their minWidth/maxWidth/minHeight/maxHeight
	 *  before the space was distributed, then the remaining unused space
	 *  is returned. Otherwise, the return value is zero.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public static function flexChildrenProportionally(
								p_spaceForChildren:Float,
								p_spaceToDistribute:Float,
								p_totalPercent:Float,
								p_childInfoArray:Array<ChildInfo>):Float
	{
		// The algorithm iterivately attempts to break down the space that 
		// is consumed by "flexible" containers into ratios that are related
		// to the percentWidth/percentHeight of the participating containers.
		
		var l_numChildren:Int = p_childInfoArray.length;
		var l_flexConsumed:Float; // space consumed by flexible compontents
		var l_done:Bool;
        
		var l_unused:Float;
		
		// Continue as long as there are some remaining flexible children.
		// The "done" flag isn't strictly necessary, except that it catches
		// cases where round-off error causes totalPercent to not exactly
		// equal zero.
		do
		{
			l_flexConsumed = 0; // space consumed by flexible compontents
			l_done = true; // we are optimistic
			
            // We now do something a little tricky so that we can 
            // support partial filling of the space. If our total
            // percent < 100% then we can trim off some space.
            // This unused space can be used to fulfill mins and maxes.
            l_unused = p_spaceToDistribute -
                                (p_spaceForChildren * p_totalPercent / 100);
            if (l_unused > 0)
                p_spaceToDistribute -= l_unused;
            else
                l_unused = 0;
            
			// Space for flexible children is the total amount of space
			// available minus the amount of space consumed by non-flexible
			// components.Divide that space in proportion to the percent
			// of the child
			var l_spacePerPercent:Float = p_spaceToDistribute / p_totalPercent;
			
			// Attempt to divide out the space using our percent amounts,
			// if we hit its limit then that control becomes 'non-flexible'
			// and we run the whole space to distribute calculation again.
			var l_i:Int = 0;
			while (l_i < l_numChildren)
			{
				var w_childInfo:ChildInfo = p_childInfoArray[l_i];

				// Set its size in proportion to its percent.
				var w_size:Float = w_childInfo.percent * l_spacePerPercent;

				// If our flexiblity calc say grow/shrink more than we are
				// allowed, then we grow/shrink whatever we can, remove
				// ourselves from the array for the next pass, and start
				// the loop over again so that the space that we weren't
				// able to consume / release can be re-used by others.
				if (w_size < w_childInfo.min)
				{
					var w_min:Float = w_childInfo.min;
					w_childInfo.size = w_min;
					
					// Move this object to the end of the array
					// and decrement the length of the array. 
					// This is slightly expensive, but we don't expect
					// to hit these min/max limits very often.
					p_childInfoArray[l_i] = p_childInfoArray[--l_numChildren];
					p_childInfoArray[l_numChildren] = w_childInfo;

					p_totalPercent -= w_childInfo.percent;
                    // Use unused space first before reducing flexible space.
                    if (l_unused >= w_min)
                    {
                        l_unused -= w_min;
                    }
                    else
                    {
                        p_spaceToDistribute -= w_min - l_unused;
                        l_unused = 0;
                    }
					l_done = false;
					break;
				}
				else if (w_size > w_childInfo.max)
				{
					var w_max:Float = w_childInfo.max;
					w_childInfo.size = w_max;

					p_childInfoArray[l_i] = p_childInfoArray[--l_numChildren];
					p_childInfoArray[l_numChildren] = w_childInfo;

					p_totalPercent -= w_childInfo.percent;
                    // Use unused space first before reducing flexible space.
                    if (l_unused >= w_max)
                    {
                        l_unused -= w_max;
                    }
                    else
                    {
                        p_spaceToDistribute -= w_max - l_unused;
                        l_unused = 0;
                    }
					l_done = false;
					break;
				}
				else
				{
					// All is well, let's carry on...
					w_childInfo.size = w_size;
					l_flexConsumed += w_size;
				}
				
				l_i++;
			}
		} 
		while (!l_done);

		return Math.max(0, Math.floor((p_spaceToDistribute + l_unused) - l_flexConsumed));
	}
}