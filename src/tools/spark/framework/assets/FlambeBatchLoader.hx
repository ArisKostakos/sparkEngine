/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, January 2016
 */

package tools.spark.framework.assets;

import flambe.System;
import flambe.asset.AssetPack;
import flambe.asset.Manifest;
import flambe.util.Promise;
import flambe.util.SignalConnection;
import flambe.asset.AssetEntry.AssetFormat;

/**
 * @author Aris Kostakos
 */
class FlambeBatchLoader extends ABatchLoader
{	
	private var _manifest:Manifest;
	private var _promise:Promise<AssetPack>;
	
	//These are signals from actual platform (flambe) loading stuff, to this object..
	private var _promiseSignalSuccess:SignalConnection;
	private var _promiseSignalError:SignalConnection;
	private var _promiseSignalProgress:SignalConnection;
	
	
	private var _flambeLoader:FlambeLoader;
	
	public function new(p_flambeLoader: FlambeLoader)
	{
		_flambeLoader = p_flambeLoader;
		
		_manifest = new Manifest();
		
		super();
	}
	
	//Interface function for ServerLoader as well
	override private function _addFile(p_name:String, p_url:String, p_forceLoadAsData:Bool, p_bytes:Int):Void
	{
		if (p_forceLoadAsData)
		{
			//_manifest.add(p_name, p_url +"?" + Std.random(10000), 1, AssetFormat.Data);
			_manifest.add(p_name, p_url, p_bytes, AssetFormat.Data);
		}
		else
		{
			//_manifest.add(p_name, p_url +"?" + Std.random(10000), 1);
			_manifest.add(p_name, p_url, p_bytes);
		}
		
		_flambeLoader.registerAsset(_manifest, p_name);
	}
	
	//Interface function for ServerLoader as well.
	override public function start():Void
	{
		_promise = System.loadAssetPack(_manifest);
		
		_promiseSignalSuccess = _promise.success.connect(_onPromiseSuccess);
		_promiseSignalError = _promise.error.connect(_onPromiseError);
		_promiseSignalProgress = _promise.progressChanged.connect(_onPromiseProgress);
	}
	
	private function _onPromiseSuccess(p_assetPack:AssetPack):Void
	{
		_disposePromiseSignals();
		
		_flambeLoader.registerBatchLoad(_manifest, p_assetPack);
		
		//Emit Success for this Batch loader
		successSignal.emit();
	}
	
	private function _onPromiseError(p_error:String):Void
	{
		_disposePromiseSignals();
		
		//Emit Error for this Batch loader
		errorSignal.emit(p_error);
	}
	
	private function _onPromiseProgress():Void
	{
		//Emit Progress for this Batch loader
		progressSignal.emit(_promise.progress, _promise.total);
	}
	
	private function _disposePromiseSignals():Void
	{
		_promiseSignalSuccess.dispose();
		_promiseSignalError.dispose();
		_promiseSignalProgress.dispose();
	}
}