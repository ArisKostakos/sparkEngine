package co.gamep.sliced.services.std.display.logicalspace.containers;

class View3D  {
	public var antiAlias : Int;
	public var background : co.gamep.sliced.services.std.display.logicalspace.textures.Texture2DBase;
	public var backgroundAlpha : Float;
	public var backgroundColor : Int;
	public var camera : co.gamep.sliced.services.std.display.logicalspace.cameras.Camera3D;
	public var deltaTime(default,never) : Int;
	public var depthPrepass : Bool;
	public var entityCollector(default,never) : co.gamep.sliced.services.std.display.logicalspace.core.traverse.EntityCollector;
	public var filters3d : Array<Dynamic>;
	public var forceMouseMove : Bool;
	public var layeredView : Bool;
	public var mousePicker : co.gamep.sliced.services.std.display.logicalspace.core.pick.IPicker;
	public var renderedFacesCount(default,never) : Int;
	public var renderer : co.gamep.sliced.services.std.display.logicalspace.core.render.RendererBase;
	public var rightClickMenuEnabled : Bool;
	public var scene : Scene3D;
	public var shareContext : Bool;
	public var stage3DProxy : co.gamep.sliced.services.std.display.logicalspace.core.managers.Stage3DProxy;
	public var touchPicker : co.gamep.sliced.services.std.display.logicalspace.core.pick.IPicker;
	public function new():Void {super();}}
