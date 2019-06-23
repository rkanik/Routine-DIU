-- phpMyAdmin SQL Dump
-- version 4.8.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 19, 2019 at 08:49 AM
-- Server version: 10.1.37-MariaDB
-- PHP Version: 7.3.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `routinemanagercse`
--

-- --------------------------------------------------------

--
-- Table structure for table `anonymous_users`
--

CREATE TABLE `anonymous_users` (
  `ip` varchar(64) NOT NULL,
  `isp` varchar(64) NOT NULL,
  `org` varchar(64) NOT NULL,
  `hostname` varchar(64) NOT NULL,
  `longitude` varchar(64) NOT NULL,
  `latitude` varchar(64) NOT NULL,
  `postal_code` varchar(16) NOT NULL,
  `city` varchar(64) NOT NULL,
  `country_code` varchar(16) NOT NULL,
  `country_name` varchar(64) NOT NULL,
  `continent_code` varchar(16) NOT NULL,
  `region` varchar(64) NOT NULL,
  `district` varchar(64) NOT NULL,
  `timezone_name` varchar(64) NOT NULL,
  `connection_type` varchar(64) DEFAULT NULL,
  `asn_number` varchar(64) NOT NULL,
  `asn_org` varchar(127) NOT NULL,
  `asn` varchar(127) NOT NULL,
  `currency_code` varchar(64) NOT NULL,
  `currency_name` varchar(64) NOT NULL,
  `browserName` varchar(64) NOT NULL,
  `fullVersion` varchar(64) NOT NULL,
  `majorVersion` varchar(16) NOT NULL,
  `appName` varchar(64) NOT NULL,
  `userAgent` text NOT NULL,
  `platform` varchar(16) NOT NULL,
  `osName` varchar(16) NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `anonymous_users`
--

INSERT INTO `anonymous_users` (`ip`, `isp`, `org`, `hostname`, `longitude`, `latitude`, `postal_code`, `city`, `country_code`, `country_name`, `continent_code`, `region`, `district`, `timezone_name`, `connection_type`, `asn_number`, `asn_org`, `asn`, `currency_code`, `currency_name`, `browserName`, `fullVersion`, `majorVersion`, `appName`, `userAgent`, `platform`, `osName`, `updated_at`, `created_at`) VALUES
('103.108.112.18', 'Wink Communication', 'Wink Communication', '103.108.112.18', '90.3883', '23.762', '1215', 'Dhaka (Tejgaon)', 'BD', 'Bangladesh', 'AS', 'Dhaka', 'Dhaka', 'Asia/Dhaka', '', '137435', 'WINK COMMUNICATION', 'AS137435 - WINK COMMUNICATION', 'BDT', 'Bangladeshi Taka', 'Chrome', '77.0.3824.6', '77', 'Netscape', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3824.6 Safari/537.36', 'Win32', 'Windows', '2019-06-19 06:48:49', '2019-06-19 06:43:22');

-- --------------------------------------------------------

--
-- Table structure for table `students`
--

CREATE TABLE `students` (
  `_id` int(11) NOT NULL,
  `Name` varchar(64) NOT NULL,
  `ID` varchar(64) NOT NULL,
  `Email` varchar(255) DEFAULT NULL,
  `Level` varchar(16) NOT NULL,
  `Term` varchar(16) NOT NULL,
  `Section` varchar(16) NOT NULL,
  `CreatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `UpdatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `students`
--

INSERT INTO `students` (`_id`, `Name`, `ID`, `Email`, `Level`, `Term`, `Section`, `CreatedAt`, `UpdatedAt`) VALUES
(1, 'Rasel', '161-15-7040', 'rasel15-7040@diu.edu.bd', 'L4', 'T2', 'I', '2019-06-18 07:23:58', '2019-06-18 07:23:58');

-- --------------------------------------------------------

--
-- Table structure for table `stud_courses`
--

CREATE TABLE `stud_courses` (
  `_id` int(11) NOT NULL,
  `stud_id` int(11) NOT NULL,
  `Courses` varchar(16) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `anonymous_users`
--
ALTER TABLE `anonymous_users`
  ADD PRIMARY KEY (`ip`);

--
-- Indexes for table `students`
--
ALTER TABLE `students`
  ADD PRIMARY KEY (`_id`);

--
-- Indexes for table `stud_courses`
--
ALTER TABLE `stud_courses`
  ADD PRIMARY KEY (`_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `students`
--
ALTER TABLE `students`
  MODIFY `_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `stud_courses`
--
ALTER TABLE `stud_courses`
  MODIFY `_id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
