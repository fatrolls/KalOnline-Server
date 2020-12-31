package systems;
import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.GraphicsConfiguration;
import java.awt.Insets;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.io.File;
import java.util.ArrayList;

import javax.media.j3d.Appearance;
import javax.media.j3d.BoundingSphere;
import javax.media.j3d.BranchGroup;
import javax.media.j3d.Canvas3D;
import javax.media.j3d.Geometry;
import javax.media.j3d.GeometryUpdater;
import javax.media.j3d.Material;
import javax.media.j3d.PointArray;
import javax.media.j3d.PointAttributes;
import javax.media.j3d.Shape3D;
import javax.media.j3d.Transform3D;
import javax.media.j3d.TransformGroup;
import javax.media.j3d.TriangleStripArray;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JSpinner;
import javax.swing.JSplitPane;
import javax.swing.JTextField;
import javax.swing.JToolBar;
import javax.swing.SpinnerNumberModel;
import javax.swing.filechooser.FileFilter;
import javax.vecmath.Color3f;
import javax.vecmath.Point3d;
import javax.vecmath.Vector3d;
import javax.vecmath.Vector3f;

import mapclasses.KalKCMap;

import com.sun.j3d.utils.behaviors.mouse.MouseRotate;
import com.sun.j3d.utils.behaviors.mouse.MouseTranslate;
import com.sun.j3d.utils.behaviors.mouse.MouseWheelZoom;
import com.sun.j3d.utils.picking.PickCanvas;
import com.sun.j3d.utils.picking.PickIntersection;
import com.sun.j3d.utils.picking.PickResult;
import com.sun.j3d.utils.universe.SimpleUniverse;

/**
 * Main Class for the viewer. Contains the window and GUI/3D related stuff.
 * @author harph
 *
 */
public class KalKCMEditor
{
	private JSpinner heightSpinner;
	/**
	 * teh title ;p
	 */
	String title = "Kal KCM Editor 0.7 BETA";
	
	private JButton PlusHeightButton;
	private JButton MinusHeightButton;
	private JButton saveButton;
	private JButton openButton;
	static KalKCMEditor window;
	
	SpinnerNumberModel heightSpinnerModel;
	
	private JTextField heightField;
	JFrame frame;
	Canvas3D canvas3D;
	KalKCMap map;
	BranchGroup scene;
	PickCanvas pickCanvas;
	JSplitPane splitPane;	
	
	SimpleUniverse simpleU;
	GraphicsConfiguration config;
	JButton picbutton01;
	JFileChooser fc;
	
	TriangleStripArray ts;
	PointArray pa;	
		
	BranchGroup objRoot;
	
	MouseRotateExt myMouseRotate;
	MouseTranslate myMouseTranslate;
	MouseWheelZoom myMouseWheelZoom;
	
	int selectedX = 0;
	int selectedY = 0;
	int selectedHeight = 0;
	
	ArrayList<Point3d> selectedPoints;
	
	int shiftX;
	int shiftY;
	float heightscale;
		
	/**
	 * Launch the application
	 * @param args
	 */
	public static void main(String args[]) {
		try {
			window = new KalKCMEditor();
			window.frame.setVisible(true);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * Create the application
	 */
	public KalKCMEditor() {
		initialize();
		disableAllButtons();
		getOpenButton().setEnabled(true);		
	}

	void disableAllButtons()
	{
		getOpenButton().setEnabled(false);
		getSaveButton().setEnabled(false);
		getPlusHeightButton().setEnabled(false);
		getMinusHeightButton().setEnabled(false);
		heightField.setEnabled(false);
	}
	
	void enableAllButtons()
	{
		getOpenButton().setEnabled(true);
		getSaveButton().setEnabled(true);
		getPlusHeightButton().setEnabled(true);
		getMinusHeightButton().setEnabled(true);	
		heightField.setEnabled(true);
	}
	
	/**
	 * Initialize the contents of the frame
	 */
	private void initialize() {
		frame = new JFrame();
		frame.setTitle(title);
		frame.setBounds(100, 100, 800, 600);
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
						
		fc = new JFileChooser();
		fc.setFileFilter(new KCMFilter());
		
        config = SimpleUniverse.getPreferredConfiguration();

		splitPane = new JSplitPane();
		splitPane.setOneTouchExpandable(true);
		splitPane.setDividerLocation(600);
		splitPane.setContinuousLayout(true);
		frame.getContentPane().add(splitPane);

		final JPanel panel = new JPanel();
		panel.setLayout(null);
		panel.setPreferredSize(new Dimension(200, 0));
		splitPane.setRightComponent(panel);		

		picbutton01 = new JButton();
		picbutton01.setBounds(22, 5, 130, 130);
		picbutton01.setPreferredSize(new Dimension(130, 130));
		picbutton01.setMargin(new Insets(1, 1, 1, 1));
		picbutton01.setBorderPainted(false);
		panel.add(picbutton01);

		heightField = new JTextField();
		heightField.addKeyListener(new KeyAdapter() {
			public void keyPressed(KeyEvent e) {
				if (e.getKeyCode() == KeyEvent.VK_ENTER)
				{
					try
					{
						for (Point3d p : selectedPoints)
						{					
							map.getHeightMap().changeHeight((int)(p.x-shiftX), Math.abs((int)(p.y-shiftY)), new Integer(heightField.getText()).intValue());
						}
						
						try
						{
							ts.updateData(new MapUpdater());
							pa.updateData(new PointUpdater(true));
						}
						catch(NullPointerException e1)
						{}
						
					}
					catch(NumberFormatException e1)
					{
						
					}										
				}
			}
		});
		heightField.setBounds(56, 181, 72, 20);
		panel.add(heightField);

		MinusHeightButton = new JButton();

		/** MINUS BUTTON **/		
		MinusHeightButton.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				for (Point3d p : selectedPoints)
				{					
					map.getHeightMap().changeHeight((int)(p.x-shiftX), Math.abs((int)(p.y-shiftY)), map.getHeightMap().getHeight((int)(p.x-shiftX), Math.abs((int)(p.y-shiftY)))- heightSpinnerModel.getNumber().intValue());
				}
				
				selectedHeight -= heightSpinnerModel.getNumber().intValue();
				getHeightField().setText(""+selectedHeight);
				
				try
				{
					ts.updateData(new MapUpdater());
					pa.updateData(new PointUpdater(true));
				}
				catch(NullPointerException e1)
				{}

			}
		});		
		MinusHeightButton.setMargin(new Insets(2, 1, 2, 1));
		MinusHeightButton.setText("-");
		MinusHeightButton.setBounds(22, 182, 26, 19);
		panel.add(MinusHeightButton);

		PlusHeightButton = new JButton();
		
		/** PLUS BUTTON **/
		PlusHeightButton.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				for (Point3d p : selectedPoints)
				{					
					map.getHeightMap().changeHeight((int)(p.x-shiftX), Math.abs((int)(p.y-shiftY)), map.getHeightMap().getHeight((int)(p.x-shiftX), Math.abs((int)(p.y-shiftY)))+ heightSpinnerModel.getNumber().intValue());
				}				
				//map.getHeightMap().changeHeight(selectedX, selectedY, selectedHeight+10);
				selectedHeight += heightSpinnerModel.getNumber().intValue();
				getHeightField().setText(""+selectedHeight);
				
				try
				{
					ts.updateData(new MapUpdater());
					pa.updateData(new PointUpdater(true));
				}
				catch(NullPointerException e1)
				{}
			}
		});
		PlusHeightButton.setMargin(new Insets(2, 1, 2, 1));
		PlusHeightButton.setText("+");
		PlusHeightButton.setBounds(134, 182, 26, 19);
		panel.add(PlusHeightButton);

		final JLabel heightLabel = new JLabel();
		heightLabel.setText("Height");
		heightLabel.setBounds(67, 157, 72, 14);
		panel.add(heightLabel);

		heightSpinnerModel = new SpinnerNumberModel(10, 1, 500, 1);
		heightSpinner = new JSpinner(heightSpinnerModel);		
		heightSpinner.setBounds(56, 207, 72, 18);
		panel.add(heightSpinner);

		final JPanel panel_1 = new JPanel();
		splitPane.setLeftComponent(panel_1);
		
		final JToolBar toolBar = new JToolBar();
		toolBar.setFloatable(false);
		toolBar.setPreferredSize(new Dimension(0, 25));
		frame.getContentPane().add(toolBar, BorderLayout.NORTH);

		toolBar.addSeparator();

		openButton = new JButton();
		
		/** OPEN BUTTON **/
		openButton.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) 
			{				
				int returnVal = fc.showOpenDialog(frame);
				
				if (returnVal == JFileChooser.APPROVE_OPTION) 
				{
					LoadingWindow lw = new LoadingWindow(window);
					new Thread(lw).start();
				}				
			}
		});
		openButton.setText("Open");
		toolBar.add(openButton);

		saveButton = new JButton();
		
		/** SAVE BUTTON **/
		saveButton.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				int returnVal = fc.showSaveDialog(frame);
				
				if (returnVal == JFileChooser.APPROVE_OPTION)
				{					
					SavingWindow sw = new SavingWindow(window, fc.getSelectedFile().getAbsolutePath());					
					new Thread(sw).start();					
				}
			}
		});
		saveButton.setText("Save As");
		toolBar.add(saveButton);
		
	}
	
	/**
	 * Creates the scene graph on loading the map.
	 * @param su
	 * @return the BranchGroup object
	 */
    public BranchGroup createSceneGraph(SimpleUniverse su) 
    {    	    	
    	// Create the root of the branch graph
    	objRoot = new BranchGroup();
    	
    	Transform3D transform = new Transform3D();    	
    	
    	Transform3D rotate = new Transform3D();
       	rotate.rotX(-Math.PI/4.0d);

       	Transform3D translate = new Transform3D();
       	Vector3f tvector = new Vector3f();
       	
       	// translation
       	tvector.set(0,0,-30);
       	translate.setTranslation(tvector);
       	
       	// scale
    	Transform3D scale = new Transform3D();
    	scale.set(0.08d);
    	
    	transform.mul(translate);
    	transform.mul(scale);
    	
        TransformGroup objMap = new TransformGroup(transform);
        objMap.setCapability(TransformGroup.ALLOW_TRANSFORM_WRITE);
        objMap.setCapability(TransformGroup.ALLOW_TRANSFORM_READ);
        objMap.setCapability(TransformGroup.ENABLE_PICK_REPORTING);
               
        
        objRoot.addChild(objMap);  
        
		byte colors[] = new byte[12];		
		float coords[] = new float[12];
    	
        myMouseRotate = new MouseRotateExt(this);
        myMouseRotate.setTransformGroup(objMap);
        myMouseRotate.setSchedulingBounds(new BoundingSphere());
        objRoot.addChild(myMouseRotate);  
        
        myMouseTranslate = new MouseTranslate();
        myMouseTranslate.setTransformGroup(objMap);
        myMouseTranslate.setSchedulingBounds(new BoundingSphere());
        objRoot.addChild(myMouseTranslate);
        
        myMouseWheelZoom = new MouseWheelZoom();
        myMouseWheelZoom.setTransformGroup(objMap);
        myMouseWheelZoom.setSchedulingBounds(new BoundingSphere());
        objRoot.addChild(myMouseWheelZoom);
        
        pickCanvas = new PickCanvas(canvas3D, objRoot);
        pickCanvas.setMode(PickCanvas.BOUNDS);
        canvas3D.addMouseListener(new PickListener());         
                 	
    	heightscale = 0.04f;
    	shiftX = -140;
    	shiftY = 130;
    	  	
    	int svc[] = new int[255];

    	for (int i = 0; i < 255; i++)
    	{
    		svc[i] = 256*2;    		
    	}    	    	    	        	    	
    	
    	ts = new TriangleStripArray(256*256*2, TriangleStripArray.COORDINATES | TriangleStripArray.COLOR_3 | TriangleStripArray.BY_REFERENCE, svc);
    	
    	ts.setCapability(TriangleStripArray.ALLOW_FORMAT_READ);
    	ts.setCapability(TriangleStripArray.ALLOW_COUNT_READ);
    	ts.setCapability(TriangleStripArray.ALLOW_COORDINATE_READ);
    	ts.setCapability(TriangleStripArray.ALLOW_COLOR_READ); 
    	ts.setCapability(TriangleStripArray.ALLOW_COORDINATE_WRITE);
    	ts.setCapability(TriangleStripArray.ALLOW_REF_DATA_WRITE);
    	ts.setCapability(TriangleStripArray.ALLOW_REF_DATA_READ);
    	
    	int xRen = 0;
    	int yRen = 0;
    	int xMap = 0;
    	int yMap = 0;   
   	
    	coords = new float[256*256*2*3];
    	colors = new byte[256*256*2*3]; 
//    	float texcoords[] = new float[256*256*2*2];
//    	boolean ev = true;
    	
    	for (int s = 0; s < 255; s++)
    	{
    		for (int v = 0; v < 256*2*3; v+=3)
    		{
    			if ((v % 2) == 0)
    			{    				
    				coords[s*256*2*3 + v] = shiftX+xRen;
    				coords[s*256*2*3 + v+1] = shiftY+yRen;
    				coords[s*256*2*3 + v+2] = map.getHeightMap().getHeight(xMap,yMap)*heightscale;
    				
    				colors[s*256*2*3 + v] = map.getColorMap().getColor(xMap,yMap).x;
    				colors[s*256*2*3 + v+1] = map.getColorMap().getColor(xMap,yMap).y;
    				colors[s*256*2*3 + v+2] = map.getColorMap().getColor(xMap,yMap).z;
    				
//    				if (ev)
//    				{
//    					texcoords[s*256*2*2 + v] = 0;
//    					texcoords[s*256*2*2 + v+1] = 1;    					
//    				}
//    				else
//    				{
//    					texcoords[s*256*2*2 + v] = 1;
//    					texcoords[s*256*2*2 + v+1] = 1;     					
//    				}
    			}
    			else
    			{
    				coords[s*256*2*3 + v] = shiftX+xRen;
    				coords[s*256*2*3 + v+1] = shiftY+yRen-1;
    				coords[s*256*2*3 + v+2] = map.getHeightMap().getHeight(xMap,yMap+1)*heightscale;    				
    				
    				colors[s*256*2*3 + v] = map.getColorMap().getColor(xMap,yMap+1).x;
    				colors[s*256*2*3 + v+1] = map.getColorMap().getColor(xMap,yMap+1).y;
    				colors[s*256*2*3 + v+2] = map.getColorMap().getColor(xMap,yMap+1).z;
    				    	
//    				if (ev)
//    				{
//    					texcoords[s*256*2*2 + v] = 0;
//    					texcoords[s*256*2*2 + v+1] = 0; 
//    					ev = false;
//    				}
//    				else
//    				{
//    					texcoords[s*256*2*2 + v] = 1;
//    					texcoords[s*256*2*2 + v+1] = 0;   
//    					ev = true;
//    				}
//    				
        			xRen++;
        			xMap++;
    			}    			
    		}    		    		
    		
    		yRen--;
    		yMap++;
    		xRen = 0;
    		xMap = 0;
    	}
    	 	
    	ts.setCoordRefFloat(coords);  
    	ts.setColorRefByte(colors);
//    	ts.setTexCoordRefFloat(0, texcoords);
    	
    	Appearance mapApp = new Appearance();
    	Material mat = new Material();
    	mat.setAmbientColor(new Color3f(0.1f,0.1f,0.1f));
    	mat.setDiffuseColor(new Color3f(0.7f,0.7f,0.7f));
    	mat.setSpecularColor(new Color3f(0.7f,0.7f,0.7f));
    	mapApp.setMaterial(mat);
    	
//    	Toolkit toolkit = Toolkit.getDefaultToolkit();
//    	Image tex = toolkit.getImage("textures/b_002.jpg");
    	
//    	Texture texImage = new TextureLoader("textures/b_002.jpg", null).getTexture();    
//    	mapApp.setTexture(texImage);
//    	TextureAttributes ta = new TextureAttributes();
//    	ta.setTextureMode(TextureAttributes.BLEND);
//    	mapApp.setTextureAttributes(ta);
    	
    	Shape3D map3d = new Shape3D(ts, mapApp);
    	map3d.setPickable(true);
    	
    	objMap.addChild(map3d);
    	
    	// POINT ARRAY
    	
	    pa = new PointArray(256*256, PointArray.COORDINATES | PointArray.COLOR_3 | PointArray.BY_REFERENCE);
	    
    	pa.setCapability(TriangleStripArray.ALLOW_FORMAT_READ);
    	pa.setCapability(TriangleStripArray.ALLOW_COUNT_READ);
    	pa.setCapability(TriangleStripArray.ALLOW_COORDINATE_READ);
    	pa.setCapability(TriangleStripArray.ALLOW_COLOR_READ); 
    	pa.setCapability(TriangleStripArray.ALLOW_COORDINATE_WRITE);
    	pa.setCapability(TriangleStripArray.ALLOW_REF_DATA_WRITE);
    	pa.setCapability(TriangleStripArray.ALLOW_REF_DATA_READ);
	    
	    Appearance paApp = new Appearance();
	    PointAttributes paAttr = new PointAttributes();
	    paAttr.setPointSize(1);
	    paApp.setPointAttributes(paAttr);
	    
    	coords = new float[256*256*3];
    	colors = new byte[256*256*3]; 
    	
    	xRen = 0;
    	yRen = 0;
    	xMap = 0;
    	yMap = 0;   
    	
    	for (int y = 0; y < 256; y++)
    	{
    		for (int x = 0; x < 256*3; x+=3)
    		{
    			coords[256*3*y + x] = shiftX+xRen;
    			coords[256*3*y + x+1] = shiftY+yRen;
    			coords[256*3*y + x+2] = (map.getHeightMap().getHeight(xMap,yMap)+1)*heightscale;
    			
    			colors[256*3*y + x] = 0;
    			colors[256*3*y + x+1] = (byte)255;
    			colors[256*3*y + x+2] = 0;
    			
    			xRen++;
    			xMap++;
    		}
    		
    		yRen--;
    		yMap++;
    		xRen = 0;
    		xMap = 0;    		
    	}
    	    	  
    	pa.setCoordRefFloat(coords);
    	pa.setColorRefByte(colors);
    	
    	Shape3D paShape = new Shape3D(pa, paApp);
    	paShape.setPickable(false);
    	
    	objMap.addChild(paShape);        	
    	
    	return objRoot;
    } 
    
    /**
     * Filter for *.kcm files
     * 
     * @author harph
     *
     */
    class KCMFilter extends FileFilter
    {
    	public boolean accept(File arg0) 
    	{
    		if (arg0 == null)
    			return false;
    		
    		if (arg0.isDirectory())
    			return true;
    		
    		String ext = getExtension(arg0);
    		
    		if (ext == null)
    			return false;
    		
    		if (ext.equalsIgnoreCase("kcm"))
    			return true;
    		
    		return false;
    	}
		
		public String getDescription() 
		{
			return "Kal Client Map";
		}
    	
		/*
	     * Get the extension of a file.
	     */  
	    public String getExtension(File f) 
	    {
	        String ext = null;
	        String s = f.getName();
	        int i = s.lastIndexOf('.');

	        if (i > 0 &&  i < s.length() - 1) {
	            ext = s.substring(i+1).toLowerCase();
	        }
	        return ext;
	    }		
    }
    
    /**
     * Listens for mouse clicks on the Canvas and checks for vertex picks
     * @author harph
     *
     */
    class PickListener extends MouseAdapter
    {
    	public void mouseClicked(MouseEvent e)
    	{
    		pickCanvas.setShapeLocation(e);
    		PickResult result = pickCanvas.pickClosest();
    		
    		if (result == null)
    		{
    			System.out.println("not picked");
    		}
    		else
    		{
    			try
    			{
	    			PickIntersection pi = result.getIntersection(0);	    			
	    			
	    			Point3d selectedPoint = new Point3d();
	    			selectedPoint = pi.getClosestVertexCoordinates();
	    			
	    			selectedPoint = new Point3d(selectedPoint.x, selectedPoint.y, map.getHeightMap().getHeight((int)(selectedPoint.x-shiftX), Math.abs((int)(selectedPoint.y-shiftY))));
	    			
	    			if (e.isControlDown())
	    			{
	    				if (!checkIfPicked(selectedPoint))
	    				{
	    					selectedPoints.add(selectedPoint);
	    					//System.out.println("ctrl mode - adding");
	    				}
	    				else selectedPoints.remove(selectedPoint);
	    			}
	    			else
	    			{
	    				selectedPoints.clear();
	    				selectedPoints.add(0, selectedPoint);
	    			}
	    			
	    			myMouseRotate.setCustomTranslate(new Vector3d(selectedPoint.x, selectedPoint.y, selectedPoint.z));	    			
	    			
	    			//System.out.println("cords: "+(selectedPoint.x-shiftX)+" "+(-(selectedPoint.y-shiftY))+" "+(selectedPoint.z/heightscale));
	    				    			
	    			selectedX = (int)(selectedPoint.x-shiftX);
	    			selectedY = Math.abs((int)(selectedPoint.y-shiftY));
	    			selectedHeight = map.getHeightMap().getHeight(selectedX, selectedY);
	    			
	    			getHeightField().setText(""+selectedHeight);	
	    			
	    			pa.updateData(new PointUpdater(false));
	    			
    			}
    			catch(IndexOutOfBoundsException ex)
    			{
    				
    			}
    		}
    	}   
    	    	
    }
    
	public JTextField getHeightField() {
		return heightField;
	}
    
	public boolean checkIfPicked(Point3d point)
	{
		for (Point3d p : selectedPoints)
		{
			if (p.equals(point))
				return true;
		}
		
		return false;
	}
	
	/**
	 * An updater for the map when you change the height, so you can see the changes in realtime.
	 * @author harph
	 *
	 */
	class MapUpdater implements GeometryUpdater
	{

		public void updateData(Geometry arg0) 
		{						
			TriangleStripArray trs = (TriangleStripArray) arg0;
			
			float coords[] = trs.getCoordRefFloat();
			
			for (int i = 0; i < coords.length; i+=3)
			{
				for (Point3d p : selectedPoints)
				{
					if ((coords[i] == p.x) && (coords[i+1] == p.y))
					{
						//System.out.println("vertex found, updating height");
						coords[i+2] = map.getHeightMap().getHeight((int)(p.x-shiftX), Math.abs((int)(p.y-shiftY)))*heightscale;
					}
				}
			}
			
			//trs.setCoordRefFloat(coords);								
		}
		
	}
	

	
	public JButton getOpenButton() {
		return openButton;
	}
	public JButton getSaveButton() {
		return saveButton;
	}
	public JButton getMinusHeightButton() {
		return MinusHeightButton;
	}
	public JButton getPlusHeightButton() {
		return PlusHeightButton;
	}
	
}
