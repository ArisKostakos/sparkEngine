package tools.spark.sliced.services.std.display.logicalspace.containers;

@:keep class Scene3D {
	public var name: String;
	public var _sceneGraphRoot : ObjectContainer3D;
	public var numChildren(default,never) : Int;
	public var partition : tools.spark.sliced.services.std.display.logicalspace.core.partition.Partition3D;
	
	public function new():Void
	{ 
		_sceneGraphRoot = new ObjectContainer3D();
	}
}
