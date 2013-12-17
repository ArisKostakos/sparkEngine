package co.gamep.sliced.services.std.display.logicalspace.animators.states;

class SpriteSheetAnimationState extends AnimationClipState implements ISpriteSheetAnimationState {
	public var backAndForth(never,default) : Bool;
	public var currentFrameData(default,never) : co.gamep.sliced.services.std.display.logicalspace.animators.data.SpriteSheetAnimationFrame;
	public var currentFrameNumber : Int;
	public var reverse(never,default) : Bool;
	public var totalFrames(default,never) : Int;
	public function new():Void {super();}}
