-- create database
CREATE DATABASE lifelens;

USE lifelens;

-- create tables
CREATE TABLE `result` (
    `id_result` INTEGER  AUTO_INCREMENT UNIQUE,
    `Inhibitory_control` FLOAT,
    `executive_functioning` FLOAT,
    `working_memory` FLOAT,
    `cognitive_flexibility` FLOAT,
    `planning` FLOAT,
    `strategic_learning` FLOAT,
    `processing_speed` FLOAT,
    `comprehensive_outcome` FLOAT,  -- resultado integral 
    
    -- `behavioral_interview` FLOAT,  
    -- `assessment_center` FLOAT,
    PRIMARY KEY (`id_result`)
);

CREATE TABLE `gonogo` (
    `id_gonogo` INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
    `hw_time_1` FLOAT ,
    `hw_answer_1` FLOAT ,
    `hw_score_1` FLOAT,
    `hw_time_2` FLOAT,
    `hw_answer_2` FLOAT,
    `hw_score_2` FLOAT,
    `hw_time_3` FLOAT,
    `hw_answer_3` FLOAT,
    `hw_score_3` FLOAT,
    `Interference` FLOAT,
    `total_homewor` FLOAT,
    `total_gonogo_answer` Float,
    `total_gonogo` FLOAT,
    `climb` varchar(50),
    PRIMARY KEY (`id_gonogo`)
);

CREATE TABLE `t_hanoi` (
    `id_t_hanoi` INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
    `number_pieces` INTEGER,
    `number_pieces_r_side` INTEGER,
    `motion_rating` FLOAT,
    `time` FLOAT,
    `motion_rating2` FLOAT,
    `total_hanoi` FLOAT,
    PRIMARY KEY (`id_t_hanoi`)
);

CREATE TABLE `stroop` (
    `id_stroop` INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
    `p` FLOAT,
    `c` FLOAT,
    `pc` FLOAT,
    `P_C` FLOAT,
    `Interference` FLOAT,
    `time` FLOAT,
    `time_homework_p` FLOAT,
    `time_homework_c` FLOAT,
    `time_homework_pc` FLOAT,
    `total_stroop` FLOAT,
    `climb` VARCHAR(50),
    PRIMARY KEY (`id_stroop`)
);

CREATE TABLE `trail_making` (
    `id_trail_making` INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
    `total_trail_making` FLOAT,
    `correct_answers_A` INTEGER,
    `time_A` FLOAT,
    `score_A` FLOAT,
    `correct_answers_B` INTEGER,
    `time_B` FLOAT,
    `score_B` FLOAT,
    `total_correct_answers` FLOAT,
    PRIMARY KEY (`id_trail_making`)
);

CREATE TABLE `user` (
    `id_user` INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
    `name` VARCHAR(50) NOT NULL,
    `name2` VARCHAR(50),
    `last_name` VARCHAR(50) NOT NULL,
    `last_name2` VARCHAR(50),
    `document` VARCHAR(50) NOT NULL UNIQUE,
    `city` VARCHAR(50),
    `clan` VARCHAR(50) NOT NULL,
    `topy` VARCHAR(50),
    `status` BOOLEAN,
    `id_gonogo` INTEGER,
    `id_t_hanoi` INTEGER,
    `id_stroop` INTEGER,
    `id_trail_making` INTEGER,
    `id_result` INTEGER,
    PRIMARY KEY (`id_user`),
    
    CONSTRAINT `fk_users_gonogo`
        FOREIGN KEY (`id_gonogo`) REFERENCES `gonogo`(`id_gonogo`)
        ON UPDATE CASCADE ON DELETE RESTRICT,
        
    CONSTRAINT `fk_users_t_hanoi`
        FOREIGN KEY (`id_t_hanoi`) REFERENCES `T_hanoi`(`id_t_hanoi`)
        ON UPDATE CASCADE ON DELETE RESTRICT,
        
    CONSTRAINT `fk_users_stroop`
        FOREIGN KEY (`id_stroop`) REFERENCES `stroop`(`id_stroop`)
        ON UPDATE CASCADE ON DELETE RESTRICT,
        
    CONSTRAINT `fk_users_trail`
        FOREIGN KEY (`id_trail_making`) REFERENCES `trail_making`(`id_trail_making`)
        ON UPDATE CASCADE ON DELETE RESTRICT,
        
    CONSTRAINT `fk_user_result`
        FOREIGN KEY (`id_result`) REFERENCES `result`(`id_result`)
        ON UPDATE CASCADE ON DELETE RESTRICT
);




-- crear add_user_pack --> create user with foreign keys

DELIMITER $$
CREATE PROCEDURE add_user_pack(
    IN p_name       VARCHAR(50),
    IN p_name2      VARCHAR(50),      -- nuevo
    IN p_last_name  VARCHAR(50),
    IN p_last_name2 VARCHAR(50),      -- nuevo
    IN p_document   VARCHAR(50),
    IN p_city       VARCHAR(50),
    IN p_clan       VARCHAR(50),
    IN p_topy       VARCHAR(50)
)
BEGIN
    DECLARE v_g  INT;
    DECLARE v_s  INT;
    DECLARE v_h  INT;
    DECLARE v_t  INT;
    DECLARE v_r  INT;

    INSERT INTO gonogo        () VALUES (); SET v_g = LAST_INSERT_ID();
    INSERT INTO stroop        () VALUES (); SET v_s = LAST_INSERT_ID();
    INSERT INTO t_hanoi       () VALUES (); SET v_h = LAST_INSERT_ID();
    INSERT INTO trail_making  () VALUES (); SET v_t = LAST_INSERT_ID();
    INSERT INTO result        () VALUES (); SET v_r = LAST_INSERT_ID();

    INSERT INTO user
        (name, name2, last_name, last_name2, document, city, clan, topy,
         id_gonogo, id_stroop, id_t_hanoi, id_trail_making, id_result)
    VALUES
        (p_name, p_name2, p_last_name, p_last_name2, p_document, p_city, p_clan, p_topy,
         v_g, v_s, v_h, v_t, v_r);
END $$
DELIMITER ;