/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, December 2014
 */

package tools.spark.framework.config;
import tools.spark.framework.assets.Asset;
import tools.spark.framework.assets.Module;


/**
 * ...
 * @author Aris Kostakos
 */
class ConfigInstantiator
{
	private var _xmlNodeTypeToNodeName:Map<ENodeType,String>;
	private var _configNode:Xml;
	private var _rootNodeType:ENodeType;
	
	public function new(p_xmlNodeTypeToNodeName:Map<ENodeType,String>) 
	{
		_xmlNodeTypeToNodeName = p_xmlNodeTypeToNodeName;
	}
	
	public function init(p_configNode:Xml, p_rootNodeType:ENodeType):Void
	{
		_configNode = p_configNode;
		_rootNodeType = p_rootNodeType;
	}
	
	public function instantiateProject():Void
	{	
		//Project Node
		var l_projectNode:Xml = _configNode.elementsNamed(_xmlNodeTypeToNodeName[ENodeType.PROJECT]).next();
		
		//Project Name
		Project.main.name = l_projectNode.elementsNamed(_xmlNodeTypeToNodeName[ENodeType.PROJECT_NAME]).next().firstChild().nodeValue;
		
		//Project Version
		Project.main.version = l_projectNode.elementsNamed(_xmlNodeTypeToNodeName[ENodeType.PROJECT_VERSION]).next().firstChild().nodeValue;
		
		//Project Type
		Project.main.type = _rootNodeType;
		
		//Project Execute Modules Node
		var l_ExecuteModules:Xml = l_projectNode.elementsNamed(_xmlNodeTypeToNodeName[ENodeType.EXECUTE_AT_LAUNCH]).next();
		
		for ( executeModule in l_ExecuteModules.elements()) 
		{
			Project.main.executeModules.push(executeModule.firstChild().nodeValue);
		}
	}
	
	public function instantiateSliced():Void
	{	
		//Sliced Node
		var l_slicedNode:Xml = _configNode.elementsNamed(_xmlNodeTypeToNodeName[ENodeType.SLICED]).next();
		
		//Common
		Project.main.sliced[ENodeType.LOGIC_SERVICE]= l_slicedNode.elementsNamed(_xmlNodeTypeToNodeName[ENodeType.LOGIC_SERVICE]).next().firstChild().nodeValue;
		Project.main.sliced[ENodeType.COMMUNICATIONS_SERVICE] = l_slicedNode.elementsNamed(_xmlNodeTypeToNodeName[ENodeType.COMMUNICATIONS_SERVICE]).next().firstChild().nodeValue;
		Project.main.sliced[ENodeType.EVENT_SERVICE]= l_slicedNode.elementsNamed(_xmlNodeTypeToNodeName[ENodeType.EVENT_SERVICE]).next().firstChild().nodeValue;
		
		//Client Only
		if (Project.main.type == ENodeType.CLIENT)
		{
			Project.main.sliced[ENodeType.SOUND_SERVICE] = l_slicedNode.elementsNamed(_xmlNodeTypeToNodeName[ENodeType.SOUND_SERVICE]).next().firstChild().nodeValue;
			Project.main.sliced[ENodeType.INPUT_SERVICE] = l_slicedNode.elementsNamed(_xmlNodeTypeToNodeName[ENodeType.INPUT_SERVICE]).next().firstChild().nodeValue;
			Project.main.sliced[ENodeType.DISPLAY_SERVICE]= l_slicedNode.elementsNamed(_xmlNodeTypeToNodeName[ENodeType.DISPLAY_SERVICE]).next().firstChild().nodeValue;
		}
	}
	
	public function instantiatePaths():Void
	{	
		//Paths Node
		var l_pathsNode:Xml = _configNode.elementsNamed(_xmlNodeTypeToNodeName[ENodeType.PATHS]).next();

		for ( f_pathNode in l_pathsNode.elements()) 
		{
			Project.main.setPath(f_pathNode.get("location"), f_pathNode.get("type"), f_pathNode.firstChild().nodeValue);
		}
	}
	
	public function instantiateAssets():Void
	{	
		//Assets Node
		var l_assetsNode:Xml = _configNode.elementsNamed(_xmlNodeTypeToNodeName[ENodeType.ASSETS]).next();
		
		//Modules
		for ( f_moduleNode in l_assetsNode.elements()) 
		{
			Project.main.modules[f_moduleNode.get("id")] = _instantiateModule(f_moduleNode);
		}
		
	}
	
	private function _instantiateModule(p_moduleNode:Xml):Module
	{
		var l_module:Module = new Module(p_moduleNode.get("id"));
		
		//Execute Entity
		l_module.executeEntity = p_moduleNode.get("executeEntity");
		
		//Create the Modules's Required Modules
		//@todo: //when i check whether the array xml element exists, and then access the first node it found (the hasNext and next functions),
			//I actually search through the xml TWICE. Instead, save the iterator from the first call(the hasNext), and use that to do the next()
		if (p_moduleNode.elementsNamed(_xmlNodeTypeToNodeName[ENodeType.REQUIRES]).hasNext())
		{
			var l_requiresNode:Xml = p_moduleNode.elementsNamed(_xmlNodeTypeToNodeName[ENodeType.REQUIRES]).next();
			for ( requiresModuleNode in  l_requiresNode.elements()) 
			{
				l_module.requiresModules.push(requiresModuleNode.firstChild().nodeValue);
			}
		}
		
		//Assets
		var l_assetChildren:Iterator<Xml> = p_moduleNode.elementsNamed(_xmlNodeTypeToNodeName[ENodeType.ASSET]);
		while (l_assetChildren.hasNext())
		{
			var w_assetNode:Xml = l_assetChildren.next();
			
			var w_asset:Asset = _instantiateAsset(w_assetNode);
			
			l_module.assets[w_asset.id] = w_asset;
		}
		
		return l_module;
	}
	
	private function _instantiateAsset(p_assetNode:Xml):Asset
	{
		var l_assetId:String;
		var l_assetUrl = p_assetNode.firstChild().nodeValue;
		
		if (p_assetNode.get("id") == "auto")
			l_assetId = p_assetNode.get("type") + ':' + StringTools.replace(l_assetUrl.substring(0, l_assetUrl.lastIndexOf(".")), "/", ".");
		else
			l_assetId = p_assetNode.get("id");
		
		var l_asset:Asset = new Asset(l_assetId);
		
		l_asset.url = l_assetUrl;
		l_asset.type =  p_assetNode.get("type");
		l_asset.subtype =  p_assetNode.get("subtype");
		l_asset.location =  p_assetNode.get("location");
		l_asset.bytes =  p_assetNode.get("bytes");
		l_asset.condition =  p_assetNode.get("condition");
		l_asset.forceLoadAsData =  p_assetNode.get("forceLoadAsData");
		
		return l_asset;
	}
}