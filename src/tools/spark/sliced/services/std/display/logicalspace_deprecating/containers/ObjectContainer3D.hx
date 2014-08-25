package tools.spark.sliced.services.std.display.logicalspace.containers;

@:keep class ObjectContainer3D extends tools.spark.sliced.services.std.display.logicalspace.core.base.Object3D implements tools.spark.sliced.services.std.display.logicalspace.library.assets.IAsset {
	public var _ancestorsAllowMouseEnabled : Bool;
	public var _isRoot : Bool;
	public var assetType(default,default) : String;
	public var ignoreTransform : Bool;
	public var implicitPartition : tools.spark.sliced.services.std.display.logicalspace.core.partition.Partition3D;
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
	public var partition : tools.spark.sliced.services.std.display.logicalspace.core.partition.Partition3D;
	public var scene : Scene3D;
	public var scenePosition(default,never) : Dynamic;
	public var sceneTransform(default,never) : Dynamic;
	public var visible : Bool;
	public var velX:Float;
	public var velY:Float;
	public var velZ:Float;
	
	public var _children:Array<ObjectContainer3D>;
	
	public function new():Void 
	{
		super();
		
		velX = 0;
		velY = 0;
		velZ = 0;
		
		_children = new Array<ObjectContainer3D>();
	
	}
	
	public function addChild(child:ObjectContainer3D):ObjectContainer3D
	{
		_children.push(child);
		
		return child;
	}

}
