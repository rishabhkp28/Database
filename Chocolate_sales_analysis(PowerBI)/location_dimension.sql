
DROP TABLE IF EXISTS `location_dimension`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `location_dimension` (
  `Location_ID` int DEFAULT NULL,
  `City` text,
  `Country` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


LOCK TABLES `location_dimension` WRITE;
INSERT INTO `location_dimension` VALUES 
(1,'Boston','USA'),(2,'Chicago','USA'),
(3,'Dallas','USA'),(4,'Denver','USA'),
(5,'Houston','USA'),
(6,'Los Angeles','USA'),
(7,'Miami','USA'),
(8,'New York','USA'),
(9,'San Francisco','USA'),
(10,'Seattle','USA');
UNLOCK TABLES;