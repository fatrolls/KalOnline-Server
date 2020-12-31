<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
  <head>
    <title> Account Registration </title>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <style type="text/css">
      body {
          font-family: verdana;
          font-size: 11px;
      }

      label {
          font-weight: bold;
      }

      .error {
          color: red;
      }
      
      .ok {
          color: green;
      }

    </style>
  </head>
  <body>
    <form action="" method="post">
      <fieldset>
        <legend>Account Registration</legend>
        <?php if(!@$result): ?>
          <label for="username">Username</label><br>
          <input type="text" name="username" value="<?php echo @$_POST['username']; ?>">
          <?php echo @$error['username']; ?>
          <br><br>
          <label for="password">Password</label><br>
          <input type="password" name="password"> 
          <?php echo @$error['password']; ?>
          <br><br>
          <img src="index.php?captcha=<?php echo time(); ?>" alt="Security Code">
          <br><br>
          <label for="captcha">Security code</label><br>
          <input type="text" name="captcha"> 
          <?php echo @$error['captcha']; ?>
          <br><br>
          <input type="submit" value="Create">
        <?php endif; ?>  
        <?php if(@$result): ?>
          <div class="ok">Account successfully registred</div>
        <?php endif; ?>
      </fieldset>
    </form>
  </body>
</html>