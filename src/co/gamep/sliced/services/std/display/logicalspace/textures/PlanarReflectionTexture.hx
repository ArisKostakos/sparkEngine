package co.gamep.sliced.services.std.display.logicalspace.textures;

class PlanarReflectionTexture extends RenderTexture {
	public var plane : co.gamep.sliced.services.std.display.logicalspace.core.math.Plane3D;
	public var renderer : co.gamep.sliced.services.std.display.logicalspace.core.render.RendererBase;
	public var scale : Float;
	public var textureRatioX(default,never) : Float;
	public var textureRatioY(default,never) : Float;
	public function new():Void {super();}}
