package co.gamep.sliced.services.std.display.logicalspace.containers;

class ObjectContainer3D extends co.gamep.sliced.services.std.display.logicalspace.core.base.Object3D implements co.gamep.sliced.services.std.display.logicalspace.library.assets.IAsset {
	public var _ancestorsAllowMouseEnabled : Bool;
	public var _isRoot : Bool;
	public var assetType(default,never) : String;
	public var ignoreTransform : Bool;
	public var implicitPartition : co.gamep.sliced.services.std.display.logicalspace.core.partition.Partition3D;
	public var inverseSceneTransform(default,never) : Dynamic;
	public var isVisible(default,never) : Bool;
	public var maxX(default,never) : Float;
	public var maxY(default,never) : Float;
	public var maxZ(default,never) : Float;
	public var minX(default,never) : Float;
	public var minY(default,never) : Float;
	public var minZ(default,never) : Float;
	public var mouseChildren : Bool;
	public var mouseEnabled : Bool;
	public var numChildren(default,never) : Int;
	public var parent(default,never) : ObjectContainer3D;
	public var partition : co.gamep.sliced.services.std.display.logicalspace.core.partition.Partition3D;
	public var scene : Scene3D;
	public var scenePosition(default,never) : Dynamic;
	public var sceneTransform(default,never) : Dynamic;
	public var visible : Bool;
	public function new():Void {super();}}
