CREATE TABLE `results` (
    `id_result` INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
    `Inhibitory_control` FLOAT,
    `executive_functioning` FLOAT,
    `working_memory` FLOAT,
    `cognitive_flexibility` FLOAT,
    `planning` FLOAT,
    `strategic_learning` FLOAT,
    `processing_speed` FLOAT,
    `behavioral_interview` FLOAT,   -- quité el espacio
    `comprehensive_outcome` FLOAT,
    `assessment_center` FLOAT,
    PRIMARY KEY (`id_result`)
);

CREATE TABLE `gonogo` (
    `id_gonogo` INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
    `hw_time_1` FLOAT NOT NULL,
    `hw_answer_1` FLOAT NOT NULL,
    `hw_score_1` FLOAT NOT NULL,
    `hw_time_2` FLOAT NOT NULL,
    `hw_answer_2` FLOAT NOT NULL,
    `hw_score_2` FLOAT NOT NULL,
    `hw_time_3` FLOAT NOT NULL,
    `hw_answer_3` FLOAT NOT NULL,
    `hw_score_3` FLOAT NOT NULL,
    `PC` FLOAT NOT NULL,
    `time` FLOAT NOT NULL,
    `time_homework_p` FLOAT NOT NULL,
    `time_homework_c` FLOAT NOT NULL,
    `time_homework_pc` FLOAT NOT NULL,
    `total_homewor` FLOAT NOT NULL,
    `total_gonogo` FLOAT NOT NULL,
    `climb` FLOAT NOT NULL,
    PRIMARY KEY (`id_gonogo`)
);

CREATE TABLE `T_hanoi` (
    `id_hanoi` INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
    `number_pieces` INTEGER NOT NULL,
    `number_pieces_r_side` INTEGER NOT NULL,
    `motion_rating` FLOAT NOT NULL,
    `time` FLOAT NOT NULL,
    `motion_rating2` FLOAT NOT NULL,
    `total_hanoi` FLOAT NOT NULL,
    PRIMARY KEY (`id_hanoi`)
);

CREATE TABLE `stroop` (
    `id_stroop` INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
    `p` FLOAT NOT NULL,
    `c` FLOAT NOT NULL,
    `pc` FLOAT NOT NULL,
    `P_C` FLOAT NOT NULL,
    `time` FLOAT NOT NULL,
    `time_homework_p` FLOAT NOT NULL,
    `time_homework_c` FLOAT NOT NULL,
    `time_homework_pc` FLOAT NOT NULL,
    `total_stroop` FLOAT NOT NULL,
    `climb` FLOAT NOT NULL,
    PRIMARY KEY (`id_stroop`)
);

CREATE TABLE `trail_making` (
    `id_trail_making` INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
    `total_trail_making` FLOAT NOT NULL,
    `correct_answers_A` INTEGER NOT NULL,
    `time_A` FLOAT NOT NULL,
    `score_A` FLOAT NOT NULL,
    `correct_answers_B` INTEGER NOT NULL,
    `time_B` FLOAT NOT NULL,
    `score_B` FLOAT NOT NULL,
    `total_correct_answers` FLOAT NOT NULL,
    PRIMARY KEY (`id_trail_making`)
);

CREATE TABLE `users` (
    `id_user` INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
    `name` VARCHAR(50) NOT NULL,
    `name2` VARCHAR(50) NOT NULL,
    `last_name` VARCHAR(100) NOT NULL,
    `document` VARCHAR(50) NOT NULL UNIQUE,
    `city` VARCHAR(50) NOT NULL,
    `clan` VARCHAR(50) NOT NULL,
    `topy` VARCHAR(50) NOT NULL,
    `status` BOOLEAN NOT NULL,
    `id_gonogo` INTEGER NOT NULL,
    `id_hanoi` INTEGER NOT NULL,
    `id_stroop` INTEGER NOT NULL,
    `id_trail_making` INTEGER NOT NULL,
    `id_results` INTEGER NOT NULL,
    PRIMARY KEY (`id_user`),
    
    CONSTRAINT `fk_users_gonogo`
        FOREIGN KEY (`id_gonogo`) REFERENCES `gonogo`(`id_gonogo`)
        ON UPDATE CASCADE ON DELETE RESTRICT,
        
    CONSTRAINT `fk_users_hanoi`
        FOREIGN KEY (`id_hanoi`) REFERENCES `T_hanoi`(`id_hanoi`)
        ON UPDATE CASCADE ON DELETE RESTRICT,
        
    CONSTRAINT `fk_users_stroop`
        FOREIGN KEY (`id_stroop`) REFERENCES `stroop`(`id_stroop`)
        ON UPDATE CASCADE ON DELETE RESTRICT,
        
    CONSTRAINT `fk_users_trail`
        FOREIGN KEY (`id_trail_making`) REFERENCES `trail_making`(`id_trail_making`)
        ON UPDATE CASCADE ON DELETE RESTRICT,
        
    CONSTRAINT `fk_users_results`
        FOREIGN KEY (`id_results`) REFERENCES `results`(`id_result`)
        ON UPDATE CASCADE ON DELETE RESTRICT
);