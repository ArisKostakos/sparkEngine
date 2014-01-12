package co.gamep.sliced.services.std.display.logicalspace.core.render;

class RendererBase {
	public var antiAlias : Int;
	public var background : co.gamep.sliced.services.std.display.logicalspace.textures.Texture2DBase;
	public var backgroundAlpha : Float;
	public var backgroundB : Float;
	public var backgroundG : Float;
	public var backgroundImageRenderer(default,never) : BackgroundImageRenderer;
	public var backgroundR : Float;
	public var clearOnRender : Bool;
	public var renderToTexture(default,never) : Bool;
	public var renderableSorter : co.gamep.sliced.services.std.display.logicalspace.core.sort.IEntitySorter;
	public var shareContext : Bool;
	public var stage3DProxy : co.gamep.sliced.services.std.display.logicalspace.core.managers.Stage3DProxy;
	public var textureRatioX : Float;
	public var textureRatioY : Float;
	public var viewHeight : Float;
	public var viewWidth : Float;
	public function new():Void {}}
