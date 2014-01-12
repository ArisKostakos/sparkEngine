/* Copyright © Game Plus Studios - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <a.kostakos@gmail.com>, October 2013
 */

package co.gamep.framework.assets;

import flambe.System;
import flambe.asset.AssetPack;
import flambe.asset.Manifest;
import flambe.util.Promise;
import flambe.util.Signal0;
import flambe.util.Signal1;
import flambe.util.Signal2;
import flambe.util.SignalConnection;
import flambe.asset.AssetEntry.AssetFormat;

/**
 * Load the config folder statically...
 * Load the lionscript\std folder statically...
 * Load the lionscript\workingProject folder dynamically
 * should also load all other asset folders (data, images, models, sounds)
 * dynamically as well. BUT should load the std parts in those folders
 * statically here. For example a font that I should always have
 * available for ALL projects.. Should be very limited.
 * FOR NOW, load lionscript\workingProject folder statically as well...
 * FOR NOW, load all assets statically...
 * @author Aris Kostakos
 */
class FlambeLoader
{	
	public var successSignal:Signal0;
	public var errorSignal:Signal1<String>;
	public var progressSignal:Signal2<Float,Float>;
	
	private var _assetInUse:Map<String,Bool>;
	private var _assetToBatchLoad:Map<String,Manifest>;
	private var _batchLoadToAssetPack:Map<String,Bool>;
	
	private var _manifest:Manifest;
	private var _promise:Promise<AssetPack>;
	private var _promiseSignalSuccess:SignalConnection;
	private var _promiseSignalError:SignalConnection;
	private var _promiseSignalProgress:SignalConnection;
	
	public function new()
	{
		_init();
	}
	
	private function _init():Void
	{
		successSignal = new Signal0();
		errorSignal = new Signal1<String>();
		progressSignal = new Signal2<Float,Float>();
		
		_assetInUse = new Map<String,Bool>();
		_assetToBatchLoad = new Map<String,Manifest>();
		_batchLoadToAssetPack = new Map<String,Bool>();
	}
	
	//Interface function for ServerLoader as well
	public function startNewBatchLoad():Void
	{
		_manifest = new Manifest();
	}
	
	//Interface function for ServerLoader as well
	public function addFile(p_name:String, p_url:String, p_forceLoadAsData:Bool):Void
	{
		if (p_forceLoadAsData)
		{
			_manifest.add(p_name, p_url, 112689, AssetFormat.Data);
		}
		else
		{
			_manifest.add(p_name, p_url, 112689);
		}
		
	}
	
	
	//Interface function for ServerLoader as well.
	public function initiateLoad():Void
	{
		_promise = System.loadAssetPack(_manifest);
		
		_promiseSignalSuccess = _promise.success.connect(_onPromiseSuccess);
		_promiseSignalError = _promise.error.connect(_onPromiseError);
		_promiseSignalProgress = _promise.progressChanged.connect(_onPromiseProgress);
	}
	
	private function _onPromiseSuccess(p_assettPack:AssetPack):Void
	{
		_disposePromiseSignals();
		
		successSignal.emit();
	}
	
	private function _onPromiseError(p_error:String):Void
	{
		_disposePromiseSignals();
		
		errorSignal.emit(p_error);
	}
	
	private function _onPromiseProgress():Void
	{
		progressSignal.emit(_promise.progress, _promise.total);
	}
	
	private function _disposePromiseSignals():Void
	{
		_promiseSignalSuccess.dispose();
		_promiseSignalError.dispose();
		_promiseSignalProgress.dispose();
	}
}