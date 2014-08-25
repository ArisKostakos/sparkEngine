package tools.spark.sliced.services.std.display.logicalspace.core.data;

@:final class RenderableListItem {
	public var cascaded : Bool;
	public var materialId : Int;
	public var next : RenderableListItem;
	public var renderOrderId : Int;
	public var renderSceneTransform : Dynamic;
	public var renderable : tools.spark.sliced.services.std.display.logicalspace.core.base.IRenderable;
	public var zIndex : Float;
	public function new():Void {}}
