package co.gamep.sliced.services.std.display.logicalspace.filters;

class DepthOfFieldFilter3D extends Filter3DBase {
	public var focusDistance : Float;
	public var focusTarget : co.gamep.sliced.services.std.display.logicalspace.containers.ObjectContainer3D;
	public var maxBlurX : Int;
	public var maxBlurY : Int;
	public var range : Float;
	public var stepSize : Int;
	public function new():Void {super();}}
