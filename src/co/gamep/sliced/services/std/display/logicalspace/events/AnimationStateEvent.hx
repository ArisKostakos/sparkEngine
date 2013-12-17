package co.gamep.sliced.services.std.display.logicalspace.events;

class AnimationStateEvent  {
	public var animationNode(default,never) : co.gamep.sliced.services.std.display.logicalspace.animators.nodes.AnimationNodeBase;
	public var animationState(default,never) : co.gamep.sliced.services.std.display.logicalspace.animators.states.IAnimationState;
	public var animator(default,never) : co.gamep.sliced.services.std.display.logicalspace.animators.IAnimator;
	public function new():Void {super();}}
