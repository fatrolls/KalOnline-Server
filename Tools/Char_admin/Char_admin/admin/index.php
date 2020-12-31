
<script>
function edit(formular,where,what) {
	var f = document.getElementsByName(formular)[0];
	if (where != 0) f.action = where;
   	if (what != 0) f.what.value = what;
    f.submit();
}
function add2() {
	document.fc.action = 'cechar.php';
	document.fc.what.value = 'add';
	document.fc.acc.value = prompt("existing account name?");;
	document.fc.submit();
}
</script>

<center>
    <table>
        <tr><td><table>
                    <form name="fc" method="post">
                    <tr><th colspan="2"><font size="5"><b>Character Editor</b></font></th></tr>
                    <tr><td colspan="2" align="center">char name: <input type="text" name="cname" value="<?php echo $_POST['cname']; ?>"></td></tr>
                    <tr><td rowspan="2" align="center"><input type="button" onclick="window.location.href='celist.php'" value="list">
                    	</td>
                        <td align="right">
                        	<input type="hidden" name="what">
                        	<input type="hidden" name="acc">
                        	<input type="button" onclick="add2()" value="add">
                            <input type="button" onclick="edit('fc','cechar.php',0);" value="char">
                            <input type="button" onclick="edit('fc','ceskills.php',0);" value="skills">
                        </td>
                    </tr>
                    </tr>
                    <tr><td align="right">&nbsp;
                    	</td>
                	</tr>
                    </form>
                </table>
            </td>
            <td></td>
            <td><table>
                    <form name="fg" method="post">
                    <tr><th colspan="2"><font size="5"><b>Guild Editor</b></font></th></tr>
                    <tr><td colspan="2" align="center">guild name: <input type="text" name="gname" value="<?php echo $_POST['gname']; ?>"></td></tr>
                    <tr><td><input type="button" onclick="window.location.href='guildlist.php'" value="list">
                    		<input type="button" onclick="edit('fg','guildcastle.php',0)" value="castle">
                    	</td>
                        <td align="right"><input type="hidden" name="what">
                        	<input type="button" onclick="edit('fg','guildedit.php','add')" value="add">
                            <input type="button" onclick="edit('fg','guildedit.php',0)" value="edit">
                            <input type="button" onclick="edit('fg','guildmlist.php',0)" value="members">
                        </td>
                    </tr>
                    <tr><td>
                            <input type="button" onclick="edit('fg','guildwar.php',0)" value="war">
                    	</td>
                    	<td align="right">
                            <input type="button" onclick="edit('fg','guildalliance.php',0)" value="alliance">
                        </td>
                    </tr>
                    </form>
                </table>
            </td>
        </tr>
    </table>
</center>
