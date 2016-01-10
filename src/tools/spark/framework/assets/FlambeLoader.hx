/* Copyright © Spark.tools - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Aris Kostakos <aris@spark.tools>, October 2013
 */

package tools.spark.framework.assets;

import flambe.asset.File;
import flambe.display.Texture;
import flambe.sound.Sound;
import flambe.System;
import flambe.asset.AssetPack;
import flambe.asset.Manifest;
import flambe.util.Promise;
import flambe.util.Signal0;
import flambe.util.Signal1;
import flambe.util.Signal2;
import flambe.util.SignalConnection;
import flambe.asset.AssetEntry.AssetFormat;
import flambe.asset.Asset;
import tools.spark.framework.assets.interfaces.IBatchLoader;

/**
 * @author Aris Kostakos
 */
class FlambeLoader
{	
	//Ok so.. these signals should be later used for informing Assets of General progress of ALL simutaneous batch loaders
	//We don't hook FlambeBatchLoader signals yet.. either we do, or we let the Batchloader call a function here..
	public var successSignal:Signal0;
	public var errorSignal:Signal1<String>;
	public var progressSignal:Signal2<Float,Float>;
	
	private var _assetInUse:Map<String,Bool>;
	private var _assetToBatchLoad:Map<String,Manifest>;
	private var _batchLoadToAssetPack:Map<Manifest,AssetPack>;
	
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
		_batchLoadToAssetPack = new Map<Manifest,AssetPack>();
	}
	
	//Interface function for ServerLoader as well
	public function startNewBatchLoad():IBatchLoader
	{
		return new FlambeBatchLoader(this);
	}
	
	//Register Stuff
	public function registerBatchLoad(p_manifest:Manifest, p_assetPack:AssetPack):Void
	{
		_batchLoadToAssetPack[p_manifest] = p_assetPack;
	}
	
	public function registerAsset(p_manifest:Manifest, p_name:String):Void
	{
		_assetToBatchLoad[p_name]= p_manifest;
	}
	
	//Some "getters"
	public function getAssetPackOf(p_name:String):AssetPack
	{
		return _batchLoadToAssetPack[_assetToBatchLoad[p_name]];
	}
	
	public function getFile(p_name:String):File
	{
		return _batchLoadToAssetPack[_assetToBatchLoad[p_name]].getFile(p_name);
	}
	
	public function getTexture(p_name:String):Texture
	{
		return _batchLoadToAssetPack[_assetToBatchLoad[p_name]].getTexture(p_name);
	}
	
	public function getSound(p_name:String):Sound
	{
		return _batchLoadToAssetPack[_assetToBatchLoad[p_name]].getSound(p_name);
	}
}