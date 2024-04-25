-- MySQL dump 10.13  Distrib 8.0.31, for Win64 (x86_64)
--
-- Host: localhost    Database: quiz
-- ------------------------------------------------------
-- Server version	8.0.31

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Temporary view structure for view `_fstats`
--

DROP TABLE IF EXISTS `_fstats`;
/*!50001 DROP VIEW IF EXISTS `_fstats`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `_fstats` AS SELECT 
 1 AS `id`,
 1 AS `email`,
 1 AS `type`,
 1 AS `followers`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `_qstats`
--

DROP TABLE IF EXISTS `_qstats`;
/*!50001 DROP VIEW IF EXISTS `_qstats`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `_qstats` AS SELECT 
 1 AS `id`,
 1 AS `email`,
 1 AS `type`,
 1 AS `followers`,
 1 AS `topics`,
 1 AS `total_quiz`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `_tstats`
--

DROP TABLE IF EXISTS `_tstats`;
/*!50001 DROP VIEW IF EXISTS `_tstats`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `_tstats` AS SELECT 
 1 AS `id`,
 1 AS `email`,
 1 AS `type`,
 1 AS `followers`,
 1 AS `topics`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `activity`
--

DROP TABLE IF EXISTS `activity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `activity` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `plan` enum('Free','Scholar','Genius','Admin') COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT 'Free',
  `balance` decimal(10,0) NOT NULL DEFAULT '0',
  `renewed_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `user_id` int unsigned NOT NULL,
  `quizzes_left` int unsigned NOT NULL DEFAULT '10',
  `challenges_left` int unsigned NOT NULL DEFAULT '5',
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `activity_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `activity_chk_1` CHECK ((`quizzes_left` > 0)),
  CONSTRAINT `activity_chk_2` CHECK ((`challenges_left` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `activity`
--

LOCK TABLES `activity` WRITE;
/*!40000 ALTER TABLE `activity` DISABLE KEYS */;
INSERT INTO `activity` VALUES (1,'Admin',0,'2024-04-18 14:50:14',1,1000000,1),(5,'Free',0,'2024-04-19 16:09:13',56,10,5);
/*!40000 ALTER TABLE `activity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `user_id` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `categories_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,'Mathematics',1),(2,'Physics',1),(3,'English',1),(4,'Biology',2),(5,'Arts',3),(11,'Medicine',1),(12,'Pharmacy',1),(13,'Engineering',1),(14,'Programming',2),(15,'Nutrition',3),(16,'Named 1',1),(20,'Unamed category',1),(22,'Unamed category 001',1),(23,'Unamed 0025',1),(30,'Unamed category 11',1),(31,'Unamed 15',1),(32,'Unamed category 111',1),(33,'Unamed 115',1);
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `challenges`
--

DROP TABLE IF EXISTS `challenges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `challenges` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `quizzes` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `paid` tinyint(1) NOT NULL DEFAULT '0',
  `entry_fee` float NOT NULL DEFAULT '0',
  `reward` float NOT NULL DEFAULT '0',
  `user_id` int unsigned NOT NULL,
  `date_added` datetime DEFAULT CURRENT_TIMESTAMP,
  `duration` int unsigned NOT NULL DEFAULT '7',
  PRIMARY KEY (`id`),
  KEY `fk_ch_users` (`user_id`),
  CONSTRAINT `fk_ch_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `challenges`
--

LOCK TABLES `challenges` WRITE;
/*!40000 ALTER TABLE `challenges` DISABLE KEYS */;
INSERT INTO `challenges` VALUES (4,'Brute test','[3,4,11]',0,0,0,2,'2024-03-25 15:51:50',7),(5,'My Quiz','[1, 9, 2, 10, 3]',1,500,4500,1,'2024-03-25 15:51:50',14),(6,'Quiz Jet','[11, 9, 2, 10, 3]',1,150,5000,1,'2024-03-25 15:51:50',1),(7,'Quiz Pro','[11, 9, 2, 10, 3]',1,150,5000,36,'2024-03-25 15:51:50',1);
/*!40000 ALTER TABLE `challenges` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dcqs`
--

DROP TABLE IF EXISTS `dcqs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dcqs` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `query` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `correct` tinyint(1) NOT NULL,
  `explanation` varchar(512) COLLATE utf8mb3_unicode_ci NOT NULL,
  `user_id` int unsigned NOT NULL,
  `topic_id` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `topic_id` (`topic_id`),
  CONSTRAINT `dcqs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `dcqs_ibfk_2` FOREIGN KEY (`topic_id`) REFERENCES `topics` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dcqs`
--

LOCK TABLES `dcqs` WRITE;
/*!40000 ALTER TABLE `dcqs` DISABLE KEYS */;
INSERT INTO `dcqs` VALUES (1,'Dual choice question 1',1,'Explained',2,1),(2,'Dual choice question 2',1,'Explained',2,1),(3,'Dual choice question 3',1,'Explained',2,1),(4,'Dual choice question 4',1,'Explained',2,1),(5,'Dual choice question 5',1,'Explained',2,1),(6,'Dual choice question 6',1,'Explained',2,1),(7,'Dual choice question 7',1,'Explained',2,1),(8,'Dual choice question 11',1,'Explained',2,1),(9,'Dual choice question 12',1,'Explained',2,1),(10,'Dual choice question 13',1,'Explained',2,1),(11,'Dual choice question 14',1,'Explained',2,1),(12,'Am i innocent 8987gh',1,'I am innocent because',1,5),(13,'Am i innocent hguiu',1,'I am innocent because',1,5),(14,'Am i innocent 6343r',1,'I am innocent because',1,5),(15,'gdgi geg innocent 8987gh',1,'I am innocent because',1,2),(16,'etrgn sfsng ent hguiu',1,'I am innocent because',1,3),(17,'d tuiuyr ocent 6343r',1,'I am innocent because',1,6),(18,'gdgi geg innocent 8987gh',1,'I am innocent because',1,2),(19,'etrgn sfsng ent hguiu',1,'I am innocent because',1,3),(20,'d tuiuyr ocent 6343r',1,'I am innocent because',1,6),(21,'gdgi geg innocent 8987gh',1,'I am innocent because',1,2),(22,'etrgn sfsng ent hguiu',1,'I am innocent because',1,3),(23,'d tuiuyr ocent 6343r',1,'I am innocent because',1,6),(29,'A good query 04rnf',0,'This query is well explained',1,6),(31,'Test dcq question',0,'This is well explained',1,6),(36,'can I go',1,'come here',1,17),(37,'can I go',1,'come here',1,17);
/*!40000 ALTER TABLE `dcqs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `follows`
--

DROP TABLE IF EXISTS `follows`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `follows` (
  `follower_id` int unsigned NOT NULL,
  `followed_id` int unsigned NOT NULL,
  `date_followed` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`follower_id`,`followed_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `follows`
--

LOCK TABLES `follows` WRITE;
/*!40000 ALTER TABLE `follows` DISABLE KEYS */;
INSERT INTO `follows` VALUES (1,2,'2024-03-28 07:19:34'),(1,3,'2024-03-28 07:19:34'),(1,16,'2024-03-28 07:19:34'),(1,30,'2024-03-31 12:29:28'),(1,31,'2024-03-28 14:06:28'),(1,32,'2024-03-30 09:54:34'),(1,33,'2024-03-28 14:15:58'),(1,34,'2024-03-28 14:12:35'),(1,35,'2024-03-28 14:10:23'),(2,3,'2024-01-30 21:35:04'),(2,4,'2024-01-30 21:35:04'),(2,16,'2024-01-30 21:55:03'),(3,1,'2024-01-30 21:35:04'),(3,2,'2024-01-30 21:35:04'),(3,10,'2024-01-30 21:35:04'),(3,16,'2024-01-30 21:55:03'),(4,1,'2024-01-30 21:35:04'),(4,10,'2024-01-30 21:35:04'),(4,16,'2024-01-30 21:55:03'),(10,1,'2024-01-30 21:35:04'),(10,3,'2024-01-30 21:35:04'),(10,16,'2024-01-30 21:55:03'),(14,16,'2024-01-30 21:55:03'),(15,16,'2024-01-30 21:55:03'),(16,1,'2024-01-31 09:33:11');
/*!40000 ALTER TABLE `follows` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `leaderboards`
--

DROP TABLE IF EXISTS `leaderboards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `leaderboards` (
  `challenge_id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL,
  `points` int unsigned NOT NULL DEFAULT '0',
  `progress` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`challenge_id`,`user_id`),
  KEY `fk_l_users` (`user_id`),
  CONSTRAINT `fk_l_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_lead_chal` FOREIGN KEY (`challenge_id`) REFERENCES `challenges` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `leaderboards`
--

LOCK TABLES `leaderboards` WRITE;
/*!40000 ALTER TABLE `leaderboards` DISABLE KEYS */;
INSERT INTO `leaderboards` VALUES (4,1,0,10),(4,10,0,0),(4,16,0,0),(4,31,0,0),(5,1,350,5),(5,10,0,0),(5,16,0,0),(5,31,0,0),(6,1,100,2),(6,10,0,0),(6,16,0,0),(6,31,0,0);
/*!40000 ALTER TABLE `leaderboards` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mcqs`
--

DROP TABLE IF EXISTS `mcqs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mcqs` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `query` varchar(512) COLLATE utf8mb3_unicode_ci NOT NULL,
  `A` varchar(100) COLLATE utf8mb3_unicode_ci NOT NULL,
  `B` varchar(100) COLLATE utf8mb3_unicode_ci NOT NULL,
  `C` varchar(100) COLLATE utf8mb3_unicode_ci NOT NULL,
  `D` varchar(100) COLLATE utf8mb3_unicode_ci NOT NULL,
  `explanation` varchar(1024) COLLATE utf8mb3_unicode_ci NOT NULL,
  `correct` enum('A','B','C','D') COLLATE utf8mb3_unicode_ci NOT NULL,
  `difficulty` enum('Easy','Medium','Hard','Impossible') COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT 'Easy',
  `topic_id` int unsigned NOT NULL,
  `user_id` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_questions_topic` (`topic_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `fk_questions_topic` FOREIGN KEY (`topic_id`) REFERENCES `topics` (`id`) ON DELETE CASCADE,
  CONSTRAINT `mcqs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=68 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mcqs`
--

LOCK TABLES `mcqs` WRITE;
/*!40000 ALTER TABLE `mcqs` DISABLE KEYS */;
INSERT INTO `mcqs` VALUES (1,'Test Question 11','Aa','Bb','Cc','Dd','explained','A','Easy',1,2),(2,'Test Question 23','Aa','Bb','Cc','Dd','explained','B','Easy',1,2),(3,'Test Question 13','Aa','Bb','Cc','Dd','explained','A','Easy',2,2),(4,'Test Question 45','Aa','Bb','Cc','Dd','explained','A','Easy',1,2),(5,'Test Question 15','Aa','Bb','Cc','Dd','explained','D','Easy',3,2),(6,'Test Question 67','Aa','Bb','Cc','Dd','explained','A','Easy',1,2),(7,'Test Question 71','Aa','Bb','Cc','Dd','explained','B','Easy',4,2),(8,'Test Question 84','Aa','Bb','Cc','Dd','explained','D','Easy',5,2),(9,'Test Question 19','Aa','Bb','Cc','Dd','explained','C','Easy',6,2),(10,'Test Question 10','Aa','Bb','Cc','Dd','explained','A','Easy',8,2),(11,'Test Question 41','Aa','Bb','Cc','Dd','explained','A','Easy',10,1),(12,'Test Question 23','Aa','Bb','Cc','Dd','explained','B','Easy',9,1),(13,'Test Question 53','Aa','Bb','Cc','Dd','explained','A','Easy',5,1),(14,'Test Question 55','Aa','Bb','Cc','Dd','explained','A','Easy',3,1),(15,'Test Question 25','Aa','Bb','Cc','Dd','explained','D','Easy',3,1),(16,'Test Question 87','Aa','Bb','Cc','Dd','explained','A','Easy',2,2),(17,'Test Question 01','Aa','Bb','Cc','Dd','explained','B','Easy',1,2),(18,'Test Question 14','Aa','Bb','Cc','Dd','explained','D','Easy',5,2),(19,'Test Question 90','Aa','Bb','Cc','Dd','explained','C','Easy',6,2),(20,'Test Question 11','Aa','Bb','Cc','Dd','explained','A','Easy',8,2),(21,'Test Question 41','Aa','Bb','Cc','Dd','explained','A','Easy',10,1),(22,'Test Question 23','Aa','Bb','Cc','Dd','explained','B','Easy',9,1),(23,'Test Question 53','Aa','Bb','Cc','Dd','explained','A','Easy',5,1),(24,'Test Question 55','Aa','Bb','Cc','Dd','explained','A','Easy',3,1),(25,'Test Question 25','Aa','Bb','Cc','Dd','explained','D','Easy',3,1),(26,'Test Question 87','Aa','Bb','Cc','Dd','explained','A','Easy',2,2),(27,'Test Question 01','Aa','Bb','Cc','Dd','explained','B','Easy',1,2),(28,'Test Question 14','Aa','Bb','Cc','Dd','explained','D','Easy',5,2),(29,'Test Question 90','Aa','Bb','Cc','Dd','explained','C','Easy',6,2),(30,'Test Question 11','Aa','Bb','Cc','Dd','explained','A','Easy',8,2),(33,'Who knows who again and again?','I do','Mashein','Broski','Entrey','How does it work','B','Hard',3,1),(34,'How many times do you who again and again?','I do','Mashein','Broski','Entrey','How does it work','B','Hard',3,1),(35,'A test question','Blah','Ahaha','No blah','Nose bleed','Who KNOWS','C','Easy',5,1),(36,'A test question y2ruy','Blah','Ahaha','No blah','Nose bleed','Who KNOWS','C','Easy',5,1),(37,'A test question 724tr','Blah','Ahaha','No blah','Nose bleed','Who KNOWS','C','Easy',5,1),(38,'A test question 0893','Blah','Ahaha','No blah','Nose bleed','Who KNOWS','C','Easy',5,1),(39,'Good Question 1','First option','Second Opt','Third Option','Last option','A thorough explanation','A','Hard',5,1),(40,'Good Question 1','First option','Second Opt','Third Option','Last option','A thorough explanation','A','Hard',5,1),(41,'Good Question 1012','First option','Second Opt','Third Option','Last option','A thorough explanation','A','Hard',5,1),(42,'Good Question 562','First option','Second Opt','Third Option','Last option','A thorough explanation','A','Hard',5,1),(43,'Good Question 562','First option','Second Opt','Third Option','Last option','A thorough explanation','A','Hard',5,1),(44,'Good Question 562','First option','Second Opt','Third Option','Last option','A thorough explanation','A','Hard',5,1),(45,'A big query 001','Answer A','Beacous','cecos','D-strig','My own explanation','B','Easy',6,1),(46,'What is c++','Language','Programming language','Latin','maths','C++ is a programming language\n','D','Easy',10,1),(47,'Who is Allah','God','Devil','Demon','NOTA','I don\'t know\n','A','Easy',10,1),(48,'How do you make omelet','Fry','boil','cook','roast','We fry omelette\n','B','Easy',10,1),(49,'How to make bread','workhorse','work hard','worksmart','steal','Stealing is best\n','B','Easy',5,1),(50,'Who wins money','business','doctor','singer','writer','I don\'t know','A','Easy',5,1),(51,'How to make bread','workhorse','work hard','worksmart','steal','Stealing is best\n','B','Easy',5,1),(52,'Who wins money','business','doctor','singer','writer','\n','A','Easy',5,1),(53,'Who knows me','no one','everyone','bobby','em','\n','C','Easy',9,1),(60,'Hala marie','aaa','bbb','ccc','ddd','BooToxa amadea','B','Medium',26,1),(61,'John ask me','mea','rojda','keiop','options nota','who gives\n','D','Easy',26,1),(62,'Hala marie','aaa','bbb','ccc','ddd','BooToxa amadea','B','Medium',26,1),(63,'John ask me','mea','rojda','keiop','options nota','who gives\n','D','Easy',26,1),(64,'Pooba','loolab','opp','otokm','kiop','through\n','B','Easy',7,1),(65,'ijop','iok','thio','thio','thie','thio','B','Easy',7,1),(66,'Pooba','loolab','opp','otokm','kiop','through\n','B','Easy',7,1),(67,'ijop','iok','thio','thio','thie','thio','B','Easy',7,1);
/*!40000 ALTER TABLE `mcqs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `profile_data`
--

DROP TABLE IF EXISTS `profile_data`;
/*!50001 DROP VIEW IF EXISTS `profile_data`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `profile_data` AS SELECT 
 1 AS `id`,
 1 AS `user_name`,
 1 AS `email`,
 1 AS `type`,
 1 AS `department`,
 1 AS `level`,
 1 AS `followers`,
 1 AS `topics`,
 1 AS `total_quiz`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `quiz`
--

DROP TABLE IF EXISTS `quiz`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quiz` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(100) COLLATE utf8mb3_unicode_ci NOT NULL,
  `questions` varchar(2048) COLLATE utf8mb3_unicode_ci NOT NULL,
  `user_id` int unsigned NOT NULL,
  `topic_id` int unsigned NOT NULL,
  `duration` int unsigned NOT NULL DEFAULT '1800',
  `description` varchar(2048) COLLATE utf8mb3_unicode_ci NOT NULL,
  `date_added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `type` enum('mcq','dcq') COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT 'mcq',
  `difficulty` enum('Easy','Medium','Hard') COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT 'Easy',
  PRIMARY KEY (`id`),
  UNIQUE KEY `title` (`title`),
  KEY `topic_id` (`topic_id`),
  KEY `fk_quiz_users` (`user_id`),
  CONSTRAINT `fk_quiz_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `quiz_ibfk_1` FOREIGN KEY (`topic_id`) REFERENCES `topics` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quiz`
--

LOCK TABLES `quiz` WRITE;
/*!40000 ALTER TABLE `quiz` DISABLE KEYS */;
INSERT INTO `quiz` VALUES (1,'Test quiz 10x0','[9, 10]',2,2,1800,'Test description','2024-01-31 09:08:12','mcq','Easy'),(2,'Test quiz 0x11','[10, 12, 14, 16, 9]',2,3,1800,'Test description','2024-01-31 09:08:12','mcq','Easy'),(3,'Test quiz 0x21','[12, 17, 19, 10]',2,4,1800,'Test description','2024-01-31 09:08:12','mcq','Easy'),(4,'Test quiz 3x01','[12, 15, 19, 10]',2,4,1800,'Test description','2024-01-31 09:08:12','mcq','Easy'),(11,'Test quiz 0x','[12, 17, 19, 10]',16,4,1800,'Test description','2024-01-31 09:14:56','mcq','Easy'),(12,'Test quiz 301','[12, 15, 19, 10]',16,4,1800,'Test description','2024-01-31 09:14:56','mcq','Easy'),(13,'A beautiful quiz','[10, 11, 12, 14, 15, 16, 18]',2,6,2000,'What a zyuw frjf','2024-03-06 15:12:27','dcq','Hard'),(14,'A beautiful quefehfiz','[10, 11, 12, 14, 15, 16, 18]',2,6,2000,'What a zyuw frjf','2024-03-06 15:12:42','dcq','Hard'),(15,'Daman dui quefehfiz','[10, 11, 12, 14, 15, 16, 18]',2,6,2000,'What a zyuw frjf','2024-03-06 15:12:51','dcq','Hard'),(20,'Moneta Quoz','[48, 47, 46, 21, 11]',1,10,600,'No brainer quiz','2024-03-27 21:10:49','mcq','Easy'),(21,'Andra day','[30, 20, 10]',1,8,1800,'The song','2024-03-27 21:13:27','mcq','Medium'),(22,'Bombardment','[31, 29, 26, 23, 20, 17]',1,6,600,'A quick one','2024-03-27 21:27:06','dcq','Hard'),(23,'Winds man','[26, 23, 17, 31]',1,6,1200,'to the winds','2024-03-27 21:30:54','dcq','Easy'),(25,'iop','[17, 4, 2, 27, 6, 1]',1,1,1800,'uhkkt','2024-04-10 23:38:48','mcq','Easy'),(27,'falter','[6, 27, 2]',1,1,600,'rukba','2024-04-11 00:05:00','mcq','Easy');
/*!40000 ALTER TABLE `quiz` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subscription_trans`
--

DROP TABLE IF EXISTS `subscription_trans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subscription_trans` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `plan` enum('Free','Scholar','Genius','Admin') COLLATE utf8mb3_unicode_ci NOT NULL,
  `reference` varchar(128) COLLATE utf8mb3_unicode_ci NOT NULL,
  `access_code` varchar(128) COLLATE utf8mb3_unicode_ci NOT NULL,
  `status` enum('pending','verified') COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT 'pending',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `verified_at` datetime DEFAULT NULL,
  `user_id` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `subscription_trans_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subscription_trans`
--

LOCK TABLES `subscription_trans` WRITE;
/*!40000 ALTER TABLE `subscription_trans` DISABLE KEYS */;
INSERT INTO `subscription_trans` VALUES (1,'Admin','5rma9x47yp','dblz4gi7nvcj0i1','verified','2024-03-24 10:22:25','2024-04-18 14:50:14',1),(2,'Admin','2q7rgyfpq3','89zjc5g5bt1x7sg','pending','2024-03-24 10:22:44',NULL,1),(3,'Admin','ls7m3phe2o','05liw8s7pe6dwo5','pending','2024-03-24 10:26:13','2024-03-24 10:26:13',1);
/*!40000 ALTER TABLE `subscription_trans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `topics`
--

DROP TABLE IF EXISTS `topics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `topics` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(100) COLLATE utf8mb3_unicode_ci NOT NULL,
  `description` varchar(2048) COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT '',
  `date_added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `category_id` int unsigned NOT NULL,
  `user_id` int unsigned NOT NULL,
  `level` enum('100','200','300','400','500','600') COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT '100',
  PRIMARY KEY (`id`),
  UNIQUE KEY `title` (`title`),
  KEY `fk_topics_cat` (`category_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `fk_topics_cat` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `topics_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `topics`
--

LOCK TABLES `topics` WRITE;
/*!40000 ALTER TABLE `topics` DISABLE KEYS */;
INSERT INTO `topics` VALUES (1,'Engine 101','','2024-01-20 13:22:51',13,1,'100'),(2,'Engine 202','','2024-01-20 13:22:51',2,2,'300'),(3,'Math 121','','2024-01-20 13:22:51',1,1,'300'),(4,'Math 234','','2024-01-20 13:22:51',1,3,'300'),(5,'Computer Programming 101','','2024-01-20 13:22:51',14,2,'300'),(6,'Lang 101','','2024-01-20 13:24:16',3,1,'300'),(7,'Lit 232','','2024-01-20 13:24:16',3,2,'300'),(8,'Phy 321','','2024-01-20 13:24:16',2,1,'300'),(9,'Math 214','','2024-01-20 13:24:16',1,3,'300'),(10,'Intro C++','','2024-01-20 13:24:16',14,2,'300'),(11,'Test topic','Test description','2024-01-20 21:03:40',14,1,'300'),(13,'Test topic 01','Test description','2024-01-20 21:07:11',14,1,'300'),(14,'Test topic 02','Test description 22','2024-01-20 21:07:11',13,1,'300'),(15,'Test topic 0100','Test description','2024-01-20 21:09:28',1,1,'300'),(16,'Test topic 0012','Test description 22','2024-01-20 21:09:28',13,1,'300'),(17,'Test topic 001','Test description','2024-01-20 21:11:37',1,1,'300'),(18,'Test topic 002','Test description 22','2024-01-20 21:11:37',13,1,'300'),(24,'A new quizze','Described','2024-03-26 21:21:06',1,1,'100'),(26,'Geneva','adams\n','2024-03-26 21:51:34',15,1,'100'),(27,'Big Topic','Anna kendrick','2024-03-26 21:57:02',3,1,'100'),(28,'BooToxa','A book toxa topic\n','2024-03-26 21:58:12',1,1,'100'),(29,'QUICKEST TOPIC','How quiz','2024-03-27 22:48:40',1,1,'100'),(30,'A big bunda','who know you','2024-03-28 14:18:12',12,1,'100'),(31,'Ball toxa','write a new me','2024-03-29 09:59:31',1,1,'100'),(32,'Bordeeline','hurray','2024-04-12 22:55:35',13,1,'100'),(33,'fantastice','hurray','2024-04-12 22:55:57',13,1,'100'),(34,'Funda','short','2024-04-12 22:57:47',16,1,'100'),(36,'kunda','short\n\n\n','2024-04-12 22:58:28',16,1,'100'),(37,'kundatt','short\n\nanuo\n','2024-04-12 22:58:53',16,1,'100');
/*!40000 ALTER TABLE `topics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_name` varchar(50) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `email` varchar(100) COLLATE utf8mb3_unicode_ci NOT NULL,
  `password` varchar(100) COLLATE utf8mb3_unicode_ci NOT NULL,
  `type` enum('Free','Scholar','Genius','Admin') COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT 'Free',
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `user_name` (`user_name`)
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'King Collins','king@gmail.com','$2b$12$dzrBz8VvUPvLO6NLyXTjKODc4x3cO099/vsPRKSSbHvw1Xcaqavoe','Admin'),(2,'Super user','super@gmail.com','$2b$12$bm8inqy4EB3CdGm2nSWepuTnwv5C7bha1lXUktXDFiCroIcLYhVFm','Admin'),(3,'Admin User','admin@gmail.com','$2b$12$xc1zLuTJEN1RaILPIjpdIeIyciPmsACcl/R2ec7JtfEDnY2ghznC6','Admin'),(4,'testuser110','test110@gmail.com','$2b$12$F88HPV1SLO0U4Wk/451zhu7dKXHRS.wpiWO/GMv5susgU86gGpAwy','Admin'),(10,'testuser116','test116@gmail.com','$2b$12$PAd5CsVDiIHWCQAqPVGTbegxU1Jt/SSFLwhuH57MZ5LSdhMsX6piC','Admin'),(14,NULL,'big@gmail.com','$2b$12$9nr.3fA0rz9KhwUNOiwq8OEyZPxApt.Fz46LT0/s0JvGNKyBkf452','Admin'),(15,'Manuel','manuel@gmail.com','$2b$12$V13cuneZBpJ1skR8rktXUOtsEPSv6YGzkb4zU65HnsxTafKb8Pej.','Admin'),(16,'James','james@gmail.com','$2b$12$LWKwAa7KO5Uj/4LWhGsPh.vPKHf4ndiaQAKJa2vf8kN2mOCwcc.Ee','Admin'),(17,'Barba','barba@gmail.com','$2b$12$XAmJPutYcMZGOvX53NnRF.FPLouPCn.flgw1RVWiQTyevbbpebEHy','Admin'),(22,'Bola Kings','bola@gmail.com','$2b$12$xDOXfTdfiytqdb.IM7tPvOM/b4qd1tcXQyPMz1uqBIYh8hYET1yFe','Admin'),(26,'Bunda Kings','bunda@gmail.com','$2b$12$m3sWTbn/GTluQNxsKxz2JuY60weT1E8BaNnLmeEkIDU059THbiH1m','Admin'),(29,'Grace Kings','grace@gmail.com','$2b$12$uw.fzZXgFYl29y6DbjGkI.YVvWyu.9/MET5trW3fW6vt3R.bDuz/y','Admin'),(30,'Andreu Kings','andreu@gmail.com','$2b$12$Z8DGVn9TNRJsY5tEhkbUCecw1NIq/C/TyosrBXBel4yDP4xU4Mbtq','Admin'),(31,'Martha Kings','martha@gmail.com','$2b$12$IPnscBZX8Qvikg7Kv5Rci.7/59c5FYyu.IQHz0XruDHjAUkmArDGO','Admin'),(32,'Bob Kings','bob@gmail.com','$2b$12$KjtgSEkavPsbuvikvMChq.DrAsoydM4j8SyF1yeSaRhb6sbEbg.7u','Admin'),(33,'Hana Kings','hana@gmail.com','$2b$12$cB..863YE2kG2.0GuFejLOXsC..ex/VMvPGrQ1k07KpYn0nEO.jsK','Admin'),(34,'Johan Kings','johan@gmail.com','$2b$12$vl1aCn4dCKyFZvntJNiFQOHRzW9zgucC4OeGW5Cmu7T2.TUPVvujW','Admin'),(35,'Bleh Kings','bleh@gmail.com','$2b$12$.Ga4a2fH6cufsBuFgYKBBeU9A5pBwoYRAiu2LEjA1bRHyka5B6lru','Admin'),(36,'Jon','jon@gmail.com','$2b$12$Z2.qjP/0MKF/AN/NoMfdMOqscN5.rPZaCcKr3E9zo9UzO45EMtSgC','Admin'),(56,'Andrew persky','andrew89@gmail.com','$2b$12$I24de9tk2iAvzpg84n006.H0tNVy5MMtxD3Vu4PX5TBtpydSVs7ry','Free');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_profile`
--

DROP TABLE IF EXISTS `users_profile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users_profile` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `department` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `level` enum('100','200','300','400','500','600') COLLATE utf8mb3_unicode_ci NOT NULL,
  `user_id` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `users_profile_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_profile`
--

LOCK TABLES `users_profile` WRITE;
/*!40000 ALTER TABLE `users_profile` DISABLE KEYS */;
INSERT INTO `users_profile` VALUES (2,'Pharmacy','200',26),(6,'Pharmacy','300',22),(9,'Pharmacy','100',29),(11,'Pharmacy','100',30),(12,'Pharmacy','100',31),(13,'Pharmacy','100',32),(14,'Pharmacy','100',33),(15,'Pharmacy','100',34),(16,'Pharmacy','100',35),(18,'Pharmacy','400',1),(20,'Engineering','500',56);
/*!40000 ALTER TABLE `users_profile` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `_fstats`
--

/*!50001 DROP VIEW IF EXISTS `_fstats`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `_fstats` AS select `users`.`id` AS `id`,`users`.`email` AS `email`,`users`.`type` AS `type`,count(`follows`.`follower_id`) AS `followers` from (`users` left join `follows` on((`follows`.`followed_id` = `users`.`id`))) group by `users`.`id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `_qstats`
--

/*!50001 DROP VIEW IF EXISTS `_qstats`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `_qstats` AS select `_tstats`.`id` AS `id`,`_tstats`.`email` AS `email`,`_tstats`.`type` AS `type`,`_tstats`.`followers` AS `followers`,`_tstats`.`topics` AS `topics`,count(`quiz`.`id`) AS `total_quiz` from (`_tstats` left join `quiz` on((`_tstats`.`id` = `quiz`.`user_id`))) group by `_tstats`.`id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `_tstats`
--

/*!50001 DROP VIEW IF EXISTS `_tstats`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `_tstats` AS select `_fstats`.`id` AS `id`,`_fstats`.`email` AS `email`,`_fstats`.`type` AS `type`,`_fstats`.`followers` AS `followers`,count(`topics`.`id`) AS `topics` from (`_fstats` left join `topics` on((`_fstats`.`id` = `topics`.`user_id`))) group by `_fstats`.`id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `profile_data`
--

/*!50001 DROP VIEW IF EXISTS `profile_data`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `profile_data` AS select `users`.`id` AS `id`,`users`.`user_name` AS `user_name`,`users`.`email` AS `email`,`users`.`type` AS `type`,`users_profile`.`department` AS `department`,`users_profile`.`level` AS `level`,`_qstats`.`followers` AS `followers`,`_qstats`.`topics` AS `topics`,`_qstats`.`total_quiz` AS `total_quiz` from (`_qstats` left join (`users_profile` left join `users` on((`users_profile`.`user_id` = `users`.`id`))) on((`_qstats`.`id` = `users`.`id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-04-21 11:28:33
