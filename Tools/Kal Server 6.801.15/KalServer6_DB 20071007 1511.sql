-- MySQL Administrator dump 1.4
--
-- ------------------------------------------------------
-- Server version	5.0.45-community-nt


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


--
-- Create schema kalonline
--

CREATE DATABASE IF NOT EXISTS kalonline;
USE kalonline;

--
-- Definition of table `accounts`
--

DROP TABLE IF EXISTS `accounts`;
CREATE TABLE `accounts` (
  `AID` int(10) unsigned NOT NULL auto_increment,
  `Account` varchar(45) NOT NULL,
  `Password` varchar(45) NOT NULL,
  `Blocked` int(10) unsigned NOT NULL,
  `LastLogin` datetime NOT NULL,
  `LastIP` varchar(45) NOT NULL,
  PRIMARY KEY  (`AID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `accounts`
--

/*!40000 ALTER TABLE `accounts` DISABLE KEYS */;
INSERT INTO `accounts` (`AID`,`Account`,`Password`,`Blocked`,`LastLogin`,`LastIP`) VALUES 
 (1,'BakaBug','Bazzuker',0,'2000-00-20 06:00:00',''),
 (2,'black1','black2',0,'2000-00-20 06:00:00','0.0.0.0'),
 (3,'zeroten','blubb',0,'2000-00-20 06:00:00','0.0.0.0'),
 (4,'anime','12345',0,'2000-00-20 06:00:00','0.0.0.0');
/*!40000 ALTER TABLE `accounts` ENABLE KEYS */;


--
-- Definition of table `character`
--

DROP TABLE IF EXISTS `character`;
CREATE TABLE `character` (
  `CID` int(10) unsigned NOT NULL auto_increment,
  `AID` int(10) unsigned default NULL,
  `Name` varchar(45) default NULL,
  `Class` int(10) unsigned default '0',
  `Job` int(10) unsigned default '0',
  `Level` int(10) unsigned default '0',
  `Contribute` int(10) unsigned default '0',
  `Exp` int(10) unsigned default '0',
  `GID` int(10) unsigned default '0',
  `GRole` int(10) unsigned default '0',
  `Strength` int(10) unsigned default '0',
  `Health` int(10) unsigned default '0',
  `Intelligence` int(10) unsigned default '0',
  `Wisdom` int(10) unsigned default '0',
  `Agillity` int(10) unsigned default '0',
  `CurHP` int(10) unsigned default '100',
  `CurMP` int(10) unsigned default '100',
  `CPoints` int(10) unsigned default '0',
  `SPoints` int(10) unsigned default '0',
  `Killed` int(10) unsigned default '0',
  `Map` int(10) unsigned default '0',
  `x` int(10) unsigned default '257284',
  `y` int(10) unsigned default '258364',
  `z` int(10) unsigned default '16150',
  `Face` int(10) unsigned default '0',
  `Hair` int(10) unsigned default '0',
  `RevivalID` int(10) unsigned default '0',
  `Rage` int(10) unsigned default '0',
  `Weapon` int(10) unsigned default '0',
  `Shield` int(10) unsigned default '0',
  `Helmet` int(10) unsigned default '0',
  `Chest` int(10) unsigned default '0',
  `Shorts` int(10) unsigned default '0',
  `Gloves` int(10) unsigned default '0',
  `Boots` int(10) unsigned default '0',
  PRIMARY KEY  (`CID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `character`
--

/*!40000 ALTER TABLE `character` DISABLE KEYS */;
INSERT INTO `character` (`CID`,`AID`,`Name`,`Class`,`Job`,`Level`,`Contribute`,`Exp`,`GID`,`GRole`,`Strength`,`Health`,`Intelligence`,`Wisdom`,`Agillity`,`CurHP`,`CurMP`,`CPoints`,`SPoints`,`Killed`,`Map`,`x`,`y`,`z`,`Face`,`Hair`,`RevivalID`,`Rage`,`Weapon`,`Shield`,`Helmet`,`Chest`,`Shorts`,`Gloves`,`Boots`) VALUES 
 (1,1,'*BakaBug*',1,0,1,0,0,0,0,8,10,22,17,8,100,100,0,0,0,0,257284,258364,16150,1,3,0,0,0,0,0,0,0,0,0),
 (2,3,'[Zero]',1,0,1,0,0,0,0,8,10,23,16,8,100,100,0,0,0,0,257284,258364,16150,1,1,0,0,0,0,0,0,0,0,0),
 (3,2,'*Bl4Ck*',0,0,1,0,0,0,0,22,17,8,8,10,100,100,0,0,0,0,257284,258364,16150,1,1,0,0,0,0,0,0,0,0,0),
 (4,3,'*ZeroTen*',1,0,1,0,0,0,0,8,10,23,16,8,100,100,0,0,0,0,257284,258364,16150,6,6,0,0,0,0,0,0,0,0,0),
 (5,1,'Mitoko',1,0,1,0,0,0,0,8,10,22,17,8,100,100,0,0,0,0,257284,258364,16150,1,3,0,0,0,0,0,0,0,0,0),
 (6,4,'Metroid',2,0,0,0,0,0,0,14,10,8,10,23,100,100,0,0,0,0,257284,258364,16150,1,1,0,0,0,0,0,0,0,0,0);
/*!40000 ALTER TABLE `character` ENABLE KEYS */;


--
-- Definition of table `item`
--

DROP TABLE IF EXISTS `item`;
CREATE TABLE `item` (
  `PID` int(10) unsigned NOT NULL auto_increment,
  `IID` bigint(20) unsigned NOT NULL,
  `Index` int(10) unsigned NOT NULL,
  `Prefix` int(10) unsigned NOT NULL,
  `Info` int(10) unsigned NOT NULL,
  `MaxEnd` int(10) unsigned NOT NULL,
  `CurEnd` int(10) unsigned NOT NULL,
  `XAttack` int(10) unsigned NOT NULL,
  `XMagic` int(10) unsigned NOT NULL,
  `XDefense` int(10) unsigned NOT NULL,
  `XHit` int(10) unsigned NOT NULL,
  `XDodge` int(10) unsigned NOT NULL,
  `Protect` int(10) unsigned NOT NULL,
  `EB` int(10) unsigned NOT NULL,
  `EBChance` int(10) unsigned NOT NULL,
  PRIMARY KEY  (`PID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `item`
--

/*!40000 ALTER TABLE `item` DISABLE KEYS */;
/*!40000 ALTER TABLE `item` ENABLE KEYS */;

--
-- Create schema `kalonline-config`
--

CREATE DATABASE IF NOT EXISTS `kalonline-config`;
USE `kalonline-config`;

--
-- Definition of table `initnpc`
--

DROP TABLE IF EXISTS `initnpc`;
CREATE TABLE `initnpc` (
  `NID` int(10) unsigned NOT NULL auto_increment COMMENT 'A increasing NPC id',
  `Hidden` tinyint(1) NOT NULL COMMENT 'Value to show or to hide NPC',
  `Kind` smallint(5) unsigned NOT NULL COMMENT 'His kind.. not so important (1,2 = ability to move)',
  `Shape` smallint(5) unsigned NOT NULL COMMENT 'NPC-shape how he looks .. how''s his name',
  `Html` int(10) unsigned NOT NULL COMMENT 'A integer to is NPC-Window',
  `x` int(10) unsigned NOT NULL,
  `y` int(10) unsigned NOT NULL,
  `z` int(10) unsigned NOT NULL,
  `look_at_x` int(10) unsigned NOT NULL COMMENT 'Where he looks at',
  `look_at_y` int(10) unsigned NOT NULL,
  `comment` varchar(45) NOT NULL COMMENT 'Here you can enter somethign to rember your NPC''s',
  PRIMARY KEY  (`NID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `initnpc`
--

/*!40000 ALTER TABLE `initnpc` DISABLE KEYS */;
INSERT INTO `initnpc` (`NID`,`Hidden`,`Kind`,`Shape`,`Html`,`x`,`y`,`z`,`look_at_x`,`look_at_y`,`comment`) VALUES 
 (1,0,0,3,1,257491,258584,16120,254491,257484,''),
 (2,0,0,3,3,257016,258556,16140,260016,250556,''),
 (3,0,0,3,7,257556,258207,16140,256556,258207,''),
 (4,0,1,5,9,258118,258956,16024,258112,259026,'skill masters Narootuh 1'),
 (5,0,1,6,15,258083,258980,16025,258112,259026,'skill masters Narootuh 2'),
 (6,0,1,7,19,258053,259000,16022,258112,259026,'skill masters Narootuh 3');
/*!40000 ALTER TABLE `initnpc` ENABLE KEYS */;




/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
