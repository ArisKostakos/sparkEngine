package tools.spark.sliced.services.std.display.logicalspace.containers;

@:keep class View3D  {
	public var name: String;
	public var x: Int;
	public var y: Int;
	public var width: Int;
	public var height: Int;
	public var zIndex: Int;
	public var requests3DEngine: Bool;
	public var antiAlias : Int;
	public var background : tools.spark.sliced.services.std.display.logicalspace.textures.Texture2DBase;
	public var backgroundAlpha : Float;
	public var backgroundColor : Int;
	public var camera : tools.spark.sliced.services.std.display.logicalspace.cameras.Camera3D;
	public var deltaTime(default,never) : Int;
	public var depthPrepass : Bool;
	public var entityCollector(default,never) : tools.spark.sliced.services.std.display.logicalspace.core.traverse.EntityCollector;
	public var filters3d : Array<Dynamic>;
	public var forceMouseMove : Bool;
	public var layeredView : Bool;
	public var mousePicker : tools.spark.sliced.services.std.display.logicalspace.core.pick.IPicker;
	public var renderedFacesCount(default,never) : Int;
	public var renderer : tools.spark.sliced.services.std.display.logicalspace.core.render.RendererBase;
	public var rightClickMenuEnabled : Bool;
	public var scene : Scene3D;
	public var shareContext : Bool;
	public var stage3DProxy : tools.spark.sliced.services.std.display.logicalspace.core.managers.Stage3DProxy;
	public var touchPicker : tools.spark.sliced.services.std.display.logicalspace.core.pick.IPicker;
	public function new():Void {}}
