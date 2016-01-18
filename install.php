<?php
function plugin_version_security()
{
return array('name' => 'security',
'version' => '1.0',
'author'=> 'Nicolas DEROUET, Gilles DUBOIS',
'license' => 'GPLv2',
'verMinOcs' => '2.2');
}

function plugin_init_security()
{
$object = new plugins;
$object -> add_cd_entry("security","software");

// Officepack table creation

$object -> sql_query("CREATE TABLE IF NOT EXISTS `securitycenter` (
  `ID` INT(11) NOT NULL AUTO_INCREMENT,
  `HARDWARE_ID` INT(11) NOT NULL,
  `SCV` VARCHAR(255) DEFAULT NULL,
  `CATEGORY` VARCHAR(255) DEFAULT NULL,
  `COMPANY` VARCHAR(255) DEFAULT NULL,
  `PRODUCT` VARCHAR(255) DEFAULT NULL,
  `VERSION` VARCHAR(255) DEFAULT NULL,
  `ENABLED` INT(11) DEFAULT NULL,
  `UPTODATE` INT(11) DEFAULT NULL,
  PRIMARY KEY  (`ID`,`HARDWARE_ID`)
) ENGINE=INNODB ;");

}

function plugin_delete_security()
{
$object = new plugins;
$object -> del_cd_entry("security");

$object -> sql_query("DROP TABLE `securitycenter`;");

}

?>
