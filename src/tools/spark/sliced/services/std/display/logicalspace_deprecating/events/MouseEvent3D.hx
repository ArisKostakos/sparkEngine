package tools.spark.sliced.services.std.display.logicalspace.events;

class MouseEvent3D  {
	public var _allowedToPropagate : Bool;
	public var _parentEvent : MouseEvent3D;
	public var altKey : Bool;
	public var ctrlKey : Bool;
	public var delta : Int;
	public var index : Int;
	public var localNormal : Dynamic;
	public var localPosition : Dynamic;
	public var material : tools.spark.sliced.services.std.display.logicalspace.materials.MaterialBase;
	public var object : tools.spark.sliced.services.std.display.logicalspace.containers.ObjectContainer3D;
	public var renderable : tools.spark.sliced.services.std.display.logicalspace.core.base.IRenderable;
	public var sceneNormal(default,never) : Dynamic;
	public var scenePosition(default,never) : Dynamic;
	public var screenX : Float;
	public var screenY : Float;
	public var shiftKey : Bool;
	public var subGeometryIndex : Int;
	public var uv : Dynamic;
	public var view : tools.spark.sliced.services.std.display.logicalspace.containers.View3D;
	public function new():Void {super();}}
