USE [master]
GO

CREATE DATABASE BD2
GO

USE BD2
GO

ALTER DATABASE [BD2] SET COMPATIBILITY_LEVEL = 140
GO

USE [BD2]
GO

CREATE SCHEMA [proyecto1]
GO

CREATE TABLE alternate_title 
    (
     alternate_title_id INTEGER NOT NULL , 
     title NVARCHAR (100) , 
     comment NVARCHAR (255) , 
     game_id INTEGER NOT NULL 
    )
GO

ALTER TABLE alternate_title ADD CONSTRAINT alternate_title_PK PRIMARY KEY CLUSTERED (alternate_title_id)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE company 
    (
     company_id INTEGER NOT NULL , 
     name NVARCHAR (100) , 
     country NVARCHAR (100) NOT NULL , 
     foundation DATE 
    )
GO

ALTER TABLE company ADD CONSTRAINT company_PK PRIMARY KEY CLUSTERED (company_id)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE franchise 
    (
     franchise_id INTEGER NOT NULL , 
     name NVARCHAR (100) 
    )
GO

ALTER TABLE franchise ADD CONSTRAINT franchise_PK PRIMARY KEY CLUSTERED (franchise_id)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE game 
    (
     game_id INTEGER NOT NULL , 
     name NVARCHAR (255) , 
     version_title NVARCHAR (255) , 
     rating FLOAT , 
     total_ratings INTEGER , 
     summary NVARCHAR (4000) , 
     storyline NVARCHAR (4000) , 
     franchise_id INTEGER NOT NULL , 
     status NVARCHAR (50) 
    )
GO

ALTER TABLE game ADD CONSTRAINT game_PK PRIMARY KEY CLUSTERED (game_id)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE game_engine 
    (
     game_engine_id INTEGER NOT NULL , 
     name NVARCHAR (100) , 
     created_at DATE 
    )
GO

ALTER TABLE game_engine ADD CONSTRAINT game_engine_PK PRIMARY KEY CLUSTERED (game_engine_id)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE game_mode 
    (
     game_mode_id INTEGER NOT NULL , 
     name NVARCHAR (100) 
    )
GO

ALTER TABLE game_mode ADD CONSTRAINT game_mode_PK PRIMARY KEY CLUSTERED (game_mode_id)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE genre 
    (
     genre_id INTEGER NOT NULL , 
     name NVARCHAR (100) 
    )
GO

ALTER TABLE genre ADD CONSTRAINT genre_PK PRIMARY KEY CLUSTERED (genre_id)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE involved_companie 
    (
     involved_id INTEGER NOT NULL , 
     developer BIT , 
     publisher BIT , 
     supporting BIT , 
     porting BIT , 
     game_id INTEGER NOT NULL , 
     company_id INTEGER NOT NULL 
    )
GO

ALTER TABLE involved_companie ADD CONSTRAINT involved_companie_PK PRIMARY KEY CLUSTERED (involved_id)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE language 
    (
     lenguage_id INTEGER NOT NULL , 
     name NVARCHAR (100) , 
     native_name NVARCHAR (100) 
    )
GO

ALTER TABLE language ADD CONSTRAINT language_PK PRIMARY KEY CLUSTERED (lenguage_id)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE  support_type 
    (
     support_type_id INTEGER NOT NULL 
     name NVARCHAR (100),
    )
GO

ALTER TABLE support_type ADD CONSTRAINT support_type_PK PRIMARY KEY CLUSTERED (support_type_id)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE language_support 
    (
     language_supports_id INTEGER NOT NULL , 
     game_id INTEGER NOT NULL , 
     lenguage_id INTEGER NOT NULL,
     support_type_id INTEGER NOT NULL 
    )
GO

ALTER TABLE language_support ADD CONSTRAINT language_support_PK PRIMARY KEY CLUSTERED (language_supports_id)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE perspective 
    (
     perspective_id INTEGER NOT NULL , 
     name NVARCHAR (100) 
    )
GO

ALTER TABLE perspective ADD CONSTRAINT perspective_PK PRIMARY KEY CLUSTERED (perspective_id)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE platform 
    (
     platform_id INTEGER NOT NULL , 
     name NVARCHAR (100) 
    )
GO

ALTER TABLE platform ADD CONSTRAINT platform_PK PRIMARY KEY CLUSTERED (platform_id)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO


CREATE TABLE region 
    (
     id_region INTEGER NOT NULL , 
     name NVARCHAR (100) 
    )
GO

ALTER TABLE region ADD CONSTRAINT region_PK PRIMARY KEY CLUSTERED (id_region)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE release 
    (
     release_id INTEGER NOT NULL, 
     date DATE, 
     game_id INTEGER NOT NULL , 
     region_id INTEGER NOT NULL , 
     platform_id INTEGER NOT NULL 
    )
GO

ALTER TABLE release ADD CONSTRAINT release_PK PRIMARY KEY CLUSTERED (release_id)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE theme 
    (
     theme_id INTEGER NOT NULL , 
     name NVARCHAR (100) 
    )
GO

ALTER TABLE theme ADD CONSTRAINT theme_PK PRIMARY KEY CLUSTERED (theme_id)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE used_engine 
    (
     used_engine_id INTEGER NOT NULL, 
     game_engine_id INTEGER NOT NULL , 
     game_id INTEGER NOT NULL 
    )
GO

ALTER TABLE used_engine ADD CONSTRAINT used_engine_PK PRIMARY KEY CLUSTERED (used_engine_id)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE used_genre 
    (
     used_genre_id INTEGER NOT NULL , 
     game_id INTEGER NOT NULL , 
     genre_id INTEGER NOT NULL 
    )
GO

ALTER TABLE used_genre ADD CONSTRAINT used_genre_PK PRIMARY KEY CLUSTERED (used_genre_id)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE used_mode 
    (
     used_mode_id INTEGER NOT NULL , 
     game_id INTEGER NOT NULL , 
     game_mode_id INTEGER NOT NULL 
    )
GO

ALTER TABLE used_mode ADD CONSTRAINT used_mode_PK PRIMARY KEY CLUSTERED (used_mode_id)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE used_perspective 
    (
     used_p_id INTEGER NOT NULL , 
     game_id INTEGER NOT NULL , 
     perspective_id INTEGER NOT NULL 
    )
GO

ALTER TABLE used_perspective ADD CONSTRAINT used_perspective_PK PRIMARY KEY CLUSTERED (used_p_id)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE used_theme 
    (
     used_theme_id INTEGER NOT NULL , 
     theme_id INTEGER NOT NULL , 
     game_id INTEGER NOT NULL 
    )
GO

ALTER TABLE used_theme ADD CONSTRAINT used_theme_PK PRIMARY KEY CLUSTERED (used_theme_id)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE franchise_member
    (
     franchise_member_id INTEGER NOT NULL , 
     franchise_id INTEGER NOT NULL , 
     game_id INTEGER NOT NULL 
    )
GO

ALTER TABLE franchise_member ADD CONSTRAINT franchise_member_PK PRIMARY KEY CLUSTERED (franchise_member_id)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO


ALTER TABLE franchise_member 
    ADD CONSTRAINT franchise_member_FK FOREIGN KEY 
    ( 
     game_id
    ) 
    REFERENCES game 
    ( 
     game_id 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE franchise_member 
    ADD CONSTRAINT franchise_member_FKv2 FOREIGN KEY 
    ( 
     franchise_id
    ) 
    REFERENCES franchise 
    ( 
     franchise_id 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE alternate_title 
    ADD CONSTRAINT alternate_title_game_FK FOREIGN KEY 
    ( 
     game_id
    ) 
    REFERENCES game 
    ( 
     game_id 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE dlc 
    ADD CONSTRAINT dlc_game_FK FOREIGN KEY 
    ( 
     game_id
    ) 
    REFERENCES game 
    ( 
     game_id 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE dlc 
    ADD CONSTRAINT dlc_game_FKv2 FOREIGN KEY 
    ( 
     parent_id
    ) 
    REFERENCES game 
    ( 
     game_id 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE fork 
    ADD CONSTRAINT fork_game_FK FOREIGN KEY 
    ( 
     game_id
    ) 
    REFERENCES game 
    ( 
     game_id 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE fork 
    ADD CONSTRAINT fork_game_FKv2 FOREIGN KEY 
    ( 
     parent_id
    ) 
    REFERENCES game 
    ( 
     game_id 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE game 
    ADD CONSTRAINT game_franchise_FK FOREIGN KEY 
    ( 
     franchise_id
    ) 
    REFERENCES franchise 
    ( 
     franchise_id 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE involved_companie 
    ADD CONSTRAINT involved_companie_company_FK FOREIGN KEY 
    ( 
     company_id
    ) 
    REFERENCES company 
    ( 
     company_id 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE involved_companie 
    ADD CONSTRAINT involved_companie_game_FK FOREIGN KEY 
    ( 
     game_id
    ) 
    REFERENCES game 
    ( 
     game_id 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE language_support 
    ADD CONSTRAINT language_support_game_FK FOREIGN KEY 
    ( 
     game_id
    ) 
    REFERENCES game 
    ( 
     game_id 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE language_support 
    ADD CONSTRAINT language_support_language_FK FOREIGN KEY 
    ( 
     lenguage_id
    ) 
    REFERENCES language 
    ( 
     lenguage_id 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE language_support 
    ADD CONSTRAINT language_support_type_FK FOREIGN KEY 
    ( 
     support_type_id
    ) 
    REFERENCES support_type 
    ( 
     support_type_id 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE re_release 
    ADD CONSTRAINT re_release_game_FK FOREIGN KEY 
    ( 
     game_id
    ) 
    REFERENCES game 
    ( 
     game_id 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE re_release 
    ADD CONSTRAINT re_release_game_FKv2 FOREIGN KEY 
    ( 
     parent_id
    ) 
    REFERENCES game 
    ( 
     game_id 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE release 
    ADD CONSTRAINT release_game_FK FOREIGN KEY 
    ( 
     game_id
    ) 
    REFERENCES game 
    ( 
     game_id 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE release 
    ADD CONSTRAINT release_platform_FK FOREIGN KEY 
    ( 
     platform_id
    ) 
    REFERENCES platform 
    ( 
     platform_id 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE release 
    ADD CONSTRAINT release_region_FK FOREIGN KEY 
    ( 
     region_id
    ) 
    REFERENCES region 
    ( 
     id_region 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE used_engine 
    ADD CONSTRAINT used_engine_game_engine_FK FOREIGN KEY 
    ( 
     game_engine_id
    ) 
    REFERENCES game_engine 
    ( 
     game_engine_id 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE used_engine 
    ADD CONSTRAINT used_engine_game_FK FOREIGN KEY 
    ( 
     game_id
    ) 
    REFERENCES game 
    ( 
     game_id 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE used_genre 
    ADD CONSTRAINT used_genre_game_FK FOREIGN KEY 
    ( 
     game_id
    ) 
    REFERENCES game 
    ( 
     game_id 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE used_genre 
    ADD CONSTRAINT used_genre_genre_FK FOREIGN KEY 
    ( 
     genre_id
    ) 
    REFERENCES genre 
    ( 
     genre_id 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE used_mode 
    ADD CONSTRAINT used_mode_game_FK FOREIGN KEY 
    ( 
     game_id
    ) 
    REFERENCES game 
    ( 
     game_id 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE used_mode 
    ADD CONSTRAINT used_mode_game_mode_FK FOREIGN KEY 
    ( 
     game_mode_id
    ) 
    REFERENCES game_mode 
    ( 
     game_mode_id 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE used_perspective 
    ADD CONSTRAINT used_perspective_game_FK FOREIGN KEY 
    ( 
     game_id
    ) 
    REFERENCES game 
    ( 
     game_id 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE used_perspective 
    ADD CONSTRAINT used_perspective_perspective_FK FOREIGN KEY 
    ( 
     perspective_id
    ) 
    REFERENCES perspective 
    ( 
     perspective_id 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE used_theme 
    ADD CONSTRAINT used_theme_game_FK FOREIGN KEY 
    ( 
     game_id
    ) 
    REFERENCES game 
    ( 
     game_id 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE used_theme 
    ADD CONSTRAINT used_theme_theme_FK FOREIGN KEY 
    ( 
     theme_id
    ) 
    REFERENCES theme 
    ( 
     theme_id 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO