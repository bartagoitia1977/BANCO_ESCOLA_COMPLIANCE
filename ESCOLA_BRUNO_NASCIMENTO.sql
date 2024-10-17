/* 

Bruno Artagoitia Vicente do Nascimento
Compliance solucoes - Outubro 2024
Avaliacao tecnica - questoes 12 a 16

*/

-- ESCOLA

-- Criacao do banco de dados

--Arquivo de inicializacao de parametros

STARTUP NOMOUNT PFILE='path_to_init.ora';

-- Database escola

CREATE DATABASE escola
USER SYS IDENTIFIED BY senha_sys
USER SYSTEM IDENTIFIED BY senha_system
LOGFILE GROUP 1 ('/u01/app/oracle/oradata/escola/redo01.log') SIZE 100M,
        GROUP 2 ('/u01/app/oracle/oradata/escola/redo02.log') SIZE 100M
DATAFILE '/u01/app/oracle/oradata/escola/system01.dbf' SIZE 700M
SYSAUX DATAFILE '/u01/app/oracle/oradata/meescolau_banco/sysaux01.dbf' SIZE 500M
DEFAULT TABLESPACE users
  DATAFILE '/u01/app/oracle/oradata/escola/users01.dbf'
DEFAULT TEMPORARY TABLESPACE temp
  TEMPFILE '/u01/app/oracle/oradata/escola/temp01.dbf'
UNDO TABLESPACE undotbs
  DATAFILE '/u01/app/oracle/oradata/escola/undotbs01.dbf';

/* Views do dicionario de dados - sqlplus

@?/rdbms/admin/catalog.sql
@?/rdbms/admin/catproc.sql

dicionario de dados - amostras

@?/sqlplus/admin/pupbld.sql

*/

ALTER DATABASE OPEN;

-- Criacao dos tablespaces solicitados

CREATE TABLESPACE TB_DATA
DATAFILE '/u01/app/oracle/oradata/escola/' SIZE 100M
AUTOEXTEND ON;

CREATE TABLESPACE TB_INDEX
DATAFILE '/u01/app/oracle/oradata/escola/' SIZE 100M
AUTOEXTEND ON;

-- Criacao das tabelas de escola
-- Obs.: boa pratica - criar primeiro as tabelas com seus atributos, inserir dados e depois seus relacionamentos

CREATE TABLE aluno
(
    codigo NUMBER PRIMARY KEY,
    nome VARCHAR2(50),
    data_nasc DATE    
)
TABLESPACE TB_DATA;


CREATE TABLE professor
(
    codigo NUMBER PRIMARY KEY,
    nome VARCHAR2(50)
)
TABLESPACE TB_DATA;


CREATE TABLE disciplina
(
    codigo NUMBER PRIMARY KEY,
    nome VARCHAR2(50),
    disc_prereq_codigo NUMBER,
    creditos NUMBER,
    professor_codigo NUMBER
)
TABLESPACE TB_DATA;


CREATE TABLE matricula
(
    aluno_codigo NUMBER,
    disc_codigo NUMBER,
    nota NUMBER(4,2),
    situacao VARCHAR2(20),
    PRIMARY KEY (aluno_codigo, disc_codigo)
)
TABLESPACE TB_INDEX;


-- Criacao de sequences

CREATE SEQUENCE seq_aluno
START WITH 1
INCREMENT BY 1
NOCACHE;


CREATE SEQUENCE seq_professor
START WITH 1
INCREMENT BY 1
NOCACHE;


CREATE SEQUENCE seq_disciplina
START WITH 1
INCREMENT BY 1
NOCACHE;


-- Triggers para sequencias de codigos

CREATE OR REPLACE TRIGGER trg_codigo_aluno
BEFORE INSERT ON aluno
FOR EACH ROW
BEGIN
  :NEW.codigo := seq_aluno.NEXTVAL;
END;


CREATE OR REPLACE TRIGGER trg_codigo_professor
BEFORE INSERT ON professor
FOR EACH ROW
BEGIN
  :NEW.codigo := seq_professor.NEXTVAL;
END;


CREATE OR REPLACE TRIGGER trg_codigo_disciplina
BEFORE INSERT ON disciplina
FOR EACH ROW
BEGIN
  :NEW.codigo := seq_disciplina.NEXTVAL;
END;


-- Insercoes nas tabelas

INSERT ALL 
    INTO aluno (nome, data_nasc) VALUES ('Rogério', TO_DATE('1974-07-31', 'YYYY-MM-DD')) --1
    INTO aluno (nome, data_nasc) VALUES ('Giovane',  TO_DATE('1975-03-26', 'YYYY-MM-DD')) --2
    INTO aluno (nome, data_nasc) VALUES ('João',  TO_DATE('1988-11-20', 'YYYY-MM-DD')) --3
    INTO aluno (nome, data_nasc) VALUES ('Maria',  TO_DATE('1988-10-20', 'YYYY-MM-DD')) --4
    INTO aluno (nome, data_nasc) VALUES ('Tereza',  TO_DATE('1982-10-07', 'YYYY-MM-DD')) --5
    INTO aluno (nome, data_nasc) VALUES ('Alexandre',  TO_DATE('1988-05-30', 'YYYY-MM-DD')) --6
    INTO aluno (nome, data_nasc) VALUES ('Arthur',  TO_DATE('1989-05-28', 'YYYY-MM-DD')) --7
    INTO aluno (nome, data_nasc) VALUES ('Angela',  TO_DATE('1972-03-02', 'YYYY-MM-DD')) --8
    INTO aluno (nome, data_nasc) VALUES ('Vinicius',  TO_DATE('1994-02-01', 'YYYY-MM-DD')) --9
SELECT * FROM DUAL;


INSERT ALL
    INTO professor (nome) VALUES ('Maíra')
    INTO professor (nome) VALUES ('Zezé')
    INTO professor (nome) VALUES ('Alexandre')
SELECT * FROM DUAL;


INSERT ALL
    INTO disciplina (nome, disc_prereq_codigo, creditos, professor_codigo) 
    VALUES ('Sistema de Informação', NULL, 2, 2) --1
    INTO disciplina (nome, disc_prereq_codigo, creditos, professor_codigo) 
    VALUES ('Sistema de Informação II', 1, 2, 3) --2
    INTO disciplina (nome, disc_prereq_codigo, creditos, professor_codigo) 
    VALUES ('Banco de Dados', NULL, 2, 1) --3
    INTO disciplina (nome, disc_prereq_codigo, creditos, professor_codigo) 
    VALUES ('Português', NULL, 4, 2) --4
    INTO disciplina (nome, disc_prereq_codigo, creditos, professor_codigo) 
    VALUES ('Banco de Dados II', 3, 4, 3) --5
SELECT * FROM DUAL;


INSERT ALL
    INTO matricula (aluno_codigo, disc_codigo, nota, situacao) VALUES (1,5,2,'Reprovado')
    INTO matricula (aluno_codigo, disc_codigo, nota, situacao) VALUES (1,1,9,'Aprovado')
    INTO matricula (aluno_codigo, disc_codigo, nota, situacao) VALUES (1,2,10,'Aprovado')
    INTO matricula (aluno_codigo, disc_codigo, nota, situacao) VALUES (1,3,6,'Aprovado')
    INTO matricula (aluno_codigo, disc_codigo, nota, situacao) VALUES (1,4,4,'Reprovado')
    INTO matricula (aluno_codigo, disc_codigo, nota, situacao) VALUES (4,1,7,'Aprovado')
    INTO matricula (aluno_codigo, disc_codigo, nota, situacao) VALUES (4,2,8,'Aprovado')
    INTO matricula (aluno_codigo, disc_codigo, nota, situacao) VALUES (4,3,7,'Aprovado')
    INTO matricula (aluno_codigo, disc_codigo, nota, situacao) VALUES (4,4,10,'Aprovado')
    INTO matricula (aluno_codigo, disc_codigo, nota, situacao) VALUES (4,5,6,'Aprovado')
    INTO matricula (aluno_codigo, disc_codigo, nota, situacao) VALUES (2,1,5,'Aprovado')
    INTO matricula (aluno_codigo, disc_codigo, nota, situacao) VALUES (2,2,4,'Reprovado')
    INTO matricula (aluno_codigo, disc_codigo, nota, situacao) VALUES (2,3,8,'Aprovado')
    INTO matricula (aluno_codigo, disc_codigo, nota, situacao) VALUES (2,4,2,'Reprovado')
    INTO matricula (aluno_codigo, disc_codigo, nota, situacao) VALUES (2,5,6,'Aprovado')
    INTO matricula (aluno_codigo, disc_codigo, nota, situacao) VALUES (3,4,3,'Reprovado')
    INTO matricula (aluno_codigo, disc_codigo, nota, situacao) VALUES (3,1,6,'Aprovado')
    INTO matricula (aluno_codigo, disc_codigo, nota, situacao) VALUES (3,2,7,'Aprovado')
    INTO matricula (aluno_codigo, disc_codigo, nota, situacao) VALUES (3,3,8,'Aprovado')
    INTO matricula (aluno_codigo, disc_codigo, nota, situacao) VALUES (3,5,9,'Aprovado')
    INTO matricula (aluno_codigo, disc_codigo, nota, situacao) VALUES (5,1,8,'Aprovado')
    INTO matricula (aluno_codigo, disc_codigo, nota, situacao) VALUES (5,2,10,'Aprovado')
    INTO matricula (aluno_codigo, disc_codigo, nota, situacao) VALUES (5,3,5,'Aprovado')
    INTO matricula (aluno_codigo, disc_codigo, nota, situacao) VALUES (5,4,5,'Aprovado')
    INTO matricula (aluno_codigo, disc_codigo, nota, situacao) VALUES (5,5,6,'Aprovado')
    INTO matricula (aluno_codigo, disc_codigo, nota, situacao) VALUES (6,1,5,'Aprovado')
    INTO matricula (aluno_codigo, disc_codigo, nota, situacao) VALUES (6,2,4,'Reprovado')
    INTO matricula (aluno_codigo, disc_codigo, nota, situacao) VALUES (6,3,3,'Reprovado')
    INTO matricula (aluno_codigo, disc_codigo, nota, situacao) VALUES (6,4,4,'Reprovado')
    INTO matricula (aluno_codigo, disc_codigo, nota, situacao) VALUES (6,5,2,'Reprovado')
    INTO matricula (aluno_codigo, disc_codigo, nota, situacao) VALUES (7,1,7,'Aprovado')
    INTO matricula (aluno_codigo, disc_codigo, nota, situacao) VALUES (7,2,8,'Aprovado')
    INTO matricula (aluno_codigo, disc_codigo, nota, situacao) VALUES (7,3,9,'Aprovado')
    INTO matricula (aluno_codigo, disc_codigo, nota, situacao) VALUES (7,4,5,'Aprovado')
    INTO matricula (aluno_codigo, disc_codigo, nota, situacao) VALUES (7,5,10,'Aprovado')
    INTO matricula (aluno_codigo, disc_codigo, nota, situacao) VALUES (8,1,8,'Aprovado')
    INTO matricula (aluno_codigo, disc_codigo, nota, situacao) VALUES (8,2,7,'Aprovado')
    INTO matricula (aluno_codigo, disc_codigo, nota, situacao) VALUES (8,3,10,'Aprovado')
    INTO matricula (aluno_codigo, disc_codigo, nota, situacao) VALUES (8,4,10,'Aprovado')
    INTO matricula (aluno_codigo, disc_codigo, nota, situacao) VALUES (8,5,9,'Aprovado')
    INTO matricula (aluno_codigo, disc_codigo, nota, situacao) VALUES (9,1,8,'Aprovado')
    INTO matricula (aluno_codigo, disc_codigo, nota, situacao) VALUES (9,2,8,'Aprovado')
    INTO matricula (aluno_codigo, disc_codigo, nota, situacao) VALUES (9,3,7,'Aprovado')
    INTO matricula (aluno_codigo, disc_codigo, nota, situacao) VALUES (9,4,3,'Reprovado')
    INTO matricula (aluno_codigo, disc_codigo, nota, situacao) VALUES (9,5,6,'Aprovado')
SELECT * FROM DUAL;


-- Foreign keys

ALTER TABLE matricula
ADD CONSTRAINT fk_aluno FOREIGN KEY (aluno_codigo)
REFERENCES aluno (codigo);


ALTER TABLE matricula
ADD CONSTRAINT fk_disciplina FOREIGN KEY (disc_codigo)
REFERENCES disciplina (codigo);


ALTER TABLE disciplina
ADD CONSTRAINT fk_prereq FOREIGN KEY (disc_prereq_codigo)
REFERENCES disciplina (codigo);


ALTER TABLE disciplina
ADD CONSTRAINT fk_professor FOREIGN KEY (professor_codigo)
REFERENCES professor (codigo);


-- Consultas (Questao 15)

-- a
SELECT codigo, nome FROM disciplina
WHERE creditos >= 2;

-- b
SELECT d.codigo, d.nome, d.creditos FROM disciplina d
WHERE EXISTS (SELECT 1 FROM professor p WHERE p.codigo = d.professor_codigo
              AND p.nome = 'Zezé');

-- c
SELECT d.codigo FROM disciplina d 
WHERE EXISTS (SELECT 1 FROM matricula m WHERE d.codigo = m.disc_codigo AND EXISTS (
              SELECT 1 FROM aluno a WHERE a.codigo = m.aluno_codigo AND a.nome = 'Rogério'));

-- d
SELECT a.codigo FROM aluno a 
WHERE EXISTS (SELECT 1 FROM matricula m WHERE m.aluno_codigo = a.codigo
              AND m.nota >= 6
              AND EXISTS (SELECT 1 FROM disciplina d WHERE d.codigo = m.disc_codigo 
              AND d.nome = 'Banco de Dados II'));

-- e
SELECT d.codigo AS NRO, d.nome AS DISCIPLINA
FROM disciplina d
WHERE d.disc_prereq_codigo IS NULL;

-- Calculos (Questao 16)

-- a
SELECT AVG(m.nota) AS NOTA_MEDIA_REPROVADOS FROM matricula m
WHERE m.nota < 5;

-- b
SELECT MAX(m.nota) AS MAIOR_NOTA_PORTUGUES, MIN(m.nota) AS MENOR_NOTA_PORTUGUES FROM matricula m
WHERE EXISTS (SELECT 1 FROM disciplina d WHERE d.codigo = m.disc_codigo AND d.nome = 'Português');

-- c
SELECT COUNT(creditos) FROM disciplina
WHERE creditos = 2;

-- d
SELECT COUNT(*) FROM aluno
WHERE data_nasc IS NULL;

-- e
SELECT COUNT(*) FROM disciplina
WHERE professor_codigo IS NULL;