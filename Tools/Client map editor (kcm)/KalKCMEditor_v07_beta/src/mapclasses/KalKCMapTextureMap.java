package mapclasses;
import java.awt.image.BufferedImage;
import java.io.DataInputStream;
import java.io.EOFException;

/**
 * KCM Texture map type
 * 
 * credit to BakaBug for specification ;>
 * @author harph
 *
 */
public class KalKCMapTextureMap 
{
	private byte[][] map;
	
	public KalKCMapTextureMap()
	{		
		map = new byte[256][256];
	}
	
	protected byte[][] getMap()
	{
		return map;
	}
	
	/**
	 * Reads the map from the given input stream 
	 * @param indat
	 * @throws Exception
	 */	
	public void readMap(DataInputStream indat) throws Exception
	{
        try
        {            
            for (int y = 255; y >= 0; y--)
            	for (int x = 0; x <= 255; x++)   
            	{
            		map[x][y] = indat.readByte();            		
            	}
        }
        catch (EOFException e)
        {
        	e.printStackTrace();
        }		
	}

	/**
	 * Converts the map to an image
	 * @return the image
	 */	
	public BufferedImage convertMapToImage()
	{
		BufferedImage im = new BufferedImage(256, 256, BufferedImage.TYPE_3BYTE_BGR);
		int pix = 0;
        for (int y = 255; y >= 0; y--)
        	for (int x = 255; x >= 0; x--)
        	{        		
        		//pix = 255+ (255*256) + (255*256*256) + (map[x][y]*256*256*256);
        		pix = map[x][y]+ (map[x][y]*256) + (map[x][y]*256*256);
        		//System.out.println(pix);
        		im.setRGB(x,y, pix);
        	}
        
        return im;
		
	}
	
	/**
	 * Converts the map to an array of bytes for saving purposes
	 * @return the byte array containing map data
	 */	
	public byte[] convertMapToByteArray()
	{		
		byte[] b = new byte[256*256];				
		
		for (int y = 255; y >= 0; y--)
		{
			for (int x = 0; x < 256; x++)
				b[(255-y)*256 + x] = (byte)map[x][y];			
		}
									
		return b;
	}
}
