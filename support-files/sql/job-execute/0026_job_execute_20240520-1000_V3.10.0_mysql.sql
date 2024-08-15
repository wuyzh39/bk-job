USE job_execute;

SET NAMES utf8mb4;

DROP PROCEDURE IF EXISTS job_schema_update;

DELIMITER <JOB_UBF>

CREATE PROCEDURE job_schema_update()
BEGIN

  DECLARE db VARCHAR(100);
  SET AUTOCOMMIT = 0;
  SELECT DATABASE() INTO db;

  -- task_instance 
  IF NOT EXISTS(SELECT 1
                FROM information_schema.statistics
                WHERE TABLE_SCHEMA = db
                  AND TABLE_NAME = 'task_instance'
                  AND INDEX_NAME = 'idx_create_time_id') THEN
      ALTER TABLE task_instance ADD INDEX `idx_create_time_id` (`create_time`,`id`);
  END IF;
  IF EXISTS(SELECT 1
                FROM information_schema.statistics
                WHERE TABLE_SCHEMA = db
                  AND TABLE_NAME = 'task_instance'
                  AND INDEX_NAME = 'idx_create_time') THEN
      ALTER TABLE task_instance DROP INDEX `idx_create_time`;
  END IF;

  -- step_instance
  IF NOT EXISTS(SELECT 1
                FROM information_schema.statistics
                WHERE TABLE_SCHEMA = db
                  AND TABLE_NAME = 'step_instance'
                  AND INDEX_NAME = 'idx_task_instance_id_id') THEN
      ALTER TABLE step_instance ADD INDEX `idx_task_instance_id_id` (`task_instance_id`,`id`);
  END IF;
  IF EXISTS(SELECT 1
                FROM information_schema.statistics
                WHERE TABLE_SCHEMA = db
                  AND TABLE_NAME = 'step_instance'
                  AND INDEX_NAME = 'idx_task_instance_id') THEN
      ALTER TABLE step_instance DROP INDEX `idx_task_instance_id`;
  END IF;

  -- step_instance_script
  IF NOT EXISTS(SELECT 1
                  FROM information_schema.COLUMNS
                  WHERE TABLE_SCHEMA = db
                    AND TABLE_NAME = 'step_instance_script'
                    AND COLUMN_NAME = 'task_instance_id') THEN
    ALTER TABLE step_instance_script ADD COLUMN `task_instance_id` bigint(20) NOT NULL DEFAULT '0';
  END IF;
  IF NOT EXISTS(SELECT 1
                FROM information_schema.statistics
                WHERE TABLE_SCHEMA = db
                  AND TABLE_NAME = 'step_instance_script'
                  AND INDEX_NAME = 'idx_task_instance_id_step_instance_id') THEN
      ALTER TABLE step_instance_script ADD INDEX `idx_task_instance_id_step_instance_id` (`task_instance_id`,`step_instance_id`);
  END IF;

  -- step_instance_file
  IF NOT EXISTS(SELECT 1
                  FROM information_schema.COLUMNS
                  WHERE TABLE_SCHEMA = db
                    AND TABLE_NAME = 'step_instance_file'
                    AND COLUMN_NAME = 'task_instance_id') THEN
    ALTER TABLE step_instance_file ADD COLUMN `task_instance_id` bigint(20) NOT NULL DEFAULT '0';
  END IF;
  IF NOT EXISTS(SELECT 1
                FROM information_schema.statistics
                WHERE TABLE_SCHEMA = db
                  AND TABLE_NAME = 'step_instance_file'
                  AND INDEX_NAME = 'idx_task_instance_id_step_instance_id') THEN
      ALTER TABLE step_instance_file ADD INDEX `idx_task_instance_id_step_instance_id` (`task_instance_id`,`step_instance_id`);
  END IF;

  -- step_instance_confirm
  IF NOT EXISTS(SELECT 1
                  FROM information_schema.COLUMNS
                  WHERE TABLE_SCHEMA = db
                    AND TABLE_NAME = 'step_instance_confirm'
                    AND COLUMN_NAME = 'task_instance_id') THEN
    ALTER TABLE step_instance_confirm ADD COLUMN `task_instance_id` bigint(20) NOT NULL DEFAULT '0';
  END IF;
  IF NOT EXISTS(SELECT 1
                FROM information_schema.statistics
                WHERE TABLE_SCHEMA = db
                  AND TABLE_NAME = 'step_instance_confirm'
                  AND INDEX_NAME = 'idx_task_instance_id_step_instance_id') THEN
      ALTER TABLE step_instance_confirm ADD INDEX `idx_task_instance_id_step_instance_id` (`task_instance_id`,`step_instance_id`);
  END IF;

  -- gse_task
  IF NOT EXISTS(SELECT 1
                  FROM information_schema.COLUMNS
                  WHERE TABLE_SCHEMA = db
                    AND TABLE_NAME = 'gse_task'
                    AND COLUMN_NAME = 'task_instance_id') THEN
    ALTER TABLE gse_task ADD COLUMN `task_instance_id` bigint(20) NOT NULL DEFAULT '0';
  END IF;
  IF NOT EXISTS(SELECT 1
                FROM information_schema.statistics
                WHERE TABLE_SCHEMA = db
                  AND TABLE_NAME = 'gse_task'
                  AND INDEX_NAME = 'idx_task_instance_id_id') THEN
      ALTER TABLE gse_task ADD INDEX `idx_task_instance_id_id` (`task_instance_id`,`id`);
  END IF;

  -- gse_script_agent_task
  IF NOT EXISTS(SELECT 1
                  FROM information_schema.COLUMNS
                  WHERE TABLE_SCHEMA = db
                    AND TABLE_NAME = 'gse_script_agent_task'
                    AND COLUMN_NAME = 'task_instance_id') THEN
    ALTER TABLE gse_script_agent_task ADD COLUMN `task_instance_id` bigint(20) NOT NULL DEFAULT '0';
  END IF;
  IF NOT EXISTS(SELECT 1
                FROM information_schema.statistics
                WHERE TABLE_SCHEMA = db
                  AND TABLE_NAME = 'gse_script_agent_task'
                  AND INDEX_NAME = 'idx_task_instance_id_id') THEN
      ALTER TABLE gse_script_agent_task ADD INDEX `idx_task_instance_id_id` (`task_instance_id`,`id`);
  END IF;

  -- gse_file_agent_task
  IF NOT EXISTS(SELECT 1
                  FROM information_schema.COLUMNS
                  WHERE TABLE_SCHEMA = db
                    AND TABLE_NAME = 'gse_file_agent_task'
                    AND COLUMN_NAME = 'task_instance_id') THEN
    ALTER TABLE gse_file_agent_task ADD COLUMN `task_instance_id` bigint(20) NOT NULL DEFAULT '0';
  END IF;
  IF NOT EXISTS(SELECT 1
                FROM information_schema.statistics
                WHERE TABLE_SCHEMA = db
                  AND TABLE_NAME = 'gse_file_agent_task'
                  AND INDEX_NAME = 'idx_task_instance_id_id') THEN
      ALTER TABLE gse_file_agent_task ADD INDEX `idx_task_instance_id_id` (`task_instance_id`,`id`);
  END IF;

  -- gse_script_execute_obj_task 
  IF NOT EXISTS(SELECT 1
                FROM information_schema.statistics
                WHERE TABLE_SCHEMA = db
                  AND TABLE_NAME = 'gse_script_execute_obj_task'
                  AND INDEX_NAME = 'idx_task_instance_id_id') THEN
      ALTER TABLE gse_script_execute_obj_task ADD INDEX `idx_task_instance_id_id` (`task_instance_id`,`id`);
  END IF;
  IF EXISTS(SELECT 1
                FROM information_schema.statistics
                WHERE TABLE_SCHEMA = db
                  AND TABLE_NAME = 'gse_script_execute_obj_task'
                  AND INDEX_NAME = 'idx_task_instance_id') THEN
      ALTER TABLE gse_script_execute_obj_task DROP INDEX `idx_task_instance_id`;
  END IF;

  -- gse_file_execute_obj_task 
  IF NOT EXISTS(SELECT 1
                FROM information_schema.statistics
                WHERE TABLE_SCHEMA = db
                  AND TABLE_NAME = 'gse_file_execute_obj_task'
                  AND INDEX_NAME = 'idx_task_instance_id_id') THEN
      ALTER TABLE gse_file_execute_obj_task ADD INDEX `idx_task_instance_id_id` (`task_instance_id`,`id`);
  END IF;
  IF EXISTS(SELECT 1
                FROM information_schema.statistics
                WHERE TABLE_SCHEMA = db
                  AND TABLE_NAME = 'gse_file_execute_obj_task'
                  AND INDEX_NAME = 'idx_task_instance_id') THEN
      ALTER TABLE gse_file_execute_obj_task DROP INDEX `idx_task_instance_id`;
  END IF;

  -- file_source_task_log
  IF NOT EXISTS(SELECT 1
                  FROM information_schema.COLUMNS
                  WHERE TABLE_SCHEMA = db
                    AND TABLE_NAME = 'file_source_task_log'
                    AND COLUMN_NAME = 'task_instance_id') THEN
    ALTER TABLE file_source_task_log ADD COLUMN `task_instance_id` bigint(20) NOT NULL DEFAULT '0';
  END IF;
  IF NOT EXISTS(SELECT 1
                FROM information_schema.statistics
                WHERE TABLE_SCHEMA = db
                  AND TABLE_NAME = 'file_source_task_log'
                  AND INDEX_NAME = 'idx_task_instance_id_id') THEN
      ALTER TABLE file_source_task_log ADD INDEX `idx_task_instance_id_id` (`task_instance_id`,`id`);
  END IF;

  -- rolling_config
  IF NOT EXISTS(SELECT 1
                FROM information_schema.statistics
                WHERE TABLE_SCHEMA = db
                  AND TABLE_NAME = 'operation_log'
                  AND INDEX_NAME = 'idx_task_instance_id_id') THEN
      ALTER TABLE rolling_config ADD INDEX `idx_task_instance_id_id` (`task_instance_id`,`id`);
  END IF;
  
  -- step_instance_rolling_task
  IF NOT EXISTS(SELECT 1
                  FROM information_schema.COLUMNS
                  WHERE TABLE_SCHEMA = db
                    AND TABLE_NAME = 'step_instance_rolling_task'
                    AND COLUMN_NAME = 'task_instance_id') THEN
    ALTER TABLE step_instance_rolling_task ADD COLUMN `task_instance_id` bigint(20) NOT NULL DEFAULT '0';
  END IF;
  IF NOT EXISTS(SELECT 1
                FROM information_schema.statistics
                WHERE TABLE_SCHEMA = db
                  AND TABLE_NAME = 'step_instance_rolling_task'
                  AND INDEX_NAME = 'idx_task_instance_id_id') THEN
      ALTER TABLE step_instance_rolling_task ADD INDEX `idx_task_instance_id_id` (`task_instance_id`,`id`);
  END IF;

  -- operation_log
  IF NOT EXISTS(SELECT 1
                FROM information_schema.statistics
                WHERE TABLE_SCHEMA = db
                  AND TABLE_NAME = 'operation_log'
                  AND INDEX_NAME = 'idx_task_instance_id_id') THEN
      ALTER TABLE operation_log ADD INDEX `idx_task_instance_id_id` (`task_instance_id`,`id`);
  END IF;
  IF EXISTS(SELECT 1
                FROM information_schema.statistics
                WHERE TABLE_SCHEMA = db
                  AND TABLE_NAME = 'operation_log'
                  AND INDEX_NAME = 'idx_task_instance_id') THEN
      ALTER TABLE operation_log DROP INDEX `idx_task_instance_id`;
  END IF;

  -- task_instance_variable
  IF NOT EXISTS(SELECT 1
                FROM information_schema.statistics
                WHERE TABLE_SCHEMA = db
                  AND TABLE_NAME = 'task_instance_variable'
                  AND INDEX_NAME = 'idx_task_instance_id_id') THEN
      ALTER TABLE task_instance_variable ADD INDEX `idx_task_instance_id_id` (`task_instance_id`,`id`);
  END IF;
  IF EXISTS(SELECT 1
                FROM information_schema.statistics
                WHERE TABLE_SCHEMA = db
                  AND TABLE_NAME = 'task_instance_variable'
                  AND INDEX_NAME = 'idx_task_instance_id') THEN
      ALTER TABLE task_instance_variable DROP INDEX `idx_task_instance_id`;
  END IF;

  -- step_instance_variable
  IF NOT EXISTS(SELECT 1
                FROM information_schema.statistics
                WHERE TABLE_SCHEMA = db
                  AND TABLE_NAME = 'step_instance_variable'
                  AND INDEX_NAME = 'idx_task_instance_id_id') THEN
      ALTER TABLE step_instance_variable ADD INDEX `idx_task_instance_id_id` (`task_instance_id`,`id`);
  END IF;
  IF EXISTS(SELECT 1
                FROM information_schema.statistics
                WHERE TABLE_SCHEMA = db
                  AND TABLE_NAME = 'step_instance_variable'
                  AND INDEX_NAME = 'idx_task_instance_id') THEN
      ALTER TABLE step_instance_variable DROP INDEX `idx_task_instance_id`;
  END IF;

  COMMIT;
END <JOB_UBF>
DELIMITER ;
COMMIT;

CALL job_schema_update();

DROP PROCEDURE IF EXISTS job_schema_update;