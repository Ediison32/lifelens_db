-- CREATE TABLE `results` (
--     `id_result` INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
--     `Inhibitory_control` FLOAT,
--     `executive_functioning` FLOAT,
--     `working_memory` FLOAT,
--     `cognitive_flexibility` FLOAT,
--     `planning` FLOAT,
--     `strategic_learning` FLOAT,
--     `processing_speed` FLOAT,
--     `behavioral_interview` FLOAT,   -- quité el espacio
--     `comprehensive_outcome` FLOAT,
--     `assessment_center` FLOAT,
--     PRIMARY KEY (`id_result`)
-- );

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


-- gonogo acutalizado 
CREATE TABLE gonogo (
    id_gonogo INT NOT NULL AUTO_INCREMENT UNIQUE,
    hw_time_1 FLOAT NOT NULL,
    hw_answer_1 FLOAT NOT NULL,
    hw_score_1 FLOAT NOT NULL,
    hw_time_2 FLOAT NOT NULL,
    hw_answer_2 FLOAT NOT NULL,
    hw_score_2 FLOAT NOT NULL,
    hw_time_3 FLOAT NOT NULL,
    hw_answer_3 FLOAT NOT NULL,
    hw_score_3 FLOAT NOT NULL,
    PC FLOAT NOT NULL,
    time FLOAT NOT NULL,
    time_homework_p FLOAT NOT NULL,
    time_homework_c FLOAT NOT NULL,
    time_homework_pc FLOAT NOT NULL,
    gonogo_total_tareas FLOAT NOT NULL,
    gonogo_interferencia FLOAT NOT NULL,
    total_gonogo FLOAT NOT NULL,
    climb VARCHAR(10) NOT NULL,
    PRIMARY KEY (id_gonogo)
);

CREATE TABLE t_hanoi (
    id_t_hanoi INT NOT NULL AUTO_INCREMENT UNIQUE,
    hanoi_pieces INT NOT NULL,
    hanoi_pieces_side INT NOT NULL,
    hanoi_cal_movement FLOAT NOT NULL,
    hanoi_time FLOAT NOT NULL,
    hanoi_cal_time FLOAT NOT NULL,
    hanoi_total FLOAT NOT NULL,
    PRIMARY KEY (id_t_hanoi)
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

-- CREATE TABLE `users` (
--     `id_user` INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
--     `name` VARCHAR(50) NOT NULL,
--     `name2` VARCHAR(50) NOT NULL,
--     `last_name` VARCHAR(100) NOT NULL,
--     `document` VARCHAR(50) NOT NULL UNIQUE,
--     `city` VARCHAR(50) NOT NULL,
--     `clan` VARCHAR(50) NOT NULL,
--     `topy` VARCHAR(50) NOT NULL,
--     `status` BOOLEAN NOT NULL,
--     `id_gonogo` INTEGER NOT NULL,
--     `id_hanoi` INTEGER NOT NULL,
--     `id_stroop` INTEGER NOT NULL,
--     `id_trail_making` INTEGER NOT NULL,
--     `id_results` INTEGER NOT NULL,
--     PRIMARY KEY (`id_user`),
    
--     CONSTRAINT `fk_users_gonogo`
--         FOREIGN KEY (`id_gonogo`) REFERENCES `gonogo`(`id_gonogo`)
--         ON UPDATE CASCADE ON DELETE RESTRICT,
        
--     CONSTRAINT `fk_users_hanoi`
--         FOREIGN KEY (`id_hanoi`) REFERENCES `t_hanoi`(`id_t_hanoi`)
--         ON UPDATE CASCADE ON DELETE RESTRICT,
        
--     CONSTRAINT `fk_users_stroop`
--         FOREIGN KEY (`id_stroop`) REFERENCES `stroop`(`id_stroop`)
--         ON UPDATE CASCADE ON DELETE RESTRICT,
        
--     CONSTRAINT `fk_users_trail`
--         FOREIGN KEY (`id_trail_making`) REFERENCES `trail_making`(`id_trail_making`)
--         ON UPDATE CASCADE ON DELETE RESTRICT,
        
--     CONSTRAINT `fk_users_results`
--         FOREIGN KEY (`id_results`) REFERENCES `results`(`id_result`)
--         ON UPDATE CASCADE ON DELETE RESTRICT
-- );



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
        FOREIGN KEY (`id_t_hanoi`) REFERENCES `t_hanoi`(`id_t_hanoi`)
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






-- paso a paso de actualizacion de la db 

--1

DELIMITER $$

CREATE PROCEDURE add_user_pack(
    IN p_name       VARCHAR(50),
    IN p_name2      VARCHAR(50),
    IN p_last_name  VARCHAR(50),
    IN p_last_name2 VARCHAR(50),
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

    -- GONOGO
    INSERT INTO gonogo (
        hw_time_1, hw_answer_1, hw_score_1,
        hw_time_2, hw_answer_2, hw_score_2,
        hw_time_3, hw_answer_3, hw_score_3,
        PC, time, time_homework_p, time_homework_c, time_homework_pc,
        `gonogo-total-tareas`, `gonogo-interferencia`, total_gonogo, climb
    ) VALUES (
        0, 0, 0,
        0, 0, 0,
        0, 0, 0,
        0, 0, 0, 0, 0,
        0, 0, 0, '-'
    );
    SET v_g = LAST_INSERT_ID();

    -- STROOP
    INSERT INTO stroop (
        p, c, pc, P_C, Interference, time_total,
        time_homework_p, time_homework_c, time_homework_pc,
        total_stroop, climb
    ) VALUES (
        0, 0, 0, 0, 0, 0,
        0, 0, 0,
        0, '-'
    );
    SET v_s = LAST_INSERT_ID();

    -- TORRE DE HANOI
    INSERT INTO t_hanoi (
        hanoi_pieces, hanoi_pieces_side, hanoi_cal_movement,
        hanoi_time, hanoi_cal_time, hanoi_total
    ) VALUES (
        0, 0, 0,
        0, 0, 0
    );
    SET v_h = LAST_INSERT_ID();

    -- TRAIL MAKING
    INSERT INTO trail_making (
        trail_A_time, trail_B_time, trail_A_errors,
        trail_B_errors, total_trail
    ) VALUES (
        0, 0, 0,
        0, 0
    );
    SET v_t = LAST_INSERT_ID();

    -- RESULTADOS
    INSERT INTO result (
        global_score, performance_level
    ) VALUES (
        0, '-'
    );
    SET v_r = LAST_INSERT_ID();

    -- INSERTAR EL USUARIO FINAL
    INSERT INTO user
        (name, name2, last_name, last_name2, document, city, clan, topy,
         id_gonogo, id_stroop, id_t_hanoi, id_trail_making, id_result)
    VALUES
        (p_name, p_name2, p_last_name, p_last_name2, p_document, p_city, p_clan, p_topy,
         v_g, v_s, v_h, v_t, v_r);

END $$ DELIMITER ;


-- 2 
CREATE TABLE gonogo (
    id_gonogo INT NOT NULL AUTO_INCREMENT UNIQUE,
    hw_time_1 FLOAT DEFAULT 0,
    hw_answer_1 FLOAT DEFAULT 0,
    hw_score_1 FLOAT DEFAULT 0,
    hw_time_2 FLOAT DEFAULT 0,
    hw_answer_2 FLOAT DEFAULT 0,
    hw_score_2 FLOAT DEFAULT 0,
    hw_time_3 FLOAT DEFAULT 0,
    hw_answer_3 FLOAT DEFAULT 0,
    hw_score_3 FLOAT DEFAULT 0,
    PC FLOAT DEFAULT 0,
    time FLOAT DEFAULT 0,
    time_homework_p FLOAT DEFAULT 0,
    time_homework_c FLOAT DEFAULT 0,
    time_homework_pc FLOAT DEFAULT 0,
    `gonogo-total-tareas` FLOAT DEFAULT 0,
    `gonogo-interferencia` FLOAT DEFAULT 0,
    total_gonogo FLOAT DEFAULT 0,
    climb VARCHAR(10) DEFAULT '-',
    PRIMARY KEY (id_gonogo)
);


CREATE TABLE t_hanoi (
    id_t_hanoi INT NOT NULL AUTO_INCREMENT UNIQUE,
    hanoi_pieces INT NOT NULL,
    hanoi_pieces_side INT NOT NULL,
    hanoi_cal_movement FLOAT NOT NULL,
    hanoi_time FLOAT NOT NULL,
    hanoi_cal_time FLOAT NOT NULL,
    hanoi_total FLOAT NOT NULL,
    PRIMARY KEY (id_t_hanoi)
);


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

-- CREATE TABLE `stroop` (
--     `id_stroop` INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
--     `p` FLOAT NOT NULL,
--     `c` FLOAT NOT NULL,
--     `pc` FLOAT NOT NULL,
--     `P_C` FLOAT NOT NULL,
--     `time` FLOAT NOT NULL,
--     `time_homework_p` FLOAT NOT NULL,
--     `time_homework_c` FLOAT NOT NULL,
--     `time_homework_pc` FLOAT NOT NULL,
--     `total_stroop` FLOAT NOT NULL,
--     `climb` FLOAT NOT NULL,
--     PRIMARY KEY (`id_stroop`)
-- );

CREATE TABLE stroop (
    id_stroop INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
    p FLOAT NOT NULL,
    c FLOAT NOT NULL,
    pc FLOAT NOT NULL,
    P_C FLOAT NOT NULL,
    Interference FLOAT NOT NULL,          -- nueva columna agregada
    time_total FLOAT NOT NULL,             -- renombrada de time para evitar conflicto
    time_homework_p FLOAT NOT NULL,
    time_homework_c FLOAT NOT NULL,
    time_homework_pc FLOAT NOT NULL,
    total_stroop FLOAT NOT NULL,
    climb VARCHAR(20) NOT NULL,           -- cambió a string
    PRIMARY KEY (id_stroop)
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


-- user 

CREATE TABLE user (
    id_user INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    name2 VARCHAR(50),
    last_name VARCHAR(50) NOT NULL,
    last_name2 VARCHAR(50),
    document VARCHAR(50) NOT NULL UNIQUE,
    city VARCHAR(50),
    clan VARCHAR(50),
    topy VARCHAR(50),
    id_gonogo INT,
    id_stroop INT,
    id_t_hanoi INT,
    id_trail_making INT,
    id_result INT,
    PRIMARY KEY (id_user),
    FOREIGN KEY (id_gonogo) REFERENCES gonogo(id_gonogo) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (id_stroop) REFERENCES stroop(id_stroop) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (id_t_hanoi) REFERENCES t_hanoi(id_t_hanoi) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (id_trail_making) REFERENCES trail_making(id_trail_making) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (id_result) REFERENCES result(id_result) ON DELETE RESTRICT ON UPDATE CASCADE
);



-- 4️⃣ Crear el procedimiento almacenado
DELIMITER $$

CREATE PROCEDURE add_user_pack(
    IN p_name       VARCHAR(50),
    IN p_name2      VARCHAR(50),
    IN p_last_name  VARCHAR(50),
    IN p_last_name2 VARCHAR(50),
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

    -- GONOGO
    INSERT INTO gonogo (
        hw_time_1, hw_answer_1, hw_score_1,
        hw_time_2, hw_answer_2, hw_score_2,
        hw_time_3, hw_answer_3, hw_score_3,
        PC, time, time_homework_p, time_homework_c, time_homework_pc,
        `gonogo-total-tareas`, `gonogo-interferencia`, total_gonogo, climb
    ) VALUES (
        0, 0, 0,
        0, 0, 0,
        0, 0, 0,
        0, 0, 0, 0, 0,
        0, 0, 0, '-'
    );
    SET v_g = LAST_INSERT_ID();

    -- STROOP
    INSERT INTO stroop (
        p, c, pc, P_C, Interference, time_total,
        time_homework_p, time_homework_c, time_homework_pc,
        total_stroop, climb
    ) VALUES (
        0, 0, 0, 0, 0, 0,
        0, 0, 0,
        0, '-'
    );
    SET v_s = LAST_INSERT_ID();

    -- TORRE DE HANOI
    INSERT INTO t_hanoi (
        hanoi_pieces, hanoi_pieces_side, hanoi_cal_movement,
        hanoi_time, hanoi_cal_time, hanoi_total
    ) VALUES (
        0, 0, 0,
        0, 0, 0
    );
    SET v_h = LAST_INSERT_ID();

    -- TRAIL MAKING
    INSERT INTO trail_making (
        total_trail_making, correct_answers_A, time_A,
        score_A, correct_answers_B, time_B, score_B, total_correct_answers
    ) VALUES (
        0, 0, 0,
        0, 0, 0, 0, 0
    );
    SET v_t = LAST_INSERT_ID();

    -- RESULTADOS
    INSERT INTO result (
        Inhibitory_control, executive_functioning, working_memory,
        cognitive_flexibility, planning, strategic_learning,
        processing_speed, comprehensive_outcome
    ) VALUES (
        0, 0, 0, 0, 0, 0, 0, 0
    );
    SET v_r = LAST_INSERT_ID();

    -- INSERTAR EL USUARIO FINAL
    INSERT INTO user
        (name, name2, last_name, last_name2, document, city, clan, topy,
         id_gonogo, id_stroop, id_t_hanoi, id_trail_making, id_result)
    VALUES
        (p_name, p_name2, p_last_name, p_last_name2, p_document, p_city, p_clan, p_topy,
         v_g, v_s, v_h, v_t, v_r);

END $$ DELIMITER ;


------------------------------------------------------------------------------------- Ensayo final 12-11-2025

mysql> CREATE TABLE gonogo (
    ->     id_gonogo INT NOT NULL AUTO_INCREMENT UNIQUE,
    ->     hw_time_1 FLOAT DEFAULT 0,
    ->     hw_answer_1 FLOAT DEFAULT 0,
    ->     hw_score_1 FLOAT DEFAULT 0,
    ->     hw_time_2 FLOAT DEFAULT 0,
    ->     hw_answer_2 FLOAT DEFAULT 0,
    ->     hw_score_2 FLOAT DEFAULT 0,
    ->     hw_time_3 FLOAT DEFAULT 0,
    ->     hw_answer_3 FLOAT DEFAULT 0,
    ->     hw_score_3 FLOAT DEFAULT 0,
    ->     PC FLOAT DEFAULT 0,
    ->     time FLOAT DEFAULT 0,
    ->     time_homework_p FLOAT DEFAULT 0,
    ->     time_homework_c FLOAT DEFAULT 0,
    ->     time_homework_pc FLOAT DEFAULT 0,
    ->     `gonogo-total-tareas` FLOAT DEFAULT 0,
    ->     `gonogo-interferencia` FLOAT DEFAULT 0,
    ->     total_gonogo FLOAT DEFAULT 0,
    ->     climb VARCHAR(10) DEFAULT '-',
    ->     PRIMARY KEY (id_gonogo)
    -> );
Query OK, 0 rows affected (0.32 sec)

mysql> CREATE TABLE stroop (
    ->     id_stroop INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
    ->     p FLOAT NOT NULL,
    ->     c FLOAT NOT NULL,
    ->     pc FLOAT NOT NULL,
    ->     P_C FLOAT NOT NULL,
    ->     Interference FLOAT NOT NULL,
    ->     time_total FLOAT NOT NULL,
    ->     time_homework_p FLOAT NOT NULL,
    ->     time_homework_c FLOAT NOT NULL,
    ->     time_homework_pc FLOAT NOT NULL,
    ->     total_stroop FLOAT NOT NULL,
    ->     climb VARCHAR(20) NOT NULL,
    ->     PRIMARY KEY (id_stroop)
    -> );
Query OK, 0 rows affected (0.31 sec)

mysql> CREATE TABLE t_hanoi (
    ->     id_t_hanoi INT NOT NULL AUTO_INCREMENT UNIQUE,
    ->     hanoi_pieces INT NOT NULL,
    ->     hanoi_pieces_side INT NOT NULL,
    ->     hanoi_cal_movement FLOAT NOT NULL,
    ->     hanoi_time FLOAT NOT NULL,
    ->     hanoi_cal_time FLOAT NOT NULL,
    ->     hanoi_total FLOAT NOT NULL,
    ->     PRIMARY KEY (id_t_hanoi)
    -> );
Query OK, 0 rows affected (0.31 sec)

mysql> CREATE TABLE trail_making (
    ->     id_trail_making INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
    ->     total_trail_making FLOAT NOT NULL,
    ->     correct_answers_A INTEGER NOT NULL,
    ->     time_A FLOAT NOT NULL,
    ->     score_A FLOAT NOT NULL,
    ->     correct_answers_B INTEGER NOT NULL,
    ->     time_B FLOAT NOT NULL,
    ->     score_B FLOAT NOT NULL,
    ->     total_correct_answers FLOAT NOT NULL,
    ->     PRIMARY KEY (id_trail_making)
    -> );
Query OK, 0 rows affected (0.31 sec)

mysql> CREATE TABLE result (
    ->     id_result INTEGER AUTO_INCREMENT UNIQUE,
    ->     Inhibitory_control FLOAT,
    ->     executive_functioning FLOAT,
    ->     working_memory FLOAT,
    ->     cognitive_flexibility FLOAT,
    ->     planning FLOAT,
    ->     strategic_learning FLOAT,
    ->     processing_speed FLOAT,
    ->     comprehensive_outcome FLOAT,
    ->     PRIMARY KEY (id_result)
    -> );
Query OK, 0 rows affected (0.31 sec)

mysql> CREATE TABLE user (
    ->     id_user INT NOT NULL AUTO_INCREMENT,
    ->     name VARCHAR(50) NOT NULL,
    ->     name2 VARCHAR(50),
    ->     last_name VARCHAR(50) NOT NULL,
    ->     last_name2 VARCHAR(50),
    ->     document VARCHAR(50) NOT NULL UNIQUE,
    ->     city VARCHAR(50),
    ->     clan VARCHAR(50),
    ->     topy VARCHAR(50),
    ->     id_gonogo INT,
    ->     id_stroop INT,
    ->     id_t_hanoi INT,
    ->     id_trail_making INT,
    ->     id_result INT,
    ->     PRIMARY KEY (id_user),
    ->     FOREIGN KEY (id_gonogo) REFERENCES gonogo(id_gonogo) ON DELETE RESTRICT ON UPDATE CASCADE,
    ->     FOREIGN KEY (id_stroop) REFERENCES stroop(id_stroop) ON DELETE RESTRICT ON UPDATE CASCADE,
    ->     FOREIGN KEY (id_t_hanoi) REFERENCES t_hanoi(id_t_hanoi) ON DELETE RESTRICT ON UPDATE CASCADE,
    ->     FOREIGN KEY (id_trail_making) REFERENCES trail_making(id_trail_making) ON DELETE RESTRICT ON UPDATE CASCADE,
    ->     FOREIGN KEY (id_result) REFERENCES result(id_result) ON DELETE RESTRICT ON UPDATE CASCADE
    -> );
Query OK, 0 rows affected (0.34 sec)

mysql> DELIMITER $$
mysql>
mysql> CREATE PROCEDURE add_user_pack(
    ->     IN p_name       VARCHAR(50),
    ->     IN p_name2      VARCHAR(50),
    ->     IN p_last_name  VARCHAR(50),
    ->     IN p_last_name2 VARCHAR(50),
    ->     IN p_document   VARCHAR(50),
    ->     IN p_city       VARCHAR(50),
    ->     IN p_clan       VARCHAR(50),
    ->     IN p_topy       VARCHAR(50)
    -> )
    -> BEGIN
    ->     DECLARE v_g  INT;
    ->     DECLARE v_s  INT;
    ->     DECLARE v_h  INT;
    ->     DECLARE v_t  INT;
    ->     DECLARE v_r  INT;
    ->
    ->     -- GONOGO
    ->     INSERT INTO gonogo (
    ->         hw_time_1, hw_answer_1, hw_score_1,
    ->         hw_time_2, hw_answer_2, hw_score_2,
    ->         hw_time_3, hw_answer_3, hw_score_3,
    ->         PC, time, time_homework_p, time_homework_c, time_homework_pc,
    ->         `gonogo-total-tareas`, `gonogo-interferencia`, total_gonogo, climb
    ->     ) VALUES (
    ->         0, 0, 0,
    ->         0, 0, 0,
    ->         0, 0, 0,
    ->         0, 0, 0, 0, 0,
    ->         0, 0, 0, '-'
    ->     );
    ->     SET v_g = LAST_INSERT_ID();
    ->
    ->     -- STROOP
    ->     INSERT INTO stroop (
    ->         p, c, pc, P_C, Interference, time_total,
    ->         time_homework_p, time_homework_c, time_homework_pc,
    ->         total_stroop, climb
    ->     ) VALUES (
    ->         0, 0, 0, 0, 0, 0,
    ->         0, 0, 0,
    ->         0, '-'
    ->     );
    ->     SET v_s = LAST_INSERT_ID();
    ->
    ->     -- TORRE DE HANOI
    ->     INSERT INTO t_hanoi (
    ->         hanoi_pieces, hanoi_pieces_side, hanoi_cal_movement,
    ->         hanoi_time, hanoi_cal_time, hanoi_total
    ->     ) VALUES (
    ->         0, 0, 0,
    ->         0, 0, 0
    ->     );
    ->     SET v_h = LAST_INSERT_ID();
    ->
    ->     -- TRAIL MAKING
    ->     INSERT INTO trail_making (
    ->         total_trail_making, correct_answers_A, time_A,
    ->         score_A, correct_answers_B, time_B, score_B, total_correct_answers
    ->     ) VALUES (
    ->         0, 0, 0,
    ->         0, 0, 0, 0, 0
    ->     );
    ->     SET v_t = LAST_INSERT_ID();
    ->
    ->     -- RESULTADOS
    ->     INSERT INTO result (
    ->         Inhibitory_control, executive_functioning, working_memory,
    ->         cognitive_flexibility, planning, strategic_learning,
    ->         processing_speed, comprehensive_outcome
    ->     ) VALUES (
    ->         0, 0, 0, 0, 0, 0, 0, 0
    ->     );
    ->     SET v_r = LAST_INSERT_ID();
    ->
    ->     -- INSERTAR EL USUARIO FINAL
    ->     INSERT INTO user
    ->         (name, name2, last_name, last_name2, document, city, clan, topy,
    ->          id_gonogo, id_stroop, id_t_hanoi, id_trail_making, id_result)
    ->     VALUES
    ->         (p_name, p_name2, p_last_name, p_last_name2, p_document, p_city, p_clan, p_topy,
    ->          v_g, v_s, v_h, v_t, v_r);
    ->
    -> END $$ DELIMITER ;
Query OK, 0 rows affected (0.30 sec)



---- intento ----------------------------------------------------------------------------------------------------------



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


-- gonogo acutalizado 
CREATE TABLE gonogo (
    id_gonogo INT NOT NULL AUTO_INCREMENT UNIQUE,
    hw_time_1 FLOAT NOT NULL,
    hw_answer_1 FLOAT NOT NULL,
    hw_score_1 FLOAT NOT NULL,
    hw_time_2 FLOAT NOT NULL,
    hw_answer_2 FLOAT NOT NULL,
    hw_score_2 FLOAT NOT NULL,
    hw_time_3 FLOAT NOT NULL,
    hw_answer_3 FLOAT NOT NULL,
    hw_score_3 FLOAT NOT NULL,
    PC FLOAT NOT NULL,
    time FLOAT NOT NULL,
    time_homework_p FLOAT NOT NULL,
    time_homework_c FLOAT NOT NULL,
    time_homework_pc FLOAT NOT NULL,
    gonogo_total_tareas FLOAT NOT NULL,
    gonogo_interferencia FLOAT NOT NULL,
    total_gonogo FLOAT NOT NULL,
    climb VARCHAR(10) NOT NULL,
    PRIMARY KEY (id_gonogo)
);

CREATE TABLE t_hanoi (
    id_t_hanoi INT NOT NULL AUTO_INCREMENT UNIQUE,
    hanoi_pieces INT NOT NULL,
    hanoi_pieces_side INT NOT NULL,
    hanoi_cal_movement FLOAT NOT NULL,
    hanoi_time FLOAT NOT NULL,
    hanoi_cal_time FLOAT NOT NULL,
    hanoi_total FLOAT NOT NULL,
    PRIMARY KEY (id_t_hanoi)
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


-- DELIMITER $$
-- CREATE PROCEDURE add_user_pack(
--     IN p_name       VARCHAR(50),
--     IN p_name2      VARCHAR(50),      -- nuevo
--     IN p_last_name  VARCHAR(50),
--     IN p_last_name2 VARCHAR(50),      -- nuevo
--     IN p_document   VARCHAR(50),
--     IN p_city       VARCHAR(50),
--     IN p_clan       VARCHAR(50),
--     IN p_topy       VARCHAR(50)
-- )
-- BEGIN
--     DECLARE v_g  INT;
--     DECLARE v_s  INT;
--     DECLARE v_h  INT;
--     DECLARE v_t  INT;
--     DECLARE v_r  INT;

--     INSERT INTO gonogo        () VALUES (); SET v_g = LAST_INSERT_ID();
--     INSERT INTO stroop        () VALUES (); SET v_s = LAST_INSERT_ID();
--     INSERT INTO t_hanoi       () VALUES (); SET v_h = LAST_INSERT_ID();
--     INSERT INTO trail_making  () VALUES (); SET v_t = LAST_INSERT_ID();
--     INSERT INTO result        () VALUES (); SET v_r = LAST_INSERT_ID();

--     INSERT INTO user
--         (name, name2, last_name, last_name2, document, city, clan, topy,
--          id_gonogo, id_stroop, id_t_hanoi, id_trail_making, id_result)
--     VALUES
--         (p_name, p_name2, p_last_name, p_last_name2, p_document, p_city, p_clan, p_topy,
--          v_g, v_s, v_h, v_t, v_r);
-- END $$  DELIMITER ;


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




------------------------------------------------------------------------------------------------ Funcional pendiente unos datos por actualizar 




---------------------------------------------------------------
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
--            trail_making
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
        FOREIGN KEY (`id_t_hanoi`) REFERENCES `t_hanoi`(`id_t_hanoi`)
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

INSERT INTO gonogo (hw_time_1, hw_answer_1, hw_score_1, hw_time_2, hw_answer_2, hw_score_2, hw_time_3, hw_answer_3, hw_score_3, total_homewor, Interference, total_gonogo_answer, total_gonogo, climb)
VALUES (0,0,0,0,0,0,0,0,0,0,0,0,0,0);

-- T_hanoi
INSERT INTO t_hanoi (number_pieces, number_pieces_r_side, motion_rating, time, motion_rating2, total_hanoi)
VALUES (0,0,0,0,0,0);

-- stroop
INSERT INTO stroop (p, c, pc, P_C, Interference, time, time_homework_p, time_homework_c, time_homework_pc, total_stroop, climb)
VALUES (0,0,0,0,0,0,0,0,0,0,0);

-- trail_making
INSERT INTO trail_making (total_trail_making, correct_answers_A, time_A, score_A, correct_answers_B, time_B, score_B, total_correct_answers)
VALUES (0,0,0,0,0,0,0,0);

-- results
INSERT INTO result () VALUES ();




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