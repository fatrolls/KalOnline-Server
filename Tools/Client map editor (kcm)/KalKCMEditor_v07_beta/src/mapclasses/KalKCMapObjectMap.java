package mapclasses;
import java.awt.image.BufferedImage;

/**
 * KCM Object map type. 
 * 
 * obsolete, not even used by the engine (thnx phantom)
 * 
 * credit to BakaBug for specification ;>
 * @author harph
 *
 */

public class KalKCMapObjectMap extends KalKCMapTextureMap 
{

	/**
	 * Converts the map into an image
	 */
	public BufferedImage convertMapToImage()
	{
		BufferedImage im = new BufferedImage(256, 256, BufferedImage.TYPE_3BYTE_BGR);
		int pix = 0;
        for (int y = 255; y >= 0; y--)
        	for (int x = 0; x <= 255; x++)
        	{        		        		
        		pix = (super.getMap()[x][y] * 255) + ((super.getMap()[x][y] * 255)*256) + ((super.getMap()[x][y] * 255)*256*256);
        		im.setRGB(x,y, pix);
        	}
        
        return im;
		
	}	
		
}
