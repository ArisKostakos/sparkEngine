package co.gamep.sliced.services.std.display.logicalspace.animators.nodes;

class ParticleSpriteSheetNode extends ParticleNodeBase {
	public var _cycleDuration : Float;
	public var _cyclePhase : Float;
	public var _numColumns : Int;
	public var _numRows : Int;
	public var _totalFrames : Int;
	public var _usesCycle : Bool;
	public var _usesPhase : Bool;
	public var numColumns(default,never) : Float;
	public var numRows(default,never) : Float;
	public var totalFrames(default,never) : Float;
	public function new():Void {super();}}
