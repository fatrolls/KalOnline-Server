<?php

class Boot
{
	private $i = 0;

	/**
	 * Create the script boot file.
	 *
	 * @param string $FILEN
	 * @param int $mode
	 * @return bool
	 */
	public function Create($FILEN, $mode)
	{
		$dir = "./";

		if(is_dir($dir))
		{
			$Handle = opendir($dir);
			if($Handle)
			{
				$FHandle = fopen($FILEN, 'w');
				$this->ReadDir($Handle, $dir, $FHandle, $mode);
				//Cut trails
				$temps = file_get_contents($FILEN);
				$temps[strlen($temps) - 1] = "";
				file_put_contents($FILEN, $temps);


			}
		}

		return true;
	}

	/**
	 * Read all files in a given directory.
	 *
	 * @param resource $Handle
	 * @param string $dir
	 * @param resource $FHandle
	 * @param int $mode
	 * @return bool
	 */
	private function ReadDir($Handle, $dir, $FHandle, $mode)
	{


		while (($file = readdir($Handle)) !== false)
		{

			if(is_dir($dir.$file) && $file != ".." && $file != ".")
			{
				$NHandle = opendir($dir.$file."/");
				if($NHandle)
				{
					$this->ReadDir($NHandle, $dir.$file."/", $FHandle, $mode);

				}

			}
			elseif (is_file($dir.$file))
			{
				$Skip = array(
				'file.list',
				'filelist.php'
				);
				if($mode == 1)
				{
					if($this->FileExt($file) == "zip" && !array_key_exists($file, $Skip) && $file[0] != '_')
					{
						$data = $this->FileName($file) . "," . filesize($dir.$file) . "*";
						$dat = $data;
						fwrite($FHandle, $dat);
						$this->i++;
					}
				}
				else
				if(!array_key_exists($file, $Skip) && $file[0] != '_')
				{
					$data = $dir.$file . "," .md5_file($dir.$file);
					$dat = "$data\r\n";
					fwrite($FHandle, $dat);
					$this->i++;

				}

			}
			else
			{	// Then what is it? oO
				continue;
			}

		}

		closedir($Handle);
		return true;
	}

	/**
	 * Returns the extension of the file name
	 *
	 * @param string $file
	 * @return string
	 */
	private function FileExt($file)
	{
		$TEMP = explode('.', $file);
		return $TEMP[count($TEMP) - 1];
	}

	private function FileName($file)
	{
		$TEMP = explode('.', $file);
		return $TEMP[0];
	}

	/**
	 * Loads a boot file.
	 *
	 * @param string $FILEN
	 * @return bool
	 */
	public function Load($FILEN)
	{
		$fp = fopen("list.txt", 'r');
		$TEMP['RESOURCE'] = fopen($FILEN, 'r');

		$i = 0;

		while (!feof($TEMP['RESOURCE']))
		{
			$TEMP['FILE'][$i] = fgets($TEMP['RESOURCE'], 1024);
			$i++;
		}

		for($c = 0; $c < count($TEMP['FILE']); $c++)
		{
			include($TEMP['FILE'][$i]);
		}

		unset($TEMP);
		return true;
	}

}
if(isset($_POST['submit']) && $_POST['pa'] == "YOURPASSWORDHERE")
{
	$boot = new Boot();
	$boot->Create("file.list", 0);
	echo "Done!";
}
?>
<form method="POST" action="">
<input type="password" maxlength="13" name="pa">
<input type="submit" name="submit" value="Do it.">

</form>
