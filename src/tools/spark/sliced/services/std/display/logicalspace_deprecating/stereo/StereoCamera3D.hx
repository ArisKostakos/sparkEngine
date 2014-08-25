package tools.spark.sliced.services.std.display.logicalspace.stereo;

class StereoCamera3D extends tools.spark.sliced.services.std.display.logicalspace.cameras.Camera3D {
	public var leftCamera(default,never) : tools.spark.sliced.services.std.display.logicalspace.cameras.Camera3D;
	public var rightCamera(default,never) : tools.spark.sliced.services.std.display.logicalspace.cameras.Camera3D;
	public var stereoFocus : Float;
	public var stereoOffset : Float;
	public function new():Void {super();}}
