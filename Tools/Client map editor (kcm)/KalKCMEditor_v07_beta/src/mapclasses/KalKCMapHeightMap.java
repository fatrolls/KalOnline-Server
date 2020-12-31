package mapclasses;
import java.awt.image.BufferedImage;
import java.io.DataInputStream;
import java.io.EOFException;

/**
 * KCM height map type
 * 
 * credit to BakaBug for specification ;>
 * @author harph
 *
 */
public class KalKCMapHeightMap 
{
	private int[][][] map;
	
	public KalKCMapHeightMap()
	{		
		map = new int[257][257][2];
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
            for (int y = 256; y >= 0; y--)
            	for (int x = 0; x <= 256; x++)  
            	{
            		map[x][y][0] = indat.readUnsignedByte();
            		map[x][y][1] = indat.readUnsignedByte();
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
		BufferedImage im = new BufferedImage(257, 257, BufferedImage.TYPE_3BYTE_BGR);
		int pix = 0;
        for (int y = 256; y >= 0; y--)
        	for (int x = 256; x >= 0; x--)
        	{        		
        		pix = ((map[x][y][0] + map[x][y][1])*256*256);        		
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
		byte[] b = new byte[257*257*2];
		
		int ex = 0;
		
		for (int y = 256; y >= 0; y--)
		{
			ex = 0;
			for (int x = 0; x < 257*2; x+=2)
			{
				b[(256-y)*257*2 + x] = (byte)map[ex][y][0];
				b[(256-y)*257*2 + x+1] = (byte)map[ex][y][1];
				ex++;
			}			
		}
									
		return b;
	}
	
	public int getHeight(int x, int y)
	{
		return ((map[x][y][0] + map[x][y][1]*256));
	}
		
	public void changeHeight(int x, int y, int height)
	{
		map[x][y][0] = height % 256;
		map[x][y][1] = (height - map[x][y][0])/256;				
	}
	
}
