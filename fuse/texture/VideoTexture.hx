package fuse.texture;

import fuse.core.front.texture.VideoTexture as FrontVideoTexture;
import msignal.Signal.Signal0;

class VideoTexture extends BaseTexture
{
    var videoTexture:FrontVideoTexture;

    //public var netStream:NetStream;
	//public var nativeVideoTexture:NativeVideoTexture;
	public var loop(get, set):Bool;
	public var duration(get, set):Null<Float>;
	public var time(get, null):Float;
	public var onComplete(get, null):Signal0;
	public var onMetaData(get, null):Signal0;
	
    public function new(url:String=null) 
	{
		super();
        texture = videoTexture = new FrontVideoTexture(url);
    }

	public function play(url:String=null, autoPlay:Bool=true) 
	{
		videoTexture.play(url, autoPlay);
	}

	public function stop()
	{
		videoTexture.stop();
	}

	public function pause()
	{
		videoTexture.pause();
	}

	public function seek(offset:Float)
	{
		videoTexture.seek(offset);
	}

	function get_loop():Bool								{	return videoTexture.loop;				}
	function get_duration():Null<Float>						{	return videoTexture.duration;			}
	function get_time():Float								{	return videoTexture.time;				}
	function get_onComplete():Signal0						{	return videoTexture.onComplete;			}
	function get_onMetaData():Signal0						{	return videoTexture.onMetaData;			}
	
	function set_loop(value:Bool):Bool						{	return videoTexture.loop = value;		}
	function set_duration(value:Null<Float>):Null<Float>	{	return videoTexture.duration = value;	}
}