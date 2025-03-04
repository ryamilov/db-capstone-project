-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema LittleLemonDM
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema LittleLemonDM
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `LittleLemonDM` DEFAULT CHARACTER SET utf8 ;
USE `LittleLemonDM` ;

-- -----------------------------------------------------
-- Table `LittleLemonDM`.`CustomerDetails`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDM`.`CustomerDetails` (
  `CustomerId` INT NOT NULL,
  `FirstName` VARCHAR(45) NULL,
  `LastName` VARCHAR(45) NULL,
  `Phone` VARCHAR(45) NULL,
  PRIMARY KEY (`CustomerId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDM`.`StaffInformation`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDM`.`StaffInformation` (
  `StaffId` INT NOT NULL,
  `FirstName` VARCHAR(45) NULL,
  `LastName` VARCHAR(45) NULL,
  `Role` VARCHAR(45) NULL,
  `Salary` DECIMAL(12,6) NULL,
  PRIMARY KEY (`StaffId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDM`.`Menu`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDM`.`Menu` (
  `MenuId` INT NOT NULL,
  `Cuisine` VARCHAR(45) NULL,
  `Starter` VARCHAR(45) NULL,
  `Course` VARCHAR(45) NULL,
  `Drink` VARCHAR(45) NULL,
  `Dessert` VARCHAR(45) NULL,
  PRIMARY KEY (`MenuId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDM`.`Bookings`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDM`.`Bookings` (
  `BookingId` INT NOT NULL,
  `BookingDate` DATE NULL,
  `TableNumber` INT NULL,
  `CustomerId` INT NULL,
  `StaffId` INT NULL,
  `MenuId` INT NULL,
  PRIMARY KEY (`BookingId`),
  INDEX `CustomerId_idx` (`CustomerId` ASC) VISIBLE,
  INDEX `StaffId_idx` (`StaffId` ASC) VISIBLE,
  INDEX `MenuId_idx` (`MenuId` ASC) VISIBLE,
  CONSTRAINT `CustomerId_Bookings`
    FOREIGN KEY (`CustomerId`)
    REFERENCES `LittleLemonDM`.`CustomerDetails` (`CustomerId`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `StaffId_Bookings`
    FOREIGN KEY (`StaffId`)
    REFERENCES `LittleLemonDM`.`StaffInformation` (`StaffId`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `MenuId`
    FOREIGN KEY (`MenuId`)
    REFERENCES `LittleLemonDM`.`Menu` (`MenuId`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDM`.`OrderDeliveryStatus`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDM`.`OrderDeliveryStatus` (
  `OrderDeliveryStatusId` INT NOT NULL,
  `DeliveryDate` DATE NULL,
  `DeliveryStatus` TINYINT NULL,
  PRIMARY KEY (`OrderDeliveryStatusId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDM`.`Orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDM`.`Orders` (
  `OrdersId` INT NOT NULL,
  `OrderDate` DATE NULL,
  `TotalCost` DECIMAL(12,6) NULL,
  `OrderDeliveryStatusId` INT NULL,
  `StaffId` INT NULL,
  `CustomerId` INT NULL,
  PRIMARY KEY (`OrdersId`),
  INDEX `OrderDeliveryStatusId_idx` (`OrderDeliveryStatusId` ASC) VISIBLE,
  INDEX `StaffId_idx` (`StaffId` ASC) VISIBLE,
  INDEX `CustomerId_idx` (`CustomerId` ASC) VISIBLE,
  CONSTRAINT `OrderDeliveryStatusId`
    FOREIGN KEY (`OrderDeliveryStatusId`)
    REFERENCES `LittleLemonDM`.`OrderDeliveryStatus` (`OrderDeliveryStatusId`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `StaffId_Orders`
    FOREIGN KEY (`StaffId`)
    REFERENCES `LittleLemonDM`.`StaffInformation` (`StaffId`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `CustomerId_Orders`
    FOREIGN KEY (`CustomerId`)
    REFERENCES `LittleLemonDM`.`CustomerDetails` (`CustomerId`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
