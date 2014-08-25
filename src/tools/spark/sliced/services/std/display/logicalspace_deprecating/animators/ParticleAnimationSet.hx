package tools.spark.sliced.services.std.display.logicalspace.animators;

class ParticleAnimationSet extends AnimationSetBase implements IAnimationSet {
	public var _animationRegisterCache : tools.spark.sliced.services.std.display.logicalspace.animators.data.AnimationRegisterCache;
	public var hasBillboard : Bool;
	public var hasColorAddNode : Bool;
	public var hasColorMulNode : Bool;
	public var hasUVNode : Bool;
	public var initParticleFunc : Dynamic;
	public var needVelocity : Bool;
	public var particleNodes(default,never) : Dynamic;
	public function new():Void {super();}}
