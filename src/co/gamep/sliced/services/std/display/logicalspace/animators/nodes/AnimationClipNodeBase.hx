package co.gamep.sliced.services.std.display.logicalspace.animators.nodes;

class AnimationClipNodeBase extends AnimationNodeBase {
	public var durations(default,never) : Dynamic;
	public var fixedFrameRate : Bool;
	public var lastFrame(default,never) : Int;
	public var looping : Bool;
	public var stitchFinalFrame : Bool;
	public var totalDelta(default,never) : Dynamic;
	public var totalDuration(default,never) : Int;
	public function new():Void {super();}}
