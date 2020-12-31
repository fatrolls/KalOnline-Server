package mapclasses;
import java.awt.image.BufferedImage;
import java.io.DataInputStream;
import java.io.EOFException;

import javax.vecmath.Color3b;

/**
 * KCM Color map type
 * 
 * credit to BakaBug for specification ;>
 * @author harph
 *
 */
public class KalKCMapColorMap 
{
	private int[][][] map;
	
	public KalKCMapColorMap()
	{
		map = new int[256][256][3];
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
            		map[x][y][2] = indat.readUnsignedByte();
            		map[x][y][1] = indat.readUnsignedByte();
            		map[x][y][0] = indat.readUnsignedByte();
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
        		pix = (map[x][y][2]) + (map[x][y][1]*256) + (map[x][y][0]*256*256);        	
        		im.setRGB(x,y, pix);
        	}
        
        return im;
		
	}
	
	public int getRed(int x, int y)
	{
		return map[x][y][0];
	}
		
	public int getGreen(int x, int y)
	{
		return map[x][y][1];
	}

	public int getBlue(int x, int y)
	{
		return map[x][y][2];
	}
	
	public Color3b getColor(int x, int y)
	{
		try
		{
			return new Color3b((byte)getRed(x-1,y-1), (byte)getGreen(x-1,y-1), (byte)getBlue(x-1,y-1));
		}
		catch(ArrayIndexOutOfBoundsException e)
		{
			return new Color3b((byte)0,(byte)0,(byte)0);
		}
	
	}
	
	/**
	 * Converts the map to an array of bytes for saving purposes
	 * @return the byte array containing map data
	 */	
	public byte[] convertMapToByteArray()
	{		
		byte[] b = new byte[256*256*3];
		
		int ex = 0;
		
		for (int y = 255; y >= 0; y--)
		{
			ex = 0;
			for (int x = 0; x < 256*3; x+=3)
			{
				b[(255-y)*256*3 + x] = (byte)map[ex][y][2];
				b[(255-y)*256*3 + x+1] = (byte)map[ex][y][1];
				b[(255-y)*256*3 + x+2] = (byte)map[ex][y][0];
				ex++;
			}			
		}
									
		return b;
	}	
	
}
