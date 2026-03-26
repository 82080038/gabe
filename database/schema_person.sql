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
-- Database: `schema_person`
--

DELIMITER $$
--
-- Prosedur
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `CalculateCreditScore` (IN `p_person_id` INT)   BEGIN
    DECLARE v_score INT DEFAULT 0;
    DECLARE v_income_score INT DEFAULT 0;
    DECLARE v_age_score INT DEFAULT 0;
    DECLARE v_business_score INT DEFAULT 0;
    DECLARE v_family_score INT DEFAULT 0;
    DECLARE v_document_score INT DEFAULT 0;
    
    
    DECLARE v_monthly_income DECIMAL(12,2);
    DECLARE v_birth_date DATE;
    DECLARE v_business_type VARCHAR(50);
    DECLARE v_marital_status VARCHAR(50);
    DECLARE v_number_of_children INT;
    
    SELECT monthly_income, birth_date, business_type, marital_status, number_of_children
    INTO v_monthly_income, v_birth_date, v_business_type, v_marital_status, v_number_of_children
    FROM persons WHERE id = p_person_id;
    
    
    IF v_monthly_income >= 5000000 THEN SET v_income_score = 30;
    ELSEIF v_monthly_income >= 3000000 THEN SET v_income_score = 25;
    ELSEIF v_monthly_income >= 2000000 THEN SET v_income_score = 20;
    ELSEIF v_monthly_income >= 1000000 THEN SET v_income_score = 15;
    ELSE SET v_income_score = 5;
    END IF;
    
    
    IF TIMESTAMPDIFF(YEAR, v_birth_date, CURDATE()) BETWEEN 25 AND 50 THEN SET v_age_score = 20;
    ELSEIF TIMESTAMPDIFF(YEAR, v_birth_date, CURDATE()) BETWEEN 20 AND 60 THEN SET v_age_score = 15;
    ELSE SET v_age_score = 10;
    END IF;
    
    
    IF v_business_type = 'pedagang_pasar' THEN SET v_business_score = 15;
    ELSEIF v_business_type = 'warung' THEN SET v_business_score = 18;
    ELSEIF v_business_type = 'toko' THEN SET v_business_score = 20;
    ELSE SET v_business_score = 10;
    END IF;
    
    
    IF v_marital_status = 'Menikah' AND v_number_of_children <= 2 THEN SET v_family_score = 20;
    ELSEIF v_marital_status = 'Menikah' AND v_number_of_children <= 4 THEN SET v_family_score = 15;
    ELSEIF v_marital_status = 'Belum Menikah' THEN SET v_family_score = 18;
    ELSE SET v_family_score = 10;
    END IF;
    
    
    SELECT COUNT(*) * 2 INTO v_document_score
    FROM document_uploads 
    WHERE person_id = p_person_id AND is_verified = 1;
    
    IF v_document_score > 10 THEN SET v_document_score = 10; END IF;
    
    
    SET v_score = v_income_score + v_age_score + v_business_score + v_family_score + v_document_score;
    
    
    UPDATE persons 
    SET credit_score = v_score,
        risk_level = CASE 
            WHEN v_score >= 80 THEN 'Rendah'
            WHEN v_score >= 60 THEN 'Sedang'
            ELSE 'Tinggi'
        END
    WHERE id = p_person_id;
    
    
    INSERT INTO risk_assessment_history 
    (person_id, assessment_date, credit_score, risk_level, assessed_by)
    VALUES (p_person_id, CURDATE(), v_score, 
            CASE WHEN v_score >= 80 THEN 'Rendah' WHEN v_score >= 60 THEN 'Sedang' ELSE 'Tinggi' END, 
            1);
    
    SELECT v_score as credit_score, 
           CASE WHEN v_score >= 80 THEN 'Rendah' WHEN v_score >= 60 THEN 'Sedang' ELSE 'Tinggi' END as risk_level;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `CalculateUniversalCreditScore` (IN `p_person_id` INT)   BEGIN
    DECLARE v_score INT DEFAULT 0;
    DECLARE v_income_score INT DEFAULT 0;
    DECLARE v_age_score INT DEFAULT 0;
    DECLARE v_education_score INT DEFAULT 0;
    DECLARE v_employment_score INT DEFAULT 0;
    DECLARE v_business_score INT DEFAULT 0;
    DECLARE v_family_score INT DEFAULT 0;
    DECLARE v_document_score INT DEFAULT 0;
    DECLARE v_health_score INT DEFAULT 0;
    
    
    DECLARE v_annual_income DECIMAL(15,2);
    DECLARE v_birth_date DATE;
    DECLARE v_education_level VARCHAR(50);
    DECLARE v_marital_status VARCHAR(50);
    DECLARE v_number_of_children INT;
    DECLARE v_occupation VARCHAR(100);
    DECLARE v_business_type VARCHAR(50);
    DECLARE v_is_blacklisted BOOLEAN;
    
    SELECT annual_income, birth_date, education_level, marital_status, 
           number_of_children, occupation, business_type, is_blacklisted
    INTO v_annual_income, v_birth_date, v_education_level, v_marital_status, 
         v_number_of_children, v_occupation, v_business_type, v_is_blacklisted
    FROM persons WHERE id = p_person_id;
    
    
    IF v_is_blacklisted = TRUE THEN
        SET v_score = 0;
    ELSE
        
        IF v_annual_income >= 120000000 THEN SET v_income_score = 25;
        ELSEIF v_annual_income >= 60000000 THEN SET v_income_score = 20;
        ELSEIF v_annual_income >= 36000000 THEN SET v_income_score = 15;
        ELSEIF v_annual_income >= 24000000 THEN SET v_income_score = 10;
        ELSE SET v_income_score = 5;
        END IF;
        
        
        IF TIMESTAMPDIFF(YEAR, v_birth_date, CURDATE()) BETWEEN 25 AND 50 THEN SET v_age_score = 15;
        ELSEIF TIMESTAMPDIFF(YEAR, v_birth_date, CURDATE()) BETWEEN 21 AND 60 THEN SET v_age_score = 12;
        ELSEIF TIMESTAMPDIFF(YEAR, v_birth_date, CURDATE()) BETWEEN 18 AND 65 THEN SET v_age_score = 8;
        ELSE SET v_age_score = 3;
        END IF;
        
        
        IF v_education_level IN ('S3', 'S2', 'Profesi') THEN SET v_education_score = 15;
        ELSEIF v_education_level IN ('S1', 'D4') THEN SET v_education_score = 12;
        ELSEIF v_education_level IN ('D3', 'D2', 'D1') THEN SET v_education_score = 10;
        ELSEIF v_education_level IN ('SMA', 'SMK', 'MA') THEN SET v_education_score = 8;
        ELSEIF v_education_level IN ('SMP') THEN SET v_education_score = 5;
        ELSE SET v_education_score = 2;
        END IF;
        
        
        IF v_occupation IN ('PNS', 'BUMN', 'Swasta') THEN SET v_employment_score = 15;
        ELSEIF v_occupation IN ('Wiraswasta', 'Pedagang') THEN SET v_employment_score = 12;
        ELSEIF v_occupation IN ('Petani', 'Nelayan') THEN SET v_employment_score = 8;
        ELSEIF v_occupation IN ('Buruh', 'Freelance') THEN SET v_employment_score = 5;
        ELSE SET v_employment_score = 2;
        END IF;
        
        
        IF v_business_type IN ('PNS', 'BUMN', 'Swasta') THEN SET v_business_score = 10;
        ELSEIF v_business_type IN ('Wiraswasta', 'Pedagang') THEN SET v_business_score = 8;
        ELSEIF v_business_type IN ('Petani', 'Nelayan') THEN SET v_business_score = 5;
        ELSE SET v_business_score = 3;
        END IF;
        
        
        IF v_marital_status = 'Menikah' AND v_number_of_children <= 2 THEN SET v_family_score = 10;
        ELSEIF v_marital_status = 'Menikah' AND v_number_of_children <= 4 THEN SET v_family_score = 8;
        ELSEIF v_marital_status = 'Belum Menikah' THEN SET v_family_score = 9;
        ELSE SET v_family_score = 5;
        END IF;
        
        
        SELECT COUNT(*) * 2 INTO v_document_score
        FROM documents 
        WHERE person_id = p_person_id AND is_verified = 1;
        
        IF v_document_score > 10 THEN SET v_document_score = 10; END IF;
        
        
        SET v_score = v_income_score + v_age_score + v_education_score + 
                     v_employment_score + v_business_score + v_family_score + v_document_score;
        
        
        IF v_score > 100 THEN SET v_score = 100; END IF;
    END IF;
    
    
    UPDATE persons 
    SET credit_score = v_score,
        risk_level = CASE 
            WHEN v_score >= 80 THEN 'Rendah'
            WHEN v_score >= 60 THEN 'Sedang'
            WHEN v_score >= 40 THEN 'Tinggi'
            ELSE 'Sangat Tinggi'
        END,
        updated_at = CURRENT_TIMESTAMP
    WHERE id = p_person_id;
    
    
    INSERT INTO audit_logs (person_id, action, new_values, user_id)
    VALUES (p_person_id, 'UPDATE', 
            JSON_OBJECT('credit_score', v_score, 'risk_level', 
                       CASE WHEN v_score >= 80 THEN 'Rendah'
                            WHEN v_score >= 60 THEN 'Sedang'
                            WHEN v_score >= 40 THEN 'Tinggi'
                            ELSE 'Sangat Tinggi' END), 
            1);
    
    SELECT v_score as credit_score, 
           CASE WHEN v_score >= 80 THEN 'Rendah'
                WHEN v_score >= 60 THEN 'Sedang'
                WHEN v_score >= 40 THEN 'Tinggi'
                ELSE 'Sangat Tinggi' END as risk_level;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UniversalPersonSearch` (IN `p_search_term` VARCHAR(255), IN `p_search_type` VARCHAR(50), IN `p_limit` INT)   BEGIN
    CASE p_search_type
        WHEN 'NIK' THEN
            SELECT * FROM persons WHERE nik LIKE CONCAT('%', p_search_term, '%') LIMIT p_limit;
        WHEN 'NAME' THEN
            SELECT * FROM persons WHERE name LIKE CONCAT('%', p_search_term, '%') OR name_alias LIKE CONCAT('%', p_search_term, '%') LIMIT p_limit;
        WHEN 'PHONE' THEN
            SELECT * FROM persons WHERE phone LIKE CONCAT('%', p_search_term, '%') OR whatsapp LIKE CONCAT('%', p_search_term, '%') LIMIT p_limit;
        WHEN 'EMAIL' THEN
            SELECT * FROM persons WHERE email LIKE CONCAT('%', p_search_term, '%') OR email2 LIKE CONCAT('%', p_search_term, '%') LIMIT p_limit;
        WHEN 'NPWP' THEN
            SELECT * FROM persons WHERE npwp LIKE CONCAT('%', p_search_term, '%') LIMIT p_limit;
        WHEN 'ALL' THEN
            SELECT * FROM persons 
            WHERE nik LIKE CONCAT('%', p_search_term, '%') 
               OR name LIKE CONCAT('%', p_search_term, '%') 
               OR phone LIKE CONCAT('%', p_search_term, '%') 
               OR email LIKE CONCAT('%', p_search_term, '%')
            LIMIT p_limit;
        ELSE
            SELECT * FROM persons WHERE name LIKE CONCAT('%', p_search_term, '%') LIMIT p_limit;
    END CASE;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `VerifyPerson` (IN `p_person_id` INT, IN `p_user_id` INT, IN `p_notes` TEXT)   BEGIN
    DECLARE v_verification_count INT DEFAULT 0;
    
    
    SELECT COUNT(*) INTO v_verification_count
    FROM document_uploads 
    WHERE person_id = p_person_id AND is_verified = 1;
    
    
    UPDATE persons 
    SET verification_status = CASE 
            WHEN v_verification_count >= 3 THEN 'Verified'
            ELSE 'Pending'
        END,
        verification_date = CASE 
            WHEN v_verification_count >= 3 THEN CURRENT_TIMESTAMP 
            ELSE NULL 
        END,
        verified_by = CASE 
            WHEN v_verification_count >= 3 THEN p_user_id 
            ELSE NULL 
        END
    WHERE id = p_person_id;
    
    
    INSERT INTO verification_history 
    (person_id, verification_type, verification_status, verified_by, notes)
    VALUES (p_person_id, 'Data_Diri', 
            CASE WHEN v_verification_count >= 3 THEN 'Verified' ELSE 'Pending' END, 
            p_user_id, p_notes);
    
    SELECT verification_status, v_verification_count as verified_documents;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `VerifyPersonDocuments` (IN `p_person_id` INT, IN `p_user_id` INT, IN `p_notes` TEXT)   BEGIN
    DECLARE v_total_documents INT DEFAULT 0;
    DECLARE v_verified_documents INT DEFAULT 0;
    DECLARE v_required_documents INT DEFAULT 3;
    
    
    SELECT COUNT(*), SUM(CASE WHEN is_verified = 1 THEN 1 ELSE 0 END)
    INTO v_total_documents, v_verified_documents
    FROM documents 
    WHERE person_id = p_person_id;
    
    
    UPDATE persons 
    SET verification_status = CASE 
            WHEN v_verified_documents >= v_required_documents THEN 'Verified'
            WHEN v_verified_documents > 0 THEN 'Pending'
            ELSE 'Pending'
        END,
        verification_date = CASE 
            WHEN v_verified_documents >= v_required_documents THEN CURRENT_TIMESTAMP 
            ELSE NULL 
        END,
        verified_by = CASE 
            WHEN v_verified_documents >= v_required_documents THEN p_user_id 
            ELSE NULL 
        END,
        updated_at = CURRENT_TIMESTAMP
    WHERE id = p_person_id;
    
    
    INSERT INTO audit_logs (person_id, action, new_values, user_id, reason)
    VALUES (p_person_id, 'VERIFY', 
            JSON_OBJECT('verification_status', 
                       CASE WHEN v_verified_documents >= v_required_documents THEN 'Verified' ELSE 'Pending' END,
                       'verified_documents', v_verified_documents,
                       'total_documents', v_total_documents), 
            p_user_id, p_notes);
    
    SELECT verification_status, v_verified_documents as verified_documents, 
           v_total_documents as total_documents;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `audit_logs`
--

CREATE TABLE `audit_logs` (
  `id` int(11) NOT NULL,
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
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `audit_logs`
--

INSERT INTO `audit_logs` (`id`, `person_id`, `table_name`, `record_id`, `action`, `old_values`, `new_values`, `changed_fields`, `ip_address`, `user_agent`, `session_id`, `user_id`, `username`, `reason`, `reference_type`, `reference_id`, `created_at`) VALUES
(1, 1, NULL, NULL, 'CREATE', NULL, '{\"nik\": \"3201011234560001\", \"name\": \"Ahmad Sudirman\", \"created_at\": \"2026-03-27 01:59:25\"}', NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, '2026-03-26 18:59:25'),
(2, 2, NULL, NULL, 'CREATE', NULL, '{\"nik\": \"3201011234560002\", \"name\": \"Siti Nurhaliza\", \"created_at\": \"2026-03-27 01:59:25\"}', NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, '2026-03-26 18:59:25'),
(3, 3, NULL, NULL, 'CREATE', NULL, '{\"nik\": \"3201011234560003\", \"name\": \"Budi Santoso\", \"created_at\": \"2026-03-27 01:59:25\"}', NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, '2026-03-26 18:59:25'),
(4, 1, NULL, NULL, 'CREATE', NULL, '{\"nik\": \"3201011234560001\", \"name\": \"Ahmad Sudirman\", \"created_at\": \"2026-03-27 01:59:47\"}', NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, '2026-03-26 18:59:47'),
(5, 2, NULL, NULL, 'CREATE', NULL, '{\"nik\": \"3201011234560002\", \"name\": \"Siti Nurhaliza\", \"created_at\": \"2026-03-27 01:59:47\"}', NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, '2026-03-26 18:59:47'),
(6, 3, NULL, NULL, 'CREATE', NULL, '{\"nik\": \"3201011234560003\", \"name\": \"Budi Santoso\", \"created_at\": \"2026-03-27 01:59:47\"}', NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, '2026-03-26 18:59:47'),
(7, 1, NULL, NULL, 'CREATE', NULL, '{\"nik\": \"3201011234560001\", \"name\": \"Ahmad Sudirman\", \"created_at\": \"2026-03-27 01:59:59\"}', NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, '2026-03-26 18:59:59'),
(8, 2, NULL, NULL, 'CREATE', NULL, '{\"nik\": \"3201011234560002\", \"name\": \"Siti Nurhaliza\", \"created_at\": \"2026-03-27 01:59:59\"}', NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, '2026-03-26 18:59:59'),
(9, 3, NULL, NULL, 'CREATE', NULL, '{\"nik\": \"3201011234560003\", \"name\": \"Budi Santoso\", \"created_at\": \"2026-03-27 01:59:59\"}', NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, '2026-03-26 18:59:59');

-- --------------------------------------------------------

--
-- Struktur dari tabel `bank_accounts`
--

CREATE TABLE `bank_accounts` (
  `id` int(11) NOT NULL,
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
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `bank_accounts`
--

INSERT INTO `bank_accounts` (`id`, `person_id`, `bank_name`, `bank_code`, `account_number`, `account_name`, `account_type`, `currency`, `branch_office`, `branch_address`, `opening_date`, `balance`, `overdraft_limit`, `interest_rate`, `is_joint_account`, `joint_account_holders`, `is_primary`, `is_active`, `is_dormant`, `last_transaction_date`, `atm_card`, `mobile_banking`, `internet_banking`, `notes`, `created_at`, `updated_at`) VALUES
(1, 1, 'BCA', '014', '1234567890', 'Ahmad Sudirman', 'Tabungan', 'IDR', 'KC Jakarta Pusat', NULL, '2005-01-15', 0.00, 0.00, NULL, 0, NULL, 1, 1, 0, NULL, 1, 1, 1, NULL, '2026-03-26 18:59:59', '2026-03-26 18:59:59'),
(2, 1, 'Mandiri', '008', '0987654321', 'Ahmad Sudirman', 'Tabungan', 'IDR', 'KC Jakarta Pusat', NULL, '2010-03-20', 0.00, 0.00, NULL, 0, NULL, 0, 1, 0, NULL, 1, 1, 1, NULL, '2026-03-26 18:59:59', '2026-03-26 18:59:59'),
(3, 2, 'BRI', '002', '1111222233', 'Siti Nurhaliza', 'Tabungan', 'IDR', 'KC Bandung', NULL, '2010-07-01', 0.00, 0.00, NULL, 0, NULL, 1, 1, 0, NULL, 1, 1, 1, NULL, '2026-03-26 18:59:59', '2026-03-26 18:59:59'),
(4, 3, 'BNI', '009', '4444555566', 'Budi Santoso', 'Tabungan', 'IDR', 'KC Surabaya', NULL, '2008-02-10', 0.00, 0.00, NULL, 0, NULL, 1, 1, 0, NULL, 1, 1, 1, NULL, '2026-03-26 18:59:59', '2026-03-26 18:59:59');

-- --------------------------------------------------------

--
-- Struktur dari tabel `business_information`
--

CREATE TABLE `business_information` (
  `id` int(11) NOT NULL,
  `person_id` int(11) NOT NULL COMMENT 'Person ID',
  `business_name` varchar(100) DEFAULT NULL COMMENT 'Nama usaha',
  `business_type` enum('pedagang_pasar','warung_kelontong','toko_kelontong','toko_semako','jasa','workshop','lainnya') NOT NULL,
  `business_category` varchar(50) DEFAULT NULL COMMENT 'Kategori usaha detail',
  `business_address` text DEFAULT NULL COMMENT 'Alamat usaha',
  `business_phone` varchar(15) DEFAULT NULL COMMENT 'Telepon usaha',
  `business_email` varchar(100) DEFAULT NULL COMMENT 'Email usaha',
  `start_date` date DEFAULT NULL COMMENT 'Tanggal mulai usaha',
  `monthly_revenue` decimal(12,2) DEFAULT NULL COMMENT 'Omzet bulanan',
  `monthly_expense` decimal(12,2) DEFAULT NULL COMMENT 'Biaya bulanan',
  `business_permit_number` varchar(50) DEFAULT NULL COMMENT 'Nomor izin usaha',
  `business_permit_expiry` date DEFAULT NULL COMMENT 'Masa berlaku izin usaha',
  `has_employees` tinyint(1) DEFAULT 0 COMMENT 'Memiliki karyawan',
  `number_of_employees` int(11) DEFAULT 0 COMMENT 'Jumlah karyawan',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `business_information`
--

INSERT INTO `business_information` (`id`, `person_id`, `business_name`, `business_type`, `business_category`, `business_address`, `business_phone`, `business_email`, `start_date`, `monthly_revenue`, `monthly_expense`, `business_permit_number`, `business_permit_expiry`, `has_employees`, `number_of_employees`, `created_at`, `updated_at`) VALUES
(1, 1, 'Toko Ahmad', 'pedagang_pasar', 'Semako', 'Pasar Senen Blok A No. 10', NULL, NULL, '2020-01-01', 5000000.00, 2000000.00, NULL, NULL, 1, 2, '2026-03-26 18:54:52', '2026-03-26 18:54:52'),
(2, 2, 'Warung Siti', 'warung_kelontong', 'Kelontong', 'Jl. Sudirman No. 456', NULL, NULL, '2019-06-15', 4000000.00, 1500000.00, NULL, NULL, 0, 0, '2026-03-26 18:54:52', '2026-03-26 18:54:52');

-- --------------------------------------------------------

--
-- Struktur dari tabel `business_records`
--

CREATE TABLE `business_records` (
  `id` int(11) NOT NULL,
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
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `business_records`
--

INSERT INTO `business_records` (`id`, `person_id`, `business_name`, `business_type`, `business_category`, `legal_entity`, `registration_number`, `tax_id`, `business_license`, `license_expiry`, `start_date`, `description`, `products_services`, `business_address`, `business_city`, `business_province`, `business_phone`, `business_email`, `business_website`, `business_social_media`, `annual_revenue`, `monthly_revenue`, `monthly_expense`, `profit_margin`, `number_of_employees`, `business_status`, `ownership_percentage`, `is_primary_business`, `created_at`, `updated_at`) VALUES
(1, 1, 'Toko Ahmad', 'Perdagangan', 'Semako', 'Perorangan', NULL, NULL, NULL, NULL, '2005-01-01', 'Toko sembako dan kebutuhan harian', NULL, 'Pasar Senen Blok A No. 10, Jakarta Pusat', NULL, NULL, '08123456789', NULL, NULL, NULL, 36000000.00, 3000000.00, 2000000.00, NULL, 2, 'Aktif', 100.00, 1, '2026-03-26 18:59:59', '2026-03-26 18:59:59'),
(2, 2, 'Warung Siti', 'Perdagangan', 'Kelontong', 'Perorangan', NULL, NULL, NULL, NULL, '2010-06-01', 'Warung kelontong dan kebutuhan rumah tangga', NULL, 'Jl. Sudirman No. 456, Bandung', NULL, NULL, '08234567890', NULL, NULL, NULL, 30000000.00, 2500000.00, 1500000.00, NULL, 0, 'Aktif', 100.00, 1, '2026-03-26 18:59:59', '2026-03-26 18:59:59');

-- --------------------------------------------------------

--
-- Struktur dari tabel `contacts`
--

CREATE TABLE `contacts` (
  `id` int(11) NOT NULL,
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
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `contacts`
--

INSERT INTO `contacts` (`id`, `person_id`, `contact_type`, `contact_name`, `relationship`, `organization`, `position`, `phone`, `phone2`, `whatsapp`, `email`, `address`, `city`, `province`, `postal_code`, `country`, `is_primary`, `is_active`, `notes`, `created_at`, `updated_at`) VALUES
(1, 1, 'Emergency', 'Dr. Andi Wijaya', 'Dokter Pribadi', NULL, NULL, '08567890123', NULL, '08567890123', 'andi.wijaya@hospital.com', 'Rumah Sakit Medika, Jl. Healthcare No. 100', NULL, NULL, NULL, 'Indonesia', 1, 1, NULL, '2026-03-26 18:59:25', '2026-03-26 18:59:25'),
(2, 2, 'Business', 'Haji Ahmad', 'Supplier', NULL, NULL, '08678901234', NULL, '08678901234', 'haji.ahmad@supplier.com', 'Pasar Grosir, Blok B No. 50', NULL, NULL, NULL, 'Indonesia', 0, 1, NULL, '2026-03-26 18:59:25', '2026-03-26 18:59:25'),
(3, 3, 'Reference', 'Prof. Dr. Siti Aminah', 'Mentor', NULL, NULL, '08789012345', NULL, '08789012345', 'siti.aminah@university.ac.id', 'Universitas Negeri, Kampus A', NULL, NULL, NULL, 'Indonesia', 1, 1, NULL, '2026-03-26 18:59:25', '2026-03-26 18:59:25'),
(4, 1, 'Emergency', 'Dr. Andi Wijaya', 'Dokter Pribadi', NULL, NULL, '08567890123', NULL, '08567890123', 'andi.wijaya@hospital.com', 'Rumah Sakit Medika, Jl. Healthcare No. 100', NULL, NULL, NULL, 'Indonesia', 1, 1, NULL, '2026-03-26 18:59:59', '2026-03-26 18:59:59'),
(5, 2, 'Business', 'Haji Ahmad', 'Supplier', NULL, NULL, '08678901234', NULL, '08678901234', 'haji.ahmad@supplier.com', 'Pasar Grosir, Blok B No. 50', NULL, NULL, NULL, 'Indonesia', 0, 1, NULL, '2026-03-26 18:59:59', '2026-03-26 18:59:59'),
(6, 3, 'Reference', 'Prof. Dr. Siti Aminah', 'Mentor', NULL, NULL, '08789012345', NULL, '08789012345', 'siti.aminah@university.ac.id', 'Universitas Negeri, Kampus A', NULL, NULL, NULL, 'Indonesia', 1, 1, NULL, '2026-03-26 18:59:59', '2026-03-26 18:59:59');

-- --------------------------------------------------------

--
-- Struktur dari tabel `digital_identities`
--

CREATE TABLE `digital_identities` (
  `id` int(11) NOT NULL,
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
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `documents`
--

CREATE TABLE `documents` (
  `id` int(11) NOT NULL,
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
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `documents`
--

INSERT INTO `documents` (`id`, `person_id`, `document_type`, `document_number`, `document_name`, `issuing_authority`, `issue_date`, `expiry_date`, `file_path`, `file_name`, `file_size`, `file_type`, `mime_type`, `checksum`, `is_verified`, `verification_method`, `verified_by`, `verified_at`, `verification_notes`, `is_public`, `access_level`, `tags`, `description`, `language`, `created_at`, `updated_at`) VALUES
(1, 1, 'KTP', '3201011234560001', NULL, 'Dinas Kependudukan', '2020-01-15', '2030-01-15', '/uploads/ktp/3201011234560001.jpg', 'KTP_Ahmad.jpg', NULL, 'JPG', NULL, NULL, 1, NULL, NULL, NULL, NULL, 0, 'Private', NULL, NULL, 'id', '2026-03-26 18:59:59', '2026-03-26 18:59:59'),
(2, 1, 'KK', '3201011234560001', NULL, 'Dinas Kependudukan', '2020-01-15', '2030-01-15', '/uploads/kk/3201011234560001.jpg', 'KK_Ahmad.jpg', NULL, 'JPG', NULL, NULL, 1, NULL, NULL, NULL, NULL, 0, 'Private', NULL, NULL, 'id', '2026-03-26 18:59:59', '2026-03-26 18:59:59'),
(3, 1, 'NPWP', '123456789012345', NULL, 'Direktorat Jenderal Pajak', '2018-03-10', NULL, '/uploads/npwp/123456789012345.jpg', 'NPWP_Ahmad.jpg', NULL, 'JPG', NULL, NULL, 1, NULL, NULL, NULL, NULL, 0, 'Private', NULL, NULL, 'id', '2026-03-26 18:59:59', '2026-03-26 18:59:59'),
(4, 2, 'KTP', '3201011234560002', NULL, 'Dinas Kependudukan', '2021-02-20', '2031-02-20', '/uploads/ktp/3201011234560002.jpg', 'KTP_Siti.jpg', NULL, 'JPG', NULL, NULL, 1, NULL, NULL, NULL, NULL, 0, 'Private', NULL, NULL, 'id', '2026-03-26 18:59:59', '2026-03-26 18:59:59'),
(5, 2, 'KK', '3201011234560002', NULL, 'Dinas Kependudukan', '2021-02-20', '2031-02-20', '/uploads/kk/3201011234560002.jpg', 'KK_Siti.jpg', NULL, 'JPG', NULL, NULL, 1, NULL, NULL, NULL, NULL, 0, 'Private', NULL, NULL, 'id', '2026-03-26 18:59:59', '2026-03-26 18:59:59'),
(6, 2, 'NPWP', '234567890123456', NULL, 'Direktorat Jenderal Pajak', '2019-05-15', NULL, '/uploads/npwp/234567890123456.jpg', 'NPWP_Siti.jpg', NULL, 'JPG', NULL, NULL, 1, NULL, NULL, NULL, NULL, 0, 'Private', NULL, NULL, 'id', '2026-03-26 18:59:59', '2026-03-26 18:59:59'),
(7, 3, 'KTP', '3201011234560003', NULL, 'Dinas Kependudukan', '2019-07-10', '2029-07-10', '/uploads/ktp/3201011234560003.jpg', 'KTP_Budi.jpg', NULL, 'JPG', NULL, NULL, 1, NULL, NULL, NULL, NULL, 0, 'Private', NULL, NULL, 'id', '2026-03-26 18:59:59', '2026-03-26 18:59:59'),
(8, 3, 'KK', '3201011234560003', NULL, 'Dinas Kependudukan', '2019-07-10', '2029-07-10', '/uploads/kk/3201011234560003.jpg', 'KK_Budi.jpg', NULL, 'JPG', NULL, NULL, 1, NULL, NULL, NULL, NULL, 0, 'Private', NULL, NULL, 'id', '2026-03-26 18:59:59', '2026-03-26 18:59:59'),
(9, 3, 'NPWP', '345678901234567', NULL, 'Direktorat Jenderal Pajak', '2017-09-20', NULL, '/uploads/npwp/345678901234567.jpg', 'NPWP_Budi.jpg', NULL, 'JPG', NULL, NULL, 1, NULL, NULL, NULL, NULL, 0, 'Private', NULL, NULL, 'id', '2026-03-26 18:59:59', '2026-03-26 18:59:59');

-- --------------------------------------------------------

--
-- Struktur dari tabel `document_uploads`
--

CREATE TABLE `document_uploads` (
  `id` int(11) NOT NULL,
  `person_id` int(11) NOT NULL COMMENT 'Person ID',
  `document_type` enum('KTP','KK','NPWP','BPJS_Kesehatan','BPJS_Ketenagakerjaan','Izin_Usaha','Surat_Nikah','Akta_Kelahiran','Ijazah','Foto_Profil','Tanda_Tangan','Lainnya') NOT NULL,
  `document_number` varchar(50) DEFAULT NULL COMMENT 'Nomor dokumen',
  `file_path` varchar(255) NOT NULL COMMENT 'Path file dokumen',
  `file_name` varchar(255) NOT NULL COMMENT 'Nama file asli',
  `file_size` int(11) DEFAULT NULL COMMENT 'Ukuran file (bytes)',
  `file_type` varchar(50) DEFAULT NULL COMMENT 'Tipe file (PDF, JPG, dll)',
  `upload_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `expiry_date` date DEFAULT NULL COMMENT 'Masa berlaku dokumen',
  `is_verified` tinyint(1) DEFAULT 0 COMMENT 'Status verifikasi',
  `verified_by` int(11) DEFAULT NULL COMMENT 'Diverifikasi oleh',
  `verified_at` timestamp NULL DEFAULT NULL COMMENT 'Tanggal verifikasi',
  `notes` text DEFAULT NULL COMMENT 'Catatan verifikasi'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `document_uploads`
--

INSERT INTO `document_uploads` (`id`, `person_id`, `document_type`, `document_number`, `file_path`, `file_name`, `file_size`, `file_type`, `upload_date`, `expiry_date`, `is_verified`, `verified_by`, `verified_at`, `notes`) VALUES
(1, 1, 'KTP', '3201011234560001', '/uploads/ktp/3201011234560001.jpg', 'KTP_Ahmad.jpg', NULL, 'JPG', '2026-03-26 18:54:52', NULL, 1, NULL, NULL, NULL),
(2, 1, 'KK', '3201011234560001', '/uploads/kk/3201011234560001.jpg', 'KK_Ahmad.jpg', NULL, 'JPG', '2026-03-26 18:54:52', NULL, 1, NULL, NULL, NULL),
(3, 1, 'NPWP', '123456789012345', '/uploads/npwp/123456789012345678.jpg', 'NPWP_Ahmad.jpg', NULL, 'JPG', '2026-03-26 18:54:52', NULL, 1, NULL, NULL, NULL),
(4, 2, 'KTP', '3201011234560002', '/uploads/ktp/3201011234560002.jpg', 'KTP_Siti.jpg', NULL, 'JPG', '2026-03-26 18:54:52', NULL, 1, NULL, NULL, NULL),
(5, 2, 'KK', '3201011234560002', '/uploads/kk/3201011234560002.jpg', 'KK_Siti.jpg', NULL, 'JPG', '2026-03-26 18:54:52', NULL, 1, NULL, NULL, NULL),
(6, 2, 'NPWP', '234567890123456', '/uploads/npwp/234567890123456.jpg', 'NPWP_Siti.jpg', NULL, 'JPG', '2026-03-26 18:54:52', NULL, 1, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Struktur dari tabel `education_background`
--

CREATE TABLE `education_background` (
  `id` int(11) NOT NULL,
  `person_id` int(11) NOT NULL COMMENT 'Person ID',
  `education_level` enum('Tidak Sekolah','SD','SMP','SMA','D3','D4','S1','S2','S3') NOT NULL,
  `institution_name` varchar(100) DEFAULT NULL COMMENT 'Nama institusi pendidikan',
  `major` varchar(100) DEFAULT NULL COMMENT 'Jurusan/Program studi',
  `year_graduated` int(11) DEFAULT NULL COMMENT 'Tahun lulus',
  `certificate_path` varchar(255) DEFAULT NULL COMMENT 'Path ijazah/sertifikat',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `education_records`
--

CREATE TABLE `education_records` (
  `id` int(11) NOT NULL,
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
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `education_records`
--

INSERT INTO `education_records` (`id`, `person_id`, `education_level`, `institution_name`, `institution_type`, `major_field`, `specialization`, `start_date`, `end_date`, `graduation_date`, `gpa`, `max_gpa`, `thesis_title`, `achievement`, `certificate_number`, `certificate_path`, `is_completed`, `is_current`, `notes`, `created_at`, `updated_at`) VALUES
(1, 1, 'SMA', 'SMA Negeri 1 Jakarta', 'Negeri', 'IPA', NULL, '1998-07-01', '2003-06-30', '2003-06-30', 3.25, 4.00, NULL, NULL, NULL, NULL, 1, 0, NULL, '2026-03-26 18:59:25', '2026-03-26 18:59:25'),
(2, 2, 'S1', 'Universitas Padjadjaran', 'Negeri', 'Manajemen', NULL, '2006-07-01', '2010-06-30', '2010-06-30', 3.45, 4.00, NULL, NULL, NULL, NULL, 1, 0, NULL, '2026-03-26 18:59:25', '2026-03-26 18:59:25'),
(3, 3, 'S2', 'Universitas Airlangga', 'Negeri', 'Pendidikan', NULL, '2003-07-01', '2005-06-30', '2005-06-30', 3.75, 4.00, NULL, NULL, NULL, NULL, 1, 0, NULL, '2026-03-26 18:59:25', '2026-03-26 18:59:25'),
(4, 1, 'SMA', 'SMA Negeri 1 Jakarta', 'Negeri', 'IPA', NULL, '1998-07-01', '2003-06-30', '2003-06-30', 3.25, 4.00, NULL, NULL, NULL, NULL, 1, 0, NULL, '2026-03-26 18:59:59', '2026-03-26 18:59:59'),
(5, 2, 'S1', 'Universitas Padjadjaran', 'Negeri', 'Manajemen', NULL, '2006-07-01', '2010-06-30', '2010-06-30', 3.45, 4.00, NULL, NULL, NULL, NULL, 1, 0, NULL, '2026-03-26 18:59:59', '2026-03-26 18:59:59'),
(6, 3, 'S2', 'Universitas Airlangga', 'Negeri', 'Pendidikan', NULL, '2003-07-01', '2005-06-30', '2005-06-30', 3.75, 4.00, NULL, NULL, NULL, NULL, 1, 0, NULL, '2026-03-26 18:59:59', '2026-03-26 18:59:59');

-- --------------------------------------------------------

--
-- Struktur dari tabel `emergency_contacts`
--

CREATE TABLE `emergency_contacts` (
  `id` int(11) NOT NULL,
  `person_id` int(11) NOT NULL COMMENT 'Person ID',
  `contact_name` varchar(100) NOT NULL COMMENT 'Nama kontak darurat',
  `relationship` varchar(50) DEFAULT NULL COMMENT 'Hubungan dengan anggota',
  `phone` varchar(15) NOT NULL COMMENT 'Nomor telepon kontak darurat',
  `address` text DEFAULT NULL COMMENT 'Alamat kontak darurat',
  `is_primary` tinyint(1) DEFAULT 0 COMMENT 'Kontak utama',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `employment_records`
--

CREATE TABLE `employment_records` (
  `id` int(11) NOT NULL,
  `person_id` int(11) NOT NULL COMMENT 'Person ID',
  `company_name` varchar(100) NOT NULL COMMENT 'Nama perusahaan/instansi',
  `company_type` enum('Pemerintah','BUMN','Swasta','Multinasional','Startup','NGO','Pendidikan','Kesehatan','Sendiri','Lainnya') NOT NULL,
  `industry_sector` varchar(50) DEFAULT NULL COMMENT 'Sektor industri',
  `position` varchar(100) NOT NULL COMMENT 'Jabatan/posisi',
  `department` varchar(100) DEFAULT NULL COMMENT 'Departemen',
  `level` enum('Staff','Supervisor','Manager','Senior Manager','Director','VP','C-Level','Owner','Lainnya') DEFAULT NULL COMMENT 'Level jabatan',
  `employment_type` enum('Tetap','Kontrak','Freelance','Part-time','Magang','Volunteer','Lainnya') NOT NULL,
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
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `family_links`
--

CREATE TABLE `family_links` (
  `id` int(11) NOT NULL,
  `person1_id` int(11) NOT NULL COMMENT 'Person ID 1',
  `person2_id` int(11) NOT NULL COMMENT 'Person ID 2',
  `relationship` enum('suami_istri','orang_tua_anak','kakek_nenek_cucu','saudara_kandung','saudara_ipar','paman_keponakan','sepupu','lainnya') NOT NULL,
  `is_primary` tinyint(1) DEFAULT 0 COMMENT 'Hubungan utama (untuk suami/istri)',
  `verification_status` enum('Pending','Verified','Rejected') DEFAULT 'Pending',
  `verified_by` int(11) DEFAULT NULL COMMENT 'Diverifikasi oleh',
  `verified_at` timestamp NULL DEFAULT NULL COMMENT 'Tanggal verifikasi',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `family_links`
--

INSERT INTO `family_links` (`id`, `person1_id`, `person2_id`, `relationship`, `is_primary`, `verification_status`, `verified_by`, `verified_at`, `created_at`) VALUES
(1, 1, 2, 'suami_istri', 1, 'Verified', NULL, NULL, '2026-03-26 18:54:52');

-- --------------------------------------------------------

--
-- Struktur dari tabel `family_relationships`
--

CREATE TABLE `family_relationships` (
  `id` int(11) NOT NULL,
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
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `family_relationships`
--

INSERT INTO `family_relationships` (`id`, `person1_id`, `person2_id`, `relationship_type`, `relationship_level`, `is_primary`, `is_legal_guardian`, `is_emergency_contact`, `custody_level`, `financial_responsibility`, `verification_status`, `verified_by`, `verified_at`, `notes`, `created_at`, `updated_at`) VALUES
(1, 1, 2, 'Suami', '1', 1, 1, 0, 'None', 'None', 'Verified', NULL, NULL, NULL, '2026-03-26 18:59:59', '2026-03-26 18:59:59'),
(2, 1, 3, 'Kakak', '2', 0, 0, 0, 'None', 'None', 'Verified', NULL, NULL, NULL, '2026-03-26 18:59:59', '2026-03-26 18:59:59');

-- --------------------------------------------------------

--
-- Struktur dari tabel `health_records`
--

CREATE TABLE `health_records` (
  `id` int(11) NOT NULL,
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
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `persons`
--

CREATE TABLE `persons` (
  `id` int(11) NOT NULL,
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
  `updated_by` int(11) DEFAULT NULL COMMENT 'Diupdate oleh (user_id)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `persons`
--

INSERT INTO `persons` (`id`, `nik`, `kk_number`, `name`, `name_alias`, `birth_place`, `birth_date`, `gender`, `religion`, `blood_type`, `nationality`, `height`, `weight`, `hair_color`, `eye_color`, `skin_color`, `distinguishing_marks`, `phone`, `phone2`, `whatsapp`, `telegram`, `instagram`, `facebook`, `email`, `email2`, `website`, `address_detail`, `rt`, `rw`, `postal_code`, `address_type`, `occupation`, `occupation_code`, `workplace`, `work_address`, `work_phone`, `work_email`, `monthly_income`, `annual_income`, `business_type`, `industry_sector`, `company_name`, `position`, `employment_status`, `education_level`, `education_major`, `education_institution`, `graduation_year`, `gpa`, `marital_status`, `spouse_name`, `spouse_nik`, `spouse_phone`, `spouse_occupation`, `number_of_children`, `father_name`, `father_nik`, `father_occupation`, `mother_name`, `mother_nik`, `mother_occupation`, `npwp`, `bpjs_kesehatan`, `bpjs_ketenagakerjaan`, `jamsostek`, `passport_number`, `passport_expiry`, `sim_type`, `sim_number`, `sim_expiry`, `health_condition`, `chronic_diseases`, `allergies`, `medications`, `blood_pressure`, `blood_sugar`, `disability`, `disability_description`, `photo_path`, `ktp_photo_path`, `kk_photo_path`, `signature_path`, `fingerprint_data`, `face_recognition_data`, `bank_account_count`, `credit_card_count`, `credit_score`, `credit_rating`, `bankruptcy_status`, `risk_level`, `is_blacklisted`, `blacklist_reason`, `is_watchlist`, `watchlist_reason`, `hobbies`, `interests`, `skills`, `languages`, `preferred_contact`, `is_active`, `is_deceased`, `death_date`, `verification_status`, `verification_date`, `verified_by`, `last_login`, `last_activity`, `created_at`, `updated_at`, `created_by`, `updated_by`) VALUES
(1, '3201011234560001', '3201011234560001', 'Ahmad Sudirman', 'Pak Ahmad', 'Jakarta', '1985-05-15', 'L', 'Islam', 'A', 'WNI', NULL, NULL, NULL, NULL, NULL, NULL, '08123456789', NULL, '08123456789', NULL, NULL, NULL, 'ahmad.sudirman@email.com', NULL, NULL, 'Jl. Merdeka No. 123, Kelurahan Menteng', '001', '002', '12345', 'Rumah', 'Pedagang', NULL, 'Pasar Senen', 'Pasar Senen Blok A No. 10, Jakarta Pusat', NULL, NULL, 3000000.00, 36000000.00, 'Pedagang', NULL, NULL, NULL, NULL, 'SMA', NULL, 'SMA Negeri 1 Jakarta', 2003, NULL, 'Menikah', 'Siti Nurhaliza', NULL, '08234567890', NULL, 2, 'Budi Santoso', NULL, NULL, 'Siti Rohani', NULL, NULL, '123456789012345', '0001234567890', '0001234567890', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Tidak Ada', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 75, NULL, 0, 'Sedang', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'Phone', 1, 0, NULL, 'Verified', NULL, NULL, NULL, NULL, '2026-03-26 18:59:59', '2026-03-26 18:59:59', 1, NULL),
(2, '3201011234560002', '3201011234560002', 'Siti Nurhaliza', 'Bu Siti', 'Bandung', '1988-08-20', 'P', 'Islam', 'B', 'WNI', NULL, NULL, NULL, NULL, NULL, NULL, '08234567890', NULL, '08234567890', NULL, NULL, NULL, 'siti.nurhaliza@email.com', NULL, NULL, 'Jl. Sudirman No. 456, Kelurahan Sukajadi', '003', '004', '54321', 'Rumah', 'Pengusaha', NULL, 'Warung Siti', 'Jl. Sudirman No. 456, Bandung', NULL, NULL, 2500000.00, 30000000.00, 'Wiraswasta', NULL, NULL, NULL, NULL, 'S1', NULL, 'Universitas Padjadjaran', 2010, NULL, 'Menikah', 'Ahmad Sudirman', NULL, '08123456789', NULL, 2, 'Ahmad Wijaya', NULL, NULL, 'Dewi Sartika', NULL, NULL, '234567890123456', '0002345678901', '0002345678901', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Tidak Ada', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 70, NULL, 0, 'Sedang', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'Phone', 1, 0, NULL, 'Verified', NULL, NULL, NULL, NULL, '2026-03-26 18:59:59', '2026-03-26 18:59:59', 1, NULL),
(3, '3201011234560003', '3201011234560003', 'Budi Santoso', 'Pak Budi', 'Surabaya', '1980-03-10', 'L', 'Islam', 'O', 'WNI', NULL, NULL, NULL, NULL, NULL, NULL, '08345678901', NULL, '08345678901', NULL, NULL, NULL, 'budi.santoso@email.com', NULL, NULL, 'Jl. Gubernur Suryo No. 789, Kelurahan Genteng', '005', '006', '65432', 'Rumah', 'PNS', NULL, 'Dinas Pendidikan', 'Dinas Pendidikan Kota Surabaya', NULL, NULL, 8000000.00, 96000000.00, 'PNS', NULL, NULL, NULL, NULL, 'S2', NULL, 'Universitas Airlangga', 2005, NULL, 'Menikah', 'Ratna Sari', NULL, '08456789012', NULL, 3, 'Suprapto', NULL, NULL, 'Sumarni', NULL, NULL, '345678901234567', '0003456789012', '0003456789012', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Tidak Ada', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 85, NULL, 0, 'Rendah', 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'Phone', 1, 0, NULL, 'Verified', NULL, NULL, NULL, NULL, '2026-03-26 18:59:59', '2026-03-26 18:59:59', 1, NULL);

--
-- Trigger `persons`
--
DELIMITER $$
CREATE TRIGGER `tr_person_audit_log` AFTER INSERT ON `persons` FOR EACH ROW BEGIN
    INSERT INTO audit_logs (person_id, action, new_values, user_id)
    VALUES (NEW.id, 'CREATE', 
            JSON_OBJECT('nik', NEW.nik, 'name', NEW.name, 'created_at', NEW.created_at), 
            NEW.created_by);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tr_person_audit_log_update` AFTER UPDATE ON `persons` FOR EACH ROW BEGIN
    INSERT INTO audit_logs (person_id, action, old_values, new_values, user_id)
    VALUES (NEW.id, 'UPDATE', 
            JSON_OBJECT('nik', OLD.nik, 'name', OLD.name, 'updated_at', OLD.updated_at),
            JSON_OBJECT('nik', NEW.nik, 'name', NEW.name, 'updated_at', NEW.updated_at), 
            NEW.updated_by);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tr_person_update_risk_assessment` AFTER UPDATE ON `persons` FOR EACH ROW BEGIN
    IF NEW.annual_income <> OLD.annual_income OR 
       NEW.business_type <> OLD.business_type OR 
       NEW.marital_status <> OLD.marital_status OR
       NEW.number_of_children <> OLD.number_of_children OR
       NEW.education_level <> OLD.education_level OR
       NEW.occupation <> OLD.occupation OR
       NEW.is_blacklisted <> OLD.is_blacklisted THEN
        CALL CalculateUniversalCreditScore(NEW.id);
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `person_complete_profile`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `person_complete_profile` (
`id` int(11)
,`nik` varchar(16)
,`kk_number` varchar(16)
,`name` varchar(100)
,`name_alias` varchar(100)
,`birth_place` varchar(50)
,`birth_date` date
,`age` bigint(21)
,`gender` enum('L','P')
,`religion` enum('Islam','Kristen','Katolik','Hindu','Budha','Konghucu','Lainnya','Tidak Ada')
,`blood_type` enum('A','B','AB','O','Tidak Tahu')
,`nationality` varchar(50)
,`height` decimal(5,2)
,`weight` decimal(5,2)
,`phone` varchar(15)
,`whatsapp` varchar(15)
,`email` varchar(100)
,`address_detail` text
,`rt` varchar(3)
,`rw` varchar(3)
,`postal_code` varchar(5)
,`occupation` varchar(100)
,`workplace` varchar(100)
,`monthly_income` decimal(12,2)
,`annual_income` decimal(15,2)
,`business_type` enum('PNS','Swasta','Wiraswasta','Pedagang','Petani','Nelayan','Buruh','Pelajar','Mahasiswa','Pensiun','Tidak Bekerja','Lainnya')
,`education_level` enum('Tidak Sekolah','SD','SMP','SMA','D1','D2','D3','D4','S1','S2','S3','Profesi','Lainnya')
,`marital_status` enum('Belum Menikah','Menikah','Cerai Hidup','Cerai Mati','Janda','Duda')
,`spouse_name` varchar(100)
,`number_of_children` int(11)
,`npwp` varchar(20)
,`bpjs_kesehatan` varchar(13)
,`bpjs_ketenagakerjaan` varchar(15)
,`credit_score` int(11)
,`risk_level` enum('Rendah','Sedang','Tinggi','Sangat Tinggi')
,`verification_status` enum('Pending','Verified','Rejected','Expired')
,`is_active` tinyint(1)
,`is_blacklisted` tinyint(1)
,`is_deceased` tinyint(1)
,`death_date` date
,`created_at` timestamp
,`updated_at` timestamp
,`verified_family_count` bigint(21)
,`active_contacts_count` bigint(21)
,`completed_education_count` bigint(21)
,`current_employment_count` bigint(21)
,`active_business_count` bigint(21)
,`active_bank_accounts_count` bigint(21)
,`verified_documents_count` bigint(21)
,`health_records_count` bigint(21)
);

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `person_risk_assessment`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `person_risk_assessment` (
`id` int(11)
,`name` varchar(100)
,`nik` varchar(16)
,`phone` varchar(15)
,`email` varchar(100)
,`credit_score` int(11)
,`risk_level` enum('Rendah','Sedang','Tinggi','Sangat Tinggi')
,`monthly_income` decimal(12,2)
,`annual_income` decimal(15,2)
,`business_type` enum('PNS','Swasta','Wiraswasta','Pedagang','Petani','Nelayan','Buruh','Pelajar','Mahasiswa','Pensiun','Tidak Bekerja','Lainnya')
,`marital_status` enum('Belum Menikah','Menikah','Cerai Hidup','Cerai Mati','Janda','Duda')
,`number_of_children` int(11)
,`education_level` enum('Tidak Sekolah','SD','SMP','SMA','D1','D2','D3','D4','S1','S2','S3','Profesi','Lainnya')
,`occupation` varchar(100)
,`is_blacklisted` tinyint(1)
,`is_watchlist` tinyint(1)
,`calculated_risk` varchar(13)
,`income_family_ratio` varchar(6)
,`employment_stability` varchar(13)
,`business_profitability` varchar(11)
,`blacklisted_family_count` bigint(21)
,`verified_documents_count` bigint(21)
,`age_factor` varchar(7)
,`member_since` timestamp
);

-- --------------------------------------------------------

--
-- Struktur dari tabel `preferences`
--

CREATE TABLE `preferences` (
  `id` int(11) NOT NULL,
  `person_id` int(11) NOT NULL COMMENT 'Person ID',
  `preference_category` varchar(50) NOT NULL COMMENT 'Kategori preferensi',
  `preference_key` varchar(100) NOT NULL COMMENT 'Key preferensi',
  `preference_value` text DEFAULT NULL COMMENT 'Value preferensi',
  `data_type` enum('String','Number','Boolean','JSON','Date','Time') DEFAULT 'String' COMMENT 'Tipe data',
  `is_system` tinyint(1) DEFAULT 0 COMMENT 'Preferensi sistem',
  `is_public` tinyint(1) DEFAULT 0 COMMENT 'Dapat diakses publik',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `preferences`
--

INSERT INTO `preferences` (`id`, `person_id`, `preference_category`, `preference_key`, `preference_value`, `data_type`, `is_system`, `is_public`, `created_at`, `updated_at`) VALUES
(1, 1, 'notification', 'email_notifications', 'true', 'Boolean', 0, 0, '2026-03-26 18:59:59', '2026-03-26 18:59:59'),
(2, 1, 'notification', 'sms_notifications', 'false', 'Boolean', 0, 0, '2026-03-26 18:59:59', '2026-03-26 18:59:59'),
(3, 1, 'language', 'preferred_language', 'id', 'String', 0, 0, '2026-03-26 18:59:59', '2026-03-26 18:59:59'),
(4, 1, 'privacy', 'share_contact_info', 'family_only', 'String', 0, 0, '2026-03-26 18:59:59', '2026-03-26 18:59:59'),
(5, 2, 'notification', 'whatsapp_notifications', 'true', 'Boolean', 0, 0, '2026-03-26 18:59:59', '2026-03-26 18:59:59'),
(6, 2, 'language', 'preferred_language', 'id', 'String', 0, 0, '2026-03-26 18:59:59', '2026-03-26 18:59:59'),
(7, 3, 'notification', 'email_notifications', 'true', 'Boolean', 0, 0, '2026-03-26 18:59:59', '2026-03-26 18:59:59'),
(8, 3, 'privacy', 'share_contact_info', 'public', 'String', 0, 0, '2026-03-26 18:59:59', '2026-03-26 18:59:59');

-- --------------------------------------------------------

--
-- Struktur dari tabel `risk_assessment_history`
--

CREATE TABLE `risk_assessment_history` (
  `id` int(11) NOT NULL,
  `person_id` int(11) NOT NULL COMMENT 'Person ID',
  `assessment_date` date NOT NULL COMMENT 'Tanggal penilaian',
  `credit_score` int(11) NOT NULL COMMENT 'Skor kredit (0-100)',
  `risk_level` enum('Rendah','Sedang','Tinggi') NOT NULL COMMENT 'Tingkat risiko',
  `assessment_factors` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Faktor penilaian (JSON)' CHECK (json_valid(`assessment_factors`)),
  `notes` text DEFAULT NULL COMMENT 'Catatan penilaian',
  `assessed_by` int(11) NOT NULL COMMENT 'Dinilai oleh (user_id)',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `verification_history`
--

CREATE TABLE `verification_history` (
  `id` int(11) NOT NULL,
  `person_id` int(11) NOT NULL COMMENT 'Person ID',
  `verification_type` enum('Data_Diri','Dokumen','Alamat','Usaha','Keluarga','Lainnya') NOT NULL,
  `verification_status` enum('Pending','Verified','Rejected') NOT NULL,
  `verification_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `verified_by` int(11) NOT NULL COMMENT 'Diverifikasi oleh (user_id)',
  `notes` text DEFAULT NULL COMMENT 'Catatan verifikasi',
  `previous_status` varchar(50) DEFAULT NULL COMMENT 'Status sebelumnya'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur untuk view `person_complete_profile`
--
DROP TABLE IF EXISTS `person_complete_profile`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `person_complete_profile`  AS SELECT `p`.`id` AS `id`, `p`.`nik` AS `nik`, `p`.`kk_number` AS `kk_number`, `p`.`name` AS `name`, `p`.`name_alias` AS `name_alias`, `p`.`birth_place` AS `birth_place`, `p`.`birth_date` AS `birth_date`, timestampdiff(YEAR,`p`.`birth_date`,curdate()) AS `age`, `p`.`gender` AS `gender`, `p`.`religion` AS `religion`, `p`.`blood_type` AS `blood_type`, `p`.`nationality` AS `nationality`, `p`.`height` AS `height`, `p`.`weight` AS `weight`, `p`.`phone` AS `phone`, `p`.`whatsapp` AS `whatsapp`, `p`.`email` AS `email`, `p`.`address_detail` AS `address_detail`, `p`.`rt` AS `rt`, `p`.`rw` AS `rw`, `p`.`postal_code` AS `postal_code`, `p`.`occupation` AS `occupation`, `p`.`workplace` AS `workplace`, `p`.`monthly_income` AS `monthly_income`, `p`.`annual_income` AS `annual_income`, `p`.`business_type` AS `business_type`, `p`.`education_level` AS `education_level`, `p`.`marital_status` AS `marital_status`, `p`.`spouse_name` AS `spouse_name`, `p`.`number_of_children` AS `number_of_children`, `p`.`npwp` AS `npwp`, `p`.`bpjs_kesehatan` AS `bpjs_kesehatan`, `p`.`bpjs_ketenagakerjaan` AS `bpjs_ketenagakerjaan`, `p`.`credit_score` AS `credit_score`, `p`.`risk_level` AS `risk_level`, `p`.`verification_status` AS `verification_status`, `p`.`is_active` AS `is_active`, `p`.`is_blacklisted` AS `is_blacklisted`, `p`.`is_deceased` AS `is_deceased`, `p`.`death_date` AS `death_date`, `p`.`created_at` AS `created_at`, `p`.`updated_at` AS `updated_at`, (select count(0) from `family_relationships` `fr` where (`fr`.`person1_id` = `p`.`id` or `fr`.`person2_id` = `p`.`id`) and `fr`.`verification_status` = 'Verified') AS `verified_family_count`, (select count(0) from `contacts` `c` where `c`.`person_id` = `p`.`id` and `c`.`is_active` = 1) AS `active_contacts_count`, (select count(0) from `education_records` `er` where `er`.`person_id` = `p`.`id` and `er`.`is_completed` = 1) AS `completed_education_count`, (select count(0) from `employment_records` `emr` where `emr`.`person_id` = `p`.`id` and `emr`.`is_current` = 1) AS `current_employment_count`, (select count(0) from `business_records` `br` where `br`.`person_id` = `p`.`id` and `br`.`business_status` = 'Aktif') AS `active_business_count`, (select count(0) from `bank_accounts` `ba` where `ba`.`person_id` = `p`.`id` and `ba`.`is_active` = 1) AS `active_bank_accounts_count`, (select count(0) from `documents` `d` where `d`.`person_id` = `p`.`id` and `d`.`is_verified` = 1) AS `verified_documents_count`, (select count(0) from `health_records` `hr` where `hr`.`person_id` = `p`.`id`) AS `health_records_count` FROM `persons` AS `p` WHERE `p`.`is_active` = 1 ;

-- --------------------------------------------------------

--
-- Struktur untuk view `person_risk_assessment`
--
DROP TABLE IF EXISTS `person_risk_assessment`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `person_risk_assessment`  AS SELECT `p`.`id` AS `id`, `p`.`name` AS `name`, `p`.`nik` AS `nik`, `p`.`phone` AS `phone`, `p`.`email` AS `email`, `p`.`credit_score` AS `credit_score`, `p`.`risk_level` AS `risk_level`, `p`.`monthly_income` AS `monthly_income`, `p`.`annual_income` AS `annual_income`, `p`.`business_type` AS `business_type`, `p`.`marital_status` AS `marital_status`, `p`.`number_of_children` AS `number_of_children`, `p`.`education_level` AS `education_level`, `p`.`occupation` AS `occupation`, `p`.`is_blacklisted` AS `is_blacklisted`, `p`.`is_watchlist` AS `is_watchlist`, CASE WHEN `p`.`credit_score` >= 80 THEN 'Rendah' WHEN `p`.`credit_score` >= 60 THEN 'Sedang' WHEN `p`.`credit_score` >= 40 THEN 'Tinggi' ELSE 'Sangat Tinggi' END AS `calculated_risk`, CASE WHEN `p`.`annual_income` > 0 AND `p`.`number_of_children` > 0 THEN CASE WHEN `p`.`annual_income` / (`p`.`number_of_children` + 1) > 24000000 THEN 'Baik' WHEN `p`.`annual_income` / (`p`.`number_of_children` + 1) > 12000000 THEN 'Cukup' ELSE 'Kurang' END ELSE 'Baik' END AS `income_family_ratio`, CASE WHEN `emr`.`employment_type` in ('Tetap','PNS','BUMN') THEN 'Stabil' WHEN `emr`.`employment_type` in ('Kontrak','Freelance') THEN 'Sedang Stabil' ELSE 'Tidak Stabil' END AS `employment_stability`, CASE WHEN `br`.`annual_revenue` > 0 AND `br`.`monthly_expense` > 0 THEN CASE WHEN (`br`.`annual_revenue` - `br`.`monthly_expense` * 12) / `br`.`annual_revenue` > 0.3 THEN 'Profitable' WHEN (`br`.`annual_revenue` - `br`.`monthly_expense` * 12) / `br`.`annual_revenue` > 0.1 THEN 'Breakeven' ELSE 'Loss Making' END ELSE 'Unknown' END AS `business_profitability`, (select count(0) from (`family_relationships` `fr` join `persons` `p2` on(`fr`.`person1_id` = `p2`.`id` or `fr`.`person2_id` = `p2`.`id`)) where (`fr`.`person1_id` = `p`.`id` or `fr`.`person2_id` = `p`.`id`) and `p2`.`is_blacklisted` = 1) AS `blacklisted_family_count`, (select count(0) from `documents` `d` where `d`.`person_id` = `p`.`id` and `d`.`is_verified` = 1) AS `verified_documents_count`, CASE WHEN timestampdiff(YEAR,`p`.`birth_date`,curdate()) between 25 and 55 THEN 'Optimal' WHEN timestampdiff(YEAR,`p`.`birth_date`,curdate()) between 18 and 65 THEN 'Good' ELSE 'Risk' END AS `age_factor`, `p`.`created_at` AS `member_since` FROM ((`persons` `p` left join `employment_records` `emr` on(`p`.`id` = `emr`.`person_id` and `emr`.`is_current` = 1)) left join `business_records` `br` on(`p`.`id` = `br`.`person_id` and `br`.`is_primary_business` = 1)) WHERE `p`.`is_active` = 1 ;

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_person` (`person_id`),
  ADD KEY `idx_table_name` (`table_name`),
  ADD KEY `idx_record_id` (`record_id`),
  ADD KEY `idx_action` (`action`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_username` (`username`),
  ADD KEY `idx_ip_address` (`ip_address`),
  ADD KEY `idx_created_at` (`created_at`),
  ADD KEY `idx_reference` (`reference_type`,`reference_id`);

--
-- Indeks untuk tabel `bank_accounts`
--
ALTER TABLE `bank_accounts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_account_number` (`bank_name`,`account_number`),
  ADD KEY `idx_person` (`person_id`),
  ADD KEY `idx_bank_name` (`bank_name`),
  ADD KEY `idx_account_number` (`account_number`),
  ADD KEY `idx_account_type` (`account_type`),
  ADD KEY `idx_currency` (`currency`),
  ADD KEY `idx_is_primary` (`is_primary`),
  ADD KEY `idx_is_active` (`is_active`),
  ADD KEY `idx_balance` (`balance`);

--
-- Indeks untuk tabel `business_information`
--
ALTER TABLE `business_information`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_person` (`person_id`),
  ADD KEY `idx_business_type` (`business_type`),
  ADD KEY `idx_business_category` (`business_category`),
  ADD KEY `idx_monthly_revenue` (`monthly_revenue`);

--
-- Indeks untuk tabel `business_records`
--
ALTER TABLE `business_records`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_person` (`person_id`),
  ADD KEY `idx_business_name` (`business_name`),
  ADD KEY `idx_business_type` (`business_type`),
  ADD KEY `idx_legal_entity` (`legal_entity`),
  ADD KEY `idx_start_date` (`start_date`),
  ADD KEY `idx_business_status` (`business_status`),
  ADD KEY `idx_annual_revenue` (`annual_revenue`),
  ADD KEY `idx_number_of_employees` (`number_of_employees`);

--
-- Indeks untuk tabel `contacts`
--
ALTER TABLE `contacts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_person` (`person_id`),
  ADD KEY `idx_contact_type` (`contact_type`),
  ADD KEY `idx_phone` (`phone`),
  ADD KEY `idx_whatsapp` (`whatsapp`),
  ADD KEY `idx_email` (`email`),
  ADD KEY `idx_is_primary` (`is_primary`),
  ADD KEY `idx_is_active` (`is_active`);

--
-- Indeks untuk tabel `digital_identities`
--
ALTER TABLE `digital_identities`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_person` (`person_id`),
  ADD KEY `idx_platform` (`platform`),
  ADD KEY `idx_platform_user_id` (`platform_user_id`),
  ADD KEY `idx_username` (`username`),
  ADD KEY `idx_email` (`email`),
  ADD KEY `idx_phone` (`phone`),
  ADD KEY `idx_is_active` (`is_active`),
  ADD KEY `idx_is_verified` (`is_verified`),
  ADD KEY `idx_last_login` (`last_login`);

--
-- Indeks untuk tabel `documents`
--
ALTER TABLE `documents`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_person` (`person_id`),
  ADD KEY `idx_document_type` (`document_type`),
  ADD KEY `idx_document_number` (`document_number`),
  ADD KEY `idx_issuing_authority` (`issuing_authority`),
  ADD KEY `idx_issue_date` (`issue_date`),
  ADD KEY `idx_expiry_date` (`expiry_date`),
  ADD KEY `idx_is_verified` (`is_verified`),
  ADD KEY `idx_verification_method` (`verification_method`),
  ADD KEY `idx_access_level` (`access_level`),
  ADD KEY `idx_created_at` (`created_at`),
  ADD KEY `idx_expiry_warning` (`expiry_date`,`is_verified`);

--
-- Indeks untuk tabel `document_uploads`
--
ALTER TABLE `document_uploads`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_person` (`person_id`),
  ADD KEY `idx_document_type` (`document_type`),
  ADD KEY `idx_expiry_date` (`expiry_date`),
  ADD KEY `idx_is_verified` (`is_verified`),
  ADD KEY `idx_upload_date` (`upload_date`);

--
-- Indeks untuk tabel `education_background`
--
ALTER TABLE `education_background`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_person` (`person_id`),
  ADD KEY `idx_education_level` (`education_level`);

--
-- Indeks untuk tabel `education_records`
--
ALTER TABLE `education_records`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_person` (`person_id`),
  ADD KEY `idx_education_level` (`education_level`),
  ADD KEY `idx_institution_name` (`institution_name`),
  ADD KEY `idx_major_field` (`major_field`),
  ADD KEY `idx_start_date` (`start_date`),
  ADD KEY `idx_end_date` (`end_date`),
  ADD KEY `idx_is_completed` (`is_completed`),
  ADD KEY `idx_is_current` (`is_current`);

--
-- Indeks untuk tabel `emergency_contacts`
--
ALTER TABLE `emergency_contacts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_person` (`person_id`),
  ADD KEY `idx_phone` (`phone`),
  ADD KEY `idx_primary` (`is_primary`);

--
-- Indeks untuk tabel `employment_records`
--
ALTER TABLE `employment_records`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_person` (`person_id`),
  ADD KEY `idx_company_name` (`company_name`),
  ADD KEY `idx_position` (`position`),
  ADD KEY `idx_employment_type` (`employment_type`),
  ADD KEY `idx_start_date` (`start_date`),
  ADD KEY `idx_end_date` (`end_date`),
  ADD KEY `idx_is_current` (`is_current`),
  ADD KEY `idx_salary` (`salary`);

--
-- Indeks untuk tabel `family_links`
--
ALTER TABLE `family_links`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_relationship` (`person1_id`,`person2_id`,`relationship`),
  ADD KEY `idx_person1` (`person1_id`),
  ADD KEY `idx_person2` (`person2_id`),
  ADD KEY `idx_relationship` (`relationship`),
  ADD KEY `idx_verification_status` (`verification_status`);

--
-- Indeks untuk tabel `family_relationships`
--
ALTER TABLE `family_relationships`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_relationship` (`person1_id`,`person2_id`,`relationship_type`),
  ADD KEY `idx_person1` (`person1_id`),
  ADD KEY `idx_person2` (`person2_id`),
  ADD KEY `idx_relationship_type` (`relationship_type`),
  ADD KEY `idx_relationship_level` (`relationship_level`),
  ADD KEY `idx_is_primary` (`is_primary`),
  ADD KEY `idx_is_legal_guardian` (`is_legal_guardian`),
  ADD KEY `idx_is_emergency_contact` (`is_emergency_contact`),
  ADD KEY `idx_verification_status` (`verification_status`);

--
-- Indeks untuk tabel `health_records`
--
ALTER TABLE `health_records`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_person` (`person_id`),
  ADD KEY `idx_record_type` (`record_type`),
  ADD KEY `idx_provider_name` (`provider_name`),
  ADD KEY `idx_doctor_name` (`doctor_name`),
  ADD KEY `idx_visit_date` (`visit_date`),
  ADD KEY `idx_diagnosis` (`diagnosis`(100)),
  ADD KEY `idx_follow_up_date` (`follow_up_date`),
  ADD KEY `idx_is_confidential` (`is_confidential`);

--
-- Indeks untuk tabel `persons`
--
ALTER TABLE `persons`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nik` (`nik`),
  ADD UNIQUE KEY `uk_phone` (`phone`),
  ADD UNIQUE KEY `uk_phone2` (`phone2`),
  ADD UNIQUE KEY `uk_whatsapp` (`whatsapp`),
  ADD UNIQUE KEY `uk_email` (`email`),
  ADD UNIQUE KEY `uk_email2` (`email2`),
  ADD UNIQUE KEY `uk_npwp` (`npwp`),
  ADD UNIQUE KEY `uk_bpjs_kesehatan` (`bpjs_kesehatan`),
  ADD UNIQUE KEY `uk_bpjs_ketenagakerjaan` (`bpjs_ketenagakerjaan`),
  ADD UNIQUE KEY `uk_passport_number` (`passport_number`),
  ADD UNIQUE KEY `uk_sim_number` (`sim_number`),
  ADD KEY `idx_nik` (`nik`),
  ADD KEY `idx_name` (`name`),
  ADD KEY `idx_name_alias` (`name_alias`),
  ADD KEY `idx_phone` (`phone`),
  ADD KEY `idx_phone2` (`phone2`),
  ADD KEY `idx_whatsapp` (`whatsapp`),
  ADD KEY `idx_email` (`email`),
  ADD KEY `idx_email2` (`email2`),
  ADD KEY `idx_kk_number` (`kk_number`),
  ADD KEY `idx_spouse_nik` (`spouse_nik`),
  ADD KEY `idx_father_nik` (`father_nik`),
  ADD KEY `idx_mother_nik` (`mother_nik`),
  ADD KEY `idx_npwp` (`npwp`),
  ADD KEY `idx_bpjs_kesehatan` (`bpjs_kesehatan`),
  ADD KEY `idx_bpjs_ketenagakerjaan` (`bpjs_ketenagakerjaan`),
  ADD KEY `idx_passport_number` (`passport_number`),
  ADD KEY `idx_sim_number` (`sim_number`),
  ADD KEY `idx_marital_status` (`marital_status`),
  ADD KEY `idx_occupation` (`occupation`),
  ADD KEY `idx_business_type` (`business_type`),
  ADD KEY `idx_education_level` (`education_level`),
  ADD KEY `idx_credit_score` (`credit_score`),
  ADD KEY `idx_risk_level` (`risk_level`),
  ADD KEY `idx_verification_status` (`verification_status`),
  ADD KEY `idx_is_active` (`is_active`),
  ADD KEY `idx_is_blacklisted` (`is_blacklisted`),
  ADD KEY `idx_is_watchlist` (`is_watchlist`),
  ADD KEY `idx_created_at` (`created_at`),
  ADD KEY `idx_updated_at` (`updated_at`),
  ADD KEY `idx_birth_date` (`birth_date`),
  ADD KEY `idx_death_date` (`death_date`),
  ADD KEY `idx_last_login` (`last_login`);

--
-- Indeks untuk tabel `preferences`
--
ALTER TABLE `preferences`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_preference` (`person_id`,`preference_category`,`preference_key`),
  ADD KEY `idx_person` (`person_id`),
  ADD KEY `idx_category` (`preference_category`),
  ADD KEY `idx_key` (`preference_key`),
  ADD KEY `idx_is_system` (`is_system`),
  ADD KEY `idx_is_public` (`is_public`);

--
-- Indeks untuk tabel `risk_assessment_history`
--
ALTER TABLE `risk_assessment_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_person` (`person_id`),
  ADD KEY `idx_assessment_date` (`assessment_date`),
  ADD KEY `idx_credit_score` (`credit_score`),
  ADD KEY `idx_risk_level` (`risk_level`),
  ADD KEY `idx_assessed_by` (`assessed_by`);

--
-- Indeks untuk tabel `verification_history`
--
ALTER TABLE `verification_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_person` (`person_id`),
  ADD KEY `idx_verification_type` (`verification_type`),
  ADD KEY `idx_verification_status` (`verification_status`),
  ADD KEY `idx_verification_date` (`verification_date`),
  ADD KEY `idx_verified_by` (`verified_by`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `audit_logs`
--
ALTER TABLE `audit_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT untuk tabel `bank_accounts`
--
ALTER TABLE `bank_accounts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT untuk tabel `business_information`
--
ALTER TABLE `business_information`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `business_records`
--
ALTER TABLE `business_records`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `contacts`
--
ALTER TABLE `contacts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT untuk tabel `digital_identities`
--
ALTER TABLE `digital_identities`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `documents`
--
ALTER TABLE `documents`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT untuk tabel `document_uploads`
--
ALTER TABLE `document_uploads`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT untuk tabel `education_background`
--
ALTER TABLE `education_background`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `education_records`
--
ALTER TABLE `education_records`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT untuk tabel `emergency_contacts`
--
ALTER TABLE `emergency_contacts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `employment_records`
--
ALTER TABLE `employment_records`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `family_links`
--
ALTER TABLE `family_links`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT untuk tabel `family_relationships`
--
ALTER TABLE `family_relationships`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `health_records`
--
ALTER TABLE `health_records`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `persons`
--
ALTER TABLE `persons`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `preferences`
--
ALTER TABLE `preferences`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT untuk tabel `risk_assessment_history`
--
ALTER TABLE `risk_assessment_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `verification_history`
--
ALTER TABLE `verification_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `bank_accounts`
--
ALTER TABLE `bank_accounts`
  ADD CONSTRAINT `bank_accounts_ibfk_1` FOREIGN KEY (`person_id`) REFERENCES `persons` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `business_information`
--
ALTER TABLE `business_information`
  ADD CONSTRAINT `business_information_ibfk_1` FOREIGN KEY (`person_id`) REFERENCES `persons` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `business_records`
--
ALTER TABLE `business_records`
  ADD CONSTRAINT `business_records_ibfk_1` FOREIGN KEY (`person_id`) REFERENCES `persons` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `contacts`
--
ALTER TABLE `contacts`
  ADD CONSTRAINT `contacts_ibfk_1` FOREIGN KEY (`person_id`) REFERENCES `persons` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `digital_identities`
--
ALTER TABLE `digital_identities`
  ADD CONSTRAINT `digital_identities_ibfk_1` FOREIGN KEY (`person_id`) REFERENCES `persons` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `documents`
--
ALTER TABLE `documents`
  ADD CONSTRAINT `documents_ibfk_1` FOREIGN KEY (`person_id`) REFERENCES `persons` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `document_uploads`
--
ALTER TABLE `document_uploads`
  ADD CONSTRAINT `document_uploads_ibfk_1` FOREIGN KEY (`person_id`) REFERENCES `persons` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `education_background`
--
ALTER TABLE `education_background`
  ADD CONSTRAINT `education_background_ibfk_1` FOREIGN KEY (`person_id`) REFERENCES `persons` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `education_records`
--
ALTER TABLE `education_records`
  ADD CONSTRAINT `education_records_ibfk_1` FOREIGN KEY (`person_id`) REFERENCES `persons` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `emergency_contacts`
--
ALTER TABLE `emergency_contacts`
  ADD CONSTRAINT `emergency_contacts_ibfk_1` FOREIGN KEY (`person_id`) REFERENCES `persons` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `employment_records`
--
ALTER TABLE `employment_records`
  ADD CONSTRAINT `employment_records_ibfk_1` FOREIGN KEY (`person_id`) REFERENCES `persons` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `family_links`
--
ALTER TABLE `family_links`
  ADD CONSTRAINT `family_links_ibfk_1` FOREIGN KEY (`person1_id`) REFERENCES `persons` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `family_links_ibfk_2` FOREIGN KEY (`person2_id`) REFERENCES `persons` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `family_relationships`
--
ALTER TABLE `family_relationships`
  ADD CONSTRAINT `family_relationships_ibfk_1` FOREIGN KEY (`person1_id`) REFERENCES `persons` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `family_relationships_ibfk_2` FOREIGN KEY (`person2_id`) REFERENCES `persons` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `health_records`
--
ALTER TABLE `health_records`
  ADD CONSTRAINT `health_records_ibfk_1` FOREIGN KEY (`person_id`) REFERENCES `persons` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `preferences`
--
ALTER TABLE `preferences`
  ADD CONSTRAINT `preferences_ibfk_1` FOREIGN KEY (`person_id`) REFERENCES `persons` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `risk_assessment_history`
--
ALTER TABLE `risk_assessment_history`
  ADD CONSTRAINT `risk_assessment_history_ibfk_1` FOREIGN KEY (`person_id`) REFERENCES `persons` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `verification_history`
--
ALTER TABLE `verification_history`
  ADD CONSTRAINT `verification_history_ibfk_1` FOREIGN KEY (`person_id`) REFERENCES `persons` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
