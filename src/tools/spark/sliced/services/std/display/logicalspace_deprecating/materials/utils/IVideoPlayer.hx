package tools.spark.sliced.services.std.display.logicalspace.materials.utils;

interface IVideoPlayer  {
	var container(default,never) : Dynamic;
	var height : Int;
	var loop : Bool;
	var mute : Bool;
	var pan : Float;
	var paused(default,never) : Bool;
	var playing(default,never) : Bool;
	var soundTransform : Dynamic;
	var source : String;
	var time(default,never) : Float;
	var volume : Float;
	var width : Int;
}
