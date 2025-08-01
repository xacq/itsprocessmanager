-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 01-08-2025 a las 04:47:38
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `ist_austro`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auth_group`
--

CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auth_group_permissions`
--

CREATE TABLE `auth_group_permissions` (
  `id` bigint(20) NOT NULL,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auth_permission`
--

CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `auth_permission`
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
(25, 'Can add process institution', 7, 'add_processinstitution'),
(26, 'Can change process institution', 7, 'change_processinstitution'),
(27, 'Can delete process institution', 7, 'delete_processinstitution'),
(28, 'Can view process institution', 7, 'view_processinstitution'),
(29, 'Can add macro process', 8, 'add_macroprocess'),
(30, 'Can change macro process', 8, 'change_macroprocess'),
(31, 'Can delete macro process', 8, 'delete_macroprocess'),
(32, 'Can view macro process', 8, 'view_macroprocess'),
(33, 'Can add process', 9, 'add_process'),
(34, 'Can change process', 9, 'change_process'),
(35, 'Can delete process', 9, 'delete_process'),
(36, 'Can view process', 9, 'view_process'),
(37, 'Can add sub process template', 10, 'add_subprocesstemplate'),
(38, 'Can change sub process template', 10, 'change_subprocesstemplate'),
(39, 'Can delete sub process template', 10, 'delete_subprocesstemplate'),
(40, 'Can view sub process template', 10, 'view_subprocesstemplate'),
(41, 'Can add storage type', 11, 'add_storagetype'),
(42, 'Can change storage type', 11, 'change_storagetype'),
(43, 'Can delete storage type', 11, 'delete_storagetype'),
(44, 'Can view storage type', 11, 'view_storagetype'),
(45, 'Can add operation template', 12, 'add_operationtemplate'),
(46, 'Can change operation template', 12, 'change_operationtemplate'),
(47, 'Can delete operation template', 12, 'delete_operationtemplate'),
(48, 'Can view operation template', 12, 'view_operationtemplate'),
(49, 'Can add operation actor template', 13, 'add_operationactortemplate'),
(50, 'Can change operation actor template', 13, 'change_operationactortemplate'),
(51, 'Can delete operation actor template', 13, 'delete_operationactortemplate'),
(52, 'Can view operation actor template', 13, 'view_operationactortemplate'),
(53, 'Can add career', 14, 'add_career'),
(54, 'Can change career', 14, 'change_career'),
(55, 'Can delete career', 14, 'delete_career'),
(56, 'Can view career', 14, 'view_career'),
(57, 'Can add academic period', 15, 'add_academicperiod'),
(58, 'Can change academic period', 15, 'change_academicperiod'),
(59, 'Can delete academic period', 15, 'delete_academicperiod'),
(60, 'Can view academic period', 15, 'view_academicperiod'),
(61, 'Can add sub process instance', 16, 'add_subprocessinstance'),
(62, 'Can change sub process instance', 16, 'change_subprocessinstance'),
(63, 'Can delete sub process instance', 16, 'delete_subprocessinstance'),
(64, 'Can view sub process instance', 16, 'view_subprocessinstance'),
(65, 'Can add operation instance', 17, 'add_operationinstance'),
(66, 'Can change operation instance', 17, 'change_operationinstance'),
(67, 'Can delete operation instance', 17, 'delete_operationinstance'),
(68, 'Can view operation instance', 17, 'view_operationinstance'),
(69, 'Can add operation assignment', 18, 'add_operationassignment'),
(70, 'Can change operation assignment', 18, 'change_operationassignment'),
(71, 'Can delete operation assignment', 18, 'delete_operationassignment'),
(72, 'Can view operation assignment', 18, 'view_operationassignment'),
(73, 'Can add document', 19, 'add_document'),
(74, 'Can change document', 19, 'change_document'),
(75, 'Can delete document', 19, 'delete_document'),
(76, 'Can view document', 19, 'view_document'),
(77, 'Can add notification', 20, 'add_notification'),
(78, 'Can change notification', 20, 'change_notification'),
(79, 'Can delete notification', 20, 'delete_notification'),
(80, 'Can view notification', 20, 'view_notification'),
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
-- Estructura de tabla para la tabla `django_admin_log`
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
-- Estructura de tabla para la tabla `django_content_type`
--

CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `django_content_type`
--

INSERT INTO `django_content_type` (`id`, `app_label`, `model`) VALUES
(1, 'admin', 'logentry'),
(3, 'auth', 'group'),
(2, 'auth', 'permission'),
(4, 'contenttypes', 'contenttype'),
(22, 'django_cron', 'cronjoblock'),
(21, 'django_cron', 'cronjoblog'),
(15, 'processes', 'academicperiod'),
(14, 'processes', 'career'),
(19, 'processes', 'document'),
(8, 'processes', 'macroprocess'),
(20, 'processes', 'notification'),
(13, 'processes', 'operationactortemplate'),
(18, 'processes', 'operationassignment'),
(17, 'processes', 'operationinstance'),
(12, 'processes', 'operationtemplate'),
(9, 'processes', 'process'),
(7, 'processes', 'processinstitution'),
(11, 'processes', 'storagetype'),
(16, 'processes', 'subprocessinstance'),
(10, 'processes', 'subprocesstemplate'),
(6, 'processes', 'user'),
(5, 'sessions', 'session');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `django_cron_cronjoblock`
--

CREATE TABLE `django_cron_cronjoblock` (
  `id` bigint(20) NOT NULL,
  `job_name` varchar(200) NOT NULL,
  `locked` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `django_cron_cronjoblog`
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
-- Estructura de tabla para la tabla `django_migrations`
--

CREATE TABLE `django_migrations` (
  `id` bigint(20) NOT NULL,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `django_migrations`
--

INSERT INTO `django_migrations` (`id`, `app`, `name`, `applied`) VALUES
(1, 'contenttypes', '0001_initial', '2025-07-21 21:59:16.635304'),
(2, 'contenttypes', '0002_remove_content_type_name', '2025-07-21 21:59:16.903286'),
(3, 'auth', '0001_initial', '2025-07-21 21:59:18.803163'),
(4, 'auth', '0002_alter_permission_name_max_length', '2025-07-21 21:59:19.033150'),
(5, 'auth', '0003_alter_user_email_max_length', '2025-07-21 21:59:19.053149'),
(6, 'auth', '0004_alter_user_username_opts', '2025-07-21 21:59:19.086146'),
(7, 'auth', '0005_alter_user_last_login_null', '2025-07-21 21:59:19.165141'),
(8, 'auth', '0006_require_contenttypes_0002', '2025-07-21 21:59:19.184139'),
(9, 'auth', '0007_alter_validators_add_error_messages', '2025-07-21 21:59:19.205137'),
(10, 'auth', '0008_alter_user_username_max_length', '2025-07-21 21:59:19.250136'),
(11, 'auth', '0009_alter_user_last_name_max_length', '2025-07-21 21:59:19.306132'),
(12, 'auth', '0010_alter_group_name_max_length', '2025-07-21 21:59:19.353129'),
(13, 'auth', '0011_update_proxy_permissions', '2025-07-21 21:59:19.407125'),
(14, 'auth', '0012_alter_user_first_name_max_length', '2025-07-21 21:59:19.455123'),
(15, 'processes', '0001_initial', '2025-07-21 21:59:25.479732'),
(16, 'admin', '0001_initial', '2025-07-21 21:59:26.374673'),
(17, 'admin', '0002_logentry_remove_auto_add', '2025-07-21 21:59:26.415670'),
(18, 'admin', '0003_logentry_add_action_flag_choices', '2025-07-21 21:59:26.483667'),
(19, 'sessions', '0001_initial', '2025-07-21 21:59:26.605656'),
(20, 'processes', '0002_storagetype_created_at_storagetype_updated_at_and_more', '2025-07-21 23:15:12.723936'),
(21, 'django_cron', '0001_initial', '2025-07-21 23:36:55.785520'),
(22, 'django_cron', '0002_remove_max_length_from_CronJobLog_message', '2025-07-21 23:36:55.802519'),
(23, 'django_cron', '0003_cronjoblock', '2025-07-21 23:36:56.036503'),
(24, 'django_cron', '0004_alter_cronjoblock_id_alter_cronjoblog_id', '2025-07-21 23:36:56.387482');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `django_session`
--

CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `processes_academicperiod`
--

CREATE TABLE `processes_academicperiod` (
  `id` bigint(20) NOT NULL,
  `code` varchar(20) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `processes_academicperiod`
--

INSERT INTO `processes_academicperiod` (`id`, `code`, `start_date`, `end_date`) VALUES
(1, '2025-1', '2025-05-01', '2025-09-30');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `processes_career`
--

CREATE TABLE `processes_career` (
  `id` bigint(20) NOT NULL,
  `name` varchar(120) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `processes_career`
--

INSERT INTO `processes_career` (`id`, `name`) VALUES
(1, 'Tecnología en Redes'),
(2, 'Contabilidad');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `processes_document`
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
-- Estructura de tabla para la tabla `processes_macroprocess`
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
-- Volcado de datos para la tabla `processes_macroprocess`
--

INSERT INTO `processes_macroprocess` (`id`, `created_at`, `updated_at`, `code_suffix`, `name`, `description`, `process_institution_id`) VALUES
(1, '2025-07-21 00:00:00.000000', '2025-07-21 00:00:00.000000', '001', 'Formación Profesional', '', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `processes_notification`
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
-- Estructura de tabla para la tabla `processes_operationactortemplate`
--

CREATE TABLE `processes_operationactortemplate` (
  `id` bigint(20) NOT NULL,
  `role` varchar(12) NOT NULL,
  `is_emitter` tinyint(1) NOT NULL,
  `is_receiver` tinyint(1) NOT NULL,
  `operation_template_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `processes_operationactortemplate`
--

INSERT INTO `processes_operationactortemplate` (`id`, `role`, `is_emitter`, `is_receiver`, `operation_template_id`) VALUES
(1, 'PARTICIPANT', 1, 0, 5),
(2, 'MANAGER', 0, 1, 5),
(3, 'PARTICIPANT', 1, 0, 1),
(4, 'MANAGER', 0, 1, 1),
(5, 'PARTICIPANT', 1, 0, 2),
(6, 'MANAGER', 0, 1, 2),
(7, 'PARTICIPANT', 1, 0, 3),
(8, 'MANAGER', 0, 1, 3),
(9, 'PARTICIPANT', 1, 0, 4),
(10, 'MANAGER', 0, 1, 4),
(11, 'PARTICIPANT', 1, 0, 5),
(12, 'MANAGER', 0, 1, 5),
(13, 'PARTICIPANT', 1, 0, 6),
(14, 'MANAGER', 0, 1, 6),
(15, 'PARTICIPANT', 1, 0, 7),
(16, 'MANAGER', 0, 1, 7),
(17, 'PARTICIPANT', 1, 0, 8),
(18, 'MANAGER', 0, 1, 8),
(19, 'PARTICIPANT', 1, 0, 9),
(20, 'MANAGER', 0, 1, 9),
(21, 'PARTICIPANT', 1, 0, 10),
(22, 'MANAGER', 0, 1, 10),
(23, 'PARTICIPANT', 1, 0, 11),
(24, 'MANAGER', 0, 1, 11),
(25, 'PARTICIPANT', 1, 0, 12),
(26, 'MANAGER', 0, 1, 12),
(27, 'PARTICIPANT', 1, 0, 13),
(28, 'MANAGER', 0, 1, 13),
(29, 'PARTICIPANT', 1, 0, 14),
(30, 'MANAGER', 0, 1, 14),
(31, 'PARTICIPANT', 1, 0, 15),
(32, 'MANAGER', 0, 1, 15),
(33, 'PARTICIPANT', 1, 0, 16),
(34, 'MANAGER', 0, 1, 16),
(35, 'PARTICIPANT', 1, 0, 17),
(36, 'MANAGER', 0, 1, 17);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `processes_operationassignment`
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
-- Estructura de tabla para la tabla `processes_operationinstance`
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
-- Estructura de tabla para la tabla `processes_operationtemplate`
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
-- Volcado de datos para la tabla `processes_operationtemplate`
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
-- Estructura de tabla para la tabla `processes_process`
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
-- Volcado de datos para la tabla `processes_process`
--

INSERT INTO `processes_process` (`id`, `created_at`, `updated_at`, `code_suffix`, `name`, `description`, `macro_process_id`, `manager_id`) VALUES
(1, '2025-07-21 00:00:00.000000', '2025-07-21 23:52:36.000000', '001', 'Prácticas Pre-Profesionales', '', 1, 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `processes_processinstitution`
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
-- Volcado de datos para la tabla `processes_processinstitution`
--

INSERT INTO `processes_processinstitution` (`id`, `created_at`, `updated_at`, `code`, `name`, `description`) VALUES
(1, '2025-07-21 00:00:00.000000', '2025-07-21 00:00:00.000000', '001', 'Procesos Académicos', '');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `processes_storagetype`
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
-- Volcado de datos para la tabla `processes_storagetype`
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
-- Estructura de tabla para la tabla `processes_subprocessinstance`
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
-- Estructura de tabla para la tabla `processes_subprocesstemplate`
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
-- Volcado de datos para la tabla `processes_subprocesstemplate`
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
-- Estructura de tabla para la tabla `processes_user`
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
-- Volcado de datos para la tabla `processes_user`
--

INSERT INTO `processes_user` (`id`, `password`, `last_login`, `is_superuser`, `username`, `first_name`, `last_name`, `email`, `is_staff`, `is_active`, `date_joined`, `id_number`, `role`) VALUES
(1, 'pbkdf2_sha256$600000$jfNlQ7ni2rE9PZAx7hn9BB$GmEWbjmbKb3ShBT+r6re1I3keXu+uN6x+KLWXR/ECd8=', NULL, 1, 'admin', '', '', 'admin@example.com', 1, 1, '2025-08-01 02:40:26.991319', '', ''),
(2, 'pbkdf2_sha256$600000$8WLe95jszHcT1qskNm3qkA$DIT+FFxaqsoxp89Ic8SPoV/M4/42zkillft15jmYRT8=', NULL, 0, 'gestor', '', '', '', 1, 1, '2025-08-01 02:42:53.962345', '0000000002', 'MANAGER');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `processes_user_groups`
--

CREATE TABLE `processes_user_groups` (
  `id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `group_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `processes_user_user_permissions`
--

CREATE TABLE `processes_user_user_permissions` (
  `id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `auth_group`
--
ALTER TABLE `auth_group`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indices de la tabla `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  ADD KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`);

--
-- Indices de la tabla `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`);

--
-- Indices de la tabla `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  ADD KEY `django_admin_log_user_id_c564eba6_fk_processes_user_id` (`user_id`);

--
-- Indices de la tabla `django_content_type`
--
ALTER TABLE `django_content_type`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`);

--
-- Indices de la tabla `django_cron_cronjoblock`
--
ALTER TABLE `django_cron_cronjoblock`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `job_name` (`job_name`);

--
-- Indices de la tabla `django_cron_cronjoblog`
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
-- Indices de la tabla `django_migrations`
--
ALTER TABLE `django_migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `django_session`
--
ALTER TABLE `django_session`
  ADD PRIMARY KEY (`session_key`),
  ADD KEY `django_session_expire_date_a5c62663` (`expire_date`);

--
-- Indices de la tabla `processes_academicperiod`
--
ALTER TABLE `processes_academicperiod`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `processes_career`
--
ALTER TABLE `processes_career`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `processes_document`
--
ALTER TABLE `processes_document`
  ADD PRIMARY KEY (`id`),
  ADD KEY `processes_document_approved_by_id_146756a0_fk_processes_user_id` (`approved_by_id`),
  ADD KEY `processes_document_operation_instance_i_ec737c85_fk_processes` (`operation_instance_id`),
  ADD KEY `processes_document_replaced_document_id_bcdbc3be_fk_processes` (`replaced_document_id`),
  ADD KEY `processes_document_storage_type_id_3835a552_fk_processes` (`storage_type_id`),
  ADD KEY `processes_document_uploaded_by_id_094b865f_fk_processes_user_id` (`uploaded_by_id`);

--
-- Indices de la tabla `processes_macroprocess`
--
ALTER TABLE `processes_macroprocess`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `processes_macroprocess_process_institution_id_c_ea6075e0_uniq` (`process_institution_id`,`code_suffix`);

--
-- Indices de la tabla `processes_notification`
--
ALTER TABLE `processes_notification`
  ADD PRIMARY KEY (`id`),
  ADD KEY `processes_notificati_related_assignment_i_db013a3d_fk_processes` (`related_assignment_id`),
  ADD KEY `processes_notification_user_id_0f3589f1_fk_processes_user_id` (`user_id`);

--
-- Indices de la tabla `processes_operationactortemplate`
--
ALTER TABLE `processes_operationactortemplate`
  ADD PRIMARY KEY (`id`),
  ADD KEY `processes_operationa_operation_template_i_bea3709b_fk_processes` (`operation_template_id`);

--
-- Indices de la tabla `processes_operationassignment`
--
ALTER TABLE `processes_operationassignment`
  ADD PRIMARY KEY (`id`),
  ADD KEY `processes_operationa_operation_instance_i_7aa4ca50_fk_processes` (`operation_instance_id`),
  ADD KEY `processes_operationa_user_id_695b23d8_fk_processes` (`user_id`);

--
-- Indices de la tabla `processes_operationinstance`
--
ALTER TABLE `processes_operationinstance`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `processes_operationinsta_subprocess_instance_id_o_c63f6df2_uniq` (`subprocess_instance_id`,`order`),
  ADD KEY `processes_operationi_operation_template_i_94c8ec47_fk_processes` (`operation_template_id`);

--
-- Indices de la tabla `processes_operationtemplate`
--
ALTER TABLE `processes_operationtemplate`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `processes_operationtempl_subprocess_template_id_o_8d598609_uniq` (`subprocess_template_id`,`order`),
  ADD KEY `processes_operationt_storage_type_id_27c9d22f_fk_processes` (`storage_type_id`);

--
-- Indices de la tabla `processes_process`
--
ALTER TABLE `processes_process`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `processes_process_macro_process_id_code_suffix_81bd8ca3_uniq` (`macro_process_id`,`code_suffix`),
  ADD KEY `processes_process_manager_id_4e3d3898_fk_processes_user_id` (`manager_id`);

--
-- Indices de la tabla `processes_processinstitution`
--
ALTER TABLE `processes_processinstitution`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`);

--
-- Indices de la tabla `processes_storagetype`
--
ALTER TABLE `processes_storagetype`
  ADD PRIMARY KEY (`id`),
  ADD KEY `processes_storagetyp_subprocess_template__f56855ca_fk_processes` (`subprocess_template_id`);

--
-- Indices de la tabla `processes_subprocessinstance`
--
ALTER TABLE `processes_subprocessinstance`
  ADD PRIMARY KEY (`id`),
  ADD KEY `processes_subprocess_career_id_e17d63e1_fk_processes` (`career_id`),
  ADD KEY `processes_subprocess_period_id_28a25288_fk_processes` (`period_id`),
  ADD KEY `processes_subprocess_template_id_add9fb5e_fk_processes` (`template_id`);

--
-- Indices de la tabla `processes_subprocesstemplate`
--
ALTER TABLE `processes_subprocesstemplate`
  ADD PRIMARY KEY (`id`),
  ADD KEY `processes_subprocess_created_by_id_009e10ca_fk_processes` (`created_by_id`),
  ADD KEY `processes_subprocess_process_id_e61a64fa_fk_processes` (`process_id`);

--
-- Indices de la tabla `processes_user`
--
ALTER TABLE `processes_user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `id_number` (`id_number`);

--
-- Indices de la tabla `processes_user_groups`
--
ALTER TABLE `processes_user_groups`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `processes_user_groups_user_id_group_id_35072031_uniq` (`user_id`,`group_id`),
  ADD KEY `processes_user_groups_group_id_7910d88f_fk_auth_group_id` (`group_id`);

--
-- Indices de la tabla `processes_user_user_permissions`
--
ALTER TABLE `processes_user_user_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `processes_user_user_perm_user_id_permission_id_0f024bfd_uniq` (`user_id`,`permission_id`),
  ADD KEY `processes_user_user__permission_id_ab54a076_fk_auth_perm` (`permission_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `auth_group`
--
ALTER TABLE `auth_group`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `auth_permission`
--
ALTER TABLE `auth_permission`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=89;

--
-- AUTO_INCREMENT de la tabla `django_admin_log`
--
ALTER TABLE `django_admin_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `django_content_type`
--
ALTER TABLE `django_content_type`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT de la tabla `django_cron_cronjoblock`
--
ALTER TABLE `django_cron_cronjoblock`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `django_cron_cronjoblog`
--
ALTER TABLE `django_cron_cronjoblog`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `django_migrations`
--
ALTER TABLE `django_migrations`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT de la tabla `processes_academicperiod`
--
ALTER TABLE `processes_academicperiod`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `processes_career`
--
ALTER TABLE `processes_career`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `processes_document`
--
ALTER TABLE `processes_document`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `processes_macroprocess`
--
ALTER TABLE `processes_macroprocess`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `processes_notification`
--
ALTER TABLE `processes_notification`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `processes_operationactortemplate`
--
ALTER TABLE `processes_operationactortemplate`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT de la tabla `processes_operationassignment`
--
ALTER TABLE `processes_operationassignment`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `processes_operationinstance`
--
ALTER TABLE `processes_operationinstance`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `processes_operationtemplate`
--
ALTER TABLE `processes_operationtemplate`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT de la tabla `processes_process`
--
ALTER TABLE `processes_process`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `processes_processinstitution`
--
ALTER TABLE `processes_processinstitution`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `processes_storagetype`
--
ALTER TABLE `processes_storagetype`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `processes_subprocessinstance`
--
ALTER TABLE `processes_subprocessinstance`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `processes_subprocesstemplate`
--
ALTER TABLE `processes_subprocesstemplate`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `processes_user`
--
ALTER TABLE `processes_user`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `processes_user_groups`
--
ALTER TABLE `processes_user_groups`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `processes_user_user_permissions`
--
ALTER TABLE `processes_user_user_permissions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`);

--
-- Filtros para la tabla `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`);

--
-- Filtros para la tabla `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  ADD CONSTRAINT `django_admin_log_user_id_c564eba6_fk_processes_user_id` FOREIGN KEY (`user_id`) REFERENCES `processes_user` (`id`);

--
-- Filtros para la tabla `processes_document`
--
ALTER TABLE `processes_document`
  ADD CONSTRAINT `processes_document_approved_by_id_146756a0_fk_processes_user_id` FOREIGN KEY (`approved_by_id`) REFERENCES `processes_user` (`id`),
  ADD CONSTRAINT `processes_document_operation_instance_i_ec737c85_fk_processes` FOREIGN KEY (`operation_instance_id`) REFERENCES `processes_operationinstance` (`id`),
  ADD CONSTRAINT `processes_document_replaced_document_id_bcdbc3be_fk_processes` FOREIGN KEY (`replaced_document_id`) REFERENCES `processes_document` (`id`),
  ADD CONSTRAINT `processes_document_storage_type_id_3835a552_fk_processes` FOREIGN KEY (`storage_type_id`) REFERENCES `processes_storagetype` (`id`),
  ADD CONSTRAINT `processes_document_uploaded_by_id_094b865f_fk_processes_user_id` FOREIGN KEY (`uploaded_by_id`) REFERENCES `processes_user` (`id`);

--
-- Filtros para la tabla `processes_macroprocess`
--
ALTER TABLE `processes_macroprocess`
  ADD CONSTRAINT `processes_macroproce_process_institution__46ba1e36_fk_processes` FOREIGN KEY (`process_institution_id`) REFERENCES `processes_processinstitution` (`id`);

--
-- Filtros para la tabla `processes_notification`
--
ALTER TABLE `processes_notification`
  ADD CONSTRAINT `processes_notificati_related_assignment_i_db013a3d_fk_processes` FOREIGN KEY (`related_assignment_id`) REFERENCES `processes_operationassignment` (`id`),
  ADD CONSTRAINT `processes_notification_user_id_0f3589f1_fk_processes_user_id` FOREIGN KEY (`user_id`) REFERENCES `processes_user` (`id`);

--
-- Filtros para la tabla `processes_operationactortemplate`
--
ALTER TABLE `processes_operationactortemplate`
  ADD CONSTRAINT `processes_operationa_operation_template_i_bea3709b_fk_processes` FOREIGN KEY (`operation_template_id`) REFERENCES `processes_operationtemplate` (`id`);

--
-- Filtros para la tabla `processes_operationassignment`
--
ALTER TABLE `processes_operationassignment`
  ADD CONSTRAINT `processes_operationa_operation_instance_i_7aa4ca50_fk_processes` FOREIGN KEY (`operation_instance_id`) REFERENCES `processes_operationinstance` (`id`),
  ADD CONSTRAINT `processes_operationa_user_id_695b23d8_fk_processes` FOREIGN KEY (`user_id`) REFERENCES `processes_user` (`id`);

--
-- Filtros para la tabla `processes_operationinstance`
--
ALTER TABLE `processes_operationinstance`
  ADD CONSTRAINT `processes_operationi_operation_template_i_94c8ec47_fk_processes` FOREIGN KEY (`operation_template_id`) REFERENCES `processes_operationtemplate` (`id`),
  ADD CONSTRAINT `processes_operationi_subprocess_instance__ee748c78_fk_processes` FOREIGN KEY (`subprocess_instance_id`) REFERENCES `processes_subprocessinstance` (`id`);

--
-- Filtros para la tabla `processes_operationtemplate`
--
ALTER TABLE `processes_operationtemplate`
  ADD CONSTRAINT `processes_operationt_storage_type_id_27c9d22f_fk_processes` FOREIGN KEY (`storage_type_id`) REFERENCES `processes_storagetype` (`id`),
  ADD CONSTRAINT `processes_operationt_subprocess_template__8a2501b6_fk_processes` FOREIGN KEY (`subprocess_template_id`) REFERENCES `processes_subprocesstemplate` (`id`);

--
-- Filtros para la tabla `processes_process`
--
ALTER TABLE `processes_process`
  ADD CONSTRAINT `processes_process_macro_process_id_9223327e_fk_processes` FOREIGN KEY (`macro_process_id`) REFERENCES `processes_macroprocess` (`id`),
  ADD CONSTRAINT `processes_process_manager_id_4e3d3898_fk_processes_user_id` FOREIGN KEY (`manager_id`) REFERENCES `processes_user` (`id`);

--
-- Filtros para la tabla `processes_storagetype`
--
ALTER TABLE `processes_storagetype`
  ADD CONSTRAINT `processes_storagetyp_subprocess_template__f56855ca_fk_processes` FOREIGN KEY (`subprocess_template_id`) REFERENCES `processes_subprocesstemplate` (`id`);

--
-- Filtros para la tabla `processes_subprocessinstance`
--
ALTER TABLE `processes_subprocessinstance`
  ADD CONSTRAINT `processes_subprocess_career_id_e17d63e1_fk_processes` FOREIGN KEY (`career_id`) REFERENCES `processes_career` (`id`),
  ADD CONSTRAINT `processes_subprocess_period_id_28a25288_fk_processes` FOREIGN KEY (`period_id`) REFERENCES `processes_academicperiod` (`id`),
  ADD CONSTRAINT `processes_subprocess_template_id_add9fb5e_fk_processes` FOREIGN KEY (`template_id`) REFERENCES `processes_subprocesstemplate` (`id`);

--
-- Filtros para la tabla `processes_subprocesstemplate`
--
ALTER TABLE `processes_subprocesstemplate`
  ADD CONSTRAINT `processes_subprocess_created_by_id_009e10ca_fk_processes` FOREIGN KEY (`created_by_id`) REFERENCES `processes_user` (`id`),
  ADD CONSTRAINT `processes_subprocess_process_id_e61a64fa_fk_processes` FOREIGN KEY (`process_id`) REFERENCES `processes_process` (`id`);

--
-- Filtros para la tabla `processes_user_groups`
--
ALTER TABLE `processes_user_groups`
  ADD CONSTRAINT `processes_user_groups_group_id_7910d88f_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  ADD CONSTRAINT `processes_user_groups_user_id_a2fd1e0b_fk_processes_user_id` FOREIGN KEY (`user_id`) REFERENCES `processes_user` (`id`);

--
-- Filtros para la tabla `processes_user_user_permissions`
--
ALTER TABLE `processes_user_user_permissions`
  ADD CONSTRAINT `processes_user_user__permission_id_ab54a076_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `processes_user_user__user_id_fe4d94a9_fk_processes` FOREIGN KEY (`user_id`) REFERENCES `processes_user` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
