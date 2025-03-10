-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Waktu pembuatan: 27 Jan 2025 pada 16.36
-- Versi server: 9.1.0
-- Versi PHP: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `mtsd1779_utama`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `academic_years`
--

DROP TABLE IF EXISTS `academic_years`;
CREATE TABLE IF NOT EXISTS `academic_years` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `academic_year` varchar(9) NOT NULL COMMENT 'Tahun Pelajaran',
  `semester` enum('odd','even') NOT NULL DEFAULT 'odd' COMMENT 'odd = Ganjil, even = Genap',
  `current_semester` enum('true','false') NOT NULL DEFAULT 'false',
  `admission_semester` enum('true','false') NOT NULL DEFAULT 'false',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  `restored_at` datetime DEFAULT NULL,
  `created_by` bigint DEFAULT '0',
  `updated_by` bigint DEFAULT '0',
  `deleted_by` bigint DEFAULT '0',
  `restored_by` bigint DEFAULT '0',
  `is_deleted` enum('true','false') DEFAULT 'false',
  PRIMARY KEY (`id`),
  UNIQUE KEY `academic_year` (`academic_year`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;

--
-- Dumping data untuk tabel `academic_years`
--

INSERT INTO `academic_years` (`id`, `academic_year`, `semester`, `current_semester`, `admission_semester`, `created_at`, `updated_at`, `deleted_at`, `restored_at`, `created_by`, `updated_by`, `deleted_by`, `restored_by`, `is_deleted`) VALUES
(1, '2024-2025', 'odd', 'true', 'false', '2023-01-29 03:50:23', '2024-12-24 10:05:52', '2024-12-24 17:05:32', '2024-12-24 17:05:40', 0, 1, 1, 1, 'false'),
(2, '2025-2026', 'odd', 'false', 'true', '2023-01-29 03:50:23', '2024-12-25 10:12:28', '2024-12-24 17:06:42', '2024-12-25 17:12:28', 0, 1, 1, 1, 'false');

-- --------------------------------------------------------

--
-- Struktur dari tabel `achievements`
--

DROP TABLE IF EXISTS `achievements`;
CREATE TABLE IF NOT EXISTS `achievements` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `student_id` bigint DEFAULT '0',
  `achievement_description` varchar(255) NOT NULL,
  `achievement_type` bigint DEFAULT '0',
  `achievement_level` smallint NOT NULL DEFAULT '0',
  `achievement_year` year NOT NULL,
  `achievement_organizer` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  `restored_at` datetime DEFAULT NULL,
  `created_by` bigint DEFAULT '0',
  `updated_by` bigint DEFAULT '0',
  `deleted_by` bigint DEFAULT '0',
  `restored_by` bigint DEFAULT '0',
  `is_deleted` enum('true','false') DEFAULT 'false',
  PRIMARY KEY (`id`),
  KEY `achievements_student_id__idx` (`student_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Struktur dari tabel `admission_exam_attendances`
--

DROP TABLE IF EXISTS `admission_exam_attendances`;
CREATE TABLE IF NOT EXISTS `admission_exam_attendances` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `exam_schedule_id` bigint DEFAULT '0' COMMENT 'FK dari table admission_exam_schedules',
  `student_id` bigint DEFAULT '0' COMMENT 'FK Dari table students',
  `presence` enum('H','S','I','A') DEFAULT 'H',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  `restored_at` datetime DEFAULT NULL,
  `created_by` bigint DEFAULT '0',
  `updated_by` bigint DEFAULT '0',
  `deleted_by` bigint DEFAULT '0',
  `restored_by` bigint DEFAULT '0',
  `is_deleted` enum('true','false') DEFAULT 'false',
  PRIMARY KEY (`id`),
  UNIQUE KEY `__unique_key` (`exam_schedule_id`,`student_id`),
  KEY `admission_exam_attendances_exam_schedule_id__idx` (`exam_schedule_id`) USING BTREE,
  KEY `admission_exam_attendances_exam_student_id__idx` (`student_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Struktur dari tabel `admission_exam_schedules`
--

DROP TABLE IF EXISTS `admission_exam_schedules`;
CREATE TABLE IF NOT EXISTS `admission_exam_schedules` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `subject_setting_detail_id` bigint DEFAULT '0' COMMENT 'FK dari table admission_subject_setting_details',
  `room_id` bigint DEFAULT '0' COMMENT 'Ruangan',
  `exam_date` date DEFAULT NULL COMMENT 'Tanggal Pelaksanaan Ujian Saringan Masuk',
  `exam_start_time` time NOT NULL COMMENT 'Jam Mulai',
  `exam_end_time` time NOT NULL COMMENT 'Jam selesai',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  `restored_at` datetime DEFAULT NULL,
  `created_by` bigint DEFAULT '0',
  `updated_by` bigint DEFAULT '0',
  `deleted_by` bigint DEFAULT '0',
  `restored_by` bigint DEFAULT '0',
  `is_deleted` enum('true','false') DEFAULT 'false',
  PRIMARY KEY (`id`),
  UNIQUE KEY `__unique_key` (`subject_setting_detail_id`,`room_id`,`exam_date`),
  KEY `admission_exam_schedules_subject_setting_detail_id__idx` (`subject_setting_detail_id`) USING BTREE,
  KEY `admission_exam_schedules_room_id__idx` (`room_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Struktur dari tabel `admission_phases`
--

DROP TABLE IF EXISTS `admission_phases`;
CREATE TABLE IF NOT EXISTS `admission_phases` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `academic_year_id` bigint DEFAULT '0' COMMENT 'Tahun Pelajaran',
  `phase_name` varchar(255) NOT NULL COMMENT 'Gelombang Pendaftaran',
  `phase_start_date` date DEFAULT NULL COMMENT 'Tanggal Mulai',
  `phase_end_date` date DEFAULT NULL COMMENT 'Tanggal Selesai',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  `restored_at` datetime DEFAULT NULL,
  `created_by` bigint DEFAULT '0',
  `updated_by` bigint DEFAULT '0',
  `deleted_by` bigint DEFAULT '0',
  `restored_by` bigint DEFAULT '0',
  `is_deleted` enum('true','false') DEFAULT 'false',
  PRIMARY KEY (`id`),
  UNIQUE KEY `__unique_key` (`academic_year_id`,`phase_name`),
  KEY `admission_phases_academic_year_id__idx` (`academic_year_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;

--
-- Dumping data untuk tabel `admission_phases`
--

INSERT INTO `admission_phases` (`id`, `academic_year_id`, `phase_name`, `phase_start_date`, `phase_end_date`, `created_at`, `updated_at`, `deleted_at`, `restored_at`, `created_by`, `updated_by`, `deleted_by`, `restored_by`, `is_deleted`) VALUES
(1, 2, 'Gelombang I', '2025-01-01', '2025-04-30', '2023-01-29 03:50:23', '2024-12-25 10:12:43', NULL, NULL, 0, 1, 0, 0, 'false'),
(2, 2, 'Gelombang II', '2025-05-01', '2025-05-31', '2023-01-29 03:50:23', '2024-12-25 10:12:47', NULL, NULL, 0, 1, 0, 0, 'false'),
(3, 2, 'Gelombang III', '2025-06-01', '2025-07-12', '2023-01-29 03:50:23', '2024-12-25 10:12:51', NULL, NULL, 0, 1, 0, 0, 'false');

-- --------------------------------------------------------

--
-- Struktur dari tabel `admission_quotas`
--

DROP TABLE IF EXISTS `admission_quotas`;
CREATE TABLE IF NOT EXISTS `admission_quotas` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `academic_year_id` bigint DEFAULT '0' COMMENT 'Tahun Pelajaran',
  `admission_type_id` bigint DEFAULT '0' COMMENT 'Jenis Pendaftaran',
  `major_id` bigint DEFAULT '0' COMMENT 'Program Keahlian',
  `quota` smallint NOT NULL DEFAULT '0' COMMENT 'Kuota Penerimaan',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  `restored_at` datetime DEFAULT NULL,
  `created_by` bigint DEFAULT '0',
  `updated_by` bigint DEFAULT '0',
  `deleted_by` bigint DEFAULT '0',
  `restored_by` bigint DEFAULT '0',
  `is_deleted` enum('true','false') DEFAULT 'false',
  PRIMARY KEY (`id`),
  UNIQUE KEY `__unique_key` (`academic_year_id`,`admission_type_id`,`major_id`),
  KEY `admission_quotas_academic_year_id__idx` (`academic_year_id`) USING BTREE,
  KEY `admission_quotas_admission_type_id__idx` (`admission_type_id`) USING BTREE,
  KEY `admission_quotas_major_id__idx` (`major_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;

--
-- Dumping data untuk tabel `admission_quotas`
--

INSERT INTO `admission_quotas` (`id`, `academic_year_id`, `admission_type_id`, `major_id`, `quota`, `created_at`, `updated_at`, `deleted_at`, `restored_at`, `created_by`, `updated_by`, `deleted_by`, `restored_by`, `is_deleted`) VALUES
(1, 2, 174, 0, 100, '2024-12-25 10:13:13', NULL, NULL, NULL, 1, 0, 0, 0, 'false');

-- --------------------------------------------------------

--
-- Struktur dari tabel `admission_subject_scores`
--

DROP TABLE IF EXISTS `admission_subject_scores`;
CREATE TABLE IF NOT EXISTS `admission_subject_scores` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `subject_setting_detail_id` bigint DEFAULT '0',
  `student_id` bigint DEFAULT '0',
  `score` decimal(5,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  `restored_at` datetime DEFAULT NULL,
  `created_by` bigint DEFAULT '0',
  `updated_by` bigint DEFAULT '0',
  `deleted_by` bigint DEFAULT '0',
  `restored_by` bigint DEFAULT '0',
  `is_deleted` enum('true','false') DEFAULT 'false',
  PRIMARY KEY (`id`),
  UNIQUE KEY `__unique_key` (`subject_setting_detail_id`,`student_id`),
  KEY `admission_subject_scores_subject_setting_detail_id__idx` (`subject_setting_detail_id`) USING BTREE,
  KEY `admission_subject_scores_student_id__idx` (`student_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Struktur dari tabel `admission_subject_settings`
--

DROP TABLE IF EXISTS `admission_subject_settings`;
CREATE TABLE IF NOT EXISTS `admission_subject_settings` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `academic_year_id` bigint DEFAULT '0',
  `admission_type_id` bigint DEFAULT '0',
  `major_id` bigint DEFAULT '0' COMMENT 'Program Keahlian',
  `subject_type` enum('exam_schedule','semester_report','national_exam') DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  `restored_at` datetime DEFAULT NULL,
  `created_by` bigint DEFAULT '0',
  `updated_by` bigint DEFAULT '0',
  `deleted_by` bigint DEFAULT '0',
  `restored_by` bigint DEFAULT '0',
  `is_deleted` enum('true','false') DEFAULT 'false',
  PRIMARY KEY (`id`),
  UNIQUE KEY `__unique_key` (`academic_year_id`,`admission_type_id`,`major_id`,`subject_type`),
  KEY `admission_subject_settings_academic_year_id__idx` (`academic_year_id`) USING BTREE,
  KEY `admission_subject_settings_admission_type_id__idx` (`admission_type_id`) USING BTREE,
  KEY `admission_subject_settings_major_id__idx` (`major_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;

--
-- Dumping data untuk tabel `admission_subject_settings`
--

INSERT INTO `admission_subject_settings` (`id`, `academic_year_id`, `admission_type_id`, `major_id`, `subject_type`, `created_at`, `updated_at`, `deleted_at`, `restored_at`, `created_by`, `updated_by`, `deleted_by`, `restored_by`, `is_deleted`) VALUES
(1, 2, 174, 0, 'semester_report', '2024-12-24 11:00:53', '2024-12-25 10:13:49', '2024-12-25 17:13:49', NULL, 1, 1, 1, 0, 'true');

-- --------------------------------------------------------

--
-- Struktur dari tabel `admission_subject_setting_details`
--

DROP TABLE IF EXISTS `admission_subject_setting_details`;
CREATE TABLE IF NOT EXISTS `admission_subject_setting_details` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `subject_setting_id` bigint DEFAULT '0',
  `subject_id` bigint DEFAULT '0',
  `visibility` enum('public','private') DEFAULT NULL COMMENT 'Tampil di Form PPDB ? public = tampil, private = hanya dari administrator',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  `restored_at` datetime DEFAULT NULL,
  `created_by` bigint DEFAULT '0',
  `updated_by` bigint DEFAULT '0',
  `deleted_by` bigint DEFAULT '0',
  `restored_by` bigint DEFAULT '0',
  `is_deleted` enum('true','false') DEFAULT 'false',
  PRIMARY KEY (`id`),
  UNIQUE KEY `__unique_key` (`subject_setting_id`,`subject_id`),
  KEY `admission_subject_setting_details_subject_setting_id__idx` (`subject_setting_id`) USING BTREE,
  KEY `admission_subject_setting_details_subject_id__idx` (`subject_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Struktur dari tabel `albums`
--

DROP TABLE IF EXISTS `albums`;
CREATE TABLE IF NOT EXISTS `albums` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `album_title` varchar(255) NOT NULL,
  `album_description` varchar(255) DEFAULT NULL,
  `album_slug` varchar(255) DEFAULT NULL,
  `album_cover` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  `restored_at` datetime DEFAULT NULL,
  `created_by` bigint DEFAULT '0',
  `updated_by` bigint DEFAULT '0',
  `deleted_by` bigint DEFAULT '0',
  `restored_by` bigint DEFAULT '0',
  `is_deleted` enum('true','false') DEFAULT 'false',
  PRIMARY KEY (`id`),
  UNIQUE KEY `album_title` (`album_title`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3;

--
-- Dumping data untuk tabel `albums`
--

INSERT INTO `albums` (`id`, `album_title`, `album_description`, `album_slug`, `album_cover`, `created_at`, `updated_at`, `deleted_at`, `restored_at`, `created_by`, `updated_by`, `deleted_by`, `restored_by`, `is_deleted`) VALUES
(1, 'Pramuka', '', 'pramuka', '62fe0049adacfc0724a7696cb30d3ebb.jpg', '2024-12-26 09:11:30', '2024-12-26 09:11:51', NULL, NULL, 1, 1, 0, 0, 'false'),
(2, 'Pentas Seni', '', 'pentas-seni', '1061a9b17ef4252d571b9a28446d9aac.jpg', '2024-12-26 09:12:07', '2024-12-26 09:13:06', NULL, NULL, 1, 1, 0, 0, 'false'),
(3, 'ANBK', '', 'anbk', 'f9ca09eacaf4f46f7eb50d4cba9edf36.jpg', '2024-12-26 09:12:19', '2024-12-26 09:15:14', NULL, NULL, 1, 1, 0, 0, 'false'),
(4, 'Sholat Dhuha', '', 'sholat-dhuha', '2ba0e28cfa1eec9eac7a5b907cd29f88.jpg', '2024-12-26 09:12:27', '2024-12-26 09:13:36', NULL, NULL, 1, 1, 0, 0, 'false'),
(5, 'Paskibra', '', 'paskibra', '5acfe881111a7bea9149c518f99eaa85.jpg', '2024-12-26 09:12:44', '2024-12-26 09:13:45', NULL, NULL, 1, 1, 0, 0, 'false'),
(6, 'Futsal', '', 'futsal', '845a1702c2e756534fa95d58f89df5f3.jpg', '2024-12-26 09:12:52', '2024-12-26 09:13:55', NULL, NULL, 1, 1, 0, 0, 'false'),
(7, 'Tarung Drajat', '', 'tarung-drajat', '96e35713795db6a7a68e2e42a125995c.jpg', '2024-12-27 00:14:49', '2024-12-27 00:15:38', NULL, NULL, 1, 1, 0, 0, 'false');

-- --------------------------------------------------------

--
-- Struktur dari tabel `answers`
--

DROP TABLE IF EXISTS `answers`;
CREATE TABLE IF NOT EXISTS `answers` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `question_id` bigint DEFAULT '0',
  `answer` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  `restored_at` datetime DEFAULT NULL,
  `created_by` bigint DEFAULT '0',
  `updated_by` bigint DEFAULT '0',
  `deleted_by` bigint DEFAULT '0',
  `restored_by` bigint DEFAULT '0',
  `is_deleted` enum('true','false') DEFAULT 'false',
  PRIMARY KEY (`id`),
  UNIQUE KEY `__unique_key` (`question_id`,`answer`),
  KEY `answers_question_id__idx` (`question_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Struktur dari tabel `categories`
--

DROP TABLE IF EXISTS `categories`;
CREATE TABLE IF NOT EXISTS `categories` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `category_name` varchar(255) NOT NULL,
  `category_slug` varchar(255) DEFAULT NULL,
  `category_description` varchar(255) DEFAULT NULL,
  `category_type` enum('post','file') DEFAULT 'post',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  `restored_at` datetime DEFAULT NULL,
  `created_by` bigint DEFAULT '0',
  `updated_by` bigint DEFAULT '0',
  `deleted_by` bigint DEFAULT '0',
  `restored_by` bigint DEFAULT '0',
  `is_deleted` enum('true','false') DEFAULT 'false',
  PRIMARY KEY (`id`),
  UNIQUE KEY `__unique_key` (`category_name`,`category_type`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;

--
-- Dumping data untuk tabel `categories`
--

INSERT INTO `categories` (`id`, `category_name`, `category_slug`, `category_description`, `category_type`, `created_at`, `updated_at`, `deleted_at`, `restored_at`, `created_by`, `updated_by`, `deleted_by`, `restored_by`, `is_deleted`) VALUES
(1, 'Berita', 'berita', 'Berita', 'post', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(2, 'Berkas', 'berkas', 'Berkas', 'file', '2023-01-29 03:50:24', '2024-12-24 11:19:09', NULL, NULL, 0, 1, 0, 0, 'false');

-- --------------------------------------------------------

--
-- Struktur dari tabel `class_groups`
--

DROP TABLE IF EXISTS `class_groups`;
CREATE TABLE IF NOT EXISTS `class_groups` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `class_group` varchar(100) DEFAULT NULL,
  `sub_class_group` varchar(100) DEFAULT NULL,
  `major_id` bigint DEFAULT '0' COMMENT 'Program Keahlian',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  `restored_at` datetime DEFAULT NULL,
  `created_by` bigint DEFAULT '0',
  `updated_by` bigint DEFAULT '0',
  `deleted_by` bigint DEFAULT '0',
  `restored_by` bigint DEFAULT '0',
  `is_deleted` enum('true','false') DEFAULT 'false',
  PRIMARY KEY (`id`),
  UNIQUE KEY `__unique_key` (`class_group`,`sub_class_group`,`major_id`),
  KEY `class_groups_major_id__idx` (`major_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb3;

--
-- Dumping data untuk tabel `class_groups`
--

INSERT INTO `class_groups` (`id`, `class_group`, `sub_class_group`, `major_id`, `created_at`, `updated_at`, `deleted_at`, `restored_at`, `created_by`, `updated_by`, `deleted_by`, `restored_by`, `is_deleted`) VALUES
(1, 'VII', 'Abu Nasr Mansur', 0, '2023-01-29 03:50:23', '2024-12-24 10:14:26', NULL, NULL, 0, 1, 0, 0, 'false'),
(2, 'VII', 'Jabbir Al Battani', 0, '2023-01-29 03:50:23', '2024-12-24 10:15:03', NULL, NULL, 0, 1, 0, 0, 'false'),
(3, 'VII', 'Abbas bin Firnas', 0, '2023-01-29 03:50:23', '2024-12-24 10:15:20', NULL, NULL, 0, 1, 0, 0, 'false'),
(4, 'VIII', 'Ibnu Al Nafis', 0, '2024-12-24 10:15:45', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(5, 'VIII', 'Ibnu Batutah', 0, '2024-12-24 10:16:04', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(6, 'VIII', 'Ibnu Khaldun', 0, '2024-12-24 10:16:18', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(7, 'IX', 'Al Idrisi', 0, '2024-12-24 10:16:30', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(8, 'IX', 'Al Jazari', 0, '2024-12-24 10:16:43', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(9, 'IX', 'Al Wafa', 0, '2024-12-24 10:16:54', NULL, NULL, NULL, 1, 0, 0, 0, 'false');

-- --------------------------------------------------------

--
-- Struktur dari tabel `class_group_settings`
--

DROP TABLE IF EXISTS `class_group_settings`;
CREATE TABLE IF NOT EXISTS `class_group_settings` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `academic_year_id` bigint DEFAULT '0' COMMENT 'FK dari academic_years',
  `class_group_id` bigint DEFAULT '0' COMMENT 'Kelas, FK dari class_groups',
  `employee_id` bigint DEFAULT '0' COMMENT 'Wali Kelas, FK dari employees',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  `restored_at` datetime DEFAULT NULL,
  `created_by` bigint DEFAULT '0',
  `updated_by` bigint DEFAULT '0',
  `deleted_by` bigint DEFAULT '0',
  `restored_by` bigint DEFAULT '0',
  `is_deleted` enum('true','false') DEFAULT 'false',
  PRIMARY KEY (`id`),
  UNIQUE KEY `__unique_key` (`academic_year_id`,`class_group_id`),
  KEY `class_group_settings_academic_year_id__idx` (`academic_year_id`) USING BTREE,
  KEY `class_group_settings_class_group_id__idx` (`class_group_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb3;

--
-- Dumping data untuk tabel `class_group_settings`
--

INSERT INTO `class_group_settings` (`id`, `academic_year_id`, `class_group_id`, `employee_id`, `created_at`, `updated_at`, `deleted_at`, `restored_at`, `created_by`, `updated_by`, `deleted_by`, `restored_by`, `is_deleted`) VALUES
(1, 1, 1, 15, '2024-12-24 10:17:47', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(2, 1, 2, 11, '2024-12-24 10:17:57', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(3, 1, 3, 2, '2024-12-24 10:18:04', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(4, 1, 4, 18, '2024-12-24 10:18:15', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(5, 1, 5, 24, '2024-12-24 10:18:24', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(6, 1, 6, 17, '2024-12-24 10:18:33', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(7, 1, 7, 6, '2024-12-24 10:18:40', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(8, 1, 8, 22, '2024-12-24 10:18:51', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(9, 1, 9, 14, '2024-12-24 10:18:59', NULL, NULL, NULL, 1, 0, 0, 0, 'false');

-- --------------------------------------------------------

--
-- Struktur dari tabel `class_group_students`
--

DROP TABLE IF EXISTS `class_group_students`;
CREATE TABLE IF NOT EXISTS `class_group_students` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `class_group_setting_id` bigint DEFAULT '0',
  `student_id` bigint DEFAULT '0',
  `is_class_manager` enum('true','false') NOT NULL DEFAULT 'false' COMMENT 'Ketua Kelas?',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  `restored_at` datetime DEFAULT NULL,
  `created_by` bigint DEFAULT '0',
  `updated_by` bigint DEFAULT '0',
  `deleted_by` bigint DEFAULT '0',
  `restored_by` bigint DEFAULT '0',
  `is_deleted` enum('true','false') DEFAULT 'false',
  PRIMARY KEY (`id`),
  UNIQUE KEY `__unique_key` (`class_group_setting_id`,`student_id`),
  KEY `class_group_students_class_group_setting_id__idx` (`class_group_setting_id`) USING BTREE,
  KEY `class_group_students_student_id__idx` (`student_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb3;

--
-- Dumping data untuk tabel `class_group_students`
--

INSERT INTO `class_group_students` (`id`, `class_group_setting_id`, `student_id`, `is_class_manager`, `created_at`, `updated_at`, `deleted_at`, `restored_at`, `created_by`, `updated_by`, `deleted_by`, `restored_by`, `is_deleted`) VALUES
(1, 3, 26, 'true', '2024-12-24 10:41:49', '2024-12-24 14:05:24', NULL, NULL, 1, 1, 0, 0, 'false'),
(2, 3, 27, 'false', '2024-12-24 10:41:49', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(3, 3, 28, 'false', '2024-12-24 10:41:49', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(4, 3, 29, 'false', '2024-12-24 10:41:49', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(5, 3, 30, 'false', '2024-12-24 10:41:49', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(6, 3, 31, 'false', '2024-12-24 10:41:49', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(7, 3, 32, 'false', '2024-12-24 10:41:49', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(8, 3, 33, 'false', '2024-12-24 10:41:49', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(9, 3, 34, 'false', '2024-12-24 10:41:49', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(10, 3, 35, 'false', '2024-12-24 10:41:49', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(11, 3, 36, 'false', '2024-12-24 10:41:49', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(12, 3, 37, 'false', '2024-12-24 10:41:49', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(13, 3, 38, 'false', '2024-12-24 10:41:49', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(14, 3, 39, 'false', '2024-12-24 10:41:49', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(15, 3, 40, 'false', '2024-12-24 10:41:49', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(16, 3, 41, 'false', '2024-12-24 10:41:49', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(17, 3, 42, 'false', '2024-12-24 10:41:49', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(18, 3, 43, 'false', '2024-12-24 10:41:49', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(19, 3, 44, 'false', '2024-12-24 10:41:49', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(20, 3, 45, 'false', '2024-12-24 10:41:49', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(21, 3, 46, 'false', '2024-12-24 10:41:49', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(22, 3, 47, 'false', '2024-12-24 10:41:49', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(23, 3, 48, 'false', '2024-12-24 10:41:49', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(24, 3, 49, 'false', '2024-12-24 10:41:49', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(25, 3, 50, 'false', '2024-12-24 10:41:49', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(26, 3, 51, 'false', '2024-12-24 10:41:49', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(27, 3, 52, 'false', '2024-12-24 10:41:49', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(28, 3, 53, 'false', '2024-12-24 10:41:49', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(29, 3, 54, 'false', '2024-12-24 10:41:49', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(30, 3, 55, 'false', '2024-12-24 10:41:49', NULL, NULL, NULL, 1, 0, 0, 0, 'false');

-- --------------------------------------------------------

--
-- Struktur dari tabel `class_meetings`
--

DROP TABLE IF EXISTS `class_meetings`;
CREATE TABLE IF NOT EXISTS `class_meetings` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `course_class_id` bigint DEFAULT '0',
  `date` date NOT NULL,
  `start_time` time NOT NULL DEFAULT '00:00:00',
  `end_time` time NOT NULL DEFAULT '00:00:00',
  `discussion` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  `restored_at` datetime DEFAULT NULL,
  `created_by` bigint DEFAULT '0',
  `updated_by` bigint DEFAULT '0',
  `deleted_by` bigint DEFAULT '0',
  `restored_by` bigint DEFAULT '0',
  `is_deleted` enum('true','false') DEFAULT 'false',
  PRIMARY KEY (`id`),
  KEY `class_meetings_course_class_id__idx` (`course_class_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;

--
-- Dumping data untuk tabel `class_meetings`
--

INSERT INTO `class_meetings` (`id`, `course_class_id`, `date`, `start_time`, `end_time`, `discussion`, `created_at`, `updated_at`, `deleted_at`, `restored_at`, `created_by`, `updated_by`, `deleted_by`, `restored_by`, `is_deleted`) VALUES
(1, 13, '2025-01-07', '17:55:24', '17:55:24', NULL, '2024-12-24 10:55:24', NULL, NULL, NULL, 2, 0, 0, 0, 'false'),
(2, 58, '2025-01-05', '15:04:31', '15:04:31', NULL, '2025-01-10 08:04:31', NULL, NULL, NULL, 2, 0, 0, 0, 'false');

-- --------------------------------------------------------

--
-- Struktur dari tabel `comments`
--

DROP TABLE IF EXISTS `comments`;
CREATE TABLE IF NOT EXISTS `comments` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `comment_post_id` bigint DEFAULT '0',
  `comment_author` varchar(255) NOT NULL,
  `comment_email` varchar(255) DEFAULT NULL,
  `comment_url` varchar(255) DEFAULT NULL,
  `comment_ip_address` varchar(255) NOT NULL,
  `comment_content` text NOT NULL,
  `comment_subject` varchar(255) DEFAULT NULL,
  `comment_reply` text,
  `comment_status` enum('approved','unapproved','spam') DEFAULT 'approved',
  `comment_agent` varchar(255) DEFAULT NULL,
  `comment_parent_id` varchar(255) DEFAULT NULL,
  `comment_type` enum('post','message') DEFAULT 'post',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  `restored_at` datetime DEFAULT NULL,
  `created_by` bigint DEFAULT '0',
  `updated_by` bigint DEFAULT '0',
  `deleted_by` bigint DEFAULT '0',
  `restored_by` bigint DEFAULT '0',
  `is_deleted` enum('true','false') DEFAULT 'false',
  PRIMARY KEY (`id`),
  KEY `comments_comment_post_id__idx` (`comment_post_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Struktur dari tabel `course_classes`
--

DROP TABLE IF EXISTS `course_classes`;
CREATE TABLE IF NOT EXISTS `course_classes` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `academic_year_id` bigint DEFAULT '0',
  `semester` enum('odd','even') NOT NULL DEFAULT 'odd' COMMENT 'odd = Ganjil, even = Genap',
  `class_group_id` bigint DEFAULT '0',
  `subject_id` bigint DEFAULT '0',
  `employee_id` bigint DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  `restored_at` datetime DEFAULT NULL,
  `created_by` bigint DEFAULT '0',
  `updated_by` bigint DEFAULT '0',
  `deleted_by` bigint DEFAULT '0',
  `restored_by` bigint DEFAULT '0',
  `is_deleted` enum('true','false') DEFAULT 'false',
  PRIMARY KEY (`id`),
  UNIQUE KEY `__unique_key` (`academic_year_id`,`semester`,`class_group_id`,`subject_id`),
  KEY `course_classes_academic_year_id__idx` (`academic_year_id`) USING BTREE,
  KEY `course_classes_class_group_id__idx` (`class_group_id`) USING BTREE,
  KEY `course_classes_subject_id__idx` (`subject_id`) USING BTREE,
  KEY `course_classes_employee_id__idx` (`employee_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=172 DEFAULT CHARSET=utf8mb3;

--
-- Dumping data untuk tabel `course_classes`
--

INSERT INTO `course_classes` (`id`, `academic_year_id`, `semester`, `class_group_id`, `subject_id`, `employee_id`, `created_at`, `updated_at`, `deleted_at`, `restored_at`, `created_by`, `updated_by`, `deleted_by`, `restored_by`, `is_deleted`) VALUES
(1, 1, 'odd', 3, 1, 15, '2024-12-24 10:17:30', '2024-12-24 14:03:19', NULL, NULL, 1, 1, 0, 0, 'false'),
(2, 1, 'odd', 3, 2, 11, '2024-12-24 10:17:30', '2024-12-24 14:03:19', NULL, NULL, 1, 1, 0, 0, 'false'),
(3, 1, 'odd', 3, 3, 17, '2024-12-24 10:17:30', '2024-12-24 14:03:19', NULL, NULL, 1, 1, 0, 0, 'false'),
(4, 1, 'odd', 3, 4, 19, '2024-12-24 10:17:30', '2024-12-24 14:03:19', NULL, NULL, 1, 1, 0, 0, 'false'),
(5, 1, 'odd', 3, 5, 9, '2024-12-24 10:17:30', '2024-12-24 14:03:19', NULL, NULL, 1, 1, 0, 0, 'false'),
(6, 1, 'odd', 3, 6, 3, '2024-12-24 10:17:30', '2024-12-24 14:03:19', NULL, NULL, 1, 1, 0, 0, 'false'),
(7, 1, 'odd', 3, 7, 20, '2024-12-24 10:17:30', '2024-12-24 14:03:19', NULL, NULL, 1, 1, 0, 0, 'false'),
(8, 1, 'odd', 3, 8, 23, '2024-12-24 10:17:30', '2024-12-24 14:03:19', NULL, NULL, 1, 1, 0, 0, 'false'),
(9, 1, 'odd', 3, 9, 12, '2024-12-24 10:17:30', '2024-12-24 14:03:19', NULL, NULL, 1, 1, 0, 0, 'false'),
(10, 1, 'odd', 3, 10, 16, '2024-12-24 10:17:30', '2024-12-24 14:03:19', NULL, NULL, 1, 1, 0, 0, 'false'),
(11, 1, 'odd', 3, 11, 14, '2024-12-24 10:17:30', '2024-12-24 14:03:19', NULL, NULL, 1, 1, 0, 0, 'false'),
(12, 1, 'odd', 3, 12, 18, '2024-12-24 10:17:30', '2024-12-24 14:03:19', NULL, NULL, 1, 1, 0, 0, 'false'),
(13, 1, 'odd', 3, 13, 2, '2024-12-24 10:17:30', '2024-12-24 10:21:00', NULL, NULL, 1, 1, 0, 0, 'false'),
(14, 1, 'odd', 3, 14, 21, '2024-12-24 10:17:30', '2024-12-24 14:03:19', NULL, NULL, 1, 1, 0, 0, 'false'),
(15, 1, 'odd', 3, 15, 3, '2024-12-24 10:17:30', '2024-12-24 14:03:19', NULL, NULL, 1, 1, 0, 0, 'false'),
(16, 1, 'odd', 1, 1, 0, '2024-12-24 10:19:34', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(17, 1, 'odd', 1, 2, 0, '2024-12-24 10:19:34', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(18, 1, 'odd', 1, 3, 0, '2024-12-24 10:19:34', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(19, 1, 'odd', 1, 4, 0, '2024-12-24 10:19:34', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(20, 1, 'odd', 1, 5, 0, '2024-12-24 10:19:34', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(21, 1, 'odd', 1, 6, 0, '2024-12-24 10:19:34', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(22, 1, 'odd', 1, 7, 0, '2024-12-24 10:19:34', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(23, 1, 'odd', 1, 8, 0, '2024-12-24 10:19:34', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(24, 1, 'odd', 1, 9, 0, '2024-12-24 10:19:34', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(25, 1, 'odd', 1, 10, 0, '2024-12-24 10:19:34', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(26, 1, 'odd', 1, 11, 0, '2024-12-24 10:19:34', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(27, 1, 'odd', 1, 12, 0, '2024-12-24 10:19:34', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(28, 1, 'odd', 1, 13, 0, '2024-12-24 10:19:34', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(29, 1, 'odd', 1, 14, 0, '2024-12-24 10:19:34', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(30, 1, 'odd', 1, 15, 0, '2024-12-24 10:19:34', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(31, 1, 'odd', 2, 1, 0, '2024-12-24 10:19:44', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(32, 1, 'odd', 2, 2, 0, '2024-12-24 10:19:44', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(33, 1, 'odd', 2, 3, 0, '2024-12-24 10:19:44', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(34, 1, 'odd', 2, 4, 0, '2024-12-24 10:19:44', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(35, 1, 'odd', 2, 5, 0, '2024-12-24 10:19:44', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(36, 1, 'odd', 2, 6, 0, '2024-12-24 10:19:44', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(37, 1, 'odd', 2, 7, 0, '2024-12-24 10:19:44', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(38, 1, 'odd', 2, 8, 0, '2024-12-24 10:19:44', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(39, 1, 'odd', 2, 9, 0, '2024-12-24 10:19:44', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(40, 1, 'odd', 2, 10, 0, '2024-12-24 10:19:44', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(41, 1, 'odd', 2, 11, 0, '2024-12-24 10:19:44', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(42, 1, 'odd', 2, 12, 0, '2024-12-24 10:19:44', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(43, 1, 'odd', 2, 13, 0, '2024-12-24 10:19:44', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(44, 1, 'odd', 2, 14, 0, '2024-12-24 10:19:44', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(45, 1, 'odd', 2, 15, 0, '2024-12-24 10:19:44', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(46, 1, 'odd', 7, 1, 0, '2024-12-24 10:19:57', '2025-01-10 07:52:03', NULL, NULL, 1, 1, 0, 0, 'false'),
(47, 1, 'odd', 7, 2, 0, '2024-12-24 10:19:57', '2025-01-10 07:52:03', NULL, NULL, 1, 1, 0, 0, 'false'),
(48, 1, 'odd', 7, 3, 0, '2024-12-24 10:19:57', '2025-01-10 07:52:03', NULL, NULL, 1, 1, 0, 0, 'false'),
(49, 1, 'odd', 7, 4, 0, '2024-12-24 10:19:57', '2025-01-10 07:52:03', NULL, NULL, 1, 1, 0, 0, 'false'),
(50, 1, 'odd', 7, 5, 0, '2024-12-24 10:19:57', '2025-01-10 07:52:03', NULL, NULL, 1, 1, 0, 0, 'false'),
(51, 1, 'odd', 7, 6, 0, '2024-12-24 10:19:57', '2025-01-10 07:52:03', NULL, NULL, 1, 1, 0, 0, 'false'),
(52, 1, 'odd', 7, 7, 0, '2024-12-24 10:19:57', '2025-01-10 07:52:03', NULL, NULL, 1, 1, 0, 0, 'false'),
(53, 1, 'odd', 7, 8, 0, '2024-12-24 10:19:57', '2025-01-10 07:52:03', NULL, NULL, 1, 1, 0, 0, 'false'),
(54, 1, 'odd', 7, 9, 0, '2024-12-24 10:19:57', '2025-01-10 07:52:03', NULL, NULL, 1, 1, 0, 0, 'false'),
(55, 1, 'odd', 7, 10, 0, '2024-12-24 10:19:57', '2025-01-10 07:52:03', NULL, NULL, 1, 1, 0, 0, 'false'),
(56, 1, 'odd', 7, 11, 0, '2024-12-24 10:19:57', '2025-01-10 07:52:03', NULL, NULL, 1, 1, 0, 0, 'false'),
(57, 1, 'odd', 7, 12, 0, '2024-12-24 10:19:58', '2025-01-10 07:52:03', NULL, NULL, 1, 1, 0, 0, 'false'),
(58, 1, 'odd', 7, 13, 2, '2024-12-24 10:19:58', '2025-01-10 07:52:03', NULL, NULL, 1, 1, 0, 0, 'false'),
(59, 1, 'odd', 7, 14, 0, '2024-12-24 10:19:58', '2025-01-10 07:52:03', NULL, NULL, 1, 1, 0, 0, 'false'),
(60, 1, 'odd', 7, 15, 0, '2024-12-24 10:19:58', '2025-01-10 07:52:03', NULL, NULL, 1, 1, 0, 0, 'false'),
(61, 1, 'odd', 8, 1, 0, '2024-12-24 10:20:06', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(62, 1, 'odd', 8, 2, 0, '2024-12-24 10:20:06', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(63, 1, 'odd', 8, 3, 0, '2024-12-24 10:20:06', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(64, 1, 'odd', 8, 4, 0, '2024-12-24 10:20:06', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(65, 1, 'odd', 8, 5, 0, '2024-12-24 10:20:06', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(66, 1, 'odd', 8, 6, 0, '2024-12-24 10:20:06', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(67, 1, 'odd', 8, 7, 0, '2024-12-24 10:20:06', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(68, 1, 'odd', 8, 8, 0, '2024-12-24 10:20:06', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(69, 1, 'odd', 8, 9, 0, '2024-12-24 10:20:06', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(70, 1, 'odd', 8, 10, 0, '2024-12-24 10:20:06', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(71, 1, 'odd', 8, 11, 0, '2024-12-24 10:20:06', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(72, 1, 'odd', 8, 12, 0, '2024-12-24 10:20:06', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(73, 1, 'odd', 8, 13, 0, '2024-12-24 10:20:06', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(74, 1, 'odd', 8, 14, 0, '2024-12-24 10:20:06', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(75, 1, 'odd', 8, 15, 0, '2024-12-24 10:20:06', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(76, 1, 'odd', 9, 1, 0, '2024-12-24 10:20:13', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(77, 1, 'odd', 9, 2, 0, '2024-12-24 10:20:13', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(78, 1, 'odd', 9, 3, 0, '2024-12-24 10:20:13', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(79, 1, 'odd', 9, 4, 0, '2024-12-24 10:20:13', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(80, 1, 'odd', 9, 5, 0, '2024-12-24 10:20:13', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(81, 1, 'odd', 9, 6, 0, '2024-12-24 10:20:13', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(82, 1, 'odd', 9, 7, 0, '2024-12-24 10:20:13', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(83, 1, 'odd', 9, 8, 0, '2024-12-24 10:20:13', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(84, 1, 'odd', 9, 9, 0, '2024-12-24 10:20:13', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(85, 1, 'odd', 9, 10, 0, '2024-12-24 10:20:13', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(86, 1, 'odd', 9, 11, 0, '2024-12-24 10:20:13', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(87, 1, 'odd', 9, 12, 0, '2024-12-24 10:20:13', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(88, 1, 'odd', 9, 13, 0, '2024-12-24 10:20:13', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(89, 1, 'odd', 9, 14, 0, '2024-12-24 10:20:13', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(90, 1, 'odd', 9, 15, 0, '2024-12-24 10:20:13', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(91, 1, 'odd', 4, 1, 0, '2024-12-24 10:20:22', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(92, 1, 'odd', 4, 2, 0, '2024-12-24 10:20:22', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(93, 1, 'odd', 4, 3, 0, '2024-12-24 10:20:22', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(94, 1, 'odd', 4, 4, 0, '2024-12-24 10:20:22', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(95, 1, 'odd', 4, 5, 0, '2024-12-24 10:20:22', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(96, 1, 'odd', 4, 6, 0, '2024-12-24 10:20:22', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(97, 1, 'odd', 4, 7, 0, '2024-12-24 10:20:22', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(98, 1, 'odd', 4, 8, 0, '2024-12-24 10:20:22', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(99, 1, 'odd', 4, 9, 0, '2024-12-24 10:20:22', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(100, 1, 'odd', 4, 10, 0, '2024-12-24 10:20:22', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(101, 1, 'odd', 4, 11, 0, '2024-12-24 10:20:22', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(102, 1, 'odd', 4, 12, 0, '2024-12-24 10:20:22', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(103, 1, 'odd', 4, 13, 0, '2024-12-24 10:20:22', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(104, 1, 'odd', 4, 14, 0, '2024-12-24 10:20:22', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(105, 1, 'odd', 4, 15, 0, '2024-12-24 10:20:22', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(106, 1, 'odd', 5, 1, 0, '2024-12-24 10:20:30', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(107, 1, 'odd', 5, 2, 0, '2024-12-24 10:20:30', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(108, 1, 'odd', 5, 3, 0, '2024-12-24 10:20:30', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(109, 1, 'odd', 5, 4, 0, '2024-12-24 10:20:30', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(110, 1, 'odd', 5, 5, 0, '2024-12-24 10:20:30', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(111, 1, 'odd', 5, 6, 0, '2024-12-24 10:20:30', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(112, 1, 'odd', 5, 7, 0, '2024-12-24 10:20:30', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(113, 1, 'odd', 5, 8, 0, '2024-12-24 10:20:30', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(114, 1, 'odd', 5, 9, 0, '2024-12-24 10:20:30', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(115, 1, 'odd', 5, 10, 0, '2024-12-24 10:20:30', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(116, 1, 'odd', 5, 11, 0, '2024-12-24 10:20:30', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(117, 1, 'odd', 5, 12, 0, '2024-12-24 10:20:30', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(118, 1, 'odd', 5, 13, 0, '2024-12-24 10:20:30', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(119, 1, 'odd', 5, 14, 0, '2024-12-24 10:20:30', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(120, 1, 'odd', 5, 15, 0, '2024-12-24 10:20:30', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(121, 1, 'odd', 6, 1, 0, '2024-12-24 10:20:38', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(122, 1, 'odd', 6, 2, 0, '2024-12-24 10:20:38', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(123, 1, 'odd', 6, 3, 0, '2024-12-24 10:20:38', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(124, 1, 'odd', 6, 4, 0, '2024-12-24 10:20:38', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(125, 1, 'odd', 6, 5, 0, '2024-12-24 10:20:38', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(126, 1, 'odd', 6, 6, 0, '2024-12-24 10:20:38', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(127, 1, 'odd', 6, 7, 0, '2024-12-24 10:20:38', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(128, 1, 'odd', 6, 8, 0, '2024-12-24 10:20:38', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(129, 1, 'odd', 6, 9, 0, '2024-12-24 10:20:38', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(130, 1, 'odd', 6, 10, 0, '2024-12-24 10:20:38', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(131, 1, 'odd', 6, 11, 0, '2024-12-24 10:20:38', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(132, 1, 'odd', 6, 12, 0, '2024-12-24 10:20:38', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(133, 1, 'odd', 6, 13, 0, '2024-12-24 10:20:38', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(134, 1, 'odd', 6, 14, 0, '2024-12-24 10:20:38', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(135, 1, 'odd', 6, 15, 0, '2024-12-24 10:20:38', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(136, 1, 'odd', 7, 16, 0, '2024-12-24 14:00:01', '2025-01-10 07:52:03', NULL, NULL, 1, 1, 0, 0, 'false'),
(137, 1, 'odd', 7, 17, 0, '2024-12-24 14:00:01', '2025-01-10 07:52:03', NULL, NULL, 1, 1, 0, 0, 'false'),
(138, 1, 'odd', 7, 18, 0, '2024-12-24 14:00:01', '2025-01-10 07:52:03', NULL, NULL, 1, 1, 0, 0, 'false'),
(139, 1, 'odd', 7, 19, 0, '2024-12-24 14:00:01', '2025-01-10 07:52:03', NULL, NULL, 1, 1, 0, 0, 'false'),
(140, 1, 'odd', 8, 16, 0, '2024-12-24 14:00:12', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(141, 1, 'odd', 8, 17, 0, '2024-12-24 14:00:12', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(142, 1, 'odd', 8, 18, 0, '2024-12-24 14:00:12', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(143, 1, 'odd', 8, 19, 0, '2024-12-24 14:00:12', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(144, 1, 'odd', 9, 16, 0, '2024-12-24 14:00:23', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(145, 1, 'odd', 9, 17, 0, '2024-12-24 14:00:23', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(146, 1, 'odd', 9, 18, 0, '2024-12-24 14:00:23', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(147, 1, 'odd', 9, 19, 0, '2024-12-24 14:00:23', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(148, 1, 'odd', 3, 16, 16, '2024-12-24 14:00:32', '2024-12-24 14:03:19', NULL, NULL, 1, 1, 0, 0, 'false'),
(149, 1, 'odd', 3, 17, 5, '2024-12-24 14:00:32', '2024-12-24 14:03:19', NULL, NULL, 1, 1, 0, 0, 'false'),
(150, 1, 'odd', 3, 18, 14, '2024-12-24 14:00:32', '2024-12-24 14:03:19', NULL, NULL, 1, 1, 0, 0, 'false'),
(151, 1, 'odd', 3, 19, 14, '2024-12-24 14:00:32', '2024-12-24 14:03:19', NULL, NULL, 1, 1, 0, 0, 'false'),
(152, 1, 'odd', 1, 16, 0, '2024-12-24 14:00:42', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(153, 1, 'odd', 1, 17, 0, '2024-12-24 14:00:42', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(154, 1, 'odd', 1, 18, 0, '2024-12-24 14:00:42', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(155, 1, 'odd', 1, 19, 0, '2024-12-24 14:00:42', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(156, 1, 'odd', 2, 16, 0, '2024-12-24 14:00:49', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(157, 1, 'odd', 2, 17, 0, '2024-12-24 14:00:49', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(158, 1, 'odd', 2, 18, 0, '2024-12-24 14:00:49', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(159, 1, 'odd', 2, 19, 0, '2024-12-24 14:00:49', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(160, 1, 'odd', 4, 16, 0, '2024-12-24 14:00:58', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(161, 1, 'odd', 4, 17, 0, '2024-12-24 14:00:58', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(162, 1, 'odd', 4, 18, 0, '2024-12-24 14:00:58', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(163, 1, 'odd', 4, 19, 0, '2024-12-24 14:00:58', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(164, 1, 'odd', 5, 16, 0, '2024-12-24 14:01:04', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(165, 1, 'odd', 5, 17, 0, '2024-12-24 14:01:04', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(166, 1, 'odd', 5, 18, 0, '2024-12-24 14:01:04', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(167, 1, 'odd', 5, 19, 0, '2024-12-24 14:01:04', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(168, 1, 'odd', 6, 16, 0, '2024-12-24 14:01:14', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(169, 1, 'odd', 6, 17, 0, '2024-12-24 14:01:14', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(170, 1, 'odd', 6, 18, 0, '2024-12-24 14:01:14', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(171, 1, 'odd', 6, 19, 0, '2024-12-24 14:01:14', NULL, NULL, NULL, 1, 0, 0, 0, 'false');

-- --------------------------------------------------------

--
-- Struktur dari tabel `employees`
--

DROP TABLE IF EXISTS `employees`;
CREATE TABLE IF NOT EXISTS `employees` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `assignment_letter_number` varchar(255) DEFAULT NULL COMMENT 'Nomor Surat Tugas',
  `assignment_letter_date` date DEFAULT NULL COMMENT 'Tanggal Surat Tugas',
  `assignment_start_date` date DEFAULT NULL COMMENT 'TMT Tugas',
  `parent_school_status` enum('true','false') NOT NULL DEFAULT 'true' COMMENT 'Status Sekolah Induk',
  `full_name` varchar(150) NOT NULL,
  `gender` enum('M','F') NOT NULL DEFAULT 'M',
  `nik` varchar(50) DEFAULT NULL,
  `birth_place` varchar(255) DEFAULT NULL,
  `birth_date` date DEFAULT NULL,
  `mother_name` varchar(150) DEFAULT NULL,
  `street_address` varchar(255) DEFAULT NULL COMMENT 'Alamat Jalan',
  `rt` varchar(10) DEFAULT NULL COMMENT 'Rukun Tetangga',
  `rw` varchar(10) DEFAULT NULL COMMENT 'Rukun Warga',
  `sub_village` varchar(255) DEFAULT NULL COMMENT 'Nama Dusun',
  `village` varchar(255) DEFAULT NULL COMMENT 'Nama Kelurahan/Desa',
  `sub_district` varchar(255) DEFAULT NULL COMMENT 'Kecamatan',
  `district` varchar(255) DEFAULT NULL COMMENT 'Kota/Kabupaten',
  `postal_code` varchar(20) DEFAULT NULL COMMENT 'Kode POS',
  `religion_id` bigint DEFAULT '0',
  `marriage_status_id` bigint DEFAULT '0',
  `spouse_name` varchar(255) DEFAULT NULL COMMENT 'Nama Pasangan : Suami / Istri',
  `spouse_employment_id` bigint DEFAULT '0' COMMENT 'Pekerjaan Pasangan : Suami / Istri',
  `citizenship` enum('WNI','WNA') NOT NULL DEFAULT 'WNI' COMMENT 'Kewarganegaraan',
  `country` varchar(255) DEFAULT NULL,
  `npwp` varchar(100) DEFAULT NULL,
  `employment_status_id` bigint DEFAULT '0' COMMENT 'Status Kepegawaian',
  `nip` varchar(100) DEFAULT NULL,
  `niy` varchar(100) DEFAULT NULL COMMENT 'NIY/NIGK',
  `nuptk` varchar(100) DEFAULT NULL,
  `employment_type_id` bigint DEFAULT '0' COMMENT 'Jenis Guru dan Tenaga Kependidikan (GTK)',
  `decree_appointment` varchar(255) DEFAULT NULL COMMENT 'SK Pengangkatan',
  `appointment_start_date` date DEFAULT NULL COMMENT 'TMT Pengangkatan',
  `institution_lifter_id` bigint DEFAULT '0' COMMENT 'Lembaga Pengangkat',
  `decree_cpns` varchar(100) DEFAULT NULL COMMENT 'SK CPNS',
  `pns_start_date` date DEFAULT NULL COMMENT 'TMT CPNS',
  `rank_id` bigint DEFAULT '0' COMMENT 'Pangkat/Golongan',
  `salary_source_id` bigint DEFAULT '0' COMMENT 'Sumber Gaji',
  `headmaster_license` enum('true','false') NOT NULL DEFAULT 'false' COMMENT 'Punya Lisensi Kepala Sekolah?',
  `laboratory_skill_id` bigint DEFAULT '0' COMMENT 'Keahlian Lab oratorium',
  `special_need_id` bigint DEFAULT '0' COMMENT 'Mampu Menangani Kebutuhan Khusus',
  `braille_skills` enum('true','false') NOT NULL DEFAULT 'false' COMMENT 'Keahlian Braile ?',
  `sign_language_skills` enum('true','false') NOT NULL DEFAULT 'false' COMMENT 'Keahlian Bahasa Isyarat ?',
  `phone` varchar(255) DEFAULT NULL,
  `mobile_phone` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `photo` varchar(100) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  `restored_at` datetime DEFAULT NULL,
  `created_by` bigint DEFAULT '0',
  `updated_by` bigint DEFAULT '0',
  `deleted_by` bigint DEFAULT '0',
  `restored_by` bigint DEFAULT '0',
  `is_deleted` enum('true','false') DEFAULT 'false',
  PRIMARY KEY (`id`),
  KEY `employees_nik__idx` (`nik`) USING BTREE,
  KEY `employees_full_name__idx` (`full_name`) USING BTREE,
  KEY `employees_email__idx` (`email`) USING BTREE,
  KEY `employees_religion_id__idx` (`religion_id`) USING BTREE,
  KEY `employees_marriage_status_id__idx` (`marriage_status_id`) USING BTREE,
  KEY `employees_spouse_employment_id__idx` (`spouse_employment_id`) USING BTREE,
  KEY `employees_employment_status_id__idx` (`employment_status_id`) USING BTREE,
  KEY `employees_employment_type_id__idx` (`employment_type_id`) USING BTREE,
  KEY `employees_institution_lifter_id__idx` (`institution_lifter_id`) USING BTREE,
  KEY `employees_rank_id__idx` (`rank_id`) USING BTREE,
  KEY `employees_salary_source_id__idx` (`salary_source_id`) USING BTREE,
  KEY `employees_laboratory_skill_id__idx` (`laboratory_skill_id`) USING BTREE,
  KEY `employees_special_need_id__idx` (`special_need_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb3;

--
-- Dumping data untuk tabel `employees`
--

INSERT INTO `employees` (`id`, `assignment_letter_number`, `assignment_letter_date`, `assignment_start_date`, `parent_school_status`, `full_name`, `gender`, `nik`, `birth_place`, `birth_date`, `mother_name`, `street_address`, `rt`, `rw`, `sub_village`, `village`, `sub_district`, `district`, `postal_code`, `religion_id`, `marriage_status_id`, `spouse_name`, `spouse_employment_id`, `citizenship`, `country`, `npwp`, `employment_status_id`, `nip`, `niy`, `nuptk`, `employment_type_id`, `decree_appointment`, `appointment_start_date`, `institution_lifter_id`, `decree_cpns`, `pns_start_date`, `rank_id`, `salary_source_id`, `headmaster_license`, `laboratory_skill_id`, `special_need_id`, `braille_skills`, `sign_language_skills`, `phone`, `mobile_phone`, `email`, `photo`, `created_at`, `updated_at`, `deleted_at`, `restored_at`, `created_by`, `updated_by`, `deleted_by`, `restored_by`, `is_deleted`) VALUES
(1, '', '0000-00-00', '0000-00-00', 'true', 'ABRI PRATAMA', 'M', '10210285196001', 'Medan', '1996-10-05', '', 'Medan, SUMUT', '', '', '', '', '', '', '', 89, 104, '', 0, 'WNI', '', NULL, 116, NULL, NULL, '', 128, '', '0000-00-00', 0, '', '0000-00-00', 0, 0, 'false', 164, 23, 'false', 'false', '', '', '10210285196001@mtssypalazhar.sch.id', '0ac733d3f3d9f6b5b703139a22114692.jpg', '2024-12-20 12:13:26', '2024-12-20 09:48:09', NULL, NULL, 1, 1, 0, 0, 'false'),
(2, '', '0000-00-00', '0000-00-00', 'true', 'ASPANI', 'M', '1223032812900000', 'Sialang Gatap', '1990-10-07', '', 'Medan, SUMUT', '', '', '', '', '', '', '', 0, 0, '', 0, 'WNI', '', NULL, 116, NULL, NULL, '', 125, '', '0000-00-00', 0, '', '0000-00-00', 0, 0, 'false', 0, 0, 'false', 'false', '', '', '1223032812900000@mtssypalazhar.sch.id', NULL, '2024-12-20 12:13:26', '2024-12-20 09:48:33', NULL, NULL, 1, 1, 0, 0, 'false'),
(3, '', '0000-00-00', '0000-00-00', 'true', 'ASRI NINGSIH', 'F', '1271085908820000', 'Belawan', '1982-08-19', '', 'Medan, SUMUT', '', '', '', '', '', '', '', 0, 0, '', 0, 'WNI', '', NULL, 116, NULL, NULL, '', 128, '', '0000-00-00', 0, '', '0000-00-00', 0, 0, 'false', 0, 0, 'false', 'false', '', '', '1271085908820000@mtssypalazhar.sch.id', NULL, '2024-12-20 12:13:26', '2024-12-20 09:48:54', NULL, NULL, 1, 1, 0, 0, 'false'),
(4, '', '0000-00-00', '0000-00-00', 'true', 'AZHARUDDIN', 'M', '8655760661200040', 'Medan', '1982-03-23', '', 'Medan, SUMUT', '', '', '', '', '', '', '', 0, 0, '', 0, 'WNI', '', NULL, 116, NULL, NULL, '', 133, '', '0000-00-00', 0, '', '0000-00-00', 0, 0, 'false', 0, 0, 'false', 'false', '', '', '8655760661200040@mtssypalazhar.sch.id', '7bf09493bf8406d4e7d6341671ec3260.jpg', '2024-12-20 12:13:26', '2024-12-21 05:01:48', NULL, NULL, 1, 1, 0, 0, 'false'),
(5, '', '0000-00-00', '0000-00-00', 'true', 'DANIEL ABDILLAH', 'M', '9260767668200000', 'Medan', '1989-09-28', '', 'Medan, SUMUT', '', '', '', '', '', '', '', 0, 0, '', 0, 'WNI', '', NULL, 116, NULL, NULL, '', 125, '', '0000-00-00', 0, '', '0000-00-00', 0, 0, 'false', 0, 0, 'false', 'false', '', '', '9260767668200000@mtssypalazhar.sch.id', '0ecaa902b4ebef684637592d334234cd.jpg', '2024-12-20 12:13:26', '2024-12-21 05:02:53', NULL, NULL, 1, 1, 0, 0, 'false'),
(6, '', '0000-00-00', '0000-00-00', 'true', 'DONNY', 'M', '2047753654200040', 'Medan', '1975-07-15', '', 'Medan, SUMUT', '', '', '', '', '', '', '', 89, 0, '', 0, 'WNI', '', NULL, 116, NULL, NULL, '', 170, '', '0000-00-00', 109, '', '0000-00-00', 0, 0, 'true', 0, 0, 'false', 'false', '', '', '2047753654200040@mtssypalazhar.sch.id', '106404d8afdf5e6915ec3ea295e1abc9.jpg', '2024-12-20 12:13:26', '2024-12-20 09:47:32', NULL, NULL, 1, 1, 0, 0, 'false'),
(7, '', '0000-00-00', '0000-00-00', 'true', 'IDRIS GINTING', 'M', '2633743648200010', 'Kuta Bunga', '1965-01-03', '', 'Medan, SUMUT', '', '', '', '', '', '', '', 0, 0, '', 0, 'WNI', '', NULL, 114, NULL, NULL, '', 125, '', '0000-00-00', 0, '', '0000-00-00', 0, 0, 'false', 0, 0, 'false', 'false', '', '', '2633743648200010@mtssypalazhar.sch.id', NULL, '2024-12-20 12:13:26', '2024-12-21 05:03:36', NULL, NULL, 1, 1, 0, 0, 'false'),
(8, '', '0000-00-00', '0000-00-00', 'true', 'HABIBNI RIDHA', 'F', '1157752652200000', 'Medan', '1974-08-25', '', 'Medan, SUMUT', '', '', '', '', '', '', '', 0, 0, '', 0, 'WNI', '', NULL, 114, NULL, NULL, '', 125, '', '0000-00-00', 0, '', '0000-00-00', 0, 0, 'false', 0, 0, 'false', 'false', '', '', '1157752652200000@mtssypalazhar.sch.id', '586b611dac7088eeb3fa35206568cea3.jpg', '2024-12-20 12:13:26', '2024-12-21 05:04:26', NULL, NULL, 1, 1, 0, 0, 'false'),
(9, '', '0000-00-00', '0000-00-00', 'true', 'HARUN', 'M', '3444750652200060', 'Benteng', '1972-12-01', '', 'Medan, SUMUT', '', '', '', '', '', '', '', 0, 0, '', 0, 'WNI', '', NULL, 116, NULL, NULL, '', 125, '', '0000-00-00', 0, '', '0000-00-00', 0, 0, 'false', 0, 0, 'false', 'false', '', '', '3444750652200060@mtssypalazhar.sch.id', '757e3cb5123db2973e41087bdf2d1000.jpg', '2024-12-20 12:13:26', '2024-12-21 05:04:43', NULL, NULL, 1, 1, 0, 0, 'false'),
(10, '', '0000-00-00', '0000-00-00', 'true', 'DINA RAMADHANA', 'F', '2255752653300030', 'Medan', '1974-09-23', '', 'Medan, SUMUT', '', '', '', '', '', '', '', 0, 0, '', 0, 'WNI', '', NULL, 116, NULL, NULL, '', 125, '', '0000-00-00', 0, '', '0000-00-00', 0, 0, 'false', 0, 0, 'false', 'false', '', '', '2255752653300030@mtssypalazhar.sch.id', 'e347aa26a6d54b107662754fb08abf7f.jpg', '2024-12-20 12:13:26', '2024-12-21 05:14:00', NULL, NULL, 1, 1, 0, 0, 'false'),
(11, '', '0000-00-00', '0000-00-00', 'true', 'KHAIRANI', 'F', '8944745646300020', 'Medan', '1967-12-06', '', 'Medan, SUMUT', '', '', '', '', '', '', '', 0, 0, '', 0, 'WNI', '', NULL, 116, NULL, NULL, '', 125, '', '0000-00-00', 0, '', '0000-00-00', 0, 0, 'false', 0, 0, 'false', 'false', '', '', '8944745646300020@mtssypalazhar.sch.id', 'c708f5bbe8119fb882f65b3039620214.jpg', '2024-12-20 12:13:26', '2024-12-21 05:14:32', NULL, NULL, 1, 1, 0, 0, 'false'),
(12, '', '0000-00-00', '0000-00-00', 'true', 'ZURAIDAH', 'F', '0547746647300032', 'Deli Serdang', '1968-02-15', '', 'Medan, SUMUT', '', '', '', '', '', '', '', 0, 0, '', 0, 'WNI', '', NULL, 116, NULL, NULL, '', 125, '', '0000-00-00', 0, '', '0000-00-00', 0, 0, 'false', 0, 0, 'false', 'false', '', '', '0547746647300032@mtssypalazhar.sch.id', 'db713f6f6ebd4858aad18ababf3836af.jpg', '2024-12-20 12:13:26', '2024-12-21 05:15:20', NULL, NULL, 1, 1, 0, 0, 'false'),
(13, '', '0000-00-00', '0000-00-00', 'true', 'IHSAN IRFANDI PAKPAHAN', 'M', '10210285194001', 'Medan', '1994-11-21', '', 'Medan, SUMUT', '', '', '', '', '', '', '', 0, 0, '', 0, 'WNI', '', NULL, 116, NULL, NULL, '', 125, '', '0000-00-00', 0, '', '0000-00-00', 0, 0, 'false', 0, 0, 'false', 'false', '', '', '10210285194001@mtssypalazhar.sch.id', 'ff768f517af218d0ddcd33c75985d8c7.jpg', '2024-12-20 12:13:26', '2024-12-21 05:15:59', NULL, NULL, 1, 1, 0, 0, 'false'),
(14, '', '0000-00-00', '0000-00-00', 'true', 'JAMHURDIN DHARMA', 'M', '10269109193001', 'Medan', '1993-05-27', '', 'Medan, SUMUT', '', '', '', '', '', '', '', 0, 0, '', 0, 'WNI', '', NULL, 116, NULL, NULL, '', 125, '', '0000-00-00', 0, '', '0000-00-00', 0, 0, 'false', 0, 0, 'false', 'false', '', '', '10269109193001@mtssypalazhar.sch.id', NULL, '2024-12-20 12:13:26', '2024-12-21 05:16:22', NULL, NULL, 1, 1, 0, 0, 'false'),
(15, '', '0000-00-00', '0000-00-00', 'true', 'MAYA VERI SAHARA NASUTION', 'F', '9133764665300080', 'Medan', '1986-08-01', '', 'Medan, SUMUT', '', '', '', '', '', '', '', 0, 0, '', 0, 'WNI', '', NULL, 116, NULL, NULL, '', 125, '', '0000-00-00', 0, '', '0000-00-00', 0, 0, 'false', 0, 0, 'false', 'false', '', '', '9133764665300080@mtssypalazhar.sch.id', 'e0d66d72995c616c1022604383e1d88f.jpg', '2024-12-20 12:13:26', '2024-12-21 05:17:19', NULL, NULL, 1, 1, 0, 0, 'false'),
(16, '', '0000-00-00', '0000-00-00', 'true', 'MINDIA RAYANI', 'F', '3833757658210120', 'Paya Geli', '1979-05-01', '', 'Medan, SUMUT', '', '', '', '', '', '', '', 0, 0, '', 0, 'WNI', '', NULL, 116, NULL, NULL, '', 125, '', '0000-00-00', 0, '', '0000-00-00', 0, 0, 'false', 0, 0, 'false', 'false', '', '', '3833757658210120@mtssypalazhar.sch.id', 'b2f78fe392b435843d05a17167e58d8c.jpg', '2024-12-20 12:13:26', '2024-12-21 05:17:40', NULL, NULL, 1, 1, 0, 0, 'false'),
(17, '', '0000-00-00', '0000-00-00', 'true', 'MUHAMMAD AZRAI', 'M', '10267143193002', 'Medan', '1994-04-08', '', 'Medan, SUMUT', '', '', '', '', '', '', '', 0, 0, '', 0, 'WNI', '', NULL, 116, NULL, NULL, '', 125, '', '0000-00-00', 0, '', '0000-00-00', 0, 0, 'false', 0, 0, 'false', 'false', '', '', '10267143193002@mtssypalazhar.sch.id', NULL, '2024-12-20 12:13:26', '2024-12-21 05:18:02', NULL, NULL, 1, 1, 0, 0, 'false'),
(18, '', '0000-00-00', '0000-00-00', 'true', 'NURHASANAH', 'F', '4148756658300080', 'Medan', '1978-08-16', '', 'Medan, SUMUT', '', '', '', '', '', '', '', 0, 0, '', 0, 'WNI', '', NULL, 116, NULL, NULL, '', 125, '', '0000-00-00', 0, '', '0000-00-00', 0, 0, 'false', 0, 0, 'false', 'false', '', '', '4148756658300080@mtssypalazhar.sch.id', '42729952694c23ea0f0b6933ed0d5561.jpg', '2024-12-20 12:13:26', '2024-12-21 05:18:24', NULL, NULL, 1, 1, 0, 0, 'false'),
(19, '', '0000-00-00', '0000-00-00', 'true', 'RIANI', 'F', '1271026512770000', 'MEDAN', '1977-12-25', '', 'Medan, SUMUT', '', '', '', '', '', '', '', 0, 0, '', 0, 'WNI', '', NULL, 116, NULL, NULL, '', 125, '', '0000-00-00', 0, '', '0000-00-00', 0, 0, 'false', 0, 0, 'false', 'false', '', '', '1271026512770000@mtssypalazhar.sch.id', NULL, '2024-12-20 12:13:26', '2024-12-21 05:19:17', NULL, NULL, 1, 1, 0, 0, 'false'),
(20, '', '0000-00-00', '0000-00-00', 'true', 'RODIAH', 'F', '9060746648300060', 'Medan', '1968-07-28', '', 'Medan, SUMUT', '', '', '', '', '', '', '', 0, 0, '', 0, 'WNI', '', NULL, 116, NULL, NULL, '', 125, '', '0000-00-00', 0, '', '0000-00-00', 0, 0, 'false', 0, 0, 'false', 'false', '', '', '9060746648300060@mtssypalazhar.sch.id', 'ffd0df47af5bbf45b6a7e7d41aa3e5c4.jpg', '2024-12-20 12:13:26', '2024-12-21 05:19:34', NULL, NULL, 1, 1, 0, 0, 'false'),
(21, '', '0000-00-00', '0000-00-00', 'true', 'SUHARTINI', 'F', '5633762664300060', 'Medan', '1984-03-01', '', 'Medan, SUMUT', '', '', '', '', '', '', '', 0, 0, '', 0, 'WNI', '', NULL, 116, NULL, NULL, '', 125, '', '0000-00-00', 0, '', '0000-00-00', 0, 0, 'false', 0, 0, 'false', 'false', '', '', '5633762664300060@mtssypalazhar.sch.id', '370a13f6f715382021900f6e57f7c592.jpg', '2024-12-20 12:13:26', '2024-12-21 05:19:55', NULL, NULL, 1, 1, 0, 0, 'false'),
(22, '', '0000-00-00', '0000-00-00', 'true', 'SYAHRIZAL', 'M', '6458752653200020', 'Medan', '1974-01-26', '', 'Medan, SUMUT', '', '', '', '', '', '', '', 0, 0, '', 0, 'WNI', '', NULL, 116, NULL, NULL, '', 125, '', '0000-00-00', 0, '', '0000-00-00', 0, 0, 'false', 0, 0, 'false', 'false', '', '', '6458752653200020@mtssypalazhar.sch.id', NULL, '2024-12-20 12:13:26', '2024-12-21 05:20:41', NULL, NULL, 1, 1, 0, 0, 'false'),
(23, '', '0000-00-00', '0000-00-00', 'true', 'YENNIYATY HARAHAP', 'F', '5236759660210110', 'Medan', '1981-09-04', '', 'Medan, SUMUT', '', '', '', '', '', '', '', 0, 0, '', 0, 'WNI', '', NULL, 116, NULL, NULL, '', 125, '', '0000-00-00', 0, '', '0000-00-00', 0, 0, 'false', 0, 0, 'false', 'false', '', '', '5236759660210110@mtssypalazhar.sch.id', NULL, '2024-12-20 12:13:26', '2024-12-21 05:21:14', NULL, NULL, 1, 1, 0, 0, 'false'),
(24, '', '0000-00-00', '0000-00-00', 'true', 'ZULKIFLI', 'M', '1259766667200010', 'Paya Perupu', '1988-09-27', '', 'Medan, SUMUT', '', '', '', '', '', '', '', 0, 0, '', 0, 'WNI', '', NULL, 116, NULL, NULL, '', 125, '', '0000-00-00', 0, '', '0000-00-00', 0, 0, 'false', 0, 0, 'false', 'false', '', '', '1259766667200010@mtssypalazhar.sch.id', NULL, '2024-12-20 12:13:26', '2024-12-21 05:21:40', NULL, NULL, 1, 1, 0, 0, 'false');

-- --------------------------------------------------------

--
-- Struktur dari tabel `field_settings`
--

DROP TABLE IF EXISTS `field_settings`;
CREATE TABLE IF NOT EXISTS `field_settings` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `field_name` varchar(100) DEFAULT NULL,
  `field_description` varchar(255) DEFAULT NULL,
  `field_setting` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  `restored_at` datetime DEFAULT NULL,
  `created_by` bigint DEFAULT '0',
  `updated_by` bigint DEFAULT '0',
  `deleted_by` bigint DEFAULT '0',
  `restored_by` bigint DEFAULT '0',
  `is_deleted` enum('true','false') DEFAULT 'false',
  PRIMARY KEY (`id`),
  UNIQUE KEY `field_name` (`field_name`)
) ENGINE=InnoDB AUTO_INCREMENT=79 DEFAULT CHARSET=utf8mb3;

--
-- Dumping data untuk tabel `field_settings`
--

INSERT INTO `field_settings` (`id`, `field_name`, `field_description`, `field_setting`, `created_at`, `updated_at`, `deleted_at`, `restored_at`, `created_by`, `updated_by`, `deleted_by`, `restored_by`, `is_deleted`) VALUES
(1, 'is_transfer', 'Jenis Pendaftaran', '{\"admission\":\"true\",\"admission_required\":\"true\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(2, 'admission_type_id', 'Jalur Pendaftaran', '{\"admission\":\"true\",\"admission_required\":\"true\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(3, 'first_choice_id', 'Pilihan Ke-1', '{\"admission\":\"false\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(4, 'second_choice_id', 'Pilihan Ke-2', '{\"admission\":\"false\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(5, 'nik', 'NIK/ No. KITAS (Untuk WNA)', '{\"admission\":\"true\",\"admission_required\":\"true\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(6, 'prev_school_name', 'Sekolah Asal', '{\"admission\":\"true\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(7, 'prev_exam_number', 'Nomor Peserta UN SMP/MTs', '{\"admission\":\"false\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(8, 'skhun', 'Nomor SKHUN SMP/MTs', '{\"admission\":\"false\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(9, 'prev_diploma_number', 'Nomor Seri Ijazah SMP/MTs', '{\"admission\":\"false\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(10, 'full_name', 'Nama Lengkap', '{\"admission\":\"true\",\"admission_required\":\"true\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(11, 'gender', 'Jenis Kelamin', '{\"admission\":\"true\",\"admission_required\":\"true\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(12, 'nisn', 'NISN', '{\"admission\":\"true\",\"admission_required\":\"true\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(13, 'family_card_number', 'Nomor Kartu Keluarga', '{\"admission\":\"false\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(14, 'birth_place', 'Tempat Lahir', '{\"admission\":\"true\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(15, 'birth_date', 'Tanggal Lahir', '{\"admission\":\"false\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(16, 'birth_certificate_number', 'Nomor Registasi Akta Lahir', '{\"admission\":\"false\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(17, 'religion_id', 'Agama dan Kepercayaan', '{\"admission\":\"true\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(18, 'citizenship', 'Kewarganegaraan', '{\"admission\":\"true\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(19, 'country', 'Nama Negara', '{\"admission\":\"false\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(20, 'special_need_id', 'Berkebutuhan Khusus', '{\"admission\":\"true\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(21, 'street_address', 'Alamat Jalan', '{\"admission\":\"true\",\"admission_required\":\"true\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(22, 'rt', 'RT', '{\"admission\":\"false\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(23, 'rw', 'RW', '{\"admission\":\"false\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(24, 'sub_village', 'Nama Dusun', '{\"admission\":\"false\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(25, 'village', 'Nama Kelurahan/Desa', '{\"admission\":\"true\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(26, 'sub_district', 'Kecamatan', '{\"admission\":\"true\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(27, 'district', 'Kabupaten', '{\"admission\":\"true\",\"admission_required\":\"true\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(28, 'postal_code', 'Kode POS', '{\"admission\":\"false\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(29, 'latitude', 'Lintang', '{\"admission\":\"false\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(30, 'longitude', 'Bujur', '{\"admission\":\"false\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(31, 'residence_id', 'Tempat Tinggal', '{\"admission\":\"true\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(32, 'transportation_id', 'Moda Transportasi', '{\"admission\":\"true\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(33, 'child_number', 'Anak Keberapa', '{\"admission\":\"true\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(34, 'employment_id', 'Pekerjaan (diperuntukan untuk warga belajar)', '{\"admission\":\"false\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(35, 'have_kip', 'Apakah Punya KIP', '{\"admission\":\"true\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(36, 'receive_kip', 'Apakah Peserta Didik Tersebut Tetap Akan Menerima KIP', '{\"admission\":\"false\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(37, 'reject_pip', 'Alasan Menolak PIP', '{\"admission\":\"false\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(38, 'father_name', 'Nama Ayah Kandung', '{\"admission\":\"true\",\"admission_required\":\"true\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(39, 'father_nik', 'NIK Ayah', '{\"admission\":\"false\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(40, 'father_birth_place', 'Tempat Lahir Ayah', '{\"admission\":\"false\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(41, 'father_birth_date', 'Tanggal Lahir Ayah', '{\"admission\":\"false\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(42, 'father_education_id', 'Pendidikan Ayah', '{\"admission\":\"true\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2025-01-09 09:53:36', NULL, NULL, 0, 1, 0, 0, 'false'),
(43, 'father_employment_id', 'Pekerjaan Ayah', '{\"admission\":\"true\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(44, 'father_monthly_income_id', 'Penghasilan Bulanan Ayah', '{\"admission\":\"false\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(45, 'father_special_need_id', 'Kebutuhan Khusus Ayah', '{\"admission\":\"false\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(46, 'father_identity_card', 'Upload KTP Ayah', '{\"admission\":\"false\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(47, 'mother_name', 'Nama Ibu Kandung', '{\"admission\":\"true\",\"admission_required\":\"true\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(48, 'mother_nik', 'NIK Ibu', '{\"admission\":\"false\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(49, 'mother_birth_place', 'Tempat Lahir Ibu', '{\"admission\":\"false\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(50, 'mother_birth_date', 'Tanggal Lahir Ibu', '{\"admission\":\"false\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(51, 'mother_education_id', 'Pendidikan Ibu', '{\"admission\":\"true\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2025-01-09 09:53:36', NULL, NULL, 0, 1, 0, 0, 'false'),
(52, 'mother_employment_id', 'Pekerjaan Ibu', '{\"admission\":\"true\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(53, 'mother_monthly_income_id', 'Penghasilan Bulanan Ibu', '{\"admission\":\"false\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(54, 'mother_special_need_id', 'Kebutuhan Khusus Ibu', '{\"admission\":\"false\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(55, 'mother_identity_card', 'Upload KTP Ibu', '{\"admission\":\"false\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(56, 'guardian_name', 'Nama Wali', '{\"admission\":\"true\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(57, 'guardian_nik', 'NIK Wali', '{\"admission\":\"false\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(58, 'guardian_birth_date', 'Tanggal Lahir Wali', '{\"admission\":\"false\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(59, 'guardian_birth_place', 'Tempat Lahir Wali', '{\"admission\":\"false\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(60, 'guardian_education_id', 'Pendidikan Wali', '{\"admission\":\"false\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(61, 'guardian_employment_id', 'Pekerjaan Wali', '{\"admission\":\"true\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(62, 'guardian_monthly_income_id', 'Penghasilan Bulanan Wali', '{\"admission\":\"false\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(63, 'guardian_identity_card', 'Upload KTP Wali', '{\"admission\":\"false\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(64, 'phone', 'Nomor Telepon Rumah', '{\"admission\":\"false\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(65, 'mobile_phone', 'Nomor HP', '{\"admission\":\"true\",\"admission_required\":\"true\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(66, 'email', 'Email', '{\"admission\":\"true\",\"admission_required\":\"true\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(67, 'height', 'Tinggi Badan', '{\"admission\":\"false\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(68, 'weight', 'Berat Badan', '{\"admission\":\"false\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(69, 'head_circumference', 'Lingkar Kepala', '{\"admission\":\"false\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(70, 'mileage', 'Jarak Tempat Tinggal ke Sekolah', '{\"admission\":\"true\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(71, 'traveling_time', 'Waktu Tempuh ke Sekolah (Menit)', '{\"admission\":\"true\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(72, 'sibling_number', 'Jumlah Saudara Kandung', '{\"admission\":\"true\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(73, 'welfare_type', 'Jenis Kesejahteraan', '{\"admission\":\"false\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(74, 'welfare_number', 'Nomor Kartu Kesejahteraan', '{\"admission\":\"false\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(75, 'welfare_name', 'Nama di Kartu Kesejahteraan', '{\"admission\":\"false\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(76, 'photo', 'Unggah Pas Foto', '{\"admission\":\"false\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(77, 'family_card', 'Unggah Kartu Keluarga', '{\"admission\":\"false\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(78, 'birth_certificate', 'Unggah Akta Lahir', '{\"admission\":\"false\",\"admission_required\":\"false\"}', '2023-01-29 03:50:24', '2024-12-25 10:10:06', NULL, NULL, 0, 1, 0, 0, 'false');

-- --------------------------------------------------------

--
-- Struktur dari tabel `files`
--

DROP TABLE IF EXISTS `files`;
CREATE TABLE IF NOT EXISTS `files` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `file_title` varchar(255) DEFAULT NULL,
  `file_description` varchar(255) DEFAULT NULL,
  `file_name` varchar(255) DEFAULT NULL,
  `file_type` varchar(255) DEFAULT NULL,
  `file_category_id` bigint DEFAULT '0',
  `file_path` varchar(255) DEFAULT NULL,
  `file_ext` varchar(255) DEFAULT NULL,
  `file_size` varchar(255) DEFAULT NULL,
  `file_visibility` enum('public','private') DEFAULT 'public',
  `file_counter` bigint DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  `restored_at` datetime DEFAULT NULL,
  `created_by` bigint DEFAULT '0',
  `updated_by` bigint DEFAULT '0',
  `deleted_by` bigint DEFAULT '0',
  `restored_by` bigint DEFAULT '0',
  `is_deleted` enum('true','false') DEFAULT 'false',
  PRIMARY KEY (`id`),
  KEY `files_file_category_id__idx` (`file_category_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;

--
-- Dumping data untuk tabel `files`
--

INSERT INTO `files` (`id`, `file_title`, `file_description`, `file_name`, `file_type`, `file_category_id`, `file_path`, `file_ext`, `file_size`, `file_visibility`, `file_counter`, `created_at`, `updated_at`, `deleted_at`, `restored_at`, `created_by`, `updated_by`, `deleted_by`, `restored_by`, `is_deleted`) VALUES
(1, 'Sertifikat Akreditasi Tahun 2024', NULL, '4aad74e61c69abd6cb7b38767c09315f.pdf', 'application/pdf', 2, '/home/mtsd1779/public_html/media_library/files/', '.pdf', '410.03', 'public', 3, '2024-12-24 11:19:38', '2025-01-05 21:26:28', NULL, NULL, 1, 1, 0, 0, 'false');

-- --------------------------------------------------------

--
-- Struktur dari tabel `grade`
--

DROP TABLE IF EXISTS `grade`;
CREATE TABLE IF NOT EXISTS `grade` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `subjects_id` int NOT NULL,
  `employees_id` int NOT NULL,
  `class_groups_id` int NOT NULL,
  `students_id` int NOT NULL,
  `academic_years_id` int NOT NULL,
  `assignment_score` double NOT NULL,
  `mid_score` double NOT NULL,
  `exam_score` double NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data untuk tabel `grade`
--

INSERT INTO `grade` (`id`, `subjects_id`, `employees_id`, `class_groups_id`, `students_id`, `academic_years_id`, `assignment_score`, `mid_score`, `exam_score`, `created_at`, `updated_at`) VALUES
(1, 13, 2, 3, 26, 1, 75, 80, 85, '2025-01-27 16:20:45', '2025-01-27 16:26:38'),
(2, 13, 2, 3, 27, 1, 78, 83, 85, '2025-01-27 16:20:46', '2025-01-27 16:26:38'),
(3, 13, 2, 3, 28, 1, 80, 80, 80, '2025-01-27 16:20:46', '2025-01-27 16:26:38'),
(4, 13, 2, 3, 29, 1, 84, 79, 78, '2025-01-27 16:20:46', '2025-01-27 16:26:38'),
(5, 13, 2, 3, 30, 1, 77, 88, 85, '2025-01-27 16:20:46', '2025-01-27 16:26:38'),
(6, 13, 2, 3, 31, 1, 75, 80, 83, '2025-01-27 16:20:46', '2025-01-27 16:26:38'),
(7, 13, 2, 3, 32, 1, 80, 80, 80, '2025-01-27 16:20:46', '2025-01-27 16:26:38'),
(8, 13, 2, 3, 33, 1, 80, 80, 80, '2025-01-27 16:20:46', '2025-01-27 16:26:38'),
(9, 13, 2, 3, 34, 1, 80, 80, 80, '2025-01-27 16:20:46', '2025-01-27 16:26:38'),
(10, 13, 2, 3, 35, 1, 80, 80, 80, '2025-01-27 16:20:46', '2025-01-27 16:26:38'),
(11, 13, 2, 3, 36, 1, 80, 80, 80, '2025-01-27 16:20:46', '2025-01-27 16:26:38'),
(12, 13, 2, 3, 37, 1, 80, 80, 80, '2025-01-27 16:20:46', '2025-01-27 16:26:38'),
(13, 13, 2, 3, 38, 1, 80, 80, 80, '2025-01-27 16:20:46', '2025-01-27 16:26:38'),
(14, 13, 2, 3, 39, 1, 80, 80, 80, '2025-01-27 16:20:46', '2025-01-27 16:26:38'),
(15, 13, 2, 3, 40, 1, 80, 80, 80, '2025-01-27 16:20:46', '2025-01-27 16:26:38'),
(16, 13, 2, 3, 41, 1, 80, 80, 80, '2025-01-27 16:20:46', '2025-01-27 16:26:38'),
(17, 13, 2, 3, 42, 1, 80, 80, 80, '2025-01-27 16:20:46', '2025-01-27 16:26:38'),
(18, 13, 2, 3, 43, 1, 80, 80, 80, '2025-01-27 16:20:46', '2025-01-27 16:26:38'),
(19, 13, 2, 3, 44, 1, 80, 80, 80, '2025-01-27 16:20:46', '2025-01-27 16:26:38'),
(20, 13, 2, 3, 45, 1, 80, 80, 80, '2025-01-27 16:20:46', '2025-01-27 16:26:38'),
(21, 13, 2, 3, 46, 1, 80, 80, 80, '2025-01-27 16:20:46', '2025-01-27 16:26:38'),
(22, 13, 2, 3, 47, 1, 80, 80, 80, '2025-01-27 16:20:46', '2025-01-27 16:26:38'),
(23, 13, 2, 3, 48, 1, 80, 80, 80, '2025-01-27 16:20:46', '2025-01-27 16:26:38'),
(24, 13, 2, 3, 49, 1, 80, 80, 80, '2025-01-27 16:20:46', '2025-01-27 16:26:38'),
(25, 13, 2, 3, 50, 1, 80, 80, 80, '2025-01-27 16:20:46', '2025-01-27 16:26:38'),
(26, 13, 2, 3, 51, 1, 80, 80, 80, '2025-01-27 16:20:46', '2025-01-27 16:26:38'),
(27, 13, 2, 3, 52, 1, 80, 80, 80, '2025-01-27 16:20:46', '2025-01-27 16:26:38'),
(28, 13, 2, 3, 53, 1, 80, 80, 80, '2025-01-27 16:20:46', '2025-01-27 16:26:38'),
(29, 13, 2, 3, 54, 1, 80, 80, 80, '2025-01-27 16:20:46', '2025-01-27 16:26:38'),
(30, 13, 2, 3, 55, 1, 80, 80, 80, '2025-01-27 16:20:46', '2025-01-27 16:26:38');

-- --------------------------------------------------------

--
-- Struktur dari tabel `image_sliders`
--

DROP TABLE IF EXISTS `image_sliders`;
CREATE TABLE IF NOT EXISTS `image_sliders` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `caption` varchar(255) NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  `restored_at` datetime DEFAULT NULL,
  `created_by` bigint DEFAULT '0',
  `updated_by` bigint DEFAULT '0',
  `deleted_by` bigint DEFAULT '0',
  `restored_by` bigint DEFAULT '0',
  `is_deleted` enum('true','false') DEFAULT 'false',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;

--
-- Dumping data untuk tabel `image_sliders`
--

INSERT INTO `image_sliders` (`id`, `caption`, `image`, `created_at`, `updated_at`, `deleted_at`, `restored_at`, `created_by`, `updated_by`, `deleted_by`, `restored_by`, `is_deleted`) VALUES
(1, 'Welcome to MTSS YP AL-AZHAR', '16d62a009fa8cb6c44c011377c151995.png', '2023-01-29 03:50:24', '2024-12-24 09:44:01', NULL, NULL, 0, 1, 0, 0, 'false'),
(2, 'HUT RI ke 79', '74492dcf2452fc657302145882c72b6b.png', '2023-01-29 03:50:24', '2024-12-24 09:43:48', NULL, NULL, 0, 1, 0, 0, 'false');

-- --------------------------------------------------------

--
-- Struktur dari tabel `links`
--

DROP TABLE IF EXISTS `links`;
CREATE TABLE IF NOT EXISTS `links` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `link_title` varchar(255) NOT NULL,
  `link_url` varchar(255) DEFAULT NULL,
  `link_target` enum('_blank','_self','_parent','_top') DEFAULT '_blank',
  `link_image` varchar(100) DEFAULT NULL,
  `link_type` enum('link','banner') DEFAULT 'link',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  `restored_at` datetime DEFAULT NULL,
  `created_by` bigint DEFAULT '0',
  `updated_by` bigint DEFAULT '0',
  `deleted_by` bigint DEFAULT '0',
  `restored_by` bigint DEFAULT '0',
  `is_deleted` enum('true','false') DEFAULT 'false',
  PRIMARY KEY (`id`),
  UNIQUE KEY `__unique_key` (`link_url`,`link_type`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;

--
-- Dumping data untuk tabel `links`
--

INSERT INTO `links` (`id`, `link_title`, `link_url`, `link_target`, `link_image`, `link_type`, `created_at`, `updated_at`, `deleted_at`, `restored_at`, `created_by`, `updated_by`, `deleted_by`, `restored_by`, `is_deleted`) VALUES
(1, 'MadrasahKu', 'https://mtssypalazhar.sch.id', '_self', NULL, 'link', '2023-01-29 03:50:24', '2024-12-24 11:00:20', NULL, NULL, 0, 1, 0, 0, 'false'),
(2, 'MadrasahKu', 'http://#', '_blank', '2bae9109a2d46508a5cfe7503c86e996.jpeg', 'banner', '2023-01-29 03:50:24', '2024-12-25 10:03:14', NULL, NULL, 0, 1, 0, 0, 'false');

-- --------------------------------------------------------

--
-- Struktur dari tabel `login_attempts`
--

DROP TABLE IF EXISTS `login_attempts`;
CREATE TABLE IF NOT EXISTS `login_attempts` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `ip_address` varchar(45) NOT NULL,
  `counter` int UNSIGNED NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  `restored_at` datetime DEFAULT NULL,
  `created_by` bigint DEFAULT '0',
  `updated_by` bigint DEFAULT '0',
  `deleted_by` bigint DEFAULT '0',
  `restored_by` bigint DEFAULT '0',
  `is_deleted` enum('true','false') DEFAULT 'false',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Struktur dari tabel `majors`
--

DROP TABLE IF EXISTS `majors`;
CREATE TABLE IF NOT EXISTS `majors` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `major_name` varchar(255) DEFAULT NULL COMMENT 'Program Keahlian / Jurusan',
  `major_short_name` varchar(255) DEFAULT NULL COMMENT 'Nama Singkat',
  `is_active` enum('true','false') DEFAULT 'true',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  `restored_at` datetime DEFAULT NULL,
  `created_by` bigint DEFAULT '0',
  `updated_by` bigint DEFAULT '0',
  `deleted_by` bigint DEFAULT '0',
  `restored_by` bigint DEFAULT '0',
  `is_deleted` enum('true','false') DEFAULT 'false',
  PRIMARY KEY (`id`),
  UNIQUE KEY `major_name` (`major_name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;

--
-- Dumping data untuk tabel `majors`
--

INSERT INTO `majors` (`id`, `major_name`, `major_short_name`, `is_active`, `created_at`, `updated_at`, `deleted_at`, `restored_at`, `created_by`, `updated_by`, `deleted_by`, `restored_by`, `is_deleted`) VALUES
(1, 'Teknik Komputer dan Jaringan', 'TKJ', 'true', '2023-01-29 03:50:23', '2024-12-24 10:14:40', '2024-12-24 17:14:40', NULL, 0, 0, 1, 0, 'true'),
(2, 'Teknik Kendaraan Ringan', 'TKR', 'true', '2023-01-29 03:50:23', '2024-12-24 10:14:40', '2024-12-24 17:14:40', NULL, 0, 0, 1, 0, 'true'),
(3, 'Komputerisasi Akuntansi', 'KA', 'true', '2023-01-29 03:50:23', '2024-12-24 10:14:40', '2024-12-24 17:14:40', NULL, 0, 0, 1, 0, 'true');

-- --------------------------------------------------------

--
-- Struktur dari tabel `meeting_attendences`
--

DROP TABLE IF EXISTS `meeting_attendences`;
CREATE TABLE IF NOT EXISTS `meeting_attendences` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `class_meeting_id` bigint DEFAULT '0',
  `student_id` bigint DEFAULT '0',
  `presence` enum('present','sick','absent','permit') DEFAULT 'present',
  `note` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  `restored_at` datetime DEFAULT NULL,
  `created_by` bigint DEFAULT '0',
  `updated_by` bigint DEFAULT '0',
  `deleted_by` bigint DEFAULT '0',
  `restored_by` bigint DEFAULT '0',
  `is_deleted` enum('true','false') DEFAULT 'false',
  PRIMARY KEY (`id`),
  UNIQUE KEY `__unique_key` (`class_meeting_id`,`student_id`),
  KEY `meeting_attendences_class_meeting_id__idx` (`class_meeting_id`) USING BTREE,
  KEY `meeting_attendences_student_id__idx` (`student_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb3;

--
-- Dumping data untuk tabel `meeting_attendences`
--

INSERT INTO `meeting_attendences` (`id`, `class_meeting_id`, `student_id`, `presence`, `note`, `created_at`, `updated_at`, `deleted_at`, `restored_at`, `created_by`, `updated_by`, `deleted_by`, `restored_by`, `is_deleted`) VALUES
(1, 1, 26, 'present', '', '2024-12-24 10:55:32', NULL, NULL, NULL, 2, 0, 0, 0, 'false'),
(2, 1, 27, 'present', '', '2024-12-24 10:55:32', NULL, NULL, NULL, 2, 0, 0, 0, 'false'),
(3, 1, 28, 'present', '', '2024-12-24 10:55:32', NULL, NULL, NULL, 2, 0, 0, 0, 'false'),
(4, 1, 29, 'present', '', '2024-12-24 10:55:32', NULL, NULL, NULL, 2, 0, 0, 0, 'false'),
(5, 1, 30, 'present', '', '2024-12-24 10:55:32', NULL, NULL, NULL, 2, 0, 0, 0, 'false'),
(6, 1, 31, 'present', '', '2024-12-24 10:55:32', NULL, NULL, NULL, 2, 0, 0, 0, 'false'),
(7, 1, 32, 'present', '', '2024-12-24 10:55:32', NULL, NULL, NULL, 2, 0, 0, 0, 'false'),
(8, 1, 33, 'present', '', '2024-12-24 10:55:32', NULL, NULL, NULL, 2, 0, 0, 0, 'false'),
(9, 1, 34, 'present', '', '2024-12-24 10:55:32', NULL, NULL, NULL, 2, 0, 0, 0, 'false'),
(10, 1, 35, 'present', '', '2024-12-24 10:55:32', NULL, NULL, NULL, 2, 0, 0, 0, 'false'),
(11, 1, 36, 'present', '', '2024-12-24 10:55:32', NULL, NULL, NULL, 2, 0, 0, 0, 'false'),
(12, 1, 37, 'present', '', '2024-12-24 10:55:32', NULL, NULL, NULL, 2, 0, 0, 0, 'false'),
(13, 1, 38, 'present', '', '2024-12-24 10:55:32', NULL, NULL, NULL, 2, 0, 0, 0, 'false'),
(14, 1, 39, 'present', '', '2024-12-24 10:55:32', NULL, NULL, NULL, 2, 0, 0, 0, 'false'),
(15, 1, 40, 'present', '', '2024-12-24 10:55:32', NULL, NULL, NULL, 2, 0, 0, 0, 'false'),
(16, 1, 41, 'present', '', '2024-12-24 10:55:32', NULL, NULL, NULL, 2, 0, 0, 0, 'false'),
(17, 1, 42, 'present', '', '2024-12-24 10:55:32', NULL, NULL, NULL, 2, 0, 0, 0, 'false'),
(18, 1, 43, 'present', '', '2024-12-24 10:55:32', NULL, NULL, NULL, 2, 0, 0, 0, 'false'),
(19, 1, 44, 'present', '', '2024-12-24 10:55:32', NULL, NULL, NULL, 2, 0, 0, 0, 'false'),
(20, 1, 45, 'present', '', '2024-12-24 10:55:32', NULL, NULL, NULL, 2, 0, 0, 0, 'false'),
(21, 1, 46, 'present', '', '2024-12-24 10:55:32', NULL, NULL, NULL, 2, 0, 0, 0, 'false'),
(22, 1, 47, 'present', '', '2024-12-24 10:55:32', NULL, NULL, NULL, 2, 0, 0, 0, 'false'),
(23, 1, 48, 'present', '', '2024-12-24 10:55:32', NULL, NULL, NULL, 2, 0, 0, 0, 'false'),
(24, 1, 49, 'present', '', '2024-12-24 10:55:32', NULL, NULL, NULL, 2, 0, 0, 0, 'false'),
(25, 1, 50, 'present', '', '2024-12-24 10:55:32', NULL, NULL, NULL, 2, 0, 0, 0, 'false'),
(26, 1, 51, 'present', '', '2024-12-24 10:55:32', NULL, NULL, NULL, 2, 0, 0, 0, 'false'),
(27, 1, 52, 'present', '', '2024-12-24 10:55:32', NULL, NULL, NULL, 2, 0, 0, 0, 'false'),
(28, 1, 53, 'present', '', '2024-12-24 10:55:32', NULL, NULL, NULL, 2, 0, 0, 0, 'false'),
(29, 1, 54, 'present', '', '2024-12-24 10:55:32', NULL, NULL, NULL, 2, 0, 0, 0, 'false'),
(30, 1, 55, 'present', '', '2024-12-24 10:55:32', NULL, NULL, NULL, 2, 0, 0, 0, 'false');

-- --------------------------------------------------------

--
-- Struktur dari tabel `menus`
--

DROP TABLE IF EXISTS `menus`;
CREATE TABLE IF NOT EXISTS `menus` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `menu_title` varchar(150) NOT NULL,
  `menu_url` varchar(150) NOT NULL,
  `menu_target` enum('_blank','_self','_parent','_top') DEFAULT '_self',
  `menu_type` varchar(100) NOT NULL DEFAULT 'pages',
  `menu_parent_id` bigint DEFAULT '0',
  `menu_position` bigint DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  `restored_at` datetime DEFAULT NULL,
  `created_by` bigint DEFAULT '0',
  `updated_by` bigint DEFAULT '0',
  `deleted_by` bigint DEFAULT '0',
  `restored_by` bigint DEFAULT '0',
  `is_deleted` enum('true','false') DEFAULT 'false',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb3;

--
-- Dumping data untuk tabel `menus`
--

INSERT INTO `menus` (`id`, `menu_title`, `menu_url`, `menu_target`, `menu_type`, `menu_parent_id`, `menu_position`, `created_at`, `updated_at`, `deleted_at`, `restored_at`, `created_by`, `updated_by`, `deleted_by`, `restored_by`, `is_deleted`) VALUES
(1, 'PROFIL MADRASAH', 'read/2/profil', '', 'pages', 20, 1, '2023-01-29 03:50:24', '2024-12-24 10:01:56', NULL, '2024-12-24 17:00:17', 0, 1, 0, 1, 'false'),
(2, 'VISI DAN MISI', 'read/3/visi-dan-misi', '', 'pages', 20, 2, '2023-01-29 03:50:24', '2024-12-24 10:01:56', NULL, '2024-12-24 17:00:28', 0, 1, 0, 1, 'false'),
(3, 'Kategori', '#', '_self', 'links', 0, 2, '2023-01-29 03:50:24', '2024-12-24 10:01:56', NULL, NULL, 0, 0, 0, 0, 'false'),
(4, 'Direktori', '#', '_self', 'links', 0, 3, '2023-01-29 03:50:24', '2024-12-24 10:01:56', NULL, NULL, 0, 0, 0, 0, 'false'),
(5, 'Pendaftaran Alumni', 'pendaftaran-alumni', '_self', 'modules', 0, 4, '2023-01-29 03:50:24', '2024-12-24 10:01:56', NULL, NULL, 0, 0, 0, 0, 'false'),
(6, 'PPDB 2025', '#', '', 'links', 0, 5, '2023-01-29 03:50:24', '2024-12-24 10:01:56', NULL, '2024-12-24 17:01:19', 0, 1, 0, 1, 'false'),
(7, 'Galeri', '#', '_self', 'links', 0, 6, '2023-01-29 03:50:24', '2024-12-24 10:01:56', NULL, NULL, 0, 0, 0, 0, 'false'),
(8, 'Hubungi Kami', 'hubungi-kami', '_self', 'modules', 0, 8, '2023-01-29 03:50:24', '2024-12-24 13:54:40', NULL, NULL, 0, 0, 0, 0, 'false'),
(9, 'Galeri Foto', 'galeri-foto', '_self', 'modules', 7, 1, '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(10, 'Galeri Video', 'galeri-video', '_self', 'modules', 7, 2, '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(11, 'Daftar Sekarang', 'formulir-penerimaan-peserta-didik-baru', '_self', 'modules', 6, 1, '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(15, 'Berita', 'kategori/berita', '', 'post_categories', 3, 2, '2023-01-29 03:50:24', '2024-12-24 13:54:40', NULL, NULL, 0, 0, 0, 0, 'false'),
(16, 'Direktori Alumni', 'direktori-alumni', '_self', 'modules', 4, 1, '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(17, 'Direktori Guru dan Tenaga Kependidikan', 'direktori-guru-dan-tenaga-kependidikan', '_self', 'modules', 4, 2, '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(18, 'Direktori Peserta Didik', 'direktori-peserta-didik', '_self', 'modules', 4, 3, '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(19, 'SEJARAH MADRASAH', 'read/9/sejarah-madrasah', '_self', 'pages', 20, 3, '2024-12-24 10:00:35', '2024-12-24 10:01:56', NULL, NULL, 1, 0, 0, 0, 'false'),
(20, 'HOME', '#', '', 'links', 0, 1, '2024-12-24 10:00:54', '2024-12-24 10:02:17', NULL, '2024-12-24 17:02:17', 1, 1, 0, 1, 'false'),
(21, 'LOGIN', 'https://mtssypalazhar.sch.id/login', '_self', 'links', 0, 9, '2024-12-24 10:26:29', '2024-12-24 13:54:40', NULL, NULL, 1, 0, 0, 0, 'false'),
(22, 'APLIKASI', '#', '_self', 'links', 0, 7, '2024-12-24 11:15:10', '2024-12-24 13:54:40', NULL, NULL, 1, 0, 0, 0, 'false'),
(23, 'RDM', 'https://rdm.mtssypalazhar.sch.id/', '_blank', 'links', 22, 1, '2024-12-24 11:15:34', '2024-12-24 11:15:53', NULL, NULL, 1, 0, 0, 0, 'false'),
(25, 'Berkas', 'download/berkas', '_self', 'file_categories', 3, 1, '2024-12-24 11:22:52', '2024-12-24 13:54:40', NULL, NULL, 1, 0, 0, 0, 'false');

-- --------------------------------------------------------

--
-- Struktur dari tabel `modules`
--

DROP TABLE IF EXISTS `modules`;
CREATE TABLE IF NOT EXISTS `modules` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `module_name` varchar(255) NOT NULL,
  `module_description` varchar(255) DEFAULT NULL,
  `module_url` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  `restored_at` datetime DEFAULT NULL,
  `created_by` bigint DEFAULT '0',
  `updated_by` bigint DEFAULT '0',
  `deleted_by` bigint DEFAULT '0',
  `restored_by` bigint DEFAULT '0',
  `is_deleted` enum('true','false') DEFAULT 'false',
  PRIMARY KEY (`id`),
  UNIQUE KEY `module_name` (`module_name`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb3;

--
-- Dumping data untuk tabel `modules`
--

INSERT INTO `modules` (`id`, `module_name`, `module_description`, `module_url`, `created_at`, `updated_at`, `deleted_at`, `restored_at`, `created_by`, `updated_by`, `deleted_by`, `restored_by`, `is_deleted`) VALUES
(1, 'Pengguna', 'Pengguna', 'users', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(2, 'Akademik', 'Akademik', 'academic', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(3, 'PPDB', 'PPDB', 'admission', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(4, 'Tampilan', 'Tampilan', 'appearance', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(5, 'Blog', 'Blog', 'blog', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(6, 'Guru dan Tenaga Kependidikan', 'Guru dan Tenaga Kependidikan', 'employees', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(7, 'Media', 'Media', 'media', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(8, 'Plugins', 'Plugins', 'plugins', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(9, 'Data Induk', 'Data Induk', 'reference', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(10, 'Pengaturan', 'Pengaturan', 'settings', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false');

-- --------------------------------------------------------

--
-- Struktur dari tabel `options`
--

DROP TABLE IF EXISTS `options`;
CREATE TABLE IF NOT EXISTS `options` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `option_group` varchar(100) NOT NULL,
  `option_name` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  `restored_at` datetime DEFAULT NULL,
  `created_by` bigint DEFAULT '0',
  `updated_by` bigint DEFAULT '0',
  `deleted_by` bigint DEFAULT '0',
  `restored_by` bigint DEFAULT '0',
  `is_deleted` enum('true','false') DEFAULT 'false',
  PRIMARY KEY (`id`),
  UNIQUE KEY `__unique_key` (`option_group`,`option_name`),
  KEY `options_option_group__idx` (`option_group`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=176 DEFAULT CHARSET=utf8mb3;

--
-- Dumping data untuk tabel `options`
--

INSERT INTO `options` (`id`, `option_group`, `option_name`, `created_at`, `updated_at`, `deleted_at`, `restored_at`, `created_by`, `updated_by`, `deleted_by`, `restored_by`, `is_deleted`) VALUES
(1, 'student_status', 'Aktif', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(2, 'student_status', 'Lulus', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(3, 'student_status', 'Mutasi', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(4, 'student_status', 'Dikeluarkan', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(5, 'student_status', 'Mengundurkan Diri', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(6, 'student_status', 'Putus Sekolah', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(7, 'student_status', 'Meninggal', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(8, 'student_status', 'Hilang', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(9, 'student_status', 'Lainnya', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(10, 'employment', 'Tidak bekerja', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(11, 'employment', 'Nelayan', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(12, 'employment', 'Petani', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(13, 'employment', 'Peternak', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(14, 'employment', 'PNS/TNI/POLRI', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(15, 'employment', 'Karyawan Swasta', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(16, 'employment', 'Pedagang Kecil', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(17, 'employment', 'Pedagang Besar', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(18, 'employment', 'Wiraswasta', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(19, 'employment', 'Wirausaha', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(20, 'employment', 'Buruh', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(21, 'employment', 'Pensiunan', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(22, 'employment', 'Lain-lain', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(23, 'special_need', 'Tidak', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(24, 'special_need', 'Tuna Netra', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(25, 'special_need', 'Tuna Rungu', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(26, 'special_need', 'Tuna Grahita ringan', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(27, 'special_need', 'Tuna Grahita Sedang', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(28, 'special_need', 'Tuna Daksa Ringan', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(29, 'special_need', 'Tuna Daksa Sedang', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(30, 'special_need', 'Tuna Laras', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(31, 'special_need', 'Tuna Wicara', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(32, 'special_need', 'Tuna ganda', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(33, 'special_need', 'Hiper aktif', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(34, 'special_need', 'Cerdas Istimewa', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(35, 'special_need', 'Bakat Istimewa', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(36, 'special_need', 'Kesulitan Belajar', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(37, 'special_need', 'Narkoba', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(38, 'special_need', 'Indigo', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(39, 'special_need', 'Down Sindrome', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(40, 'special_need', 'Autis', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(41, 'special_need', 'Lainnya', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(42, 'education', 'Tidak sekolah', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(43, 'education', 'Putus SD', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(44, 'education', 'SD Sederajat', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(45, 'education', 'SMP Sederajat', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(46, 'education', 'SMA Sederajat', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(47, 'education', 'D1', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(48, 'education', 'D2', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(49, 'education', 'D3', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(50, 'education', 'D4/S1', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(51, 'education', 'S2', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(52, 'education', 'S3', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(53, 'scholarship', 'Anak berprestasi', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(54, 'scholarship', 'Anak Miskin', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(55, 'scholarship', 'Pendidikan', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(56, 'scholarship', 'Unggulan', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(57, 'scholarship', 'Lain-lain', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(58, 'achievement_type', 'Sains', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(59, 'achievement_type', 'Seni', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(60, 'achievement_type', 'Olahraga', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(61, 'achievement_type', 'Lain-lain', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(62, 'achievement_level', 'Sekolah', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(63, 'achievement_level', 'Kecamatan', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(64, 'achievement_level', 'Kabupaten', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(65, 'achievement_level', 'Propinsi', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(66, 'achievement_level', 'Nasional', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(67, 'achievement_level', 'Internasional', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(68, 'monthly_income', 'Kurang dari Rp 1.000.000', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(69, 'monthly_income', 'Rp 1.000.000 - Rp 2.000.000', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(70, 'monthly_income', 'Lebih dari Rp 2.000.000', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(71, 'monthly_income', 'Kurang dari Rp. 500,000', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(72, 'monthly_income', 'Rp. 500,000 - Rp. 999,999', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(73, 'monthly_income', 'Rp. 1,000,000 - Rp. 1,999,999', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(74, 'monthly_income', 'Rp. 2,000,000 - Rp. 4,999,999', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(75, 'monthly_income', 'Rp. 5,000,000 - Rp. 20,000,000', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(76, 'monthly_income', 'Lebih dari Rp. 20,000,000', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(77, 'monthly_income', 'Tidak Berpenghasilan', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(78, 'monthly_income', 'Lainnya', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(79, 'residence', 'Bersama orang tua', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(80, 'residence', 'Wali', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(81, 'residence', 'Kos', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(82, 'residence', 'Asrama', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(83, 'residence', 'Panti Asuhan', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(84, 'residence', 'Lainnya', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(85, 'transportation', 'Jalan kaki', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(86, 'transportation', 'Kendaraan pribadi', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(87, 'transportation', 'Kendaraan Umum / angkot / Pete-pete', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(88, 'transportation', 'Jemputan Sekolah', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(89, 'transportation', 'Kereta Api', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(90, 'transportation', 'Ojek', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(91, 'transportation', 'Andong / Bendi / Sado / Dokar / Delman / Beca', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(92, 'transportation', 'Perahu penyebrangan / Rakit / Getek', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(93, 'transportation', 'Lainnya', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(94, 'religion', 'Islam', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(95, 'religion', 'Kristen / Protestan', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(96, 'religion', 'Katholik', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(97, 'religion', 'Hindu', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(98, 'religion', 'Budha', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(99, 'religion', 'Khong Hu Chu', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(100, 'religion', 'Lainnya', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(101, 'school_level', '1 - Sekolah Dasar (SD) / Sederajat', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(102, 'school_level', '2 - Sekolah Menengah Pertama (SMP) / Sederajat', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(103, 'school_level', '3 - Sekolah Menengah Atas (SMA) / Aliyah', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(104, 'school_level', '4 - Sekolah Menengah Kejuruan (SMK)', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(105, 'marriage_status', 'Menikah', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(106, 'marriage_status', 'Belum Menikah', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(107, 'marriage_status', 'Berpisah', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(108, 'institution_lifter', 'Pemerintah Pusat', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(109, 'institution_lifter', 'Pemerintah Provinsi', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(110, 'institution_lifter', 'Pemerintah Kab / Kota', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(111, 'institution_lifter', 'Ketua Yayasan', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(112, 'institution_lifter', 'Kepala Sekolah', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(113, 'institution_lifter', 'Komite Sekolah', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(114, 'institution_lifter', 'Lainnya', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(115, 'employment_status', 'PNS', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(116, 'employment_status', 'PNS Diperbantukan', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(117, 'employment_status', 'PNS DEPAG', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(118, 'employment_status', 'GTY / PTY', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(119, 'employment_status', 'GTT / PTT Provinsi', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(120, 'employment_status', 'GTT / PTT Kabupaten / Kota', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(121, 'employment_status', 'Guru Bantu Pusat', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(122, 'employment_status', 'Guru Honor Sekolah', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(123, 'employment_status', 'Tenaga Honor Sekolah', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(124, 'employment_status', 'CPNS', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(125, 'employment_status', 'Lainnya', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(126, 'employment_type', 'Guru Kelas', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(127, 'employment_type', 'Guru Mata Pelajaran', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(128, 'employment_type', 'Guru BK', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(129, 'employment_type', 'Guru Inklusi', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(130, 'employment_type', 'Tenaga Administrasi Sekolah', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(131, 'employment_type', 'Guru Pendamping', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(132, 'employment_type', 'Guru Magang', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(133, 'employment_type', 'Guru TIK', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(134, 'employment_type', 'Laboran', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(135, 'employment_type', 'Pustakawan', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(136, 'employment_type', 'Lainnya', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(137, 'rank', 'I/A', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(138, 'rank', 'I/B', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(139, 'rank', 'I/C', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(140, 'rank', 'I/D', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(141, 'rank', 'II/A', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(142, 'rank', 'II/B', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(143, 'rank', 'II/C', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(144, 'rank', 'II/D', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(145, 'rank', 'III/A', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(146, 'rank', 'III/B', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(147, 'rank', 'III/C', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(148, 'rank', 'III/D', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(149, 'rank', 'IV/A', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(150, 'rank', 'IV/B', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(151, 'rank', 'IV/C', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(152, 'rank', 'IV/D', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(153, 'rank', 'IV/E', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(154, 'salary_source', 'APBN', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(155, 'salary_source', 'APBD Provinsi', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(156, 'salary_source', 'APBD Kab / Kota', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(157, 'salary_source', 'Yayasan', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(158, 'salary_source', 'Sekolah', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(159, 'salary_source', 'Lembaga Donor', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(160, 'salary_source', 'Lainnya', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(161, 'laboratory_skill', 'Lab IPA', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(162, 'laboratory_skill', 'Lab Fisika', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(163, 'laboratory_skill', 'Lab Biologi', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(164, 'laboratory_skill', 'Lab Kimia', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(165, 'laboratory_skill', 'Lab Bahasa', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(166, 'laboratory_skill', 'Lab Komputer', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(167, 'laboratory_skill', 'Teknik Bangunan', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(168, 'laboratory_skill', 'Teknik Survei & Pemetaan', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(169, 'laboratory_skill', 'Teknik Ketenagakerjaan', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(170, 'laboratory_skill', 'Teknik Pendinginan & Tata Udara', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(171, 'laboratory_skill', 'Teknik Mesin', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(172, 'building', 'Gedung Lama', '2023-01-29 03:50:24', '2024-12-24 10:10:14', NULL, NULL, 0, 1, 0, 0, 'false'),
(173, 'building', 'Gedung Baru', '2023-01-29 03:50:24', '2024-12-24 10:10:20', NULL, NULL, 0, 1, 0, 0, 'false'),
(174, 'admission_type', 'Umum', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(175, 'admission_type', 'Prestasi', '2023-01-29 03:50:24', '2025-01-07 00:56:09', '2025-01-07 07:56:09', NULL, 0, 0, 1, 0, 'true');

-- --------------------------------------------------------

--
-- Struktur dari tabel `photos`
--

DROP TABLE IF EXISTS `photos`;
CREATE TABLE IF NOT EXISTS `photos` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `photo_album_id` bigint DEFAULT '0',
  `photo_name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  `restored_at` datetime DEFAULT NULL,
  `created_by` bigint DEFAULT '0',
  `updated_by` bigint DEFAULT '0',
  `deleted_by` bigint DEFAULT '0',
  `restored_by` bigint DEFAULT '0',
  `is_deleted` enum('true','false') DEFAULT 'false',
  PRIMARY KEY (`id`),
  KEY `photos_photo_album_id__idx` (`photo_album_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Struktur dari tabel `pollings`
--

DROP TABLE IF EXISTS `pollings`;
CREATE TABLE IF NOT EXISTS `pollings` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `answer_id` bigint DEFAULT '0',
  `ip_address` varchar(45) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  `restored_at` datetime DEFAULT NULL,
  `created_by` bigint DEFAULT '0',
  `updated_by` bigint DEFAULT '0',
  `deleted_by` bigint DEFAULT '0',
  `restored_by` bigint DEFAULT '0',
  `is_deleted` enum('true','false') DEFAULT 'false',
  PRIMARY KEY (`id`),
  KEY `pollings_answer_id__idx` (`answer_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Struktur dari tabel `posts`
--

DROP TABLE IF EXISTS `posts`;
CREATE TABLE IF NOT EXISTS `posts` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `post_title` varchar(255) DEFAULT NULL,
  `post_content` longtext,
  `post_image` varchar(100) DEFAULT NULL,
  `post_author` bigint DEFAULT '0',
  `post_categories` varchar(255) DEFAULT NULL,
  `post_type` varchar(50) NOT NULL DEFAULT 'post',
  `post_status` enum('publish','draft') DEFAULT 'draft',
  `post_visibility` enum('public','private') DEFAULT 'public',
  `post_comment_status` enum('open','close') DEFAULT 'close',
  `post_slug` varchar(255) DEFAULT NULL,
  `post_tags` varchar(255) DEFAULT NULL,
  `post_counter` bigint DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  `restored_at` datetime DEFAULT NULL,
  `created_by` bigint DEFAULT '0',
  `updated_by` bigint DEFAULT '0',
  `deleted_by` bigint DEFAULT '0',
  `restored_by` bigint DEFAULT '0',
  `is_deleted` enum('true','false') DEFAULT 'false',
  PRIMARY KEY (`id`),
  KEY `posts_post_author__idx` (`post_author`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb3;

--
-- Dumping data untuk tabel `posts`
--

INSERT INTO `posts` (`id`, `post_title`, `post_content`, `post_image`, `post_author`, `post_categories`, `post_type`, `post_status`, `post_visibility`, `post_comment_status`, `post_slug`, `post_tags`, `post_counter`, `created_at`, `updated_at`, `deleted_at`, `restored_at`, `created_by`, `updated_by`, `deleted_by`, `restored_by`, `is_deleted`) VALUES
(1, NULL, '<p style=\"margin-top: 0cm; text-align: justify; background: white;\"><span style=\"font-family: \'Helvetica\',\'sans-serif\'; color: #212529;\">&nbsp;<strong style=\"box-sizing: border-box;\"><span style=\"font-family: \'Helvetica\',\'sans-serif\';\">Assalamu\'alaikum warahmatullahi wabarakatuh,</span></strong></span></p>\n<p style=\"margin-top: 0cm; text-align: justify; background: white; box-sizing: border-box; margin-bottom: 1rem; font-variant-ligatures: normal; font-variant-caps: normal; orphans: 2; widows: 2; -webkit-text-stroke-width: 0px; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; word-spacing: 0px;\"><span style=\"font-family: \'Helvetica\',\'sans-serif\'; color: #212529;\"><br style=\"box-sizing: border-box;\" /> Alhamdulillah, puji syukur kita panjatkan ke hadirat Allah SWT atas segala rahmat, karunia, dan nikmat-Nya yang tiada terhingga. Dengan izin-Nya, Madrasah kami dapat terus berkembang dan berkomitmen dalam mencetak generasi penerus yang berakhlakul karimah, cerdas, dan berkompeten dalam berbagai bidang ilmu.</span></p>\n<p style=\"margin-top: 0cm; text-align: justify; background: white; box-sizing: border-box; margin-bottom: 1rem; font-variant-ligatures: normal; font-variant-caps: normal; orphans: 2; widows: 2; -webkit-text-stroke-width: 0px; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; word-spacing: 0px;\"><span style=\"font-family: \'Helvetica\',\'sans-serif\'; color: #212529;\">Sebagai lembaga pendidikan yang mengintegrasikan antara ilmu agama dan umum, kami berusaha untuk memberikan pendidikan yang berkualitas dan relevan dengan perkembangan zaman, namun tetap menjaga nilai-nilai islami dalam setiap aspek kehidupan sehari-hari. Di Madrasah kami, setiap siswa tidak hanya dididik untuk menjadi insan yang cerdas secara intelektual, tetapi juga diharapkan memiliki karakter yang mulia, empati, dan rasa tanggung jawab sosial yang tinggi.</span></p>\n<p style=\"margin-top: 0cm; text-align: justify; background: white; box-sizing: border-box; margin-bottom: 1rem; font-variant-ligatures: normal; font-variant-caps: normal; orphans: 2; widows: 2; -webkit-text-stroke-width: 0px; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; word-spacing: 0px;\"><span style=\"font-family: \'Helvetica\',\'sans-serif\'; color: #212529;\">Kami percaya bahwa pendidikan adalah kunci untuk membuka masa depan yang lebih baik, baik bagi individu maupun bangsa. Oleh karena itu, kami terus berinovasi dalam metode pengajaran, fasilitas, dan pendekatan yang holistik agar setiap siswa dapat berkembang sesuai dengan potensi terbaik mereka.</span></p>\n<p style=\"margin-top: 0cm; text-align: justify; background: white; box-sizing: border-box; margin-bottom: 1rem; font-variant-ligatures: normal; font-variant-caps: normal; orphans: 2; widows: 2; -webkit-text-stroke-width: 0px; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; word-spacing: 0px;\"><span style=\"font-family: \'Helvetica\',\'sans-serif\'; color: #212529;\">Di samping itu, kami sangat mengutamakan peran serta orang tua dan masyarakat dalam mendukung proses pendidikan di Madrasah. Kolaborasi antara guru, siswa, orang tua, dan pihak terkait lainnya sangat penting untuk mewujudkan visi dan misi Madrasah kami.</span></p>\n<p style=\"margin-top: 0cm; text-align: justify; background: white; box-sizing: border-box; margin-bottom: 1rem; font-variant-ligatures: normal; font-variant-caps: normal; orphans: 2; widows: 2; -webkit-text-stroke-width: 0px; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; word-spacing: 0px;\"><span style=\"font-family: \'Helvetica\',\'sans-serif\'; color: #212529;\">Kami berharap bahwa melalui website ini, Anda dapat mendapatkan informasi yang lengkap mengenai program pendidikan, kegiatan, dan prestasi yang telah kami capai, serta dapat lebih dekat dengan kami dalam mewujudkan cita-cita luhur mendidik generasi penerus bangsa.</span></p>\n<p style=\"margin-top: 0cm; text-align: justify; background: white; box-sizing: border-box; margin-bottom: 1rem; font-variant-ligatures: normal; font-variant-caps: normal; orphans: 2; widows: 2; -webkit-text-stroke-width: 0px; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; word-spacing: 0px;\"><span style=\"font-family: \'Helvetica\',\'sans-serif\'; color: #212529;\">Mari bersama-sama kita ciptakan lingkungan pendidikan yang penuh semangat, kedamaian, dan keberkahan. Semoga Allah SWT senantiasa memberikan petunjuk-Nya kepada kita semua dalam setiap langkah yang kita ambil.</span></p>\n<p style=\"margin-top: 0cm; text-align: justify; background: white; box-sizing: border-box; margin-bottom: 1rem; font-variant-ligatures: normal; font-variant-caps: normal; orphans: 2; widows: 2; -webkit-text-stroke-width: 0px; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; word-spacing: 0px;\"><strong style=\"box-sizing: border-box;\"><span style=\"font-family: \'Helvetica\',\'sans-serif\'; color: #212529;\">Wassalamu\'alaikum warahmatullahi wabarakatuh.</span></strong></p>\n<p style=\"margin-top: 0cm; text-align: justify; background: white; box-sizing: border-box; margin-bottom: 1rem; font-variant-ligatures: normal; font-variant-caps: normal; orphans: 2; widows: 2; -webkit-text-stroke-width: 0px; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; word-spacing: 0px;\"><span style=\"font-family: \'Helvetica\',\'sans-serif\'; color: #212529;\">&nbsp;</span></p>\n<p style=\"margin-top: 0cm; text-align: justify; background: white; box-sizing: border-box; margin-bottom: 1rem; font-variant-ligatures: normal; font-variant-caps: normal; orphans: 2; widows: 2; -webkit-text-stroke-width: 0px; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; word-spacing: 0px;\"><span style=\"font-family: \'Helvetica\',\'sans-serif\'; color: #212529;\">Kepala MTSS YP AL AZHAR</span></p>\n<p style=\"margin-top: 0cm; text-align: justify; background: white; box-sizing: border-box; margin-bottom: 1rem; font-variant-ligatures: normal; font-variant-caps: normal; orphans: 2; widows: 2; -webkit-text-stroke-width: 0px; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; word-spacing: 0px;\"><strong style=\"box-sizing: border-box;\"><span style=\"font-family: \'Helvetica\',\'sans-serif\'; color: #212529;\">Donny, S.S.</span></strong></p>', NULL, 0, NULL, 'opening_speech', '', 'public', 'close', NULL, NULL, 0, '2023-01-29 03:50:24', '2024-12-24 09:59:06', NULL, NULL, 0, 1, 0, 0, 'false'),
(2, 'PROFIL MADRASAH', '<table style=\"width: 569px;\">\n<tbody>\n<tr>\n<td style=\"width: 268.016px;\">Data Umum</td>\n<td style=\"width: 282.984px;\">&nbsp;</td>\n</tr>\n<tr>\n<td style=\"width: 268.016px;\">Nomor Statistik Madrasah</td>\n<td style=\"width: 282.984px;\">: 121212710048</td>\n</tr>\n<tr>\n<td style=\"width: 268.016px;\">Nomor Pokok Sekolah Nasional</td>\n<td style=\"width: 282.984px;\">: 10264592</td>\n</tr>\n<tr>\n<td style=\"width: 268.016px;\">Nama Madrasah</td>\n<td style=\"width: 282.984px;\">: MTSS YP Al Azhar</td>\n</tr>\n<tr>\n<td style=\"width: 268.016px;\">Status</td>\n<td style=\"width: 282.984px;\">: Swasta</td>\n</tr>\n<tr>\n<td style=\"width: 268.016px;\">Data Kurikulum</td>\n<td style=\"width: 282.984px;\">: Kurikulum Merdeka</td>\n</tr>\n<tr>\n<td style=\"width: 268.016px;\">&nbsp;</td>\n<td style=\"width: 282.984px;\">&nbsp;</td>\n</tr>\n<tr>\n<td style=\"width: 268.016px;\">Alamat Madrasah</td>\n<td style=\"width: 282.984px;\">&nbsp;</td>\n</tr>\n<tr>\n<td style=\"width: 268.016px;\">Jalan/Kampung &amp; RT/RW</td>\n<td style=\"width: 282.984px;\">: Jl. Merak Gg. Nirwana No. 65 F</td>\n</tr>\n<tr>\n<td style=\"width: 268.016px;\">Provinsi</td>\n<td style=\"width: 282.984px;\">: Sumatera Utara</td>\n</tr>\n<tr>\n<td style=\"width: 268.016px;\">Kabupaten/Kota</td>\n<td style=\"width: 282.984px;\">:&nbsp; Kota Medan</td>\n</tr>\n<tr>\n<td style=\"width: 268.016px;\">Kecamatan</td>\n<td style=\"width: 282.984px;\">: Medan Sunggal</td>\n</tr>\n<tr>\n<td style=\"width: 268.016px;\">Desa/Kelurahan</td>\n<td style=\"width: 282.984px;\">: Sei Sikambing B</td>\n</tr>\n<tr>\n<td style=\"width: 268.016px;\">Nomor Telepon</td>\n<td style=\"width: 282.984px;\">:&nbsp;061 &ndash; 8458955</td>\n</tr>\n<tr>\n<td style=\"width: 268.016px;\">Kode POS</td>\n<td style=\"width: 282.984px;\">: 20122</td>\n</tr>\n<tr>\n<td style=\"width: 268.016px;\">Koordinat</td>\n<td style=\"width: 282.984px;\">&nbsp;</td>\n</tr>\n<tr>\n<td style=\"width: 268.016px;\">Longitude</td>\n<td style=\"width: 282.984px;\">:&nbsp;3.584307</td>\n</tr>\n<tr>\n<td style=\"width: 268.016px;\">Latitude</td>\n<td style=\"width: 282.984px;\">:&nbsp;98.628337</td>\n</tr>\n<tr>\n<td style=\"width: 268.016px;\">&nbsp;</td>\n<td style=\"width: 282.984px;\">&nbsp;</td>\n</tr>\n<tr>\n<td style=\"width: 268.016px;\">Dokumen Perijinan dan Akreditasi</td>\n<td style=\"width: 282.984px;\">&nbsp;</td>\n</tr>\n<tr>\n<td style=\"width: 268.016px;\">Nomor SK Pendirian</td>\n<td style=\"width: 282.984px;\">:&nbsp;AHU-0025521.AH.01.12.TAHUN 2019</td>\n</tr>\n<tr>\n<td style=\"width: 268.016px;\">Tanggal SK Pendirian</td>\n<td style=\"width: 282.984px;\">:&nbsp;21 Desember 2019</td>\n</tr>\n<tr>\n<td style=\"width: 268.016px;\">Nomor SK Ijin Operasional</td>\n<td style=\"width: 282.984px;\">:&nbsp;1289 Tahun 2019</td>\n</tr>\n<tr>\n<td style=\"width: 268.016px;\">Tanggal SK Ijin Operasional</td>\n<td style=\"width: 282.984px;\">:&nbsp;21 Oktober 2019</td>\n</tr>\n<tr>\n<td style=\"width: 268.016px;\">Status Akreditasi</td>\n<td style=\"width: 282.984px;\">:&nbsp;Unggul</td>\n</tr>\n<tr>\n<td style=\"width: 268.016px;\">Nomor SK Akreditasi</td>\n<td style=\"width: 282.984px;\">:&nbsp;789/BANSM/PROVSU/LL/X/2018</td>\n</tr>\n<tr>\n<td style=\"width: 268.016px;\">Tanggal SK Akreditasi</td>\n<td style=\"width: 282.984px;\">:&nbsp;10 Oktober 2018</td>\n</tr>\n</tbody>\n</table>\n<p>&nbsp;</p>', NULL, 1, '+1+', 'page', 'publish', 'public', 'close', 'profil-madrasah', 'berita, pengumuman, sekilas-info', 23, '2023-01-29 03:50:24', '2025-01-09 01:38:43', NULL, NULL, 0, 1, 0, 0, 'false'),
(3, 'VISI DAN MISI', '<p><em>Visi</em></p>\n<p>&ldquo; Mewujudkan Sumber Daya Manusia (SDM) yang memiliki Skill serta Profesional dibidang Institusional ditengah-tengah Masyarakat yang Madani &ldquo;</p>\n<p>&nbsp;</p>\n<p><em>Misi</em></p>\n<ul>\n<li>Mempersiapkan Sarana dan Prasarana Pendidikan yang di Handalkan;</li>\n<li>Membekali Peserta Didik yang siap Pakai, dalam bidang keagamaan dan Pengetahuan Umum;</li>\n<li>Meningkatkan Kualitas Pengajaran Guru;</li>\n<li>Memenuhi Kebutuhan Peserta Didik, Guru dan Fungsional Madrasah yang seimbang dan sesuai.</li>\n</ul>', NULL, 1, '+1+', 'page', 'publish', 'public', 'close', 'visi-dan-misi', 'berita, pengumuman, sekilas-info', 10, '2023-01-29 03:50:24', '2025-01-09 01:38:44', NULL, NULL, 0, 1, 0, 0, 'false'),
(4, 'Sample Post 1', '<p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>', '400x250.png', 1, '+1+', 'post', 'publish', 'public', 'open', 'sample-post-1', 'berita, pengumuman, sekilas-info', 8, '2023-01-29 03:50:24', '2025-01-06 10:17:25', NULL, NULL, 0, 0, 0, 0, 'false'),
(5, 'Sample Post 2', '<p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>', '400x250.png', 1, '+1+', 'post', 'publish', 'public', 'open', 'sample-post-2', 'berita, pengumuman, sekilas-info', 4, '2023-01-29 03:50:24', '2025-01-07 12:52:01', NULL, NULL, 0, 0, 0, 0, 'false'),
(6, 'Sample Post 3', '<p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>', '400x250.png', 1, '+1+', 'post', 'publish', 'public', 'open', 'sample-post-3', 'berita, pengumuman, sekilas-info', 4, '2023-01-29 03:50:24', '2025-01-08 22:48:15', NULL, NULL, 0, 0, 0, 0, 'false'),
(7, 'Sample Post 4', '<p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>', '400x250.png', 1, '+1+', 'post', 'publish', 'public', 'open', 'sample-post-4', 'berita, pengumuman, sekilas-info', 4, '2023-01-29 03:50:24', '2025-01-07 13:51:02', NULL, NULL, 0, 0, 0, 0, 'false'),
(8, 'Sample Post 5', '<p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>', '400x250.png', 1, '+1+', 'post', 'publish', 'public', 'open', 'sample-post-5', 'berita, pengumuman, sekilas-info', 3, '2023-01-29 03:50:24', '2025-01-04 19:23:47', NULL, NULL, 0, 0, 0, 0, 'false'),
(9, 'SEJARAH MADRASAH', '<p style=\"margin-top: 0cm; text-align: justify; background: white;\"><strong><span style=\"font-family: \'Helvetica\',\'sans-serif\'; color: #212529;\">Sejarah berdirinya</span></strong></p>\n<p style=\"margin-top: 0cm; text-align: justify; background: white; box-sizing: border-box; margin-bottom: 1rem; font-variant-ligatures: normal; font-variant-caps: normal; orphans: 2; widows: 2; -webkit-text-stroke-width: 0px; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; word-spacing: 0px;\"><span style=\"font-family: \'Helvetica\',\'sans-serif\'; color: #212529;\">Bahwa dikelurahan Sei Sikambing B Jl. Balam No. 52 telah berdiri Yayasan Swadaya Masyarakat yang membina SD/MI. Yayasan Swadaya Masyarakat ini dipimpin oleh almarhum Asman Hutagalung yang pada waktu itu menjabat sebagai Lurah Sei Sikambing B, dan sekretaris atau seksi bidang kependidikan adalah Drs. H. Hisbullah Hamid (Pendiri Yayasan Perguruan Al Azhar Medan Sunggal).</span></p>\n<p style=\"margin-top: 0cm; text-align: justify; background: white; box-sizing: border-box; margin-bottom: 1rem; font-variant-ligatures: normal; font-variant-caps: normal; orphans: 2; widows: 2; -webkit-text-stroke-width: 0px; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; word-spacing: 0px;\"><span style=\"font-family: \'Helvetica\',\'sans-serif\'; color: #212529;\">Berdasarkan keputusan pengurus Yayasan beserta para Pendiri dan Pemuka Masyarakat, Yayasan Swadaya Masyarakat diserahkan kepada Depertemen Agama untuk dijadikan MIN (Madrasah Ibtidaiyah Negeri) dan diresmikan oleh Menteri Agama.</span></p>\n<p style=\"margin-top: 0cm; text-align: justify; background: white; box-sizing: border-box; margin-bottom: 1rem; font-variant-ligatures: normal; font-variant-caps: normal; orphans: 2; widows: 2; -webkit-text-stroke-width: 0px; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; word-spacing: 0px;\"><span style=\"font-family: \'Helvetica\',\'sans-serif\'; color: #212529;\">Dalam perkembangannya, MIN yang dikepalai oleh Dra. Hj. Halawani (Sekretaris Yayasan Perguruan Al Azhar Medan Sunggal) berkembang pesat. Untuk menampung tamatan MIN sebagai lanjutan ke jenjang pendidikan yang lebih tinggi, maka dibangunlah MTs Al Azhar Medan Sunggal yang didirikan pada tanggal 2 Mei 1995, bertempat di Jl. Merak Gg. Nirwana No. 65 F Sei Sikambing B Medan Sunggal 20122 Telp. (061) 8458955 (bersebelahan dengan MIN 6 Kota Medan).</span></p>\n<p style=\"margin-top: 0cm; text-align: justify; background: white; box-sizing: border-box; margin-bottom: 1rem; font-variant-ligatures: normal; font-variant-caps: normal; orphans: 2; widows: 2; -webkit-text-stroke-width: 0px; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; word-spacing: 0px;\"><span style=\"font-family: \'Helvetica\',\'sans-serif\'; color: #212529;\">Lain daripada itu, MTs Al Azhar Medan Sunggal berdiri untuk membantu pendidikan bagi masyarakat yang kurang mampu yang terpuruk akibat krisis moneter, karena Pendiri Yayasan Perguruan Al Azhar Medan Sunggal (Drs. H. Hisbullah Hamid) berperinsip : &ldquo;&nbsp;<em style=\"box-sizing: border-box;\"><span style=\"font-family: \'Helvetica\',\'sans-serif\';\">Jangan sampai ummat Islam yang kurang mampu tidak dapat merasakan pendidikan&rdquo;</span></em>.</span></p>\n<p style=\"margin-top: 0cm; text-align: justify; background: white; box-sizing: border-box; margin-bottom: 1rem; font-variant-ligatures: normal; font-variant-caps: normal; orphans: 2; widows: 2; -webkit-text-stroke-width: 0px; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; word-spacing: 0px;\"><span style=\"font-family: \'Helvetica\',\'sans-serif\'; color: #212529;\">Yayasan Perguruan Al Azhar berdiri untuk mengamalkan perintah Allah Subehanahu Wataala yang terdapat dalam Al Qur&rsquo;an Surah Al Mujadalah Ayat 11 yang artinya:&nbsp;<em style=\"box-sizing: border-box;\"><span style=\"font-family: \'Helvetica\',\'sans-serif\';\">&ldquo; Niscahya Allah akan meninggikan orang orang yang beriman di antaramu dan orang orang yang diberi ilmu pengetahuan beberapa derajat&rdquo;</span></em>, dan Hadits Nabi Muhammad Sallahu Alaihi Wassalam yang artinya :&nbsp;<em style=\"box-sizing: border-box;\"><span style=\"font-family: \'Helvetica\',\'sans-serif\';\">&ldquo;Barang siapa ingin kebahagiaan didunia, maka haruslah ia berilmu dan barang siapa ingin kebahagiaan diakhirat, maka haruslah ia berilmu&rdquo;.</span></em>&nbsp;Selain itu juga membantu pemerintah dalam mencerdaskan bangsa yang tertuang didalam Pembukaan UUD 1945 Alenia ke 4 yang berbunyi&nbsp;<em style=\"box-sizing: border-box;\"><span style=\"font-family: \'Helvetica\',\'sans-serif\';\">&ldquo;... melindungi segenap bangsa Indonesia dan seluruh tumpah darah Indonesia dan untuk memajukan kesejahteraan umum, mencerdaskan kehidupan bangsa dan ikut melaksanakan ketertiban dunia ...&rdquo;</span></em>.</span></p>\n<p style=\"margin-top: 0cm; text-align: justify; background: white; box-sizing: border-box; margin-bottom: 1rem; font-variant-ligatures: normal; font-variant-caps: normal; orphans: 2; widows: 2; -webkit-text-stroke-width: 0px; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; word-spacing: 0px;\"><span style=\"font-family: \'Helvetica\',\'sans-serif\'; color: #212529;\">&nbsp;</span></p>\n<p style=\"margin-top: 0cm; text-align: justify; background: white; box-sizing: border-box; margin-bottom: 1rem; font-variant-ligatures: normal; font-variant-caps: normal; orphans: 2; widows: 2; -webkit-text-stroke-width: 0px; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; word-spacing: 0px;\"><strong style=\"box-sizing: border-box;\"><span style=\"font-family: \'Helvetica\',\'sans-serif\'; color: #212529;\">Perkembangannya</span></strong></p>\n<p style=\"margin-top: 0cm; text-align: justify; background: white; box-sizing: border-box; margin-bottom: 1rem; font-variant-ligatures: normal; font-variant-caps: normal; orphans: 2; widows: 2; -webkit-text-stroke-width: 0px; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; word-spacing: 0px;\"><span style=\"font-family: \'Helvetica\',\'sans-serif\'; color: #212529;\">Yayasan Perguruan Al Azhar Medan Sunggal pada saat ini telah berumur 24 (duapuluh empat) tahun dan mengeluarkan tamatan tingkat MTs/SMP sebanyak 128 pada tahun 2019 angkatan ke XXII (duapuluh dua). Pada tahun pelajaran 2019/2020 ini jumlah siswa siswi kelas VII (Tujuh) 167 Orang, kelas VIII (Delapan) 169 Orang dan kelas IX (Sembilan) 137 Orang.</span></p>\n<p style=\"margin-top: 0cm; text-align: justify; background: white; box-sizing: border-box; margin-bottom: 1rem; font-variant-ligatures: normal; font-variant-caps: normal; orphans: 2; widows: 2; -webkit-text-stroke-width: 0px; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; word-spacing: 0px;\"><span style=\"font-family: \'Helvetica\',\'sans-serif\'; color: #212529;\">Siswa siswi tamatan MTs Al Azhar Medan Sunggal telah menyambung pendidikan ke berbagai sekolah, ada yang menyambung ke Madrasah Aliyah (MA), Sekolah Menengah Atas/Umum/Kejuruan (SMA/SMU/SMK), Sekolah Tekhnik Mesin (STM) baik Negeri maupun Swasta didalam Kota maupun luar Kota bahkan luar Provinsi.</span></p>\n<p style=\"margin-top: 0cm; text-align: justify; background: white; box-sizing: border-box; margin-bottom: 1rem; font-variant-ligatures: normal; font-variant-caps: normal; orphans: 2; widows: 2; -webkit-text-stroke-width: 0px; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; word-spacing: 0px;\"><span style=\"font-family: \'Helvetica\',\'sans-serif\'; color: #212529;\">Prestasi Siswa Siswi MTs Al Azhar Medan Sunggal diantaranya adalah Juara 1 lomba Fahmil Qur&rsquo;an tingkat MTs se Kecamatan Medan Sunggal yang diselenggarakan oleh LPTQ Medan bekerjasama dengan TVRI Stasiun Medan . Juara 2 lomba KSM (Kompetisi Sains Madrasah) tingkat Kota Medan tahun 2019 bidang lomba Matematika Terintegritas. Juara 2 LT (Loma Tingkat) Kwarcab Kota Medan tahun 2017. Juga masih banyak lagi prestasi prestasi dalam bidang kepramukaan, dakwah, kesenian, olahraga, paskibar dan drumband.</span></p>\n<p style=\"margin-top: 0cm; text-align: justify; background: white; box-sizing: border-box; margin-bottom: 1rem; font-variant-ligatures: normal; font-variant-caps: normal; orphans: 2; widows: 2; -webkit-text-stroke-width: 0px; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; word-spacing: 0px;\"><span style=\"font-family: \'Helvetica\',\'sans-serif\'; color: #212529;\">&nbsp;</span></p>\n<p style=\"margin-top: 0cm; text-align: justify; background: white; box-sizing: border-box; margin-bottom: 1rem; font-variant-ligatures: normal; font-variant-caps: normal; orphans: 2; widows: 2; -webkit-text-stroke-width: 0px; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; word-spacing: 0px;\"><strong style=\"box-sizing: border-box;\"><span style=\"font-family: \'Helvetica\',\'sans-serif\'; color: #212529;\">Pendidik dan Tenaga Kependidikan</span></strong></p>\n<p style=\"margin-top: 0cm; text-align: justify; background: white; box-sizing: border-box; margin-bottom: 1rem; font-variant-ligatures: normal; font-variant-caps: normal; orphans: 2; widows: 2; -webkit-text-stroke-width: 0px; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; word-spacing: 0px;\"><span style=\"font-family: \'Helvetica\',\'sans-serif\'; color: #212529;\">Pendidik yang mengajar di MTs Al Azhar Medan Sunggal adalah para sarjana S1 bahkan S2 yang berkompeten serta berpengalaman pada bidangnya masing-masing. Alumni UIN, UNIMED, PTN, PTS dari berbagai daerah diIndonesia, sehingga memungkinkan tamatan MTs Al Azhar Medan Sunggal memiliki kualitas yang handal.</span></p>\n<p style=\"margin-top: 0cm; text-align: justify; background: white; box-sizing: border-box; margin-bottom: 1rem; font-variant-ligatures: normal; font-variant-caps: normal; orphans: 2; widows: 2; -webkit-text-stroke-width: 0px; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; word-spacing: 0px;\"><span style=\"font-family: \'Helvetica\',\'sans-serif\'; color: #212529;\">&nbsp;</span></p>\n<p style=\"margin-top: 0cm; text-align: justify; background: white; box-sizing: border-box; margin-bottom: 1rem; font-variant-ligatures: normal; font-variant-caps: normal; orphans: 2; widows: 2; -webkit-text-stroke-width: 0px; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; word-spacing: 0px;\"><strong style=\"box-sizing: border-box;\"><span style=\"font-family: \'Helvetica\',\'sans-serif\'; color: #212529;\">Fasilitas dan pendukung lainnya</span></strong></p>\n<p style=\"margin-top: 0cm; text-align: justify; background: white; box-sizing: border-box; margin-bottom: 1rem; font-variant-ligatures: normal; font-variant-caps: normal; orphans: 2; widows: 2; -webkit-text-stroke-width: 0px; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; word-spacing: 0px;\"><span style=\"font-family: \'Helvetica\',\'sans-serif\'; color: #212529;\">Fasilitas dan penunjang untuk terlaksananya pendidikan dan pengajaran secara tertib dan teratur, MTs Al Azhar Medan Sunggal memiliki ruang belajar ber lantai 3 (tiga) yang nyaman, perpustakaan, layanan administrasi yang profesional, bagi siswa siswi kurang mampu dan berprestasi ada program beasiswa, laboratorium komputer dan sarana ujian berbasis komputer, serta extrakurikuler seperti pramuka, paskibra, futsal, tarung drajat, sanggar tari, nasyid, teater, dakwah, jurnalistik, band dan drum band.</span></p>', NULL, 1, NULL, 'page', 'publish', 'public', 'close', 'sejarah-madrasah', NULL, 10, '2024-12-24 09:58:27', '2025-01-09 01:38:45', NULL, NULL, 1, 1, 0, 0, 'false');

-- --------------------------------------------------------

--
-- Struktur dari tabel `questions`
--

DROP TABLE IF EXISTS `questions`;
CREATE TABLE IF NOT EXISTS `questions` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `question` varchar(255) DEFAULT NULL,
  `is_active` enum('true','false') DEFAULT 'false',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  `restored_at` datetime DEFAULT NULL,
  `created_by` bigint DEFAULT '0',
  `updated_by` bigint DEFAULT '0',
  `deleted_by` bigint DEFAULT '0',
  `restored_by` bigint DEFAULT '0',
  `is_deleted` enum('true','false') DEFAULT 'false',
  PRIMARY KEY (`id`),
  UNIQUE KEY `question` (`question`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Struktur dari tabel `quotes`
--

DROP TABLE IF EXISTS `quotes`;
CREATE TABLE IF NOT EXISTS `quotes` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `quote` varchar(255) DEFAULT NULL,
  `quote_by` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  `restored_at` datetime DEFAULT NULL,
  `created_by` bigint DEFAULT '0',
  `updated_by` bigint DEFAULT '0',
  `deleted_by` bigint DEFAULT '0',
  `restored_by` bigint DEFAULT '0',
  `is_deleted` enum('true','false') DEFAULT 'false',
  PRIMARY KEY (`id`),
  UNIQUE KEY `__unique_key` (`quote`,`quote_by`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb3;

--
-- Dumping data untuk tabel `quotes`
--

INSERT INTO `quotes` (`id`, `quote`, `quote_by`, `created_at`, `updated_at`, `deleted_at`, `restored_at`, `created_by`, `updated_by`, `deleted_by`, `restored_by`, `is_deleted`) VALUES
(1, 'Imajinasi lebih penting daripada pengetahuan. Karena pengetahuan itu terbatas, sementara imajinasi mencakup seluruh dunia, merangsang kemajuan, dan melahirkan evolusi', 'Albert Einstein', '2023-01-29 03:50:24', '2024-12-25 09:50:21', NULL, NULL, 1, 1, 0, 0, 'false'),
(2, 'Selalu tampak mustahil sampai itu tercapai', 'Nelson Mandela', '2023-01-29 03:50:24', '2024-12-25 09:51:01', NULL, NULL, 1, 1, 0, 0, 'false'),
(3, 'Jadilah perubahan yang ingin kamu lihat di dunia', 'Mahatma Gandhi', '2023-01-29 03:50:24', '2024-12-25 09:51:45', NULL, NULL, 1, 1, 0, 0, 'false'),
(4, 'Kesuksesan bukanlah akhir, kegagalan bukanlah hal yang fatal: Yang penting adalah keberanian untuk terus melangkah', 'Winston Churchill', '2024-12-25 09:52:24', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(5, 'Barang siapa yang tidak memiliki kesabaran, ia tidak akan mampu memberi nasihat', 'Ali bin Abi Talib', '2024-12-25 09:53:06', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(6, 'Jangan bersedih. Apapun yang kamu kehilangan akan kembali dalam bentuk yang baru', 'Rumi', '2024-12-25 09:53:36', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(7, 'Perhitungkan dirimu sebelum kamu dihitung', 'Umar bin Khattab', '2024-12-25 09:54:02', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(8, 'Orang terbaik di antara kalian adalah mereka yang memiliki akhlak dan perilaku yang terbaik', 'Abu Hurairah', '2024-12-25 09:54:27', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(9, 'Ilmu bukanlah apa yang dihafal, ilmu adalah apa yang memberi manfaat', 'Sufyan Al-Thawri', '2024-12-25 09:55:19', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(10, 'Hidupmu terbatas, jadi jangan sia-siakan hidupmu untuk menjalani kehidupan orang lain', 'Imam Al-Ghazali', '2024-12-25 09:55:45', NULL, NULL, NULL, 1, 0, 0, 0, 'false');

-- --------------------------------------------------------

--
-- Struktur dari tabel `rooms`
--

DROP TABLE IF EXISTS `rooms`;
CREATE TABLE IF NOT EXISTS `rooms` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `building_id` bigint DEFAULT '0' COMMENT 'Ruangan ini di gedung mana?',
  `room_name` varchar(100) NOT NULL COMMENT 'Nama Ruangan',
  `room_capacity` smallint NOT NULL COMMENT 'Kapasitas / Jumlah Kursi',
  `is_class_room` enum('true','false') NOT NULL COMMENT 'Apakah merupakan ruang kelas?',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  `restored_at` datetime DEFAULT NULL,
  `created_by` bigint DEFAULT '0',
  `updated_by` bigint DEFAULT '0',
  `deleted_by` bigint DEFAULT '0',
  `restored_by` bigint DEFAULT '0',
  `is_deleted` enum('true','false') DEFAULT 'false',
  PRIMARY KEY (`id`),
  UNIQUE KEY `__unique_key` (`building_id`,`room_name`),
  KEY `rooms_building_id__idx` (`building_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3;

--
-- Dumping data untuk tabel `rooms`
--

INSERT INTO `rooms` (`id`, `building_id`, `room_name`, `room_capacity`, `is_class_room`, `created_at`, `updated_at`, `deleted_at`, `restored_at`, `created_by`, `updated_by`, `deleted_by`, `restored_by`, `is_deleted`) VALUES
(1, 172, 'lama-01', 40, 'true', '2023-01-29 03:50:23', '2024-12-24 11:01:49', NULL, NULL, 0, 1, 0, 0, 'false'),
(2, 172, 'lama-02', 40, 'true', '2023-01-29 03:50:23', '2024-12-24 11:02:00', NULL, NULL, 0, 1, 0, 0, 'false'),
(3, 172, 'lama-03', 40, 'true', '2023-01-29 03:50:23', '2024-12-24 11:02:14', NULL, NULL, 0, 1, 0, 0, 'false'),
(4, 172, 'lama-04', 40, 'true', '2024-12-24 11:02:25', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(5, 172, 'lama-05', 40, 'true', '2024-12-24 11:02:36', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(6, 172, 'lama-06', 40, 'true', '2024-12-24 11:02:49', NULL, NULL, NULL, 1, 0, 0, 0, 'false');

-- --------------------------------------------------------

--
-- Struktur dari tabel `scholarships`
--

DROP TABLE IF EXISTS `scholarships`;
CREATE TABLE IF NOT EXISTS `scholarships` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `student_id` bigint DEFAULT '0',
  `scholarship_type` bigint DEFAULT '0',
  `scholarship_description` varchar(255) NOT NULL,
  `scholarship_start_year` year NOT NULL,
  `scholarship_end_year` year NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  `restored_at` datetime DEFAULT NULL,
  `created_by` bigint DEFAULT '0',
  `updated_by` bigint DEFAULT '0',
  `deleted_by` bigint DEFAULT '0',
  `restored_by` bigint DEFAULT '0',
  `is_deleted` enum('true','false') DEFAULT 'false',
  PRIMARY KEY (`id`),
  KEY `scholarships_student_id__idx` (`student_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Struktur dari tabel `settings`
--

DROP TABLE IF EXISTS `settings`;
CREATE TABLE IF NOT EXISTS `settings` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `setting_group` varchar(100) NOT NULL,
  `setting_variable` varchar(255) DEFAULT NULL,
  `setting_value` text,
  `setting_default_value` text,
  `setting_access_group` varchar(255) DEFAULT NULL,
  `setting_description` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  `restored_at` datetime DEFAULT NULL,
  `created_by` bigint DEFAULT '0',
  `updated_by` bigint DEFAULT '0',
  `deleted_by` bigint DEFAULT '0',
  `restored_by` bigint DEFAULT '0',
  `is_deleted` enum('true','false') DEFAULT 'false',
  PRIMARY KEY (`id`),
  UNIQUE KEY `__unique_key` (`setting_group`,`setting_variable`)
) ENGINE=InnoDB AUTO_INCREMENT=87 DEFAULT CHARSET=utf8mb3;

--
-- Dumping data untuk tabel `settings`
--

INSERT INTO `settings` (`id`, `setting_group`, `setting_variable`, `setting_value`, `setting_default_value`, `setting_access_group`, `setting_description`, `created_at`, `updated_at`, `deleted_at`, `restored_at`, `created_by`, `updated_by`, `deleted_by`, `restored_by`, `is_deleted`) VALUES
(1, 'general', 'site_maintenance', NULL, 'false', 'public', 'Pemeliharaan situs', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(2, 'general', 'site_maintenance_end_date', NULL, '2023-01-01', 'public', 'Tanggal Berakhir Pemeliharaan Situs', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(3, 'general', 'site_cache', NULL, 'false', 'public', 'Cache situs', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(4, 'general', 'site_cache_time', NULL, '10', 'public', 'Lama Cache Situs', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(5, 'general', 'meta_description', NULL, 'CMS Sekolahku adalah Content Management System dan PPDB Online gratis untuk SD SMP/Sederajat SMA/Sederajat', 'public', 'Deskripsi Meta', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(6, 'general', 'meta_keywords', NULL, 'CMS, Website Sekolah Gratis, Cara Membuat Website Sekolah, membuat web sekolah, contoh website sekolah, fitur website sekolah, Sekolah, Website, Internet,Situs, CMS Sekolah, Web Sekolah, Website Sekolah Gratis, Website Sekolah, Aplikasi Sekolah, PPDB Online, PSB Online, PSB Online Gratis, Penerimaan Siswa Baru Online, Raport Online, Kurikulum 2013, SD, SMP, SMA, Aliyah, MTs, SMK', 'public', 'Kata Kunci Meta', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(7, 'general', 'map_location', NULL, '', 'public', 'Lokasi di Google Maps', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(8, 'general', 'favicon', '422bf6dd373bab269761e6202deb75b1.png', 'favicon.png', 'public', 'Favicon', '2023-01-29 03:50:24', '2024-12-26 04:45:37', NULL, NULL, 0, 1, 0, 0, 'false'),
(9, 'general', 'header', NULL, 'header.png', 'public', 'Gambar Header', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(10, 'general', 'recaptcha_status', 'enable', 'disable', 'public', 'reCAPTCHA Status', '2023-01-29 03:50:24', '2024-12-26 10:28:49', NULL, NULL, 0, 1, 0, 0, 'false'),
(11, 'general', 'recaptcha_site_key', NULL, '6Lfo67cjAAAAAHK_c2JcBfzJd8DSMlr8hpeFPy3W', 'public', 'reCAPTCHA Site Key', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(12, 'general', 'recaptcha_secret_key', NULL, '6Lfo67cjAAAAAIYv3j5yJWhEJtgRATv4xaYTNR0f', 'public', 'reCAPTCHA Secret Key', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(13, 'general', 'timezone', NULL, 'Asia/Jakarta', 'public', 'Time Zone', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(14, 'media', 'file_allowed_types', 'jpg, jpeg, png, gif, pdf', 'jpg, jpeg, png, gif', 'public', 'Tipe file yang diizinkan', '2023-01-29 03:50:24', '2024-12-24 11:24:02', NULL, NULL, 0, 1, 0, 0, 'false'),
(15, 'media', 'upload_max_filesize', NULL, '0', 'public', 'Maksimal Ukuran File yang Diupload', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(16, 'media', 'thumbnail_size_height', NULL, '100', 'private', 'Tinggi Gambar Thumbnail', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(17, 'media', 'thumbnail_size_width', NULL, '150', 'private', 'Lebar Gambar Thumbnail', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(18, 'media', 'medium_size_height', NULL, '308', 'private', 'Tinggi Gambar Sedang', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(19, 'media', 'medium_size_width', NULL, '460', 'private', 'Lebar Gambar Sedang', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(20, 'media', 'large_size_height', NULL, '600', 'private', 'Tinggi Gambar Besar', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(21, 'media', 'large_size_width', NULL, '800', 'private', 'Lebar Gambar Besar', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(22, 'media', 'album_cover_height', NULL, '250', 'private', 'Tinggi Cover Album Foto', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(23, 'media', 'album_cover_width', NULL, '400', 'private', 'Lebar Cover Album Foto', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(24, 'media', 'banner_height', NULL, '81', 'private', 'Tinggi Iklan', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(25, 'media', 'banner_width', NULL, '245', 'private', 'Lebar Iklan', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(26, 'media', 'image_slider_height', NULL, '400', 'private', 'Tinggi Gambar Slide', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(27, 'media', 'image_slider_width', NULL, '900', 'private', 'Lebar Gambar Slide', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(28, 'media', 'user_photo_height', NULL, '600', 'private', 'Tinggi Foto Siswa, Guru, Tenaga Kependidikan, dan Kepala Sekolah', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(29, 'media', 'user_photo_width', NULL, '400', 'private', 'Lebar Foto Siswa, Guru, Tenaga Kependidikan, dan Kepala Sekolah', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(30, 'media', 'logo_height', NULL, '120', 'private', 'Tinggi Logo Sekolah', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(31, 'media', 'logo_width', NULL, '120', 'private', 'Lebar Logo Sekolah', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(32, 'writing', 'default_post_category', NULL, '1', 'private', 'Default Kategori Tulisan', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(33, 'writing', 'default_post_status', NULL, 'publish', 'private', 'Default Status Tulisan', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(34, 'writing', 'default_post_visibility', NULL, 'public', 'private', 'Default Akses Tulisan', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(35, 'writing', 'default_post_discussion', NULL, 'open', 'private', 'Default Komentar Tulisan', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(36, 'writing', 'post_image_thumbnail_height', NULL, '100', 'private', 'Tinggi Gambar Kecil', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(37, 'writing', 'post_image_thumbnail_width', NULL, '150', 'private', 'Lebar Gambar Kecil', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(38, 'writing', 'post_image_medium_height', NULL, '250', 'private', 'Tinggi Gambar Sedang', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(39, 'writing', 'post_image_medium_width', NULL, '400', 'private', 'Lebar Gambar Sedang', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(40, 'writing', 'post_image_large_height', NULL, '450', 'private', 'Tinggi Gambar Besar', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(41, 'writing', 'post_image_large_width', NULL, '840', 'private', 'Lebar Gambar Besar', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(42, 'reading', 'post_per_page', NULL, '5', 'public', 'Tulisan per halaman', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(43, 'reading', 'post_rss_count', NULL, '10', 'public', 'Jumlah RSS', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(44, 'reading', 'post_related_count', NULL, '5', 'public', 'Jumlah Tulisan Terkait', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(45, 'reading', 'comment_per_page', NULL, '5', 'public', 'Komentar per halaman', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(46, 'discussion', 'comment_moderation', NULL, 'false', 'public', 'Komentar harus disetujui secara manual', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(47, 'discussion', 'comment_registration', NULL, 'false', 'public', 'Pengguna harus terdaftar dan login untuk komentar', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(48, 'discussion', 'comment_blacklist', NULL, 'kampret', 'public', 'Komentar disaring', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(49, 'discussion', 'comment_order', NULL, 'asc', 'public', 'Urutan Komentar', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(50, 'social_account', 'facebook', NULL, 'https://www.facebook.com/cmssekolahku/', 'public', 'Facebook', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(51, 'social_account', 'twitter', NULL, 'https://twitter.com/antonsofyan', 'public', 'Twitter', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(52, 'social_account', 'linked_in', NULL, 'https://www.linkedin.com/in/anton-sofyan-1428937a/', 'public', 'Linked In', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(53, 'social_account', 'youtube', NULL, '-', 'public', 'Youtube', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(54, 'social_account', 'instagram', NULL, 'https://www.instagram.com/anton_sofyan/', 'public', 'Instagram', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(55, 'mail_server', 'smtp_host', NULL, '', 'private', 'SMTP Server Address', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(56, 'mail_server', 'smtp_user', NULL, '', 'private', 'SMTP Username', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(57, 'mail_server', 'smtp_pass', NULL, '', 'private', 'SMTP Password', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(58, 'mail_server', 'smtp_port', NULL, '', 'public', 'SMTP Port', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(59, 'school_profile', 'npsn', '10264592', '123', 'public', 'NPSN', '2023-01-29 03:50:24', '2024-12-24 09:41:59', NULL, NULL, 0, 1, 0, 0, 'false'),
(60, 'school_profile', 'school_name', 'MTSS YP AL AZHAR', 'SMK Negeri 10 Kuningan', 'public', 'Nama Sekolah', '2023-01-29 03:50:24', '2024-12-24 09:31:26', NULL, NULL, 0, 1, 0, 0, 'false'),
(61, 'school_profile', 'headmaster', 'Donny, S.S.', 'Anton Sofyan', 'public', 'Kepala Sekolah', '2023-01-29 03:50:24', '2024-12-24 09:32:53', NULL, NULL, 0, 1, 0, 0, 'false'),
(62, 'school_profile', 'headmaster_photo', '6b4bc58c21935f39d8f3164ffe955e5a.jpg', 'headmaster_photo.png', 'public', 'Foto Kepala Sekolah', '2023-01-29 03:50:24', '2024-12-24 09:41:42', NULL, NULL, 0, 1, 0, 0, 'false'),
(63, 'school_profile', 'school_level', '102', '3', 'public', 'Bentuk Pendidikan', '2023-01-29 03:50:24', '2024-12-24 09:42:40', NULL, NULL, 0, 1, 0, 0, 'false'),
(64, 'school_profile', 'school_status', '2', '1', 'public', 'Status Sekolah', '2023-01-29 03:50:24', '2024-12-24 09:31:31', NULL, NULL, 0, 1, 0, 0, 'false'),
(65, 'school_profile', 'ownership_status', '111', '1', 'public', 'Status Kepemilikan', '2023-01-29 03:50:24', '2024-12-24 09:42:07', NULL, NULL, 0, 1, 0, 0, 'false'),
(66, 'school_profile', 'tagline', 'Man Jadda Wa Jadda', 'Where Tomorrow\'s Leaders Come Together', 'public', 'Slogan', '2023-01-29 03:50:24', '2024-12-24 09:32:13', NULL, NULL, 0, 1, 0, 0, 'false'),
(67, 'school_profile', 'rt', '00', '12', 'public', 'RT', '2023-01-29 03:50:24', '2024-12-24 09:42:30', NULL, NULL, 0, 1, 0, 0, 'false'),
(68, 'school_profile', 'rw', '00', '06', 'public', 'RW', '2023-01-29 03:50:24', '2024-12-24 09:42:34', NULL, NULL, 0, 1, 0, 0, 'false'),
(69, 'school_profile', 'sub_village', '-', 'Wage', 'public', 'Dusun', '2023-01-29 03:50:24', '2024-12-24 09:32:02', NULL, NULL, 0, 1, 0, 0, 'false'),
(70, 'school_profile', 'village', 'Sei Sikambing B', 'Kadugede', 'public', 'Kelurahan / Desa', '2023-01-29 03:50:24', '2024-12-24 09:32:21', NULL, NULL, 0, 1, 0, 0, 'false'),
(71, 'school_profile', 'sub_district', 'Medan Sunggal', 'Kadugede', 'public', 'Kecamatan', '2023-01-29 03:50:24', '2024-12-24 09:31:56', NULL, NULL, 0, 1, 0, 0, 'false'),
(72, 'school_profile', 'district', 'Kota Medan', 'Kuningan', 'public', 'Kabupaten/Kota', '2023-01-29 03:50:24', '2024-12-24 09:31:09', NULL, NULL, 0, 1, 0, 0, 'false'),
(73, 'school_profile', 'postal_code', '20122', '45561', 'public', 'Kode Pos', '2023-01-29 03:50:24', '2024-12-24 09:42:24', NULL, NULL, 0, 1, 0, 0, 'false'),
(74, 'school_profile', 'street_address', 'Jl. Merak Gg. Nirwana No. 65 F', 'Jalan Raya Kadugede No. 11', 'public', 'Alamat Jalan', '2023-01-29 03:50:24', '2024-12-24 09:31:46', NULL, NULL, 0, 1, 0, 0, 'false'),
(75, 'school_profile', 'phone', '061 8458955', '0232123456', 'public', 'Telepon', '2023-01-29 03:50:24', '2024-12-24 09:42:16', NULL, NULL, 0, 1, 0, 0, 'false'),
(76, 'school_profile', 'fax', '061 8458955', '0232123456', 'public', 'Fax', '2023-01-29 03:50:24', '2024-12-24 09:41:08', NULL, NULL, 0, 1, 0, 0, 'false'),
(77, 'school_profile', 'email', 'mtssypalazhar@gmail.com', 'info@sman9kuningan.sch.id', 'public', 'Email', '2023-01-29 03:50:24', '2024-12-24 09:34:50', NULL, NULL, 0, 1, 0, 0, 'false'),
(78, 'school_profile', 'website', 'www.mtssypalazhar.sch.id', 'http://www.sman9kuningan.sch.id', 'public', 'Website', '2023-01-29 03:50:24', '2024-12-24 09:32:37', NULL, NULL, 0, 1, 0, 0, 'false'),
(79, 'school_profile', 'logo', '930b1cbe9fa339ddf0dff71c94266f92.png', 'logo.png', 'public', 'Logo', '2023-01-29 03:50:24', '2024-12-24 11:13:43', NULL, NULL, 0, 1, 0, 0, 'false'),
(80, 'admission', 'admission_status', 'open', 'open', 'public', 'Status Penerimaan Peserta Didik Baru', '2023-01-29 03:50:24', '2025-01-07 00:54:25', NULL, NULL, 0, 1, 0, 0, 'false'),
(81, 'admission', 'announcement_start_date', '2025-01-01', '2023-01-01', 'public', 'Tanggal mulai pengumuman hasil seleksi Penerimaan Peserta Didik Baru', '2023-01-29 03:50:24', '2024-12-25 10:14:14', NULL, NULL, 0, 1, 0, 0, 'false'),
(82, 'admission', 'announcement_end_date', '2025-07-12', '2024-12-31', 'public', 'Tanggal selesai pengumuman hasil seleksi Penerimaan Peserta Didik Baru', '2023-01-29 03:50:24', '2024-12-25 10:14:30', NULL, NULL, 0, 1, 0, 0, 'false'),
(83, 'admission', 'print_exam_card_start_date', NULL, '2023-01-01', 'public', 'Tanggal mulai cetak kartu ujian tes tulis', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(84, 'admission', 'print_exam_card_end_date', NULL, '2024-12-31', 'public', 'Tanggal selesai cetak kartu ujian tes tulis', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(85, 'admission', 'min_birth_date', NULL, NULL, 'private', 'Tanggal lahir minimal Calon Peserta Didik Baru', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(86, 'admission', 'max_birth_date', NULL, NULL, 'private', 'Tanggal lahir maksimal Calon Peserta Didik Baru', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false');

-- --------------------------------------------------------

--
-- Struktur dari tabel `students`
--

DROP TABLE IF EXISTS `students`;
CREATE TABLE IF NOT EXISTS `students` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `major_id` bigint DEFAULT '0' COMMENT 'Program Keahlian',
  `first_choice_id` bigint DEFAULT '0' COMMENT 'Pilihan Pertama PPDB',
  `second_choice_id` bigint DEFAULT '0' COMMENT 'Pilihan Kedua PPDB',
  `registration_number` varchar(10) DEFAULT NULL COMMENT 'Nomor Pendaftaran',
  `admission_exam_number` varchar(10) DEFAULT NULL COMMENT 'Nomor Ujian Tes Tulis',
  `selection_result` varchar(100) DEFAULT NULL COMMENT 'Hasil Seleksi PPDB/PMB',
  `admission_phase_id` bigint DEFAULT '0' COMMENT 'Gelombang Pendaftaran',
  `admission_type_id` bigint DEFAULT '0' COMMENT 'Jalur Pendaftaran',
  `photo` varchar(100) DEFAULT NULL,
  `achievement` text COMMENT 'Prestasi Calon Peserta Didik / Mahasiswa',
  `is_student` enum('true','false') NOT NULL DEFAULT 'false' COMMENT 'Apakah Siswa Aktif ? Set true jika lolos seleksi PPDB dan set FALSE jika sudah lulus',
  `is_prospective_student` enum('true','false') NOT NULL DEFAULT 'false' COMMENT 'Apakah Calon Siswa Baru ?',
  `is_alumni` enum('true','false','unverified') NOT NULL DEFAULT 'false' COMMENT 'Apakah Alumni?',
  `is_transfer` enum('true','false') NOT NULL DEFAULT 'false' COMMENT 'Jenis Pendaftaran : Baru / Pindahan ?',
  `re_registration` enum('true','false') DEFAULT NULL COMMENT 'Konfirmasi Pendaftaran Ulang Calon Siswa Baru',
  `start_date` date DEFAULT NULL COMMENT 'Tanggal Masuk Sekolah',
  `identity_number` varchar(50) DEFAULT NULL COMMENT 'NIS/NIM',
  `nisn` varchar(50) DEFAULT NULL COMMENT 'Nomor Induk Siswa Nasional',
  `nik` varchar(50) DEFAULT NULL COMMENT 'Nomor Induk Kependudukan/KTP',
  `prev_exam_number` varchar(50) DEFAULT NULL COMMENT 'Nomor Peserta Ujian Sebelumnya',
  `prev_diploma_number` varchar(50) DEFAULT NULL COMMENT 'Nomor Ijazah Sebelumnya',
  `paud` enum('true','false') DEFAULT NULL COMMENT 'Apakah Pernah PAUD',
  `tk` enum('true','false') DEFAULT NULL COMMENT 'Apakah Pernah TK',
  `skhun` varchar(50) DEFAULT NULL COMMENT 'No. Seri Surat Keterangan Hasil Ujian Nasional Sebelumnya',
  `prev_school_name` varchar(255) DEFAULT NULL COMMENT 'Nama Sekolah Sebelumnya',
  `prev_school_address` varchar(255) DEFAULT NULL COMMENT 'Alamat Sekolah Sebelumnya',
  `hobby` varchar(255) DEFAULT NULL,
  `ambition` varchar(255) DEFAULT NULL COMMENT 'Cita-Cita',
  `full_name` varchar(150) NOT NULL,
  `gender` enum('M','F') NOT NULL DEFAULT 'M',
  `birth_place` varchar(255) DEFAULT NULL,
  `birth_date` date DEFAULT NULL,
  `religion_id` bigint DEFAULT '0',
  `special_need_id` bigint DEFAULT '0' COMMENT 'Berkeburuhan Khusus',
  `street_address` varchar(255) DEFAULT NULL COMMENT 'Alamat Jalan',
  `rt` varchar(10) DEFAULT NULL COMMENT 'Alamat Jalan',
  `rw` varchar(10) DEFAULT NULL COMMENT 'Alamat Jalan',
  `sub_village` varchar(255) DEFAULT NULL COMMENT 'Nama Dusun',
  `village` varchar(255) DEFAULT NULL COMMENT 'Nama Kelurahan/Desa',
  `sub_district` varchar(255) DEFAULT NULL COMMENT 'Kecamatan',
  `district` varchar(255) DEFAULT NULL COMMENT 'Kota/Kabupaten',
  `postal_code` varchar(20) DEFAULT NULL COMMENT 'Kode POS',
  `residence_id` bigint DEFAULT '0' COMMENT 'Tempat Tinggal',
  `transportation_id` bigint DEFAULT '0' COMMENT 'Moda Transportasi',
  `phone` varchar(50) DEFAULT NULL,
  `mobile_phone` varchar(50) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `sktm` varchar(100) DEFAULT NULL COMMENT 'Surat Keterangan Tidak Mampu (SKTM)',
  `kks` varchar(100) DEFAULT NULL COMMENT 'Kartu Keluarga Sejahtera (KKS)',
  `kps` varchar(100) DEFAULT NULL COMMENT 'Kartu Pra Sejahtera (KPS)',
  `kip` varchar(100) DEFAULT NULL COMMENT 'Kartu Indonesia Pintar (KIP)',
  `kis` varchar(100) DEFAULT NULL COMMENT 'Kartu Indonesia Sehat (KIS)',
  `citizenship` enum('WNI','WNA') NOT NULL DEFAULT 'WNI' COMMENT 'Kewarganegaraan',
  `country` varchar(255) DEFAULT NULL,
  `father_name` varchar(150) DEFAULT NULL,
  `father_birth_year` year DEFAULT NULL,
  `father_education_id` bigint DEFAULT '0',
  `father_employment_id` bigint DEFAULT '0',
  `father_monthly_income_id` bigint DEFAULT '0',
  `father_special_need_id` bigint DEFAULT '0',
  `mother_name` varchar(150) DEFAULT NULL,
  `mother_birth_year` year DEFAULT NULL,
  `mother_education_id` bigint DEFAULT '0',
  `mother_employment_id` bigint DEFAULT '0',
  `mother_monthly_income_id` bigint DEFAULT '0',
  `mother_special_need_id` bigint DEFAULT '0',
  `guardian_name` varchar(150) DEFAULT NULL,
  `guardian_birth_year` year DEFAULT NULL,
  `guardian_education_id` bigint DEFAULT '0',
  `guardian_employment_id` bigint DEFAULT '0',
  `guardian_monthly_income_id` bigint DEFAULT '0',
  `mileage` smallint DEFAULT NULL COMMENT 'Jarak tempat tinggal ke sekolah',
  `traveling_time` smallint DEFAULT NULL COMMENT 'Waktu Tempuh',
  `height` smallint DEFAULT NULL COMMENT 'Tinggi Badan',
  `weight` smallint DEFAULT NULL COMMENT 'Berat Badan',
  `sibling_number` smallint DEFAULT '0' COMMENT 'Jumlah Saudara Kandung',
  `student_status_id` bigint DEFAULT '0' COMMENT 'Status siswa',
  `end_date` date DEFAULT NULL COMMENT 'Tanggal Keluar',
  `reason` varchar(255) DEFAULT NULL COMMENT 'Diisi jika peserta didik sudah keluar',
  `created_at` datetime DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  `restored_at` datetime DEFAULT NULL,
  `created_by` bigint DEFAULT '0',
  `updated_by` bigint DEFAULT '0',
  `deleted_by` bigint DEFAULT '0',
  `restored_by` bigint DEFAULT '0',
  `is_deleted` enum('true','false') DEFAULT 'false',
  PRIMARY KEY (`id`),
  KEY `students_registration_number__idx` (`registration_number`) USING BTREE,
  KEY `students_identity_number__idx` (`identity_number`) USING BTREE,
  KEY `students_full_name__idx` (`full_name`) USING BTREE,
  KEY `students_first_choice_id__idx` (`first_choice_id`) USING BTREE,
  KEY `students_second_choice_id__idx` (`second_choice_id`) USING BTREE,
  KEY `students_major_id__idx` (`major_id`) USING BTREE,
  KEY `students_admission_phase_id__idx` (`admission_phase_id`) USING BTREE,
  KEY `students_admission_type_id__idx` (`admission_type_id`) USING BTREE,
  KEY `students_student_status_id__idx` (`student_status_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=93 DEFAULT CHARSET=utf8mb3;

--
-- Dumping data untuk tabel `students`
--

INSERT INTO `students` (`id`, `major_id`, `first_choice_id`, `second_choice_id`, `registration_number`, `admission_exam_number`, `selection_result`, `admission_phase_id`, `admission_type_id`, `photo`, `achievement`, `is_student`, `is_prospective_student`, `is_alumni`, `is_transfer`, `re_registration`, `start_date`, `identity_number`, `nisn`, `nik`, `prev_exam_number`, `prev_diploma_number`, `paud`, `tk`, `skhun`, `prev_school_name`, `prev_school_address`, `hobby`, `ambition`, `full_name`, `gender`, `birth_place`, `birth_date`, `religion_id`, `special_need_id`, `street_address`, `rt`, `rw`, `sub_village`, `village`, `sub_district`, `district`, `postal_code`, `residence_id`, `transportation_id`, `phone`, `mobile_phone`, `email`, `sktm`, `kks`, `kps`, `kip`, `kis`, `citizenship`, `country`, `father_name`, `father_birth_year`, `father_education_id`, `father_employment_id`, `father_monthly_income_id`, `father_special_need_id`, `mother_name`, `mother_birth_year`, `mother_education_id`, `mother_employment_id`, `mother_monthly_income_id`, `mother_special_need_id`, `guardian_name`, `guardian_birth_year`, `guardian_education_id`, `guardian_employment_id`, `guardian_monthly_income_id`, `mileage`, `traveling_time`, `height`, `weight`, `sibling_number`, `student_status_id`, `end_date`, `reason`, `created_at`, `updated_at`, `deleted_at`, `restored_at`, `created_by`, `updated_by`, `deleted_by`, `restored_by`, `is_deleted`) VALUES
(1, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, '0000-00-00', '240001', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '', 'ABDUL MALIK SIREGAR', 'M', 'SIMPANG BUNTAL', '0000-00-00', 89, 23, 'Jl. Seroja, Kel. Sei SiKambing, Kec. Medan Sunggal', '', '', '', '', '', '', '', 0, 0, '', '', '240001@mtssypalazhar.sch.id', '', '', '', '', '', 'WNI', '', '', '0000', 0, 0, 0, 0, '', '0000', 0, 0, 0, 0, '', '0000', 0, 0, 0, 0, 0, 0, 0, 0, 1, '0000-00-00', '', '2024-12-20 16:52:17', '2024-12-21 12:51:05', NULL, NULL, 1, 1, 0, 0, 'false'),
(2, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240003', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'ALIYA SAHKILA', 'F', 'MEDAN', '0000-00-00', 0, 0, 'Jl. Seroja, Kel. Sunggal, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240003@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 16:52:17', '2024-12-20 09:52:17', NULL, NULL, 1, 0, 0, 0, 'false'),
(3, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240008', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'ARIFAH SYAHFITRI', 'F', 'MEDAN', '0000-00-00', 0, 0, 'Jl. Kantil No.9, Kel. Tanjung Rejo, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240008@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 16:52:17', '2024-12-20 09:52:17', NULL, NULL, 1, 0, 0, 0, 'false'),
(4, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240013', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'CINTA UMMAIRAH', 'F', 'MEDAN', '0000-00-00', 0, 0, 'Kel. Sei Sikambing B, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240013@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 16:52:17', '2024-12-20 09:52:17', NULL, NULL, 1, 0, 0, 0, 'false'),
(5, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240015', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'DAVA RIFQI', 'M', 'MEDAN', '0000-00-00', 0, 0, 'Jl. Setia Budi, Gg. Ampera No.1, Kel. Sei Sikambing B, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240015@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 16:52:17', '2024-12-20 09:52:17', NULL, NULL, 1, 0, 0, 0, 'false'),
(6, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240021', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'DINA SAFIRA PUTRI', 'F', 'SEI APUNG', '0000-00-00', 0, 0, 'BANDAR JAWA, Kel. SEI APUNG, Kec. TANJUNG BALAI, SUMATERA UTARA, 21352', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240021@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 16:52:17', '2024-12-20 09:52:17', NULL, NULL, 1, 0, 0, 0, 'false'),
(7, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240022', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'FADJAR ALAMSAH', 'M', 'MEDAN', '0000-00-00', 0, 0, 'JL.BALAM GG RUHAMA NO 4 LK 13, Kel. SEI SIKAMBING B, Kec. MEDAN SUNGGAL, SUMATERA UTARA, 20122', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240022@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 16:52:17', '2024-12-20 09:52:17', NULL, NULL, 1, 0, 0, 0, 'false'),
(8, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240026', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'FEBRIANSYAH PERDANA LUBIS', 'M', 'MEDAN', '0000-00-00', 0, 0, 'Jl. Merak Gg. Keluarga No. 8A, Kel. Sei Sikambing B, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240026@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 16:52:17', '2024-12-20 09:52:17', NULL, NULL, 1, 0, 0, 0, 'false'),
(9, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240029', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'GHALIYATUL IFFAH LUBIS', 'F', 'MEDAN', '0000-00-00', 0, 0, 'JL.T.AMIR HAMZAHNO.59, Kel. HELVETIA TIMUR, Kec. MEDAN HELVETIA, SUMATERA UTARA, 20123', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240029@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 16:52:17', '2024-12-20 09:52:17', NULL, NULL, 1, 0, 0, 0, 'false'),
(10, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240033', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'HARIS OCTO MAULANA', 'M', 'MEDAN', '0000-00-00', 0, 0, 'Jl. Merak No.5, Kel, Sei Sikambing B, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240033@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 16:52:17', '2024-12-20 09:52:17', NULL, NULL, 1, 0, 0, 0, 'false'),
(11, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240035', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'IRANDA PUTRI', 'F', 'MEDAN', '0000-00-00', 0, 0, 'Jl. Abadi, Gg. Sepakat, Kel. Tanjung Rejo, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240035@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 16:52:17', '2024-12-20 09:52:17', NULL, NULL, 1, 0, 0, 0, 'false'),
(12, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240039', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'KHAIRIL DWI PANCA', 'M', 'MEDAN', '0000-00-00', 0, 0, 'Jl. Seroja Gg. Warisan, Kel. Sunggal, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240039@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 16:52:17', '2024-12-20 09:52:17', NULL, NULL, 1, 0, 0, 0, 'false'),
(13, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240042', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'KHALIS NIZAM', 'M', 'MEDAN', '0000-00-00', 0, 0, 'Jl. Beringin Gg. Tentram, Kel. Sunggal, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240042@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 16:52:17', '2024-12-20 09:52:17', NULL, NULL, 1, 0, 0, 0, 'false'),
(14, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240048', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'M. RAFKHY', 'M', 'MEDAN', '0000-00-00', 0, 0, 'Jl. Pendidikan, Kel. Tanjung Rejo, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240048@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 16:52:17', '2024-12-20 09:52:17', NULL, NULL, 1, 0, 0, 0, 'false'),
(15, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240052', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MIFTAH SYIR ALIYA', 'F', 'BATU BARA', '0000-00-00', 0, 0, 'Jln. Balai Desa, Gg. Wakaf No.21, Kel. Sunggal, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240052@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 16:52:17', '2024-12-20 09:52:17', NULL, NULL, 1, 0, 0, 0, 'false'),
(16, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240091', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MUHAMMAD AZAM', 'M', 'MEDAN', '0000-00-00', 0, 0, 'Jl. Beo No. 21, Kel. Sei Sikambing B, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240091@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 16:52:17', '2024-12-20 09:52:17', NULL, NULL, 1, 0, 0, 0, 'false'),
(17, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240053', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MUHAMMAD BAGAS ARZIKI', 'M', 'MEDAN', '0000-00-00', 0, 0, 'Jl. Seroja No. 43, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240053@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 16:52:17', '2024-12-20 09:52:17', NULL, NULL, 1, 0, 0, 0, 'false'),
(18, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240057', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MUHAMMAD FAIZ', 'M', 'DARUSSALAM', '0000-00-00', 0, 0, 'Jl. Kasuari, Gg. Kacang, Kel. Sei Sikambing B, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240057@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 16:52:17', '2024-12-20 09:52:17', NULL, NULL, 1, 0, 0, 0, 'false'),
(19, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240045', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MUHAMMAD FARHAN SYAPUTRA', 'M', 'BANJAR XII', '0000-00-00', 0, 0, 'Jl. Kasuari, Gg. Sosial, Kel. Sei Sikambing B, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240045@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 16:52:17', '2024-12-20 09:52:17', NULL, NULL, 1, 0, 0, 0, 'false'),
(20, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240060', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MUHAMMAR RIZKY', 'M', 'BIREM RAYEUK', '0000-00-00', 0, 0, 'Ringroad Gagak Hitam', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240060@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 16:52:17', '2024-12-20 09:52:17', NULL, NULL, 1, 0, 0, 0, 'false'),
(21, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240063', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'NAZIFA NASUTION', 'F', 'SEI KASIH', '0000-00-00', 0, 0, 'Jl. Merak No.55, Kel. Sei Sikambing B, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240063@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 16:52:17', '2024-12-20 09:52:17', NULL, NULL, 1, 0, 0, 0, 'false'),
(22, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240092', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'NAZWA AZAHRA LUBIS', 'F', 'MEDAN', '0000-00-00', 0, 0, 'JL. TITIPAN GG. PERTAHANAN, kel. Sei Sikambing D, Kec. Medan Petisah', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240092@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 16:52:17', '2024-12-20 09:52:17', NULL, NULL, 1, 0, 0, 0, 'false'),
(23, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240066', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'NURUL SYAHRINY', 'F', 'MEDAN', '0000-00-00', 0, 0, 'Jl. Beringin, Gg. Bersama, Kel. Sunggal, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240066@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 16:52:17', '2024-12-20 09:52:17', NULL, NULL, 1, 0, 0, 0, 'false'),
(24, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240069', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'RAHFI RICZKY SARAGIH', 'M', 'TALUN KONDOT', '0000-00-00', 0, 0, 'Talun Kondot, Kel. TALUN KONDOT, Kec. BANDAR MASILAM, SUMATERA UTARA, 21161', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240069@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 16:52:17', '2024-12-20 09:52:17', NULL, NULL, 1, 0, 0, 0, 'false'),
(25, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240075', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'RENDYANSYAH', 'M', 'MEDAN', '0000-00-00', 0, 0, 'Jl. Merpati, Gg. Musholla, Kel. Sei Sikambing B, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240075@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 16:52:17', '2024-12-20 09:52:17', NULL, NULL, 1, 0, 0, 0, 'false'),
(26, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240076', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'RESTY NURANDINI', 'F', 'MEDAN', '0000-00-00', 0, 0, 'Jln. Merak, Gg. Asal N0. 28 B, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240076@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 16:52:17', '2024-12-20 09:52:17', NULL, NULL, 1, 0, 0, 0, 'false'),
(27, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240082', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'SYUHADA RAMADHAN', 'M', 'MEDAN', '0000-00-00', 0, 0, 'Jl. Pinang Baris, Gg. Wakaf No.3, Kel. Lalang, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240082@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 16:52:17', '2024-12-20 09:52:17', NULL, NULL, 1, 0, 0, 0, 'false'),
(28, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240084', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'TITA NIA AZZAHRA', 'F', 'MEDAN', '0000-00-00', 0, 0, 'Jl. Kapt-Muslim, Gg. Jawa, Lr. Musholla, Desa. Sei Sikambing C II, Medan Helvetia', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240084@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 16:52:17', '2024-12-20 09:52:17', NULL, NULL, 1, 0, 0, 0, 'false'),
(29, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240087', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'WAN SEKAR HARUM AQILAH PUTRI', 'F', 'MEDAN', '0000-00-00', 0, 0, 'Jl. Murni No.14, Kel. Tanjung Rejo, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240087@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 16:52:17', '2024-12-20 09:52:17', NULL, NULL, 1, 0, 0, 0, 'false'),
(30, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240090', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'ZAZKIA KINARA ARTANTI', 'F', 'MEDAN', '0000-00-00', 0, 0, 'Jl. Pinang Baris, Gg. Wakaf, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240090@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 16:52:17', '2024-12-20 09:52:17', NULL, NULL, 1, 0, 0, 0, 'false'),
(31, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240002', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'AISYAH NUR KHAIRA', 'F', 'MEDAN', '0000-00-00', 0, 0, 'JL PERJUANGAN GG KETERTIBAN-9, Kel. TANJUNG REJO, Kec. MEDAN SUNGGAL, SUMATERA UTARA, 20122', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240002@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 16:59:57', '2024-12-20 09:59:57', NULL, NULL, 1, 0, 0, 0, 'false'),
(32, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240006', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'ANISA PUTRI', 'F', 'BINJAI', '0000-00-00', 0, 0, 'Jl. Sunggal Gg. Musholla No. 48', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240006@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 16:59:57', '2024-12-20 09:59:57', NULL, NULL, 1, 0, 0, 0, 'false'),
(33, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240007', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'ARDIANSYAH PUTRA', 'M', 'MEDAN', '0000-00-00', 0, 0, 'Jl. Seroja, Gg. Rukun No. 99, Lk V, Kel. Sunggal, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240007@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 16:59:57', '2024-12-20 09:59:57', NULL, NULL, 1, 0, 0, 0, 'false'),
(34, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240010', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'BIMA CAKRA', 'M', 'MEDAN', '0000-00-00', 0, 0, 'JL DARUSSALAM, Kel. SEI SIKAMBING D, Kec. MEDAN PETISAH, SUMATERA UTARA, 20119', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240010@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 16:59:57', '2024-12-20 09:59:57', NULL, NULL, 1, 0, 0, 0, 'false'),
(35, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240012', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'CINTA KASIH ANUGRAH', 'F', 'DELI SERDANG', '0000-00-00', 0, 0, 'Jl. Sumpah Prajurit Timur K-11, Kel. Tanjung Rejo, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240012@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 16:59:57', '2024-12-20 09:59:57', NULL, NULL, 1, 0, 0, 0, 'false'),
(36, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240017', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'DELLA AMELIA PUTRI', 'F', 'MEDAN', '0000-00-00', 0, 0, 'Jl. Sunggal No. 7, Lk VIII Serba Setia, Kel. Sunggal, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240017@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 16:59:57', '2024-12-20 09:59:57', NULL, NULL, 1, 0, 0, 0, 'false'),
(37, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240018', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'DERIL LIVINO', 'M', 'MEDAN', '0000-00-00', 0, 0, 'Jl. Kesatria Gg. Sederhana No. 39, Kel. Tanjung Rejo, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240018@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 16:59:57', '2024-12-20 09:59:57', NULL, NULL, 1, 0, 0, 0, 'false'),
(38, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240019', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'DHIYA JALWA ARDINI', 'F', 'MEDAN', '0000-00-00', 0, 0, 'Jl. Komp PTP VI No. 3 P, Kel. SEI SIKAMBING B, Kec. MEDAN SUNGGAL, SUMATERA UTARA, 20122', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240019@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 16:59:57', '2024-12-20 09:59:57', NULL, NULL, 1, 0, 0, 0, 'false'),
(39, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240023', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'FAHRI DHARMA HENDRA', 'M', 'MEDAN', '0000-00-00', 0, 0, 'Jl. Merpati, Gg. Bersama No. 84BM, Kel. Sei Sikambing B, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240023@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 16:59:57', '2024-12-20 09:59:57', NULL, NULL, 1, 0, 0, 0, 'false'),
(40, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240028', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'GABRIELLA STEPHANI PANJAITAN', 'F', 'MEDAN', '0000-00-00', 0, 0, 'JL.BALAM NO.42, Kel. SEI SIKAMBING B, Kec. MEDAN SUNGGAL, SUMATERA UTARA, 20122', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240028@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 16:59:57', '2024-12-20 09:59:57', NULL, NULL, 1, 0, 0, 0, 'false'),
(41, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240031', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'GISELLA ANGGRAINI', 'F', 'MEDAN', '0000-00-00', 0, 0, 'Jl. Titi Papan, Gg. Persatuan, Lr. Abadi, Kel. Sei Sikambing D, Kec. Medan Petisah', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240031@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 16:59:57', '2024-12-20 09:59:57', NULL, NULL, 1, 0, 0, 0, 'false'),
(42, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240034', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'ILHAM FAHREZI', 'M', 'BAHOROK', '0000-00-00', 0, 0, 'Jl. Balam Gg. Gajah, Kel. SEI SIKAMBING B, Kec. MEDAN SUNGGAL, SUMATERA UTARA, 20122', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240034@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 16:59:57', '2024-12-20 09:59:57', NULL, NULL, 1, 0, 0, 0, 'false'),
(43, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240037', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'KAYLA LOKA SARI', 'F', 'MEDAN', '0000-00-00', 0, 0, 'Jl Kasuari Gg Nuri No 3, Kec. MEDAN SUNGGAL, SUMATERA UTARA, 20122', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240037@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 16:59:57', '2024-12-20 09:59:57', NULL, NULL, 1, 0, 0, 0, 'false'),
(44, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240040', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'KHAIRIL RISKI', 'M', 'MEDAN', '0000-00-00', 0, 0, 'Jl. Merak No. 22 A, Lk. XX SSB, Kel. Sei Sikambing, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240040@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 16:59:57', '2024-12-20 09:59:57', NULL, NULL, 1, 0, 0, 0, 'false'),
(45, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240043', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'KORI FADHILLAH', 'M', 'MEDAN', '0000-00-00', 0, 0, 'Jl. Binjai, Gg. Dermawan No. 61, Kel. Sei Sikambing C II, Kec. Medan Helvetia', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240043@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 16:59:57', '2024-12-20 09:59:57', NULL, NULL, 1, 0, 0, 0, 'false'),
(46, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240046', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'M IBNU QODRY', 'M', 'MEDAN', '0000-00-00', 0, 0, 'Jl. Beo, Gg. Rahim No. 3, Kel. Sei Sikambing B, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240046@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 16:59:57', '2024-12-20 09:59:57', NULL, NULL, 1, 0, 0, 0, 'false'),
(47, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240050', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MAULANA SIDIQ', 'M', 'MEDAN', '0000-00-00', 0, 0, 'Jl. Garuda No. 106 Kel. Sei Sikambing B, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240050@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 16:59:57', '2024-12-20 09:59:57', NULL, NULL, 1, 0, 0, 0, 'false'),
(48, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240051', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MESYA ALVIRA DWITAMI', 'F', 'MEDAN', '0000-00-00', 0, 0, 'Jl. Balam No. 68E, Kel. Sei Sikambing B, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240051@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 16:59:57', '2024-12-20 09:59:57', NULL, NULL, 1, 0, 0, 0, 'false'),
(49, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240055', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MUHAMMAD DICKY ALFATTAN TARIGAN', 'M', 'MEDAN', '0000-00-00', 0, 0, 'Jl. Tempua Kamp. Tempua Indah E-18, Kel. Sei Sikambing B, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240055@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 16:59:57', '2024-12-20 09:59:57', NULL, NULL, 1, 0, 0, 0, 'false'),
(50, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240049', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MUHAMMAD RAIHANSYAH', 'M', 'MEDAN', '0000-00-00', 0, 0, 'Jl. Garuda No. 70, Kel. Sei Sikambing, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240049@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 16:59:57', '2024-12-20 09:59:57', NULL, NULL, 1, 0, 0, 0, 'false'),
(51, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240058', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MUHAMMAD REZEKI', 'M', 'MEDAN', '0000-00-00', 0, 0, 'Jl Kasuari Gg Buntu No 36D, Kel. SEI SIKAMBING B, Kec. MEDAN SUNGGAL, SUMATERA UTARA, 20122', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240058@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 16:59:57', '2024-12-20 09:59:57', NULL, NULL, 1, 0, 0, 0, 'false'),
(52, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240062', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'NAYYATUL KHAIRI', 'F', 'MEDAN', '0000-00-00', 0, 0, 'JL PERJUANGAN GG BERSAMA N0 2 LK 22, Kel. TANJUNG REJO, Kec. MEDAN SUNGGAL, SUMATERA UTARA, 20122', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240062@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 16:59:57', '2024-12-20 09:59:57', NULL, NULL, 1, 0, 0, 0, 'false'),
(53, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240065', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'NUR INDAH', 'F', 'MEDAN', '0000-00-00', 0, 0, 'Jl. Kasuari, Gg. Sosial No. 3, Kel. Sei Sikambing B, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240065@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 16:59:57', '2024-12-20 09:59:57', NULL, NULL, 1, 0, 0, 0, 'false'),
(54, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240067', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'RADIT PRATAMA', 'M', 'MEDAN', '0000-00-00', 0, 0, 'Jl. Kiwi No.14/61,Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240067@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 16:59:57', '2024-12-20 09:59:57', NULL, NULL, 1, 0, 0, 0, 'false'),
(55, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240071', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'RAISYA PUTRI SIMATUPANG', 'F', 'MEDAN', '0000-00-00', 0, 0, 'JL KASWARI GG SENYUM N0.11 DALAM, Kel. SEI SIKAMBING B, Kec. MEDAN SUNGGAL, SUMATERA UTARA, 20122', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240071@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 16:59:57', '2024-12-20 09:59:57', NULL, NULL, 1, 0, 0, 0, 'false'),
(56, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240072', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'RASYID AL JABBAR', 'M', 'MEDAN', '0000-00-00', 0, 0, 'Jl. Merpati Gg. Amanah No.53 B, Kel. Sei Sikambing B, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240072@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 16:59:57', '2024-12-20 09:59:57', NULL, NULL, 1, 0, 0, 0, 'false'),
(57, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240093', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'SALWA SYAHIRAH', 'F', 'LANGKAT', '0000-00-00', 0, 0, 'JL. BALAM GG. MUSLIM NO. 44 H, Kel. SEI SIKAMBING B, Kec. MEDAN SUNGGAL, SUMATERA UTARA, 20128', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240093@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 16:59:57', '2024-12-20 09:59:57', NULL, NULL, 1, 0, 0, 0, 'false'),
(58, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240077', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'SANDY SETIADI', 'M', 'BANDUNG', '0000-00-00', 0, 0, 'Jl. Balam, Gg. Malau, Kel. Sei Sikambing B, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240077@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 16:59:57', '2024-12-20 09:59:57', NULL, NULL, 1, 0, 0, 0, 'false'),
(59, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240079', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'SITI MUTIARA DEWI', 'F', 'DUMAI', '0000-00-00', 0, 0, 'Jl. Kaswari No. 44, Kel. Sei Sikambing B, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240079@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 16:59:57', '2024-12-20 09:59:57', NULL, NULL, 1, 0, 0, 0, 'false'),
(60, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240083', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'TIARA SAPUTRI', 'F', 'LANGKAT', '0000-00-00', 0, 0, 'Jl. Balam Gg. Pribadi, Kel. Sei Sikambing B, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240083@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 16:59:57', '2024-12-20 09:59:57', NULL, NULL, 1, 0, 0, 0, 'false'),
(61, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240089', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'ZAHIRA RIZKYA', 'F', 'MEDAN', '0000-00-00', 0, 0, 'Jl. Legawa Tengah K-372, Kel. PB Selayang II, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240089@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 16:59:57', '2024-12-20 09:59:57', NULL, NULL, 1, 0, 0, 0, 'false'),
(62, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240004', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'AMANDA', 'F', 'MEDAN', '0000-00-00', 0, 0, 'Jl. Perjuangan, Gg. Buntu, Kel. Tanjung Rejo, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240004@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 17:02:09', '2024-12-20 10:02:09', NULL, NULL, 1, 0, 0, 0, 'false'),
(63, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240005', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'ANGGA WIJAYA', 'M', 'MEDAN', '0000-00-00', 0, 0, 'JL SETIABUDI, Kel. TANJUNG REJO, Kec. MEDAN SUNGGAL, SUMATERA UTARA, 20122', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240005@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 17:02:09', '2024-12-20 10:02:09', NULL, NULL, 1, 0, 0, 0, 'false'),
(64, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240009', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'AZRIL HASRI', 'M', 'MEDAN', '0000-00-00', 0, 0, 'Jl. Balam, Gg. Gajah, Kel. Sei Sikambing B, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240009@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 17:02:09', '2024-12-20 10:02:09', NULL, NULL, 1, 0, 0, 0, 'false'),
(65, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240011', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'BUNGA NOVITA SARI', 'F', 'MEDAN', '0000-00-00', 0, 0, 'Jl. Bunga Raya, Asam Kumbang', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240011@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 17:02:09', '2024-12-20 10:02:09', NULL, NULL, 1, 0, 0, 0, 'false'),
(66, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240014', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Daffa fakhrurrazi', 'M', 'Bandar Negeri', '0000-00-00', 0, 0, 'Jl. Balai Desa, Gg. Wakaf No. 42,Kel. Sunggal, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240014@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 17:02:09', '2024-12-20 10:02:09', NULL, NULL, 1, 0, 0, 0, 'false'),
(67, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240016', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'DEBY MEISYA AULIA', 'F', 'MEDAN', '0000-00-00', 0, 0, 'JL SUNGGAL GG MANDALA, Kel. TANJUNG REJO, Kec. MEDAN SUNGGAL, SUMATERA UTARA, 20122', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240016@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 17:02:09', '2024-12-20 10:02:09', NULL, NULL, 1, 0, 0, 0, 'false'),
(68, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240020', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'DIFA KURNIAWAN', 'M', 'MEDAN', '0000-00-00', 0, 0, 'Jl. Perjuangan, Gg. Buntu No. 42A, Kel. Tanjung Rejo, Kec.  Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240020@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 17:02:09', '2024-12-20 10:02:09', NULL, NULL, 1, 0, 0, 0, 'false'),
(69, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240024', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'FAKHRI AHMAD SIREGAR', 'M', 'BATAM', '0000-00-00', 0, 0, 'Jl. Bakti Luhur, Gg. Sempurna, Kl. Dwi Kora, Kec. Medan Helvetia', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240024@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 17:02:09', '2024-12-20 10:02:09', NULL, NULL, 1, 0, 0, 0, 'false'),
(70, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240025', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'FATHIYAH AQILA ZAHRA', 'F', 'MEDAN', '0000-00-00', 0, 0, 'Jl. Balam Gg. Panda No. 37 F Lk 13, Kel. SEI SIKAMBING B, Kec. MEDAN SUNGGAL, SUMATERA UTARA, 20122', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240025@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 17:02:09', '2024-12-20 10:02:09', NULL, NULL, 1, 0, 0, 0, 'false'),
(71, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240027', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'FIKRI PRATAMA', 'M', 'MEDAN', '0000-00-00', 0, 0, 'JL BEO GG RAHIM NO 3, Kel. SEI SIKAMBING B, Kec. MEDAN SUNGGAL, SUMATERA UTARA, 20122', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240027@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 17:02:09', '2024-12-20 10:02:09', NULL, NULL, 1, 0, 0, 0, 'false'),
(72, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240030', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Gisca Aurel Nur Faiza', 'F', 'Medan', '0000-00-00', 0, 0, 'Jl. Seroja, Kel. Sunggal, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240030@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 17:02:09', '2024-12-20 10:02:09', NULL, NULL, 1, 0, 0, 0, 'false'),
(73, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240032', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'HAFIF GUMILAR', 'M', 'MEDAN', '0000-00-00', 0, 0, 'JL GEMINASTITI TIMUR K 489 MEDAN, Kel. TANJUNG REJO, Kec. MEDAN SUNGGAL, SUMATERA UTARA, 20122', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240032@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 17:02:09', '2024-12-20 10:02:09', NULL, NULL, 1, 0, 0, 0, 'false'),
(74, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240036', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'KATIKA DEWI', 'F', 'MEDAN', '0000-00-00', 0, 0, 'JL. SEROJA NO. 80, Kel. SUNGGAL, Kec. MEDAN SUNGGAL, SUMATERA UTARA, 20128', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240036@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 17:02:09', '2024-12-20 10:02:09', NULL, NULL, 1, 0, 0, 0, 'false'),
(75, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240038', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'KEANU BONDAN ALFALAH RIKUMAHU', 'M', 'MEDAN', '0000-00-00', 0, 0, 'Jl Gelatik Gg Keluarga No 5 Lk II, Kec. MEDAN SUNGGAL, SUMATERA UTARA, 20122', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240038@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 17:02:09', '2024-12-20 10:02:09', NULL, NULL, 1, 0, 0, 0, 'false'),
(76, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240041', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'KHAIRUMAN ALI LUBIS', 'M', 'MEDAN', '0000-00-00', 0, 0, 'Jl. Beringin, Gg. Sehat No. 12, Kel. Sunggal, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240041@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 17:02:09', '2024-12-20 10:02:09', NULL, NULL, 1, 0, 0, 0, 'false'),
(77, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240047', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'M RAFFI', 'M', 'MEDAN', '0000-00-00', 0, 0, 'Jl. Balai Desa, Gg. Wakaf No. 39, Kel. Sunggal, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240047@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 17:02:09', '2024-12-20 10:02:09', NULL, NULL, 1, 0, 0, 0, 'false'),
(78, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240044', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'M. FADRI ANWAR', 'M', 'MEDAN', '0000-00-00', 0, 0, 'Jl. Brayan, Gg. Turi No. 11, Kel. P Berayan Darat II, Kec. Medan Timur', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240044@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 17:02:09', '2024-12-20 10:02:09', NULL, NULL, 1, 0, 0, 0, 'false');
INSERT INTO `students` (`id`, `major_id`, `first_choice_id`, `second_choice_id`, `registration_number`, `admission_exam_number`, `selection_result`, `admission_phase_id`, `admission_type_id`, `photo`, `achievement`, `is_student`, `is_prospective_student`, `is_alumni`, `is_transfer`, `re_registration`, `start_date`, `identity_number`, `nisn`, `nik`, `prev_exam_number`, `prev_diploma_number`, `paud`, `tk`, `skhun`, `prev_school_name`, `prev_school_address`, `hobby`, `ambition`, `full_name`, `gender`, `birth_place`, `birth_date`, `religion_id`, `special_need_id`, `street_address`, `rt`, `rw`, `sub_village`, `village`, `sub_district`, `district`, `postal_code`, `residence_id`, `transportation_id`, `phone`, `mobile_phone`, `email`, `sktm`, `kks`, `kps`, `kip`, `kis`, `citizenship`, `country`, `father_name`, `father_birth_year`, `father_education_id`, `father_employment_id`, `father_monthly_income_id`, `father_special_need_id`, `mother_name`, `mother_birth_year`, `mother_education_id`, `mother_employment_id`, `mother_monthly_income_id`, `mother_special_need_id`, `guardian_name`, `guardian_birth_year`, `guardian_education_id`, `guardian_employment_id`, `guardian_monthly_income_id`, `mileage`, `traveling_time`, `height`, `weight`, `sibling_number`, `student_status_id`, `end_date`, `reason`, `created_at`, `updated_at`, `deleted_at`, `restored_at`, `created_by`, `updated_by`, `deleted_by`, `restored_by`, `is_deleted`) VALUES
(79, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240054', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Muhammad Budi Hariadi', 'M', 'Medan', '0000-00-00', 0, 0, 'Jl. Merak, Gg. Adil No. 5, Kel. Sei Sikambing B, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240054@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 17:02:09', '2024-12-20 10:02:09', NULL, NULL, 1, 0, 0, 0, 'false'),
(80, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240056', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MUHAMMAD DIRZA', 'M', 'MEDAN', '0000-00-00', 0, 0, 'JL ABADI GG BUDI NO 33 B, Kel. TANJUNG REJO, Kec. MEDAN SUNGGAL, SUMATERA UTARA, 20122', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240056@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 17:02:09', '2024-12-20 10:02:09', NULL, NULL, 1, 0, 0, 0, 'false'),
(81, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240059', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Muhammad Zaki Al Azizi', 'M', 'Medan', '0000-00-00', 0, 0, 'Jl. Garuda, Gg. Hidayah, Kel. Sei Sikambing B, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240059@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 17:02:09', '2024-12-20 10:02:09', NULL, NULL, 1, 0, 0, 0, 'false'),
(82, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240061', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'NABILA', 'F', 'BELAWAN', '0000-00-00', 0, 0, 'Jl. Tempua, Gg. Family No. 2, Kel. Sei Sikambing B, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240061@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 17:02:09', '2024-12-20 10:02:09', NULL, NULL, 1, 0, 0, 0, 'false'),
(83, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240064', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Nur Aisyah Ramadhani', 'F', 'Medan', '0000-00-00', 0, 0, 'Jl. Pasar II, Gg. Samosir, Kel. Sunggal, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240064@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 17:02:09', '2024-12-20 10:02:09', NULL, NULL, 1, 0, 0, 0, 'false'),
(84, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240068', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'RAFI AL FARIZ', 'M', 'MEDAN', '0000-00-00', 0, 0, 'Jl. Merak, Gg. Keluarga No. 6, Kel. Sei Sikambing B, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240068@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 17:02:09', '2024-12-20 10:02:09', NULL, NULL, 1, 0, 0, 0, 'false'),
(85, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240070', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'RAISHA SYAHPUTRI', 'F', 'SEI MUKA', '0000-00-00', 0, 0, 'JL SETIABUDI, Kel. TANJUNG REJO, Kec. MEDAN SUNGGAL, SUMATERA UTARA, 20122', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240070@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 17:02:09', '2024-12-20 10:02:09', NULL, NULL, 1, 0, 0, 0, 'false'),
(86, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240073', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'RAZA GHAZAWAN SYAHPUTRA', 'M', 'MEDAN', '0000-00-00', 0, 0, 'Jl. Sunggal No. 22, Kel&lt; Sei Sikambing B, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240073@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 17:02:09', '2024-12-20 10:02:09', NULL, NULL, 1, 0, 0, 0, 'false'),
(87, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240074', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'REIKA SALSAH BILAH', 'F', 'MEDAN', '0000-00-00', 0, 0, 'Jl. Kenanga No. 9', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240074@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 17:02:09', '2024-12-20 10:02:09', NULL, NULL, 1, 0, 0, 0, 'false'),
(88, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240078', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Satria Bagas Pratama', 'M', 'Medan', '0000-00-00', 0, 0, 'Jl. Kasuari, Gg. Sosial, Kel. SEI SIKAMBING B, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240078@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 17:02:09', '2024-12-20 10:02:09', NULL, NULL, 1, 0, 0, 0, 'false'),
(89, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240081', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Syawalani Fitri Humairah Batu Bara', 'F', 'Medan', '0000-00-00', 0, 0, 'Jl. Hang Tuan, Kel. Percut, Kec. Percut Sei Tuan, Kab. Deli Serdang', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240081@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 17:02:09', '2024-12-20 10:02:09', NULL, NULL, 1, 0, 0, 0, 'false'),
(90, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240085', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'TRIA NABILLA SARI', 'F', 'MEDAN', '0000-00-00', 0, 0, 'Jl. Kiwi, Gg. Buntu, Kel. Sei Sikambing, Kec, Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240085@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 17:02:09', '2024-12-20 10:02:09', NULL, NULL, 1, 0, 0, 0, 'false'),
(91, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240086', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'VAYLA SIFA AZKYA', 'F', 'MEDAN', '0000-00-00', 0, 0, 'Jl. Beringin Gg, Musholla No. 28 A, Kel. SUNGGAL, Kec. MEDAN SUNGGAL, SUMATERA UTARA, 20128', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240086@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 17:02:09', '2024-12-20 10:02:09', NULL, NULL, 1, 0, 0, 0, 'false'),
(92, 0, 0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 'true', 'false', 'false', 'false', NULL, NULL, '240088', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Zahira Khaila Putri Sabri', 'F', 'Medan', '0000-00-00', 0, 0, 'Jl. Merak, Gg. Keluarga No. 8, Kel. Sei Sikambing B, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, '240088@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 'WNI', NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, '2024-12-20 17:02:09', '2024-12-20 10:02:09', NULL, NULL, 1, 0, 0, 0, 'false');

-- --------------------------------------------------------

--
-- Struktur dari tabel `subjects`
--

DROP TABLE IF EXISTS `subjects`;
CREATE TABLE IF NOT EXISTS `subjects` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `subject_name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  `restored_at` datetime DEFAULT NULL,
  `created_by` bigint DEFAULT '0',
  `updated_by` bigint DEFAULT '0',
  `deleted_by` bigint DEFAULT '0',
  `restored_by` bigint DEFAULT '0',
  `is_deleted` enum('true','false') DEFAULT 'false',
  PRIMARY KEY (`id`),
  UNIQUE KEY `subject_name` (`subject_name`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb3;

--
-- Dumping data untuk tabel `subjects`
--

INSERT INTO `subjects` (`id`, `subject_name`, `created_at`, `updated_at`, `deleted_at`, `restored_at`, `created_by`, `updated_by`, `deleted_by`, `restored_by`, `is_deleted`) VALUES
(1, 'Matematika', '2023-01-29 03:50:23', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(2, 'Bahasa Indonesia', '2023-01-29 03:50:23', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(3, 'Bahasa Inggris', '2023-01-29 03:50:23', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(4, 'Al Qur`an Hadis', '2024-12-24 10:11:43', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(5, 'Akidah Akhlak', '2024-12-24 10:11:57', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(6, 'Fikih', '2024-12-24 10:12:14', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(7, 'Sejarah Kebudayaan Islam', '2024-12-24 10:12:25', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(8, 'Bahasa Arab', '2024-12-24 10:12:38', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(9, 'Pendidikan Pancasila', '2024-12-24 10:12:48', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(10, 'Fisika', '2024-12-24 10:13:00', '2024-12-24 13:57:40', NULL, NULL, 1, 1, 0, 0, 'false'),
(11, 'Geografi', '2024-12-24 10:13:10', '2024-12-24 13:58:24', NULL, NULL, 1, 1, 0, 0, 'false'),
(12, 'Pendidikan Jasmani, Olahraga dan Kesehatan', '2024-12-24 10:13:20', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(13, 'Informatika', '2024-12-24 10:13:30', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(14, 'Seni Budaya / Prakarya', '2024-12-24 10:13:45', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(15, 'Praktik Ibadah', '2024-12-24 10:13:54', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(16, 'Kimia', '2024-12-24 13:57:50', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(17, 'Biologi', '2024-12-24 13:57:59', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(18, 'Ekonomi', '2024-12-24 13:58:35', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(19, 'Sejarah', '2024-12-24 13:58:48', NULL, NULL, NULL, 1, 0, 0, 0, 'false');

-- --------------------------------------------------------

--
-- Struktur dari tabel `subscribers`
--

DROP TABLE IF EXISTS `subscribers`;
CREATE TABLE IF NOT EXISTS `subscribers` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `email` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  `restored_at` datetime DEFAULT NULL,
  `created_by` bigint DEFAULT '0',
  `updated_by` bigint DEFAULT '0',
  `deleted_by` bigint DEFAULT '0',
  `restored_by` bigint DEFAULT '0',
  `is_deleted` enum('true','false') DEFAULT 'false',
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Struktur dari tabel `tags`
--

DROP TABLE IF EXISTS `tags`;
CREATE TABLE IF NOT EXISTS `tags` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tag` varchar(255) NOT NULL,
  `slug` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  `restored_at` datetime DEFAULT NULL,
  `created_by` bigint DEFAULT '0',
  `updated_by` bigint DEFAULT '0',
  `deleted_by` bigint DEFAULT '0',
  `restored_by` bigint DEFAULT '0',
  `is_deleted` enum('true','false') DEFAULT 'false',
  PRIMARY KEY (`id`),
  UNIQUE KEY `tag` (`tag`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;

--
-- Dumping data untuk tabel `tags`
--

INSERT INTO `tags` (`id`, `tag`, `slug`, `created_at`, `updated_at`, `deleted_at`, `restored_at`, `created_by`, `updated_by`, `deleted_by`, `restored_by`, `is_deleted`) VALUES
(1, 'Berita', 'berita', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(2, 'Pengumuman', 'pengumuman', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false'),
(3, 'Sekilas Info', 'sekilas-info', '2023-01-29 03:50:24', NULL, NULL, NULL, 0, 0, 0, 0, 'false');

-- --------------------------------------------------------

--
-- Struktur dari tabel `themes`
--

DROP TABLE IF EXISTS `themes`;
CREATE TABLE IF NOT EXISTS `themes` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `theme_name` varchar(255) NOT NULL,
  `theme_folder` varchar(255) DEFAULT NULL,
  `theme_author` varchar(255) DEFAULT NULL,
  `is_active` enum('true','false') DEFAULT 'false',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  `restored_at` datetime DEFAULT NULL,
  `created_by` bigint DEFAULT '0',
  `updated_by` bigint DEFAULT '0',
  `deleted_by` bigint DEFAULT '0',
  `restored_by` bigint DEFAULT '0',
  `is_deleted` enum('true','false') DEFAULT 'false',
  PRIMARY KEY (`id`),
  UNIQUE KEY `theme_name` (`theme_name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;

--
-- Dumping data untuk tabel `themes`
--

INSERT INTO `themes` (`id`, `theme_name`, `theme_folder`, `theme_author`, `is_active`, `created_at`, `updated_at`, `deleted_at`, `restored_at`, `created_by`, `updated_by`, `deleted_by`, `restored_by`, `is_deleted`) VALUES
(1, 'Theme 1', '1', 'Admin', 'false', '2023-01-29 03:50:24', '2024-12-24 14:06:45', NULL, NULL, 1, 1, 0, 0, 'false'),
(2, 'Theme 2', '2', 'Admin', 'true', '2023-01-29 03:50:24', '2024-12-26 10:27:13', NULL, NULL, 1, 1, 0, 0, 'false'),
(3, 'Theme 3', '3', 'Admin', 'false', '2023-01-29 03:50:24', '2024-12-26 07:03:01', NULL, NULL, 1, 1, 0, 0, 'false'),
(4, 'Theme 4', '4', 'Admin', 'false', '2023-01-29 03:50:24', '2024-12-26 10:27:13', NULL, NULL, 1, 1, 0, 0, 'false'),
(5, 'green_land', 'green_land', 'Admin', 'false', '2024-12-24 09:38:11', '2024-12-26 07:05:12', NULL, NULL, 1, 1, 0, 0, 'false');

-- --------------------------------------------------------

--
-- Struktur dari tabel `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `is_super_admin` enum('true','false') NOT NULL DEFAULT 'false' COMMENT 'Super Admin?',
  `is_admin` enum('true','false') NOT NULL DEFAULT 'false' COMMENT 'Admin?',
  `is_employee` enum('true','false') NOT NULL DEFAULT 'false' COMMENT 'Tenaga Kependidikan?',
  `is_prospective_student` enum('true','false') NOT NULL DEFAULT 'false' COMMENT 'Apakah Calon Siswa Baru?',
  `is_student` enum('true','false') NOT NULL DEFAULT 'false' COMMENT 'Apakah Siswa Aktif ? Set true jika lolos seleksi PPDB dan set FALSE jika sudah lulus',
  `is_alumni` enum('true','false','unverified') NOT NULL DEFAULT 'false' COMMENT 'Apakah Alumni?',
  `password` varchar(100) DEFAULT NULL,
  `user_group_id` bigint DEFAULT '0',
  `forgot_password_key` varchar(100) DEFAULT NULL,
  `forgot_password_request_date` date DEFAULT NULL,
  `active` enum('true','false') DEFAULT 'false',
  `last_active` datetime DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `is_transfer` enum('true','false') NOT NULL DEFAULT 'false' COMMENT 'Jenis Pendaftaran : Baru / Pindahan?',
  `major_id` bigint DEFAULT '0' COMMENT 'Program Keahlian',
  `admission_type_id` bigint DEFAULT '0' COMMENT 'Jenis Pendaftaran',
  `start_date` date DEFAULT NULL COMMENT 'Tanggal Masuk Sekolah',
  `prev_school_name` varchar(255) DEFAULT NULL COMMENT 'Sekolah Asal',
  `prev_exam_number` varchar(50) DEFAULT NULL COMMENT 'Nomor Peserta UN SMP/MTs',
  `prev_diploma_number` varchar(50) DEFAULT NULL COMMENT 'No. Seri Ijazah SMP/MTs',
  `skhun` varchar(50) DEFAULT NULL COMMENT 'No. Seri Surat Keterangan Hasil Ujian Nasional Sebelumnya',
  `first_choice_id` bigint DEFAULT '0' COMMENT 'Pilihan Pertama PPDB',
  `second_choice_id` bigint DEFAULT '0' COMMENT 'Pilihan Kedua PPDB',
  `registration_number` varchar(10) DEFAULT NULL COMMENT 'Nomor Pendaftaran',
  `admission_phase_id` bigint DEFAULT '0' COMMENT 'Gelombang Pendaftaran',
  `re_registration` enum('true','false') DEFAULT NULL COMMENT 'Konfirmasi Pendaftaran Ulang Calon Siswa Baru',
  `selection_result` varchar(100) DEFAULT NULL COMMENT 'Hasil Seleksi PPDB',
  `photo` varchar(100) DEFAULT NULL,
  `family_card` varchar(100) DEFAULT NULL COMMENT 'Kartu Keluarga',
  `birth_certificate` varchar(100) DEFAULT NULL COMMENT 'Akta Lahir',
  `full_name` varchar(150) NOT NULL,
  `gender` enum('M','F') NOT NULL DEFAULT 'M',
  `nis` varchar(25) DEFAULT NULL COMMENT 'Nomor Induk Siswa',
  `nisn` varchar(25) DEFAULT NULL COMMENT 'Nomor Induk Siswa Nasional',
  `nik` varchar(25) DEFAULT NULL COMMENT 'NIK/ No. KITAS (Untuk WNA)',
  `family_card_number` varchar(50) DEFAULT NULL COMMENT 'Nomor Kartu Keluarga',
  `birth_place` varchar(255) DEFAULT NULL,
  `birth_date` date DEFAULT NULL,
  `birth_certificate_number` varchar(50) DEFAULT NULL COMMENT 'Nomor Registasi Akta Lahir',
  `religion_id` bigint DEFAULT '0',
  `citizenship` enum('WNI','WNA') NOT NULL DEFAULT 'WNI' COMMENT 'Kewarganegaraan',
  `country` varchar(255) DEFAULT NULL,
  `special_need_id` bigint DEFAULT '0' COMMENT 'Berkebutuhan Khusus',
  `street_address` varchar(255) DEFAULT NULL COMMENT 'Alamat Jalan',
  `rt` varchar(10) DEFAULT NULL COMMENT 'Alamat Jalan',
  `rw` varchar(10) DEFAULT NULL COMMENT 'Alamat Jalan',
  `sub_village` varchar(255) DEFAULT NULL COMMENT 'Nama Dusun',
  `village` varchar(255) DEFAULT NULL COMMENT 'Desa/Kelurahan',
  `sub_district` varchar(255) DEFAULT NULL COMMENT 'Kecamatan',
  `district` varchar(255) DEFAULT NULL COMMENT 'Kabupaten',
  `postal_code` varchar(20) DEFAULT NULL COMMENT 'Kode POS',
  `latitude` varchar(30) DEFAULT NULL COMMENT 'Titik koordinat tempat tinggal siswa',
  `longitude` varchar(30) DEFAULT NULL COMMENT 'Titik koordinat tempat tinggal siswa',
  `residence_id` bigint DEFAULT '0' COMMENT 'Kepemilikan tempat tinggal peserta didik saat ini (yang telah diisikan pada kolom-kolom sebelumnya di atas)',
  `transportation_id` bigint DEFAULT '0' COMMENT 'Jenis transportasi utama atau yang paling sering digunakan peserta didik untuk berangkat ke sekolah',
  `child_number` smallint DEFAULT '0' COMMENT 'Anak Ke Berapa',
  `employment_id` bigint DEFAULT '0' COMMENT 'Pekerjaan (diperuntukan untuk warga belajar)',
  `have_kip` enum('true','false') DEFAULT 'false' COMMENT 'Apakah punya KIP',
  `receive_kip` enum('true','false') DEFAULT 'false' COMMENT 'Apakah peserta didik tersebut tetap akan menerima KIP',
  `reject_pip` bigint DEFAULT '0' COMMENT 'Alasan Menolak PIP',
  `father_name` varchar(150) DEFAULT NULL,
  `father_nik` varchar(16) DEFAULT NULL COMMENT 'NIK/ No. KITAS (Untuk WNA)',
  `father_birth_place` varchar(255) DEFAULT NULL,
  `father_birth_date` date DEFAULT NULL,
  `father_education_id` bigint DEFAULT '0',
  `father_employment_id` bigint DEFAULT '0',
  `father_monthly_income_id` bigint DEFAULT '0',
  `father_special_need_id` bigint DEFAULT '0',
  `father_identity_card` varchar(100) DEFAULT NULL,
  `mother_name` varchar(150) DEFAULT NULL,
  `mother_nik` varchar(16) DEFAULT NULL COMMENT 'NIK/ No. KITAS (Untuk WNA)',
  `mother_birth_place` varchar(255) DEFAULT NULL,
  `mother_birth_date` date DEFAULT NULL,
  `mother_education_id` bigint DEFAULT '0',
  `mother_employment_id` bigint DEFAULT '0',
  `mother_monthly_income_id` bigint DEFAULT '0',
  `mother_special_need_id` bigint DEFAULT '0',
  `mother_identity_card` varchar(100) DEFAULT NULL,
  `guardian_name` varchar(150) DEFAULT NULL,
  `guardian_nik` varchar(16) DEFAULT NULL COMMENT 'NIK/ No. KITAS (Untuk WNA)',
  `guardian_birth_place` varchar(255) DEFAULT NULL,
  `guardian_birth_date` date DEFAULT NULL,
  `guardian_education_id` bigint DEFAULT '0',
  `guardian_employment_id` bigint DEFAULT '0',
  `guardian_monthly_income_id` bigint DEFAULT '0',
  `guardian_identity_card` varchar(100) DEFAULT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `mobile_phone` varchar(50) DEFAULT NULL,
  `email` varchar(150) NOT NULL,
  `height` smallint DEFAULT NULL COMMENT 'Tinggi Badan',
  `weight` smallint DEFAULT NULL COMMENT 'Berat Badan',
  `head_circumference` smallint DEFAULT NULL COMMENT 'Lingkar Kepala',
  `mileage` smallint DEFAULT NULL COMMENT 'Jarak tempat tinggal ke sekolah',
  `traveling_time` smallint DEFAULT NULL COMMENT 'Waktu Tempuh',
  `sibling_number` smallint DEFAULT '0' COMMENT 'Jumlah Saudara Kandung',
  `welfare_type` varchar(2) DEFAULT NULL COMMENT 'Jenis Kesejahteraan: 01:PKH, 02:PIP, 03:Kartu Perlindungan Sosial, 04:Kartu Keluarga Sejahtera  05:Kartu Kesehatan',
  `welfare_number` varchar(100) DEFAULT NULL COMMENT 'No. Kartu Kesejahteraan',
  `welfare_name` varchar(100) DEFAULT NULL COMMENT 'Nama di Kartu Kesejahteraan',
  `student_status_id` bigint DEFAULT '0' COMMENT 'Status siswa',
  `end_date` date DEFAULT NULL COMMENT 'Tanggal saat peserta didik diketahui/tercatat keluar dari sekolah',
  `reason` varchar(255) DEFAULT NULL COMMENT 'Alasan khusus yang melatarbelakangi peserta didik keluar dari sekolah',
  `employment_type_id` bigint DEFAULT '0' COMMENT 'Jenis Guru dan Tenaga Kependidikan (GTK)',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  `restored_at` datetime DEFAULT NULL,
  `created_by` bigint DEFAULT '0',
  `updated_by` bigint DEFAULT '0',
  `deleted_by` bigint DEFAULT '0',
  `restored_by` bigint DEFAULT '0',
  `is_deleted` enum('true','false') DEFAULT 'false',
  PRIMARY KEY (`id`),
  KEY `users_registration_number__idx` (`registration_number`) USING BTREE,
  KEY `users_nis__idx` (`nis`) USING BTREE,
  KEY `users_full_name__idx` (`full_name`) USING BTREE,
  KEY `users_email__idx` (`email`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8mb3;

--
-- Dumping data untuk tabel `users`
--

INSERT INTO `users` (`id`, `is_super_admin`, `is_admin`, `is_employee`, `is_prospective_student`, `is_student`, `is_alumni`, `password`, `user_group_id`, `forgot_password_key`, `forgot_password_request_date`, `active`, `last_active`, `ip_address`, `is_transfer`, `major_id`, `admission_type_id`, `start_date`, `prev_school_name`, `prev_exam_number`, `prev_diploma_number`, `skhun`, `first_choice_id`, `second_choice_id`, `registration_number`, `admission_phase_id`, `re_registration`, `selection_result`, `photo`, `family_card`, `birth_certificate`, `full_name`, `gender`, `nis`, `nisn`, `nik`, `family_card_number`, `birth_place`, `birth_date`, `birth_certificate_number`, `religion_id`, `citizenship`, `country`, `special_need_id`, `street_address`, `rt`, `rw`, `sub_village`, `village`, `sub_district`, `district`, `postal_code`, `latitude`, `longitude`, `residence_id`, `transportation_id`, `child_number`, `employment_id`, `have_kip`, `receive_kip`, `reject_pip`, `father_name`, `father_nik`, `father_birth_place`, `father_birth_date`, `father_education_id`, `father_employment_id`, `father_monthly_income_id`, `father_special_need_id`, `father_identity_card`, `mother_name`, `mother_nik`, `mother_birth_place`, `mother_birth_date`, `mother_education_id`, `mother_employment_id`, `mother_monthly_income_id`, `mother_special_need_id`, `mother_identity_card`, `guardian_name`, `guardian_nik`, `guardian_birth_place`, `guardian_birth_date`, `guardian_education_id`, `guardian_employment_id`, `guardian_monthly_income_id`, `guardian_identity_card`, `phone`, `mobile_phone`, `email`, `height`, `weight`, `head_circumference`, `mileage`, `traveling_time`, `sibling_number`, `welfare_type`, `welfare_number`, `welfare_name`, `student_status_id`, `end_date`, `reason`, `employment_type_id`, `created_at`, `updated_at`, `deleted_at`, `restored_at`, `created_by`, `updated_by`, `deleted_by`, `restored_by`, `is_deleted`) VALUES
(1, 'true', 'false', 'false', 'false', 'false', 'false', '$2y$12$54xFToE1dQY/gYcCGTJ9JuFMT4cqdypjR4dpcJz9fmh/T1luwl81q', 0, NULL, NULL, 'false', '2025-01-10 14:49:06', '127.0.0.1', 'false', 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'Abri Pratama', 'M', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 'WNI', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 'false', 'false', 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, 'super@admin.com', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, 0, '2023-01-29 03:50:24', '2025-01-10 08:02:02', NULL, NULL, NULL, 1, 0, 0, 'false'),
(2, 'false', 'false', 'true', 'false', 'false', 'false', '$2y$12$mJ0WGV14vP3IsRwBhDjip.LrMo1vP3cJl9bjWx3PL8.A5lglCwaGS', 0, NULL, NULL, 'true', '2025-01-27 23:20:13', '127.0.0.1', 'false', 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, NULL, NULL, 'de71a9a8d4b07bc23ee25354986b237b.jpg', NULL, NULL, 'ABRI PRATAMA', 'M', NULL, NULL, '10210285196001', NULL, 'Medan', '1996-10-05', NULL, 94, 'WNI', 'INDONESIA', 0, 'JL. PSR MELINTANG NO. 3D', '010', '028', '0', 'SUNGGAL', 'MEDAN SUNGGAL', 'KOTA MEDAN', '20128', NULL, NULL, 0, 0, 0, 0, 'false', 'false', 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, '082124709720', '082124709720', 'abripratama@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, 127, '2024-12-24 10:08:43', '2025-01-27 16:20:13', NULL, NULL, 1, 1, 0, 0, 'false'),
(3, 'false', 'false', 'true', 'false', 'false', 'false', '$2y$12$9Uvn6u6YJtWYAkZ.X193Nuoq.1sAvg/DYjuqPXluJgps28.SfwFZm', 0, NULL, NULL, 'false', NULL, NULL, 'false', 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, NULL, NULL, '81a7f4716df2269d66c62838e47f2406.png', NULL, NULL, 'ASPANI', 'M', NULL, NULL, '1223032812900002', NULL, 'Sialang Gatap', '1990-10-07', NULL, 0, 'WNI', '', 0, 'Medan, SUMUT', '', '', '', '', '', '', '', NULL, NULL, 0, 0, 0, 0, 'false', 'false', 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, '', '', '1223032812900002@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, 127, '2024-12-24 10:08:44', '2024-12-26 06:17:44', NULL, NULL, 1, 1, 0, 0, 'false'),
(4, 'false', 'false', 'true', 'false', 'false', 'false', '$2y$12$ausZIIMA8hNCOmVkMRRyeuRe8RKpcqLVVH0AKSL5kPHNLw9kxNoUm', 0, NULL, NULL, 'false', NULL, NULL, 'false', 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'ASRI NINGSIH', 'F', NULL, NULL, '1271085908820004', NULL, 'Belawan', '1982-08-19', NULL, 0, 'WNI', '', 0, 'Medan, SUMUT', '', '', '', '', '', '', '', NULL, NULL, 0, 0, 0, 0, 'false', 'false', 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, '', '', '1271085908820004@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, 130, '2024-12-24 10:08:44', '2024-12-24 11:06:49', NULL, NULL, 1, 1, 0, 0, 'false'),
(5, 'false', 'false', 'true', 'false', 'false', 'false', '$2y$12$391L0EhoVDCJ3iewzxYAx.pBySsZDBCfNs8g2yrRsI8C4K7lfOHkW', 0, NULL, NULL, 'false', NULL, NULL, 'false', 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, NULL, NULL, '6a893cdf39482776b30e7b1ef8c4a22b.jpg', NULL, NULL, 'AZHARUDDIN', 'M', NULL, NULL, '8655760661200040', NULL, 'Medan', '1982-03-23', NULL, 0, 'WNI', '', 0, 'Medan, SUMUT', '', '', '', '', '', '', '', NULL, NULL, 0, 0, 0, 0, 'false', 'false', 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, '', '', '8655760661200040@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, 127, '2024-12-24 10:08:44', '2024-12-24 11:07:32', NULL, NULL, 1, 1, 0, 0, 'false'),
(6, 'false', 'false', 'true', 'false', 'false', 'false', '$2y$12$h4iXIUsj0ygU/ozM45ZJ6OEqNuwgax4s1.rzRw1KO8/kFfrPHEYbW', 0, NULL, NULL, 'false', NULL, NULL, 'false', 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, NULL, NULL, '977388444d03d4efdea964d2fd1bef07.jpg', NULL, NULL, 'DANIEL ABDILLAH', 'M', NULL, NULL, '9260767668200003', NULL, 'Medan', '1989-09-28', NULL, 0, 'WNI', '', 0, 'Medan, SUMUT', '', '', '', '', '', '', '', NULL, NULL, 0, 0, 0, 0, 'false', 'false', 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, '', '', '9260767668200003@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, 127, '2024-12-24 10:08:45', '2024-12-24 11:08:10', NULL, NULL, 1, 1, 0, 0, 'false'),
(7, 'false', 'false', 'true', 'false', 'false', 'false', '$2y$12$0keA/pLAH39TxNNSi8HrveoW/8ZDuM5kfLEz2Lh1ojK.hUVatEy3m', 0, NULL, NULL, 'false', NULL, NULL, 'false', 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, NULL, NULL, '48e22357ab51e7aed076ee38032bd28a.jpg', NULL, NULL, 'DONNY', 'M', NULL, NULL, '2047753654200040', NULL, 'Medan', '1975-07-15', NULL, 0, 'WNI', '', 0, 'Medan, SUMUT', '', '', '', '', '', '', '', NULL, NULL, 0, 0, 0, 0, 'false', 'false', 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, '', '', '2047753654200040@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, 127, '2024-12-24 10:08:45', '2024-12-26 06:01:13', NULL, NULL, 1, 1, 0, 0, 'false'),
(8, 'false', 'false', 'true', 'false', 'false', 'false', '$2y$12$HQ0zXQr9SHO9Te3yoUdN3OgxGxntA6IhOs4Djdhyl9KPvhFJ9a28K', 0, NULL, NULL, 'false', NULL, NULL, 'false', 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'IDRIS GINTING', 'M', NULL, NULL, '2633743648200010', NULL, 'Kuta Bunga', '1965-01-03', NULL, 0, 'WNI', '', 0, 'Medan, SUMUT', '', '', '', '', '', '', '', NULL, NULL, 0, 0, 0, 0, 'false', 'false', 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, '', '', '2633743648200010@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, 127, '2024-12-24 10:08:45', '2024-12-24 13:42:38', NULL, NULL, 1, 1, 0, 0, 'false'),
(9, 'false', 'false', 'true', 'false', 'false', 'false', '$2y$12$DNdFvFc6.PlCOg.VfoGBB.iIusgtLTq.NkItehg2IXys9fdvZuibm', 0, NULL, NULL, 'false', NULL, NULL, 'false', 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, NULL, NULL, 'e246480326107cb658ee82e366326c3c.jpg', NULL, NULL, 'HABIBNI RIDHA', 'F', NULL, NULL, '1157752652200000', NULL, 'Medan', '1974-08-25', NULL, 0, 'WNI', '', 0, 'Medan, SUMUT', '', '', '', '', '', '', '', NULL, NULL, 0, 0, 0, 0, 'false', 'false', 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, '', '', '1157752652200000@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, 127, '2024-12-24 10:08:45', '2024-12-26 06:01:22', NULL, NULL, 1, 1, 0, 0, 'false'),
(10, 'false', 'false', 'true', 'false', 'false', 'false', '$2y$12$Vwz7oC6WXvTQb3cb/WVv/OXmesQRXRDRbSDhLRf3xoFxxmZBmTczS', 0, NULL, NULL, 'false', NULL, NULL, 'false', 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, NULL, NULL, 'bf52c3922444b92ce96b0d7208e09875.jpg', NULL, NULL, 'HARUN', 'M', NULL, NULL, '3444750652200060', NULL, 'Benteng', '1972-12-01', NULL, 0, 'WNI', '', 0, 'Medan, SUMUT', '', '', '', '', '', '', '', NULL, NULL, 0, 0, 0, 0, 'false', 'false', 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, '', '', '3444750652200060@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, 127, '2024-12-24 10:08:46', '2024-12-26 06:01:33', NULL, NULL, 1, 1, 0, 0, 'false'),
(11, 'false', 'false', 'true', 'false', 'false', 'false', '$2y$12$MielvlP0v3pEsxlQIYCEE.OE0rZfPrvmfE5klM3ZiJ1nizY4yYuw2', 0, NULL, NULL, 'false', NULL, NULL, 'false', 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, NULL, NULL, '78d19d837e6cf41402b4a4e373199823.jpg', NULL, NULL, 'DINA RAMADHANA', 'F', NULL, NULL, '2255752653300030', NULL, 'Medan', '1974-09-23', NULL, 0, 'WNI', '', 0, 'Medan, SUMUT', '', '', '', '', '', '', '', NULL, NULL, 0, 0, 0, 0, 'false', 'false', 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, '', '', '2255752653300030@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, 127, '2024-12-24 10:08:46', '2024-12-26 06:01:40', NULL, NULL, 1, 1, 0, 0, 'false'),
(12, 'false', 'false', 'true', 'false', 'false', 'false', '$2y$12$SMWNIIeT1N27QdX8bMEaN.3Bzz3v0tU3D.OhSqEMkbgwedM/vEKSK', 0, NULL, NULL, 'false', NULL, NULL, 'false', 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, NULL, NULL, '3c5d8ebb1ac4227f1ab729645363e90c.jpg', NULL, NULL, 'KHAIRANI', 'F', NULL, NULL, '8944745646300020', NULL, 'Medan', '1967-12-06', NULL, 0, 'WNI', '', 0, 'Medan, SUMUT', '', '', '', '', '', '', '', NULL, NULL, 0, 0, 0, 0, 'false', 'false', 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, '', '', '8944745646300020@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, 127, '2024-12-24 10:08:46', '2024-12-26 06:01:52', NULL, NULL, 1, 1, 0, 0, 'false'),
(13, 'false', 'false', 'true', 'false', 'false', 'false', '$2y$12$R2ou0don/oszts2JBwX9LeQosBzsQfYD9oKEOsbklDBV4BLMSq1NG', 0, NULL, NULL, 'false', NULL, NULL, 'false', 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, NULL, NULL, '49bbf9d1070eac76263a1cff61afd70e.jpg', NULL, NULL, 'ZURAIDAH', 'F', NULL, NULL, '0547746647300032', NULL, 'Deli Serdang', '1968-02-15', NULL, 0, 'WNI', '', 0, 'Medan, SUMUT', '', '', '', '', '', '', '', NULL, NULL, 0, 0, 0, 0, 'false', 'false', 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, '', '', '0547746647300032@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, 127, '2024-12-24 10:08:47', '2024-12-26 06:02:04', NULL, NULL, 1, 1, 0, 0, 'false'),
(14, 'false', 'false', 'true', 'false', 'false', 'false', '$2y$12$8qTRfMgNpqO8MGzpUylyk.z4R7s/O9OqKovF.XGE4THpQU2c/8lsO', 0, NULL, NULL, 'false', NULL, NULL, 'false', 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, NULL, NULL, '019a22ad27cca9bda806be95d76c5443.jpg', NULL, NULL, 'IHSAN IRFANDI PAKPAHAN', 'M', NULL, NULL, '10210285194001', NULL, 'Medan', '1994-11-21', NULL, 0, 'WNI', '', 0, 'Medan, SUMUT', '', '', '', '', '', '', '', NULL, NULL, 0, 0, 0, 0, 'false', 'false', 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, '', '', '10210285194001@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, 127, '2024-12-24 10:08:47', '2024-12-26 06:02:12', NULL, NULL, 1, 1, 0, 0, 'false'),
(15, 'false', 'false', 'true', 'false', 'false', 'false', '$2y$12$QNYaTfJ9jrzECBzeIoT3OOAmiVAVhPpBui9LOcXcwhslQKiUSh1SO', 0, NULL, NULL, 'false', NULL, NULL, 'false', 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'JAMHURDIN DHARMA', 'M', NULL, NULL, '10269109193001', NULL, 'Medan', '1993-05-27', NULL, 0, 'WNI', '', 0, 'Medan, SUMUT', '', '', '', '', '', '', '', NULL, NULL, 0, 0, 0, 0, 'false', 'false', 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, '', '', '10269109193001@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, 127, '2024-12-24 10:08:47', '2024-12-24 13:44:56', NULL, NULL, 1, 1, 0, 0, 'false'),
(16, 'false', 'false', 'true', 'false', 'false', 'false', '$2y$12$OaIoU.b1o5bmcgLOgkjvl.y19LrX69RQdffAOCAdX.n9IocLxNDSe', 0, NULL, NULL, 'false', NULL, NULL, 'false', 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, NULL, NULL, 'a52e2f64f0deb789450441466288445e.jpg', NULL, NULL, 'MAYA VERI SAHARA NASUTION', 'F', NULL, NULL, '9133764665300080', NULL, 'Medan', '1986-08-01', NULL, 0, 'WNI', '', 0, 'Medan, SUMUT', '', '', '', '', '', '', '', NULL, NULL, 0, 0, 0, 0, 'false', 'false', 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, '', '', '9133764665300080@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, 127, '2024-12-24 10:08:47', '2024-12-26 06:02:26', NULL, NULL, 1, 1, 0, 0, 'false'),
(17, 'false', 'false', 'true', 'false', 'false', 'false', '$2y$12$.KgG4Ic4xBb0eWH5IqCJ..8y6tOTcJqvgqXaD/DpeXrXmQLBLt7Cm', 0, NULL, NULL, 'false', NULL, NULL, 'false', 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, NULL, NULL, 'c611418d0ec43b94886fab0e76a0daa1.jpg', NULL, NULL, 'MINDIA RAYANI', 'F', NULL, NULL, '3833757658210120', NULL, 'Paya Geli', '1979-05-01', NULL, 0, 'WNI', '', 0, 'Medan, SUMUT', '', '', '', '', '', '', '', NULL, NULL, 0, 0, 0, 0, 'false', 'false', 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, '', '', '3833757658210120@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, 127, '2024-12-24 10:08:48', '2024-12-26 06:02:41', NULL, NULL, 1, 1, 0, 0, 'false'),
(18, 'false', 'false', 'true', 'false', 'false', 'false', '$2y$12$v4A2j6NENA5yl1Q2ZZfrqum0WtaR8rrE3pcOhJEYgIAQ4fOCDrzxa', 0, NULL, NULL, 'false', NULL, NULL, 'false', 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'MUHAMMAD AZRAI', 'M', NULL, NULL, '10267143193002', NULL, 'Medan', '1994-04-08', NULL, 0, 'WNI', '', 0, 'Medan, SUMUT', '', '', '', '', '', '', '', NULL, NULL, 0, 0, 0, 0, 'false', 'false', 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, '', '', '10267143193002@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, 127, '2024-12-24 10:08:48', '2024-12-24 13:46:25', NULL, NULL, 1, 1, 0, 0, 'false'),
(19, 'false', 'false', 'true', 'false', 'false', 'false', '$2y$12$CgmJx55tLUcVHLMaipq3TOKQQKPNaTA5xMWS4BR9nK1B3D5/JNy7K', 0, NULL, NULL, 'false', NULL, NULL, 'false', 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, NULL, NULL, 'c396ca5de5e8507e77f44c2f5cc754ac.jpg', NULL, NULL, 'NURHASANAH', 'F', NULL, NULL, '4148756658300080', NULL, 'Medan', '1978-08-16', NULL, 0, 'WNI', '', 0, 'Medan, SUMUT', '', '', '', '', '', '', '', NULL, NULL, 0, 0, 0, 0, 'false', 'false', 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, '', '', '4148756658300080@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, 127, '2024-12-24 10:08:48', '2024-12-26 06:02:57', NULL, NULL, 1, 1, 0, 0, 'false'),
(20, 'false', 'false', 'true', 'false', 'false', 'false', '$2y$12$nKN8aE7445oh0I8ZW6MMF.QDUQGGQ1cNms7fatld0N9UaBdb.rqNe', 0, NULL, NULL, 'false', NULL, NULL, 'false', 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'RIANI', 'F', NULL, NULL, '1271026512770000', NULL, 'MEDAN', '1977-12-25', NULL, 0, 'WNI', '', 0, 'Medan, SUMUT', '', '', '', '', '', '', '', NULL, NULL, 0, 0, 0, 0, 'false', 'false', 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, '', '', '1271026512770000@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, 127, '2024-12-24 10:08:49', '2024-12-24 13:46:51', NULL, NULL, 1, 1, 0, 0, 'false'),
(21, 'false', 'false', 'true', 'false', 'false', 'false', '$2y$12$FkykuDrE98.Ck8h70.uUgOYxbaTpvSZhny64xi6xR2.kA2c7f97qq', 0, NULL, NULL, 'false', NULL, NULL, 'false', 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, NULL, NULL, 'ee30def67c493899c4bd63543a288ee9.jpg', NULL, NULL, 'RODIAH', 'F', NULL, NULL, '9060746648300060', NULL, 'Medan', '1968-07-28', NULL, 0, 'WNI', '', 0, 'Medan, SUMUT', '', '', '', '', '', '', '', NULL, NULL, 0, 0, 0, 0, 'false', 'false', 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, '', '', '9060746648300060@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, 127, '2024-12-24 10:08:49', '2024-12-26 06:03:05', NULL, NULL, 1, 1, 0, 0, 'false'),
(22, 'false', 'false', 'true', 'false', 'false', 'false', '$2y$12$LzLKM8pVQUUrriFxoTkhp.TpMhQKM4Bp7/M1HVTC4MTqO3U0MQMBq', 0, NULL, NULL, 'false', NULL, NULL, 'false', 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, NULL, NULL, '68fb48bec8e0036c4a0ce43d90469d97.jpg', NULL, NULL, 'SUHARTINI', 'F', NULL, NULL, '5633762664300060', NULL, 'Medan', '1984-03-01', NULL, 0, 'WNI', '', 0, 'Medan, SUMUT', '', '', '', '', '', '', '', NULL, NULL, 0, 0, 0, 0, 'false', 'false', 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, '', '', '5633762664300060@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, 127, '2024-12-24 10:08:49', '2024-12-26 06:03:15', NULL, NULL, 1, 1, 0, 0, 'false'),
(23, 'false', 'false', 'true', 'false', 'false', 'false', '$2y$12$yWR9iPKLY4ginOVn7BSbJemaPkqtmAuwVBs95xobIRyKIozEw8iEG', 0, NULL, NULL, 'false', NULL, NULL, 'false', 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'SYAHRIZAL', 'M', NULL, NULL, '6458752653200020', NULL, 'Medan', '1974-01-26', NULL, 0, 'WNI', '', 0, 'Medan, SUMUT', '', '', '', '', '', '', '', NULL, NULL, 0, 0, 0, 0, 'false', 'false', 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, '', '', '6458752653200020@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, 127, '2024-12-24 10:08:50', '2024-12-24 13:47:35', NULL, NULL, 1, 1, 0, 0, 'false'),
(24, 'false', 'false', 'true', 'false', 'false', 'false', '$2y$12$sFVt/lyfDULYzLwp65I01OhqstbpeByWhFInrCA8AbPSHf.vtaR.O', 0, NULL, NULL, 'false', NULL, NULL, 'false', 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'YENNIYATY HARAHAP', 'F', NULL, NULL, '5236759660210110', NULL, 'Medan', '1981-09-04', NULL, 0, 'WNI', '', 0, 'Medan, SUMUT', '', '', '', '', '', '', '', NULL, NULL, 0, 0, 0, 0, 'false', 'false', 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, '', '', '5236759660210110@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, 127, '2024-12-24 10:08:50', '2024-12-24 13:47:48', NULL, NULL, 1, 1, 0, 0, 'false'),
(25, 'false', 'false', 'true', 'false', 'false', 'false', '$2y$12$hutpG8qxTu1KPmeN.quf8.IADCs2Wktc1/CLxx/xO2L./BMoIecd6', 0, NULL, NULL, 'false', NULL, NULL, 'false', 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'ZULKIFLI', 'M', NULL, NULL, '1259766667200010', NULL, 'Paya Perupu', '1988-09-27', NULL, 0, 'WNI', '', 0, 'Medan, SUMUT', '', '', '', '', '', '', '', NULL, NULL, 0, 0, 0, 0, 'false', 'false', 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, '', '', '1259766667200010@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, 127, '2024-12-24 10:08:50', '2024-12-24 13:48:02', NULL, NULL, 1, 1, 0, 0, 'false'),
(26, 'false', 'false', 'false', 'false', 'true', 'false', '$2y$12$1XJ6CUjZhFwfIT7iGd1Wbu6D593zTlATTUJifkGCW/iAfYk29iAfu', 0, NULL, NULL, 'false', '2025-01-10 00:11:01', '127.0.0.1', 'false', 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'ABDUL MALIK SIREGAR', 'M', '240001', NULL, NULL, NULL, 'SIMPANG BUNTAL', '0000-00-00', NULL, 94, 'WNI', '', 23, 'Jl. Seroja, Kel. Sei SiKambing, Kec. Medan Sunggal', '', '', '', '', '', '', '', NULL, NULL, 0, 0, 0, 0, 'false', 'false', 0, '', '', '', '0000-00-00', 0, 0, 0, 0, NULL, '', '', '', '0000-00-00', 0, 0, 0, 0, NULL, '', '', '', '0000-00-00', 0, 0, 0, NULL, '', '', '240001@mtssypalazhar.sch.id', 0, 0, 0, 0, 0, 0, '02', '', '', 1, NULL, NULL, 0, '2024-12-24 10:41:19', '2025-01-09 17:11:11', NULL, NULL, 1, 26, 0, 0, 'false'),
(27, 'false', 'false', 'false', 'false', 'true', 'false', '$2y$12$nOFYqpZa7N.n2ZF9vB4GD.Po/utzY0KuSIpHc2RJ0krIVhDsdp3fa', 0, NULL, NULL, 'false', NULL, NULL, 'false', 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'ALIYA SAHKILA', 'F', '240003', NULL, NULL, NULL, 'MEDAN', '0000-00-00', NULL, 0, 'WNI', NULL, 0, 'Jl. Seroja, Kel. Sunggal, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 'false', 'false', 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, '240003@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, 0, '2024-12-24 10:41:19', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(28, 'false', 'false', 'false', 'false', 'true', 'false', '$2y$12$h/h9NHsbTDmmMwD59JBnx.nekbgg0QNEA3nyfumcRFe5bKFnO4bIm', 0, NULL, NULL, 'false', NULL, NULL, 'false', 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'ARIFAH SYAHFITRI', 'F', '240008', NULL, NULL, NULL, 'MEDAN', '0000-00-00', NULL, 0, 'WNI', NULL, 0, 'Jl. Kantil No.9, Kel. Tanjung Rejo, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 'false', 'false', 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, '240008@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, 0, '2024-12-24 10:41:19', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(29, 'false', 'false', 'false', 'false', 'true', 'false', '$2y$12$xTxSNGwEbabm9iILqxv90eCuRH6RmKjz4YNBB3EFJ3gmFEt.dIPxi', 0, NULL, NULL, 'false', NULL, NULL, 'false', 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'CINTA UMMAIRAH', 'F', '240013', NULL, NULL, NULL, 'MEDAN', '0000-00-00', NULL, 0, 'WNI', NULL, 0, 'Kel. Sei Sikambing B, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 'false', 'false', 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, '240013@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, 0, '2024-12-24 10:41:20', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(30, 'false', 'false', 'false', 'false', 'true', 'false', '$2y$12$oB12QufpUWiHTE4cmk7O3uwxR4QRw6A9oLTgZ7hZUiE2lfQSevkTi', 0, NULL, NULL, 'false', NULL, NULL, 'false', 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'DAVA RIFQI', 'M', '240015', NULL, NULL, NULL, 'MEDAN', '0000-00-00', NULL, 0, 'WNI', NULL, 0, 'Jl. Setia Budi, Gg. Ampera No.1, Kel. Sei Sikambing B, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 'false', 'false', 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, '240015@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, 0, '2024-12-24 10:41:20', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(31, 'false', 'false', 'false', 'false', 'true', 'false', '$2y$12$q02bwaWTrdlMX9/OzQ2lsutvJIKO2MMhN8UmAm/RwFFCQEkKPgzIe', 0, NULL, NULL, 'false', NULL, NULL, 'false', 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'DINA SAFIRA PUTRI', 'F', '240021', NULL, NULL, NULL, 'SEI APUNG', '0000-00-00', NULL, 0, 'WNI', NULL, 0, 'BANDAR JAWA, Kel. SEI APUNG, Kec. TANJUNG BALAI, SUMATERA UTARA, 21352', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 'false', 'false', 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, '240021@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, 0, '2024-12-24 10:41:20', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(32, 'false', 'false', 'false', 'false', 'true', 'false', '$2y$12$K8pAXAD5Jw3YUpoZUlYwje3DLjdnVpZVUJbHHDemlARVc8hYHGs1a', 0, NULL, NULL, 'false', NULL, NULL, 'false', 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'FADJAR ALAMSAH', 'M', '240022', NULL, NULL, NULL, 'MEDAN', '0000-00-00', NULL, 0, 'WNI', NULL, 0, 'JL.BALAM GG RUHAMA NO 4 LK 13, Kel. SEI SIKAMBING B, Kec. MEDAN SUNGGAL, SUMATERA UTARA, 20122', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 'false', 'false', 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, '240022@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, 0, '2024-12-24 10:41:21', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(33, 'false', 'false', 'false', 'false', 'true', 'false', '$2y$12$wL5.9UOfvUnxJi38IcZSVe1w.DZVqNODJHJDfM0maokxtOcL1a9qK', 0, NULL, NULL, 'false', NULL, NULL, 'false', 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'FEBRIANSYAH PERDANA LUBIS', 'M', '240026', NULL, NULL, NULL, 'MEDAN', '0000-00-00', NULL, 0, 'WNI', NULL, 0, 'Jl. Merak Gg. Keluarga No. 8A, Kel. Sei Sikambing B, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 'false', 'false', 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, '240026@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, 0, '2024-12-24 10:41:21', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(34, 'false', 'false', 'false', 'false', 'true', 'false', '$2y$12$FUGPk7veYGhFkrpB1lx2W.r/KMzVctXdKhbvB4XQYJdvhzM/JYH/W', 0, NULL, NULL, 'false', NULL, NULL, 'false', 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'GHALIYATUL IFFAH LUBIS', 'F', '240029', NULL, NULL, NULL, 'MEDAN', '0000-00-00', NULL, 0, 'WNI', NULL, 0, 'JL.T.AMIR HAMZAHNO.59, Kel. HELVETIA TIMUR, Kec. MEDAN HELVETIA, SUMATERA UTARA, 20123', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 'false', 'false', 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, '240029@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, 0, '2024-12-24 10:41:21', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(35, 'false', 'false', 'false', 'false', 'true', 'false', '$2y$12$6ko2yRaYu2whGwsvgNY09.OyZm9FLE64bgl4t.VMi3UD2.VscgT0O', 0, NULL, NULL, 'false', NULL, NULL, 'false', 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'HARIS OCTO MAULANA', 'M', '240033', NULL, NULL, NULL, 'MEDAN', '0000-00-00', NULL, 0, 'WNI', NULL, 0, 'Jl. Merak No.5, Kel, Sei Sikambing B, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 'false', 'false', 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, '240033@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, 0, '2024-12-24 10:41:21', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(36, 'false', 'false', 'false', 'false', 'true', 'false', '$2y$12$b1wSpVbU17L.UlbSwvwIyeIP0y6CcT4yKl1U5YNspoxTn0xw49kKu', 0, NULL, NULL, 'false', NULL, NULL, 'false', 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'IRANDA PUTRI', 'F', '240035', NULL, NULL, NULL, 'MEDAN', '0000-00-00', NULL, 0, 'WNI', NULL, 0, 'Jl. Abadi, Gg. Sepakat, Kel. Tanjung Rejo, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 'false', 'false', 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, '240035@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, 0, '2024-12-24 10:41:22', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(37, 'false', 'false', 'false', 'false', 'true', 'false', '$2y$12$v10zpbcHk.t5qIHAVVohXu0.3MTGYkNX5jYPfaH6T/7CcS.Q79Yia', 0, NULL, NULL, 'false', NULL, NULL, 'false', 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'KHAIRIL DWI PANCA', 'M', '240039', NULL, NULL, NULL, 'MEDAN', '0000-00-00', NULL, 0, 'WNI', NULL, 0, 'Jl. Seroja Gg. Warisan, Kel. Sunggal, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 'false', 'false', 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, '240039@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, 0, '2024-12-24 10:41:22', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(38, 'false', 'false', 'false', 'false', 'true', 'false', '$2y$12$.rmqTdaAjNTkUwtWfebyB.Tp7eae4.bMvZuuVwBi4B8o8faIXZzqu', 0, NULL, NULL, 'false', NULL, NULL, 'false', 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'KHALIS NIZAM', 'M', '240042', NULL, NULL, NULL, 'MEDAN', '0000-00-00', NULL, 0, 'WNI', NULL, 0, 'Jl. Beringin Gg. Tentram, Kel. Sunggal, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 'false', 'false', 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, '240042@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, 0, '2024-12-24 10:41:22', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(39, 'false', 'false', 'false', 'false', 'true', 'false', '$2y$12$vgAAMGC5sbUZJlXURN4LYeC7Les/1ag7BKkBoH47Jvf8RKjgyA8xu', 0, NULL, NULL, 'false', NULL, NULL, 'false', 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'M. RAFKHY', 'M', '240048', NULL, NULL, NULL, 'MEDAN', '0000-00-00', NULL, 0, 'WNI', NULL, 0, 'Jl. Pendidikan, Kel. Tanjung Rejo, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 'false', 'false', 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, '240048@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, 0, '2024-12-24 10:41:23', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(40, 'false', 'false', 'false', 'false', 'true', 'false', '$2y$12$65Ffq0XfttQ3uUiwlL7Aau1e/j537HdYu5BVnDYtFZTkAyzlJKT7u', 0, NULL, NULL, 'false', NULL, NULL, 'false', 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'MIFTAH SYIR ALIYA', 'F', '240052', NULL, NULL, NULL, 'BATU BARA', '0000-00-00', NULL, 0, 'WNI', NULL, 0, 'Jln. Balai Desa, Gg. Wakaf No.21, Kel. Sunggal, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 'false', 'false', 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, '240052@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, 0, '2024-12-24 10:41:23', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(41, 'false', 'false', 'false', 'false', 'true', 'false', '$2y$12$jYzzTytq.t4cPjZdaaN6GeP9eFJleGtWsLEqz05B1hF9k9DSRz7rO', 0, NULL, NULL, 'false', NULL, NULL, 'false', 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'MUHAMMAD AZAM', 'M', '240091', NULL, NULL, NULL, 'MEDAN', '0000-00-00', NULL, 0, 'WNI', NULL, 0, 'Jl. Beo No. 21, Kel. Sei Sikambing B, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 'false', 'false', 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, '240091@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, 0, '2024-12-24 10:41:23', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(42, 'false', 'false', 'false', 'false', 'true', 'false', '$2y$12$21Hs/AREDCDDFd4j.0rp.uejDIfCNVgAgqid07FVf7nbtYCSEctKu', 0, NULL, NULL, 'false', NULL, NULL, 'false', 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'MUHAMMAD BAGAS ARZIKI', 'M', '240053', NULL, NULL, NULL, 'MEDAN', '0000-00-00', NULL, 0, 'WNI', NULL, 0, 'Jl. Seroja No. 43, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 'false', 'false', 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, '240053@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, 0, '2024-12-24 10:41:23', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(43, 'false', 'false', 'false', 'false', 'true', 'false', '$2y$12$uKstY3Wkh9DqUq.XfkonoOys9N9B9fBX6qNsXHpoWvUfQdAM7zq9e', 0, NULL, NULL, 'false', NULL, NULL, 'false', 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'MUHAMMAD FAIZ', 'M', '240057', NULL, NULL, NULL, 'DARUSSALAM', '0000-00-00', NULL, 0, 'WNI', NULL, 0, 'Jl. Kasuari, Gg. Kacang, Kel. Sei Sikambing B, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 'false', 'false', 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, '240057@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, 0, '2024-12-24 10:41:24', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(44, 'false', 'false', 'false', 'false', 'true', 'false', '$2y$12$DFutFlPB5v6Y3mebLbhlQe6/gS.nHnM3rCiOTYSK5SlEhM63LAaIO', 0, NULL, NULL, 'false', NULL, NULL, 'false', 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'MUHAMMAD FARHAN SYAPUTRA', 'M', '240045', NULL, NULL, NULL, 'BANJAR XII', '0000-00-00', NULL, 0, 'WNI', NULL, 0, 'Jl. Kasuari, Gg. Sosial, Kel. Sei Sikambing B, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 'false', 'false', 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, '240045@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, 0, '2024-12-24 10:41:24', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(45, 'false', 'false', 'false', 'false', 'true', 'false', '$2y$12$hjOxc6nvD1sWfnsBh49SfOEe5yHG9BJv1F2qrMLStzhz7TMxG3Yo2', 0, NULL, NULL, 'false', NULL, NULL, 'false', 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'MUHAMMAR RIZKY', 'M', '240060', NULL, NULL, NULL, 'BIREM RAYEUK', '0000-00-00', NULL, 0, 'WNI', NULL, 0, 'Ringroad Gagak Hitam', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 'false', 'false', 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, '240060@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, 0, '2024-12-24 10:41:24', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(46, 'false', 'false', 'false', 'false', 'true', 'false', '$2y$12$33Ieb8W.5sTVkwaSC356EuPv7GBFWxBXn1N.Eb8UoqIEsK0tHxEHC', 0, NULL, NULL, 'false', NULL, NULL, 'false', 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'NAZIFA NASUTION', 'F', '240063', NULL, NULL, NULL, 'SEI KASIH', '0000-00-00', NULL, 0, 'WNI', NULL, 0, 'Jl. Merak No.55, Kel. Sei Sikambing B, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 'false', 'false', 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, '240063@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, 0, '2024-12-24 10:41:25', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(47, 'false', 'false', 'false', 'false', 'true', 'false', '$2y$12$V855ewTQA5OR1geKAe76FuTokEhnEdA/m1jFvYrBHmuwhROLjVe6G', 0, NULL, NULL, 'false', NULL, NULL, 'false', 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'NAZWA AZAHRA LUBIS', 'F', '240092', NULL, NULL, NULL, 'MEDAN', '0000-00-00', NULL, 0, 'WNI', NULL, 0, 'JL. TITIPAN GG. PERTAHANAN, kel. Sei Sikambing D, Kec. Medan Petisah', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 'false', 'false', 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, '240092@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, 0, '2024-12-24 10:41:25', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(48, 'false', 'false', 'false', 'false', 'true', 'false', '$2y$12$OBaQh9ovyE04p9F9VD.PA.itsGnKqwKKV1d6RSDomWZ5RrQiN/T3S', 0, NULL, NULL, 'false', NULL, NULL, 'false', 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'NURUL SYAHRINY', 'F', '240066', NULL, NULL, NULL, 'MEDAN', '0000-00-00', NULL, 0, 'WNI', NULL, 0, 'Jl. Beringin, Gg. Bersama, Kel. Sunggal, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 'false', 'false', 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, '240066@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, 0, '2024-12-24 10:41:25', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(49, 'false', 'false', 'false', 'false', 'true', 'false', '$2y$12$xlfuCAzSUFom.clNjJCb0eEwY3FJh.KATwhHcKtLJz0ojmHYTzGx6', 0, NULL, NULL, 'false', NULL, NULL, 'false', 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'RAHFI RICZKY SARAGIH', 'M', '240069', NULL, NULL, NULL, 'TALUN KONDOT', '0000-00-00', NULL, 0, 'WNI', NULL, 0, 'Talun Kondot, Kel. TALUN KONDOT, Kec. BANDAR MASILAM, SUMATERA UTARA, 21161', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 'false', 'false', 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, '240069@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, 0, '2024-12-24 10:41:25', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(50, 'false', 'false', 'false', 'false', 'true', 'false', '$2y$12$w0jdeEAaXtNd3CIVE06X7.cP9bvb4KZvdz/5m0PN9vvc/bepqVcGC', 0, NULL, NULL, 'false', NULL, NULL, 'false', 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'RENDYANSYAH', 'M', '240075', NULL, NULL, NULL, 'MEDAN', '0000-00-00', NULL, 0, 'WNI', NULL, 0, 'Jl. Merpati, Gg. Musholla, Kel. Sei Sikambing B, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 'false', 'false', 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, '240075@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, 0, '2024-12-24 10:41:26', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(51, 'false', 'false', 'false', 'false', 'true', 'false', '$2y$12$9SHpDs.TlHtRnJqqcZX.6OgKL0VYuSZU7pL09h5YENmyZfyt74egu', 0, NULL, NULL, 'false', NULL, NULL, 'false', 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'RESTY NURANDINI', 'F', '240076', NULL, NULL, NULL, 'MEDAN', '0000-00-00', NULL, 0, 'WNI', NULL, 0, 'Jln. Merak, Gg. Asal N0. 28 B, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 'false', 'false', 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, '240076@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, 0, '2024-12-24 10:41:26', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(52, 'false', 'false', 'false', 'false', 'true', 'false', '$2y$12$2zH66i8zjTI6QPXF2xA3GuTXRP9ToGmT5lfjRiSaqUrGY3MHnNZim', 0, NULL, NULL, 'false', NULL, NULL, 'false', 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'SYUHADA RAMADHAN', 'M', '240082', NULL, NULL, NULL, 'MEDAN', '0000-00-00', NULL, 0, 'WNI', NULL, 0, 'Jl. Pinang Baris, Gg. Wakaf No.3, Kel. Lalang, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 'false', 'false', 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, '240082@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, 0, '2024-12-24 10:41:26', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(53, 'false', 'false', 'false', 'false', 'true', 'false', '$2y$12$JBUHxO/4KlF6GqRZUJaD3OLllrWe6YxtJ6gOfRUwY2gJ3eCy9R17e', 0, NULL, NULL, 'false', NULL, NULL, 'false', 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'TITA NIA AZZAHRA', 'F', '240084', NULL, NULL, NULL, 'MEDAN', '0000-00-00', NULL, 0, 'WNI', NULL, 0, 'Jl. Kapt-Muslim, Gg. Jawa, Lr. Musholla, Desa. Sei Sikambing C II, Medan Helvetia', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 'false', 'false', 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, '240084@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, 0, '2024-12-24 10:41:27', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(54, 'false', 'false', 'false', 'false', 'true', 'false', '$2y$12$lbutxj0DnoSgr0GfbidTI.60zkOfAgYCjS3bTfCejLRXFSYJfn14y', 0, NULL, NULL, 'false', NULL, NULL, 'false', 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'WAN SEKAR HARUM AQILAH PUTRI', 'F', '240087', NULL, NULL, NULL, 'MEDAN', '0000-00-00', NULL, 0, 'WNI', NULL, 0, 'Jl. Murni No.14, Kel. Tanjung Rejo, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 'false', 'false', 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, '240087@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, 0, '2024-12-24 10:41:27', NULL, NULL, NULL, 1, 0, 0, 0, 'false'),
(55, 'false', 'false', 'false', 'false', 'true', 'false', '$2y$12$ymR/bQ3UPCzLd8nvEnoduetMBUb1r93TeLwL01iUCHwCCzuecgGoq', 0, NULL, NULL, 'false', NULL, NULL, 'false', 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'ZAZKIA KINARA ARTANTI', 'F', '240090', NULL, NULL, NULL, 'MEDAN', '0000-00-00', NULL, 0, 'WNI', NULL, 0, 'Jl. Pinang Baris, Gg. Wakaf, Kec. Medan Sunggal', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 'false', 'false', 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, '240090@mtssypalazhar.sch.id', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, 0, '2024-12-24 10:41:27', NULL, NULL, NULL, 1, 0, 0, 0, 'false');

-- --------------------------------------------------------

--
-- Struktur dari tabel `user_groups`
--

DROP TABLE IF EXISTS `user_groups`;
CREATE TABLE IF NOT EXISTS `user_groups` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_group` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  `restored_at` datetime DEFAULT NULL,
  `created_by` bigint DEFAULT '0',
  `updated_by` bigint DEFAULT '0',
  `deleted_by` bigint DEFAULT '0',
  `restored_by` bigint DEFAULT '0',
  `is_deleted` enum('true','false') DEFAULT 'false',
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_group` (`user_group`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;

--
-- Dumping data untuk tabel `user_groups`
--

INSERT INTO `user_groups` (`id`, `user_group`, `created_at`, `updated_at`, `deleted_at`, `restored_at`, `created_by`, `updated_by`, `deleted_by`, `restored_by`, `is_deleted`) VALUES
(1, 'GTK', '2024-12-24 14:13:34', NULL, NULL, NULL, 1, 0, 0, 0, 'false');

-- --------------------------------------------------------

--
-- Struktur dari tabel `user_privileges`
--

DROP TABLE IF EXISTS `user_privileges`;
CREATE TABLE IF NOT EXISTS `user_privileges` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_group_id` bigint DEFAULT '0',
  `module_id` bigint DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  `restored_at` datetime DEFAULT NULL,
  `created_by` bigint DEFAULT '0',
  `updated_by` bigint DEFAULT '0',
  `deleted_by` bigint DEFAULT '0',
  `restored_by` bigint DEFAULT '0',
  `is_deleted` enum('true','false') DEFAULT 'false',
  PRIMARY KEY (`id`),
  UNIQUE KEY `__unique_key` (`user_group_id`,`module_id`),
  KEY `user_privileges_user_group_id__idx` (`user_group_id`) USING BTREE,
  KEY `user_privileges_module_id__idx` (`module_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Struktur dari tabel `_sessions`
--

DROP TABLE IF EXISTS `_sessions`;
CREATE TABLE IF NOT EXISTS `_sessions` (
  `id` varchar(128) NOT NULL,
  `ip_address` varchar(45) NOT NULL,
  `timestamp` int UNSIGNED NOT NULL DEFAULT '0',
  `data` blob NOT NULL,
  KEY `ci_sessions_timestamp` (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Dumping data untuk tabel `_sessions`
--

INSERT INTO `_sessions` (`id`, `ip_address`, `timestamp`, `data`) VALUES
('knik5de2pp5f8u5hhj1sp4m56ip86nk0', '127.0.0.1', 1737995236, 0x5f5f63695f6c6173745f726567656e65726174657c693a313733373939353233363b67656e6572616c7c613a31333a7b733a31363a22736974655f6d61696e74656e616e6365223b733a353a2266616c7365223b733a32353a22736974655f6d61696e74656e616e63655f656e645f64617465223b733a31303a22323032332d30312d3031223b733a31303a22736974655f6361636865223b733a353a2266616c7365223b733a31353a22736974655f63616368655f74696d65223b733a323a223130223b733a31363a226d6574615f6465736372697074696f6e223b733a3130363a22434d532053656b6f6c61686b75206164616c616820436f6e74656e74204d616e6167656d656e742053797374656d2064616e2050504442204f6e6c696e652067726174697320756e74756b20534420534d502f5365646572616a617420534d412f5365646572616a6174223b733a31333a226d6574615f6b6579776f726473223b733a3338313a22434d532c20576562736974652053656b6f6c6168204772617469732c2043617261204d656d6275617420576562736974652053656b6f6c61682c206d656d62756174207765622073656b6f6c61682c20636f6e746f6820776562736974652073656b6f6c61682c20666974757220776562736974652073656b6f6c61682c2053656b6f6c61682c20576562736974652c20496e7465726e65742c53697475732c20434d532053656b6f6c61682c205765622053656b6f6c61682c20576562736974652053656b6f6c6168204772617469732c20576562736974652053656b6f6c61682c2041706c696b6173692053656b6f6c61682c2050504442204f6e6c696e652c20505342204f6e6c696e652c20505342204f6e6c696e65204772617469732c2050656e6572696d61616e2053697377612042617275204f6e6c696e652c205261706f7274204f6e6c696e652c204b7572696b756c756d20323031332c2053442c20534d502c20534d412c20416c697961682c204d54732c20534d4b223b733a31323a226d61705f6c6f636174696f6e223b733a303a22223b733a373a2266617669636f6e223b733a33363a2234323262663664643337336261623236393736316536323032646562373562312e706e67223b733a363a22686561646572223b733a31303a226865616465722e706e67223b733a31363a227265636170746368615f737461747573223b733a363a22656e61626c65223b733a31383a227265636170746368615f736974655f6b6579223b733a34303a22364c666f3637636a4141414141484b5f63324a6342667a4a643844534d6c72386870654650793357223b733a32303a227265636170746368615f7365637265745f6b6579223b733a34303a22364c666f3637636a4141414141495976336a35794a5768454a74675241547634786159544e523066223b733a383a2274696d657a6f6e65223b733a31323a22417369612f4a616b61727461223b7d6d656469617c613a31383a7b733a31383a2266696c655f616c6c6f7765645f7479706573223b733a32343a226a70672c206a7065672c20706e672c206769662c20706466223b733a31393a2275706c6f61645f6d61785f66696c6573697a65223b733a313a2230223b733a32313a227468756d626e61696c5f73697a655f686569676874223b733a333a22313030223b733a32303a227468756d626e61696c5f73697a655f7769647468223b733a333a22313530223b733a31383a226d656469756d5f73697a655f686569676874223b733a333a22333038223b733a31373a226d656469756d5f73697a655f7769647468223b733a333a22343630223b733a31373a226c617267655f73697a655f686569676874223b733a333a22363030223b733a31363a226c617267655f73697a655f7769647468223b733a333a22383030223b733a31383a22616c62756d5f636f7665725f686569676874223b733a333a22323530223b733a31373a22616c62756d5f636f7665725f7769647468223b733a333a22343030223b733a31333a2262616e6e65725f686569676874223b733a323a223831223b733a31323a2262616e6e65725f7769647468223b733a333a22323435223b733a31393a22696d6167655f736c696465725f686569676874223b733a333a22343030223b733a31383a22696d6167655f736c696465725f7769647468223b733a333a22393030223b733a31373a22757365725f70686f746f5f686569676874223b733a333a22363030223b733a31363a22757365725f70686f746f5f7769647468223b733a333a22343030223b733a31313a226c6f676f5f686569676874223b733a333a22313230223b733a31303a226c6f676f5f7769647468223b733a333a22313230223b7d77726974696e677c613a31303a7b733a32313a2264656661756c745f706f73745f63617465676f7279223b733a313a2231223b733a31393a2264656661756c745f706f73745f737461747573223b733a373a227075626c697368223b733a32333a2264656661756c745f706f73745f7669736962696c697479223b733a363a227075626c6963223b733a32333a2264656661756c745f706f73745f64697363757373696f6e223b733a343a226f70656e223b733a32373a22706f73745f696d6167655f7468756d626e61696c5f686569676874223b733a333a22313030223b733a32363a22706f73745f696d6167655f7468756d626e61696c5f7769647468223b733a333a22313530223b733a32343a22706f73745f696d6167655f6d656469756d5f686569676874223b733a333a22323530223b733a32333a22706f73745f696d6167655f6d656469756d5f7769647468223b733a333a22343030223b733a32333a22706f73745f696d6167655f6c617267655f686569676874223b733a333a22343530223b733a32323a22706f73745f696d6167655f6c617267655f7769647468223b733a333a22383430223b7d72656164696e677c613a343a7b733a31333a22706f73745f7065725f70616765223b733a313a2235223b733a31343a22706f73745f7273735f636f756e74223b733a323a223130223b733a31383a22706f73745f72656c617465645f636f756e74223b733a313a2235223b733a31363a22636f6d6d656e745f7065725f70616765223b733a313a2235223b7d64697363757373696f6e7c613a343a7b733a31383a22636f6d6d656e745f6d6f6465726174696f6e223b733a353a2266616c7365223b733a32303a22636f6d6d656e745f726567697374726174696f6e223b733a353a2266616c7365223b733a31373a22636f6d6d656e745f626c61636b6c697374223b733a373a226b616d70726574223b733a31333a22636f6d6d656e745f6f72646572223b733a333a22617363223b7d736f6369616c5f6163636f756e747c613a353a7b733a383a2266616365626f6f6b223b733a33383a2268747470733a2f2f7777772e66616365626f6f6b2e636f6d2f636d7373656b6f6c61686b752f223b733a373a2274776974746572223b733a33313a2268747470733a2f2f747769747465722e636f6d2f616e746f6e736f6679616e223b733a393a226c696e6b65645f696e223b733a35303a2268747470733a2f2f7777772e6c696e6b6564696e2e636f6d2f696e2f616e746f6e2d736f6679616e2d31343238393337612f223b733a373a22796f7574756265223b733a313a222d223b733a393a22696e7374616772616d223b733a33393a2268747470733a2f2f7777772e696e7374616772616d2e636f6d2f616e746f6e5f736f6679616e2f223b7d6d61696c5f7365727665727c613a343a7b733a393a22736d74705f686f7374223b733a303a22223b733a393a22736d74705f75736572223b733a303a22223b733a393a22736d74705f70617373223b733a303a22223b733a393a22736d74705f706f7274223b733a303a22223b7d7363686f6f6c5f70726f66696c657c613a32313a7b733a343a226e70736e223b733a383a223130323634353932223b733a31313a227363686f6f6c5f6e616d65223b733a31363a224d54535320595020414c20415a484152223b733a31303a22686561646d6173746572223b733a31313a22446f6e6e792c20532e532e223b733a31363a22686561646d61737465725f70686f746f223b733a33363a2236623462633538633231393335663339643866333136346666653935356535612e6a7067223b733a31323a227363686f6f6c5f6c6576656c223b733a333a22313032223b733a31333a227363686f6f6c5f737461747573223b733a313a2232223b733a31363a226f776e6572736869705f737461747573223b733a333a22313131223b733a373a227461676c696e65223b733a31383a224d616e204a61646461205761204a61646461223b733a323a227274223b733a323a223030223b733a323a227277223b733a323a223030223b733a31313a227375625f76696c6c616765223b733a313a222d223b733a373a2276696c6c616765223b733a31353a225365692053696b616d62696e672042223b733a31323a227375625f6469737472696374223b733a31333a224d6564616e2053756e6767616c223b733a383a226469737472696374223b733a31303a224b6f7461204d6564616e223b733a31313a22706f7374616c5f636f6465223b733a353a223230313232223b733a31343a227374726565745f61646472657373223b733a33303a224a6c2e204d6572616b2047672e204e697277616e61204e6f2e2036352046223b733a353a2270686f6e65223b733a31313a223036312038343538393535223b733a333a22666178223b733a31313a223036312038343538393535223b733a353a22656d61696c223b733a32333a226d7473737970616c617a68617240676d61696c2e636f6d223b733a373a2277656273697465223b733a32343a227777772e6d7473737970616c617a6861722e7363682e6964223b733a343a226c6f676f223b733a33363a2239333062316362653966613333396464663064666637316339343236366639322e706e67223b7d61646d697373696f6e7c613a373a7b733a31363a2261646d697373696f6e5f737461747573223b733a343a226f70656e223b733a32333a22616e6e6f756e63656d656e745f73746172745f64617465223b733a31303a22323032352d30312d3031223b733a32313a22616e6e6f756e63656d656e745f656e645f64617465223b733a31303a22323032352d30372d3132223b733a32363a227072696e745f6578616d5f636172645f73746172745f64617465223b733a31303a22323032332d30312d3031223b733a32343a227072696e745f6578616d5f636172645f656e645f64617465223b733a31303a22323032342d31322d3331223b733a31343a226d696e5f62697274685f64617465223b4e3b733a31343a226d61785f62697274685f64617465223b4e3b7d7468656d657c733a313a2232223b666f726d5f69735f7472616e736665727c613a323a7b733a393a2261646d697373696f6e223b733a343a2274727565223b733a31383a2261646d697373696f6e5f7265717569726564223b733a343a2274727565223b7d666f726d5f61646d697373696f6e5f747970655f69647c613a323a7b733a393a2261646d697373696f6e223b733a343a2274727565223b733a31383a2261646d697373696f6e5f7265717569726564223b733a343a2274727565223b7d666f726d5f66697273745f63686f6963655f69647c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f7365636f6e645f63686f6963655f69647c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f6e696b7c613a323a7b733a393a2261646d697373696f6e223b733a343a2274727565223b733a31383a2261646d697373696f6e5f7265717569726564223b733a343a2274727565223b7d666f726d5f707265765f7363686f6f6c5f6e616d657c613a323a7b733a393a2261646d697373696f6e223b733a343a2274727565223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f707265765f6578616d5f6e756d6265727c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f736b68756e7c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f707265765f6469706c6f6d615f6e756d6265727c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f66756c6c5f6e616d657c613a323a7b733a393a2261646d697373696f6e223b733a343a2274727565223b733a31383a2261646d697373696f6e5f7265717569726564223b733a343a2274727565223b7d666f726d5f67656e6465727c613a323a7b733a393a2261646d697373696f6e223b733a343a2274727565223b733a31383a2261646d697373696f6e5f7265717569726564223b733a343a2274727565223b7d666f726d5f6e69736e7c613a323a7b733a393a2261646d697373696f6e223b733a343a2274727565223b733a31383a2261646d697373696f6e5f7265717569726564223b733a343a2274727565223b7d666f726d5f66616d696c795f636172645f6e756d6265727c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f62697274685f706c6163657c613a323a7b733a393a2261646d697373696f6e223b733a343a2274727565223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f62697274685f646174657c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f62697274685f63657274696669636174655f6e756d6265727c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f72656c6967696f6e5f69647c613a323a7b733a393a2261646d697373696f6e223b733a343a2274727565223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f636974697a656e736869707c613a323a7b733a393a2261646d697373696f6e223b733a343a2274727565223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f636f756e7472797c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f7370656369616c5f6e6565645f69647c613a323a7b733a393a2261646d697373696f6e223b733a343a2274727565223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f7374726565745f616464726573737c613a323a7b733a393a2261646d697373696f6e223b733a343a2274727565223b733a31383a2261646d697373696f6e5f7265717569726564223b733a343a2274727565223b7d666f726d5f72747c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f72777c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f7375625f76696c6c6167657c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f76696c6c6167657c613a323a7b733a393a2261646d697373696f6e223b733a343a2274727565223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f7375625f64697374726963747c613a323a7b733a393a2261646d697373696f6e223b733a343a2274727565223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f64697374726963747c613a323a7b733a393a2261646d697373696f6e223b733a343a2274727565223b733a31383a2261646d697373696f6e5f7265717569726564223b733a343a2274727565223b7d666f726d5f706f7374616c5f636f64657c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f6c617469747564657c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f6c6f6e6769747564657c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f7265736964656e63655f69647c613a323a7b733a393a2261646d697373696f6e223b733a343a2274727565223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f7472616e73706f72746174696f6e5f69647c613a323a7b733a393a2261646d697373696f6e223b733a343a2274727565223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f6368696c645f6e756d6265727c613a323a7b733a393a2261646d697373696f6e223b733a343a2274727565223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f656d706c6f796d656e745f69647c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f686176655f6b69707c613a323a7b733a393a2261646d697373696f6e223b733a343a2274727565223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f726563656976655f6b69707c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f72656a6563745f7069707c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f6661746865725f6e616d657c613a323a7b733a393a2261646d697373696f6e223b733a343a2274727565223b733a31383a2261646d697373696f6e5f7265717569726564223b733a343a2274727565223b7d666f726d5f6661746865725f6e696b7c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f6661746865725f62697274685f706c6163657c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f6661746865725f62697274685f646174657c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f6661746865725f656475636174696f6e5f69647c613a323a7b733a393a2261646d697373696f6e223b733a343a2274727565223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f6661746865725f656d706c6f796d656e745f69647c613a323a7b733a393a2261646d697373696f6e223b733a343a2274727565223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f6661746865725f6d6f6e74686c795f696e636f6d655f69647c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f6661746865725f7370656369616c5f6e6565645f69647c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f6661746865725f6964656e746974795f636172647c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f6d6f746865725f6e616d657c613a323a7b733a393a2261646d697373696f6e223b733a343a2274727565223b733a31383a2261646d697373696f6e5f7265717569726564223b733a343a2274727565223b7d666f726d5f6d6f746865725f6e696b7c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f6d6f746865725f62697274685f706c6163657c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f6d6f746865725f62697274685f646174657c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f6d6f746865725f656475636174696f6e5f69647c613a323a7b733a393a2261646d697373696f6e223b733a343a2274727565223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f6d6f746865725f656d706c6f796d656e745f69647c613a323a7b733a393a2261646d697373696f6e223b733a343a2274727565223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f6d6f746865725f6d6f6e74686c795f696e636f6d655f69647c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f6d6f746865725f7370656369616c5f6e6565645f69647c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f6d6f746865725f6964656e746974795f636172647c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f677561726469616e5f6e616d657c613a323a7b733a393a2261646d697373696f6e223b733a343a2274727565223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f677561726469616e5f6e696b7c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f677561726469616e5f62697274685f646174657c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f677561726469616e5f62697274685f706c6163657c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f677561726469616e5f656475636174696f6e5f69647c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f677561726469616e5f656d706c6f796d656e745f69647c613a323a7b733a393a2261646d697373696f6e223b733a343a2274727565223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f677561726469616e5f6d6f6e74686c795f696e636f6d655f69647c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f677561726469616e5f6964656e746974795f636172647c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f70686f6e657c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f6d6f62696c655f70686f6e657c613a323a7b733a393a2261646d697373696f6e223b733a343a2274727565223b733a31383a2261646d697373696f6e5f7265717569726564223b733a343a2274727565223b7d666f726d5f656d61696c7c613a323a7b733a393a2261646d697373696f6e223b733a343a2274727565223b733a31383a2261646d697373696f6e5f7265717569726564223b733a343a2274727565223b7d666f726d5f6865696768747c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f7765696768747c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f686561645f63697263756d666572656e63657c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f6d696c656167657c613a323a7b733a393a2261646d697373696f6e223b733a343a2274727565223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f74726176656c696e675f74696d657c613a323a7b733a393a2261646d697373696f6e223b733a343a2274727565223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f7369626c696e675f6e756d6265727c613a323a7b733a393a2261646d697373696f6e223b733a343a2274727565223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f77656c666172655f747970657c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f77656c666172655f6e756d6265727c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f77656c666172655f6e616d657c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f70686f746f7c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f66616d696c795f636172647c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f62697274685f63657274696669636174657c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d61646d697373696f6e5f73656d65737465725f69647c733a313a2232223b61646d697373696f6e5f73656d65737465727c733a393a22323032352d32303236223b61646d697373696f6e5f796561727c733a343a2232303235223b63757272656e745f61636164656d69635f796561725f69647c733a313a2231223b63757272656e745f61636164656d69635f796561727c733a393a22323032342d32303235223b63757272656e745f61636164656d69635f73656d65737465727c733a333a226f6464223b61646d697373696f6e5f70686173655f69647c733a313a2231223b61646d697373696f6e5f70686173657c733a31313a2247656c6f6d62616e672049223b61646d697373696f6e5f73746172745f646174657c733a31303a22323032352d30312d3031223b61646d697373696f6e5f656e645f646174657c733a31303a22323032352d30342d3330223b6d616a6f725f636f756e747c623a303b757365725f69647c733a313a2232223b656d61696c7c733a33323a226162726970726174616d61406d7473737970616c617a6861722e7363682e6964223b66756c6c5f6e616d657c733a31323a22414252492050524154414d41223b69735f73757065725f61646d696e7c623a303b69735f61646d696e7c623a303b69735f656d706c6f7965657c623a313b69735f70726f73706563746976655f73747564656e747c623a303b69735f73747564656e747c623a303b69735f616c756d6e697c623a303b6163746976657c623a313b757365725f70726976696c656765737c613a353a7b693a303b733a393a2264617368626f617264223b693a313b733a31353a226368616e67655f70617373776f7264223b693a323b733a31363a22656d706c6f7965655f70726f66696c65223b693a333b733a353a22706f737473223b693a343b733a373a2274656163686572223b7d656d706c6f796d656e745f747970657c733a31393a2247757275204d6174612050656c616a6172616e223b),
('gptu7n0b5elg0kk3392eksermibqloq5', '127.0.0.1', 1737995512, 0x5f5f63695f6c6173745f726567656e65726174657c693a313733373939353233363b67656e6572616c7c613a31333a7b733a31363a22736974655f6d61696e74656e616e6365223b733a353a2266616c7365223b733a32353a22736974655f6d61696e74656e616e63655f656e645f64617465223b733a31303a22323032332d30312d3031223b733a31303a22736974655f6361636865223b733a353a2266616c7365223b733a31353a22736974655f63616368655f74696d65223b733a323a223130223b733a31363a226d6574615f6465736372697074696f6e223b733a3130363a22434d532053656b6f6c61686b75206164616c616820436f6e74656e74204d616e6167656d656e742053797374656d2064616e2050504442204f6e6c696e652067726174697320756e74756b20534420534d502f5365646572616a617420534d412f5365646572616a6174223b733a31333a226d6574615f6b6579776f726473223b733a3338313a22434d532c20576562736974652053656b6f6c6168204772617469732c2043617261204d656d6275617420576562736974652053656b6f6c61682c206d656d62756174207765622073656b6f6c61682c20636f6e746f6820776562736974652073656b6f6c61682c20666974757220776562736974652073656b6f6c61682c2053656b6f6c61682c20576562736974652c20496e7465726e65742c53697475732c20434d532053656b6f6c61682c205765622053656b6f6c61682c20576562736974652053656b6f6c6168204772617469732c20576562736974652053656b6f6c61682c2041706c696b6173692053656b6f6c61682c2050504442204f6e6c696e652c20505342204f6e6c696e652c20505342204f6e6c696e65204772617469732c2050656e6572696d61616e2053697377612042617275204f6e6c696e652c205261706f7274204f6e6c696e652c204b7572696b756c756d20323031332c2053442c20534d502c20534d412c20416c697961682c204d54732c20534d4b223b733a31323a226d61705f6c6f636174696f6e223b733a303a22223b733a373a2266617669636f6e223b733a33363a2234323262663664643337336261623236393736316536323032646562373562312e706e67223b733a363a22686561646572223b733a31303a226865616465722e706e67223b733a31363a227265636170746368615f737461747573223b733a363a22656e61626c65223b733a31383a227265636170746368615f736974655f6b6579223b733a34303a22364c666f3637636a4141414141484b5f63324a6342667a4a643844534d6c72386870654650793357223b733a32303a227265636170746368615f7365637265745f6b6579223b733a34303a22364c666f3637636a4141414141495976336a35794a5768454a74675241547634786159544e523066223b733a383a2274696d657a6f6e65223b733a31323a22417369612f4a616b61727461223b7d6d656469617c613a31383a7b733a31383a2266696c655f616c6c6f7765645f7479706573223b733a32343a226a70672c206a7065672c20706e672c206769662c20706466223b733a31393a2275706c6f61645f6d61785f66696c6573697a65223b733a313a2230223b733a32313a227468756d626e61696c5f73697a655f686569676874223b733a333a22313030223b733a32303a227468756d626e61696c5f73697a655f7769647468223b733a333a22313530223b733a31383a226d656469756d5f73697a655f686569676874223b733a333a22333038223b733a31373a226d656469756d5f73697a655f7769647468223b733a333a22343630223b733a31373a226c617267655f73697a655f686569676874223b733a333a22363030223b733a31363a226c617267655f73697a655f7769647468223b733a333a22383030223b733a31383a22616c62756d5f636f7665725f686569676874223b733a333a22323530223b733a31373a22616c62756d5f636f7665725f7769647468223b733a333a22343030223b733a31333a2262616e6e65725f686569676874223b733a323a223831223b733a31323a2262616e6e65725f7769647468223b733a333a22323435223b733a31393a22696d6167655f736c696465725f686569676874223b733a333a22343030223b733a31383a22696d6167655f736c696465725f7769647468223b733a333a22393030223b733a31373a22757365725f70686f746f5f686569676874223b733a333a22363030223b733a31363a22757365725f70686f746f5f7769647468223b733a333a22343030223b733a31313a226c6f676f5f686569676874223b733a333a22313230223b733a31303a226c6f676f5f7769647468223b733a333a22313230223b7d77726974696e677c613a31303a7b733a32313a2264656661756c745f706f73745f63617465676f7279223b733a313a2231223b733a31393a2264656661756c745f706f73745f737461747573223b733a373a227075626c697368223b733a32333a2264656661756c745f706f73745f7669736962696c697479223b733a363a227075626c6963223b733a32333a2264656661756c745f706f73745f64697363757373696f6e223b733a343a226f70656e223b733a32373a22706f73745f696d6167655f7468756d626e61696c5f686569676874223b733a333a22313030223b733a32363a22706f73745f696d6167655f7468756d626e61696c5f7769647468223b733a333a22313530223b733a32343a22706f73745f696d6167655f6d656469756d5f686569676874223b733a333a22323530223b733a32333a22706f73745f696d6167655f6d656469756d5f7769647468223b733a333a22343030223b733a32333a22706f73745f696d6167655f6c617267655f686569676874223b733a333a22343530223b733a32323a22706f73745f696d6167655f6c617267655f7769647468223b733a333a22383430223b7d72656164696e677c613a343a7b733a31333a22706f73745f7065725f70616765223b733a313a2235223b733a31343a22706f73745f7273735f636f756e74223b733a323a223130223b733a31383a22706f73745f72656c617465645f636f756e74223b733a313a2235223b733a31363a22636f6d6d656e745f7065725f70616765223b733a313a2235223b7d64697363757373696f6e7c613a343a7b733a31383a22636f6d6d656e745f6d6f6465726174696f6e223b733a353a2266616c7365223b733a32303a22636f6d6d656e745f726567697374726174696f6e223b733a353a2266616c7365223b733a31373a22636f6d6d656e745f626c61636b6c697374223b733a373a226b616d70726574223b733a31333a22636f6d6d656e745f6f72646572223b733a333a22617363223b7d736f6369616c5f6163636f756e747c613a353a7b733a383a2266616365626f6f6b223b733a33383a2268747470733a2f2f7777772e66616365626f6f6b2e636f6d2f636d7373656b6f6c61686b752f223b733a373a2274776974746572223b733a33313a2268747470733a2f2f747769747465722e636f6d2f616e746f6e736f6679616e223b733a393a226c696e6b65645f696e223b733a35303a2268747470733a2f2f7777772e6c696e6b6564696e2e636f6d2f696e2f616e746f6e2d736f6679616e2d31343238393337612f223b733a373a22796f7574756265223b733a313a222d223b733a393a22696e7374616772616d223b733a33393a2268747470733a2f2f7777772e696e7374616772616d2e636f6d2f616e746f6e5f736f6679616e2f223b7d6d61696c5f7365727665727c613a343a7b733a393a22736d74705f686f7374223b733a303a22223b733a393a22736d74705f75736572223b733a303a22223b733a393a22736d74705f70617373223b733a303a22223b733a393a22736d74705f706f7274223b733a303a22223b7d7363686f6f6c5f70726f66696c657c613a32313a7b733a343a226e70736e223b733a383a223130323634353932223b733a31313a227363686f6f6c5f6e616d65223b733a31363a224d54535320595020414c20415a484152223b733a31303a22686561646d6173746572223b733a31313a22446f6e6e792c20532e532e223b733a31363a22686561646d61737465725f70686f746f223b733a33363a2236623462633538633231393335663339643866333136346666653935356535612e6a7067223b733a31323a227363686f6f6c5f6c6576656c223b733a333a22313032223b733a31333a227363686f6f6c5f737461747573223b733a313a2232223b733a31363a226f776e6572736869705f737461747573223b733a333a22313131223b733a373a227461676c696e65223b733a31383a224d616e204a61646461205761204a61646461223b733a323a227274223b733a323a223030223b733a323a227277223b733a323a223030223b733a31313a227375625f76696c6c616765223b733a313a222d223b733a373a2276696c6c616765223b733a31353a225365692053696b616d62696e672042223b733a31323a227375625f6469737472696374223b733a31333a224d6564616e2053756e6767616c223b733a383a226469737472696374223b733a31303a224b6f7461204d6564616e223b733a31313a22706f7374616c5f636f6465223b733a353a223230313232223b733a31343a227374726565745f61646472657373223b733a33303a224a6c2e204d6572616b2047672e204e697277616e61204e6f2e2036352046223b733a353a2270686f6e65223b733a31313a223036312038343538393535223b733a333a22666178223b733a31313a223036312038343538393535223b733a353a22656d61696c223b733a32333a226d7473737970616c617a68617240676d61696c2e636f6d223b733a373a2277656273697465223b733a32343a227777772e6d7473737970616c617a6861722e7363682e6964223b733a343a226c6f676f223b733a33363a2239333062316362653966613333396464663064666637316339343236366639322e706e67223b7d61646d697373696f6e7c613a373a7b733a31363a2261646d697373696f6e5f737461747573223b733a343a226f70656e223b733a32333a22616e6e6f756e63656d656e745f73746172745f64617465223b733a31303a22323032352d30312d3031223b733a32313a22616e6e6f756e63656d656e745f656e645f64617465223b733a31303a22323032352d30372d3132223b733a32363a227072696e745f6578616d5f636172645f73746172745f64617465223b733a31303a22323032332d30312d3031223b733a32343a227072696e745f6578616d5f636172645f656e645f64617465223b733a31303a22323032342d31322d3331223b733a31343a226d696e5f62697274685f64617465223b4e3b733a31343a226d61785f62697274685f64617465223b4e3b7d7468656d657c733a313a2232223b666f726d5f69735f7472616e736665727c613a323a7b733a393a2261646d697373696f6e223b733a343a2274727565223b733a31383a2261646d697373696f6e5f7265717569726564223b733a343a2274727565223b7d666f726d5f61646d697373696f6e5f747970655f69647c613a323a7b733a393a2261646d697373696f6e223b733a343a2274727565223b733a31383a2261646d697373696f6e5f7265717569726564223b733a343a2274727565223b7d666f726d5f66697273745f63686f6963655f69647c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f7365636f6e645f63686f6963655f69647c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f6e696b7c613a323a7b733a393a2261646d697373696f6e223b733a343a2274727565223b733a31383a2261646d697373696f6e5f7265717569726564223b733a343a2274727565223b7d666f726d5f707265765f7363686f6f6c5f6e616d657c613a323a7b733a393a2261646d697373696f6e223b733a343a2274727565223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f707265765f6578616d5f6e756d6265727c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f736b68756e7c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f707265765f6469706c6f6d615f6e756d6265727c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f66756c6c5f6e616d657c613a323a7b733a393a2261646d697373696f6e223b733a343a2274727565223b733a31383a2261646d697373696f6e5f7265717569726564223b733a343a2274727565223b7d666f726d5f67656e6465727c613a323a7b733a393a2261646d697373696f6e223b733a343a2274727565223b733a31383a2261646d697373696f6e5f7265717569726564223b733a343a2274727565223b7d666f726d5f6e69736e7c613a323a7b733a393a2261646d697373696f6e223b733a343a2274727565223b733a31383a2261646d697373696f6e5f7265717569726564223b733a343a2274727565223b7d666f726d5f66616d696c795f636172645f6e756d6265727c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f62697274685f706c6163657c613a323a7b733a393a2261646d697373696f6e223b733a343a2274727565223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f62697274685f646174657c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f62697274685f63657274696669636174655f6e756d6265727c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f72656c6967696f6e5f69647c613a323a7b733a393a2261646d697373696f6e223b733a343a2274727565223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f636974697a656e736869707c613a323a7b733a393a2261646d697373696f6e223b733a343a2274727565223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f636f756e7472797c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f7370656369616c5f6e6565645f69647c613a323a7b733a393a2261646d697373696f6e223b733a343a2274727565223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f7374726565745f616464726573737c613a323a7b733a393a2261646d697373696f6e223b733a343a2274727565223b733a31383a2261646d697373696f6e5f7265717569726564223b733a343a2274727565223b7d666f726d5f72747c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f72777c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f7375625f76696c6c6167657c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f76696c6c6167657c613a323a7b733a393a2261646d697373696f6e223b733a343a2274727565223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f7375625f64697374726963747c613a323a7b733a393a2261646d697373696f6e223b733a343a2274727565223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f64697374726963747c613a323a7b733a393a2261646d697373696f6e223b733a343a2274727565223b733a31383a2261646d697373696f6e5f7265717569726564223b733a343a2274727565223b7d666f726d5f706f7374616c5f636f64657c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f6c617469747564657c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f6c6f6e6769747564657c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f7265736964656e63655f69647c613a323a7b733a393a2261646d697373696f6e223b733a343a2274727565223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f7472616e73706f72746174696f6e5f69647c613a323a7b733a393a2261646d697373696f6e223b733a343a2274727565223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f6368696c645f6e756d6265727c613a323a7b733a393a2261646d697373696f6e223b733a343a2274727565223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f656d706c6f796d656e745f69647c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f686176655f6b69707c613a323a7b733a393a2261646d697373696f6e223b733a343a2274727565223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f726563656976655f6b69707c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f72656a6563745f7069707c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f6661746865725f6e616d657c613a323a7b733a393a2261646d697373696f6e223b733a343a2274727565223b733a31383a2261646d697373696f6e5f7265717569726564223b733a343a2274727565223b7d666f726d5f6661746865725f6e696b7c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f6661746865725f62697274685f706c6163657c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f6661746865725f62697274685f646174657c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f6661746865725f656475636174696f6e5f69647c613a323a7b733a393a2261646d697373696f6e223b733a343a2274727565223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f6661746865725f656d706c6f796d656e745f69647c613a323a7b733a393a2261646d697373696f6e223b733a343a2274727565223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f6661746865725f6d6f6e74686c795f696e636f6d655f69647c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f6661746865725f7370656369616c5f6e6565645f69647c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f6661746865725f6964656e746974795f636172647c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f6d6f746865725f6e616d657c613a323a7b733a393a2261646d697373696f6e223b733a343a2274727565223b733a31383a2261646d697373696f6e5f7265717569726564223b733a343a2274727565223b7d666f726d5f6d6f746865725f6e696b7c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f6d6f746865725f62697274685f706c6163657c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f6d6f746865725f62697274685f646174657c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f6d6f746865725f656475636174696f6e5f69647c613a323a7b733a393a2261646d697373696f6e223b733a343a2274727565223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f6d6f746865725f656d706c6f796d656e745f69647c613a323a7b733a393a2261646d697373696f6e223b733a343a2274727565223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f6d6f746865725f6d6f6e74686c795f696e636f6d655f69647c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f6d6f746865725f7370656369616c5f6e6565645f69647c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f6d6f746865725f6964656e746974795f636172647c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f677561726469616e5f6e616d657c613a323a7b733a393a2261646d697373696f6e223b733a343a2274727565223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f677561726469616e5f6e696b7c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f677561726469616e5f62697274685f646174657c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f677561726469616e5f62697274685f706c6163657c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f677561726469616e5f656475636174696f6e5f69647c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f677561726469616e5f656d706c6f796d656e745f69647c613a323a7b733a393a2261646d697373696f6e223b733a343a2274727565223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f677561726469616e5f6d6f6e74686c795f696e636f6d655f69647c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f677561726469616e5f6964656e746974795f636172647c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f70686f6e657c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f6d6f62696c655f70686f6e657c613a323a7b733a393a2261646d697373696f6e223b733a343a2274727565223b733a31383a2261646d697373696f6e5f7265717569726564223b733a343a2274727565223b7d666f726d5f656d61696c7c613a323a7b733a393a2261646d697373696f6e223b733a343a2274727565223b733a31383a2261646d697373696f6e5f7265717569726564223b733a343a2274727565223b7d666f726d5f6865696768747c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f7765696768747c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f686561645f63697263756d666572656e63657c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f6d696c656167657c613a323a7b733a393a2261646d697373696f6e223b733a343a2274727565223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f74726176656c696e675f74696d657c613a323a7b733a393a2261646d697373696f6e223b733a343a2274727565223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f7369626c696e675f6e756d6265727c613a323a7b733a393a2261646d697373696f6e223b733a343a2274727565223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f77656c666172655f747970657c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f77656c666172655f6e756d6265727c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f77656c666172655f6e616d657c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f70686f746f7c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f66616d696c795f636172647c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d666f726d5f62697274685f63657274696669636174657c613a323a7b733a393a2261646d697373696f6e223b733a353a2266616c7365223b733a31383a2261646d697373696f6e5f7265717569726564223b733a353a2266616c7365223b7d61646d697373696f6e5f73656d65737465725f69647c733a313a2232223b61646d697373696f6e5f73656d65737465727c733a393a22323032352d32303236223b61646d697373696f6e5f796561727c733a343a2232303235223b63757272656e745f61636164656d69635f796561725f69647c733a313a2231223b63757272656e745f61636164656d69635f796561727c733a393a22323032342d32303235223b63757272656e745f61636164656d69635f73656d65737465727c733a333a226f6464223b61646d697373696f6e5f70686173655f69647c733a313a2231223b61646d697373696f6e5f70686173657c733a31313a2247656c6f6d62616e672049223b61646d697373696f6e5f73746172745f646174657c733a31303a22323032352d30312d3031223b61646d697373696f6e5f656e645f646174657c733a31303a22323032352d30342d3330223b6d616a6f725f636f756e747c623a303b757365725f69647c733a313a2232223b656d61696c7c733a33323a226162726970726174616d61406d7473737970616c617a6861722e7363682e6964223b66756c6c5f6e616d657c733a31323a22414252492050524154414d41223b69735f73757065725f61646d696e7c623a303b69735f61646d696e7c623a303b69735f656d706c6f7965657c623a313b69735f70726f73706563746976655f73747564656e747c623a303b69735f73747564656e747c623a303b69735f616c756d6e697c623a303b6163746976657c623a313b757365725f70726976696c656765737c613a353a7b693a303b733a393a2264617368626f617264223b693a313b733a31353a226368616e67655f70617373776f7264223b693a323b733a31363a22656d706c6f7965655f70726f66696c65223b693a333b733a353a22706f737473223b693a343b733a373a2274656163686572223b7d656d706c6f796d656e745f747970657c733a31393a2247757275204d6174612050656c616a6172616e223b);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
