-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Dec 07, 2021 at 03:12 AM
-- Server version: 10.4.21-MariaDB
-- PHP Version: 7.4.23

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `city_events`
--

-- --------------------------------------------------------

--
-- Table structure for table `cities`
--

CREATE TABLE `cities` (
  `city` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `cities`
--

INSERT INTO `cities` (`city`) VALUES
('Cork'),
('Dublin'),
('Galway'),
('kildare'),
('London'),
('Mars'),
('New York'),
('Paris'),
('shanghai'),
('Shenzhen');

-- --------------------------------------------------------

--
-- Table structure for table `events`
--

CREATE TABLE `events` (
  `id` int(11) NOT NULL,
  `event` varchar(255) NOT NULL,
  `creator` varchar(100) NOT NULL,
  `event_info` varchar(5500) DEFAULT NULL,
  `event_time` varchar(100) NOT NULL,
  `event_place` varchar(500) NOT NULL,
  `city` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `events`
--

INSERT INTO `events` (`id`, `event`, `creator`, `event_info`, `event_time`, `event_place`, `city`) VALUES
(1, 'Basketball game', 'mapleofriver@gmail.com', 'Let\'s play basketball together!', '2021-12-03T21:36', 'D8 V65', 'Dublin'),
(2, 'Play music', 'mapleofriver@gmail.com', 'Welcome, everyone!', '2021-12-03T21:41', 'D1 ABC', 'Dublin'),
(3, 'Christmas sale!', 'mapleofriver@gmail.com', 'Buy something on sale!', '2021-12-03T18:39', 'City centre', 'Dublin'),
(4, 'Book fair', 'mapleofriver@gmail.com', 'Welcome, all Harry Potter fans!', '2021-12-24T20:00', 'No.5 Avenue', 'London'),
(5, 'New year party', 'mapleofriver@gmail.com', 'Kiss and hug each other!', '2022-01-01T00:00', 'Time Square', 'NeW york'),
(6, 'Basketball game', 'mapleofriver@gmail.com', 'Play togetHer', '2021-12-18T02:01', 'Lujiazui', 'SHanghai'),
(7, 'Competitive programming', 'mapleofriver@gmail.com', 'HAVe FuN', '2021-12-17T01:00', 'LUJIAZHUI', 'SHANGHAI'),
(8, 'UFC fiGHT', 'mapleofriver@gmail.com', 'EVERYONe!', '2021-12-24T02:03', 'BenZ CENtre', 'SHANGHAI'),
(9, 'Basketball game', 'ruoheng@gmail.com', 'Let\'s play!', '2021-12-07T10:00', 'baskteball court', 'Cork'),
(10, 'Rock & Roll Party', 'ruoheng@gmail.com', 'Everyone is welcome!', '2021-12-18T18:00', 'city centre', 'Cork'),
(11, 'Play cards', 'ruoheng@gmail.com', 'HAve fun', '2021-12-15T19:00', 'My home', 'Cork'),
(12, 'Texas hold \'em', 'ruoheng@gmail.com', 'No money involved!', '2021-12-17T16:00', 'Casino', 'Cork');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`email`, `password`) VALUES
('Duncan@gmail.com', 'duncan'),
('Johnwick@gmail.com', 'johnwick'),
('mapleofriver@gmail.com', '05071997'),
('ruoheng.weng@ucdconnect.ie', '05071997'),
('ruoheng1@gmail.com', '05071997'),
('ruoheng2@gmail.com', '123456'),
('ruoheng@gmail.com', '123456'),
('s2039981@ed.ac.uk', '741852963'),
('use@gmail.com', '987654'),
('user1@gmail.com', '05071997'),
('user2@gmail.com', '123456789'),
('user3@gmail.com', '123456789'),
('user@gmail.com', '05071997'),
('wanjia@gmail.com', 'wanjiayu');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cities`
--
ALTER TABLE `cities`
  ADD PRIMARY KEY (`city`);

--
-- Indexes for table `events`
--
ALTER TABLE `events`
  ADD PRIMARY KEY (`id`),
  ADD KEY `city` (`city`),
  ADD KEY `creator` (`creator`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `events`
--
ALTER TABLE `events`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `events`
--
ALTER TABLE `events`
  ADD CONSTRAINT `events_ibfk_1` FOREIGN KEY (`creator`) REFERENCES `users` (`email`),
  ADD CONSTRAINT `events_ibfk_2` FOREIGN KEY (`city`) REFERENCES `cities` (`city`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
