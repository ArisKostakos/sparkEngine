package co.gamep.sliced.services.std.display.logicalspace.loaders.misc;

class ResourceDependency {
	public var assets(default,never) : Dynamic;
	public var data(default,never) : Dynamic;
	public var dependencies(default,never) : Dynamic;
	public var id(default,never) : String;
	public var loader : SingleFileLoader;
	public var parentParser(default,never) : co.gamep.sliced.services.std.display.logicalspace.loaders.parsers.ParserBase;
	public var request(default,never) : Dynamic;
	public var retrieveAsRawData(default,never) : Bool;
	public var success : Bool;
	public var suppresAssetEvents(default,never) : Bool;
	public function new():Void {super();}}
