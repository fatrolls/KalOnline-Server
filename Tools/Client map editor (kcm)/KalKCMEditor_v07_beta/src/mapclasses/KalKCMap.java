package mapclasses;

import java.io.BufferedOutputStream;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.EOFException;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;

import javax.imageio.ImageIO;
import javax.swing.JProgressBar;

import systems.CRC32Direct;

/**
 * Main class of the KCM file
 * 
 * Header structure:
 * 
 * length: 52B
 * 
 * byte 9 : n_XXX_... number
 * byte 13: n_..._XXX number
 * 
 * byte 38 - 45: if the byte != FF then there is a Texture map.
 * @author harph
 *
 */
public class KalKCMap 
{
	private static final int HEADER_LEN = 52;
	private File kcmFile;
	private byte[] header;
	
	private int texMapsNum;
	private int[] mapNumber;
	
	private KalKCMapTextureMap[] textureMaps;
	private KalKCMapHeightMap heightMap;
	private KalKCMapColorMap colorMap;
	private KalKCMapObjectMap objectMap;
	
	/**
	 * Loads the map from the given file
	 * @param filename
	 * @param progressBar
	 */
	public KalKCMap(String filename, JProgressBar progressBar)
	{
		kcmFile = new File(filename);
		header = new byte[HEADER_LEN];
		mapNumber = new int[2];
		texMapsNum = 0;	
		
		try
		{			
	        FileInputStream fdat = new FileInputStream(kcmFile);					
			DataInputStream indat = new DataInputStream(fdat);	            	
		
			System.out.println("reading file: "+kcmFile.getName());
			
			readHeader(indat);		
			
			mapNumber[0] = header[8];
			mapNumber[1] = header[12];						
			
			textureMaps = new KalKCMapTextureMap[7];
			
			for (int i = 0; i < 7; i++)
			{
				if (header[37+i] != -1)
				{				
		        	textureMaps[6-i] = new KalKCMapTextureMap(); 
		        	textureMaps[6-i].readMap(indat);					
					texMapsNum++;					
				}
			}
			
			progressBar.setValue(15);
									
    		heightMap = new KalKCMapHeightMap();
    		heightMap.readMap(indat);
			
    		progressBar.setValue(25);
    		
    		colorMap = new KalKCMapColorMap();
    		colorMap.readMap(indat);
    		
    		progressBar.setValue(35);
    		
    		objectMap = new KalKCMapObjectMap();
    		objectMap.readMap(indat);    		    		
			
    		System.out.println("finished reading");
    		
	        indat.close();
	        fdat.close();
			
		}
		catch (Exception e)
		{
			System.err.println("error by reading the file");
			e.printStackTrace();
			System.exit(1);
		}
		
	}
	
	/**
	 * Reads the header from the given stream
	 * @param indat
	 * @throws Exception
	 */
	void readHeader(DataInputStream indat) throws Exception
	{		
        try
        {
            for (int n = 0; n < HEADER_LEN; n++)
            {
            	header[n] = indat.readByte();	                	                	              
            }            
        }
        catch (EOFException e)
        {
        	
        }        		        
	}
	
	/**
	 * Gets the images from the kcm and exports them into the given directory. Uncomment
	 * what you want to export other map images too. Not in the editor itself, but a nice function.
	 * @param dir
	 * @throws Exception
	 */
	void exportImages(String dir) throws Exception
	{
		System.out.println("exporting images");
		BufferedOutputStream out;
		
		int i = 0;
		for (KalKCMapTextureMap um : textureMaps)
		{			
			if (um != null)
			{
				out = new BufferedOutputStream(new FileOutputStream(dir+"\\n_"+(mapNumber[0] > 100 ? mapNumber[0] : "0"+mapNumber[0])+"_"+(mapNumber[1] > 100 ? mapNumber[1] : "0"+mapNumber[1])+"_u"+i+".jpg"));
	    		ImageIO.write(um.convertMapToImage(), "jpg", out);         	
	    		out.close();
			}
    		i++;
		}
		
		
		out = new BufferedOutputStream(new FileOutputStream(dir+"\\n_"+(mapNumber[0] > 100 ? mapNumber[0] : "0"+mapNumber[0])+"_"+(mapNumber[1] > 100 ? mapNumber[1] : "0"+mapNumber[1])+"_s.bmp"));
		ImageIO.write(heightMap.convertMapToImage(), "bmp", out);         	
		out.close();					
		
		out = new BufferedOutputStream(new FileOutputStream(dir+"\\n_"+(mapNumber[0] > 100 ? mapNumber[0] : "0"+mapNumber[0])+"_"+(mapNumber[1] > 100 ? mapNumber[1] : "0"+mapNumber[1])+"_t.jpg"));
		ImageIO.write(colorMap.convertMapToImage(), "jpg", out);         	
		out.close();			
		
		out = new BufferedOutputStream(new FileOutputStream(dir+"\\n_"+(mapNumber[0] > 100 ? mapNumber[0] : "0"+mapNumber[0])+"_"+(mapNumber[1] > 100 ? mapNumber[1] : "0"+mapNumber[1])+"_o.jpg"));
		ImageIO.write(objectMap.convertMapToImage(), "jpg", out);         	
		out.close();			
		
		System.out.println("done");
	}
	

	/**
	 * Saves the map to the given path
	 * @param filename
	 * @throws IOException
	 */
	public void saveMap(String filename, JProgressBar progressBar) throws IOException
	{
		byte[] data = exportMapForSaving();
		
        FileOutputStream out = new FileOutputStream(filename);
	    DataOutputStream pd = new DataOutputStream(out);
	    
	    byte[] crc32 = intToByteArray((int)CRC32Direct.getCRC(data, 4, data.length-4));
	    
	    progressBar.setMaximum(data.length);
	    progressBar.setMinimum(0);
	    progressBar.setValue(0);
	    
	    for (int i = 3; i >= 0; i--)
	    {
	    	pd.write(crc32[i]);
	    	progressBar.setValue(i);
	    }
	    
	    for (int i = 4; i < data.length; i++)
	    {	    	
	    	pd.write(data[i]);
	    	progressBar.setValue(i);
	    }	    	    
	    
	    pd.close();
	    out.close();	    
	}
	
	/**
	 * Prepares the data for saving
	 * @return the map data in bytes
	 */
	public byte[] exportMapForSaving()
	{
		// number of bytes for the file
		int length = header.length +				// header 
					 texMapsNum*256*256 + 			// bytes for texture maps
					 257*257*2 +					// height map
					 256*256*3 +					// color map
					 256*256;						// object map
		
		byte[] bytes = new byte[length];
		
		int progress = 0;
		
		// writing header
		for (int i = 0; i < header.length; i++)
		{
			bytes[progress] = header[i];
			progress++;
		}
		
		// writing texture maps
		byte[] tmp = null;
		
		for (int u = 0; u < texMapsNum; u++)
		{
			tmp = textureMaps[6-u].convertMapToByteArray();
			for (int i = 0; i < tmp.length; i++)
			{
				bytes[progress] = tmp[i];
				progress++;
			}
		}
		
		// writing height map
		tmp = heightMap.convertMapToByteArray();
		for (int i = 0; i < tmp.length; i++)
		{
			bytes[progress] = tmp[i];
			progress++;
		}
		
		// writing color map
		tmp = colorMap.convertMapToByteArray();
		for (int i = 0; i < tmp.length; i++)
		{
			bytes[progress] = tmp[i];
			progress++;
		}
		
		// writing object map
		tmp = objectMap.convertMapToByteArray();
		for (int i = 0; i < tmp.length; i++)
		{
			bytes[progress] = tmp[i];
			progress++;
		}
		
		return bytes;
	}
	
	public KalKCMapHeightMap getHeightMap()
	{
		return heightMap;
	}
	
	public KalKCMapColorMap getColorMap()
	{
		return colorMap;
	}
	
	/**
	 * Converts an int to a byte array
	 * @param value
	 * @return the byte array
	 */
    public static byte[] intToByteArray(int value) 
    {
        byte[] b = new byte[4];
        for (int i = 0; i < 4; i++) {
            int offset = (b.length - 1 - i) * 8;
            b[i] = (byte) ((value >>> offset) & 0xFF);
        }
        return b;
    }
    
}
