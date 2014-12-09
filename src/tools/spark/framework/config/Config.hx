package tools.spark.framework.config;
import flambe.asset.File;

/**
 * ...
 * @author Aris Kostakos
 */
class Config
{
	private var _configValidator:ConfigValidator;
	//private var _configInstantiator:ConfigInstantiator;
	private var _configFile:File;
	private var _xmlNodeTypeToNodeName:Map<ENodeType,String>;
	private var _xmlNodeNameToNodeType:Map<String,ENodeType>;
	
	public function new(p_configFile:File) 
	{
		_configFile = p_configFile;
		_init();
	}
	
	inline private function _init():Void
	{
		_initNodeNamesMap();
		_initNodeTypesMap();
		
		_configValidator = new ConfigValidator(_xmlNodeTypeToNodeName);
		//_configInstantiator = new GameClassInstantiator(_xmlNodeTypeToNodeName);
	}
	
	public function parseClient():Bool
	{
		return _parse(ENodeType.CLIENT);
	}
	
	public function parseServer():Bool
	{
		return _parse(ENodeType.SERVER);
	}
	
	private function _parse(p_rootNodeType:ENodeType):Bool
	{
		var l_configNode:Xml;
		
		//Parse
		Console.info('Parsing Config file');
		try 
		{
			l_configNode=Xml.parse(_configFile.toString());
		}
		catch (err:Dynamic) 
		{
			Console.error(Std.string(err));
			return false;
		}
		
		//Get First Element Node
		l_configNode = l_configNode.firstElement();
		
		//Make Sure the Config file is correct (Client or Server)
		var l_configNodeType:ENodeType = _xmlNodeNameToNodeType[l_configNode.nodeName];
		if (l_configNodeType != p_rootNodeType)
		{
			Console.error('Config file is not correct. Expected Root Child: ' + p_rootNodeType + ', got: ' + l_configNodeType +'.');
			return false;
		}
		
		//Validate
		Console.info('Validating Config file');
		
		//Init Validation (construct rules for either client or server config)
		_configValidator.init(p_rootNodeType);
		
		if (_validateConfigNode(l_configNode)==false)
		{
			Console.error('Config file could not be validated');
			return false;
		}
		
		
		//Instantiate
		
		
		
		
		Console.info('successs yooo');
		return true;
	}
	
	private function _validateConfigNode(p_configNode:Xml):Bool
	{
		var l_configNodeType:ENodeType = _xmlNodeNameToNodeType[p_configNode.nodeName];
		
		if (_configValidator.validateConfigNode(p_configNode, l_configNodeType))
		{
			//For all Elements
			//@todo: Catch infinite recursion if that could somehow be possible..
			for ( elt in p_configNode.elements() ) 
			{
				if (_validateConfigNode(elt) == false)
				{
					Console.error('Failed to validate config node ' + elt.nodeName);
					return false;
				}
			}
			return true;
		}
		else
		{
			Console.error('Failed to validate $l_configNodeType node');
			return false;
		}
	}
	
	//Mapping
	
	private function _initNodeNamesMap():Void
	{
		_xmlNodeTypeToNodeName = new Map<ENodeType,String>();
		
		_xmlNodeTypeToNodeName[ENodeType.CLIENT] = "Client";
		_xmlNodeTypeToNodeName[ENodeType.SERVER] = "Server";
		_xmlNodeTypeToNodeName[ENodeType.PROJECT] = "Project";
		_xmlNodeTypeToNodeName[ENodeType.SLICED] = "Sliced";
		_xmlNodeTypeToNodeName[ENodeType.PATHS] = "Paths";
		_xmlNodeTypeToNodeName[ENodeType.ASSETS] = "Assets";
		_xmlNodeTypeToNodeName[ENodeType.PROJECT_NAME] = "Name";
		_xmlNodeTypeToNodeName[ENodeType.PROJECT_VERSION] = "Version";
		_xmlNodeTypeToNodeName[ENodeType.EXECUTE_AT_LAUNCH] = "ExecuteAtLaunch";
		_xmlNodeTypeToNodeName[ENodeType.EXECUTE_MODULE] = "ExecuteModule";
		_xmlNodeTypeToNodeName[ENodeType.SOUND_SERVICE] = "Sound";
		_xmlNodeTypeToNodeName[ENodeType.LOGIC_SERVICE] = "Logic";
		_xmlNodeTypeToNodeName[ENodeType.INPUT_SERVICE] = "Input";
		_xmlNodeTypeToNodeName[ENodeType.COMMUNICATIONS_SERVICE] = "Comms";
		_xmlNodeTypeToNodeName[ENodeType.EVENT_SERVICE] = "Event";
		_xmlNodeTypeToNodeName[ENodeType.DISPLAY_SERVICE] = "Display";
		_xmlNodeTypeToNodeName[ENodeType.PATH] = "Path";
		_xmlNodeTypeToNodeName[ENodeType.MODULE] = "Module";
		_xmlNodeTypeToNodeName[ENodeType.ASSET] = "Asset";
		_xmlNodeTypeToNodeName[ENodeType.REQUIRES] = "Requires";
		_xmlNodeTypeToNodeName[ENodeType.REQUIRES_MODULE] = "RequiresModule";
	}
	
	private function _initNodeTypesMap():Void
	{
		_xmlNodeNameToNodeType = new Map<String,ENodeType>();
		
		_xmlNodeNameToNodeType[_xmlNodeTypeToNodeName[ENodeType.CLIENT]] = ENodeType.CLIENT;
		_xmlNodeNameToNodeType[_xmlNodeTypeToNodeName[ENodeType.SERVER]] = ENodeType.SERVER;
		_xmlNodeNameToNodeType[_xmlNodeTypeToNodeName[ENodeType.PROJECT]] = ENodeType.PROJECT;
		_xmlNodeNameToNodeType[_xmlNodeTypeToNodeName[ENodeType.SLICED]] = ENodeType.SLICED;
		_xmlNodeNameToNodeType[_xmlNodeTypeToNodeName[ENodeType.PATHS]] = ENodeType.PATHS;
		_xmlNodeNameToNodeType[_xmlNodeTypeToNodeName[ENodeType.ASSETS]] = ENodeType.ASSETS;
		_xmlNodeNameToNodeType[_xmlNodeTypeToNodeName[ENodeType.PROJECT_NAME]] = ENodeType.PROJECT_NAME;
		_xmlNodeNameToNodeType[_xmlNodeTypeToNodeName[ENodeType.PROJECT_VERSION]] = ENodeType.PROJECT_VERSION;
		_xmlNodeNameToNodeType[_xmlNodeTypeToNodeName[ENodeType.EXECUTE_AT_LAUNCH]] = ENodeType.EXECUTE_AT_LAUNCH;
		_xmlNodeNameToNodeType[_xmlNodeTypeToNodeName[ENodeType.EXECUTE_MODULE]] = ENodeType.EXECUTE_MODULE;
		_xmlNodeNameToNodeType[_xmlNodeTypeToNodeName[ENodeType.SOUND_SERVICE]] = ENodeType.SOUND_SERVICE;
		_xmlNodeNameToNodeType[_xmlNodeTypeToNodeName[ENodeType.LOGIC_SERVICE]] = ENodeType.LOGIC_SERVICE;
		_xmlNodeNameToNodeType[_xmlNodeTypeToNodeName[ENodeType.INPUT_SERVICE]] = ENodeType.INPUT_SERVICE;
		_xmlNodeNameToNodeType[_xmlNodeTypeToNodeName[ENodeType.COMMUNICATIONS_SERVICE]] = ENodeType.COMMUNICATIONS_SERVICE;
		_xmlNodeNameToNodeType[_xmlNodeTypeToNodeName[ENodeType.EVENT_SERVICE]] = ENodeType.EVENT_SERVICE;
		_xmlNodeNameToNodeType[_xmlNodeTypeToNodeName[ENodeType.DISPLAY_SERVICE]] = ENodeType.DISPLAY_SERVICE;
		_xmlNodeNameToNodeType[_xmlNodeTypeToNodeName[ENodeType.PATH]] = ENodeType.PATH;
		_xmlNodeNameToNodeType[_xmlNodeTypeToNodeName[ENodeType.MODULE]] = ENodeType.MODULE;
		_xmlNodeNameToNodeType[_xmlNodeTypeToNodeName[ENodeType.ASSET]] = ENodeType.ASSET;
		_xmlNodeNameToNodeType[_xmlNodeTypeToNodeName[ENodeType.REQUIRES]] = ENodeType.REQUIRES;
		_xmlNodeNameToNodeType[_xmlNodeTypeToNodeName[ENodeType.REQUIRES_MODULE]] = ENodeType.REQUIRES_MODULE;
	}
}