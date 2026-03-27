/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19  Distrib 10.6.23-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: schema_app
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
-- Table structure for table `accounts`
--

DROP TABLE IF EXISTS `accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account_code` varchar(20) NOT NULL COMMENT 'Kode akun',
  `account_name` varchar(100) NOT NULL COMMENT 'Nama akun',
  `account_type` enum('aset','kewajiban','ekuitas','pendapatan','beban') NOT NULL COMMENT 'Tipe akun',
  `account_category` enum('current','non_current','operating','investing','financing') DEFAULT NULL COMMENT 'Kategori akun',
  `parent_id` int(11) DEFAULT NULL COMMENT 'ID akun induk',
  `level` int(11) DEFAULT 1 COMMENT 'Tingkat akun',
  `normal_balance` enum('debit','credit') NOT NULL COMMENT 'Saldo normal',
  `description` text DEFAULT NULL COMMENT 'Deskripsi akun',
  `is_active` tinyint(1) DEFAULT 1 COMMENT 'Status aktif',
  `is_consolidated` tinyint(1) DEFAULT 0 COMMENT 'Dikonsolidasi',
  `is_budget_account` tinyint(1) DEFAULT 0 COMMENT 'Akun anggaran',
  `is_tax_account` tinyint(1) DEFAULT 0 COMMENT 'Akun pajak',
  `is_restricted` tinyint(1) DEFAULT 0 COMMENT 'Akun terbatas',
  `opening_balance` decimal(15,2) DEFAULT 0.00 COMMENT 'Saldo awal',
  `opening_balance_date` date DEFAULT NULL COMMENT 'Tanggal saldo awal',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `created_by` int(11) DEFAULT NULL COMMENT 'Dibuat oleh',
  `updated_by` int(11) DEFAULT NULL COMMENT 'Diupdate oleh',
  PRIMARY KEY (`id`),
  UNIQUE KEY `account_code` (`account_code`),
  KEY `created_by` (`created_by`),
  KEY `updated_by` (`updated_by`),
  KEY `idx_account_code` (`account_code`),
  KEY `idx_account_type` (`account_type`),
  KEY `idx_parent_id` (`parent_id`),
  KEY `idx_level` (`level`),
  KEY `idx_is_active` (`is_active`),
  CONSTRAINT `accounts_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `accounts` (`id`),
  CONSTRAINT `accounts_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  CONSTRAINT `accounts_ibfk_3` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accounts`
--

LOCK TABLES `accounts` WRITE;
/*!40000 ALTER TABLE `accounts` DISABLE KEYS */;
/*!40000 ALTER TABLE `accounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `branches`
--

DROP TABLE IF EXISTS `branches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `branches` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `unit_id` int(11) NOT NULL COMMENT 'Unit induk',
  `name` varchar(100) NOT NULL COMMENT 'Nama cabang',
  `code` varchar(20) NOT NULL COMMENT 'Kode cabang',
  `branch_type` enum('pusat','cabang_utama','cabang','unit_pelayanan') DEFAULT 'cabang',
  `head_user_id` int(11) DEFAULT NULL COMMENT 'Kepala cabang',
  `manager_user_id` int(11) DEFAULT NULL COMMENT 'Manager cabang',
  `address_id` int(11) DEFAULT NULL COMMENT 'ID alamat (schema_address)',
  `phone` varchar(15) DEFAULT NULL COMMENT 'Telepon cabang',
  `phone2` varchar(15) DEFAULT NULL COMMENT 'Telepon cadangan',
  `email` varchar(100) DEFAULT NULL COMMENT 'Email cabang',
  `website` varchar(100) DEFAULT NULL COMMENT 'Website cabang',
  `operational_area` text DEFAULT NULL COMMENT 'Area operasional',
  `service_hours` varchar(100) DEFAULT NULL COMMENT 'Jam operasional',
  `latitude` decimal(10,8) DEFAULT NULL COMMENT 'Koordinat latitude',
  `longitude` decimal(11,8) DEFAULT NULL COMMENT 'Koordinat longitude',
  `coverage_radius_km` int(11) DEFAULT 5 COMMENT 'Radius cakupan (km)',
  `is_active` tinyint(1) DEFAULT 1 COMMENT 'Status aktif',
  `opening_date` date DEFAULT NULL COMMENT 'Tanggal buka',
  `closing_date` date DEFAULT NULL COMMENT 'Tanggal tutup (jika ada)',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `created_by` int(11) DEFAULT NULL COMMENT 'Dibuat oleh',
  `updated_by` int(11) DEFAULT NULL COMMENT 'Diupdate oleh',
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `idx_unit` (`unit_id`),
  KEY `idx_code` (`code`),
  KEY `idx_branch_type` (`branch_type`),
  KEY `idx_head_user` (`head_user_id`),
  KEY `idx_manager_user` (`manager_user_id`),
  KEY `idx_is_active` (`is_active`),
  KEY `idx_opening_date` (`opening_date`),
  CONSTRAINT `branches_ibfk_1` FOREIGN KEY (`unit_id`) REFERENCES `units` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `branches`
--

LOCK TABLES `branches` WRITE;
/*!40000 ALTER TABLE `branches` DISABLE KEYS */;
/*!40000 ALTER TABLE `branches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `journal_details`
--

DROP TABLE IF EXISTS `journal_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `journal_details` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `journal_id` int(11) NOT NULL COMMENT 'ID jurnal',
  `account_id` int(11) NOT NULL COMMENT 'ID akun',
  `line_number` int(11) NOT NULL COMMENT 'Nomor baris',
  `debit` decimal(15,2) DEFAULT 0.00 COMMENT 'Debit',
  `credit` decimal(15,2) DEFAULT 0.00 COMMENT 'Kredit',
  `amount` decimal(15,2) GENERATED ALWAYS AS (greatest(`debit`,`credit`)) STORED,
  `description` text DEFAULT NULL COMMENT 'Deskripsi baris jurnal',
  `reference_type` varchar(50) DEFAULT NULL COMMENT 'Tipe referensi',
  `reference_id` int(11) DEFAULT NULL COMMENT 'ID referensi',
  `reference_number` varchar(50) DEFAULT NULL COMMENT 'Nomor referensi',
  `notes` text DEFAULT NULL COMMENT 'Catatan baris jurnal',
  `attachments` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Lampiran (JSON)' CHECK (json_valid(`attachments`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_journal_id` (`journal_id`),
  KEY `idx_account_id` (`account_id`),
  KEY `idx_debit` (`debit`),
  KEY `idx_credit` (`credit`),
  KEY `idx_amount` (`amount`),
  KEY `idx_reference` (`reference_type`,`reference_id`),
  CONSTRAINT `journal_details_ibfk_1` FOREIGN KEY (`journal_id`) REFERENCES `journals` (`id`) ON DELETE CASCADE,
  CONSTRAINT `journal_details_ibfk_2` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `journal_details`
--

LOCK TABLES `journal_details` WRITE;
/*!40000 ALTER TABLE `journal_details` DISABLE KEYS */;
/*!40000 ALTER TABLE `journal_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `journals`
--

DROP TABLE IF EXISTS `journals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `journals` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `journal_number` varchar(20) NOT NULL COMMENT 'Nomor jurnal',
  `journal_date` date NOT NULL COMMENT 'Tanggal jurnal',
  `description` text DEFAULT NULL COMMENT 'Deskripsi jurnal',
  `reference_type` varchar(50) DEFAULT NULL COMMENT 'Tipe referensi',
  `reference_id` int(11) DEFAULT NULL COMMENT 'ID referensi',
  `reference_number` varchar(50) DEFAULT NULL COMMENT 'Nomor referensi',
  `status` enum('draft','submitted','approved','rejected','posted','reversed') DEFAULT 'draft',
  `approved_by` int(11) DEFAULT NULL COMMENT 'Disetujui oleh',
  `approved_at` timestamp NULL DEFAULT NULL COMMENT 'Tanggal persetujuan',
  `posted_by` int(11) DEFAULT NULL COMMENT 'Diposting oleh',
  `posted_at` timestamp NULL DEFAULT NULL COMMENT 'Tanggal posting',
  `reversed_by` int(11) DEFAULT NULL COMMENT 'Dibalik oleh',
  `reversed_at` timestamp NULL DEFAULT NULL COMMENT 'Tanggal pembalikan',
  `notes` text DEFAULT NULL COMMENT 'Catatan jurnal',
  `attachments` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Lampiran (JSON)' CHECK (json_valid(`attachments`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `created_by` int(11) NOT NULL COMMENT 'Dibuat oleh',
  `updated_by` int(11) DEFAULT NULL COMMENT 'Diupdate oleh',
  PRIMARY KEY (`id`),
  UNIQUE KEY `journal_number` (`journal_number`),
  KEY `posted_by` (`posted_by`),
  KEY `reversed_by` (`reversed_by`),
  KEY `updated_by` (`updated_by`),
  KEY `idx_journal_number` (`journal_number`),
  KEY `idx_journal_date` (`journal_date`),
  KEY `idx_reference` (`reference_type`,`reference_id`),
  KEY `idx_status` (`status`),
  KEY `idx_approved_by` (`approved_by`),
  KEY `idx_created_by` (`created_by`),
  CONSTRAINT `journals_ibfk_1` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`),
  CONSTRAINT `journals_ibfk_2` FOREIGN KEY (`posted_by`) REFERENCES `users` (`id`),
  CONSTRAINT `journals_ibfk_3` FOREIGN KEY (`reversed_by`) REFERENCES `users` (`id`),
  CONSTRAINT `journals_ibfk_4` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  CONSTRAINT `journals_ibfk_5` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `journals`
--

LOCK TABLES `journals` WRITE;
/*!40000 ALTER TABLE `journals` DISABLE KEYS */;
/*!40000 ALTER TABLE `journals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `loan_products`
--

DROP TABLE IF EXISTS `loan_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `loan_products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL COMMENT 'Nama produk',
  `code` varchar(20) NOT NULL COMMENT 'Kode produk',
  `description` text DEFAULT NULL COMMENT 'Deskripsi produk',
  `product_category` enum('mikro','kecil','menengah','konsumtif','produktif','pendidikan','kesehatan','khusus') DEFAULT 'mikro',
  `min_amount` decimal(12,2) NOT NULL COMMENT 'Minimal pinjaman',
  `max_amount` decimal(12,2) NOT NULL COMMENT 'Maksimal pinjaman',
  `default_amount` decimal(12,2) DEFAULT NULL COMMENT 'Default pinjaman',
  `amount_increment` decimal(8,2) DEFAULT 100000.00 COMMENT 'Kelipatan jumlah',
  `min_tenor_days` int(11) NOT NULL COMMENT 'Minimal tenor (hari)',
  `max_tenor_days` int(11) NOT NULL COMMENT 'Maksimal tenor (hari)',
  `default_tenor_days` int(11) DEFAULT NULL COMMENT 'Default tenor (hari)',
  `tenor_increment_days` int(11) DEFAULT 1 COMMENT 'Kelipatan tenor',
  `interest_rate_monthly` decimal(5,4) NOT NULL COMMENT 'Suku bunga per bulan',
  `interest_type` enum('flat','effective','annuity','declining_balance') DEFAULT 'flat',
  `admin_fee_rate` decimal(5,4) DEFAULT 0.0200 COMMENT 'Biaya admin (%)',
  `admin_fee_fixed` decimal(10,2) DEFAULT 0.00 COMMENT 'Biaya admin tetap',
  `processing_fee_rate` decimal(5,4) DEFAULT 0.0000 COMMENT 'Biaya proses (%)',
  `processing_fee_fixed` decimal(10,2) DEFAULT 0.00 COMMENT 'Biaya proses tetap',
  `late_fee_rate` decimal(5,4) DEFAULT 0.0100 COMMENT 'Denda keterlambatan (%)',
  `late_fee_fixed` decimal(10,2) DEFAULT 0.00 COMMENT 'Denda keterlambatan tetap',
  `early_payment_fee_rate` decimal(5,4) DEFAULT 0.0000 COMMENT 'Biaya pelunasan dini (%)',
  `min_credit_score` int(11) DEFAULT 0 COMMENT 'Skor kredit minimal',
  `max_credit_score` int(11) DEFAULT 100 COMMENT 'Skor kredit maksimal',
  `min_membership_days` int(11) DEFAULT 0 COMMENT 'Lama keanggotaan minimal (hari)',
  `max_age_years` int(11) DEFAULT 0 COMMENT 'Usia maksimal (0=tidak ada)',
  `min_monthly_income` decimal(12,2) DEFAULT NULL COMMENT 'Pendapatan bulanan minimal',
  `required_documents` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Dokumen yang diperlukan (JSON)' CHECK (json_valid(`required_documents`)),
  `collateral_required` tinyint(1) DEFAULT 0 COMMENT 'Jaminan diperlukan',
  `collateral_type` enum('none','personal_guarantee','corporate_guarantee','asset','deposit') DEFAULT 'none',
  `target_member_types` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Tipe member target (JSON)' CHECK (json_valid(`target_member_types`)),
  `target_business_types` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Tipe usaha target (JSON)' CHECK (json_valid(`target_business_types`)),
  `target_income_range` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Range pendapatan target (JSON)' CHECK (json_valid(`target_income_range`)),
  `target_geographic_areas` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Area geografis target (JSON)' CHECK (json_valid(`target_geographic_areas`)),
  `installment_frequency` enum('daily','weekly','biweekly','monthly','quarterly') DEFAULT 'daily',
  `grace_period_days` int(11) DEFAULT 0 COMMENT 'Masa tenggang (hari)',
  `disbursement_method` enum('cash','transfer','digital_wallet') DEFAULT 'transfer',
  `repayment_method` enum('cash','auto_debit','digital_wallet','bank_transfer') DEFAULT 'cash',
  `is_active` tinyint(1) DEFAULT 1 COMMENT 'Status aktif',
  `is_promotional` tinyint(1) DEFAULT 0 COMMENT 'Produk promosi',
  `priority_level` int(11) DEFAULT 0 COMMENT 'Prioritas (0=terendah)',
  `effective_date` date DEFAULT NULL COMMENT 'Tanggal efektif',
  `expiry_date` date DEFAULT NULL COMMENT 'Tanggal kadaluarsa',
  `terms_conditions` text DEFAULT NULL COMMENT 'Syarat dan ketentuan',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `created_by` int(11) DEFAULT NULL COMMENT 'Dibuat oleh',
  `updated_by` int(11) DEFAULT NULL COMMENT 'Diupdate oleh',
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `created_by` (`created_by`),
  KEY `updated_by` (`updated_by`),
  KEY `idx_code` (`code`),
  KEY `idx_product_category` (`product_category`),
  KEY `idx_min_amount` (`min_amount`),
  KEY `idx_max_amount` (`max_amount`),
  KEY `idx_interest_rate` (`interest_rate_monthly`),
  KEY `idx_is_active` (`is_active`),
  KEY `idx_is_promotional` (`is_promotional`),
  KEY `idx_effective_date` (`effective_date`),
  CONSTRAINT `loan_products_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  CONSTRAINT `loan_products_ibfk_2` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `loan_products`
--

LOCK TABLES `loan_products` WRITE;
/*!40000 ALTER TABLE `loan_products` DISABLE KEYS */;
/*!40000 ALTER TABLE `loan_products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `loans`
--

DROP TABLE IF EXISTS `loans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `loans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `application_number` varchar(20) NOT NULL COMMENT 'Nomor aplikasi',
  `member_id` int(11) NOT NULL COMMENT 'ID member',
  `product_id` int(11) NOT NULL COMMENT 'ID produk pinjaman',
  `branch_id` int(11) NOT NULL COMMENT 'ID cabang',
  `collector_id` int(11) DEFAULT NULL COMMENT 'ID kolektor',
  `amount` decimal(12,2) NOT NULL COMMENT 'Jumlah pinjaman',
  `admin_fee` decimal(10,2) NOT NULL COMMENT 'Biaya admin',
  `processing_fee` decimal(10,2) NOT NULL COMMENT 'Biaya proses',
  `insurance_fee` decimal(10,2) DEFAULT 0.00 COMMENT 'Biaya asuransi',
  `other_fees` decimal(10,2) DEFAULT 0.00 COMMENT 'Biaya lain-lain',
  `net_disbursed` decimal(12,2) NOT NULL COMMENT 'Jumlah cair',
  `interest_rate_monthly` decimal(5,4) NOT NULL COMMENT 'Suku bunga per bulan',
  `interest_type` enum('flat','effective','annuity','declining_balance') DEFAULT 'flat',
  `installment_amount` decimal(10,2) NOT NULL COMMENT 'Jumlah angsuran',
  `frequency` enum('daily','weekly','biweekly','monthly') DEFAULT 'daily',
  `total_installments` int(11) NOT NULL COMMENT 'Total angsuran',
  `paid_installments` int(11) DEFAULT 0 COMMENT 'Angsuran terbayang',
  `application_date` date NOT NULL COMMENT 'Tanggal aplikasi',
  `approval_date` date DEFAULT NULL COMMENT 'Tanggal persetujuan',
  `disbursement_date` date DEFAULT NULL COMMENT 'Tanggal pencairan',
  `first_payment_date` date DEFAULT NULL COMMENT 'Tanggal pembayaran pertama',
  `maturity_date` date DEFAULT NULL COMMENT 'Tanggal jatuh tempo',
  `completion_date` date DEFAULT NULL COMMENT 'Tanggal pelunasan',
  `status` enum('draft','submitted','under_review','approved','rejected','disbursed','active','late','defaulted','completed','cancelled') DEFAULT 'draft',
  `rejection_reason` text DEFAULT NULL COMMENT 'Alasan penolakan',
  `cancellation_reason` text DEFAULT NULL COMMENT 'Alasan pembatalan',
  `collateral_type` enum('none','personal_guarantee','corporate_guarantee','asset','deposit','savings') DEFAULT 'none',
  `collateral_value` decimal(12,2) DEFAULT 0.00 COMMENT 'Nilai jaminan',
  `collateral_description` text DEFAULT NULL COMMENT 'Deskripsi jaminan',
  `guarantor_id` int(11) DEFAULT NULL COMMENT 'ID penjamin',
  `guarantor_relationship` varchar(50) DEFAULT NULL COMMENT 'Hubungan penjamin',
  `credit_score_at_application` int(11) DEFAULT NULL COMMENT 'Skor kredit saat aplikasi',
  `risk_level_at_application` enum('low','medium','high','very_high') DEFAULT NULL COMMENT 'Tingkat risiko saat aplikasi',
  `risk_score` decimal(5,2) DEFAULT NULL COMMENT 'Skor risiko (0-100)',
  `risk_factors` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Faktor risiko (JSON)' CHECK (json_valid(`risk_factors`)),
  `total_principal` decimal(12,2) GENERATED ALWAYS AS (`amount`) STORED,
  `total_interest` decimal(12,2) DEFAULT 0.00 COMMENT 'Total bunga',
  `total_late_fees` decimal(12,2) DEFAULT 0.00 COMMENT 'Total denda',
  `total_paid` decimal(12,2) DEFAULT 0.00 COMMENT 'Total terbayar',
  `total_outstanding` decimal(12,2) GENERATED ALWAYS AS (`total_principal` + `total_interest` + `total_late_fees` - `total_paid`) STORED,
  `days_past_due` int(11) DEFAULT 0 COMMENT 'Hari tunggakan',
  `purpose` text DEFAULT NULL COMMENT 'Tujuan pinjaman',
  `notes` text DEFAULT NULL COMMENT 'Catatan tambahan',
  `document_attachments` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Dokumen lampiran (JSON)' CHECK (json_valid(`document_attachments`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `created_by` int(11) NOT NULL COMMENT 'Dibuat oleh',
  `updated_by` int(11) DEFAULT NULL COMMENT 'Diupdate oleh',
  PRIMARY KEY (`id`),
  UNIQUE KEY `application_number` (`application_number`),
  KEY `guarantor_id` (`guarantor_id`),
  KEY `created_by` (`created_by`),
  KEY `updated_by` (`updated_by`),
  KEY `idx_application_number` (`application_number`),
  KEY `idx_member_id` (`member_id`),
  KEY `idx_product_id` (`product_id`),
  KEY `idx_branch_id` (`branch_id`),
  KEY `idx_collector_id` (`collector_id`),
  KEY `idx_status` (`status`),
  KEY `idx_application_date` (`application_date`),
  KEY `idx_disbursement_date` (`disbursement_date`),
  KEY `idx_maturity_date` (`maturity_date`),
  KEY `idx_amount` (`amount`),
  KEY `idx_total_outstanding` (`total_outstanding`),
  KEY `idx_days_past_due` (`days_past_due`),
  CONSTRAINT `loans_ibfk_1` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`),
  CONSTRAINT `loans_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `loan_products` (`id`),
  CONSTRAINT `loans_ibfk_3` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`),
  CONSTRAINT `loans_ibfk_4` FOREIGN KEY (`collector_id`) REFERENCES `users` (`id`),
  CONSTRAINT `loans_ibfk_5` FOREIGN KEY (`guarantor_id`) REFERENCES `members` (`id`),
  CONSTRAINT `loans_ibfk_6` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  CONSTRAINT `loans_ibfk_7` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `loans`
--

LOCK TABLES `loans` WRITE;
/*!40000 ALTER TABLE `loans` DISABLE KEYS */;
/*!40000 ALTER TABLE `loans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `master_banks`
--

DROP TABLE IF EXISTS `master_banks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `master_banks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(10) NOT NULL COMMENT 'Kode bank',
  `name` varchar(100) NOT NULL COMMENT 'Nama bank',
  `short_name` varchar(50) DEFAULT NULL COMMENT 'Nama singkat',
  `bank_type` enum('government','private','foreign','syariah','rural','development') NOT NULL,
  `bic_code` varchar(20) DEFAULT NULL COMMENT 'BIC/SWIFT Code',
  `headquarters` varchar(100) DEFAULT NULL COMMENT 'Kantor pusat',
  `website` varchar(100) DEFAULT NULL COMMENT 'Website',
  `phone` varchar(20) DEFAULT NULL COMMENT 'Telepon',
  `email` varchar(100) DEFAULT NULL COMMENT 'Email',
  `description` text DEFAULT NULL COMMENT 'Deskripsi',
  `is_active` tinyint(1) DEFAULT 1 COMMENT 'Status aktif',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `idx_code` (`code`),
  KEY `idx_name` (`name`),
  KEY `idx_bank_type` (`bank_type`),
  KEY `idx_bic_code` (`bic_code`),
  KEY `idx_is_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `master_banks`
--

LOCK TABLES `master_banks` WRITE;
/*!40000 ALTER TABLE `master_banks` DISABLE KEYS */;
/*!40000 ALTER TABLE `master_banks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `master_blood_types`
--

DROP TABLE IF EXISTS `master_blood_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `master_blood_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(5) NOT NULL COMMENT 'Golongan darah (A, B, AB, O)',
  `name` varchar(20) NOT NULL COMMENT 'Nama lengkap',
  `rhesus_factor` enum('+','-') DEFAULT '+' COMMENT 'Faktor Rhesus',
  `description` text DEFAULT NULL COMMENT 'Deskripsi',
  `is_active` tinyint(1) DEFAULT 1 COMMENT 'Status aktif',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `idx_code` (`code`),
  KEY `idx_name` (`name`),
  KEY `idx_is_active` (`is_active`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `master_blood_types`
--

LOCK TABLES `master_blood_types` WRITE;
/*!40000 ALTER TABLE `master_blood_types` DISABLE KEYS */;
INSERT INTO `master_blood_types` VALUES (1,'A+','A Positif','+','Golongan darah A positif',1,'2026-03-27 12:50:07','2026-03-27 12:50:07'),(2,'A-','A Negatif','-','Golongan darah A negatif',1,'2026-03-27 12:50:07','2026-03-27 12:50:07'),(3,'B+','B Positif','+','Golongan darah B positif',1,'2026-03-27 12:50:07','2026-03-27 12:50:07'),(4,'B-','B Negatif','-','Golongan darah B negatif',1,'2026-03-27 12:50:07','2026-03-27 12:50:07'),(5,'AB+','AB Positif','+','Golongan darah AB positif',1,'2026-03-27 12:50:07','2026-03-27 12:50:07'),(6,'AB-','AB Negatif','-','Golongan darah AB negatif',1,'2026-03-27 12:50:07','2026-03-27 12:50:07'),(7,'O+','O Positif','+','Golongan darah O positif',1,'2026-03-27 12:50:07','2026-03-27 12:50:07'),(8,'O-','O Negatif','-','Golongan darah O negatif',1,'2026-03-27 12:50:07','2026-03-27 12:50:07');
/*!40000 ALTER TABLE `master_blood_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `master_business_types`
--

DROP TABLE IF EXISTS `master_business_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `master_business_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(20) NOT NULL COMMENT 'Kode jenis usaha',
  `name` varchar(100) NOT NULL COMMENT 'Nama jenis usaha',
  `category` varchar(50) DEFAULT NULL COMMENT 'Kategori usaha',
  `description` text DEFAULT NULL COMMENT 'Deskripsi',
  `risk_level` enum('low','medium','high') DEFAULT 'medium' COMMENT 'Tingkat risiko',
  `is_active` tinyint(1) DEFAULT 1 COMMENT 'Status aktif',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `idx_code` (`code`),
  KEY `idx_name` (`name`),
  KEY `idx_category` (`category`),
  KEY `idx_risk_level` (`risk_level`),
  KEY `idx_is_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `master_business_types`
--

LOCK TABLES `master_business_types` WRITE;
/*!40000 ALTER TABLE `master_business_types` DISABLE KEYS */;
/*!40000 ALTER TABLE `master_business_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `master_communication_channels`
--

DROP TABLE IF EXISTS `master_communication_channels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `master_communication_channels` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(20) NOT NULL COMMENT 'Kode channel',
  `name` varchar(50) NOT NULL COMMENT 'Nama channel',
  `type` enum('email','sms','whatsapp','push','in_app','phone_call','mail','other') NOT NULL,
  `description` text DEFAULT NULL COMMENT 'Deskripsi',
  `provider` varchar(100) DEFAULT NULL COMMENT 'Provider',
  `cost_per_unit` decimal(10,4) DEFAULT 0.0000 COMMENT 'Biaya per unit',
  `max_length` int(11) DEFAULT NULL COMMENT 'Maksimal karakter',
  `supports_attachments` tinyint(1) DEFAULT 0 COMMENT 'Mendukung lampiran',
  `is_active` tinyint(1) DEFAULT 1 COMMENT 'Status aktif',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `idx_code` (`code`),
  KEY `idx_name` (`name`),
  KEY `idx_type` (`type`),
  KEY `idx_is_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `master_communication_channels`
--

LOCK TABLES `master_communication_channels` WRITE;
/*!40000 ALTER TABLE `master_communication_channels` DISABLE KEYS */;
/*!40000 ALTER TABLE `master_communication_channels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `master_compliance_statuses`
--

DROP TABLE IF EXISTS `master_compliance_statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `master_compliance_statuses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(20) NOT NULL COMMENT 'Kode status compliance',
  `name` varchar(50) NOT NULL COMMENT 'Nama status',
  `category` enum('kyc','aml','audit','legal','other') NOT NULL,
  `description` text DEFAULT NULL COMMENT 'Deskripsi',
  `next_step` text DEFAULT NULL COMMENT 'Langkah berikutnya',
  `is_active` tinyint(1) DEFAULT 1 COMMENT 'Status aktif',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `idx_code` (`code`),
  KEY `idx_name` (`name`),
  KEY `idx_category` (`category`),
  KEY `idx_is_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `master_compliance_statuses`
--

LOCK TABLES `master_compliance_statuses` WRITE;
/*!40000 ALTER TABLE `master_compliance_statuses` DISABLE KEYS */;
/*!40000 ALTER TABLE `master_compliance_statuses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `master_countries`
--

DROP TABLE IF EXISTS `master_countries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `master_countries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(3) NOT NULL COMMENT 'Kode negara (ISO 3166-1 alpha-3)',
  `name` varchar(100) NOT NULL COMMENT 'Nama negara',
  `name_local` varchar(100) DEFAULT NULL COMMENT 'Nama lokal',
  `continent` varchar(50) DEFAULT NULL COMMENT 'Benua',
  `capital` varchar(100) DEFAULT NULL COMMENT 'Ibukota',
  `currency_code` varchar(3) DEFAULT NULL COMMENT 'Kode mata uang',
  `phone_code` varchar(10) DEFAULT NULL COMMENT 'Kode telepon',
  `is_active` tinyint(1) DEFAULT 1 COMMENT 'Status aktif',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `idx_code` (`code`),
  KEY `idx_name` (`name`),
  KEY `idx_continent` (`continent`),
  KEY `idx_is_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `master_countries`
--

LOCK TABLES `master_countries` WRITE;
/*!40000 ALTER TABLE `master_countries` DISABLE KEYS */;
/*!40000 ALTER TABLE `master_countries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `master_currencies`
--

DROP TABLE IF EXISTS `master_currencies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `master_currencies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(3) NOT NULL COMMENT 'Kode mata uang (ISO 4217)',
  `name` varchar(50) NOT NULL COMMENT 'Nama mata uang',
  `symbol` varchar(10) NOT NULL COMMENT 'Simbol mata uang',
  `decimal_places` int(11) DEFAULT 2 COMMENT 'Jumlah desimal',
  `is_active` tinyint(1) DEFAULT 1 COMMENT 'Status aktif',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `idx_code` (`code`),
  KEY `idx_name` (`name`),
  KEY `idx_is_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `master_currencies`
--

LOCK TABLES `master_currencies` WRITE;
/*!40000 ALTER TABLE `master_currencies` DISABLE KEYS */;
/*!40000 ALTER TABLE `master_currencies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `master_device_types`
--

DROP TABLE IF EXISTS `master_device_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `master_device_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(20) NOT NULL COMMENT 'Kode device',
  `name` varchar(50) NOT NULL COMMENT 'Nama device',
  `category` enum('mobile','tablet','desktop','laptop','other') NOT NULL,
  `os_name` varchar(50) DEFAULT NULL COMMENT 'Nama OS',
  `browser_name` varchar(50) DEFAULT NULL COMMENT 'Nama browser',
  `description` text DEFAULT NULL COMMENT 'Deskripsi',
  `is_active` tinyint(1) DEFAULT 1 COMMENT 'Status aktif',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `idx_code` (`code`),
  KEY `idx_name` (`name`),
  KEY `idx_category` (`category`),
  KEY `idx_os_name` (`os_name`),
  KEY `idx_browser_name` (`browser_name`),
  KEY `idx_is_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `master_device_types`
--

LOCK TABLES `master_device_types` WRITE;
/*!40000 ALTER TABLE `master_device_types` DISABLE KEYS */;
/*!40000 ALTER TABLE `master_device_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `master_document_types`
--

DROP TABLE IF EXISTS `master_document_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `master_document_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(20) NOT NULL COMMENT 'Kode dokumen',
  `name` varchar(100) NOT NULL COMMENT 'Nama dokumen',
  `category` enum('identity','legal','financial','business','education','health','other') NOT NULL,
  `description` text DEFAULT NULL COMMENT 'Deskripsi',
  `is_required` tinyint(1) DEFAULT 0 COMMENT 'Wajib diisi',
  `expiry_required` tinyint(1) DEFAULT 0 COMMENT 'Memiliki masa berlaku',
  `file_types_allowed` text DEFAULT NULL COMMENT 'Tipe file yang diizinkan',
  `max_file_size_mb` int(11) DEFAULT 5 COMMENT 'Ukuran file maksimal (MB)',
  `is_active` tinyint(1) DEFAULT 1 COMMENT 'Status aktif',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `idx_code` (`code`),
  KEY `idx_name` (`name`),
  KEY `idx_category` (`category`),
  KEY `idx_is_required` (`is_required`),
  KEY `idx_is_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `master_document_types`
--

LOCK TABLES `master_document_types` WRITE;
/*!40000 ALTER TABLE `master_document_types` DISABLE KEYS */;
/*!40000 ALTER TABLE `master_document_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `master_education_levels`
--

DROP TABLE IF EXISTS `master_education_levels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `master_education_levels` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(10) NOT NULL COMMENT 'Kode tingkat pendidikan',
  `name` varchar(50) NOT NULL COMMENT 'Nama tingkat pendidikan',
  `level_order` int(11) NOT NULL COMMENT 'Urutan level',
  `description` text DEFAULT NULL COMMENT 'Deskripsi',
  `is_active` tinyint(1) DEFAULT 1 COMMENT 'Status aktif',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `idx_code` (`code`),
  KEY `idx_name` (`name`),
  KEY `idx_level_order` (`level_order`),
  KEY `idx_is_active` (`is_active`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `master_education_levels`
--

LOCK TABLES `master_education_levels` WRITE;
/*!40000 ALTER TABLE `master_education_levels` DISABLE KEYS */;
INSERT INTO `master_education_levels` VALUES (1,'TDS','Tidak Sekolah',0,'Tidak pernah sekolah',1,'2026-03-27 12:50:07','2026-03-27 12:50:07'),(2,'TK','TK',1,'Taman Kanak-Kanak',1,'2026-03-27 12:50:07','2026-03-27 12:50:07'),(3,'SD','SD',2,'Sekolah Dasar',1,'2026-03-27 12:50:07','2026-03-27 12:50:07'),(4,'SMP','SMP',3,'Sekolah Menengah Pertama',1,'2026-03-27 12:50:07','2026-03-27 12:50:07'),(5,'SMA','SMA',4,'Sekolah Menengah Atas',1,'2026-03-27 12:50:07','2026-03-27 12:50:07'),(6,'SMK','SMK',4,'Sekolah Menengah Kejuruan',1,'2026-03-27 12:50:07','2026-03-27 12:50:07'),(7,'MA','MA',4,'Madrasah Aliyah',1,'2026-03-27 12:50:07','2026-03-27 12:50:07'),(8,'D1','D1',5,'Diploma 1',1,'2026-03-27 12:50:07','2026-03-27 12:50:07'),(9,'D2','D2',5,'Diploma 2',1,'2026-03-27 12:50:07','2026-03-27 12:50:07'),(10,'D3','D3',5,'Diploma 3',1,'2026-03-27 12:50:07','2026-03-27 12:50:07'),(11,'D4','D4',6,'Diploma 4',1,'2026-03-27 12:50:07','2026-03-27 12:50:07'),(12,'S1','S1',6,'Strata 1 (Sarjana)',1,'2026-03-27 12:50:07','2026-03-27 12:50:07'),(13,'S2','S2',7,'Strata 2 (Magister)',1,'2026-03-27 12:50:07','2026-03-27 12:50:07'),(14,'S3','S3',8,'Strata 3 (Doktor)',1,'2026-03-27 12:50:07','2026-03-27 12:50:07'),(15,'PRS','Profesi',6,'Pendidikan Profesi',1,'2026-03-27 12:50:07','2026-03-27 12:50:07'),(16,'LNN','Lainnya',9,'Pendidikan lainnya',1,'2026-03-27 12:50:07','2026-03-27 12:50:07');
/*!40000 ALTER TABLE `master_education_levels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `master_fee_types`
--

DROP TABLE IF EXISTS `master_fee_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `master_fee_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(20) NOT NULL COMMENT 'Kode jenis biaya',
  `name` varchar(100) NOT NULL COMMENT 'Nama jenis biaya',
  `category` enum('admin','processing','late','early_payment','penalty','service','other') NOT NULL,
  `calculation_method` enum('fixed','percentage','tiered') DEFAULT 'percentage',
  `default_rate` decimal(5,4) DEFAULT 0.0000 COMMENT 'Tarif default (%)',
  `default_amount` decimal(12,2) DEFAULT 0.00 COMMENT 'Jumlah default',
  `description` text DEFAULT NULL COMMENT 'Deskripsi',
  `is_taxable` tinyint(1) DEFAULT 0 COMMENT 'Kena pajak',
  `is_active` tinyint(1) DEFAULT 1 COMMENT 'Status aktif',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `idx_code` (`code`),
  KEY `idx_name` (`name`),
  KEY `idx_category` (`category`),
  KEY `idx_is_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `master_fee_types`
--

LOCK TABLES `master_fee_types` WRITE;
/*!40000 ALTER TABLE `master_fee_types` DISABLE KEYS */;
/*!40000 ALTER TABLE `master_fee_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `master_id_types`
--

DROP TABLE IF EXISTS `master_id_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `master_id_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(20) NOT NULL COMMENT 'Kode jenis identitas',
  `name` varchar(100) NOT NULL COMMENT 'Nama jenis identitas',
  `category` enum('government','professional','business','educational','health','other') NOT NULL,
  `issuing_authority` varchar(100) DEFAULT NULL COMMENT 'Penerbit',
  `format_pattern` varchar(50) DEFAULT NULL COMMENT 'Pola format (regex)',
  `length_min` int(11) DEFAULT NULL COMMENT 'Panjang minimal',
  `length_max` int(11) DEFAULT NULL COMMENT 'Panjang maksimal',
  `has_expiry` tinyint(1) DEFAULT 0 COMMENT 'Memiliki masa berlaku',
  `description` text DEFAULT NULL COMMENT 'Deskripsi',
  `is_active` tinyint(1) DEFAULT 1 COMMENT 'Status aktif',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `idx_code` (`code`),
  KEY `idx_name` (`name`),
  KEY `idx_category` (`category`),
  KEY `idx_issuing_authority` (`issuing_authority`),
  KEY `idx_is_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `master_id_types`
--

LOCK TABLES `master_id_types` WRITE;
/*!40000 ALTER TABLE `master_id_types` DISABLE KEYS */;
/*!40000 ALTER TABLE `master_id_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `master_notification_types`
--

DROP TABLE IF EXISTS `master_notification_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `master_notification_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(20) NOT NULL COMMENT 'Kode jenis notifikasi',
  `name` varchar(100) NOT NULL COMMENT 'Nama jenis notifikasi',
  `category` enum('info','warning','error','success','reminder','alert','promotion','system') NOT NULL,
  `priority` enum('low','medium','high','urgent') DEFAULT 'medium',
  `description` text DEFAULT NULL COMMENT 'Deskripsi',
  `template_path` varchar(255) DEFAULT NULL COMMENT 'Path template',
  `is_active` tinyint(1) DEFAULT 1 COMMENT 'Status aktif',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `idx_code` (`code`),
  KEY `idx_name` (`name`),
  KEY `idx_category` (`category`),
  KEY `idx_priority` (`priority`),
  KEY `idx_is_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `master_notification_types`
--

LOCK TABLES `master_notification_types` WRITE;
/*!40000 ALTER TABLE `master_notification_types` DISABLE KEYS */;
/*!40000 ALTER TABLE `master_notification_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `master_occupations`
--

DROP TABLE IF EXISTS `master_occupations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `master_occupations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(20) NOT NULL COMMENT 'Kode pekerjaan',
  `name` varchar(100) NOT NULL COMMENT 'Nama pekerjaan',
  `category` varchar(50) DEFAULT NULL COMMENT 'Kategori pekerjaan',
  `bps_code` varchar(20) DEFAULT NULL COMMENT 'Kode BPS',
  `description` text DEFAULT NULL COMMENT 'Deskripsi',
  `income_level` enum('low','medium','high','none') DEFAULT NULL COMMENT 'Tingkat pendapatan',
  `is_active` tinyint(1) DEFAULT 1 COMMENT 'Status aktif',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `idx_code` (`code`),
  KEY `idx_name` (`name`),
  KEY `idx_category` (`category`),
  KEY `idx_bps_code` (`bps_code`),
  KEY `idx_is_active` (`is_active`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `master_occupations`
--

LOCK TABLES `master_occupations` WRITE;
/*!40000 ALTER TABLE `master_occupations` DISABLE KEYS */;
/*!40000 ALTER TABLE `master_occupations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `master_payment_methods`
--

DROP TABLE IF EXISTS `master_payment_methods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `master_payment_methods` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(20) NOT NULL COMMENT 'Kode metode pembayaran',
  `name` varchar(50) NOT NULL COMMENT 'Nama metode pembayaran',
  `category` enum('cash','bank_transfer','digital_wallet','card','auto_debit','check','other') NOT NULL,
  `description` text DEFAULT NULL COMMENT 'Deskripsi',
  `processing_fee_rate` decimal(5,4) DEFAULT 0.0000 COMMENT 'Biaya proses (%)',
  `min_amount` decimal(12,2) DEFAULT NULL COMMENT 'Jumlah minimal',
  `max_amount` decimal(12,2) DEFAULT NULL COMMENT 'Jumlah maksimal',
  `is_active` tinyint(1) DEFAULT 1 COMMENT 'Status aktif',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `idx_code` (`code`),
  KEY `idx_name` (`name`),
  KEY `idx_category` (`category`),
  KEY `idx_is_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `master_payment_methods`
--

LOCK TABLES `master_payment_methods` WRITE;
/*!40000 ALTER TABLE `master_payment_methods` DISABLE KEYS */;
/*!40000 ALTER TABLE `master_payment_methods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `master_provinces`
--

DROP TABLE IF EXISTS `master_provinces`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `master_provinces` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(10) NOT NULL COMMENT 'Kode provinsi',
  `name` varchar(100) NOT NULL COMMENT 'Nama provinsi',
  `country_code` varchar(3) DEFAULT 'IDN' COMMENT 'Kode negara',
  `capital` varchar(100) DEFAULT NULL COMMENT 'Ibukota provinsi',
  `area_km2` decimal(10,2) DEFAULT NULL COMMENT 'Luas (km²)',
  `population` int(11) DEFAULT NULL COMMENT 'Jumlah penduduk',
  `density_per_km2` decimal(8,2) DEFAULT NULL COMMENT 'Kepaduan per km²',
  `gdp_trillion` decimal(10,2) DEFAULT NULL COMMENT 'GDP (triliun)',
  `is_active` tinyint(1) DEFAULT 1 COMMENT 'Status aktif',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `idx_code` (`code`),
  KEY `idx_name` (`name`),
  KEY `idx_country_code` (`country_code`),
  KEY `idx_is_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `master_provinces`
--

LOCK TABLES `master_provinces` WRITE;
/*!40000 ALTER TABLE `master_provinces` DISABLE KEYS */;
/*!40000 ALTER TABLE `master_provinces` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `master_relationship_types`
--

DROP TABLE IF EXISTS `master_relationship_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `master_relationship_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(20) NOT NULL COMMENT 'Kode hubungan',
  `name` varchar(50) NOT NULL COMMENT 'Nama hubungan',
  `category` enum('family','business','legal','other') NOT NULL,
  `relationship_level` enum('1','2','3','4','5+') NOT NULL COMMENT 'Tingkat hubungan',
  `inverse_relationship_id` int(11) DEFAULT NULL COMMENT 'Hubungan invers',
  `description` text DEFAULT NULL COMMENT 'Deskripsi',
  `is_active` tinyint(1) DEFAULT 1 COMMENT 'Status aktif',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `inverse_relationship_id` (`inverse_relationship_id`),
  KEY `idx_code` (`code`),
  KEY `idx_name` (`name`),
  KEY `idx_category` (`category`),
  KEY `idx_relationship_level` (`relationship_level`),
  KEY `idx_is_active` (`is_active`),
  CONSTRAINT `master_relationship_types_ibfk_1` FOREIGN KEY (`inverse_relationship_id`) REFERENCES `master_relationship_types` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `master_relationship_types`
--

LOCK TABLES `master_relationship_types` WRITE;
/*!40000 ALTER TABLE `master_relationship_types` DISABLE KEYS */;
/*!40000 ALTER TABLE `master_relationship_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `master_religions`
--

DROP TABLE IF EXISTS `master_religions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `master_religions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(10) NOT NULL COMMENT 'Kode agama',
  `name` varchar(50) NOT NULL COMMENT 'Nama agama',
  `description` text DEFAULT NULL COMMENT 'Deskripsi',
  `is_active` tinyint(1) DEFAULT 1 COMMENT 'Status aktif',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `idx_code` (`code`),
  KEY `idx_name` (`name`),
  KEY `idx_is_active` (`is_active`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `master_religions`
--

LOCK TABLES `master_religions` WRITE;
/*!40000 ALTER TABLE `master_religions` DISABLE KEYS */;
INSERT INTO `master_religions` VALUES (1,'ISL','Islam','Agama Islam',1,'2026-03-27 12:50:07','2026-03-27 12:50:07'),(2,'KRT','Kristen','Agama Kristen Protestan',1,'2026-03-27 12:50:07','2026-03-27 12:50:07'),(3,'KTH','Katolik','Agama Katolik',1,'2026-03-27 12:50:07','2026-03-27 12:50:07'),(4,'HDN','Hindu','Agama Hindu',1,'2026-03-27 12:50:07','2026-03-27 12:50:07'),(5,'BDH','Budha','Agama Budha',1,'2026-03-27 12:50:07','2026-03-27 12:50:07'),(6,'KHC','Konghucu','Agama Konghucu',1,'2026-03-27 12:50:07','2026-03-27 12:50:07'),(7,'LNN','Lainnya','Agama lainnya',1,'2026-03-27 12:50:07','2026-03-27 12:50:07'),(8,'TDA','Tidak Ada','Tidak beragama',1,'2026-03-27 12:50:07','2026-03-27 12:50:07');
/*!40000 ALTER TABLE `master_religions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `master_risk_levels`
--

DROP TABLE IF EXISTS `master_risk_levels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `master_risk_levels` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(20) NOT NULL COMMENT 'Kode tingkat risiko',
  `name` varchar(50) NOT NULL COMMENT 'Nama tingkat risiko',
  `score_min` int(11) NOT NULL COMMENT 'Skor minimal',
  `score_max` int(11) NOT NULL COMMENT 'Skor maksimal',
  `color_code` varchar(10) DEFAULT NULL COMMENT 'Kode warna',
  `description` text DEFAULT NULL COMMENT 'Deskripsi',
  `action_required` text DEFAULT NULL COMMENT 'Tindakan yang diperlukan',
  `is_active` tinyint(1) DEFAULT 1 COMMENT 'Status aktif',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `idx_code` (`code`),
  KEY `idx_name` (`name`),
  KEY `idx_score_range` (`score_min`,`score_max`),
  KEY `idx_is_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `master_risk_levels`
--

LOCK TABLES `master_risk_levels` WRITE;
/*!40000 ALTER TABLE `master_risk_levels` DISABLE KEYS */;
/*!40000 ALTER TABLE `master_risk_levels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `master_setting_categories`
--

DROP TABLE IF EXISTS `master_setting_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `master_setting_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(20) NOT NULL COMMENT 'Kode kategori',
  `name` varchar(100) NOT NULL COMMENT 'Nama kategori',
  `description` text DEFAULT NULL COMMENT 'Deskripsi',
  `parent_category_id` int(11) DEFAULT NULL COMMENT 'Kategori induk',
  `is_active` tinyint(1) DEFAULT 1 COMMENT 'Status aktif',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `idx_code` (`code`),
  KEY `idx_name` (`name`),
  KEY `idx_parent_category` (`parent_category_id`),
  KEY `idx_is_active` (`is_active`),
  CONSTRAINT `master_setting_categories_ibfk_1` FOREIGN KEY (`parent_category_id`) REFERENCES `master_setting_categories` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `master_setting_categories`
--

LOCK TABLES `master_setting_categories` WRITE;
/*!40000 ALTER TABLE `master_setting_categories` DISABLE KEYS */;
/*!40000 ALTER TABLE `master_setting_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `master_status_types`
--

DROP TABLE IF EXISTS `master_status_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `master_status_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(20) NOT NULL COMMENT 'Kode status',
  `name` varchar(50) NOT NULL COMMENT 'Nama status',
  `category` enum('user','member','loan','savings','document','transaction','other') NOT NULL,
  `color_code` varchar(10) DEFAULT NULL COMMENT 'Kode warna',
  `description` text DEFAULT NULL COMMENT 'Deskripsi',
  `next_statuses` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Status berikutnya yang mungkin' CHECK (json_valid(`next_statuses`)),
  `is_active` tinyint(1) DEFAULT 1 COMMENT 'Status aktif',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `idx_code` (`code`),
  KEY `idx_name` (`name`),
  KEY `idx_category` (`category`),
  KEY `idx_is_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `master_status_types`
--

LOCK TABLES `master_status_types` WRITE;
/*!40000 ALTER TABLE `master_status_types` DISABLE KEYS */;
/*!40000 ALTER TABLE `master_status_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `master_transaction_types`
--

DROP TABLE IF EXISTS `master_transaction_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `master_transaction_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(20) NOT NULL COMMENT 'Kode jenis transaksi',
  `name` varchar(100) NOT NULL COMMENT 'Nama jenis transaksi',
  `category` enum('loan','savings','fee','transfer','adjustment','other') NOT NULL,
  `direction` enum('in','out','neutral') NOT NULL COMMENT 'Arah transaksi',
  `description` text DEFAULT NULL COMMENT 'Deskripsi',
  `affects_balance` tinyint(1) DEFAULT 1 COMMENT 'Mempengaruhi saldo',
  `requires_approval` tinyint(1) DEFAULT 0 COMMENT 'Memerlukan persetujuan',
  `is_active` tinyint(1) DEFAULT 1 COMMENT 'Status aktif',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `idx_code` (`code`),
  KEY `idx_name` (`name`),
  KEY `idx_category` (`category`),
  KEY `idx_direction` (`direction`),
  KEY `idx_is_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `master_transaction_types`
--

LOCK TABLES `master_transaction_types` WRITE;
/*!40000 ALTER TABLE `master_transaction_types` DISABLE KEYS */;
/*!40000 ALTER TABLE `master_transaction_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `master_user_roles`
--

DROP TABLE IF EXISTS `master_user_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `master_user_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(20) NOT NULL COMMENT 'Kode role',
  `name` varchar(50) NOT NULL COMMENT 'Nama role',
  `display_name` varchar(100) DEFAULT NULL COMMENT 'Nama tampilan',
  `level` int(11) NOT NULL COMMENT 'Level role (1=highest)',
  `description` text DEFAULT NULL COMMENT 'Deskripsi',
  `permissions` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Hak akses' CHECK (json_valid(`permissions`)),
  `is_system_role` tinyint(1) DEFAULT 0 COMMENT 'Role sistem',
  `is_active` tinyint(1) DEFAULT 1 COMMENT 'Status aktif',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `idx_code` (`code`),
  KEY `idx_name` (`name`),
  KEY `idx_level` (`level`),
  KEY `idx_is_system_role` (`is_system_role`),
  KEY `idx_is_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `master_user_roles`
--

LOCK TABLES `master_user_roles` WRITE;
/*!40000 ALTER TABLE `master_user_roles` DISABLE KEYS */;
/*!40000 ALTER TABLE `master_user_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `member_complete_profile`
--

DROP TABLE IF EXISTS `member_complete_profile`;
/*!50001 DROP VIEW IF EXISTS `member_complete_profile`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `member_complete_profile` AS SELECT
 1 AS `id`,
  1 AS `member_number`,
  1 AS `member_type`,
  1 AS `join_date`,
  1 AS `status`,
  1 AS `credit_score`,
  1 AS `risk_level`,
  1 AS `max_loan_amount`,
  1 AS `current_active_loans`,
  1 AS `current_total_loans`,
  1 AS `total_savings`,
  1 AS `kyc_status`,
  1 AS `aml_status`,
  1 AS `nik`,
  1 AS `name`,
  1 AS `phone`,
  1 AS `email`,
  1 AS `birth_date`,
  1 AS `age`,
  1 AS `gender`,
  1 AS `occupation`,
  1 AS `monthly_income`,
  1 AS `business_type`,
  1 AS `marital_status`,
  1 AS `number_of_children`,
  1 AS `address_detail`,
  1 AS `postal_code`,
  1 AS `branch_name`,
  1 AS `branch_code`,
  1 AS `branch_phone`,
  1 AS `active_loans_count`,
  1 AS `total_loan_amount`,
  1 AS `active_savings_count`,
  1 AS `total_savings_balance`,
  1 AS `member_since`,
  1 AS `updated_at` */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `members`
--

DROP TABLE IF EXISTS `members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `members` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `person_id` int(11) NOT NULL COMMENT 'ID person (schema_person)',
  `member_number` varchar(20) NOT NULL COMMENT 'Nomor anggota unik',
  `branch_id` int(11) NOT NULL COMMENT 'ID cabang',
  `member_type` enum('regular','premium','vip','corporate','student','senior') DEFAULT 'regular',
  `membership_category` enum('anggota_biasa','anggota_luar_biasa','anggota_kehormatan') DEFAULT 'anggota_biasa',
  `join_date` date NOT NULL COMMENT 'Tanggal bergabung',
  `activation_date` date DEFAULT NULL COMMENT 'Tanggal aktivasi',
  `status` enum('pending','active','inactive','suspended','blacklisted','deceased') DEFAULT 'pending',
  `status_reason` text DEFAULT NULL COMMENT 'Alasan status',
  `max_active_loans` int(11) DEFAULT 2 COMMENT 'Maks pinjaman aktif',
  `max_loan_amount` decimal(12,2) DEFAULT 10000000.00 COMMENT 'Maks jumlah pinjaman',
  `max_loan_tenor_days` int(11) DEFAULT 180 COMMENT 'Maks tenor (hari)',
  `current_active_loans` int(11) DEFAULT 0 COMMENT 'Pinjaman aktif saat ini',
  `current_total_loans` decimal(12,2) DEFAULT 0.00 COMMENT 'Total pinjaman saat ini',
  `current_late_count` int(11) DEFAULT 0 COMMENT 'Jumlah tunggakan',
  `current_late_days` int(11) DEFAULT 0 COMMENT 'Hari tunggakan',
  `current_npl_amount` decimal(12,2) DEFAULT 0.00 COMMENT 'Jumlah NPL',
  `mandatory_savings_amount` decimal(10,2) DEFAULT 0.00 COMMENT 'Simpanan wajib minimal',
  `voluntary_savings_amount` decimal(10,2) DEFAULT 0.00 COMMENT 'Simpanan sukarela minimal',
  `current_mandatory_savings` decimal(12,2) DEFAULT 0.00 COMMENT 'Simpanan wajib saat ini',
  `current_voluntary_savings` decimal(12,2) DEFAULT 0.00 COMMENT 'Simpanan sukarela saat ini',
  `total_savings` decimal(12,2) DEFAULT 0.00 COMMENT 'Total simpanan',
  `credit_score` int(11) DEFAULT 0 COMMENT 'Skor kredit (0-100)',
  `risk_level` enum('low','medium','high','very_high') DEFAULT 'medium',
  `credit_limit` decimal(12,2) DEFAULT 0.00 COMMENT 'Limit kredit',
  `available_credit` decimal(12,2) DEFAULT 0.00 COMMENT 'Kredit tersedia',
  `last_credit_assessment` date DEFAULT NULL COMMENT 'Terakhir penilaian kredit',
  `kyc_status` enum('pending','verified','rejected','expired') DEFAULT 'pending',
  `kyc_verified_at` timestamp NULL DEFAULT NULL COMMENT 'KYC terverifikasi',
  `kyc_verified_by` int(11) DEFAULT NULL COMMENT 'Diverifikasi oleh',
  `aml_status` enum('pending','cleared','suspicious','blocked') DEFAULT 'pending',
  `aml_verified_at` timestamp NULL DEFAULT NULL COMMENT 'AML terverifikasi',
  `aml_verified_by` int(11) DEFAULT NULL COMMENT 'Diverifikasi oleh',
  `preferred_language` varchar(10) DEFAULT 'id' COMMENT 'Bahasa preferensi',
  `preferred_contact` enum('phone','whatsapp','email','sms') DEFAULT 'phone',
  `notification_settings` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Pengaturan notifikasi' CHECK (json_valid(`notification_settings`)),
  `privacy_settings` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Pengaturan privasi' CHECK (json_valid(`privacy_settings`)),
  `referral_source` varchar(100) DEFAULT NULL COMMENT 'Sumber referensi',
  `referral_member_id` int(11) DEFAULT NULL COMMENT 'ID member referensi',
  `notes` text DEFAULT NULL COMMENT 'Catatan tambahan',
  `is_active` tinyint(1) DEFAULT 1 COMMENT 'Status aktif',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `created_by` int(11) DEFAULT NULL COMMENT 'Dibuat oleh',
  `updated_by` int(11) DEFAULT NULL COMMENT 'Diupdate oleh',
  PRIMARY KEY (`id`),
  UNIQUE KEY `person_id` (`person_id`),
  UNIQUE KEY `member_number` (`member_number`),
  KEY `referral_member_id` (`referral_member_id`),
  KEY `created_by` (`created_by`),
  KEY `updated_by` (`updated_by`),
  KEY `kyc_verified_by` (`kyc_verified_by`),
  KEY `aml_verified_by` (`aml_verified_by`),
  KEY `idx_person_id` (`person_id`),
  KEY `idx_member_number` (`member_number`),
  KEY `idx_branch_id` (`branch_id`),
  KEY `idx_member_type` (`member_type`),
  KEY `idx_status` (`status`),
  KEY `idx_credit_score` (`credit_score`),
  KEY `idx_risk_level` (`risk_level`),
  KEY `idx_kyc_status` (`kyc_status`),
  KEY `idx_aml_status` (`aml_status`),
  KEY `idx_join_date` (`join_date`),
  KEY `idx_is_active` (`is_active`),
  CONSTRAINT `members_ibfk_1` FOREIGN KEY (`person_id`) REFERENCES `schema_person`.`persons` (`id`),
  CONSTRAINT `members_ibfk_2` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`),
  CONSTRAINT `members_ibfk_3` FOREIGN KEY (`referral_member_id`) REFERENCES `members` (`id`),
  CONSTRAINT `members_ibfk_4` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  CONSTRAINT `members_ibfk_5` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`),
  CONSTRAINT `members_ibfk_6` FOREIGN KEY (`kyc_verified_by`) REFERENCES `users` (`id`),
  CONSTRAINT `members_ibfk_7` FOREIGN KEY (`aml_verified_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `members`
--

LOCK TABLES `members` WRITE;
/*!40000 ALTER TABLE `members` DISABLE KEYS */;
/*!40000 ALTER TABLE `members` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `savings_accounts`
--

DROP TABLE IF EXISTS `savings_accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `savings_accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account_number` varchar(20) NOT NULL COMMENT 'Nomor rekening',
  `member_id` int(11) NOT NULL COMMENT 'ID member',
  `product_id` int(11) NOT NULL COMMENT 'ID produk simpanan',
  `branch_id` int(11) NOT NULL COMMENT 'ID cabang',
  `account_name` varchar(100) NOT NULL COMMENT 'Nama rekening',
  `account_type` enum('individual','joint','corporate','custodial') DEFAULT 'individual',
  `joint_account_holders` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Pemegang rekening bersama (JSON)' CHECK (json_valid(`joint_account_holders`)),
  `custodian_id` int(11) DEFAULT NULL COMMENT 'ID wali (untuk minor)',
  `start_date` date NOT NULL COMMENT 'Tanggal mulai',
  `end_date` date DEFAULT NULL COMMENT 'Tanggal berakhir',
  `target_amount` decimal(12,2) DEFAULT NULL COMMENT 'Target jumlah',
  `monthly_target` decimal(10,2) DEFAULT NULL COMMENT 'Target bulanan',
  `auto_debit_enabled` tinyint(1) DEFAULT 0 COMMENT 'Auto-debit aktif',
  `auto_debit_amount` decimal(10,2) DEFAULT NULL COMMENT 'Jumlah auto-debit',
  `interest_rate_monthly` decimal(5,4) NOT NULL COMMENT 'Suku bunga per bulan',
  `interest_calculation` enum('daily','monthly','quarterly','annually') DEFAULT 'monthly',
  `interest_payment_frequency` enum('monthly','quarterly','annually','maturity') DEFAULT 'monthly',
  `tax_withholding_rate` decimal(5,4) DEFAULT 0.0000 COMMENT 'Pajak yang ditahan',
  `current_balance` decimal(12,2) DEFAULT 0.00 COMMENT 'Saldo saat ini',
  `total_deposits` decimal(12,2) DEFAULT 0.00 COMMENT 'Total setoran',
  `total_withdrawals` decimal(12,2) DEFAULT 0.00 COMMENT 'Total penarikan',
  `total_interest_earned` decimal(12,2) DEFAULT 0.00 COMMENT 'Total bunga earned',
  `total_tax_withheld` decimal(12,2) DEFAULT 0.00 COMMENT 'Total pajak ditahan',
  `status` enum('active','inactive','frozen','closed','dormant') DEFAULT 'active',
  `freeze_reason` text DEFAULT NULL COMMENT 'Alasan pembekuan',
  `closure_reason` text DEFAULT NULL COMMENT 'Alasan penutupan',
  `closure_date` date DEFAULT NULL COMMENT 'Tanggal penutupan',
  `online_access_enabled` tinyint(1) DEFAULT 1 COMMENT 'Akses online aktif',
  `mobile_banking_enabled` tinyint(1) DEFAULT 1 COMMENT 'Mobile banking aktif',
  `atm_card_enabled` tinyint(1) DEFAULT 1 COMMENT 'Kartu ATM aktif',
  `daily_limit` decimal(10,2) DEFAULT 0.00 COMMENT 'Batas harian',
  `transaction_limit` decimal(10,2) DEFAULT 0.00 COMMENT 'Batas transaksi',
  `notes` text DEFAULT NULL COMMENT 'Catatan tambahan',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `created_by` int(11) NOT NULL COMMENT 'Dibuat oleh',
  `updated_by` int(11) DEFAULT NULL COMMENT 'Diupdate oleh',
  PRIMARY KEY (`id`),
  UNIQUE KEY `account_number` (`account_number`),
  KEY `custodian_id` (`custodian_id`),
  KEY `created_by` (`created_by`),
  KEY `updated_by` (`updated_by`),
  KEY `idx_account_number` (`account_number`),
  KEY `idx_member_id` (`member_id`),
  KEY `idx_product_id` (`product_id`),
  KEY `idx_branch_id` (`branch_id`),
  KEY `idx_status` (`status`),
  KEY `idx_start_date` (`start_date`),
  KEY `idx_end_date` (`end_date`),
  KEY `idx_current_balance` (`current_balance`),
  CONSTRAINT `savings_accounts_ibfk_1` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`),
  CONSTRAINT `savings_accounts_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `savings_products` (`id`),
  CONSTRAINT `savings_accounts_ibfk_3` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`),
  CONSTRAINT `savings_accounts_ibfk_4` FOREIGN KEY (`custodian_id`) REFERENCES `members` (`id`),
  CONSTRAINT `savings_accounts_ibfk_5` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  CONSTRAINT `savings_accounts_ibfk_6` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `savings_accounts`
--

LOCK TABLES `savings_accounts` WRITE;
/*!40000 ALTER TABLE `savings_accounts` DISABLE KEYS */;
/*!40000 ALTER TABLE `savings_accounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `savings_deposits`
--

DROP TABLE IF EXISTS `savings_deposits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `savings_deposits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account_id` int(11) NOT NULL COMMENT 'ID rekening',
  `transaction_number` varchar(20) DEFAULT NULL COMMENT 'Nomor transaksi',
  `deposit_date` date NOT NULL COMMENT 'Tanggal setoran',
  `amount` decimal(10,2) NOT NULL COMMENT 'Jumlah setoran',
  `deposit_type` enum('regular','additional','bonus','interest','correction') DEFAULT 'regular',
  `payment_method` enum('cash','transfer','digital_wallet','auto_debit','bank_transfer') DEFAULT 'cash',
  `payment_reference` varchar(50) DEFAULT NULL COMMENT 'Referensi pembayaran',
  `receipt_number` varchar(50) DEFAULT NULL COMMENT 'Nomor kwitansi',
  `collector_id` int(11) DEFAULT NULL COMMENT 'ID kolektor',
  `teller_id` int(11) DEFAULT NULL COMMENT 'ID teller',
  `branch_id` int(11) NOT NULL COMMENT 'ID cabang',
  `counter_number` varchar(10) DEFAULT NULL COMMENT 'Nomor loket',
  `status` enum('pending','verified','rejected','cancelled') DEFAULT 'verified',
  `verified_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Tanggal verifikasi',
  `verified_by` int(11) DEFAULT NULL COMMENT 'Diverifikasi oleh',
  `rejection_reason` text DEFAULT NULL COMMENT 'Alasan penolakan',
  `notes` text DEFAULT NULL COMMENT 'Catatan tambahan',
  `attachments` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Lampiran (JSON)' CHECK (json_valid(`attachments`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_by` int(11) NOT NULL COMMENT 'Dibuat oleh',
  PRIMARY KEY (`id`),
  UNIQUE KEY `transaction_number` (`transaction_number`),
  KEY `teller_id` (`teller_id`),
  KEY `branch_id` (`branch_id`),
  KEY `verified_by` (`verified_by`),
  KEY `created_by` (`created_by`),
  KEY `idx_account_id` (`account_id`),
  KEY `idx_transaction_number` (`transaction_number`),
  KEY `idx_deposit_date` (`deposit_date`),
  KEY `idx_collector_id` (`collector_id`),
  KEY `idx_status` (`status`),
  KEY `idx_amount` (`amount`),
  CONSTRAINT `savings_deposits_ibfk_1` FOREIGN KEY (`account_id`) REFERENCES `savings_accounts` (`id`),
  CONSTRAINT `savings_deposits_ibfk_2` FOREIGN KEY (`collector_id`) REFERENCES `users` (`id`),
  CONSTRAINT `savings_deposits_ibfk_3` FOREIGN KEY (`teller_id`) REFERENCES `users` (`id`),
  CONSTRAINT `savings_deposits_ibfk_4` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`),
  CONSTRAINT `savings_deposits_ibfk_5` FOREIGN KEY (`verified_by`) REFERENCES `users` (`id`),
  CONSTRAINT `savings_deposits_ibfk_6` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `savings_deposits`
--

LOCK TABLES `savings_deposits` WRITE;
/*!40000 ALTER TABLE `savings_deposits` DISABLE KEYS */;
/*!40000 ALTER TABLE `savings_deposits` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `savings_products`
--

DROP TABLE IF EXISTS `savings_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `savings_products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL COMMENT 'Nama produk',
  `code` varchar(20) NOT NULL COMMENT 'Kode produk',
  `description` text DEFAULT NULL COMMENT 'Deskripsi produk',
  `product_type` enum('kewer','mawar','sukarela','deposito','berjangka','pendidikan','haji','khusus') DEFAULT 'sukarela',
  `product_category` enum('wajib','sukarela','investasi','tujuan') DEFAULT 'sukarela',
  `min_deposit` decimal(10,2) NOT NULL COMMENT 'Setoran minimal',
  `max_deposit` decimal(12,2) DEFAULT NULL COMMENT 'Setoran maksimal (0=tidak ada)',
  `default_deposit` decimal(10,2) DEFAULT NULL COMMENT 'Setoran default',
  `deposit_increment` decimal(8,2) DEFAULT 10000.00 COMMENT 'Kelipatan setoran',
  `deposit_frequency` enum('daily','weekly','monthly','quarterly','flexible') DEFAULT 'flexible',
  `min_monthly_deposit` decimal(10,2) DEFAULT NULL COMMENT 'Setoran bulanan minimal',
  `interest_rate_monthly` decimal(5,4) NOT NULL COMMENT 'Suku bunga per bulan',
  `interest_calculation` enum('daily','monthly','quarterly','annually') DEFAULT 'monthly',
  `interest_payment_frequency` enum('monthly','quarterly','annually','maturity') DEFAULT 'monthly',
  `bonus_rate` decimal(5,4) DEFAULT 0.0000 COMMENT 'Bonus rate (%)',
  `tax_rate` decimal(5,4) DEFAULT 0.0000 COMMENT 'Pajak bunga (%)',
  `compounding_method` enum('simple','compound') DEFAULT 'simple',
  `min_tenor_months` int(11) DEFAULT NULL COMMENT 'Tenor minimal (bulan)',
  `max_tenor_months` int(11) DEFAULT NULL COMMENT 'Tenor maksimal (bulan)',
  `default_tenor_months` int(11) DEFAULT NULL COMMENT 'Tenor default (bulan)',
  `withdrawal_penalty_days` int(11) DEFAULT 0 COMMENT 'Masa penalti penarikan (hari)',
  `withdrawal_penalty_rate` decimal(5,4) DEFAULT 0.0000 COMMENT 'Penalti penarikan (%)',
  `min_withdrawal_amount` decimal(10,2) DEFAULT NULL COMMENT 'Penarikan minimal',
  `max_withdrawal_frequency` int(11) DEFAULT NULL COMMENT 'Maks frekuensi penarikan per bulan',
  `auto_renewal` tinyint(1) DEFAULT 0 COMMENT 'Perpanjangan otomatis',
  `min_credit_score` int(11) DEFAULT 0 COMMENT 'Skor kredit minimal',
  `min_membership_days` int(11) DEFAULT 0 COMMENT 'Lama keanggotaan minimal (hari)',
  `min_age_years` int(11) DEFAULT 17 COMMENT 'Usia minimal',
  `max_age_years` int(11) DEFAULT 0 COMMENT 'Usia maksimal (0=tidak ada)',
  `required_documents` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Dokumen yang diperlukan (JSON)' CHECK (json_valid(`required_documents`)),
  `target_member_types` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Tipe member target (JSON)' CHECK (json_valid(`target_member_types`)),
  `target_income_range` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Range pendapatan target (JSON)' CHECK (json_valid(`target_income_range`)),
  `target_purpose` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Tujuan target (JSON)' CHECK (json_valid(`target_purpose`)),
  `account_type` enum('individual','joint','corporate','custodial') DEFAULT 'individual',
  `currency` varchar(3) DEFAULT 'IDR' COMMENT 'Mata uang',
  `auto_debit_enabled` tinyint(1) DEFAULT 0 COMMENT 'Auto-debit aktif',
  `online_access` tinyint(1) DEFAULT 1 COMMENT 'Akses online',
  `mobile_banking` tinyint(1) DEFAULT 1 COMMENT 'Mobile banking',
  `is_active` tinyint(1) DEFAULT 1 COMMENT 'Status aktif',
  `is_promotional` tinyint(1) DEFAULT 0 COMMENT 'Produk promosi',
  `priority_level` int(11) DEFAULT 0 COMMENT 'Prioritas (0=terendah)',
  `effective_date` date DEFAULT NULL COMMENT 'Tanggal efektif',
  `expiry_date` date DEFAULT NULL COMMENT 'Tanggal kadaluarsa',
  `terms_conditions` text DEFAULT NULL COMMENT 'Syarat dan ketentuan',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `created_by` int(11) DEFAULT NULL COMMENT 'Dibuat oleh',
  `updated_by` int(11) DEFAULT NULL COMMENT 'Diupdate oleh',
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `created_by` (`created_by`),
  KEY `updated_by` (`updated_by`),
  KEY `idx_code` (`code`),
  KEY `idx_product_type` (`product_type`),
  KEY `idx_product_category` (`product_category`),
  KEY `idx_interest_rate` (`interest_rate_monthly`),
  KEY `idx_is_active` (`is_active`),
  KEY `idx_is_promotional` (`is_promotional`),
  KEY `idx_effective_date` (`effective_date`),
  CONSTRAINT `savings_products_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  CONSTRAINT `savings_products_ibfk_2` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `savings_products`
--

LOCK TABLES `savings_products` WRITE;
/*!40000 ALTER TABLE `savings_products` DISABLE KEYS */;
/*!40000 ALTER TABLE `savings_products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `units`
--

DROP TABLE IF EXISTS `units`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `units` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL COMMENT 'Nama unit organisasi',
  `code` varchar(20) NOT NULL COMMENT 'Kode unit',
  `description` text DEFAULT NULL COMMENT 'Deskripsi unit',
  `unit_type` enum('pusat','cabang','unit','divisi','departemen') DEFAULT 'unit',
  `parent_unit_id` int(11) DEFAULT NULL COMMENT 'Unit induk (hierarki)',
  `head_user_id` int(11) DEFAULT NULL COMMENT 'Kepala unit',
  `contact_person` varchar(100) DEFAULT NULL COMMENT 'Person kontak',
  `contact_phone` varchar(15) DEFAULT NULL COMMENT 'Telepon kontak',
  `contact_email` varchar(100) DEFAULT NULL COMMENT 'Email kontak',
  `address_id` int(11) DEFAULT NULL COMMENT 'ID alamat (schema_address)',
  `is_active` tinyint(1) DEFAULT 1 COMMENT 'Status aktif',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `created_by` int(11) DEFAULT NULL COMMENT 'Dibuat oleh',
  `updated_by` int(11) DEFAULT NULL COMMENT 'Diupdate oleh',
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `idx_code` (`code`),
  KEY `idx_unit_type` (`unit_type`),
  KEY `idx_parent_unit` (`parent_unit_id`),
  KEY `idx_head_user` (`head_user_id`),
  KEY `idx_is_active` (`is_active`),
  CONSTRAINT `units_ibfk_1` FOREIGN KEY (`parent_unit_id`) REFERENCES `units` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `units`
--

LOCK TABLES `units` WRITE;
/*!40000 ALTER TABLE `units` DISABLE KEYS */;
/*!40000 ALTER TABLE `units` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_sessions`
--

DROP TABLE IF EXISTS `user_sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_sessions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT 'ID user',
  `session_id` varchar(100) NOT NULL COMMENT 'ID session',
  `ip_address` varchar(45) DEFAULT NULL COMMENT 'IP address',
  `user_agent` text DEFAULT NULL COMMENT 'User agent',
  `device_info` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Info device (JSON)' CHECK (json_valid(`device_info`)),
  `location_info` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Info lokasi (JSON)' CHECK (json_valid(`location_info`)),
  `login_time` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Waktu login',
  `last_activity` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Aktivitas terakhir',
  `expiry_time` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Waktu expiry',
  `is_active` tinyint(1) DEFAULT 1 COMMENT 'Status aktif',
  `logout_time` timestamp NULL DEFAULT NULL COMMENT 'Waktu logout',
  `logout_reason` varchar(50) DEFAULT NULL COMMENT 'Alasan logout',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `session_id` (`session_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_session_id` (`session_id`),
  KEY `idx_ip_address` (`ip_address`),
  KEY `idx_login_time` (`login_time`),
  KEY `idx_expiry_time` (`expiry_time`),
  KEY `idx_is_active` (`is_active`),
  CONSTRAINT `user_sessions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_sessions`
--

LOCK TABLES `user_sessions` WRITE;
/*!40000 ALTER TABLE `user_sessions` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL COMMENT 'Username login',
  `password` varchar(255) NOT NULL COMMENT 'Password (hashed)',
  `person_id` int(11) NOT NULL COMMENT 'ID person (schema_person)',
  `branch_id` int(11) DEFAULT NULL COMMENT 'ID cabang default',
  `unit_id` int(11) DEFAULT NULL COMMENT 'ID unit default',
  `role` enum('super_admin','admin','unit_head','branch_head','supervisor','collector','cashier','member','guest') NOT NULL DEFAULT 'member',
  `status` enum('active','inactive','suspended','pending') DEFAULT 'active',
  `login_attempts` int(11) DEFAULT 0 COMMENT 'Jumlah percobaan login gagal',
  `last_login` timestamp NULL DEFAULT NULL COMMENT 'Login terakhir',
  `last_activity` timestamp NULL DEFAULT NULL COMMENT 'Aktivitas terakhir',
  `session_id` varchar(100) DEFAULT NULL COMMENT 'ID session aktif',
  `api_token` varchar(255) DEFAULT NULL COMMENT 'Token API',
  `api_token_expiry` timestamp NULL DEFAULT NULL COMMENT 'Masa berlaku token API',
  `two_factor_enabled` tinyint(1) DEFAULT 0 COMMENT '2FA aktif',
  `two_factor_secret` varchar(32) DEFAULT NULL COMMENT 'Secret 2FA',
  `email_verified` tinyint(1) DEFAULT 0 COMMENT 'Email terverifikasi',
  `phone_verified` tinyint(1) DEFAULT 0 COMMENT 'Telepon terverifikasi',
  `must_change_password` tinyint(1) DEFAULT 0 COMMENT 'Harus ganti password',
  `password_changed_at` timestamp NULL DEFAULT NULL COMMENT 'Password terakhir diubah',
  `ip_restrictions` text DEFAULT NULL COMMENT 'Batasan IP (JSON)',
  `device_restrictions` text DEFAULT NULL COMMENT 'Batasan device (JSON)',
  `permissions` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Hak akses tambahan (JSON)' CHECK (json_valid(`permissions`)),
  `preferences` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Preferensi user (JSON)' CHECK (json_valid(`preferences`)),
  `is_active` tinyint(1) DEFAULT 1 COMMENT 'Status aktif',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `created_by` int(11) DEFAULT NULL COMMENT 'Dibuat oleh',
  `updated_by` int(11) DEFAULT NULL COMMENT 'Diupdate oleh',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  KEY `created_by` (`created_by`),
  KEY `updated_by` (`updated_by`),
  KEY `idx_username` (`username`),
  KEY `idx_person_id` (`person_id`),
  KEY `idx_branch_id` (`branch_id`),
  KEY `idx_unit_id` (`unit_id`),
  KEY `idx_role` (`role`),
  KEY `idx_status` (`status`),
  KEY `idx_last_login` (`last_login`),
  KEY `idx_api_token` (`api_token`),
  KEY `idx_is_active` (`is_active`),
  CONSTRAINT `users_ibfk_1` FOREIGN KEY (`person_id`) REFERENCES `schema_person`.`persons` (`id`),
  CONSTRAINT `users_ibfk_2` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`),
  CONSTRAINT `users_ibfk_3` FOREIGN KEY (`unit_id`) REFERENCES `units` (`id`),
  CONSTRAINT `users_ibfk_4` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  CONSTRAINT `users_ibfk_5` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (7,'admin','$2y$10$./sU885uH29gFGnlqYiud.bTfUVA33.9o.83v6Rp8LYc4hC.J8Jpm',1,NULL,NULL,'super_admin','active',0,'2026-03-27 14:51:04','2026-03-27 14:51:04',NULL,NULL,NULL,0,NULL,0,0,0,NULL,NULL,NULL,NULL,NULL,1,'2026-03-27 12:50:23','2026-03-27 14:51:04',NULL,NULL),(8,'manager','$2y$10$OtuHLHdY/7mFwpUMpREVe.GP9lvhipzqUWRRktyNaZg41fXGPnFZK',2,NULL,NULL,'unit_head','active',0,'2026-03-27 14:51:04','2026-03-27 14:51:04',NULL,NULL,NULL,0,NULL,0,0,0,NULL,NULL,NULL,NULL,NULL,1,'2026-03-27 12:50:23','2026-03-27 14:51:04',NULL,NULL),(9,'branch_head','$2y$10$9otXGsQ0hCc.rHDsk.KPeOvymTahc.sFP9aVK7gBjpblh9Hwu4BBK',3,NULL,NULL,'branch_head','active',0,'2026-03-27 14:51:04','2026-03-27 14:51:04',NULL,NULL,NULL,0,NULL,0,0,0,NULL,NULL,NULL,NULL,NULL,1,'2026-03-27 12:50:23','2026-03-27 14:51:04',NULL,NULL),(10,'collector','$2y$10$4lY6l2xvchYaSjDtJ8ET0OUNtnbQhE3fckWZDwkauZO0E.yZneo5u',1,NULL,NULL,'collector','active',0,'2026-03-27 14:51:04','2026-03-27 14:51:04',NULL,NULL,NULL,0,NULL,0,0,0,NULL,NULL,NULL,NULL,NULL,1,'2026-03-27 12:50:23','2026-03-27 14:51:04',NULL,NULL),(11,'cashier','$2y$10$X6JGx7yWtvTq9F.p89qSgudCEhZN.zHEi0Dj74agiFTsGtcN3Co6e',2,NULL,NULL,'cashier','active',0,'2026-03-27 14:51:04','2026-03-27 14:51:04',NULL,NULL,NULL,0,NULL,0,0,0,NULL,NULL,NULL,NULL,NULL,1,'2026-03-27 12:50:23','2026-03-27 14:51:04',NULL,NULL),(12,'staff','$2y$10$aZtB6exAZwtx7Sbntbrop.NJ1MVVbNAx358uxHHSLhun3w9JEKraO',3,NULL,NULL,'member','active',0,'2026-03-27 14:51:05','2026-03-27 14:51:05',NULL,NULL,NULL,0,NULL,0,0,0,NULL,NULL,NULL,NULL,NULL,1,'2026-03-27 12:50:23','2026-03-27 14:51:05',NULL,NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `member_complete_profile`
--

/*!50001 DROP VIEW IF EXISTS `member_complete_profile`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `member_complete_profile` AS select `m`.`id` AS `id`,`m`.`member_number` AS `member_number`,`m`.`member_type` AS `member_type`,`m`.`join_date` AS `join_date`,`m`.`status` AS `status`,`m`.`credit_score` AS `credit_score`,`m`.`risk_level` AS `risk_level`,`m`.`max_loan_amount` AS `max_loan_amount`,`m`.`current_active_loans` AS `current_active_loans`,`m`.`current_total_loans` AS `current_total_loans`,`m`.`total_savings` AS `total_savings`,`m`.`kyc_status` AS `kyc_status`,`m`.`aml_status` AS `aml_status`,`p`.`nik` AS `nik`,`p`.`name` AS `name`,`p`.`phone` AS `phone`,`p`.`email` AS `email`,`p`.`birth_date` AS `birth_date`,timestampdiff(YEAR,`p`.`birth_date`,curdate()) AS `age`,`p`.`gender` AS `gender`,`p`.`occupation` AS `occupation`,`p`.`monthly_income` AS `monthly_income`,`p`.`business_type` AS `business_type`,`p`.`marital_status` AS `marital_status`,`p`.`number_of_children` AS `number_of_children`,`p`.`address_detail` AS `address_detail`,`p`.`postal_code` AS `postal_code`,`b`.`name` AS `branch_name`,`b`.`code` AS `branch_code`,`b`.`phone` AS `branch_phone`,(select count(0) from `schema_app`.`loans` `l` where `l`.`member_id` = `m`.`id` and `l`.`status` in ('active','late','defaulted')) AS `active_loans_count`,(select coalesce(sum(`l`.`amount`),0) from `schema_app`.`loans` `l` where `l`.`member_id` = `m`.`id` and `l`.`status` in ('active','late','defaulted')) AS `total_loan_amount`,(select count(0) from `schema_app`.`savings_accounts` `sa` where `sa`.`member_id` = `m`.`id` and `sa`.`status` = 'active') AS `active_savings_count`,(select coalesce(sum(`sa`.`current_balance`),0) from `schema_app`.`savings_accounts` `sa` where `sa`.`member_id` = `m`.`id` and `sa`.`status` = 'active') AS `total_savings_balance`,`m`.`created_at` AS `member_since`,`m`.`updated_at` AS `updated_at` from ((`schema_app`.`members` `m` join `schema_person`.`persons` `p` on(`m`.`person_id` = `p`.`id`)) join `schema_app`.`branches` `b` on(`m`.`branch_id` = `b`.`id`)) where `m`.`is_active` = 1 */;
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

-- Dump completed on 2026-03-27 22:02:31
