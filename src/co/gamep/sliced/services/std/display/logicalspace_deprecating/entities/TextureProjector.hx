package co.gamep.sliced.services.std.display.logicalspace.entities;

class TextureProjector extends co.gamep.sliced.services.std.display.logicalspace.containers.ObjectContainer3D {
	public var aspectRatio : Float;
	public var fieldOfView : Float;
	public var texture : co.gamep.sliced.services.std.display.logicalspace.textures.Texture2DBase;
	public var viewProjection(default,never) : Dynamic;
	public function new():Void {super();}}
