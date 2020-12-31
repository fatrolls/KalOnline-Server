package systems;

import java.io.IOException;

import javax.swing.JDialog;
import javax.swing.JProgressBar;
import javax.swing.WindowConstants;

/**
 * A window for saving
 * @author harph
 *
 */
public class SavingWindow extends JDialog implements Runnable
{
	JProgressBar progressBar;
	KalKCMEditor owner;
	String file;
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/**
	 * Create the dialog
	 */
	public SavingWindow(KalKCMEditor owner, String file) 
	{		
		super(owner.frame, false);
		this.owner = owner;		
		getContentPane().setLayout(null);
		setResizable(false);
		setAlwaysOnTop(false);
		setDefaultCloseOperation(WindowConstants.DISPOSE_ON_CLOSE);
		setName("SaveFileDialog");
		setTitle("Saving...");		
		
		this.file = file;
		
		setBounds(owner.frame.getBounds().x+150, owner.frame.getBounds().y+200, 600, 72);
	}

	public void run() 
	{
		owner.disableAllButtons();
		progressBar = new JProgressBar();
		progressBar.setBounds(10, 10, 574, 26);
		getContentPane().add(progressBar);

		setVisible(true);
		progressBar.setValue(0);
		progressBar.setStringPainted(true);

		try {
			owner.map.saveMap(file, progressBar);
		} catch (IOException e) {
			System.out.println("problem with saving!");
			e.printStackTrace();
		}
		
		setVisible(false);
		owner.enableAllButtons();				
		
	}

}
