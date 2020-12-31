package systems;

import javax.media.j3d.Geometry;
import javax.media.j3d.GeometryUpdater;
import javax.media.j3d.PointArray;
import javax.vecmath.Point3d;

/**
 * An updater that makes the point map up to date while selecting/changing.
 * @author harph
 *
 */
public class PointUpdater implements GeometryUpdater
{
	boolean changing;
	
	public PointUpdater(boolean changing)
	{
		this.changing = changing;
	}
	
	public void updateData(Geometry arg0) 
	{						
		PointArray trs = (PointArray) arg0;			
					
		float coords[] = trs.getCoordRefFloat();
		
		byte colors[] = trs.getColorRefByte();
		
		for (int i = 0; i < colors.length; i+=3)
		{
			if (colors[i] == (byte)255)
			{
				colors[i] = 0;
				colors[i+1] = (byte) 255;
			}
			
			for (Point3d p : KalKCMEditor.window.selectedPoints)
			{				
				if ((coords[i] == p.x) && (coords[i+1] == p.y))
				{
					if (changing)
					{
						//System.out.println("[debug] point found, updating height");
						coords[i+2] = (KalKCMEditor.window.map.getHeightMap().getHeight((int)(p.x-KalKCMEditor.window.shiftX), Math.abs((int)(p.y-KalKCMEditor.window.shiftY)))+1)*KalKCMEditor.window.heightscale;
					}
						
					//System.out.println("[debug] coloring point");
					colors[i] = (byte) 255;
					colors[i+1] = 0;
				}
			}

		}
		
		//trs.setCoordRefFloat(coords);	
		//trs.setColorRefByte(colors);
	}
	
}	
