package tools.spark.sliced.services.std.display.logicalspace.animators;

class SpriteSheetAnimator extends AnimatorBase implements IAnimator {
	public var backAndForth : Bool;
	public var currentFrameNumber(default,never) : Int;
	public var fps : Int;
	public var reverse : Bool;
	public var totalFrames(default,never) : Int;
	public function new():Void {super();}}
