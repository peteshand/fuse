package kea2.core.atlas.renderer;
import kea2.core.atlas.items.AtlasItem;
import kea2.core.atlas.packer.AtlasPartition;
import kea2.utils.Notifier;
import kea.texture.Texture;
import kea.util.MatrixUtils;
import kha.math.FastMatrix3;

/**
 * ...
 * @author P.J.Shand
 */
class AtlasRenderer
{
	var atlasBuffer:AtlasBuffer;
	var currentTextureAtlas(default, set):TextureAtlas;
	var rotMatrix:FastMatrix3;
	
	public function new(atlasBuffer:AtlasBuffer) 
	{
		this.atlasBuffer = atlasBuffer;
		rotMatrix = FastMatrix3.identity();
		rotMatrix = MatrixUtils.rotateMatrix(rotMatrix, 20 / 180 * Math.PI);
	}
	
	public function render(orderedlist:Array<AtlasItem>) 
	{
		//currentTextureAtlas = atlasBuffer.atlases[0];
		//
		//for (i in 0...orderedlist.length) 
		//{
			//var atlasItem:AtlasItem = orderedlist[i];
			//if (atlasItem.rendered) continue;
			//atlasItem.rendered = true;
			//
			//currentTextureAtlas = atlasBuffer.atlases[atlasItem.atlasIndex];
			//
			//if (atlasItem.partition.value != null){
				//var partition:AtlasPartition = atlasItem.partition.value;
				//if (atlasItem.rotation == 90) {
					//currentTextureAtlas.texture.g2.rotate(90 / 180 * Math.PI, partition.x, partition.y);
					//currentTextureAtlas.texture.g2.drawImage(atlasItem.texture, partition.x, partition.y - partition.width);
					//currentTextureAtlas.texture.g2.rotate(-90 / 180 * Math.PI, partition.x, partition.y);
				//}
				//else {
					//currentTextureAtlas.texture.g2.drawImage(atlasItem.texture, partition.x, partition.y);
				//}
			//}
		//}
		//
		//currentTextureAtlas = null;
	}
	
	function drawOutline(texture:Texture, x:Float, y:Float, width:Dynamic, height:Dynamic) 
	{
		texture.g2.begin(false);
		texture.g2.color = 0xAA000000;
		texture.g2.fillRect(x + 2, y + 2, width - 2, height - 2);
		texture.g2.color = 0xFFFFFFFF;
		texture.g2.end();
	}
	
	function get_currentTextureAtlas():TextureAtlas 
	{
		return currentTextureAtlas;
	}
	
	function set_currentTextureAtlas(value:TextureAtlas):TextureAtlas 
	{
		//if (value == null) {
			//if (currentTextureAtlas != null) currentTextureAtlas.texture.g2.end();
		//}
		//currentTextureAtlas = value;
		//if (currentTextureAtlas != null) currentTextureAtlas.texture.g2.begin(false);
		return currentTextureAtlas;
	}
}