<?php

/**
 * This function is called on installation and is used to create database schema for the plugin
 */
function extension_install_security()
{
    $commonObject = new ExtensionCommon;

    $commonObject -> sqlQuery("CREATE TABLE IF NOT EXISTS `securitycenter` (
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

/**
 * This function is called on removal and is used to destroy database schema for the plugin
 */
function extension_delete_security()
{
    $commonObject = new ExtensionCommon;
    $commonObject -> sqlQuery("DROP TABLE IF EXISTS `securitycenter`");
}

/**
 * This function is called on plugin upgrade
 */
function extension_upgrade_security()
{

}
