package systems;

import java.awt.Dimension;
import java.util.ArrayList;

import javax.media.j3d.BranchGroup;
import javax.media.j3d.Canvas3D;
import javax.swing.ImageIcon;
import javax.swing.JDialog;
import javax.swing.JProgressBar;
import javax.swing.WindowConstants;
import javax.vecmath.Point3d;

import com.sun.j3d.utils.universe.SimpleUniverse;

import mapclasses.KalKCMap;

/**
 * A window for loading
 * @author harph
 *
 */
public class LoadingWindow extends JDialog implements Runnable
{
	JProgressBar progressBar;
	KalKCMEditor owner;
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/**
	 * Create the dialog
	 */
	public LoadingWindow(KalKCMEditor owner) 
	{		
		super(owner.frame, false);
		this.owner = owner;		
		getContentPane().setLayout(null);
		setResizable(false);
		setAlwaysOnTop(false);
		setDefaultCloseOperation(WindowConstants.DISPOSE_ON_CLOSE);
		setName("LoadFileDialog");
		setTitle("Loading...");		
		
		setBounds(owner.frame.getBounds().x+150, owner.frame.getBounds().y+200, 600, 72);
	}

	public void run() 
	{
		owner.disableAllButtons();
		progressBar = new JProgressBar(0, 100);
		progressBar.setBounds(10, 10, 574, 26);
		getContentPane().add(progressBar);

		setVisible(true);
		progressBar.setValue(0);
		progressBar.setStringPainted(true);
		
		owner.map = new KalKCMap(owner.fc.getSelectedFile().getAbsolutePath(), progressBar);
        
		progressBar.setValue(40);
		
		owner.canvas3D = new Canvas3D(owner.config);
		owner.canvas3D.setPreferredSize(new Dimension(800,0));		
        
		progressBar.setValue(50);
		
        // SimpleUniverse is a Convenience Utility class					
		owner.simpleU = new SimpleUniverse(owner.canvas3D);
		
		owner.scene = owner.createSceneGraph(owner.simpleU);		
		owner.scene.setCapability(BranchGroup.ALLOW_CHILDREN_EXTEND);
		owner.scene.setCapability(BranchGroup.ALLOW_CHILDREN_WRITE);
		
		progressBar.setValue(80);
		
        // This will move the ViewPlatform back a bit so the
        // objects in the scene can be viewed.
		owner.simpleU.getViewingPlatform().setNominalViewingTransform();

		owner.simpleU.addBranchGraph(owner.scene);
        
		owner.selectedPoints = new ArrayList<Point3d>();
		
        progressBar.setValue(100);			        
		
        owner.splitPane.setLeftComponent(owner.canvas3D);
        owner.picbutton01.setIcon(new ImageIcon(owner.map.getColorMap().convertMapToImage().getScaledInstance(130, 130, 0)));
        
        setVisible(false);
        
        owner.frame.setTitle(owner.title+" - "+owner.fc.getSelectedFile().getName());
        owner.enableAllButtons();
		
	}

}
