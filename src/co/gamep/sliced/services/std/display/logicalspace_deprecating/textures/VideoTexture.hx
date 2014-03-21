package co.gamep.sliced.services.std.display.logicalspace.textures;

class VideoTexture extends BitmapTexture {
	public var autoPlay : Bool;
	public var autoUpdate : Bool;
	public var materialHeight : Int;
	public var materialWidth : Int;
	public var player(default,never) : co.gamep.sliced.services.std.display.logicalspace.materials.utils.IVideoPlayer;
	public function new():Void {super();}}
