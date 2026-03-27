/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19  Distrib 10.6.23-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: schema_person
-- ------------------------------------------------------
-- Server version	10.4.32-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `audit_logs`
--

DROP TABLE IF EXISTS `audit_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `audit_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `person_id` int(11) DEFAULT NULL COMMENT 'Person ID (jika applicable)',
  `table_name` varchar(50) DEFAULT NULL COMMENT 'Nama tabel',
  `record_id` int(11) DEFAULT NULL COMMENT 'ID record',
  `action` enum('CREATE','UPDATE','DELETE','VIEW','LOGIN','LOGOUT','EXPORT','IMPORT','VERIFY','REJECT','APPROVE','LAINNYA') NOT NULL,
  `old_values` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Nilai lama (JSON)' CHECK (json_valid(`old_values`)),
  `new_values` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Nilai baru (JSON)' CHECK (json_valid(`new_values`)),
  `changed_fields` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Field yang berubah (JSON)' CHECK (json_valid(`changed_fields`)),
  `ip_address` varchar(45) DEFAULT NULL COMMENT 'IP address',
  `user_agent` text DEFAULT NULL COMMENT 'User agent',
  `session_id` varchar(100) DEFAULT NULL COMMENT 'Session ID',
  `user_id` int(11) DEFAULT NULL COMMENT 'User ID yang melakukan aksi',
  `username` varchar(50) DEFAULT NULL COMMENT 'Username yang melakukan aksi',
  `reason` text DEFAULT NULL COMMENT 'Alasan perubahan',
  `reference_type` varchar(50) DEFAULT NULL COMMENT 'Tipe referensi',
  `reference_id` int(11) DEFAULT NULL COMMENT 'ID referensi',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_person` (`person_id`),
  KEY `idx_table_name` (`table_name`),
  KEY `idx_record_id` (`record_id`),
  KEY `idx_action` (`action`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_username` (`username`),
  KEY `idx_ip_address` (`ip_address`),
  KEY `idx_created_at` (`created_at`),
  KEY `idx_reference` (`reference_type`,`reference_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit_logs`
--

LOCK TABLES `audit_logs` WRITE;
/*!40000 ALTER TABLE `audit_logs` DISABLE KEYS */;
INSERT INTO `audit_logs` VALUES (1,1,NULL,NULL,'CREATE',NULL,'{\"nik\": \"3201011234560001\", \"name\": \"Ahmad Sudirman\", \"created_at\": \"2026-03-27 19:49:23\"}',NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,'2026-03-27 12:49:23'),(2,2,NULL,NULL,'CREATE',NULL,'{\"nik\": \"3201011234560002\", \"name\": \"Siti Nurhaliza\", \"created_at\": \"2026-03-27 19:49:23\"}',NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,'2026-03-27 12:49:23'),(3,3,NULL,NULL,'CREATE',NULL,'{\"nik\": \"3201011234560003\", \"name\": \"Budi Santoso\", \"created_at\": \"2026-03-27 19:49:23\"}',NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,'2026-03-27 12:49:23');
/*!40000 ALTER TABLE `audit_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bank_accounts`
--

DROP TABLE IF EXISTS `bank_accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `bank_accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `person_id` int(11) NOT NULL COMMENT 'Person ID',
  `bank_name` varchar(50) NOT NULL COMMENT 'Nama bank',
  `bank_code` varchar(10) DEFAULT NULL COMMENT 'Kode bank',
  `account_number` varchar(25) NOT NULL COMMENT 'Nomor rekening',
  `account_name` varchar(100) NOT NULL COMMENT 'Nama pemegang rekening',
  `account_type` enum('Tabungan','Giro','Deposito','Kredit','Syariah','Digital','Lainnya') DEFAULT 'Tabungan',
  `currency` varchar(3) DEFAULT 'IDR' COMMENT 'Mata uang',
  `branch_office` varchar(100) DEFAULT NULL COMMENT 'Nama cabang bank',
  `branch_address` text DEFAULT NULL COMMENT 'Alamat cabang',
  `opening_date` date DEFAULT NULL COMMENT 'Tanggal buka rekening',
  `balance` decimal(15,2) DEFAULT 0.00 COMMENT 'Saldo rekening',
  `overdraft_limit` decimal(15,2) DEFAULT 0.00 COMMENT 'Batas overdraft',
  `interest_rate` decimal(5,4) DEFAULT NULL COMMENT 'Suku bunga',
  `is_joint_account` tinyint(1) DEFAULT 0 COMMENT 'Rekening bersama',
  `joint_account_holders` text DEFAULT NULL COMMENT 'Pemegang rekening bersama',
  `is_primary` tinyint(1) DEFAULT 0 COMMENT 'Rekening utama',
  `is_active` tinyint(1) DEFAULT 1 COMMENT 'Status aktif',
  `is_dormant` tinyint(1) DEFAULT 0 COMMENT 'Status dormant',
  `last_transaction_date` date DEFAULT NULL COMMENT 'Tanggal transaksi terakhir',
  `atm_card` tinyint(1) DEFAULT 1 COMMENT 'Memiliki kartu ATM',
  `mobile_banking` tinyint(1) DEFAULT 1 COMMENT 'Aktif mobile banking',
  `internet_banking` tinyint(1) DEFAULT 1 COMMENT 'Aktif internet banking',
  `notes` text DEFAULT NULL COMMENT 'Catatan tambahan',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_account_number` (`bank_name`,`account_number`),
  KEY `idx_person` (`person_id`),
  KEY `idx_bank_name` (`bank_name`),
  KEY `idx_account_number` (`account_number`),
  KEY `idx_account_type` (`account_type`),
  KEY `idx_currency` (`currency`),
  KEY `idx_is_primary` (`is_primary`),
  KEY `idx_is_active` (`is_active`),
  KEY `idx_balance` (`balance`),
  CONSTRAINT `bank_accounts_ibfk_1` FOREIGN KEY (`person_id`) REFERENCES `persons` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bank_accounts`
--

LOCK TABLES `bank_accounts` WRITE;
/*!40000 ALTER TABLE `bank_accounts` DISABLE KEYS */;
INSERT INTO `bank_accounts` VALUES (1,1,'BCA','014','1234567890','Ahmad Sudirman','Tabungan','IDR','KC Jakarta Pusat',NULL,'2005-01-15',0.00,0.00,NULL,0,NULL,1,1,0,NULL,1,1,1,NULL,'2026-03-27 12:49:24','2026-03-27 12:49:24'),(2,1,'Mandiri','008','0987654321','Ahmad Sudirman','Tabungan','IDR','KC Jakarta Pusat',NULL,'2010-03-20',0.00,0.00,NULL,0,NULL,0,1,0,NULL,1,1,1,NULL,'2026-03-27 12:49:24','2026-03-27 12:49:24'),(3,2,'BRI','002','1111222233','Siti Nurhaliza','Tabungan','IDR','KC Bandung',NULL,'2010-07-01',0.00,0.00,NULL,0,NULL,1,1,0,NULL,1,1,1,NULL,'2026-03-27 12:49:24','2026-03-27 12:49:24'),(4,3,'BNI','009','4444555566','Budi Santoso','Tabungan','IDR','KC Surabaya',NULL,'2008-02-10',0.00,0.00,NULL,0,NULL,1,1,0,NULL,1,1,1,NULL,'2026-03-27 12:49:24','2026-03-27 12:49:24');
/*!40000 ALTER TABLE `bank_accounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `business_records`
--

DROP TABLE IF EXISTS `business_records`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `business_records` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `person_id` int(11) NOT NULL COMMENT 'Person ID (owner)',
  `business_name` varchar(100) NOT NULL COMMENT 'Nama usaha',
  `business_type` enum('Toko','Restoran','Jasa','Manufaktur','Teknologi','Pertanian','Perdagangan','Transportasi','Kesehatan','Pendidikan','Lainnya') NOT NULL,
  `business_category` varchar(50) DEFAULT NULL COMMENT 'Kategori usaha detail',
  `legal_entity` enum('Perorangan','CV','PT','Firma','Yayasan','Koperasi','Lainnya') DEFAULT 'Perorangan',
  `registration_number` varchar(50) DEFAULT NULL COMMENT 'Nomor registrasi usaha',
  `tax_id` varchar(30) DEFAULT NULL COMMENT 'NPWP perusahaan',
  `business_license` varchar(50) DEFAULT NULL COMMENT 'Nomor izin usaha',
  `license_expiry` date DEFAULT NULL COMMENT 'Masa berlaku izin',
  `start_date` date DEFAULT NULL COMMENT 'Tanggal mulai usaha',
  `description` text DEFAULT NULL COMMENT 'Deskripsi usaha',
  `products_services` text DEFAULT NULL COMMENT 'Produk/jasa',
  `business_address` text DEFAULT NULL COMMENT 'Alamat usaha',
  `business_city` varchar(50) DEFAULT NULL COMMENT 'Kota usaha',
  `business_province` varchar(50) DEFAULT NULL COMMENT 'Provinsi usaha',
  `business_phone` varchar(15) DEFAULT NULL COMMENT 'Telepon usaha',
  `business_email` varchar(100) DEFAULT NULL COMMENT 'Email usaha',
  `business_website` varchar(100) DEFAULT NULL COMMENT 'Website usaha',
  `business_social_media` text DEFAULT NULL COMMENT 'Media sosial usaha',
  `annual_revenue` decimal(15,2) DEFAULT NULL COMMENT 'Omzet tahunan',
  `monthly_revenue` decimal(12,2) DEFAULT NULL COMMENT 'Omzet bulanan',
  `monthly_expense` decimal(12,2) DEFAULT NULL COMMENT 'Biaya bulanan',
  `profit_margin` decimal(5,2) DEFAULT NULL COMMENT 'Margin profit (%)',
  `number_of_employees` int(11) DEFAULT 0 COMMENT 'Jumlah karyawan',
  `business_status` enum('Aktif','Tidak Aktif','Dijual','Ditutup','Lainnya') DEFAULT 'Aktif',
  `ownership_percentage` decimal(5,2) DEFAULT 100.00 COMMENT 'Persentase kepemilikan',
  `is_primary_business` tinyint(1) DEFAULT 1 COMMENT 'Usaha utama',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_person` (`person_id`),
  KEY `idx_business_name` (`business_name`),
  KEY `idx_business_type` (`business_type`),
  KEY `idx_legal_entity` (`legal_entity`),
  KEY `idx_start_date` (`start_date`),
  KEY `idx_business_status` (`business_status`),
  KEY `idx_annual_revenue` (`annual_revenue`),
  KEY `idx_number_of_employees` (`number_of_employees`),
  CONSTRAINT `business_records_ibfk_1` FOREIGN KEY (`person_id`) REFERENCES `persons` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `business_records`
--

LOCK TABLES `business_records` WRITE;
/*!40000 ALTER TABLE `business_records` DISABLE KEYS */;
INSERT INTO `business_records` VALUES (1,1,'Toko Ahmad','Perdagangan','Semako','Perorangan',NULL,NULL,NULL,NULL,'2005-01-01','Toko sembako dan kebutuhan harian',NULL,'Pasar Senen Blok A No. 10, Jakarta Pusat',NULL,NULL,'08123456789',NULL,NULL,NULL,36000000.00,3000000.00,2000000.00,NULL,2,'Aktif',100.00,1,'2026-03-27 12:49:24','2026-03-27 12:49:24'),(2,2,'Warung Siti','Perdagangan','Kelontong','Perorangan',NULL,NULL,NULL,NULL,'2010-06-01','Warung kelontong dan kebutuhan rumah tangga',NULL,'Jl. Sudirman No. 456, Bandung',NULL,NULL,'08234567890',NULL,NULL,NULL,30000000.00,2500000.00,1500000.00,NULL,0,'Aktif',100.00,1,'2026-03-27 12:49:24','2026-03-27 12:49:24');
/*!40000 ALTER TABLE `business_records` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contacts`
--

DROP TABLE IF EXISTS `contacts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `person_id` int(11) NOT NULL COMMENT 'Person ID',
  `contact_type` enum('Personal','Business','Emergency','Reference','Social','Professional') NOT NULL,
  `contact_name` varchar(100) NOT NULL COMMENT 'Nama kontak',
  `relationship` varchar(50) DEFAULT NULL COMMENT 'Hubungan dengan person',
  `organization` varchar(100) DEFAULT NULL COMMENT 'Organisasi/perusahaan',
  `position` varchar(100) DEFAULT NULL COMMENT 'Jabatan',
  `phone` varchar(15) DEFAULT NULL COMMENT 'Nomor telepon',
  `phone2` varchar(15) DEFAULT NULL COMMENT 'Nomor telepon cadangan',
  `whatsapp` varchar(15) DEFAULT NULL COMMENT 'Nomor WhatsApp',
  `email` varchar(100) DEFAULT NULL COMMENT 'Email',
  `address` text DEFAULT NULL COMMENT 'Alamat',
  `city` varchar(50) DEFAULT NULL COMMENT 'Kota',
  `province` varchar(50) DEFAULT NULL COMMENT 'Provinsi',
  `postal_code` varchar(5) DEFAULT NULL COMMENT 'Kode pos',
  `country` varchar(50) DEFAULT 'Indonesia' COMMENT 'Negara',
  `is_primary` tinyint(1) DEFAULT 0 COMMENT 'Kontak utama',
  `is_active` tinyint(1) DEFAULT 1 COMMENT 'Status aktif',
  `notes` text DEFAULT NULL COMMENT 'Catatan tambahan',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_person` (`person_id`),
  KEY `idx_contact_type` (`contact_type`),
  KEY `idx_phone` (`phone`),
  KEY `idx_whatsapp` (`whatsapp`),
  KEY `idx_email` (`email`),
  KEY `idx_is_primary` (`is_primary`),
  KEY `idx_is_active` (`is_active`),
  CONSTRAINT `contacts_ibfk_1` FOREIGN KEY (`person_id`) REFERENCES `persons` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contacts`
--

LOCK TABLES `contacts` WRITE;
/*!40000 ALTER TABLE `contacts` DISABLE KEYS */;
INSERT INTO `contacts` VALUES (1,1,'Emergency','Dr. Andi Wijaya','Dokter Pribadi',NULL,NULL,'08567890123',NULL,'08567890123','andi.wijaya@hospital.com','Rumah Sakit Medika, Jl. Healthcare No. 100',NULL,NULL,NULL,'Indonesia',1,1,NULL,'2026-03-27 12:49:23','2026-03-27 12:49:23'),(2,2,'Business','Haji Ahmad','Supplier',NULL,NULL,'08678901234',NULL,'08678901234','haji.ahmad@supplier.com','Pasar Grosir, Blok B No. 50',NULL,NULL,NULL,'Indonesia',0,1,NULL,'2026-03-27 12:49:23','2026-03-27 12:49:23'),(3,3,'Reference','Prof. Dr. Siti Aminah','Mentor',NULL,NULL,'08789012345',NULL,'08789012345','siti.aminah@university.ac.id','Universitas Negeri, Kampus A',NULL,NULL,NULL,'Indonesia',1,1,NULL,'2026-03-27 12:49:23','2026-03-27 12:49:23');
/*!40000 ALTER TABLE `contacts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `digital_identities`
--

DROP TABLE IF EXISTS `digital_identities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `digital_identities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `person_id` int(11) NOT NULL COMMENT 'Person ID',
  `platform` varchar(50) NOT NULL COMMENT 'Platform (Google, Apple, Facebook, dll)',
  `platform_user_id` varchar(100) DEFAULT NULL COMMENT 'User ID di platform',
  `username` varchar(100) DEFAULT NULL COMMENT 'Username',
  `email` varchar(100) DEFAULT NULL COMMENT 'Email terkait',
  `phone` varchar(15) DEFAULT NULL COMMENT 'Phone terkait',
  `auth_method` enum('Email','Phone','OAuth2','SAML','LDAP','Biometric','Lainnya') DEFAULT NULL COMMENT 'Metode autentikasi',
  `last_login` timestamp NULL DEFAULT NULL COMMENT 'Login terakhir',
  `is_active` tinyint(1) DEFAULT 1 COMMENT 'Status aktif',
  `is_verified` tinyint(1) DEFAULT 0 COMMENT 'Status terverifikasi',
  `verification_date` timestamp NULL DEFAULT NULL COMMENT 'Tanggal verifikasi',
  `permissions` text DEFAULT NULL COMMENT 'Permissions/hak akses',
  `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Data tambahan (JSON)' CHECK (json_valid(`metadata`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_person` (`person_id`),
  KEY `idx_platform` (`platform`),
  KEY `idx_platform_user_id` (`platform_user_id`),
  KEY `idx_username` (`username`),
  KEY `idx_email` (`email`),
  KEY `idx_phone` (`phone`),
  KEY `idx_is_active` (`is_active`),
  KEY `idx_is_verified` (`is_verified`),
  KEY `idx_last_login` (`last_login`),
  CONSTRAINT `digital_identities_ibfk_1` FOREIGN KEY (`person_id`) REFERENCES `persons` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `digital_identities`
--

LOCK TABLES `digital_identities` WRITE;
/*!40000 ALTER TABLE `digital_identities` DISABLE KEYS */;
/*!40000 ALTER TABLE `digital_identities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `documents`
--

DROP TABLE IF EXISTS `documents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `documents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `person_id` int(11) NOT NULL COMMENT 'Person ID',
  `document_type` enum('KTP','KK','AKTA_KELAHIRAN','AKTA_PERKAWINAN','AKTA_CERAI','NPWP','BPJS_Kesehatan','BPJS_Ketenagakerjaan','SIM','PASPOR','IJAZAH','SERTIFIKAT','SURAT_REFERENSI','SURAT_KETERANGAN','FOTO','TANDA_TANGAN','KARTU_IDENTITAS','LAINNYA') NOT NULL,
  `document_number` varchar(50) DEFAULT NULL COMMENT 'Nomor dokumen',
  `document_name` varchar(200) DEFAULT NULL COMMENT 'Nama dokumen',
  `issuing_authority` varchar(100) DEFAULT NULL COMMENT 'Penerbit dokumen',
  `issue_date` date DEFAULT NULL COMMENT 'Tanggal terbit',
  `expiry_date` date DEFAULT NULL COMMENT 'Masa berlaku',
  `file_path` varchar(255) NOT NULL COMMENT 'Path file dokumen',
  `file_name` varchar(255) NOT NULL COMMENT 'Nama file asli',
  `file_size` int(11) DEFAULT NULL COMMENT 'Ukuran file (bytes)',
  `file_type` varchar(50) DEFAULT NULL COMMENT 'Tipe file (PDF, JPG, PNG, dll)',
  `mime_type` varchar(100) DEFAULT NULL COMMENT 'MIME type',
  `checksum` varchar(64) DEFAULT NULL COMMENT 'Checksum file (SHA-256)',
  `is_verified` tinyint(1) DEFAULT 0 COMMENT 'Status verifikasi',
  `verification_method` enum('Manual','OCR','API','Blockchain','Lainnya') DEFAULT NULL COMMENT 'Metode verifikasi',
  `verified_by` int(11) DEFAULT NULL COMMENT 'Diverifikasi oleh',
  `verified_at` timestamp NULL DEFAULT NULL COMMENT 'Tanggal verifikasi',
  `verification_notes` text DEFAULT NULL COMMENT 'Catatan verifikasi',
  `is_public` tinyint(1) DEFAULT 0 COMMENT 'Dapat diakses publik',
  `access_level` enum('Private','Internal','Public','Restricted') DEFAULT 'Private' COMMENT 'Level akses',
  `tags` text DEFAULT NULL COMMENT 'Tag/kategori',
  `description` text DEFAULT NULL COMMENT 'Deskripsi dokumen',
  `language` varchar(10) DEFAULT 'id' COMMENT 'Bahasa dokumen',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_person` (`person_id`),
  KEY `idx_document_type` (`document_type`),
  KEY `idx_document_number` (`document_number`),
  KEY `idx_issuing_authority` (`issuing_authority`),
  KEY `idx_issue_date` (`issue_date`),
  KEY `idx_expiry_date` (`expiry_date`),
  KEY `idx_is_verified` (`is_verified`),
  KEY `idx_verification_method` (`verification_method`),
  KEY `idx_access_level` (`access_level`),
  KEY `idx_created_at` (`created_at`),
  KEY `idx_expiry_warning` (`expiry_date`,`is_verified`),
  CONSTRAINT `documents_ibfk_1` FOREIGN KEY (`person_id`) REFERENCES `persons` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `documents`
--

LOCK TABLES `documents` WRITE;
/*!40000 ALTER TABLE `documents` DISABLE KEYS */;
INSERT INTO `documents` VALUES (1,1,'KTP','3201011234560001',NULL,'Dinas Kependudukan','2020-01-15','2030-01-15','/uploads/ktp/3201011234560001.jpg','KTP_Ahmad.jpg',NULL,'JPG',NULL,NULL,1,NULL,NULL,NULL,NULL,0,'Private',NULL,NULL,'id','2026-03-27 12:49:24','2026-03-27 12:49:24'),(2,1,'KK','3201011234560001',NULL,'Dinas Kependudukan','2020-01-15','2030-01-15','/uploads/kk/3201011234560001.jpg','KK_Ahmad.jpg',NULL,'JPG',NULL,NULL,1,NULL,NULL,NULL,NULL,0,'Private',NULL,NULL,'id','2026-03-27 12:49:24','2026-03-27 12:49:24'),(3,1,'NPWP','123456789012345',NULL,'Direktorat Jenderal Pajak','2018-03-10',NULL,'/uploads/npwp/123456789012345.jpg','NPWP_Ahmad.jpg',NULL,'JPG',NULL,NULL,1,NULL,NULL,NULL,NULL,0,'Private',NULL,NULL,'id','2026-03-27 12:49:24','2026-03-27 12:49:24'),(4,2,'KTP','3201011234560002',NULL,'Dinas Kependudukan','2021-02-20','2031-02-20','/uploads/ktp/3201011234560002.jpg','KTP_Siti.jpg',NULL,'JPG',NULL,NULL,1,NULL,NULL,NULL,NULL,0,'Private',NULL,NULL,'id','2026-03-27 12:49:24','2026-03-27 12:49:24'),(5,2,'KK','3201011234560002',NULL,'Dinas Kependudukan','2021-02-20','2031-02-20','/uploads/kk/3201011234560002.jpg','KK_Siti.jpg',NULL,'JPG',NULL,NULL,1,NULL,NULL,NULL,NULL,0,'Private',NULL,NULL,'id','2026-03-27 12:49:24','2026-03-27 12:49:24'),(6,2,'NPWP','234567890123456',NULL,'Direktorat Jenderal Pajak','2019-05-15',NULL,'/uploads/npwp/234567890123456.jpg','NPWP_Siti.jpg',NULL,'JPG',NULL,NULL,1,NULL,NULL,NULL,NULL,0,'Private',NULL,NULL,'id','2026-03-27 12:49:24','2026-03-27 12:49:24'),(7,3,'KTP','3201011234560003',NULL,'Dinas Kependudukan','2019-07-10','2029-07-10','/uploads/ktp/3201011234560003.jpg','KTP_Budi.jpg',NULL,'JPG',NULL,NULL,1,NULL,NULL,NULL,NULL,0,'Private',NULL,NULL,'id','2026-03-27 12:49:24','2026-03-27 12:49:24'),(8,3,'KK','3201011234560003',NULL,'Dinas Kependudukan','2019-07-10','2029-07-10','/uploads/kk/3201011234560003.jpg','KK_Budi.jpg',NULL,'JPG',NULL,NULL,1,NULL,NULL,NULL,NULL,0,'Private',NULL,NULL,'id','2026-03-27 12:49:24','2026-03-27 12:49:24'),(9,3,'NPWP','345678901234567',NULL,'Direktorat Jenderal Pajak','2017-09-20',NULL,'/uploads/npwp/345678901234567.jpg','NPWP_Budi.jpg',NULL,'JPG',NULL,NULL,1,NULL,NULL,NULL,NULL,0,'Private',NULL,NULL,'id','2026-03-27 12:49:24','2026-03-27 12:49:24');
/*!40000 ALTER TABLE `documents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `education_records`
--

DROP TABLE IF EXISTS `education_records`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `education_records` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `person_id` int(11) NOT NULL COMMENT 'Person ID',
  `education_level` enum('TK','SD','SMP','SMA','SMK','MA','D1','D2','D3','D4','S1','S2','S3','Profesi','Sertifikat','Kursus','Lainnya') NOT NULL,
  `institution_name` varchar(100) NOT NULL COMMENT 'Nama institusi',
  `institution_type` enum('Negeri','Swasta','Internasional','Online') DEFAULT 'Negeri',
  `major_field` varchar(100) DEFAULT NULL COMMENT 'Jurusan/Program studi',
  `specialization` varchar(100) DEFAULT NULL COMMENT 'Spesialisasi',
  `start_date` date DEFAULT NULL COMMENT 'Tanggal mulai',
  `end_date` date DEFAULT NULL COMMENT 'Tanggal selesai',
  `graduation_date` date DEFAULT NULL COMMENT 'Tanggal wisuda',
  `gpa` decimal(3,2) DEFAULT NULL COMMENT 'IPK/Nilai rata-rata',
  `max_gpa` decimal(3,2) DEFAULT 4.00 COMMENT 'Skala maksimum GPA',
  `thesis_title` varchar(200) DEFAULT NULL COMMENT 'Judul tesis/skripsi',
  `achievement` varchar(200) DEFAULT NULL COMMENT 'Prestasi/capaian',
  `certificate_number` varchar(50) DEFAULT NULL COMMENT 'Nomor ijazah/sertifikat',
  `certificate_path` varchar(255) DEFAULT NULL COMMENT 'Path file ijazah/sertifikat',
  `is_completed` tinyint(1) DEFAULT 0 COMMENT 'Status selesai',
  `is_current` tinyint(1) DEFAULT 0 COMMENT 'Sedang berjalan',
  `notes` text DEFAULT NULL COMMENT 'Catatan tambahan',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_person` (`person_id`),
  KEY `idx_education_level` (`education_level`),
  KEY `idx_institution_name` (`institution_name`),
  KEY `idx_major_field` (`major_field`),
  KEY `idx_start_date` (`start_date`),
  KEY `idx_end_date` (`end_date`),
  KEY `idx_is_completed` (`is_completed`),
  KEY `idx_is_current` (`is_current`),
  CONSTRAINT `education_records_ibfk_1` FOREIGN KEY (`person_id`) REFERENCES `persons` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `education_records`
--

LOCK TABLES `education_records` WRITE;
/*!40000 ALTER TABLE `education_records` DISABLE KEYS */;
INSERT INTO `education_records` VALUES (1,1,'SMA','SMA Negeri 1 Jakarta','Negeri','IPA',NULL,'1998-07-01','2003-06-30','2003-06-30',3.25,4.00,NULL,NULL,NULL,NULL,1,0,NULL,'2026-03-27 12:49:23','2026-03-27 12:49:23'),(2,2,'S1','Universitas Padjadjaran','Negeri','Manajemen',NULL,'2006-07-01','2010-06-30','2010-06-30',3.45,4.00,NULL,NULL,NULL,NULL,1,0,NULL,'2026-03-27 12:49:23','2026-03-27 12:49:23'),(3,3,'S2','Universitas Airlangga','Negeri','Pendidikan',NULL,'2003-07-01','2005-06-30','2005-06-30',3.75,4.00,NULL,NULL,NULL,NULL,1,0,NULL,'2026-03-27 12:49:23','2026-03-27 12:49:23');
/*!40000 ALTER TABLE `education_records` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employment_records`
--

DROP TABLE IF EXISTS `employment_records`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `employment_records` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `person_id` int(11) NOT NULL COMMENT 'Person ID',
  `company_name` varchar(100) NOT NULL COMMENT 'Nama perusahaan/instansi',
  `company_type` enum('Pemerintah','BUMN','Swasta','Multinasional','Startup','NGO','Pendidikan','Kesehatan','Sendiri','Lainnya') NOT NULL,
  `industry_sector` varchar(50) DEFAULT NULL COMMENT 'Sektor industri',
  `position` varchar(100) NOT NULL COMMENT 'Jabatan/posisi',
  `department` varchar(100) DEFAULT NULL COMMENT 'Departemen',
  `level` enum('Staff','Supervisor','Manager','Senior Manager','Director','VP','C-Level','Owner','Lainnya') DEFAULT NULL COMMENT 'Level jabatan',
  `employment_type` enum('Tetap','Kontrak','Freelance','Part-time','Magang','Volunteer','Sendiri','Lainnya') NOT NULL,
  `start_date` date NOT NULL COMMENT 'Tanggal mulai kerja',
  `end_date` date DEFAULT NULL COMMENT 'Tanggal selesai kerja',
  `is_current` tinyint(1) DEFAULT 0 COMMENT 'Sedang bekerja',
  `salary` decimal(12,2) DEFAULT NULL COMMENT 'Gaji bulanan',
  `salary_currency` varchar(3) DEFAULT 'IDR' COMMENT 'Mata uang gaji',
  `benefits` text DEFAULT NULL COMMENT 'Benefit/fasilitas',
  `work_address` text DEFAULT NULL COMMENT 'Alamat kerja',
  `work_city` varchar(50) DEFAULT NULL COMMENT 'Kota kerja',
  `work_province` varchar(50) DEFAULT NULL COMMENT 'Provinsi kerja',
  `work_phone` varchar(15) DEFAULT NULL COMMENT 'Telepon kantor',
  `work_email` varchar(100) DEFAULT NULL COMMENT 'Email kantor',
  `supervisor_name` varchar(100) DEFAULT NULL COMMENT 'Nama atasan',
  `supervisor_phone` varchar(15) DEFAULT NULL COMMENT 'Telepon atasan',
  `supervisor_email` varchar(100) DEFAULT NULL COMMENT 'Email atasan',
  `duties` text DEFAULT NULL COMMENT 'Tugas dan tanggung jawab',
  `achievements` text DEFAULT NULL COMMENT 'Pencapaian/prestasi',
  `reason_for_leaving` text DEFAULT NULL COMMENT 'Alasan keluar',
  `reference_available` tinyint(1) DEFAULT 0 COMMENT 'Referensi tersedia',
  `reference_contact` varchar(100) DEFAULT NULL COMMENT 'Kontak referensi',
  `certificate_path` varchar(255) DEFAULT NULL COMMENT 'Path file sertifikat kerja',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_person` (`person_id`),
  KEY `idx_company_name` (`company_name`),
  KEY `idx_position` (`position`),
  KEY `idx_employment_type` (`employment_type`),
  KEY `idx_start_date` (`start_date`),
  KEY `idx_end_date` (`end_date`),
  KEY `idx_is_current` (`is_current`),
  KEY `idx_salary` (`salary`),
  CONSTRAINT `employment_records_ibfk_1` FOREIGN KEY (`person_id`) REFERENCES `persons` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employment_records`
--

LOCK TABLES `employment_records` WRITE;
/*!40000 ALTER TABLE `employment_records` DISABLE KEYS */;
INSERT INTO `employment_records` VALUES (1,1,'Pasar Senen','Sendiri',NULL,'Pedagang',NULL,'Owner','Sendiri','2005-01-01',NULL,1,3000000.00,'IDR',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-03-27 12:49:24','2026-03-27 12:49:24'),(2,2,'Warung Siti','Sendiri',NULL,'Pemilik Warung',NULL,'Owner','Sendiri','2010-06-01',NULL,1,2500000.00,'IDR',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-03-27 12:49:24','2026-03-27 12:49:24'),(3,3,'Dinas Pendidikan Kota Surabaya','Pemerintah',NULL,'Guru Honorer',NULL,'Staff','Kontrak','2008-01-01',NULL,1,8000000.00,'IDR',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-03-27 12:49:24','2026-03-27 12:49:24');
/*!40000 ALTER TABLE `employment_records` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `family_relationships`
--

DROP TABLE IF EXISTS `family_relationships`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `family_relationships` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `person1_id` int(11) NOT NULL COMMENT 'Person ID 1',
  `person2_id` int(11) NOT NULL COMMENT 'Person ID 2',
  `relationship_type` enum('Ayah','Ibu','Anak','Suami','Istri','Kakak','Adik','Kakek','Nenek','Cucu','Paman','Bibi','Keponakan','Sepupu','Mertua','Menantu','Ipar','Lainnya') NOT NULL,
  `relationship_level` enum('1','2','3','4','5+') DEFAULT NULL COMMENT 'Tingkat hubungan (1=orang tua, 2=saudara, 3=sepupu, dst)',
  `is_primary` tinyint(1) DEFAULT 0 COMMENT 'Hubungan utama (untuk suami/istri)',
  `is_legal_guardian` tinyint(1) DEFAULT 0 COMMENT 'Wali hukum',
  `is_emergency_contact` tinyint(1) DEFAULT 0 COMMENT 'Kontak darurat',
  `custody_level` enum('Full','Partial','None') DEFAULT 'None' COMMENT 'Tingkat perwalian',
  `financial_responsibility` enum('Full','Partial','None') DEFAULT 'None' COMMENT 'Tanggung jawab finansial',
  `verification_status` enum('Pending','Verified','Rejected') DEFAULT 'Pending',
  `verified_by` int(11) DEFAULT NULL COMMENT 'Diverifikasi oleh',
  `verified_at` timestamp NULL DEFAULT NULL COMMENT 'Tanggal verifikasi',
  `notes` text DEFAULT NULL COMMENT 'Catatan hubungan',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_relationship` (`person1_id`,`person2_id`,`relationship_type`),
  KEY `idx_person1` (`person1_id`),
  KEY `idx_person2` (`person2_id`),
  KEY `idx_relationship_type` (`relationship_type`),
  KEY `idx_relationship_level` (`relationship_level`),
  KEY `idx_is_primary` (`is_primary`),
  KEY `idx_is_legal_guardian` (`is_legal_guardian`),
  KEY `idx_is_emergency_contact` (`is_emergency_contact`),
  KEY `idx_verification_status` (`verification_status`),
  CONSTRAINT `family_relationships_ibfk_1` FOREIGN KEY (`person1_id`) REFERENCES `persons` (`id`) ON DELETE CASCADE,
  CONSTRAINT `family_relationships_ibfk_2` FOREIGN KEY (`person2_id`) REFERENCES `persons` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `family_relationships`
--

LOCK TABLES `family_relationships` WRITE;
/*!40000 ALTER TABLE `family_relationships` DISABLE KEYS */;
INSERT INTO `family_relationships` VALUES (1,1,2,'Suami','1',1,1,0,'None','None','Verified',NULL,NULL,NULL,'2026-03-27 12:49:23','2026-03-27 12:49:23'),(2,1,3,'Kakak','2',0,0,0,'None','None','Verified',NULL,NULL,NULL,'2026-03-27 12:49:23','2026-03-27 12:49:23');
/*!40000 ALTER TABLE `family_relationships` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `health_records`
--

DROP TABLE IF EXISTS `health_records`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `health_records` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `person_id` int(11) NOT NULL COMMENT 'Person ID',
  `record_type` enum('Medical','Dental','Vision','Mental','Vaccination','Checkup','Emergency','Surgery','Lainnya') NOT NULL,
  `provider_name` varchar(100) DEFAULT NULL COMMENT 'Nama provider/fasilitas kesehatan',
  `provider_type` enum('Rumah Sakit','Klinik','Puskesmas','Dokter Praktik','Apotek','Lainnya') DEFAULT NULL COMMENT 'Tipe provider',
  `doctor_name` varchar(100) DEFAULT NULL COMMENT 'Nama dokter',
  `doctor_specialization` varchar(50) DEFAULT NULL COMMENT 'Spesialisasi dokumen',
  `visit_date` date NOT NULL COMMENT 'Tanggal kunjungan',
  `diagnosis` text DEFAULT NULL COMMENT 'Diagnosis',
  `symptoms` text DEFAULT NULL COMMENT 'Gejala',
  `treatment` text DEFAULT NULL COMMENT 'Pengobatan/tindakan',
  `medications` text DEFAULT NULL COMMENT 'Obat-obatan',
  `prescription` varchar(100) DEFAULT NULL COMMENT 'Nomor resep',
  `allergies` text DEFAULT NULL COMMENT 'Alergi yang ditemukan',
  `blood_pressure` varchar(20) DEFAULT NULL COMMENT 'Tekanan darah',
  `heart_rate` int(11) DEFAULT NULL COMMENT 'Denyut jantung',
  `weight` decimal(5,2) DEFAULT NULL COMMENT 'Berat badan',
  `height` decimal(5,2) DEFAULT NULL COMMENT 'Tinggi badan',
  `temperature` decimal(4,1) DEFAULT NULL COMMENT 'Suhu tubuh',
  `blood_sugar` varchar(20) DEFAULT NULL COMMENT 'Gula darah',
  `cholesterol` varchar(20) DEFAULT NULL COMMENT 'Kolesterol',
  `notes` text DEFAULT NULL COMMENT 'Catatan tambahan',
  `follow_up_required` tinyint(1) DEFAULT 0 COMMENT 'Perlu follow-up',
  `follow_up_date` date DEFAULT NULL COMMENT 'Tanggal follow-up',
  `is_confidential` tinyint(1) DEFAULT 1 COMMENT 'Informasi rahasia',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_person` (`person_id`),
  KEY `idx_record_type` (`record_type`),
  KEY `idx_provider_name` (`provider_name`),
  KEY `idx_doctor_name` (`doctor_name`),
  KEY `idx_visit_date` (`visit_date`),
  KEY `idx_diagnosis` (`diagnosis`(100)),
  KEY `idx_follow_up_date` (`follow_up_date`),
  KEY `idx_is_confidential` (`is_confidential`),
  CONSTRAINT `health_records_ibfk_1` FOREIGN KEY (`person_id`) REFERENCES `persons` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `health_records`
--

LOCK TABLES `health_records` WRITE;
/*!40000 ALTER TABLE `health_records` DISABLE KEYS */;
/*!40000 ALTER TABLE `health_records` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `person_complete_profile`
--

DROP TABLE IF EXISTS `person_complete_profile`;
/*!50001 DROP VIEW IF EXISTS `person_complete_profile`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `person_complete_profile` AS SELECT
 1 AS `id`,
  1 AS `nik`,
  1 AS `kk_number`,
  1 AS `name`,
  1 AS `name_alias`,
  1 AS `birth_place`,
  1 AS `birth_date`,
  1 AS `age`,
  1 AS `gender`,
  1 AS `religion`,
  1 AS `blood_type`,
  1 AS `nationality`,
  1 AS `height`,
  1 AS `weight`,
  1 AS `phone`,
  1 AS `whatsapp`,
  1 AS `email`,
  1 AS `address_detail`,
  1 AS `rt`,
  1 AS `rw`,
  1 AS `postal_code`,
  1 AS `occupation`,
  1 AS `workplace`,
  1 AS `monthly_income`,
  1 AS `annual_income`,
  1 AS `business_type`,
  1 AS `education_level`,
  1 AS `marital_status`,
  1 AS `spouse_name`,
  1 AS `number_of_children`,
  1 AS `npwp`,
  1 AS `bpjs_kesehatan`,
  1 AS `bpjs_ketenagakerjaan`,
  1 AS `credit_score`,
  1 AS `risk_level`,
  1 AS `verification_status`,
  1 AS `is_active`,
  1 AS `is_blacklisted`,
  1 AS `is_deceased`,
  1 AS `death_date`,
  1 AS `created_at`,
  1 AS `updated_at`,
  1 AS `verified_family_count`,
  1 AS `active_contacts_count`,
  1 AS `completed_education_count`,
  1 AS `current_employment_count`,
  1 AS `active_business_count`,
  1 AS `active_bank_accounts_count`,
  1 AS `verified_documents_count`,
  1 AS `health_records_count` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `person_risk_assessment`
--

DROP TABLE IF EXISTS `person_risk_assessment`;
/*!50001 DROP VIEW IF EXISTS `person_risk_assessment`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `person_risk_assessment` AS SELECT
 1 AS `id`,
  1 AS `name`,
  1 AS `nik`,
  1 AS `phone`,
  1 AS `email`,
  1 AS `credit_score`,
  1 AS `risk_level`,
  1 AS `monthly_income`,
  1 AS `annual_income`,
  1 AS `business_type`,
  1 AS `marital_status`,
  1 AS `number_of_children`,
  1 AS `education_level`,
  1 AS `occupation`,
  1 AS `is_blacklisted`,
  1 AS `is_watchlist`,
  1 AS `calculated_risk`,
  1 AS `income_family_ratio`,
  1 AS `employment_stability`,
  1 AS `business_profitability`,
  1 AS `blacklisted_family_count`,
  1 AS `verified_documents_count`,
  1 AS `age_factor`,
  1 AS `member_since` */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `persons`
--

DROP TABLE IF EXISTS `persons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `persons` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nik` varchar(16) NOT NULL COMMENT 'Nomor Induk Kependudukan (16 digit)',
  `kk_number` varchar(16) DEFAULT NULL COMMENT 'Nomor Kartu Keluarga',
  `name` varchar(100) NOT NULL COMMENT 'Nama lengkap sesuai KTP',
  `name_alias` varchar(100) DEFAULT NULL COMMENT 'Nama panggilan/alias',
  `birth_place` varchar(50) DEFAULT NULL COMMENT 'Tempat lahir',
  `birth_date` date DEFAULT NULL COMMENT 'Tanggal lahir (YYYY-MM-DD)',
  `gender` enum('L','P') DEFAULT NULL COMMENT 'Jenis kelamin: L=Laki-laki, P=Perempuan',
  `religion` enum('Islam','Kristen','Katolik','Hindu','Budha','Konghucu','Lainnya','Tidak Ada') DEFAULT 'Islam',
  `blood_type` enum('A','B','AB','O','Tidak Tahu') DEFAULT NULL COMMENT 'Golongan darah',
  `nationality` varchar(50) DEFAULT 'WNI' COMMENT 'Kewarganegaraan',
  `height` decimal(5,2) DEFAULT NULL COMMENT 'Tinggi badan (cm)',
  `weight` decimal(5,2) DEFAULT NULL COMMENT 'Berat badan (kg)',
  `hair_color` varchar(20) DEFAULT NULL COMMENT 'Warna rambut',
  `eye_color` varchar(20) DEFAULT NULL COMMENT 'Warna mata',
  `skin_color` varchar(20) DEFAULT NULL COMMENT 'Warna kulit',
  `distinguishing_marks` text DEFAULT NULL COMMENT 'Ciri-ciri khusus/tato/luka',
  `phone` varchar(15) DEFAULT NULL COMMENT 'Nomor telepon/HP utama',
  `phone2` varchar(15) DEFAULT NULL COMMENT 'Nomor telepon/HP cadangan',
  `whatsapp` varchar(15) DEFAULT NULL COMMENT 'Nomor WhatsApp',
  `telegram` varchar(30) DEFAULT NULL COMMENT 'Username Telegram',
  `instagram` varchar(50) DEFAULT NULL COMMENT 'Username Instagram',
  `facebook` varchar(50) DEFAULT NULL COMMENT 'Username Facebook',
  `email` varchar(100) DEFAULT NULL COMMENT 'Email utama',
  `email2` varchar(100) DEFAULT NULL COMMENT 'Email cadangan',
  `website` varchar(100) DEFAULT NULL COMMENT 'Website personal (jika ada)',
  `address_detail` text DEFAULT NULL COMMENT 'Alamat lengkap (jalan, RT/RW)',
  `rt` varchar(3) DEFAULT NULL COMMENT 'RT (Rukun Tetangga)',
  `rw` varchar(3) DEFAULT NULL COMMENT 'RW (Rukun Warga)',
  `postal_code` varchar(5) DEFAULT NULL COMMENT 'Kode pos',
  `address_type` enum('Rumah','Kantor','Usaha','Kos','Lainnya') DEFAULT 'Rumah',
  `occupation` varchar(100) DEFAULT NULL COMMENT 'Pekerjaan utama',
  `occupation_code` varchar(20) DEFAULT NULL COMMENT 'Kode pekerjaan (BPS)',
  `workplace` varchar(100) DEFAULT NULL COMMENT 'Nama tempat kerja',
  `work_address` text DEFAULT NULL COMMENT 'Alamat tempat kerja',
  `work_phone` varchar(15) DEFAULT NULL COMMENT 'Telepon kantor',
  `work_email` varchar(100) DEFAULT NULL COMMENT 'Email kantor',
  `monthly_income` decimal(12,2) DEFAULT NULL COMMENT 'Pendapatan bulanan',
  `annual_income` decimal(15,2) DEFAULT NULL COMMENT 'Pendapatan tahunan',
  `business_type` enum('PNS','Swasta','Wiraswasta','Pedagang','Petani','Nelayan','Buruh','Pelajar','Mahasiswa','Pensiun','Tidak Bekerja','Lainnya') DEFAULT NULL COMMENT 'Jenis pekerjaan',
  `industry_sector` varchar(50) DEFAULT NULL COMMENT 'Sektor industri',
  `company_name` varchar(100) DEFAULT NULL COMMENT 'Nama perusahaan',
  `position` varchar(100) DEFAULT NULL COMMENT 'Jabatan',
  `employment_status` enum('Tetap','Kontrak','Freelance','Part-time','Magang','Tidak Bekerja') DEFAULT NULL COMMENT 'Status pekerjaan',
  `education_level` enum('Tidak Sekolah','SD','SMP','SMA','D1','D2','D3','D4','S1','S2','S3','Profesi','Lainnya') DEFAULT NULL COMMENT 'Tingkat pendidikan tertinggi',
  `education_major` varchar(100) DEFAULT NULL COMMENT 'Jurusan pendidikan',
  `education_institution` varchar(100) DEFAULT NULL COMMENT 'Nama institusi pendidikan',
  `graduation_year` int(11) DEFAULT NULL COMMENT 'Tahun lulus',
  `gpa` decimal(3,2) DEFAULT NULL COMMENT 'IPK (jika applicable)',
  `marital_status` enum('Belum Menikah','Menikah','Cerai Hidup','Cerai Mati','Janda','Duda') DEFAULT 'Belum Menikah',
  `spouse_name` varchar(100) DEFAULT NULL COMMENT 'Nama suami/istri',
  `spouse_nik` varchar(16) DEFAULT NULL COMMENT 'NIK suami/istri',
  `spouse_phone` varchar(15) DEFAULT NULL COMMENT 'Telepon suami/istri',
  `spouse_occupation` varchar(100) DEFAULT NULL COMMENT 'Pekerjaan suami/istri',
  `number_of_children` int(11) DEFAULT 0 COMMENT 'Jumlah anak',
  `father_name` varchar(100) DEFAULT NULL COMMENT 'Nama ayah',
  `father_nik` varchar(16) DEFAULT NULL COMMENT 'NIK ayah',
  `father_occupation` varchar(100) DEFAULT NULL COMMENT 'Pekerjaan ayah',
  `mother_name` varchar(100) DEFAULT NULL COMMENT 'Nama ibu',
  `mother_nik` varchar(16) DEFAULT NULL COMMENT 'NIK ibu',
  `mother_occupation` varchar(100) DEFAULT NULL COMMENT 'Pekerjaan ibu',
  `npwp` varchar(20) DEFAULT NULL COMMENT 'Nomor Pokok Wajib Pajak',
  `bpjs_kesehatan` varchar(13) DEFAULT NULL COMMENT 'Nomor BPJS Kesehatan',
  `bpjs_ketenagakerjaan` varchar(15) DEFAULT NULL COMMENT 'Nomor BPJS Ketenagakerjaan',
  `jamsostek` varchar(11) DEFAULT NULL COMMENT 'Nomor Jamsostek (legacy)',
  `passport_number` varchar(20) DEFAULT NULL COMMENT 'Nomor paspor',
  `passport_expiry` date DEFAULT NULL COMMENT 'Masa berlaku paspor',
  `sim_type` enum('A','B1','B2','C','D','Tidak Ada') DEFAULT NULL COMMENT 'Jenis SIM',
  `sim_number` varchar(20) DEFAULT NULL COMMENT 'Nomor SIM',
  `sim_expiry` date DEFAULT NULL COMMENT 'Masa berlaku SIM',
  `health_condition` text DEFAULT NULL COMMENT 'Kondisi kesehatan umum',
  `chronic_diseases` text DEFAULT NULL COMMENT 'Penyakit kronis (jika ada)',
  `allergies` text DEFAULT NULL COMMENT 'Alergi',
  `medications` text DEFAULT NULL COMMENT 'Obat-obatan rutin',
  `blood_pressure` varchar(20) DEFAULT NULL COMMENT 'Tekanan darah',
  `blood_sugar` varchar(20) DEFAULT NULL COMMENT 'Gula darah',
  `disability` enum('Tidak Ada','Fisik','Sensorik','Mental','Intelektual','Multiple') DEFAULT 'Tidak Ada' COMMENT 'Disabilitas',
  `disability_description` text DEFAULT NULL COMMENT 'Deskripsi disabilitas',
  `photo_path` varchar(255) DEFAULT NULL COMMENT 'Path foto profil',
  `ktp_photo_path` varchar(255) DEFAULT NULL COMMENT 'Path foto KTP',
  `kk_photo_path` varchar(255) DEFAULT NULL COMMENT 'Path foto KK',
  `signature_path` varchar(255) DEFAULT NULL COMMENT 'Path tanda tangan digital',
  `fingerprint_data` text DEFAULT NULL COMMENT 'Data sidik jari (encrypted)',
  `face_recognition_data` text DEFAULT NULL COMMENT 'Data pengenalan wajah (encrypted)',
  `bank_account_count` int(11) DEFAULT 0 COMMENT 'Jumlah rekening bank',
  `credit_card_count` int(11) DEFAULT 0 COMMENT 'Jumlah kartu kredit',
  `credit_score` int(11) DEFAULT 0 COMMENT 'Skor kredit (0-100)',
  `credit_rating` enum('Excellent','Good','Fair','Poor','Very Poor') DEFAULT NULL COMMENT 'Rating kredit',
  `bankruptcy_status` tinyint(1) DEFAULT 0 COMMENT 'Status pailit/kebangkrutan',
  `risk_level` enum('Rendah','Sedang','Tinggi','Sangat Tinggi') DEFAULT 'Sedang' COMMENT 'Tingkat risiko',
  `is_blacklisted` tinyint(1) DEFAULT 0 COMMENT 'Daftar hitam',
  `blacklist_reason` text DEFAULT NULL COMMENT 'Alasan blacklist',
  `is_watchlist` tinyint(1) DEFAULT 0 COMMENT 'Daftar pantauan',
  `watchlist_reason` text DEFAULT NULL COMMENT 'Alasan watchlist',
  `hobbies` text DEFAULT NULL COMMENT 'Hobi',
  `interests` text DEFAULT NULL COMMENT 'Minat/ketertarikan',
  `skills` text DEFAULT NULL COMMENT 'Keahlian/keterampilan',
  `languages` text DEFAULT NULL COMMENT 'Bahasa yang dikuasai',
  `preferred_contact` enum('Phone','WhatsApp','Email','SMS','Surat') DEFAULT 'Phone' COMMENT 'Preferensi kontak',
  `is_active` tinyint(1) DEFAULT 1 COMMENT 'Status aktif',
  `is_deceased` tinyint(1) DEFAULT 0 COMMENT 'Status meninggal',
  `death_date` date DEFAULT NULL COMMENT 'Tanggal meninggal',
  `verification_status` enum('Pending','Verified','Rejected','Expired') DEFAULT 'Pending' COMMENT 'Status verifikasi',
  `verification_date` timestamp NULL DEFAULT NULL COMMENT 'Tanggal verifikasi',
  `verified_by` int(11) DEFAULT NULL COMMENT 'Diverifikasi oleh (user_id)',
  `last_login` timestamp NULL DEFAULT NULL COMMENT 'Login terakhir',
  `last_activity` timestamp NULL DEFAULT NULL COMMENT 'Aktivitas terakhir',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `created_by` int(11) DEFAULT NULL COMMENT 'Dibuat oleh (user_id)',
  `updated_by` int(11) DEFAULT NULL COMMENT 'Diupdate oleh (user_id)',
  PRIMARY KEY (`id`),
  UNIQUE KEY `nik` (`nik`),
  UNIQUE KEY `uk_phone` (`phone`),
  UNIQUE KEY `uk_phone2` (`phone2`),
  UNIQUE KEY `uk_whatsapp` (`whatsapp`),
  UNIQUE KEY `uk_email` (`email`),
  UNIQUE KEY `uk_email2` (`email2`),
  UNIQUE KEY `uk_npwp` (`npwp`),
  UNIQUE KEY `uk_bpjs_kesehatan` (`bpjs_kesehatan`),
  UNIQUE KEY `uk_bpjs_ketenagakerjaan` (`bpjs_ketenagakerjaan`),
  UNIQUE KEY `uk_passport_number` (`passport_number`),
  UNIQUE KEY `uk_sim_number` (`sim_number`),
  KEY `idx_nik` (`nik`),
  KEY `idx_name` (`name`),
  KEY `idx_name_alias` (`name_alias`),
  KEY `idx_phone` (`phone`),
  KEY `idx_phone2` (`phone2`),
  KEY `idx_whatsapp` (`whatsapp`),
  KEY `idx_email` (`email`),
  KEY `idx_email2` (`email2`),
  KEY `idx_kk_number` (`kk_number`),
  KEY `idx_spouse_nik` (`spouse_nik`),
  KEY `idx_father_nik` (`father_nik`),
  KEY `idx_mother_nik` (`mother_nik`),
  KEY `idx_npwp` (`npwp`),
  KEY `idx_bpjs_kesehatan` (`bpjs_kesehatan`),
  KEY `idx_bpjs_ketenagakerjaan` (`bpjs_ketenagakerjaan`),
  KEY `idx_passport_number` (`passport_number`),
  KEY `idx_sim_number` (`sim_number`),
  KEY `idx_marital_status` (`marital_status`),
  KEY `idx_occupation` (`occupation`),
  KEY `idx_business_type` (`business_type`),
  KEY `idx_education_level` (`education_level`),
  KEY `idx_credit_score` (`credit_score`),
  KEY `idx_risk_level` (`risk_level`),
  KEY `idx_verification_status` (`verification_status`),
  KEY `idx_is_active` (`is_active`),
  KEY `idx_is_blacklisted` (`is_blacklisted`),
  KEY `idx_is_watchlist` (`is_watchlist`),
  KEY `idx_created_at` (`created_at`),
  KEY `idx_updated_at` (`updated_at`),
  KEY `idx_birth_date` (`birth_date`),
  KEY `idx_death_date` (`death_date`),
  KEY `idx_last_login` (`last_login`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `persons`
--

LOCK TABLES `persons` WRITE;
/*!40000 ALTER TABLE `persons` DISABLE KEYS */;
INSERT INTO `persons` VALUES (1,'3201011234560001','3201011234560001','Ahmad Sudirman','Pak Ahmad','Jakarta','1985-05-15','L','Islam','A','WNI',NULL,NULL,NULL,NULL,NULL,NULL,'08123456789',NULL,'08123456789',NULL,NULL,NULL,'ahmad.sudirman@email.com',NULL,NULL,'Jl. Merdeka No. 123, Kelurahan Menteng','001','002','12345','Rumah','Pedagang',NULL,'Pasar Senen','Pasar Senen Blok A No. 10, Jakarta Pusat',NULL,NULL,3000000.00,36000000.00,'Pedagang',NULL,NULL,NULL,NULL,'SMA',NULL,'SMA Negeri 1 Jakarta',2003,NULL,'Menikah','Siti Nurhaliza',NULL,'08234567890',NULL,2,'Budi Santoso',NULL,NULL,'Siti Rohani',NULL,NULL,'123456789012345','0001234567890','0001234567890',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Tidak Ada',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,75,NULL,0,'Sedang',0,NULL,0,NULL,NULL,NULL,NULL,NULL,'Phone',1,0,NULL,'Verified',NULL,NULL,NULL,NULL,'2026-03-27 12:49:23','2026-03-27 12:49:23',1,NULL),(2,'3201011234560002','3201011234560002','Siti Nurhaliza','Bu Siti','Bandung','1988-08-20','P','Islam','B','WNI',NULL,NULL,NULL,NULL,NULL,NULL,'08234567890',NULL,'08234567890',NULL,NULL,NULL,'siti.nurhaliza@email.com',NULL,NULL,'Jl. Sudirman No. 456, Kelurahan Sukajadi','003','004','54321','Rumah','Pengusaha',NULL,'Warung Siti','Jl. Sudirman No. 456, Bandung',NULL,NULL,2500000.00,30000000.00,'Wiraswasta',NULL,NULL,NULL,NULL,'S1',NULL,'Universitas Padjadjaran',2010,NULL,'Menikah','Ahmad Sudirman',NULL,'08123456789',NULL,2,'Ahmad Wijaya',NULL,NULL,'Dewi Sartika',NULL,NULL,'234567890123456','0002345678901','0002345678901',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Tidak Ada',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,70,NULL,0,'Sedang',0,NULL,0,NULL,NULL,NULL,NULL,NULL,'Phone',1,0,NULL,'Verified',NULL,NULL,NULL,NULL,'2026-03-27 12:49:23','2026-03-27 12:49:23',1,NULL),(3,'3201011234560003','3201011234560003','Budi Santoso','Pak Budi','Surabaya','1980-03-10','L','Islam','O','WNI',NULL,NULL,NULL,NULL,NULL,NULL,'08345678901',NULL,'08345678901',NULL,NULL,NULL,'budi.santoso@email.com',NULL,NULL,'Jl. Gubernur Suryo No. 789, Kelurahan Genteng','005','006','65432','Rumah','PNS',NULL,'Dinas Pendidikan','Dinas Pendidikan Kota Surabaya',NULL,NULL,8000000.00,96000000.00,'PNS',NULL,NULL,NULL,NULL,'S2',NULL,'Universitas Airlangga',2005,NULL,'Menikah','Ratna Sari',NULL,'08456789012',NULL,3,'Suprapto',NULL,NULL,'Sumarni',NULL,NULL,'345678901234567','0003456789012','0003456789012',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Tidak Ada',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,85,NULL,0,'Rendah',0,NULL,0,NULL,NULL,NULL,NULL,NULL,'Phone',1,0,NULL,'Verified',NULL,NULL,NULL,NULL,'2026-03-27 12:49:23','2026-03-27 12:49:23',1,NULL);
/*!40000 ALTER TABLE `persons` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER IF NOT EXISTS tr_person_audit_log
AFTER INSERT ON persons
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (person_id, action, new_values, user_id)
    VALUES (NEW.id, 'CREATE', 
            JSON_OBJECT('nik', NEW.nik, 'name', NEW.name, 'created_at', NEW.created_at), 
            NEW.created_by);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER IF NOT EXISTS tr_person_update_risk_assessment
AFTER UPDATE ON persons
FOR EACH ROW
BEGIN
    IF NEW.annual_income <> OLD.annual_income OR 
       NEW.business_type <> OLD.business_type OR 
       NEW.marital_status <> OLD.marital_status OR
       NEW.number_of_children <> OLD.number_of_children OR
       NEW.education_level <> OLD.education_level OR
       NEW.occupation <> OLD.occupation OR
       NEW.is_blacklisted <> OLD.is_blacklisted THEN
        CALL CalculateUniversalCreditScore(NEW.id);
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER IF NOT EXISTS tr_person_audit_log_update
AFTER UPDATE ON persons
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (person_id, action, old_values, new_values, user_id)
    VALUES (NEW.id, 'UPDATE', 
            JSON_OBJECT('nik', OLD.nik, 'name', OLD.name, 'updated_at', OLD.updated_at),
            JSON_OBJECT('nik', NEW.nik, 'name', NEW.name, 'updated_at', NEW.updated_at), 
            NEW.updated_by);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `preferences`
--

DROP TABLE IF EXISTS `preferences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `preferences` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `person_id` int(11) NOT NULL COMMENT 'Person ID',
  `preference_category` varchar(50) NOT NULL COMMENT 'Kategori preferensi',
  `preference_key` varchar(100) NOT NULL COMMENT 'Key preferensi',
  `preference_value` text DEFAULT NULL COMMENT 'Value preferensi',
  `data_type` enum('String','Number','Boolean','JSON','Date','Time') DEFAULT 'String' COMMENT 'Tipe data',
  `is_system` tinyint(1) DEFAULT 0 COMMENT 'Preferensi sistem',
  `is_public` tinyint(1) DEFAULT 0 COMMENT 'Dapat diakses publik',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_preference` (`person_id`,`preference_category`,`preference_key`),
  KEY `idx_person` (`person_id`),
  KEY `idx_category` (`preference_category`),
  KEY `idx_key` (`preference_key`),
  KEY `idx_is_system` (`is_system`),
  KEY `idx_is_public` (`is_public`),
  CONSTRAINT `preferences_ibfk_1` FOREIGN KEY (`person_id`) REFERENCES `persons` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `preferences`
--

LOCK TABLES `preferences` WRITE;
/*!40000 ALTER TABLE `preferences` DISABLE KEYS */;
INSERT INTO `preferences` VALUES (1,1,'notification','email_notifications','true','Boolean',0,0,'2026-03-27 12:49:24','2026-03-27 12:49:24'),(2,1,'notification','sms_notifications','false','Boolean',0,0,'2026-03-27 12:49:24','2026-03-27 12:49:24'),(3,1,'language','preferred_language','id','String',0,0,'2026-03-27 12:49:24','2026-03-27 12:49:24'),(4,1,'privacy','share_contact_info','family_only','String',0,0,'2026-03-27 12:49:24','2026-03-27 12:49:24'),(5,2,'notification','whatsapp_notifications','true','Boolean',0,0,'2026-03-27 12:49:24','2026-03-27 12:49:24'),(6,2,'language','preferred_language','id','String',0,0,'2026-03-27 12:49:24','2026-03-27 12:49:24'),(7,3,'notification','email_notifications','true','Boolean',0,0,'2026-03-27 12:49:24','2026-03-27 12:49:24'),(8,3,'privacy','share_contact_info','public','String',0,0,'2026-03-27 12:49:24','2026-03-27 12:49:24');
/*!40000 ALTER TABLE `preferences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `person_complete_profile`
--

/*!50001 DROP VIEW IF EXISTS `person_complete_profile`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `person_complete_profile` AS select `p`.`id` AS `id`,`p`.`nik` AS `nik`,`p`.`kk_number` AS `kk_number`,`p`.`name` AS `name`,`p`.`name_alias` AS `name_alias`,`p`.`birth_place` AS `birth_place`,`p`.`birth_date` AS `birth_date`,timestampdiff(YEAR,`p`.`birth_date`,curdate()) AS `age`,`p`.`gender` AS `gender`,`p`.`religion` AS `religion`,`p`.`blood_type` AS `blood_type`,`p`.`nationality` AS `nationality`,`p`.`height` AS `height`,`p`.`weight` AS `weight`,`p`.`phone` AS `phone`,`p`.`whatsapp` AS `whatsapp`,`p`.`email` AS `email`,`p`.`address_detail` AS `address_detail`,`p`.`rt` AS `rt`,`p`.`rw` AS `rw`,`p`.`postal_code` AS `postal_code`,`p`.`occupation` AS `occupation`,`p`.`workplace` AS `workplace`,`p`.`monthly_income` AS `monthly_income`,`p`.`annual_income` AS `annual_income`,`p`.`business_type` AS `business_type`,`p`.`education_level` AS `education_level`,`p`.`marital_status` AS `marital_status`,`p`.`spouse_name` AS `spouse_name`,`p`.`number_of_children` AS `number_of_children`,`p`.`npwp` AS `npwp`,`p`.`bpjs_kesehatan` AS `bpjs_kesehatan`,`p`.`bpjs_ketenagakerjaan` AS `bpjs_ketenagakerjaan`,`p`.`credit_score` AS `credit_score`,`p`.`risk_level` AS `risk_level`,`p`.`verification_status` AS `verification_status`,`p`.`is_active` AS `is_active`,`p`.`is_blacklisted` AS `is_blacklisted`,`p`.`is_deceased` AS `is_deceased`,`p`.`death_date` AS `death_date`,`p`.`created_at` AS `created_at`,`p`.`updated_at` AS `updated_at`,(select count(0) from `family_relationships` `fr` where (`fr`.`person1_id` = `p`.`id` or `fr`.`person2_id` = `p`.`id`) and `fr`.`verification_status` = 'Verified') AS `verified_family_count`,(select count(0) from `contacts` `c` where `c`.`person_id` = `p`.`id` and `c`.`is_active` = 1) AS `active_contacts_count`,(select count(0) from `education_records` `er` where `er`.`person_id` = `p`.`id` and `er`.`is_completed` = 1) AS `completed_education_count`,(select count(0) from `employment_records` `emr` where `emr`.`person_id` = `p`.`id` and `emr`.`is_current` = 1) AS `current_employment_count`,(select count(0) from `business_records` `br` where `br`.`person_id` = `p`.`id` and `br`.`business_status` = 'Aktif') AS `active_business_count`,(select count(0) from `bank_accounts` `ba` where `ba`.`person_id` = `p`.`id` and `ba`.`is_active` = 1) AS `active_bank_accounts_count`,(select count(0) from `documents` `d` where `d`.`person_id` = `p`.`id` and `d`.`is_verified` = 1) AS `verified_documents_count`,(select count(0) from `health_records` `hr` where `hr`.`person_id` = `p`.`id`) AS `health_records_count` from `persons` `p` where `p`.`is_active` = 1 */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `person_risk_assessment`
--

/*!50001 DROP VIEW IF EXISTS `person_risk_assessment`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `person_risk_assessment` AS select `p`.`id` AS `id`,`p`.`name` AS `name`,`p`.`nik` AS `nik`,`p`.`phone` AS `phone`,`p`.`email` AS `email`,`p`.`credit_score` AS `credit_score`,`p`.`risk_level` AS `risk_level`,`p`.`monthly_income` AS `monthly_income`,`p`.`annual_income` AS `annual_income`,`p`.`business_type` AS `business_type`,`p`.`marital_status` AS `marital_status`,`p`.`number_of_children` AS `number_of_children`,`p`.`education_level` AS `education_level`,`p`.`occupation` AS `occupation`,`p`.`is_blacklisted` AS `is_blacklisted`,`p`.`is_watchlist` AS `is_watchlist`,case when `p`.`credit_score` >= 80 then 'Rendah' when `p`.`credit_score` >= 60 then 'Sedang' when `p`.`credit_score` >= 40 then 'Tinggi' else 'Sangat Tinggi' end AS `calculated_risk`,case when `p`.`annual_income` > 0 and `p`.`number_of_children` > 0 then case when `p`.`annual_income` / (`p`.`number_of_children` + 1) > 24000000 then 'Baik' when `p`.`annual_income` / (`p`.`number_of_children` + 1) > 12000000 then 'Cukup' else 'Kurang' end else 'Baik' end AS `income_family_ratio`,case when `emr`.`employment_type` in ('Tetap','PNS','BUMN') then 'Stabil' when `emr`.`employment_type` in ('Kontrak','Freelance') then 'Sedang Stabil' else 'Tidak Stabil' end AS `employment_stability`,case when `br`.`annual_revenue` > 0 and `br`.`monthly_expense` > 0 then case when (`br`.`annual_revenue` - `br`.`monthly_expense` * 12) / `br`.`annual_revenue` > 0.3 then 'Profitable' when (`br`.`annual_revenue` - `br`.`monthly_expense` * 12) / `br`.`annual_revenue` > 0.1 then 'Breakeven' else 'Loss Making' end else 'Unknown' end AS `business_profitability`,(select count(0) from (`family_relationships` `fr` join `persons` `p2` on(`fr`.`person1_id` = `p2`.`id` or `fr`.`person2_id` = `p2`.`id`)) where (`fr`.`person1_id` = `p`.`id` or `fr`.`person2_id` = `p`.`id`) and `p2`.`is_blacklisted` = 1) AS `blacklisted_family_count`,(select count(0) from `documents` `d` where `d`.`person_id` = `p`.`id` and `d`.`is_verified` = 1) AS `verified_documents_count`,case when timestampdiff(YEAR,`p`.`birth_date`,curdate()) between 25 and 55 then 'Optimal' when timestampdiff(YEAR,`p`.`birth_date`,curdate()) between 18 and 65 then 'Good' else 'Risk' end AS `age_factor`,`p`.`created_at` AS `member_since` from ((`persons` `p` left join `employment_records` `emr` on(`p`.`id` = `emr`.`person_id` and `emr`.`is_current` = 1)) left join `business_records` `br` on(`p`.`id` = `br`.`person_id` and `br`.`is_primary_business` = 1)) where `p`.`is_active` = 1 */;
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

-- Dump completed on 2026-03-27 22:02:11
