package co.gamep.sliced.services.std.display.logicalspace.library.assets;

interface IAsset   {
	var assetFullPath(default,never) : Array<Dynamic>;
	var assetNamespace(default,never) : String;
	var assetType(default,never) : String;
	var id : String;
	var name : String;
}
