DELIMITER $$

CREATE DEFINER=`ttsuser`@`%` PROCEDURE `init_ttsdb`()
 BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE t_name VARCHAR(50) DEFAULT NULL;
    DECLARE cur CURSOR FOR SELECT CONCAT(TABLE_SCHEMA,'.',TABLE_NAME) FROM information_schema.TABLES WHERE TABLE_SCHEMA IN ('tts','tts_gn1','policydb_1','rtpolicydb_1','qmq_produce') AND TABLE_NAME NOT IN ('client_shard','policy_db_info','client_information','qss_client_information','menu','permissions','sys_user');
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    OPEN cur;
    REPEAT
      FETCH cur INTO t_name;
      SET @t_name = CONCAT('delete from ',t_name);
      IF NOT done THEN
        PREPARE stmt FROM @t_name;
        EXECUTE stmt;
      END IF;
    UNTIL done END REPEAT;
    CLOSE cur;
  END$$

DELIMITER ;