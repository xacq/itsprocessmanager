-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 21, 2026 at 12:54 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ist_austro`
--

-- --------------------------------------------------------

--
-- Table structure for table `auth_group`
--

CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_group_permissions`
--

CREATE TABLE `auth_group_permissions` (
  `id` bigint(20) NOT NULL,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_permission`
--

CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `auth_permission`
--

INSERT INTO `auth_permission` (`id`, `name`, `content_type_id`, `codename`) VALUES
(1, 'Can add log entry', 1, 'add_logentry'),
(2, 'Can change log entry', 1, 'change_logentry'),
(3, 'Can delete log entry', 1, 'delete_logentry'),
(4, 'Can view log entry', 1, 'view_logentry'),
(5, 'Can add permission', 2, 'add_permission'),
(6, 'Can change permission', 2, 'change_permission'),
(7, 'Can delete permission', 2, 'delete_permission'),
(8, 'Can view permission', 2, 'view_permission'),
(9, 'Can add group', 3, 'add_group'),
(10, 'Can change group', 3, 'change_group'),
(11, 'Can delete group', 3, 'delete_group'),
(12, 'Can view group', 3, 'view_group'),
(13, 'Can add content type', 4, 'add_contenttype'),
(14, 'Can change content type', 4, 'change_contenttype'),
(15, 'Can delete content type', 4, 'delete_contenttype'),
(16, 'Can view content type', 4, 'view_contenttype'),
(17, 'Can add session', 5, 'add_session'),
(18, 'Can change session', 5, 'change_session'),
(19, 'Can delete session', 5, 'delete_session'),
(20, 'Can view session', 5, 'view_session'),
(21, 'Can add user', 6, 'add_user'),
(22, 'Can change user', 6, 'change_user'),
(23, 'Can delete user', 6, 'delete_user'),
(24, 'Can view user', 6, 'view_user'),
(25, 'Can add academic period', 7, 'add_academicperiod'),
(26, 'Can change academic period', 7, 'change_academicperiod'),
(27, 'Can delete academic period', 7, 'delete_academicperiod'),
(28, 'Can view academic period', 7, 'view_academicperiod'),
(29, 'Can add career', 8, 'add_career'),
(30, 'Can change career', 8, 'change_career'),
(31, 'Can delete career', 8, 'delete_career'),
(32, 'Can view career', 8, 'view_career'),
(33, 'Can add macro process', 9, 'add_macroprocess'),
(34, 'Can change macro process', 9, 'change_macroprocess'),
(35, 'Can delete macro process', 9, 'delete_macroprocess'),
(36, 'Can view macro process', 9, 'view_macroprocess'),
(37, 'Can add process', 10, 'add_process'),
(38, 'Can change process', 10, 'change_process'),
(39, 'Can delete process', 10, 'delete_process'),
(40, 'Can view process', 10, 'view_process'),
(41, 'Can add process institution', 11, 'add_processinstitution'),
(42, 'Can change process institution', 11, 'change_processinstitution'),
(43, 'Can delete process institution', 11, 'delete_processinstitution'),
(44, 'Can view process institution', 11, 'view_processinstitution'),
(45, 'Can add sub process template', 12, 'add_subprocesstemplate'),
(46, 'Can change sub process template', 12, 'change_subprocesstemplate'),
(47, 'Can delete sub process template', 12, 'delete_subprocesstemplate'),
(48, 'Can view sub process template', 12, 'view_subprocesstemplate'),
(49, 'Can add sub process instance', 13, 'add_subprocessinstance'),
(50, 'Can change sub process instance', 13, 'change_subprocessinstance'),
(51, 'Can delete sub process instance', 13, 'delete_subprocessinstance'),
(52, 'Can view sub process instance', 13, 'view_subprocessinstance'),
(53, 'Can add storage type', 14, 'add_storagetype'),
(54, 'Can change storage type', 14, 'change_storagetype'),
(55, 'Can delete storage type', 14, 'delete_storagetype'),
(56, 'Can view storage type', 14, 'view_storagetype'),
(57, 'Can add operation template', 15, 'add_operationtemplate'),
(58, 'Can change operation template', 15, 'change_operationtemplate'),
(59, 'Can delete operation template', 15, 'delete_operationtemplate'),
(60, 'Can view operation template', 15, 'view_operationtemplate'),
(61, 'Can add operation instance', 16, 'add_operationinstance'),
(62, 'Can change operation instance', 16, 'change_operationinstance'),
(63, 'Can delete operation instance', 16, 'delete_operationinstance'),
(64, 'Can view operation instance', 16, 'view_operationinstance'),
(65, 'Can add operation assignment', 17, 'add_operationassignment'),
(66, 'Can change operation assignment', 17, 'change_operationassignment'),
(67, 'Can delete operation assignment', 17, 'delete_operationassignment'),
(68, 'Can view operation assignment', 17, 'view_operationassignment'),
(69, 'Can add operation actor template', 18, 'add_operationactortemplate'),
(70, 'Can change operation actor template', 18, 'change_operationactortemplate'),
(71, 'Can delete operation actor template', 18, 'delete_operationactortemplate'),
(72, 'Can view operation actor template', 18, 'view_operationactortemplate'),
(73, 'Can add notification', 19, 'add_notification'),
(74, 'Can change notification', 19, 'change_notification'),
(75, 'Can delete notification', 19, 'delete_notification'),
(76, 'Can view notification', 19, 'view_notification'),
(77, 'Can add document', 20, 'add_document'),
(78, 'Can change document', 20, 'change_document'),
(79, 'Can delete document', 20, 'delete_document'),
(80, 'Can view document', 20, 'view_document'),
(81, 'Can add cron job log', 21, 'add_cronjoblog'),
(82, 'Can change cron job log', 21, 'change_cronjoblog'),
(83, 'Can delete cron job log', 21, 'delete_cronjoblog'),
(84, 'Can view cron job log', 21, 'view_cronjoblog'),
(85, 'Can add cron job lock', 22, 'add_cronjoblock'),
(86, 'Can change cron job lock', 22, 'change_cronjoblock'),
(87, 'Can delete cron job lock', 22, 'delete_cronjoblock'),
(88, 'Can view cron job lock', 22, 'view_cronjoblock');

-- --------------------------------------------------------

--
-- Table structure for table `django_admin_log`
--

CREATE TABLE `django_admin_log` (
  `id` int(11) NOT NULL,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext DEFAULT NULL,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) UNSIGNED NOT NULL CHECK (`action_flag` >= 0),
  `change_message` longtext NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `django_content_type`
--

CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `django_content_type`
--

INSERT INTO `django_content_type` (`id`, `app_label`, `model`) VALUES
(1, 'admin', 'logentry'),
(3, 'auth', 'group'),
(2, 'auth', 'permission'),
(4, 'contenttypes', 'contenttype'),
(22, 'django_cron', 'cronjoblock'),
(21, 'django_cron', 'cronjoblog'),
(7, 'processes', 'academicperiod'),
(8, 'processes', 'career'),
(20, 'processes', 'document'),
(9, 'processes', 'macroprocess'),
(19, 'processes', 'notification'),
(18, 'processes', 'operationactortemplate'),
(17, 'processes', 'operationassignment'),
(16, 'processes', 'operationinstance'),
(15, 'processes', 'operationtemplate'),
(10, 'processes', 'process'),
(11, 'processes', 'processinstitution'),
(14, 'processes', 'storagetype'),
(13, 'processes', 'subprocessinstance'),
(12, 'processes', 'subprocesstemplate'),
(6, 'processes', 'user'),
(5, 'sessions', 'session');

-- --------------------------------------------------------

--
-- Table structure for table `django_cron_cronjoblock`
--

CREATE TABLE `django_cron_cronjoblock` (
  `id` bigint(20) NOT NULL,
  `job_name` varchar(200) NOT NULL,
  `locked` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `django_cron_cronjoblog`
--

CREATE TABLE `django_cron_cronjoblog` (
  `id` bigint(20) NOT NULL,
  `code` varchar(64) NOT NULL,
  `start_time` datetime(6) NOT NULL,
  `end_time` datetime(6) NOT NULL,
  `is_success` tinyint(1) NOT NULL,
  `message` longtext NOT NULL,
  `ran_at_time` time(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `django_migrations`
--

CREATE TABLE `django_migrations` (
  `id` bigint(20) NOT NULL,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `django_migrations`
--

INSERT INTO `django_migrations` (`id`, `app`, `name`, `applied`) VALUES
(1, 'contenttypes', '0001_initial', '2026-01-20 23:18:51.855651'),
(2, 'contenttypes', '0002_remove_content_type_name', '2026-01-20 23:18:51.911000'),
(3, 'auth', '0001_initial', '2026-01-20 23:18:52.143974'),
(4, 'auth', '0002_alter_permission_name_max_length', '2026-01-20 23:18:52.205189'),
(5, 'auth', '0003_alter_user_email_max_length', '2026-01-20 23:18:52.210254'),
(6, 'auth', '0004_alter_user_username_opts', '2026-01-20 23:18:52.220252'),
(7, 'auth', '0005_alter_user_last_login_null', '2026-01-20 23:18:52.228079'),
(8, 'auth', '0006_require_contenttypes_0002', '2026-01-20 23:18:52.230532'),
(9, 'auth', '0007_alter_validators_add_error_messages', '2026-01-20 23:18:52.236529'),
(10, 'auth', '0008_alter_user_username_max_length', '2026-01-20 23:18:52.243813'),
(11, 'auth', '0009_alter_user_last_name_max_length', '2026-01-20 23:18:52.250695'),
(12, 'auth', '0010_alter_group_name_max_length', '2026-01-20 23:18:52.262639'),
(13, 'auth', '0011_update_proxy_permissions', '2026-01-20 23:18:52.272643'),
(14, 'auth', '0012_alter_user_first_name_max_length', '2026-01-20 23:18:52.278562'),
(15, 'processes', '0001_initial', '2026-01-20 23:18:54.150576'),
(16, 'admin', '0001_initial', '2026-01-20 23:18:54.305397'),
(17, 'admin', '0002_logentry_remove_auto_add', '2026-01-20 23:18:54.317825'),
(18, 'admin', '0003_logentry_add_action_flag_choices', '2026-01-20 23:18:54.332417'),
(19, 'django_cron', '0001_initial', '2026-01-20 23:18:54.440292'),
(20, 'django_cron', '0002_remove_max_length_from_CronJobLog_message', '2026-01-20 23:18:54.446704'),
(21, 'django_cron', '0003_cronjoblock', '2026-01-20 23:18:54.483219'),
(22, 'django_cron', '0004_alter_cronjoblock_id_alter_cronjoblog_id', '2026-01-20 23:18:54.610262'),
(23, 'processes', '0002_storagetype_created_at_storagetype_updated_at_and_more', '2026-01-20 23:18:54.684768'),
(24, 'processes', '0003_operationactortemplate_participant', '2026-01-20 23:18:54.793775'),
(25, 'sessions', '0001_initial', '2026-01-20 23:18:54.832065');

-- --------------------------------------------------------

--
-- Table structure for table `django_session`
--

CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `django_session`
--

INSERT INTO `django_session` (`session_key`, `session_data`, `expire_date`) VALUES
('utfu1pna9bbx97xw5mrrmko2szc76yok', '.eJxVjEEOwiAQRe_C2hAomcK4dO8ZyAyMUjU0Ke2q8e5K0oWufvLfy9tVpG0tcWuyxCmrsxrU6fdjSk-pHeQH1fus01zXZWLdFX3Qpq9zltflcP8ChVrp2SFBYLKSgDl5tMGi2ICOAJEA3OgzjInEZcsWmUx2xrtbCOY76NT7A96RN0Y:1viLQr:Mc888N2kSPYMO8p-Q8M7HxG64kVQhtFnwEJisVf-TWg', '2026-02-03 23:46:45.600479');

-- --------------------------------------------------------

--
-- Table structure for table `processes_academicperiod`
--

CREATE TABLE `processes_academicperiod` (
  `id` bigint(20) NOT NULL,
  `code` varchar(20) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `processes_academicperiod`
--

INSERT INTO `processes_academicperiod` (`id`, `code`, `start_date`, `end_date`) VALUES
(1, '2025-1', '2025-05-01', '2025-09-30');

-- --------------------------------------------------------

--
-- Table structure for table `processes_career`
--

CREATE TABLE `processes_career` (
  `id` bigint(20) NOT NULL,
  `name` varchar(120) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `processes_career`
--

INSERT INTO `processes_career` (`id`, `name`) VALUES
(1, 'Tecnología en Redes'),
(2, 'Contabilidad');

-- --------------------------------------------------------

--
-- Table structure for table `processes_document`
--

CREATE TABLE `processes_document` (
  `id` bigint(20) NOT NULL,
  `file` varchar(100) NOT NULL,
  `uploaded_at` datetime(6) NOT NULL,
  `approved_at` datetime(6) DEFAULT NULL,
  `approved_by_id` bigint(20) DEFAULT NULL,
  `operation_instance_id` bigint(20) NOT NULL,
  `replaced_document_id` bigint(20) DEFAULT NULL,
  `storage_type_id` bigint(20) NOT NULL,
  `uploaded_by_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `processes_macroprocess`
--

CREATE TABLE `processes_macroprocess` (
  `id` bigint(20) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `code_suffix` varchar(3) NOT NULL,
  `name` varchar(120) NOT NULL,
  `description` longtext NOT NULL,
  `process_institution_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `processes_macroprocess`
--

INSERT INTO `processes_macroprocess` (`id`, `created_at`, `updated_at`, `code_suffix`, `name`, `description`, `process_institution_id`) VALUES
(1, '2025-07-21 00:00:00.000000', '2025-07-21 00:00:00.000000', '001', 'Formación Profesional', '', 1);

-- --------------------------------------------------------

--
-- Table structure for table `processes_notification`
--

CREATE TABLE `processes_notification` (
  `id` bigint(20) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `message` longtext NOT NULL,
  `is_read` tinyint(1) NOT NULL,
  `related_assignment_id` bigint(20) DEFAULT NULL,
  `user_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `processes_operationactortemplate`
--

CREATE TABLE `processes_operationactortemplate` (
  `id` bigint(20) NOT NULL,
  `role` varchar(12) NOT NULL,
  `is_emitter` tinyint(1) NOT NULL,
  `is_receiver` tinyint(1) NOT NULL,
  `operation_template_id` bigint(20) NOT NULL,
  `participant_id` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `processes_operationactortemplate`
--

INSERT INTO `processes_operationactortemplate` (`id`, `role`, `is_emitter`, `is_receiver`, `operation_template_id`, `participant_id`) VALUES
(1, 'PARTICIPANT', 1, 0, 5, NULL),
(2, 'MANAGER', 0, 1, 5, NULL),
(3, 'PARTICIPANT', 1, 0, 1, NULL),
(4, 'MANAGER', 0, 1, 1, NULL),
(5, 'PARTICIPANT', 1, 0, 2, NULL),
(6, 'MANAGER', 0, 1, 2, NULL),
(7, 'PARTICIPANT', 1, 0, 3, NULL),
(8, 'MANAGER', 0, 1, 3, NULL),
(9, 'PARTICIPANT', 1, 0, 4, NULL),
(10, 'MANAGER', 0, 1, 4, NULL),
(11, 'PARTICIPANT', 1, 0, 5, NULL),
(12, 'MANAGER', 0, 1, 5, NULL),
(13, 'PARTICIPANT', 1, 0, 6, NULL),
(14, 'MANAGER', 0, 1, 6, NULL),
(15, 'PARTICIPANT', 1, 0, 7, NULL),
(16, 'MANAGER', 0, 1, 7, NULL),
(17, 'PARTICIPANT', 1, 0, 8, NULL),
(18, 'MANAGER', 0, 1, 8, NULL),
(19, 'PARTICIPANT', 1, 0, 9, NULL),
(20, 'MANAGER', 0, 1, 9, NULL),
(21, 'PARTICIPANT', 1, 0, 10, NULL),
(22, 'MANAGER', 0, 1, 10, NULL),
(23, 'PARTICIPANT', 1, 0, 11, NULL),
(24, 'MANAGER', 0, 1, 11, NULL),
(25, 'PARTICIPANT', 1, 0, 12, NULL),
(26, 'MANAGER', 0, 1, 12, NULL),
(27, 'PARTICIPANT', 1, 0, 13, NULL),
(28, 'MANAGER', 0, 1, 13, NULL),
(29, 'PARTICIPANT', 1, 0, 14, NULL),
(30, 'MANAGER', 0, 1, 14, NULL),
(31, 'PARTICIPANT', 1, 0, 15, NULL),
(32, 'MANAGER', 0, 1, 15, NULL),
(33, 'PARTICIPANT', 1, 0, 16, NULL),
(34, 'MANAGER', 0, 1, 16, NULL),
(35, 'PARTICIPANT', 1, 0, 17, NULL),
(36, 'MANAGER', 0, 1, 17, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `processes_operationassignment`
--

CREATE TABLE `processes_operationassignment` (
  `id` bigint(20) NOT NULL,
  `role_in_operation` varchar(12) NOT NULL,
  `status` varchar(12) NOT NULL,
  `completed_at` datetime(6) DEFAULT NULL,
  `operation_instance_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `processes_operationinstance`
--

CREATE TABLE `processes_operationinstance` (
  `id` bigint(20) NOT NULL,
  `state` varchar(12) NOT NULL,
  `deadline` date DEFAULT NULL,
  `order` smallint(5) UNSIGNED NOT NULL CHECK (`order` >= 0),
  `operation_template_id` bigint(20) NOT NULL,
  `subprocess_instance_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `processes_operationtemplate`
--

CREATE TABLE `processes_operationtemplate` (
  `id` bigint(20) NOT NULL,
  `name` varchar(120) NOT NULL,
  `type` varchar(15) NOT NULL,
  `order` smallint(5) UNSIGNED NOT NULL CHECK (`order` >= 0),
  `deadline_days` smallint(5) UNSIGNED NOT NULL CHECK (`deadline_days` >= 0),
  `requires_approval` tinyint(1) NOT NULL,
  `storage_type_id` bigint(20) DEFAULT NULL,
  `subprocess_template_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `processes_operationtemplate`
--

INSERT INTO `processes_operationtemplate` (`id`, `name`, `type`, `order`, `deadline_days`, `requires_approval`, `storage_type_id`, `subprocess_template_id`) VALUES
(1, 'Crear cronograma', 'COMPLETE', 1, 7, 0, NULL, 1),
(2, 'Subir carta compromiso', 'DOC_REQUEST', 2, 14, 0, 2, 1),
(3, 'Aprobar carta compromiso', 'REVIEW', 3, 3, 1, 2, 1),
(4, 'Plan de actividades aprobado', 'COMPLETE', 1, 7, 0, NULL, 3),
(5, 'Cargar evidencia semanal', 'DOC_REQUEST', 2, 7, 0, 4, 3),
(6, 'Validar evidencia', 'REVIEW', 3, 7, 1, 4, 3),
(7, 'Registrar horas completadas', 'COMPLETE', 4, 0, 0, NULL, 3),
(8, 'Cargar informe final', 'DOC_REQUEST', 1, 5, 0, 5, 4),
(9, 'Revisión del tutor', 'REVIEW', 2, 5, 1, 5, 4),
(10, 'Subir versión firmada', 'DOC_REQUEST', 3, 3, 0, 6, 4),
(11, 'Solicitar certificado', 'CERT_REQUEST', 1, 0, 0, 7, 5),
(12, 'Plan de proyecto aprobado', 'COMPLETE', 1, 7, 0, NULL, 6),
(13, 'Subir evidencia SC', 'DOC_REQUEST', 2, 14, 0, 8, 6),
(14, 'Aprobar evidencia SC', 'REVIEW', 3, 7, 1, 8, 6),
(15, 'Cargar informe SC', 'DOC_REQUEST', 4, 5, 0, 9, 6),
(16, 'Aprobar informe SC', 'REVIEW', 5, 5, 1, 9, 6),
(17, 'Generar certificado SC', 'CERT_REQUEST', 6, 0, 0, 10, 6);

-- --------------------------------------------------------

--
-- Table structure for table `processes_process`
--

CREATE TABLE `processes_process` (
  `id` bigint(20) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `code_suffix` varchar(3) NOT NULL,
  `name` varchar(120) NOT NULL,
  `description` longtext NOT NULL,
  `macro_process_id` bigint(20) NOT NULL,
  `manager_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `processes_process`
--

INSERT INTO `processes_process` (`id`, `created_at`, `updated_at`, `code_suffix`, `name`, `description`, `macro_process_id`, `manager_id`) VALUES
(1, '2025-07-21 00:00:00.000000', '2025-07-21 23:52:36.000000', '001', 'Prácticas Pre-Profesionales', '', 1, 2);

-- --------------------------------------------------------

--
-- Table structure for table `processes_processinstitution`
--

CREATE TABLE `processes_processinstitution` (
  `id` bigint(20) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `code` varchar(3) NOT NULL,
  `name` varchar(120) NOT NULL,
  `description` longtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `processes_processinstitution`
--

INSERT INTO `processes_processinstitution` (`id`, `created_at`, `updated_at`, `code`, `name`, `description`) VALUES
(1, '2025-07-21 00:00:00.000000', '2025-07-21 00:00:00.000000', '001', 'Procesos Académicos', '');

-- --------------------------------------------------------

--
-- Table structure for table `processes_storagetype`
--

CREATE TABLE `processes_storagetype` (
  `id` bigint(20) NOT NULL,
  `name` varchar(120) NOT NULL,
  `permanent` tinyint(1) NOT NULL,
  `subprocess_template_id` bigint(20) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `processes_storagetype`
--

INSERT INTO `processes_storagetype` (`id`, `name`, `permanent`, `subprocess_template_id`, `created_at`, `updated_at`) VALUES
(1, 'Cronograma', 1, 1, '2025-07-31 20:29:46.000000', '2025-07-31 20:29:46.000000'),
(2, 'Cartas', 1, 1, '2025-07-31 20:29:57.000000', '2025-07-31 20:29:57.000000'),
(3, 'Informe', 1, 1, '2025-07-31 20:30:08.000000', '2025-07-31 20:30:08.000000'),
(4, 'Evidencia PPP', 1, 3, '2025-08-01 01:33:18.426000', '2025-08-01 01:33:18.426000'),
(5, 'Informe PPP', 1, 4, '2025-08-01 01:33:38.717000', '2025-08-01 01:33:38.717000'),
(6, 'Informe Firmado', 1, 4, '2025-08-01 01:33:55.341000', '2025-08-01 01:33:55.341000'),
(7, 'Certificado PPP', 1, 5, '2025-08-01 01:34:13.267000', '2025-08-01 01:34:13.267000'),
(8, 'Evidencia SC', 1, 6, '2025-08-01 01:34:27.563000', '2025-08-01 01:34:27.563000'),
(9, 'Informe SC', 1, 6, '2025-08-01 01:34:41.104000', '2025-08-01 01:34:41.104000'),
(10, 'Certificado SC', 1, 6, '2025-08-01 01:34:50.557000', '2025-08-01 01:34:50.557000');

-- --------------------------------------------------------

--
-- Table structure for table `processes_subprocessinstance`
--

CREATE TABLE `processes_subprocessinstance` (
  `id` bigint(20) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `state` varchar(12) NOT NULL,
  `started_at` datetime(6) NOT NULL,
  `completed_at` datetime(6) DEFAULT NULL,
  `career_id` bigint(20) NOT NULL,
  `period_id` bigint(20) NOT NULL,
  `template_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `processes_subprocesstemplate`
--

CREATE TABLE `processes_subprocesstemplate` (
  `id` bigint(20) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `name` varchar(120) NOT NULL,
  `description` longtext NOT NULL,
  `created_by_id` bigint(20) NOT NULL,
  `process_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `processes_subprocesstemplate`
--

INSERT INTO `processes_subprocesstemplate` (`id`, `created_at`, `updated_at`, `name`, `description`, `created_by_id`, `process_id`) VALUES
(1, '2025-07-21 23:52:36.000000', '2025-07-21 23:52:36.000000', 'Planificación PPP', 'Varios', 1, 1),
(2, '2025-07-31 21:05:44.400000', '2025-08-01 01:29:08.612000', 'Planificación PPP', '', 2, 1),
(3, '2025-08-01 01:29:44.849000', '2025-08-01 01:29:44.849000', 'Ejecución PPP', '', 2, 1),
(4, '2025-08-01 01:30:12.110000', '2025-08-01 01:30:12.110000', 'Informe Final PPP', '', 2, 1),
(5, '2025-08-01 01:30:30.206000', '2025-08-01 01:30:30.206000', 'Certificado PPP', '', 2, 1),
(6, '2025-08-01 01:30:46.608000', '2025-08-01 01:30:46.608000', 'Servicio Comunitario', '', 2, 1);

-- --------------------------------------------------------

--
-- Table structure for table `processes_user`
--

CREATE TABLE `processes_user` (
  `id` bigint(20) NOT NULL,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  `id_number` varchar(20) NOT NULL,
  `role` varchar(12) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `processes_user`
--

INSERT INTO `processes_user` (`id`, `password`, `last_login`, `is_superuser`, `username`, `first_name`, `last_name`, `email`, `is_staff`, `is_active`, `date_joined`, `id_number`, `role`) VALUES
(1, 'pbkdf2_sha256$600000$TIWGKW7wutqwB0EeE0WQYJ$40FMDMcb7RFG5MR68bRycEFMPoDRu8hAvSoRx0Gqy1I=', '2026-01-20 23:45:48.257837', 1, 'admin', '', '', 'admin@istausto.edu.ec', 1, 1, '2026-01-20 23:25:43.800620', '0000000001', 'ADMIN'),
(2, 'pbkdf2_sha256$600000$yhqbaFKQkqrzKsCpMKKPQu$9I9OdqwvR7c1rbPNAaxr1FxpMUcuC6fWkY7h3N5blO0=', '2026-01-20 23:46:45.596806', 0, 'gestor', '', '', 'gestor@istausto.edu.ec', 1, 1, '2026-01-20 18:31:59.000000', '0000000002', 'MANAGER'),
(4, 'pbkdf2_sha256$600000$K6V8WFXfhWYCHKo2qec4fm$oSIJ1a9iZIgpT7l5mZ4Ae2x/DE0DPB7LSJAq8i94e1o=', NULL, 0, 'alumno', '', '', 'alumno@istausto.edu.ec', 0, 1, '2026-01-20 23:32:38.176141', '1111111111', 'PARTICIPANT');

-- --------------------------------------------------------

--
-- Table structure for table `processes_user_groups`
--

CREATE TABLE `processes_user_groups` (
  `id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `group_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `processes_user_user_permissions`
--

CREATE TABLE `processes_user_user_permissions` (
  `id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `auth_group`
--
ALTER TABLE `auth_group`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  ADD KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`);

--
-- Indexes for table `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`);

--
-- Indexes for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  ADD KEY `django_admin_log_user_id_c564eba6_fk_processes_user_id` (`user_id`);

--
-- Indexes for table `django_content_type`
--
ALTER TABLE `django_content_type`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`);

--
-- Indexes for table `django_cron_cronjoblock`
--
ALTER TABLE `django_cron_cronjoblock`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `job_name` (`job_name`);

--
-- Indexes for table `django_cron_cronjoblog`
--
ALTER TABLE `django_cron_cronjoblog`
  ADD PRIMARY KEY (`id`),
  ADD KEY `django_cron_cronjoblog_code_start_time_ran_at_time_8b50b8fa_idx` (`code`,`start_time`,`ran_at_time`),
  ADD KEY `django_cron_cronjoblog_code_start_time_4fc78f9d_idx` (`code`,`start_time`),
  ADD KEY `django_cron_cronjoblog_code_is_success_ran_at_time_84da9606_idx` (`code`,`is_success`,`ran_at_time`),
  ADD KEY `django_cron_cronjoblog_code_48865653` (`code`),
  ADD KEY `django_cron_cronjoblog_start_time_d68c0dd9` (`start_time`),
  ADD KEY `django_cron_cronjoblog_end_time_7918602a` (`end_time`),
  ADD KEY `django_cron_cronjoblog_ran_at_time_7fed2751` (`ran_at_time`);

--
-- Indexes for table `django_migrations`
--
ALTER TABLE `django_migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `django_session`
--
ALTER TABLE `django_session`
  ADD PRIMARY KEY (`session_key`),
  ADD KEY `django_session_expire_date_a5c62663` (`expire_date`);

--
-- Indexes for table `processes_academicperiod`
--
ALTER TABLE `processes_academicperiod`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `processes_career`
--
ALTER TABLE `processes_career`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `processes_document`
--
ALTER TABLE `processes_document`
  ADD PRIMARY KEY (`id`),
  ADD KEY `processes_document_approved_by_id_146756a0_fk_processes_user_id` (`approved_by_id`),
  ADD KEY `processes_document_operation_instance_i_ec737c85_fk_processes` (`operation_instance_id`),
  ADD KEY `processes_document_replaced_document_id_bcdbc3be_fk_processes` (`replaced_document_id`),
  ADD KEY `processes_document_storage_type_id_3835a552_fk_processes` (`storage_type_id`),
  ADD KEY `processes_document_uploaded_by_id_094b865f_fk_processes_user_id` (`uploaded_by_id`);

--
-- Indexes for table `processes_macroprocess`
--
ALTER TABLE `processes_macroprocess`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `processes_macroprocess_process_institution_id_c_ea6075e0_uniq` (`process_institution_id`,`code_suffix`);

--
-- Indexes for table `processes_notification`
--
ALTER TABLE `processes_notification`
  ADD PRIMARY KEY (`id`),
  ADD KEY `processes_notificati_related_assignment_i_db013a3d_fk_processes` (`related_assignment_id`),
  ADD KEY `processes_notification_user_id_0f3589f1_fk_processes_user_id` (`user_id`);

--
-- Indexes for table `processes_operationactortemplate`
--
ALTER TABLE `processes_operationactortemplate`
  ADD PRIMARY KEY (`id`),
  ADD KEY `processes_operationa_operation_template_i_bea3709b_fk_processes` (`operation_template_id`),
  ADD KEY `processes_operationa_participant_id_673fadfc_fk_processes` (`participant_id`);

--
-- Indexes for table `processes_operationassignment`
--
ALTER TABLE `processes_operationassignment`
  ADD PRIMARY KEY (`id`),
  ADD KEY `processes_operationa_operation_instance_i_7aa4ca50_fk_processes` (`operation_instance_id`),
  ADD KEY `processes_operationa_user_id_695b23d8_fk_processes` (`user_id`);

--
-- Indexes for table `processes_operationinstance`
--
ALTER TABLE `processes_operationinstance`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `processes_operationinsta_subprocess_instance_id_o_c63f6df2_uniq` (`subprocess_instance_id`,`order`),
  ADD KEY `processes_operationi_operation_template_i_94c8ec47_fk_processes` (`operation_template_id`);

--
-- Indexes for table `processes_operationtemplate`
--
ALTER TABLE `processes_operationtemplate`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `processes_operationtempl_subprocess_template_id_o_8d598609_uniq` (`subprocess_template_id`,`order`),
  ADD KEY `processes_operationt_storage_type_id_27c9d22f_fk_processes` (`storage_type_id`);

--
-- Indexes for table `processes_process`
--
ALTER TABLE `processes_process`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `processes_process_macro_process_id_code_suffix_81bd8ca3_uniq` (`macro_process_id`,`code_suffix`),
  ADD KEY `processes_process_manager_id_4e3d3898_fk_processes_user_id` (`manager_id`);

--
-- Indexes for table `processes_processinstitution`
--
ALTER TABLE `processes_processinstitution`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`);

--
-- Indexes for table `processes_storagetype`
--
ALTER TABLE `processes_storagetype`
  ADD PRIMARY KEY (`id`),
  ADD KEY `processes_storagetyp_subprocess_template__f56855ca_fk_processes` (`subprocess_template_id`);

--
-- Indexes for table `processes_subprocessinstance`
--
ALTER TABLE `processes_subprocessinstance`
  ADD PRIMARY KEY (`id`),
  ADD KEY `processes_subprocess_career_id_e17d63e1_fk_processes` (`career_id`),
  ADD KEY `processes_subprocess_period_id_28a25288_fk_processes` (`period_id`),
  ADD KEY `processes_subprocess_template_id_add9fb5e_fk_processes` (`template_id`);

--
-- Indexes for table `processes_subprocesstemplate`
--
ALTER TABLE `processes_subprocesstemplate`
  ADD PRIMARY KEY (`id`),
  ADD KEY `processes_subprocess_created_by_id_009e10ca_fk_processes` (`created_by_id`),
  ADD KEY `processes_subprocess_process_id_e61a64fa_fk_processes` (`process_id`);

--
-- Indexes for table `processes_user`
--
ALTER TABLE `processes_user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `id_number` (`id_number`);

--
-- Indexes for table `processes_user_groups`
--
ALTER TABLE `processes_user_groups`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `processes_user_groups_user_id_group_id_35072031_uniq` (`user_id`,`group_id`),
  ADD KEY `processes_user_groups_group_id_7910d88f_fk_auth_group_id` (`group_id`);

--
-- Indexes for table `processes_user_user_permissions`
--
ALTER TABLE `processes_user_user_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `processes_user_user_perm_user_id_permission_id_0f024bfd_uniq` (`user_id`,`permission_id`),
  ADD KEY `processes_user_user__permission_id_ab54a076_fk_auth_perm` (`permission_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `auth_group`
--
ALTER TABLE `auth_group`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_permission`
--
ALTER TABLE `auth_permission`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=89;

--
-- AUTO_INCREMENT for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `django_content_type`
--
ALTER TABLE `django_content_type`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `django_cron_cronjoblock`
--
ALTER TABLE `django_cron_cronjoblock`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `django_cron_cronjoblog`
--
ALTER TABLE `django_cron_cronjoblog`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `django_migrations`
--
ALTER TABLE `django_migrations`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `processes_academicperiod`
--
ALTER TABLE `processes_academicperiod`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `processes_career`
--
ALTER TABLE `processes_career`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `processes_document`
--
ALTER TABLE `processes_document`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `processes_macroprocess`
--
ALTER TABLE `processes_macroprocess`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `processes_notification`
--
ALTER TABLE `processes_notification`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `processes_operationactortemplate`
--
ALTER TABLE `processes_operationactortemplate`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT for table `processes_operationassignment`
--
ALTER TABLE `processes_operationassignment`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `processes_operationinstance`
--
ALTER TABLE `processes_operationinstance`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `processes_operationtemplate`
--
ALTER TABLE `processes_operationtemplate`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `processes_process`
--
ALTER TABLE `processes_process`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `processes_processinstitution`
--
ALTER TABLE `processes_processinstitution`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `processes_storagetype`
--
ALTER TABLE `processes_storagetype`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `processes_subprocessinstance`
--
ALTER TABLE `processes_subprocessinstance`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `processes_subprocesstemplate`
--
ALTER TABLE `processes_subprocesstemplate`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `processes_user`
--
ALTER TABLE `processes_user`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `processes_user_groups`
--
ALTER TABLE `processes_user_groups`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `processes_user_user_permissions`
--
ALTER TABLE `processes_user_user_permissions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`);

--
-- Constraints for table `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`);

--
-- Constraints for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  ADD CONSTRAINT `django_admin_log_user_id_c564eba6_fk_processes_user_id` FOREIGN KEY (`user_id`) REFERENCES `processes_user` (`id`);

--
-- Constraints for table `processes_document`
--
ALTER TABLE `processes_document`
  ADD CONSTRAINT `processes_document_approved_by_id_146756a0_fk_processes_user_id` FOREIGN KEY (`approved_by_id`) REFERENCES `processes_user` (`id`),
  ADD CONSTRAINT `processes_document_operation_instance_i_ec737c85_fk_processes` FOREIGN KEY (`operation_instance_id`) REFERENCES `processes_operationinstance` (`id`),
  ADD CONSTRAINT `processes_document_replaced_document_id_bcdbc3be_fk_processes` FOREIGN KEY (`replaced_document_id`) REFERENCES `processes_document` (`id`),
  ADD CONSTRAINT `processes_document_storage_type_id_3835a552_fk_processes` FOREIGN KEY (`storage_type_id`) REFERENCES `processes_storagetype` (`id`),
  ADD CONSTRAINT `processes_document_uploaded_by_id_094b865f_fk_processes_user_id` FOREIGN KEY (`uploaded_by_id`) REFERENCES `processes_user` (`id`);

--
-- Constraints for table `processes_macroprocess`
--
ALTER TABLE `processes_macroprocess`
  ADD CONSTRAINT `processes_macroproce_process_institution__46ba1e36_fk_processes` FOREIGN KEY (`process_institution_id`) REFERENCES `processes_processinstitution` (`id`);

--
-- Constraints for table `processes_notification`
--
ALTER TABLE `processes_notification`
  ADD CONSTRAINT `processes_notificati_related_assignment_i_db013a3d_fk_processes` FOREIGN KEY (`related_assignment_id`) REFERENCES `processes_operationassignment` (`id`),
  ADD CONSTRAINT `processes_notification_user_id_0f3589f1_fk_processes_user_id` FOREIGN KEY (`user_id`) REFERENCES `processes_user` (`id`);

--
-- Constraints for table `processes_operationactortemplate`
--
ALTER TABLE `processes_operationactortemplate`
  ADD CONSTRAINT `processes_operationa_operation_template_i_bea3709b_fk_processes` FOREIGN KEY (`operation_template_id`) REFERENCES `processes_operationtemplate` (`id`),
  ADD CONSTRAINT `processes_operationa_participant_id_673fadfc_fk_processes` FOREIGN KEY (`participant_id`) REFERENCES `processes_user` (`id`);

--
-- Constraints for table `processes_operationassignment`
--
ALTER TABLE `processes_operationassignment`
  ADD CONSTRAINT `processes_operationa_operation_instance_i_7aa4ca50_fk_processes` FOREIGN KEY (`operation_instance_id`) REFERENCES `processes_operationinstance` (`id`),
  ADD CONSTRAINT `processes_operationa_user_id_695b23d8_fk_processes` FOREIGN KEY (`user_id`) REFERENCES `processes_user` (`id`);

--
-- Constraints for table `processes_operationinstance`
--
ALTER TABLE `processes_operationinstance`
  ADD CONSTRAINT `processes_operationi_operation_template_i_94c8ec47_fk_processes` FOREIGN KEY (`operation_template_id`) REFERENCES `processes_operationtemplate` (`id`),
  ADD CONSTRAINT `processes_operationi_subprocess_instance__ee748c78_fk_processes` FOREIGN KEY (`subprocess_instance_id`) REFERENCES `processes_subprocessinstance` (`id`);

--
-- Constraints for table `processes_operationtemplate`
--
ALTER TABLE `processes_operationtemplate`
  ADD CONSTRAINT `processes_operationt_storage_type_id_27c9d22f_fk_processes` FOREIGN KEY (`storage_type_id`) REFERENCES `processes_storagetype` (`id`),
  ADD CONSTRAINT `processes_operationt_subprocess_template__8a2501b6_fk_processes` FOREIGN KEY (`subprocess_template_id`) REFERENCES `processes_subprocesstemplate` (`id`);

--
-- Constraints for table `processes_process`
--
ALTER TABLE `processes_process`
  ADD CONSTRAINT `processes_process_macro_process_id_9223327e_fk_processes` FOREIGN KEY (`macro_process_id`) REFERENCES `processes_macroprocess` (`id`),
  ADD CONSTRAINT `processes_process_manager_id_4e3d3898_fk_processes_user_id` FOREIGN KEY (`manager_id`) REFERENCES `processes_user` (`id`);

--
-- Constraints for table `processes_storagetype`
--
ALTER TABLE `processes_storagetype`
  ADD CONSTRAINT `processes_storagetyp_subprocess_template__f56855ca_fk_processes` FOREIGN KEY (`subprocess_template_id`) REFERENCES `processes_subprocesstemplate` (`id`);

--
-- Constraints for table `processes_subprocessinstance`
--
ALTER TABLE `processes_subprocessinstance`
  ADD CONSTRAINT `processes_subprocess_career_id_e17d63e1_fk_processes` FOREIGN KEY (`career_id`) REFERENCES `processes_career` (`id`),
  ADD CONSTRAINT `processes_subprocess_period_id_28a25288_fk_processes` FOREIGN KEY (`period_id`) REFERENCES `processes_academicperiod` (`id`),
  ADD CONSTRAINT `processes_subprocess_template_id_add9fb5e_fk_processes` FOREIGN KEY (`template_id`) REFERENCES `processes_subprocesstemplate` (`id`);

--
-- Constraints for table `processes_subprocesstemplate`
--
ALTER TABLE `processes_subprocesstemplate`
  ADD CONSTRAINT `processes_subprocess_created_by_id_009e10ca_fk_processes` FOREIGN KEY (`created_by_id`) REFERENCES `processes_user` (`id`),
  ADD CONSTRAINT `processes_subprocess_process_id_e61a64fa_fk_processes` FOREIGN KEY (`process_id`) REFERENCES `processes_process` (`id`);

--
-- Constraints for table `processes_user_groups`
--
ALTER TABLE `processes_user_groups`
  ADD CONSTRAINT `processes_user_groups_group_id_7910d88f_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  ADD CONSTRAINT `processes_user_groups_user_id_a2fd1e0b_fk_processes_user_id` FOREIGN KEY (`user_id`) REFERENCES `processes_user` (`id`);

--
-- Constraints for table `processes_user_user_permissions`
--
ALTER TABLE `processes_user_user_permissions`
  ADD CONSTRAINT `processes_user_user__permission_id_ab54a076_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `processes_user_user__user_id_fe4d94a9_fk_processes` FOREIGN KEY (`user_id`) REFERENCES `processes_user` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
