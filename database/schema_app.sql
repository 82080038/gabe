-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Waktu pembuatan: 26 Mar 2026 pada 21.33
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `schema_app`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `accounts`
--

CREATE TABLE `accounts` (
  `id` int(11) NOT NULL,
  `account_code` varchar(20) NOT NULL,
  `account_name` varchar(100) NOT NULL,
  `account_type` enum('aset','kewajiban','ekuitas','pendapatan','beban') NOT NULL,
  `account_category` enum('current','non_current','operating','investing','financing') DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `level` int(11) DEFAULT 1,
  `normal_balance` enum('debit','credit') NOT NULL,
  `description` text DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `is_consolidated` tinyint(1) DEFAULT 0,
  `is_budget_account` tinyint(1) DEFAULT 0,
  `is_tax_account` tinyint(1) DEFAULT 0,
  `is_restricted` tinyint(1) DEFAULT 0,
  `opening_balance` decimal(15,2) DEFAULT 0.00,
  `opening_balance_date` date DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `accounts`
--

INSERT INTO `accounts` (`id`, `account_code`, `account_name`, `account_type`, `account_category`, `parent_id`, `level`, `normal_balance`, `description`, `is_active`, `is_consolidated`, `is_budget_account`, `is_tax_account`, `is_restricted`, `opening_balance`, `opening_balance_date`, `created_at`, `updated_at`, `created_by`, `updated_by`) VALUES
(1, '1000', 'AKTIVA LANCAR', 'aset', NULL, NULL, 1, 'debit', NULL, 1, 0, 0, 0, 0, 0.00, NULL, '2026-03-26 19:07:45', '2026-03-26 19:07:45', NULL, NULL),
(2, '1010', 'KAS', 'aset', NULL, NULL, 1, 'debit', NULL, 1, 0, 0, 0, 0, 0.00, NULL, '2026-03-26 19:07:45', '2026-03-26 19:07:45', NULL, NULL),
(3, '1100', 'PIUTANG PINJAMAN MIKRO', 'aset', NULL, NULL, 1, 'debit', NULL, 1, 0, 0, 0, 0, 0.00, NULL, '2026-03-26 19:07:45', '2026-03-26 19:07:45', NULL, NULL),
(4, '2000', 'KEWAJIBAN LANCAR', 'kewajiban', NULL, NULL, 1, 'credit', NULL, 1, 0, 0, 0, 0, 0.00, NULL, '2026-03-26 19:07:45', '2026-03-26 19:07:45', NULL, NULL),
(5, '2100', 'SIMPANAN ANGGOTA', 'kewajiban', NULL, NULL, 1, 'credit', NULL, 1, 0, 0, 0, 0, 0.00, NULL, '2026-03-26 19:07:45', '2026-03-26 19:07:45', NULL, NULL),
(6, '3000', 'EKUITAS', 'ekuitas', NULL, NULL, 1, 'credit', NULL, 1, 0, 0, 0, 0, 0.00, NULL, '2026-03-26 19:07:45', '2026-03-26 19:07:45', NULL, NULL),
(7, '4000', 'PENDAPATAN', 'pendapatan', NULL, NULL, 1, 'credit', NULL, 1, 0, 0, 0, 0, 0.00, NULL, '2026-03-26 19:07:45', '2026-03-26 19:07:45', NULL, NULL),
(8, '4100', 'BIAYA ADMIN', 'beban', NULL, NULL, 1, 'debit', NULL, 1, 0, 0, 0, 0, 0.00, NULL, '2026-03-26 19:07:45', '2026-03-26 19:07:45', NULL, NULL),
(9, '5000', 'BEBAN', 'beban', NULL, NULL, 1, 'debit', NULL, 1, 0, 0, 0, 0, 0.00, NULL, '2026-03-26 19:07:45', '2026-03-26 19:07:45', NULL, NULL);

-- --------------------------------------------------------

--
-- Struktur dari tabel `addresses`
--

CREATE TABLE `addresses` (
  `id` int(11) NOT NULL,
  `person_id` int(11) NOT NULL,
  `village_id` int(11) NOT NULL,
  `address_detail` text DEFAULT NULL,
  `address_type` enum('rumah','usaha','penagihan') DEFAULT NULL,
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `branches`
--

CREATE TABLE `branches` (
  `id` int(11) NOT NULL,
  `unit_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `code` varchar(20) NOT NULL,
  `branch_type` enum('pusat','cabang_utama','cabang','unit_pelayanan') DEFAULT 'cabang',
  `head_user_id` int(11) DEFAULT NULL,
  `manager_user_id` int(11) DEFAULT NULL,
  `address_id` int(11) DEFAULT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `phone2` varchar(15) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `website` varchar(100) DEFAULT NULL,
  `operational_area` text DEFAULT NULL,
  `service_hours` varchar(100) DEFAULT NULL,
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `coverage_radius_km` int(11) DEFAULT 5,
  `is_active` tinyint(1) DEFAULT 1,
  `opening_date` date DEFAULT NULL,
  `closing_date` date DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `branches`
--

INSERT INTO `branches` (`id`, `unit_id`, `name`, `code`, `branch_type`, `head_user_id`, `manager_user_id`, `address_id`, `phone`, `phone2`, `email`, `website`, `operational_area`, `service_hours`, `latitude`, `longitude`, `coverage_radius_km`, `is_active`, `opening_date`, `closing_date`, `created_at`, `updated_at`, `created_by`, `updated_by`) VALUES
(1, 1, 'Kantor Pusat', 'KP001', 'pusat', NULL, NULL, NULL, '021-55551234', NULL, 'info@koperasi.co.id', NULL, NULL, NULL, NULL, NULL, 5, 1, NULL, NULL, '2026-03-26 19:06:48', '2026-03-26 19:06:48', NULL, NULL),
(2, 1, 'Cabang Jakarta Pusat', 'CJ001', 'cabang', NULL, NULL, NULL, '021-55551235', NULL, 'jakarta@koperasi.co.id', NULL, NULL, NULL, NULL, NULL, 5, 1, NULL, NULL, '2026-03-26 19:06:48', '2026-03-26 19:06:48', NULL, NULL),
(3, 2, 'Cabang Jakarta Selatan', 'CJ002', 'cabang', NULL, NULL, NULL, '021-55551236', NULL, 'jakselatan@koperasi.co.id', NULL, NULL, NULL, NULL, NULL, 5, 1, NULL, NULL, '2026-03-26 19:06:48', '2026-03-26 19:06:48', NULL, NULL);

-- --------------------------------------------------------

--
-- Struktur dari tabel `fraud_alerts`
--

CREATE TABLE `fraud_alerts` (
  `id` int(11) NOT NULL,
  `collector_id` int(11) NOT NULL,
  `alert_date` date NOT NULL,
  `anomaly_types` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`anomaly_types`)),
  `details` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`details`)),
  `severity` enum('low','medium','high') DEFAULT NULL,
  `status` enum('pending','investigating','resolved') DEFAULT 'pending',
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `journals`
--

CREATE TABLE `journals` (
  `id` int(11) NOT NULL,
  `journal_number` varchar(20) NOT NULL,
  `journal_date` date NOT NULL,
  `description` text DEFAULT NULL,
  `reference_type` varchar(50) DEFAULT NULL,
  `reference_id` int(11) DEFAULT NULL,
  `reference_number` varchar(50) DEFAULT NULL,
  `status` enum('draft','submitted','approved','rejected','posted','reversed') DEFAULT 'draft',
  `approved_by` int(11) DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `posted_by` int(11) DEFAULT NULL,
  `posted_at` timestamp NULL DEFAULT NULL,
  `reversed_by` int(11) DEFAULT NULL,
  `reversed_at` timestamp NULL DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `attachments` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`attachments`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `created_by` int(11) NOT NULL,
  `updated_by` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `journal_details`
--

CREATE TABLE `journal_details` (
  `id` int(11) NOT NULL,
  `journal_id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `line_number` int(11) NOT NULL,
  `debit` decimal(15,2) DEFAULT 0.00,
  `credit` decimal(15,2) DEFAULT 0.00,
  `amount` decimal(15,2) GENERATED ALWAYS AS (greatest(`debit`,`credit`)) STORED,
  `description` text DEFAULT NULL,
  `reference_type` varchar(50) DEFAULT NULL,
  `reference_id` int(11) DEFAULT NULL,
  `reference_number` varchar(50) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `attachments` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`attachments`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `loans`
--

CREATE TABLE `loans` (
  `id` int(11) NOT NULL,
  `application_number` varchar(20) NOT NULL,
  `member_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `branch_id` int(11) NOT NULL,
  `collector_id` int(11) DEFAULT NULL,
  `amount` decimal(12,2) NOT NULL,
  `admin_fee` decimal(10,2) NOT NULL,
  `processing_fee` decimal(10,2) NOT NULL,
  `insurance_fee` decimal(10,2) DEFAULT 0.00,
  `other_fees` decimal(10,2) DEFAULT 0.00,
  `net_disbursed` decimal(12,2) NOT NULL,
  `interest_rate_monthly` decimal(5,4) NOT NULL,
  `interest_type` enum('flat','effective','annuity','declining_balance') DEFAULT 'flat',
  `installment_amount` decimal(10,2) NOT NULL,
  `frequency` enum('daily','weekly','biweekly','monthly') DEFAULT 'daily',
  `total_installments` int(11) NOT NULL,
  `paid_installments` int(11) DEFAULT 0,
  `application_date` date NOT NULL,
  `approval_date` date DEFAULT NULL,
  `disbursement_date` date DEFAULT NULL,
  `first_payment_date` date DEFAULT NULL,
  `maturity_date` date DEFAULT NULL,
  `completion_date` date DEFAULT NULL,
  `status` enum('draft','submitted','under_review','approved','rejected','disbursed','active','late','defaulted','completed','cancelled') DEFAULT 'draft',
  `rejection_reason` text DEFAULT NULL,
  `cancellation_reason` text DEFAULT NULL,
  `collateral_type` enum('none','personal_guarantee','corporate_guarantee','asset','deposit','savings') DEFAULT 'none',
  `collateral_value` decimal(12,2) DEFAULT 0.00,
  `collateral_description` text DEFAULT NULL,
  `guarantor_id` int(11) DEFAULT NULL,
  `guarantor_relationship` varchar(50) DEFAULT NULL,
  `credit_score_at_application` int(11) DEFAULT NULL,
  `risk_level_at_application` enum('low','medium','high','very_high') DEFAULT NULL,
  `risk_score` decimal(5,2) DEFAULT NULL,
  `risk_factors` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`risk_factors`)),
  `total_principal` decimal(12,2) GENERATED ALWAYS AS (`amount`) STORED,
  `total_interest` decimal(12,2) DEFAULT 0.00,
  `total_late_fees` decimal(12,2) DEFAULT 0.00,
  `total_paid` decimal(12,2) DEFAULT 0.00,
  `total_outstanding` decimal(12,2) GENERATED ALWAYS AS (`total_principal` + `total_interest` + `total_late_fees` - `total_paid`) STORED,
  `days_past_due` int(11) DEFAULT 0,
  `purpose` text DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `document_attachments` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`document_attachments`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `created_by` int(11) NOT NULL,
  `updated_by` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `loan_products`
--

CREATE TABLE `loan_products` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `code` varchar(20) NOT NULL,
  `description` text DEFAULT NULL,
  `product_category` enum('mikro','kecil','menengah','konsumtif','produktif','pendidikan','kesehatan','khusus') DEFAULT 'mikro',
  `min_amount` decimal(12,2) NOT NULL,
  `max_amount` decimal(12,2) NOT NULL,
  `default_amount` decimal(12,2) DEFAULT NULL,
  `amount_increment` decimal(8,2) DEFAULT 100000.00,
  `min_tenor_days` int(11) NOT NULL,
  `max_tenor_days` int(11) NOT NULL,
  `default_tenor_days` int(11) DEFAULT NULL,
  `tenor_increment_days` int(11) DEFAULT 1,
  `interest_rate_monthly` decimal(5,4) NOT NULL,
  `interest_type` enum('flat','effective','annuity','declining_balance') DEFAULT 'flat',
  `admin_fee_rate` decimal(5,4) DEFAULT 0.0200,
  `admin_fee_fixed` decimal(10,2) DEFAULT 0.00,
  `processing_fee_rate` decimal(5,4) DEFAULT 0.0000,
  `processing_fee_fixed` decimal(10,2) DEFAULT 0.00,
  `late_fee_rate` decimal(5,4) DEFAULT 0.0100,
  `late_fee_fixed` decimal(10,2) DEFAULT 0.00,
  `early_payment_fee_rate` decimal(5,4) DEFAULT 0.0000,
  `min_credit_score` int(11) DEFAULT 0,
  `max_credit_score` int(11) DEFAULT 100,
  `min_membership_days` int(11) DEFAULT 0,
  `max_age_years` int(11) DEFAULT 0,
  `min_monthly_income` decimal(12,2) DEFAULT NULL,
  `required_documents` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`required_documents`)),
  `collateral_required` tinyint(1) DEFAULT 0,
  `collateral_type` enum('none','personal_guarantee','corporate_guarantee','asset','deposit') DEFAULT 'none',
  `target_member_types` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`target_member_types`)),
  `target_business_types` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`target_business_types`)),
  `target_income_range` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`target_income_range`)),
  `target_geographic_areas` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`target_geographic_areas`)),
  `installment_frequency` enum('daily','weekly','biweekly','monthly','quarterly') DEFAULT 'daily',
  `grace_period_days` int(11) DEFAULT 0,
  `disbursement_method` enum('cash','transfer','digital_wallet') DEFAULT 'transfer',
  `repayment_method` enum('cash','auto_debit','digital_wallet','bank_transfer') DEFAULT 'cash',
  `is_active` tinyint(1) DEFAULT 1,
  `is_promotional` tinyint(1) DEFAULT 0,
  `priority_level` int(11) DEFAULT 0,
  `effective_date` date DEFAULT NULL,
  `expiry_date` date DEFAULT NULL,
  `terms_conditions` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `loan_products`
--

INSERT INTO `loan_products` (`id`, `name`, `code`, `description`, `product_category`, `min_amount`, `max_amount`, `default_amount`, `amount_increment`, `min_tenor_days`, `max_tenor_days`, `default_tenor_days`, `tenor_increment_days`, `interest_rate_monthly`, `interest_type`, `admin_fee_rate`, `admin_fee_fixed`, `processing_fee_rate`, `processing_fee_fixed`, `late_fee_rate`, `late_fee_fixed`, `early_payment_fee_rate`, `min_credit_score`, `max_credit_score`, `min_membership_days`, `max_age_years`, `min_monthly_income`, `required_documents`, `collateral_required`, `collateral_type`, `target_member_types`, `target_business_types`, `target_income_range`, `target_geographic_areas`, `installment_frequency`, `grace_period_days`, `disbursement_method`, `repayment_method`, `is_active`, `is_promotional`, `priority_level`, `effective_date`, `expiry_date`, `terms_conditions`, `created_at`, `updated_at`, `created_by`, `updated_by`) VALUES
(1, 'Pinjaman Mikro Kewer', 'PMK001', 'Pinjaman mikro untuk kebutuhan harian', 'mikro', 500000.00, 5000000.00, NULL, 100000.00, 30, 90, NULL, 1, 0.0300, 'flat', 0.0200, 0.00, 0.0000, 0.00, 0.0100, 0.00, 0.0000, 0, 100, 0, 0, NULL, NULL, 0, 'none', NULL, NULL, NULL, NULL, 'daily', 0, 'transfer', 'cash', 1, 0, 0, NULL, NULL, NULL, '2026-03-26 19:07:11', '2026-03-26 19:07:11', NULL, NULL),
(2, 'Pinjaman Kecil Mawar', 'PMK002', 'Pinjaman kecil untuk modal usaha', 'kecil', 5000000.00, 10000000.00, NULL, 100000.00, 60, 180, NULL, 1, 0.0250, 'flat', 0.0150, 0.00, 0.0000, 0.00, 0.0100, 0.00, 0.0000, 0, 100, 0, 0, NULL, NULL, 0, 'none', NULL, NULL, NULL, NULL, 'daily', 0, 'transfer', 'cash', 1, 0, 0, NULL, NULL, NULL, '2026-03-26 19:07:11', '2026-03-26 19:07:11', NULL, NULL),
(3, 'Pinjaman Produktif', 'PMK003', 'Pinjaman untuk modal produktif', 'menengah', 10000000.00, 50000000.00, NULL, 100000.00, 90, 360, NULL, 1, 0.0200, 'flat', 0.0100, 0.00, 0.0000, 0.00, 0.0100, 0.00, 0.0000, 0, 100, 0, 0, NULL, NULL, 0, 'none', NULL, NULL, NULL, NULL, 'daily', 0, 'transfer', 'cash', 1, 0, 0, NULL, NULL, NULL, '2026-03-26 19:07:11', '2026-03-26 19:07:11', NULL, NULL);

-- --------------------------------------------------------

--
-- Struktur dari tabel `master_banks`
--

CREATE TABLE `master_banks` (
  `id` int(11) NOT NULL,
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
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `master_banks`
--

INSERT INTO `master_banks` (`id`, `code`, `name`, `short_name`, `bank_type`, `bic_code`, `headquarters`, `website`, `phone`, `email`, `description`, `is_active`, `created_at`, `updated_at`) VALUES
(1, '014', 'Bank Central Asia', 'BCA', 'private', 'CENAIDJA', 'Jakarta', 'https://www.bca.co.id', '1500888', 'halo@bca.co.id', 'Bank swasta terbesar di Indonesia', 1, '2026-03-26 19:23:47', '2026-03-26 19:23:47'),
(2, '008', 'Bank Mandiri', 'Mandiri', 'government', 'BDRIIDJA', 'Jakarta', 'https://www.bankmandiri.co.id', '14000', 'mandiri@bankmandiri.co.id', 'Bank milik pemerintah', 1, '2026-03-26 19:23:47', '2026-03-26 19:23:47'),
(3, '002', 'Bank Rakyat Indonesia', 'BRI', 'government', 'BRINIDJA', 'Jakarta', 'https://www.bri.co.id', '1500176', 'halo@bri.co.id', 'Bank untuk UMKM', 1, '2026-03-26 19:23:47', '2026-03-26 19:23:47'),
(4, '009', 'Bank Negara Indonesia', 'BNI', 'government', 'BNINIDJA', 'Jakarta', 'https://www.bni.co.id', '1500646', 'bni@bni.co.id', 'Bank BUMN pertama', 1, '2026-03-26 19:23:47', '2026-03-26 19:23:47'),
(5, '011', 'Danamon', 'Danamon', 'private', 'DANAINID', 'Jakarta', 'https://www.danamon.co.id', '1500688', 'cs@danamon.co.id', 'Bank swasta', 1, '2026-03-26 19:23:47', '2026-03-26 19:23:47'),
(6, '019', 'Bank Panin', 'Panin', 'private', 'PANINIDJA', 'Jakarta', 'https://www.panin.co.id', '1500788', 'info@panin.co.id', 'Bank swasta', 1, '2026-03-26 19:23:47', '2026-03-26 19:23:47'),
(7, '022', 'CIMB Niaga', 'CIMB', 'private', 'BIBAIDJA', 'Jakarta', 'https://www.cimbniaga.co.id', '1500800', 'cimbniaga@cimbniaga.co.id', 'Bank CIMB Group', 1, '2026-03-26 19:23:47', '2026-03-26 19:23:47'),
(8, '031', 'Bank Permata', 'Permata', 'private', 'BBBAIDJA', 'Jakarta', 'https://www.permatabank.co.id', '1500111', 'info@permatabank.co.id', 'Bank Permata', 1, '2026-03-26 19:23:47', '2026-03-26 19:23:47'),
(9, '213', 'Bank Syariah Mandiri', 'BSM', 'syariah', 'BSMDIDJA', 'Jakarta', 'https://www.syariahmandiri.co.id', '1500155', 'bsm@syariahmandiri.co.id', 'Bank syariah', 1, '2026-03-26 19:23:47', '2026-03-26 19:23:47'),
(10, '425', 'Bank BJB', 'BJB', 'government', 'BJBAIDJA', 'Bandung', 'https://www.bankbjb.co.id', '1500667', 'bjb@bankbjb.co.id', 'Bank BPD Jawa Barat', 1, '2026-03-26 19:23:47', '2026-03-26 19:23:47');

-- --------------------------------------------------------

--
-- Struktur dari tabel `master_blood_types`
--

CREATE TABLE `master_blood_types` (
  `id` int(11) NOT NULL,
  `code` varchar(5) NOT NULL COMMENT 'Golongan darah (A, B, AB, O)',
  `name` varchar(20) NOT NULL COMMENT 'Nama lengkap',
  `rhesus_factor` enum('+','-') DEFAULT '+' COMMENT 'Faktor Rhesus',
  `description` text DEFAULT NULL COMMENT 'Deskripsi',
  `is_active` tinyint(1) DEFAULT 1 COMMENT 'Status aktif',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `master_blood_types`
--

INSERT INTO `master_blood_types` (`id`, `code`, `name`, `rhesus_factor`, `description`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'A+', 'A Positif', '+', 'Golongan darah A positif', 1, '2026-03-26 19:13:04', '2026-03-26 19:13:04'),
(2, 'A-', 'A Negatif', '-', 'Golongan darah A negatif', 1, '2026-03-26 19:13:04', '2026-03-26 19:13:04'),
(3, 'B+', 'B Positif', '+', 'Golongan darah B positif', 1, '2026-03-26 19:13:04', '2026-03-26 19:13:04'),
(4, 'B-', 'B Negatif', '-', 'Golongan darah B negatif', 1, '2026-03-26 19:13:04', '2026-03-26 19:13:04'),
(5, 'AB+', 'AB Positif', '+', 'Golongan darah AB positif', 1, '2026-03-26 19:13:04', '2026-03-26 19:13:04'),
(6, 'AB-', 'AB Negatif', '-', 'Golongan darah AB negatif', 1, '2026-03-26 19:13:04', '2026-03-26 19:13:04'),
(7, 'O+', 'O Positif', '+', 'Golongan darah O positif', 1, '2026-03-26 19:13:04', '2026-03-26 19:13:04'),
(8, 'O-', 'O Negatif', '-', 'Golongan darah O negatif', 1, '2026-03-26 19:13:04', '2026-03-26 19:13:04');

-- --------------------------------------------------------

--
-- Struktur dari tabel `master_business_types`
--

CREATE TABLE `master_business_types` (
  `id` int(11) NOT NULL,
  `code` varchar(20) NOT NULL COMMENT 'Kode jenis usaha',
  `name` varchar(100) NOT NULL COMMENT 'Nama jenis usaha',
  `category` varchar(50) DEFAULT NULL COMMENT 'Kategori usaha',
  `description` text DEFAULT NULL COMMENT 'Deskripsi',
  `risk_level` enum('low','medium','high') DEFAULT 'medium' COMMENT 'Tingkat risiko',
  `is_active` tinyint(1) DEFAULT 1 COMMENT 'Status aktif',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `master_business_types`
--

INSERT INTO `master_business_types` (`id`, `code`, `name`, `category`, `description`, `risk_level`, `is_active`, `created_at`, `updated_at`) VALUES
(12, 'TRS', 'Toko', 'Retail', 'Toko kelontong/semako', 'low', 1, '2026-03-26 19:23:25', '2026-03-26 19:23:25'),
(13, 'RSL', 'Restoran', 'Food & Beverage', 'Rumah makan/kafe', 'medium', 1, '2026-03-26 19:23:25', '2026-03-26 19:23:25'),
(14, 'JAS', 'Jasa', 'Services', 'Berbagai jenis jasa', 'medium', 1, '2026-03-26 19:23:25', '2026-03-26 19:23:25'),
(15, 'MNF', 'Manufaktur', 'Industri', 'Produksi barang', 'high', 1, '2026-03-26 19:23:25', '2026-03-26 19:23:25'),
(16, 'TEK', 'Teknologi', 'Technology', 'IT dan teknologi', 'medium', 1, '2026-03-26 19:23:25', '2026-03-26 19:23:25'),
(17, 'PTR', 'Pertanian', 'Agrikultur', 'Usaha pertanian', 'medium', 1, '2026-03-26 19:23:25', '2026-03-26 19:23:25'),
(18, 'TRD', 'Perdagangan', 'Trade', 'Distributor/grosir', 'medium', 1, '2026-03-26 19:23:25', '2026-03-26 19:23:25'),
(19, 'TRP', 'Transportasi', 'Transportation', 'Jasa transportasi', 'high', 1, '2026-03-26 19:23:25', '2026-03-26 19:23:25'),
(20, 'KSH', 'Kesehatan', 'Healthcare', 'Fasilitas kesehatan', 'medium', 1, '2026-03-26 19:23:25', '2026-03-26 19:23:25'),
(21, 'PND', 'Pendidikan', 'Education', 'Lembaga pendidikan', 'low', 1, '2026-03-26 19:23:25', '2026-03-26 19:23:25'),
(22, 'LNN', 'Lainnya', 'Other', 'Jenis usaha lainnya', 'medium', 1, '2026-03-26 19:23:25', '2026-03-26 19:23:25');

-- --------------------------------------------------------

--
-- Struktur dari tabel `master_communication_channels`
--

CREATE TABLE `master_communication_channels` (
  `id` int(11) NOT NULL,
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
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `master_compliance_statuses`
--

CREATE TABLE `master_compliance_statuses` (
  `id` int(11) NOT NULL,
  `code` varchar(20) NOT NULL COMMENT 'Kode status compliance',
  `name` varchar(50) NOT NULL COMMENT 'Nama status',
  `category` enum('kyc','aml','audit','legal','other') NOT NULL,
  `description` text DEFAULT NULL COMMENT 'Deskripsi',
  `next_step` text DEFAULT NULL COMMENT 'Langkah berikutnya',
  `is_active` tinyint(1) DEFAULT 1 COMMENT 'Status aktif',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `master_countries`
--

CREATE TABLE `master_countries` (
  `id` int(11) NOT NULL,
  `code` varchar(3) NOT NULL COMMENT 'Kode negara (ISO 3166-1 alpha-3)',
  `name` varchar(100) NOT NULL COMMENT 'Nama negara',
  `name_local` varchar(100) DEFAULT NULL COMMENT 'Nama lokal',
  `continent` varchar(50) DEFAULT NULL COMMENT 'Benua',
  `capital` varchar(100) DEFAULT NULL COMMENT 'Ibukota',
  `currency_code` varchar(3) DEFAULT NULL COMMENT 'Kode mata uang',
  `phone_code` varchar(10) DEFAULT NULL COMMENT 'Kode telepon',
  `is_active` tinyint(1) DEFAULT 1 COMMENT 'Status aktif',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `master_currencies`
--

CREATE TABLE `master_currencies` (
  `id` int(11) NOT NULL,
  `code` varchar(3) NOT NULL COMMENT 'Kode mata uang (ISO 4217)',
  `name` varchar(50) NOT NULL COMMENT 'Nama mata uang',
  `symbol` varchar(10) NOT NULL COMMENT 'Simbol mata uang',
  `decimal_places` int(11) DEFAULT 2 COMMENT 'Jumlah desimal',
  `is_active` tinyint(1) DEFAULT 1 COMMENT 'Status aktif',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `master_device_types`
--

CREATE TABLE `master_device_types` (
  `id` int(11) NOT NULL,
  `code` varchar(20) NOT NULL COMMENT 'Kode device',
  `name` varchar(50) NOT NULL COMMENT 'Nama device',
  `category` enum('mobile','tablet','desktop','laptop','other') NOT NULL,
  `os_name` varchar(50) DEFAULT NULL COMMENT 'Nama OS',
  `browser_name` varchar(50) DEFAULT NULL COMMENT 'Nama browser',
  `description` text DEFAULT NULL COMMENT 'Deskripsi',
  `is_active` tinyint(1) DEFAULT 1 COMMENT 'Status aktif',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `master_document_types`
--

CREATE TABLE `master_document_types` (
  `id` int(11) NOT NULL,
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
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `master_document_types`
--

INSERT INTO `master_document_types` (`id`, `code`, `name`, `category`, `description`, `is_required`, `expiry_required`, `file_types_allowed`, `max_file_size_mb`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'KTP', 'KTP', 'identity', 'Kartu Tanda Penduduk', 1, 1, 'JPG,JPEG,PNG,PDF', 5, 1, '2026-03-26 19:23:36', '2026-03-26 19:23:36'),
(2, 'KK', 'Kartu Keluarga', 'identity', 'Kartu Keluarga', 1, 1, 'JPG,JPEG,PNG,PDF', 5, 1, '2026-03-26 19:23:36', '2026-03-26 19:23:36'),
(3, 'AKL', 'Akta Kelahiran', 'legal', 'Akta Kelahiran', 0, 0, 'JPG,JPEG,PNG,PDF', 5, 1, '2026-03-26 19:23:36', '2026-03-26 19:23:36'),
(4, 'AKP', 'Akta Perkawinan', 'legal', 'Akta Perkawinan', 0, 0, 'JPG,JPEG,PNG,PDF', 5, 1, '2026-03-26 19:23:36', '2026-03-26 19:23:36'),
(5, 'AKC', 'Akta Cerai', 'legal', 'Akta Perceraian', 0, 0, 'JPG,JPEG,PNG,PDF', 5, 1, '2026-03-26 19:23:36', '2026-03-26 19:23:36'),
(6, 'NPWP', 'NPWP', 'financial', 'Nomor Pokok Wajib Pajak', 0, 0, 'JPG,JPEG,PNG,PDF', 5, 1, '2026-03-26 19:23:36', '2026-03-26 19:23:36'),
(7, 'BPK', 'BPJS Kesehatan', 'financial', 'Kartu BPJS Kesehatan', 0, 1, 'JPG,JPEG,PNG,PDF', 5, 1, '2026-03-26 19:23:36', '2026-03-26 19:23:36'),
(8, 'BPT', 'BPJS Ketenagakerjaan', 'financial', 'Kartu BPJS Ketenagakerjaan', 0, 1, 'JPG,JPEG,PNG,PDF', 5, 1, '2026-03-26 19:23:36', '2026-03-26 19:23:36'),
(9, 'SIM', 'SIM', 'identity', 'Surat Izin Mengemudi', 0, 1, 'JPG,JPEG,PNG,PDF', 5, 1, '2026-03-26 19:23:36', '2026-03-26 19:23:36'),
(10, 'PSP', 'Paspor', 'identity', 'Paspor', 0, 1, 'JPG,JPEG,PNG,PDF', 5, 1, '2026-03-26 19:23:36', '2026-03-26 19:23:36'),
(11, 'IJZ', 'Ijazah', 'education', 'Ijazah pendidikan', 0, 0, 'JPG,JPEG,PNG,PDF', 5, 1, '2026-03-26 19:23:36', '2026-03-26 19:23:36'),
(12, 'SRT', 'Surat Referensi', 'business', 'Surat referensi kerja/usaha', 0, 0, 'PDF,DOC,DOCX', 5, 1, '2026-03-26 19:23:36', '2026-03-26 19:23:36'),
(13, 'LNN', 'Lainnya', 'other', 'Dokumen lainnya', 0, 0, 'PDF,DOC,DOCX,JPG,JPEG,PNG', 5, 1, '2026-03-26 19:23:36', '2026-03-26 19:23:36');

-- --------------------------------------------------------

--
-- Struktur dari tabel `master_education_levels`
--

CREATE TABLE `master_education_levels` (
  `id` int(11) NOT NULL,
  `code` varchar(10) NOT NULL COMMENT 'Kode tingkat pendidikan',
  `name` varchar(50) NOT NULL COMMENT 'Nama tingkat pendidikan',
  `level_order` int(11) NOT NULL COMMENT 'Urutan level',
  `description` text DEFAULT NULL COMMENT 'Deskripsi',
  `is_active` tinyint(1) DEFAULT 1 COMMENT 'Status aktif',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `master_education_levels`
--

INSERT INTO `master_education_levels` (`id`, `code`, `name`, `level_order`, `description`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'TDS', 'Tidak Sekolah', 0, 'Tidak pernah sekolah', 1, '2026-03-26 19:13:04', '2026-03-26 19:13:04'),
(2, 'TK', 'TK', 1, 'Taman Kanak-Kanak', 1, '2026-03-26 19:13:04', '2026-03-26 19:13:04'),
(3, 'SD', 'SD', 2, 'Sekolah Dasar', 1, '2026-03-26 19:13:04', '2026-03-26 19:13:04'),
(4, 'SMP', 'SMP', 3, 'Sekolah Menengah Pertama', 1, '2026-03-26 19:13:04', '2026-03-26 19:13:04'),
(5, 'SMA', 'SMA', 4, 'Sekolah Menengah Atas', 1, '2026-03-26 19:13:04', '2026-03-26 19:13:04'),
(6, 'SMK', 'SMK', 4, 'Sekolah Menengah Kejuruan', 1, '2026-03-26 19:13:04', '2026-03-26 19:13:04'),
(7, 'MA', 'MA', 4, 'Madrasah Aliyah', 1, '2026-03-26 19:13:04', '2026-03-26 19:13:04'),
(8, 'D1', 'D1', 5, 'Diploma 1', 1, '2026-03-26 19:13:04', '2026-03-26 19:13:04'),
(9, 'D2', 'D2', 5, 'Diploma 2', 1, '2026-03-26 19:13:04', '2026-03-26 19:13:04'),
(10, 'D3', 'D3', 5, 'Diploma 3', 1, '2026-03-26 19:13:04', '2026-03-26 19:13:04'),
(11, 'D4', 'D4', 6, 'Diploma 4', 1, '2026-03-26 19:13:04', '2026-03-26 19:13:04'),
(12, 'S1', 'S1', 6, 'Strata 1 (Sarjana)', 1, '2026-03-26 19:13:04', '2026-03-26 19:13:04'),
(13, 'S2', 'S2', 7, 'Strata 2 (Magister)', 1, '2026-03-26 19:13:04', '2026-03-26 19:13:04'),
(14, 'S3', 'S3', 8, 'Strata 3 (Doktor)', 1, '2026-03-26 19:13:04', '2026-03-26 19:13:04'),
(15, 'PRS', 'Profesi', 6, 'Pendidikan Profesi', 1, '2026-03-26 19:13:04', '2026-03-26 19:13:04'),
(16, 'LNN', 'Lainnya', 9, 'Pendidikan lainnya', 1, '2026-03-26 19:13:04', '2026-03-26 19:13:04');

-- --------------------------------------------------------

--
-- Struktur dari tabel `master_fee_types`
--

CREATE TABLE `master_fee_types` (
  `id` int(11) NOT NULL,
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
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `master_id_types`
--

CREATE TABLE `master_id_types` (
  `id` int(11) NOT NULL,
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
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `master_notification_types`
--

CREATE TABLE `master_notification_types` (
  `id` int(11) NOT NULL,
  `code` varchar(20) NOT NULL COMMENT 'Kode jenis notifikasi',
  `name` varchar(100) NOT NULL COMMENT 'Nama jenis notifikasi',
  `category` enum('info','warning','error','success','reminder','alert','promotion','system') NOT NULL,
  `priority` enum('low','medium','high','urgent') DEFAULT 'medium',
  `description` text DEFAULT NULL COMMENT 'Deskripsi',
  `template_path` varchar(255) DEFAULT NULL COMMENT 'Path template',
  `is_active` tinyint(1) DEFAULT 1 COMMENT 'Status aktif',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `master_occupations`
--

CREATE TABLE `master_occupations` (
  `id` int(11) NOT NULL,
  `code` varchar(20) NOT NULL COMMENT 'Kode pekerjaan',
  `name` varchar(100) NOT NULL COMMENT 'Nama pekerjaan',
  `category` varchar(50) DEFAULT NULL COMMENT 'Kategori pekerjaan',
  `bps_code` varchar(20) DEFAULT NULL COMMENT 'Kode BPS',
  `description` text DEFAULT NULL COMMENT 'Deskripsi',
  `income_level` enum('low','medium','high','none') DEFAULT NULL COMMENT 'Tingkat pendapatan',
  `is_active` tinyint(1) DEFAULT 1 COMMENT 'Status aktif',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `master_occupations`
--

INSERT INTO `master_occupations` (`id`, `code`, `name`, `category`, `bps_code`, `description`, `income_level`, `is_active`, `created_at`, `updated_at`) VALUES
(1341, 'WIR', 'Wiraswasta', 'Bisnis', '5111', 'Pengusaha', 'medium', 1, '2026-03-26 19:23:09', '2026-03-26 19:23:09'),
(1342, 'TRD', 'Pedagang', 'Bisnis', '5121', 'Pengguna jasa', 'medium', 1, '2026-03-26 19:23:09', '2026-03-26 19:23:09'),
(1343, 'PTR', 'Petani', 'Pertanian', '6111', 'Tenaga pertanian', 'low', 1, '2026-03-26 19:23:09', '2026-03-26 19:23:09'),
(1344, 'NLN', 'Nelayan', 'Perikanan', '6121', 'Tenaga perikanan', 'low', 1, '2026-03-26 19:23:09', '2026-03-26 19:23:09'),
(1345, 'BRH', 'Buruh', 'Industri', '7111', 'Tenaga industri', 'low', 1, '2026-03-26 19:23:09', '2026-03-26 19:23:09'),
(1346, 'PLJ', 'Pelajar', 'Pendidikan', '8111', 'Sedang belajar', 'low', 1, '2026-03-26 19:23:09', '2026-03-26 19:23:09'),
(1347, 'MHS', 'Mahasiswa', 'Pendidikan', '8121', 'Sedang kuliah', 'low', 1, '2026-03-26 19:23:09', '2026-03-26 19:23:09'),
(1348, 'PEN', 'Pensiunan', 'Lainnya', '9111', 'Sudah pensiun', 'medium', 1, '2026-03-26 19:23:09', '2026-03-26 19:23:09'),
(1349, 'TGL', 'Tidak Bekerja', 'Lainnya', '9999', 'Tidak memiliki pekerjaan', 'low', 1, '2026-03-26 19:23:09', '2026-03-26 19:23:09'),
(1350, 'LNN', 'Lainnya', 'Lainnya', '9998', 'Pekerjaan lainnya', 'medium', 1, '2026-03-26 19:23:09', '2026-03-26 19:23:09');

-- --------------------------------------------------------

--
-- Struktur dari tabel `master_payment_methods`
--

CREATE TABLE `master_payment_methods` (
  `id` int(11) NOT NULL,
  `code` varchar(20) NOT NULL COMMENT 'Kode metode pembayaran',
  `name` varchar(50) NOT NULL COMMENT 'Nama metode pembayaran',
  `category` enum('cash','bank_transfer','digital_wallet','card','auto_debit','check','other') NOT NULL,
  `description` text DEFAULT NULL COMMENT 'Deskripsi',
  `processing_fee_rate` decimal(5,4) DEFAULT 0.0000 COMMENT 'Biaya proses (%)',
  `min_amount` decimal(12,2) DEFAULT NULL COMMENT 'Jumlah minimal',
  `max_amount` decimal(12,2) DEFAULT NULL COMMENT 'Jumlah maksimal',
  `is_active` tinyint(1) DEFAULT 1 COMMENT 'Status aktif',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `master_payment_methods`
--

INSERT INTO `master_payment_methods` (`id`, `code`, `name`, `category`, `description`, `processing_fee_rate`, `min_amount`, `max_amount`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'CASH', 'Tunai', 'cash', 'Pembayaran tunai', 0.0000, 0.00, 999999999.00, 1, '2026-03-26 19:23:58', '2026-03-26 19:23:58'),
(2, 'TRF', 'Transfer Bank', 'bank_transfer', 'Transfer antar bank', 0.0050, 10000.00, 999999999.00, 1, '2026-03-26 19:23:58', '2026-03-26 19:23:58'),
(3, 'OVO', 'OVO', 'digital_wallet', 'Dompet digital OVO', 0.0100, 1000.00, 5000000.00, 1, '2026-03-26 19:23:58', '2026-03-26 19:23:58'),
(4, 'GPA', 'GoPay', 'digital_wallet', 'Dompet digital GoPay', 0.0100, 1000.00, 5000000.00, 1, '2026-03-26 19:23:58', '2026-03-26 19:23:58'),
(5, 'DNA', 'DANA', 'digital_wallet', 'Dompet digital DANA', 0.0100, 1000.00, 5000000.00, 1, '2026-03-26 19:23:58', '2026-03-26 19:23:58'),
(6, 'SHO', 'ShopeePay', 'digital_wallet', 'Dompet digital ShopeePay', 0.0100, 1000.00, 5000000.00, 1, '2026-03-26 19:23:58', '2026-03-26 19:23:58'),
(7, 'ATM', 'ATM Transfer', 'bank_transfer', 'Transfer via ATM', 0.0075, 10000.00, 999999999.00, 1, '2026-03-26 19:23:58', '2026-03-26 19:23:58'),
(8, 'MBK', 'Mobile Banking', 'bank_transfer', 'Transfer via mobile banking', 0.0050, 10000.00, 999999999.00, 1, '2026-03-26 19:23:58', '2026-03-26 19:23:58'),
(9, 'IBK', 'Internet Banking', 'bank_transfer', 'Transfer via internet banking', 0.0050, 10000.00, 999999999.00, 1, '2026-03-26 19:23:58', '2026-03-26 19:23:58'),
(10, 'CHQ', 'Cek', 'check', 'Pembayaran dengan cek', 0.0150, 100000.00, 999999999.00, 1, '2026-03-26 19:23:58', '2026-03-26 19:23:58'),
(11, 'GIR', 'Bilyet Giro', 'check', 'Pembayaran dengan bilyet giro', 0.0100, 100000.00, 999999999.00, 1, '2026-03-26 19:23:58', '2026-03-26 19:23:58'),
(12, 'ADB', 'Auto Debit', 'auto_debit', 'Potongan otomatis', 0.0050, 10000.00, 999999999.00, 1, '2026-03-26 19:23:58', '2026-03-26 19:23:58');

-- --------------------------------------------------------

--
-- Struktur dari tabel `master_provinces`
--

CREATE TABLE `master_provinces` (
  `id` int(11) NOT NULL,
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
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `master_relationship_types`
--

CREATE TABLE `master_relationship_types` (
  `id` int(11) NOT NULL,
  `code` varchar(20) NOT NULL COMMENT 'Kode hubungan',
  `name` varchar(50) NOT NULL COMMENT 'Nama hubungan',
  `category` enum('family','business','legal','other') NOT NULL,
  `relationship_level` enum('1','2','3','4','5+') NOT NULL COMMENT 'Tingkat hubungan',
  `inverse_relationship_id` int(11) DEFAULT NULL COMMENT 'Hubungan invers',
  `description` text DEFAULT NULL COMMENT 'Deskripsi',
  `is_active` tinyint(1) DEFAULT 1 COMMENT 'Status aktif',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `master_religions`
--

CREATE TABLE `master_religions` (
  `id` int(11) NOT NULL,
  `code` varchar(10) NOT NULL COMMENT 'Kode agama',
  `name` varchar(50) NOT NULL COMMENT 'Nama agama',
  `description` text DEFAULT NULL COMMENT 'Deskripsi',
  `is_active` tinyint(1) DEFAULT 1 COMMENT 'Status aktif',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `master_religions`
--

INSERT INTO `master_religions` (`id`, `code`, `name`, `description`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'ISL', 'Islam', 'Agama Islam', 1, '2026-03-26 19:13:04', '2026-03-26 19:13:04'),
(2, 'KRT', 'Kristen', 'Agama Kristen Protestan', 1, '2026-03-26 19:13:04', '2026-03-26 19:13:04'),
(3, 'KTH', 'Katolik', 'Agama Katolik', 1, '2026-03-26 19:13:04', '2026-03-26 19:13:04'),
(4, 'HDN', 'Hindu', 'Agama Hindu', 1, '2026-03-26 19:13:04', '2026-03-26 19:13:04'),
(5, 'BDH', 'Budha', 'Agama Budha', 1, '2026-03-26 19:13:04', '2026-03-26 19:13:04'),
(6, 'KHC', 'Konghucu', 'Agama Konghucu', 1, '2026-03-26 19:13:04', '2026-03-26 19:13:04'),
(7, 'LNN', 'Lainnya', 'Agama lainnya', 1, '2026-03-26 19:13:04', '2026-03-26 19:13:04'),
(8, 'TDA', 'Tidak Ada', 'Tidak beragama', 1, '2026-03-26 19:13:04', '2026-03-26 19:13:04');

-- --------------------------------------------------------

--
-- Struktur dari tabel `master_risk_levels`
--

CREATE TABLE `master_risk_levels` (
  `id` int(11) NOT NULL,
  `code` varchar(20) NOT NULL COMMENT 'Kode tingkat risiko',
  `name` varchar(50) NOT NULL COMMENT 'Nama tingkat risiko',
  `score_min` int(11) NOT NULL COMMENT 'Skor minimal',
  `score_max` int(11) NOT NULL COMMENT 'Skor maksimal',
  `color_code` varchar(10) DEFAULT NULL COMMENT 'Kode warna',
  `description` text DEFAULT NULL COMMENT 'Deskripsi',
  `action_required` text DEFAULT NULL COMMENT 'Tindakan yang diperlukan',
  `is_active` tinyint(1) DEFAULT 1 COMMENT 'Status aktif',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `master_setting_categories`
--

CREATE TABLE `master_setting_categories` (
  `id` int(11) NOT NULL,
  `code` varchar(20) NOT NULL COMMENT 'Kode kategori',
  `name` varchar(100) NOT NULL COMMENT 'Nama kategori',
  `description` text DEFAULT NULL COMMENT 'Deskripsi',
  `parent_category_id` int(11) DEFAULT NULL COMMENT 'Kategori induk',
  `is_active` tinyint(1) DEFAULT 1 COMMENT 'Status aktif',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `master_status_types`
--

CREATE TABLE `master_status_types` (
  `id` int(11) NOT NULL,
  `code` varchar(20) NOT NULL COMMENT 'Kode status',
  `name` varchar(50) NOT NULL COMMENT 'Nama status',
  `category` enum('user','member','loan','savings','document','transaction','other') NOT NULL,
  `color_code` varchar(10) DEFAULT NULL COMMENT 'Kode warna',
  `description` text DEFAULT NULL COMMENT 'Deskripsi',
  `next_statuses` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Status berikutnya yang mungkin' CHECK (json_valid(`next_statuses`)),
  `is_active` tinyint(1) DEFAULT 1 COMMENT 'Status aktif',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `master_transaction_types`
--

CREATE TABLE `master_transaction_types` (
  `id` int(11) NOT NULL,
  `code` varchar(20) NOT NULL COMMENT 'Kode jenis transaksi',
  `name` varchar(100) NOT NULL COMMENT 'Nama jenis transaksi',
  `category` enum('loan','savings','fee','transfer','adjustment','other') NOT NULL,
  `direction` enum('in','out','neutral') NOT NULL COMMENT 'Arah transaksi',
  `description` text DEFAULT NULL COMMENT 'Deskripsi',
  `affects_balance` tinyint(1) DEFAULT 1 COMMENT 'Mempengaruhi saldo',
  `requires_approval` tinyint(1) DEFAULT 0 COMMENT 'Memerlukan persetujuan',
  `is_active` tinyint(1) DEFAULT 1 COMMENT 'Status aktif',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `master_user_roles`
--

CREATE TABLE `master_user_roles` (
  `id` int(11) NOT NULL,
  `code` varchar(20) NOT NULL COMMENT 'Kode role',
  `name` varchar(50) NOT NULL COMMENT 'Nama role',
  `display_name` varchar(100) DEFAULT NULL COMMENT 'Nama tampilan',
  `level` int(11) NOT NULL COMMENT 'Level role (1=highest)',
  `description` text DEFAULT NULL COMMENT 'Deskripsi',
  `permissions` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Hak akses' CHECK (json_valid(`permissions`)),
  `is_system_role` tinyint(1) DEFAULT 0 COMMENT 'Role sistem',
  `is_active` tinyint(1) DEFAULT 1 COMMENT 'Status aktif',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `master_user_roles`
--

INSERT INTO `master_user_roles` (`id`, `code`, `name`, `display_name`, `level`, `description`, `permissions`, `is_system_role`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'SADM', 'super_admin', 'Super Administrator', 1, 'Administrator sistem dengan akses penuh', '[\"all\"]', 1, 1, '2026-03-26 19:24:07', '2026-03-26 19:24:07'),
(2, 'ADM', 'admin', 'Administrator', 2, 'Administrator dengan akses luas', '[\"users\", \"members\", \"products\", \"reports\"]', 1, 1, '2026-03-26 19:24:07', '2026-03-26 19:24:07'),
(3, 'UHD', 'unit_head', 'Kepala Unit', 3, 'Kepala unit organisasi', '[\"unit_management\", \"staff_management\", \"reports\"]', 0, 1, '2026-03-26 19:24:07', '2026-03-26 19:24:07'),
(4, 'BHD', 'branch_head', 'Kepala Cabang', 4, 'Kepala cabang koperasi', '[\"branch_management\", \"member_management\", \"loan_approval\", \"reports\"]', 0, 1, '2026-03-26 19:24:07', '2026-03-26 19:24:07'),
(5, 'SUP', 'supervisor', 'Supervisor', 5, 'Supervisor operasional', '[\"staff_supervision\", \"collection_supervision\", \"reports\"]', 0, 1, '2026-03-26 19:24:07', '2026-03-26 19:24:07'),
(6, 'COL', 'collector', 'Kolektor', 6, 'Kolektor lapangan', '[\"collection\", \"member_visit\", \"mobile_access\"]', 0, 1, '2026-03-26 19:24:07', '2026-03-26 19:24:07'),
(7, 'CSH', 'cashier', 'Kasir', 6, 'Kasir koperasi', '[\"cash_management\", \"savings_transactions\", \"loan_payments\"]', 0, 1, '2026-03-26 19:24:07', '2026-03-26 19:24:07'),
(8, 'MBR', 'member', 'Anggota', 7, 'Anggota koperasi', '[\"self_service\", \"view_own_data\", \"apply_loan\"]', 0, 1, '2026-03-26 19:24:07', '2026-03-26 19:24:07'),
(9, 'GST', 'guest', 'Tamu', 8, 'Pengguna tamu dengan akses terbatas', '[\"view_public_info\"]', 1, 1, '2026-03-26 19:24:07', '2026-03-26 19:24:07');

-- --------------------------------------------------------

--
-- Struktur dari tabel `members`
--

CREATE TABLE `members` (
  `id` int(11) NOT NULL,
  `person_id` int(11) NOT NULL,
  `member_number` varchar(20) NOT NULL,
  `branch_id` int(11) NOT NULL,
  `member_type` enum('regular','premium','vip','corporate','student','senior') DEFAULT 'regular',
  `membership_category` enum('anggota_biasa','anggota_luar_biasa','anggota_kehormatan') DEFAULT 'anggota_biasa',
  `join_date` date NOT NULL,
  `activation_date` date DEFAULT NULL,
  `status` enum('pending','active','inactive','suspended','blacklisted','deceased') DEFAULT 'pending',
  `status_reason` text DEFAULT NULL,
  `max_active_loans` int(11) DEFAULT 2,
  `max_loan_amount` decimal(12,2) DEFAULT 10000000.00,
  `max_loan_tenor_days` int(11) DEFAULT 180,
  `current_active_loans` int(11) DEFAULT 0,
  `current_total_loans` decimal(12,2) DEFAULT 0.00,
  `current_late_count` int(11) DEFAULT 0,
  `current_late_days` int(11) DEFAULT 0,
  `current_npl_amount` decimal(12,2) DEFAULT 0.00,
  `mandatory_savings_amount` decimal(10,2) DEFAULT 0.00,
  `voluntary_savings_amount` decimal(10,2) DEFAULT 0.00,
  `current_mandatory_savings` decimal(12,2) DEFAULT 0.00,
  `current_voluntary_savings` decimal(12,2) DEFAULT 0.00,
  `total_savings` decimal(12,2) DEFAULT 0.00,
  `credit_score` int(11) DEFAULT 0,
  `risk_level` enum('low','medium','high','very_high') DEFAULT 'medium',
  `credit_limit` decimal(12,2) DEFAULT 0.00,
  `available_credit` decimal(12,2) DEFAULT 0.00,
  `last_credit_assessment` date DEFAULT NULL,
  `kyc_status` enum('pending','verified','rejected','expired') DEFAULT 'pending',
  `kyc_verified_at` timestamp NULL DEFAULT NULL,
  `kyc_verified_by` int(11) DEFAULT NULL,
  `aml_status` enum('pending','cleared','suspicious','blocked') DEFAULT 'pending',
  `aml_verified_at` timestamp NULL DEFAULT NULL,
  `aml_verified_by` int(11) DEFAULT NULL,
  `preferred_language` varchar(10) DEFAULT 'id',
  `preferred_contact` enum('phone','whatsapp','email','sms') DEFAULT 'phone',
  `notification_settings` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`notification_settings`)),
  `privacy_settings` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`privacy_settings`)),
  `referral_source` varchar(100) DEFAULT NULL,
  `referral_member_id` int(11) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `members`
--

INSERT INTO `members` (`id`, `person_id`, `member_number`, `branch_id`, `member_type`, `membership_category`, `join_date`, `activation_date`, `status`, `status_reason`, `max_active_loans`, `max_loan_amount`, `max_loan_tenor_days`, `current_active_loans`, `current_total_loans`, `current_late_count`, `current_late_days`, `current_npl_amount`, `mandatory_savings_amount`, `voluntary_savings_amount`, `current_mandatory_savings`, `current_voluntary_savings`, `total_savings`, `credit_score`, `risk_level`, `credit_limit`, `available_credit`, `last_credit_assessment`, `kyc_status`, `kyc_verified_at`, `kyc_verified_by`, `aml_status`, `aml_verified_at`, `aml_verified_by`, `preferred_language`, `preferred_contact`, `notification_settings`, `privacy_settings`, `referral_source`, `referral_member_id`, `notes`, `is_active`, `created_at`, `updated_at`, `created_by`, `updated_by`) VALUES
(1, 1, 'MBR202603270001', 2, 'regular', 'anggota_biasa', '2026-03-27', NULL, 'active', NULL, 2, 10000000.00, 180, 0, 0.00, 0, 0, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 'medium', 0.00, 0.00, NULL, 'pending', NULL, NULL, 'pending', NULL, NULL, 'id', 'phone', NULL, NULL, NULL, NULL, NULL, 1, '2026-03-26 19:07:05', '2026-03-26 19:07:05', NULL, NULL),
(2, 2, 'MBR202603270002', 2, 'regular', 'anggota_biasa', '2026-03-27', NULL, 'active', NULL, 2, 10000000.00, 180, 0, 0.00, 0, 0, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 'medium', 0.00, 0.00, NULL, 'pending', NULL, NULL, 'pending', NULL, NULL, 'id', 'phone', NULL, NULL, NULL, NULL, NULL, 1, '2026-03-26 19:07:05', '2026-03-26 19:07:05', NULL, NULL),
(3, 3, 'MBR202603270003', 3, 'regular', 'anggota_biasa', '2026-03-27', NULL, 'active', NULL, 2, 10000000.00, 180, 0, 0.00, 0, 0, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 'medium', 0.00, 0.00, NULL, 'pending', NULL, NULL, 'pending', NULL, NULL, 'id', 'phone', NULL, NULL, NULL, NULL, NULL, 1, '2026-03-26 19:07:05', '2026-03-26 19:07:05', NULL, NULL);

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `member_portfolio_view`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `member_portfolio_view` (
`id` int(11)
,`member_number` varchar(20)
,`name` varchar(100)
,`phone` varchar(15)
,`branch_name` varchar(100)
,`active_loans` bigint(21)
,`total_loans` decimal(34,2)
,`savings_accounts` bigint(21)
,`total_savings` decimal(34,2)
,`member_status` enum('pending','active','inactive','suspended','blacklisted','deceased')
,`join_date` date
);

-- --------------------------------------------------------

--
-- Struktur dari tabel `ppatk_reportable_transactions`
--

CREATE TABLE `ppatk_reportable_transactions` (
  `id` int(11) NOT NULL,
  `member_id` int(11) NOT NULL,
  `transaction_date` date NOT NULL,
  `amount` decimal(15,2) NOT NULL,
  `transaction_type` enum('cash_in','cash_out') NOT NULL,
  `cumulative_amount` decimal(15,2) NOT NULL,
  `reported` tinyint(1) DEFAULT 0,
  `reported_date` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `savings_accounts`
--

CREATE TABLE `savings_accounts` (
  `id` int(11) NOT NULL,
  `account_number` varchar(20) NOT NULL,
  `member_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `branch_id` int(11) NOT NULL,
  `account_name` varchar(100) NOT NULL,
  `account_type` enum('individual','joint','corporate','custodial') DEFAULT 'individual',
  `joint_account_holders` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`joint_account_holders`)),
  `custodian_id` int(11) DEFAULT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `target_amount` decimal(12,2) DEFAULT NULL,
  `monthly_target` decimal(10,2) DEFAULT NULL,
  `auto_debit_enabled` tinyint(1) DEFAULT 0,
  `auto_debit_amount` decimal(10,2) DEFAULT NULL,
  `interest_rate_monthly` decimal(5,4) NOT NULL,
  `interest_calculation` enum('daily','monthly','quarterly','annually') DEFAULT 'monthly',
  `interest_payment_frequency` enum('monthly','quarterly','annually','maturity') DEFAULT 'monthly',
  `tax_withholding_rate` decimal(5,4) DEFAULT 0.0000,
  `current_balance` decimal(12,2) DEFAULT 0.00,
  `total_deposits` decimal(12,2) DEFAULT 0.00,
  `total_withdrawals` decimal(12,2) DEFAULT 0.00,
  `total_interest_earned` decimal(12,2) DEFAULT 0.00,
  `total_tax_withheld` decimal(12,2) DEFAULT 0.00,
  `status` enum('active','inactive','frozen','closed','dormant') DEFAULT 'active',
  `freeze_reason` text DEFAULT NULL,
  `closure_reason` text DEFAULT NULL,
  `closure_date` date DEFAULT NULL,
  `online_access_enabled` tinyint(1) DEFAULT 1,
  `mobile_banking_enabled` tinyint(1) DEFAULT 1,
  `atm_card_enabled` tinyint(1) DEFAULT 1,
  `daily_limit` decimal(10,2) DEFAULT 0.00,
  `transaction_limit` decimal(10,2) DEFAULT 0.00,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `created_by` int(11) NOT NULL,
  `updated_by` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `savings_accounts`
--

INSERT INTO `savings_accounts` (`id`, `account_number`, `member_id`, `product_id`, `branch_id`, `account_name`, `account_type`, `joint_account_holders`, `custodian_id`, `start_date`, `end_date`, `target_amount`, `monthly_target`, `auto_debit_enabled`, `auto_debit_amount`, `interest_rate_monthly`, `interest_calculation`, `interest_payment_frequency`, `tax_withholding_rate`, `current_balance`, `total_deposits`, `total_withdrawals`, `total_interest_earned`, `total_tax_withheld`, `status`, `freeze_reason`, `closure_reason`, `closure_date`, `online_access_enabled`, `mobile_banking_enabled`, `atm_card_enabled`, `daily_limit`, `transaction_limit`, `notes`, `created_at`, `updated_at`, `created_by`, `updated_by`) VALUES
(1, 'SA001', 1, 1, 1, 'Tabungan Ahmad', 'individual', NULL, NULL, '2026-03-27', NULL, NULL, NULL, 0, NULL, 0.0080, 'monthly', 'monthly', 0.0000, 0.00, 0.00, 0.00, 0.00, 0.00, 'active', NULL, NULL, NULL, 1, 1, 1, 0.00, 0.00, NULL, '2026-03-26 19:07:30', '2026-03-26 19:07:30', 1, NULL),
(2, 'SA002', 2, 2, 1, 'Tabungan Siti', 'individual', NULL, NULL, '2026-03-27', NULL, NULL, NULL, 0, NULL, 0.0100, 'monthly', 'monthly', 0.0000, 0.00, 0.00, 0.00, 0.00, 0.00, 'active', NULL, NULL, NULL, 1, 1, 1, 0.00, 0.00, NULL, '2026-03-26 19:07:30', '2026-03-26 19:07:30', 1, NULL),
(3, 'SA003', 3, 3, 2, 'Tabungan Budi', 'individual', NULL, NULL, '2026-03-27', NULL, NULL, NULL, 0, NULL, 0.0090, 'monthly', 'monthly', 0.0000, 0.00, 0.00, 0.00, 0.00, 0.00, 'active', NULL, NULL, NULL, 1, 1, 1, 0.00, 0.00, NULL, '2026-03-26 19:07:30', '2026-03-26 19:07:30', 1, NULL);

-- --------------------------------------------------------

--
-- Struktur dari tabel `savings_deposits`
--

CREATE TABLE `savings_deposits` (
  `id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `transaction_number` varchar(20) DEFAULT NULL,
  `deposit_date` date NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `deposit_type` enum('regular','additional','bonus','interest','correction') DEFAULT 'regular',
  `payment_method` enum('cash','transfer','digital_wallet','auto_debit','bank_transfer') DEFAULT 'cash',
  `payment_reference` varchar(50) DEFAULT NULL,
  `receipt_number` varchar(50) DEFAULT NULL,
  `collector_id` int(11) DEFAULT NULL,
  `teller_id` int(11) DEFAULT NULL,
  `branch_id` int(11) NOT NULL,
  `counter_number` varchar(10) DEFAULT NULL,
  `status` enum('pending','verified','rejected','cancelled') DEFAULT 'verified',
  `verified_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `verified_by` int(11) DEFAULT NULL,
  `rejection_reason` text DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `attachments` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`attachments`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_by` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `savings_deposits`
--

INSERT INTO `savings_deposits` (`id`, `account_id`, `transaction_number`, `deposit_date`, `amount`, `deposit_type`, `payment_method`, `payment_reference`, `receipt_number`, `collector_id`, `teller_id`, `branch_id`, `counter_number`, `status`, `verified_at`, `verified_by`, `rejection_reason`, `notes`, `attachments`, `created_at`, `created_by`) VALUES
(1, 1, NULL, '2026-03-27', 100000.00, 'regular', 'cash', NULL, NULL, NULL, NULL, 2, NULL, 'verified', '2026-03-26 19:07:38', NULL, NULL, NULL, NULL, '2026-03-26 19:07:38', 1),
(2, 2, NULL, '2026-03-27', 150000.00, 'regular', 'transfer', NULL, NULL, NULL, NULL, 1, NULL, 'verified', '2026-03-26 19:07:38', NULL, NULL, NULL, NULL, '2026-03-26 19:07:38', 1),
(3, 3, NULL, '2026-03-27', 200000.00, 'regular', 'cash', NULL, NULL, NULL, NULL, 3, NULL, 'verified', '2026-03-26 19:07:38', NULL, NULL, NULL, NULL, '2026-03-26 19:07:38', 1);

-- --------------------------------------------------------

--
-- Struktur dari tabel `savings_products`
--

CREATE TABLE `savings_products` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `code` varchar(20) NOT NULL,
  `description` text DEFAULT NULL,
  `product_type` enum('kewer','mawar','sukarela','deposito','berjangka','pendidikan','haji','khusus') DEFAULT 'sukarela',
  `product_category` enum('wajib','sukarela','investasi','tujuan') DEFAULT 'sukarela',
  `min_deposit` decimal(10,2) NOT NULL,
  `max_deposit` decimal(12,2) DEFAULT NULL,
  `default_deposit` decimal(10,2) DEFAULT NULL,
  `deposit_increment` decimal(8,2) DEFAULT 10000.00,
  `deposit_frequency` enum('daily','weekly','monthly','quarterly','flexible') DEFAULT 'flexible',
  `min_monthly_deposit` decimal(10,2) DEFAULT NULL,
  `interest_rate_monthly` decimal(5,4) NOT NULL,
  `interest_calculation` enum('daily','monthly','quarterly','annually') DEFAULT 'monthly',
  `interest_payment_frequency` enum('monthly','quarterly','annually','maturity') DEFAULT 'monthly',
  `bonus_rate` decimal(5,4) DEFAULT 0.0000,
  `tax_rate` decimal(5,4) DEFAULT 0.0000,
  `compounding_method` enum('simple','compound') DEFAULT 'simple',
  `min_tenor_months` int(11) DEFAULT NULL,
  `max_tenor_months` int(11) DEFAULT NULL,
  `default_tenor_months` int(11) DEFAULT NULL,
  `withdrawal_penalty_days` int(11) DEFAULT 0,
  `withdrawal_penalty_rate` decimal(5,4) DEFAULT 0.0000,
  `min_withdrawal_amount` decimal(10,2) DEFAULT NULL,
  `max_withdrawal_frequency` int(11) DEFAULT NULL,
  `auto_renewal` tinyint(1) DEFAULT 0,
  `min_credit_score` int(11) DEFAULT 0,
  `min_membership_days` int(11) DEFAULT 0,
  `min_age_years` int(11) DEFAULT 17,
  `max_age_years` int(11) DEFAULT 0,
  `required_documents` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`required_documents`)),
  `target_member_types` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`target_member_types`)),
  `target_income_range` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`target_income_range`)),
  `target_purpose` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`target_purpose`)),
  `account_type` enum('individual','joint','corporate','custodial') DEFAULT 'individual',
  `currency` varchar(3) DEFAULT 'IDR',
  `auto_debit_enabled` tinyint(1) DEFAULT 0,
  `online_access` tinyint(1) DEFAULT 1,
  `mobile_banking` tinyint(1) DEFAULT 1,
  `is_active` tinyint(1) DEFAULT 1,
  `is_promotional` tinyint(1) DEFAULT 0,
  `priority_level` int(11) DEFAULT 0,
  `effective_date` date DEFAULT NULL,
  `expiry_date` date DEFAULT NULL,
  `terms_conditions` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `savings_products`
--

INSERT INTO `savings_products` (`id`, `name`, `code`, `description`, `product_type`, `product_category`, `min_deposit`, `max_deposit`, `default_deposit`, `deposit_increment`, `deposit_frequency`, `min_monthly_deposit`, `interest_rate_monthly`, `interest_calculation`, `interest_payment_frequency`, `bonus_rate`, `tax_rate`, `compounding_method`, `min_tenor_months`, `max_tenor_months`, `default_tenor_months`, `withdrawal_penalty_days`, `withdrawal_penalty_rate`, `min_withdrawal_amount`, `max_withdrawal_frequency`, `auto_renewal`, `min_credit_score`, `min_membership_days`, `min_age_years`, `max_age_years`, `required_documents`, `target_member_types`, `target_income_range`, `target_purpose`, `account_type`, `currency`, `auto_debit_enabled`, `online_access`, `mobile_banking`, `is_active`, `is_promotional`, `priority_level`, `effective_date`, `expiry_date`, `terms_conditions`, `created_at`, `updated_at`, `created_by`, `updated_by`) VALUES
(1, 'Kewer Harian', 'SKH001', 'Simpanan harian rutin', 'kewer', 'sukarela', 5000.00, NULL, NULL, 10000.00, 'flexible', NULL, 0.0080, 'monthly', 'monthly', 0.0000, 0.0000, 'simple', NULL, NULL, NULL, 0, 0.0000, NULL, NULL, 0, 0, 0, 17, 0, NULL, NULL, NULL, NULL, 'individual', 'IDR', 0, 1, 1, 1, 0, 0, NULL, NULL, NULL, '2026-03-26 19:07:17', '2026-03-26 19:07:17', NULL, NULL),
(2, 'Mawar Bulanan', 'SKM002', 'Simpanan bulanan berjangka', 'mawar', 'sukarela', 100000.00, NULL, NULL, 10000.00, 'flexible', NULL, 0.0100, 'monthly', 'monthly', 0.0000, 0.0000, 'simple', NULL, NULL, NULL, 0, 0.0000, NULL, NULL, 0, 0, 0, 17, 0, NULL, NULL, NULL, NULL, 'individual', 'IDR', 0, 1, 1, 1, 0, 0, NULL, NULL, NULL, '2026-03-26 19:07:17', '2026-03-26 19:07:17', NULL, NULL),
(3, 'Sukarela', 'SKS003', 'Simpanan sukarela fleksibel', 'sukarela', 'sukarela', 10000.00, NULL, NULL, 10000.00, 'flexible', NULL, 0.0090, 'monthly', 'monthly', 0.0000, 0.0000, 'simple', NULL, NULL, NULL, 0, 0.0000, NULL, NULL, 0, 0, 0, 17, 0, NULL, NULL, NULL, NULL, 'individual', 'IDR', 0, 1, 1, 1, 0, 0, NULL, NULL, NULL, '2026-03-26 19:07:17', '2026-03-26 19:07:17', NULL, NULL);

-- --------------------------------------------------------

--
-- Struktur dari tabel `units`
--

CREATE TABLE `units` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `code` varchar(20) NOT NULL,
  `description` text DEFAULT NULL,
  `unit_type` enum('pusat','cabang','unit','divisi','departemen') DEFAULT 'unit',
  `parent_unit_id` int(11) DEFAULT NULL,
  `contact_person` varchar(100) DEFAULT NULL,
  `contact_phone` varchar(15) DEFAULT NULL,
  `contact_email` varchar(100) DEFAULT NULL,
  `address_id` int(11) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `units`
--

INSERT INTO `units` (`id`, `name`, `code`, `description`, `unit_type`, `parent_unit_id`, `contact_person`, `contact_phone`, `contact_email`, `address_id`, `is_active`, `created_at`, `updated_at`, `created_by`, `updated_by`) VALUES
(1, 'Unit Pusat', 'UP001', 'Unit Pusat Koperasi Berjalan', 'pusat', NULL, NULL, NULL, NULL, NULL, 1, '2026-03-26 19:06:42', '2026-03-26 19:06:42', NULL, NULL),
(2, 'Unit Jakarta', 'UP002', 'Unit Operasional Jakarta', 'unit', NULL, NULL, NULL, NULL, NULL, 1, '2026-03-26 19:06:42', '2026-03-26 19:06:42', NULL, NULL);

-- --------------------------------------------------------

--
-- Struktur dari tabel `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `person_id` int(11) NOT NULL,
  `branch_id` int(11) DEFAULT NULL,
  `unit_id` int(11) DEFAULT NULL,
  `role` enum('super_admin','admin','unit_head','branch_head','supervisor','collector','cashier','member','guest') NOT NULL DEFAULT 'member',
  `status` enum('active','inactive','suspended','pending') DEFAULT 'active',
  `login_attempts` int(11) DEFAULT 0,
  `last_login` timestamp NULL DEFAULT NULL,
  `last_activity` timestamp NULL DEFAULT NULL,
  `session_id` varchar(100) DEFAULT NULL,
  `api_token` varchar(255) DEFAULT NULL,
  `api_token_expiry` timestamp NULL DEFAULT NULL,
  `two_factor_enabled` tinyint(1) DEFAULT 0,
  `two_factor_secret` varchar(32) DEFAULT NULL,
  `email_verified` tinyint(1) DEFAULT 0,
  `phone_verified` tinyint(1) DEFAULT 0,
  `must_change_password` tinyint(1) DEFAULT 0,
  `password_changed_at` timestamp NULL DEFAULT NULL,
  `ip_restrictions` text DEFAULT NULL,
  `device_restrictions` text DEFAULT NULL,
  `permissions` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`permissions`)),
  `preferences` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`preferences`)),
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `person_id`, `branch_id`, `unit_id`, `role`, `status`, `login_attempts`, `last_login`, `last_activity`, `session_id`, `api_token`, `api_token_expiry`, `two_factor_enabled`, `two_factor_secret`, `email_verified`, `phone_verified`, `must_change_password`, `password_changed_at`, `ip_restrictions`, `device_restrictions`, `permissions`, `preferences`, `is_active`, `created_at`, `updated_at`, `created_by`, `updated_by`) VALUES
(1, 'admin', '$2y$10$abcdefghijklmnopqrstuvwx', 1, 1, NULL, 'super_admin', 'active', 0, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 1, '2026-03-26 19:06:58', '2026-03-26 19:06:58', NULL, NULL),
(2, 'manager', '$2y$10$abcdefghijklmnopqrstuvwx', 2, 1, NULL, 'admin', 'active', 0, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 1, '2026-03-26 19:06:58', '2026-03-26 19:06:58', NULL, NULL),
(3, 'collector1', '$2y$10$abcdefghijklmnopqrstuvwx', 3, 2, NULL, 'collector', 'active', 0, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 1, '2026-03-26 19:06:58', '2026-03-26 19:06:58', NULL, NULL),
(4, 'cashier1', '$2y$10$abcdefghijklmnopqrstuvwx', 3, 2, NULL, 'cashier', 'active', 0, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 1, '2026-03-26 19:06:58', '2026-03-26 19:06:58', NULL, NULL);

-- --------------------------------------------------------

--
-- Struktur untuk view `member_portfolio_view`
--
DROP TABLE IF EXISTS `member_portfolio_view`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `member_portfolio_view`  AS SELECT `m`.`id` AS `id`, `m`.`member_number` AS `member_number`, `p`.`name` AS `name`, `p`.`phone` AS `phone`, `b`.`name` AS `branch_name`, count(`l`.`id`) AS `active_loans`, coalesce(sum(`l`.`amount`),0) AS `total_loans`, count(`sa`.`id`) AS `savings_accounts`, coalesce(sum(`sa`.`current_balance`),0) AS `total_savings`, `m`.`status` AS `member_status`, `m`.`join_date` AS `join_date` FROM ((((`members` `m` join `schema_person`.`persons` `p` on(`m`.`person_id` = `p`.`id`)) join `branches` `b` on(`m`.`branch_id` = `b`.`id`)) left join `loans` `l` on(`m`.`id` = `l`.`member_id` and `l`.`status` = 'disbursed')) left join `savings_accounts` `sa` on(`m`.`id` = `sa`.`member_id` and `sa`.`status` = 'active')) GROUP BY `m`.`id` ;

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `accounts`
--
ALTER TABLE `accounts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `account_code` (`account_code`),
  ADD KEY `idx_account_code` (`account_code`),
  ADD KEY `idx_account_type` (`account_type`),
  ADD KEY `idx_parent_id` (`parent_id`),
  ADD KEY `idx_level` (`level`),
  ADD KEY `idx_is_active` (`is_active`);

--
-- Indeks untuk tabel `addresses`
--
ALTER TABLE `addresses`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `branches`
--
ALTER TABLE `branches`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`),
  ADD KEY `idx_unit` (`unit_id`),
  ADD KEY `idx_code` (`code`),
  ADD KEY `idx_branch_type` (`branch_type`),
  ADD KEY `idx_is_active` (`is_active`),
  ADD KEY `idx_opening_date` (`opening_date`);

--
-- Indeks untuk tabel `fraud_alerts`
--
ALTER TABLE `fraud_alerts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `idx_collector_date` (`collector_id`,`alert_date`),
  ADD KEY `idx_severity` (`severity`),
  ADD KEY `idx_status` (`status`);

--
-- Indeks untuk tabel `journals`
--
ALTER TABLE `journals`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `journal_number` (`journal_number`),
  ADD KEY `idx_journal_number` (`journal_number`),
  ADD KEY `idx_journal_date` (`journal_date`),
  ADD KEY `idx_reference` (`reference_type`,`reference_id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_approved_by` (`approved_by`),
  ADD KEY `idx_created_by` (`created_by`);

--
-- Indeks untuk tabel `journal_details`
--
ALTER TABLE `journal_details`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_journal_id` (`journal_id`),
  ADD KEY `idx_account_id` (`account_id`),
  ADD KEY `idx_debit` (`debit`),
  ADD KEY `idx_credit` (`credit`),
  ADD KEY `idx_amount` (`amount`),
  ADD KEY `idx_reference` (`reference_type`,`reference_id`);

--
-- Indeks untuk tabel `loans`
--
ALTER TABLE `loans`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `application_number` (`application_number`),
  ADD KEY `idx_application_number` (`application_number`),
  ADD KEY `idx_member_id` (`member_id`),
  ADD KEY `idx_product_id` (`product_id`),
  ADD KEY `idx_branch_id` (`branch_id`),
  ADD KEY `idx_collector_id` (`collector_id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_application_date` (`application_date`),
  ADD KEY `idx_disbursement_date` (`disbursement_date`),
  ADD KEY `idx_maturity_date` (`maturity_date`),
  ADD KEY `idx_amount` (`amount`),
  ADD KEY `idx_total_outstanding` (`total_outstanding`),
  ADD KEY `idx_days_past_due` (`days_past_due`),
  ADD KEY `guarantor_id` (`guarantor_id`);

--
-- Indeks untuk tabel `loan_products`
--
ALTER TABLE `loan_products`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`),
  ADD KEY `idx_code` (`code`),
  ADD KEY `idx_product_category` (`product_category`),
  ADD KEY `idx_min_amount` (`min_amount`),
  ADD KEY `idx_max_amount` (`max_amount`),
  ADD KEY `idx_interest_rate` (`interest_rate_monthly`),
  ADD KEY `idx_is_active` (`is_active`),
  ADD KEY `idx_is_promotional` (`is_promotional`),
  ADD KEY `idx_effective_date` (`effective_date`);

--
-- Indeks untuk tabel `master_banks`
--
ALTER TABLE `master_banks`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`),
  ADD KEY `idx_code` (`code`),
  ADD KEY `idx_name` (`name`),
  ADD KEY `idx_bank_type` (`bank_type`),
  ADD KEY `idx_bic_code` (`bic_code`),
  ADD KEY `idx_is_active` (`is_active`);

--
-- Indeks untuk tabel `master_blood_types`
--
ALTER TABLE `master_blood_types`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`),
  ADD KEY `idx_code` (`code`),
  ADD KEY `idx_name` (`name`),
  ADD KEY `idx_is_active` (`is_active`);

--
-- Indeks untuk tabel `master_business_types`
--
ALTER TABLE `master_business_types`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`),
  ADD KEY `idx_code` (`code`),
  ADD KEY `idx_name` (`name`),
  ADD KEY `idx_category` (`category`),
  ADD KEY `idx_risk_level` (`risk_level`),
  ADD KEY `idx_is_active` (`is_active`);

--
-- Indeks untuk tabel `master_communication_channels`
--
ALTER TABLE `master_communication_channels`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`),
  ADD KEY `idx_code` (`code`),
  ADD KEY `idx_name` (`name`),
  ADD KEY `idx_type` (`type`),
  ADD KEY `idx_is_active` (`is_active`);

--
-- Indeks untuk tabel `master_compliance_statuses`
--
ALTER TABLE `master_compliance_statuses`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`),
  ADD KEY `idx_code` (`code`),
  ADD KEY `idx_name` (`name`),
  ADD KEY `idx_category` (`category`),
  ADD KEY `idx_is_active` (`is_active`);

--
-- Indeks untuk tabel `master_countries`
--
ALTER TABLE `master_countries`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`),
  ADD KEY `idx_code` (`code`),
  ADD KEY `idx_name` (`name`),
  ADD KEY `idx_continent` (`continent`),
  ADD KEY `idx_is_active` (`is_active`);

--
-- Indeks untuk tabel `master_currencies`
--
ALTER TABLE `master_currencies`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`),
  ADD KEY `idx_code` (`code`),
  ADD KEY `idx_name` (`name`),
  ADD KEY `idx_is_active` (`is_active`);

--
-- Indeks untuk tabel `master_device_types`
--
ALTER TABLE `master_device_types`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`),
  ADD KEY `idx_code` (`code`),
  ADD KEY `idx_name` (`name`),
  ADD KEY `idx_category` (`category`),
  ADD KEY `idx_os_name` (`os_name`),
  ADD KEY `idx_browser_name` (`browser_name`),
  ADD KEY `idx_is_active` (`is_active`);

--
-- Indeks untuk tabel `master_document_types`
--
ALTER TABLE `master_document_types`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`),
  ADD KEY `idx_code` (`code`),
  ADD KEY `idx_name` (`name`),
  ADD KEY `idx_category` (`category`),
  ADD KEY `idx_is_required` (`is_required`),
  ADD KEY `idx_is_active` (`is_active`);

--
-- Indeks untuk tabel `master_education_levels`
--
ALTER TABLE `master_education_levels`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`),
  ADD KEY `idx_code` (`code`),
  ADD KEY `idx_name` (`name`),
  ADD KEY `idx_level_order` (`level_order`),
  ADD KEY `idx_is_active` (`is_active`);

--
-- Indeks untuk tabel `master_fee_types`
--
ALTER TABLE `master_fee_types`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`),
  ADD KEY `idx_code` (`code`),
  ADD KEY `idx_name` (`name`),
  ADD KEY `idx_category` (`category`),
  ADD KEY `idx_is_active` (`is_active`);

--
-- Indeks untuk tabel `master_id_types`
--
ALTER TABLE `master_id_types`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`),
  ADD KEY `idx_code` (`code`),
  ADD KEY `idx_name` (`name`),
  ADD KEY `idx_category` (`category`),
  ADD KEY `idx_issuing_authority` (`issuing_authority`),
  ADD KEY `idx_is_active` (`is_active`);

--
-- Indeks untuk tabel `master_notification_types`
--
ALTER TABLE `master_notification_types`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`),
  ADD KEY `idx_code` (`code`),
  ADD KEY `idx_name` (`name`),
  ADD KEY `idx_category` (`category`),
  ADD KEY `idx_priority` (`priority`),
  ADD KEY `idx_is_active` (`is_active`);

--
-- Indeks untuk tabel `master_occupations`
--
ALTER TABLE `master_occupations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`),
  ADD KEY `idx_code` (`code`),
  ADD KEY `idx_name` (`name`),
  ADD KEY `idx_category` (`category`),
  ADD KEY `idx_bps_code` (`bps_code`),
  ADD KEY `idx_is_active` (`is_active`);

--
-- Indeks untuk tabel `master_payment_methods`
--
ALTER TABLE `master_payment_methods`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`),
  ADD KEY `idx_code` (`code`),
  ADD KEY `idx_name` (`name`),
  ADD KEY `idx_category` (`category`),
  ADD KEY `idx_is_active` (`is_active`);

--
-- Indeks untuk tabel `master_provinces`
--
ALTER TABLE `master_provinces`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`),
  ADD KEY `idx_code` (`code`),
  ADD KEY `idx_name` (`name`),
  ADD KEY `idx_country_code` (`country_code`),
  ADD KEY `idx_is_active` (`is_active`);

--
-- Indeks untuk tabel `master_relationship_types`
--
ALTER TABLE `master_relationship_types`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`),
  ADD KEY `inverse_relationship_id` (`inverse_relationship_id`),
  ADD KEY `idx_code` (`code`),
  ADD KEY `idx_name` (`name`),
  ADD KEY `idx_category` (`category`),
  ADD KEY `idx_relationship_level` (`relationship_level`),
  ADD KEY `idx_is_active` (`is_active`);

--
-- Indeks untuk tabel `master_religions`
--
ALTER TABLE `master_religions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`),
  ADD KEY `idx_code` (`code`),
  ADD KEY `idx_name` (`name`),
  ADD KEY `idx_is_active` (`is_active`);

--
-- Indeks untuk tabel `master_risk_levels`
--
ALTER TABLE `master_risk_levels`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`),
  ADD KEY `idx_code` (`code`),
  ADD KEY `idx_name` (`name`),
  ADD KEY `idx_score_range` (`score_min`,`score_max`),
  ADD KEY `idx_is_active` (`is_active`);

--
-- Indeks untuk tabel `master_setting_categories`
--
ALTER TABLE `master_setting_categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`),
  ADD KEY `idx_code` (`code`),
  ADD KEY `idx_name` (`name`),
  ADD KEY `idx_parent_category` (`parent_category_id`),
  ADD KEY `idx_is_active` (`is_active`);

--
-- Indeks untuk tabel `master_status_types`
--
ALTER TABLE `master_status_types`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`),
  ADD KEY `idx_code` (`code`),
  ADD KEY `idx_name` (`name`),
  ADD KEY `idx_category` (`category`),
  ADD KEY `idx_is_active` (`is_active`);

--
-- Indeks untuk tabel `master_transaction_types`
--
ALTER TABLE `master_transaction_types`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`),
  ADD KEY `idx_code` (`code`),
  ADD KEY `idx_name` (`name`),
  ADD KEY `idx_category` (`category`),
  ADD KEY `idx_direction` (`direction`),
  ADD KEY `idx_is_active` (`is_active`);

--
-- Indeks untuk tabel `master_user_roles`
--
ALTER TABLE `master_user_roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`),
  ADD KEY `idx_code` (`code`),
  ADD KEY `idx_name` (`name`),
  ADD KEY `idx_level` (`level`),
  ADD KEY `idx_is_system_role` (`is_system_role`),
  ADD KEY `idx_is_active` (`is_active`);

--
-- Indeks untuk tabel `members`
--
ALTER TABLE `members`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `person_id` (`person_id`),
  ADD UNIQUE KEY `member_number` (`member_number`),
  ADD KEY `idx_person_id` (`person_id`),
  ADD KEY `idx_member_number` (`member_number`),
  ADD KEY `idx_branch_id` (`branch_id`),
  ADD KEY `idx_member_type` (`member_type`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_credit_score` (`credit_score`),
  ADD KEY `idx_risk_level` (`risk_level`),
  ADD KEY `idx_kyc_status` (`kyc_status`),
  ADD KEY `idx_aml_status` (`aml_status`),
  ADD KEY `idx_join_date` (`join_date`),
  ADD KEY `idx_is_active` (`is_active`),
  ADD KEY `referral_member_id` (`referral_member_id`);

--
-- Indeks untuk tabel `ppatk_reportable_transactions`
--
ALTER TABLE `ppatk_reportable_transactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_member_date` (`member_id`,`transaction_date`),
  ADD KEY `idx_cumulative` (`cumulative_amount`),
  ADD KEY `idx_reported` (`reported`);

--
-- Indeks untuk tabel `savings_accounts`
--
ALTER TABLE `savings_accounts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `account_number` (`account_number`),
  ADD KEY `idx_account_number` (`account_number`),
  ADD KEY `idx_member_id` (`member_id`),
  ADD KEY `idx_product_id` (`product_id`),
  ADD KEY `idx_branch_id` (`branch_id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_start_date` (`start_date`),
  ADD KEY `idx_end_date` (`end_date`),
  ADD KEY `idx_current_balance` (`current_balance`),
  ADD KEY `custodian_id` (`custodian_id`);

--
-- Indeks untuk tabel `savings_deposits`
--
ALTER TABLE `savings_deposits`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `transaction_number` (`transaction_number`),
  ADD KEY `idx_account_id` (`account_id`),
  ADD KEY `idx_transaction_number` (`transaction_number`),
  ADD KEY `idx_deposit_date` (`deposit_date`),
  ADD KEY `idx_collector_id` (`collector_id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_amount` (`amount`),
  ADD KEY `branch_id` (`branch_id`);

--
-- Indeks untuk tabel `savings_products`
--
ALTER TABLE `savings_products`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`),
  ADD KEY `idx_code` (`code`),
  ADD KEY `idx_product_type` (`product_type`),
  ADD KEY `idx_product_category` (`product_category`),
  ADD KEY `idx_interest_rate` (`interest_rate_monthly`),
  ADD KEY `idx_is_active` (`is_active`),
  ADD KEY `idx_is_promotional` (`is_promotional`),
  ADD KEY `idx_effective_date` (`effective_date`);

--
-- Indeks untuk tabel `units`
--
ALTER TABLE `units`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`),
  ADD KEY `idx_code` (`code`),
  ADD KEY `idx_unit_type` (`unit_type`),
  ADD KEY `idx_parent_unit` (`parent_unit_id`),
  ADD KEY `idx_is_active` (`is_active`);

--
-- Indeks untuk tabel `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD KEY `idx_username` (`username`),
  ADD KEY `idx_person_id` (`person_id`),
  ADD KEY `idx_branch_id` (`branch_id`),
  ADD KEY `idx_unit_id` (`unit_id`),
  ADD KEY `idx_role` (`role`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_last_login` (`last_login`),
  ADD KEY `idx_api_token` (`api_token`),
  ADD KEY `idx_is_active` (`is_active`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `accounts`
--
ALTER TABLE `accounts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT untuk tabel `addresses`
--
ALTER TABLE `addresses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `branches`
--
ALTER TABLE `branches`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `fraud_alerts`
--
ALTER TABLE `fraud_alerts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `journals`
--
ALTER TABLE `journals`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `journal_details`
--
ALTER TABLE `journal_details`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `loans`
--
ALTER TABLE `loans`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `loan_products`
--
ALTER TABLE `loan_products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `master_banks`
--
ALTER TABLE `master_banks`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT untuk tabel `master_blood_types`
--
ALTER TABLE `master_blood_types`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT untuk tabel `master_business_types`
--
ALTER TABLE `master_business_types`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT untuk tabel `master_communication_channels`
--
ALTER TABLE `master_communication_channels`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `master_compliance_statuses`
--
ALTER TABLE `master_compliance_statuses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `master_countries`
--
ALTER TABLE `master_countries`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `master_currencies`
--
ALTER TABLE `master_currencies`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `master_device_types`
--
ALTER TABLE `master_device_types`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `master_document_types`
--
ALTER TABLE `master_document_types`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT untuk tabel `master_education_levels`
--
ALTER TABLE `master_education_levels`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT untuk tabel `master_fee_types`
--
ALTER TABLE `master_fee_types`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `master_id_types`
--
ALTER TABLE `master_id_types`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `master_notification_types`
--
ALTER TABLE `master_notification_types`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `master_occupations`
--
ALTER TABLE `master_occupations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1351;

--
-- AUTO_INCREMENT untuk tabel `master_payment_methods`
--
ALTER TABLE `master_payment_methods`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT untuk tabel `master_provinces`
--
ALTER TABLE `master_provinces`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `master_relationship_types`
--
ALTER TABLE `master_relationship_types`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `master_religions`
--
ALTER TABLE `master_religions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT untuk tabel `master_risk_levels`
--
ALTER TABLE `master_risk_levels`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `master_setting_categories`
--
ALTER TABLE `master_setting_categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `master_status_types`
--
ALTER TABLE `master_status_types`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `master_transaction_types`
--
ALTER TABLE `master_transaction_types`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `master_user_roles`
--
ALTER TABLE `master_user_roles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT untuk tabel `members`
--
ALTER TABLE `members`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `ppatk_reportable_transactions`
--
ALTER TABLE `ppatk_reportable_transactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `savings_accounts`
--
ALTER TABLE `savings_accounts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `savings_deposits`
--
ALTER TABLE `savings_deposits`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `savings_products`
--
ALTER TABLE `savings_products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `units`
--
ALTER TABLE `units`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `accounts`
--
ALTER TABLE `accounts`
  ADD CONSTRAINT `accounts_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `accounts` (`id`);

--
-- Ketidakleluasaan untuk tabel `fraud_alerts`
--
ALTER TABLE `fraud_alerts`
  ADD CONSTRAINT `fraud_alerts_ibfk_1` FOREIGN KEY (`collector_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `fraud_alerts_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`);

--
-- Ketidakleluasaan untuk tabel `journal_details`
--
ALTER TABLE `journal_details`
  ADD CONSTRAINT `journal_details_ibfk_1` FOREIGN KEY (`journal_id`) REFERENCES `journals` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `journal_details_ibfk_2` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`);

--
-- Ketidakleluasaan untuk tabel `loans`
--
ALTER TABLE `loans`
  ADD CONSTRAINT `loans_ibfk_1` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`),
  ADD CONSTRAINT `loans_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `loan_products` (`id`),
  ADD CONSTRAINT `loans_ibfk_3` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`),
  ADD CONSTRAINT `loans_ibfk_4` FOREIGN KEY (`guarantor_id`) REFERENCES `members` (`id`);

--
-- Ketidakleluasaan untuk tabel `master_relationship_types`
--
ALTER TABLE `master_relationship_types`
  ADD CONSTRAINT `master_relationship_types_ibfk_1` FOREIGN KEY (`inverse_relationship_id`) REFERENCES `master_relationship_types` (`id`);

--
-- Ketidakleluasaan untuk tabel `master_setting_categories`
--
ALTER TABLE `master_setting_categories`
  ADD CONSTRAINT `master_setting_categories_ibfk_1` FOREIGN KEY (`parent_category_id`) REFERENCES `master_setting_categories` (`id`);

--
-- Ketidakleluasaan untuk tabel `members`
--
ALTER TABLE `members`
  ADD CONSTRAINT `members_ibfk_1` FOREIGN KEY (`person_id`) REFERENCES `schema_person`.`persons` (`id`),
  ADD CONSTRAINT `members_ibfk_2` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`),
  ADD CONSTRAINT `members_ibfk_3` FOREIGN KEY (`referral_member_id`) REFERENCES `members` (`id`);

--
-- Ketidakleluasaan untuk tabel `ppatk_reportable_transactions`
--
ALTER TABLE `ppatk_reportable_transactions`
  ADD CONSTRAINT `ppatk_reportable_transactions_ibfk_1` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`);

--
-- Ketidakleluasaan untuk tabel `savings_accounts`
--
ALTER TABLE `savings_accounts`
  ADD CONSTRAINT `savings_accounts_ibfk_1` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`),
  ADD CONSTRAINT `savings_accounts_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `savings_products` (`id`),
  ADD CONSTRAINT `savings_accounts_ibfk_3` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`),
  ADD CONSTRAINT `savings_accounts_ibfk_4` FOREIGN KEY (`custodian_id`) REFERENCES `members` (`id`);

--
-- Ketidakleluasaan untuk tabel `savings_deposits`
--
ALTER TABLE `savings_deposits`
  ADD CONSTRAINT `savings_deposits_ibfk_1` FOREIGN KEY (`account_id`) REFERENCES `savings_accounts` (`id`),
  ADD CONSTRAINT `savings_deposits_ibfk_2` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`);

--
-- Ketidakleluasaan untuk tabel `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`person_id`) REFERENCES `schema_person`.`persons` (`id`),
  ADD CONSTRAINT `users_ibfk_2` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`),
  ADD CONSTRAINT `users_ibfk_3` FOREIGN KEY (`unit_id`) REFERENCES `units` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
