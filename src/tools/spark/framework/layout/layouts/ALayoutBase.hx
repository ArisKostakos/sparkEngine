/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, January 2015
 */

package tools.spark.framework.layout.layouts;
import tools.spark.framework.layout.containers.Group;

/**
 * ...
 * @author Aris Kostakos
 */
class ALayoutBase
{
	public var target( default, set ):Group;
	public var layoutType( default, default ):String;
	public var typicalLayoutElement( get, null ):Group;
	private var _typicalLayoutElement:Group;
	
	public function new() 
	{
		
	}
	
	public function get_typicalLayoutElement():Group
    {
        if (_typicalLayoutElement==null && target!=null && (target.children.length > 0))
            _typicalLayoutElement = target.children[0];
        return _typicalLayoutElement;
    }
	
	private function set_target( p_value : Group ) : Group 
	{
		//If the target is already attached to this Layout, do nothing
		if (target == p_value)
			return target;
			
		target = p_value;
		
		return target;
	}
	
	 /**
     *  Measures the target's default size based on its content, and optionally
     *  measures the target's default minimum size.
     *
     *  <p>This is one of the methods that you must override when creating a
     *  subclass of LayoutBase. The other method is <code>updateDisplayList()</code>.
     *  You do not call these methods directly. Flex calls this method as part
     *  of a layout pass. A layout pass consists of three phases.</p>
     *
     *  <p>First, if the target's properties are invalid, the LayoutManager calls
     *  the target's <code>commitProperties</code> method.</p>
     *
     *  <p>Second, if the target's size is invalid, LayoutManager calls the target's
     *  <code>validateSize()</code> method. The target's <code>validateSize()</code>
     *  will in turn call the layout's <code>measure()</code> to calculate the
     *  target's default size unless it was explicitly specified by both target's
     *  <code>explicitWidth</code> and <code>explicitHeight</code> properties.
     *  If the default size changes, Flex will invalidate the target's display list.</p>
     *
     *  <p>Last, if the target's display list is invalid, LayoutManager calls the target's
     *  <code>validateDisplayList</code>. The target's <code>validateDisplayList</code>
     *  will in turn call the layout's <code>updateDisplayList</code> method to
     *  size and position the target's elements.</p>
     *
     *  <p>When implementing this method, you must set the target's
     *  <code>measuredWidth</code> and <code>measuredHeight</code> properties
     *  to define the target's default size. You may optionally set the
     *  <code>measuredMinWidth</code> and <code>measuredMinHeight</code>
     *  properties to define the default minimum size.
     *  A typical implementation iterates through the target's elements
     *  and uses the methods defined by the <code>ILayoutElement</code> to
     *  accumulate the preferred and/or minimum sizes of the elements and then sets
     *  the target's <code>measuredWidth</code>, <code>measuredHeight</code>,
     *  <code>measuredMinWidth</code> and <code>measuredMinHeight</code>.</p>
     *
     *  @see #updateDisplayList()
     */
    public function measure():Void
    {
		//override me
    }
    
    /**
     *  Sizes and positions the target's elements.
     *
     *  <p>This is one of the methods that you must override when creating a
     *  subclass of LayoutBase. The other method is <code>measure()</code>.
     *  You do not call these methods directly. Flex calls this method as part
     *  of a layout pass. A layout pass consists of three phases.</p>
     *
     *  <p>First, if the target's properties are invalid, the LayoutManager calls
     *  the target's <code>commitProperties</code> method.</p>
     *
     *  <p>Second, if the target's size is invalid, LayoutManager calls the target's
     *  <code>validateSize()</code> method. The target's <code>validateSize()</code>
     *  will in turn call the layout's <code>measure()</code> to calculate the
     *  target's default size unless it was explicitly specified by both target's
     *  <code>explicitWidth</code> and <code>explicitHeight</code> properties.
     *  If the default size changes, Flex will invalidate the target's display list.</p>
     *
     *  <p>Last, if the target's display list is invalid, LayoutManager calls the target's
     *  <code>validateDisplayList</code>. The target's <code>validateDisplayList</code>
     *  will in turn call the layout's <code>updateDisplayList</code> method to
     *  size and position the target's elements.</p>
     *
     *  <p>A typical implementation iterates through the target's elements
     *  and uses the methods defined by the <code>ILayoutElement</code> to
     *  position and resize the elements. Then the layout must also calculate and set
     *  the target's <code>contentWidth</code> and <code>contentHeight</code>
     *  properties to define the target's scrolling region.</p>
     *
     *  @param unscaledWidth Specifies the width of the target, in pixels,
     *  in the targets's coordinates.
     *
     *  @param unscaledHeight Specifies the height of the component, in pixels,
     *  in the target's coordinates.
     *
     *  @see #measure()
     */
    public function updateDisplayList(p_unscaledWidth:Float, p_unscaledHeight:Float):Void
    {
		//override me
    }
}