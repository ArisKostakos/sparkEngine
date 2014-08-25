package tools.spark.sliced.services.std.display.logicalspace.materials.utils;

class SimpleVideoPlayer implements IVideoPlayer {
	public var container(default,never) : Dynamic;
	public var height : Int;
	public var loop : Bool;
	public var mute : Bool;
	public var pan : Float;
	public var paused(default,never) : Bool;
	public var playing(default,never) : Bool;
	public var soundTransform : Dynamic;
	public var source : String;
	public var time(default,never) : Float;
	public var volume : Float;
	public var width : Int;
	public function new():Void {super();}}
