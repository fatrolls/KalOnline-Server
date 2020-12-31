<?php
/**
 * Registration handling
 *
 * @author     Claus J?rgensen <thedeathart@gmail.com>
 * @category   Common
 * @package    Kalonline Registration
 * @copyright  Copyright (c) 2006 Claus J?rgensen (http://dragons-lair.org)
 * @license    MIT License
 */

include 'Password.php'; // password class
include 'Captcha.php';  // captcha class

session_start(); // required for captcha to work

// error reporting
error_reporting(E_ALL);
ini_set('display_errors','on');

// configuration
$config = array(
    'db_username' => 'sa', // database username
    'db_password' => '',   // database password
    'db_dsn'      => '',   // system DSN to the database
    'debug'       => false,               // show SQL errors if true
);

// HTML error
define('UI_ERROR','<span class="error">%s</span>');

// if we need to output a captcha
if(isset($_GET['captcha'])) {
    $captcha = new Captcha(120,40,6);
}

// if submitted
if(strtolower($_SERVER['REQUEST_METHOD']) == 'post') {
    $username = $_POST['username'];
    $password = $_POST['password'];
    $captcha  = $_POST['captcha'];

    $error = array();
    // validate username
    if(!ctype_alnum($username)) {
        $error['username'] = sprintf(UI_ERROR,'illegal characters in the username');
    }
    // validate password
    if(!ctype_alnum($password)) {
        $error['password'] = sprintf(UI_ERROR,'illegal characters in the password');
    }
    // validate captcha
    if($captcha != $_SESSION['captcha']) {
        $error['captcha']  = sprintf(UI_ERROR,'Wrong security code');
    }
    
    // no errors, continue to username check
    if(empty($error)) {
        // db connect
        $conn = odbc_connect($config['db_dsn'],
                             $config['db_username'],
                             $config['db_password']);
        // check about account name is taken
        $check = "SELECT
                      [ID] FROM [Login]
                  WHERE
                      [ID]='%s'
                  OR
                      [ID]='%s'
                  OR
                      [ID]='%s'
                  OR
                      [ID]='%s'
                  ";
        $check = sprintf($check,$username,
            strtolower($username),
            strtoupper($username),
            ucfirst($username)
        );
        $exec = odbc_exec($conn,$check);
        // check for errors
        if(!$exec && ($config['debug'] === true)) {
            echo odbc_errormsg($conn);
            die();
        }
        // is the account registered?
        $data = odbc_fetch_array($exec);
        if($data !== false) {
            $error['username'] = sprintf(UI_ERROR,'Account allready registered,
                                                   please choose another name');
        } else { // else continue
            // encode password
            $password = Password::encode($password);
            // prepare sql
            $sql = "INSERT INTO
                        [Login] ([ID],[PWD],[Birth],[Type],[ExpTime],[Info])
                    VALUES
                        ('".$username."',".$password.",'19190101',0,4000,0)
                    ";
            // insert user
            $result = odbc_exec($conn,$sql);
            if(!$result && ($config['debug'] === true)) {
                echo odbc_errormsg($conn);
                die();
            }
        }
    }
}

// display template
include ("./incls/registration.tpl");

?> 