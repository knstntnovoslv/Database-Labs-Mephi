-- WITH (OIDS=FLASE) - Указание, что строки таблицы не содержат OIDS
-- OIDS используется в качестве первичных ключей для таблиц(беззнаковое 4-байтовое число)
-- Он выключён по умолчанию с 9+ версии PostgreSQL

SET lc_monetary TO "ru_RU.UTF-8";

CREATE TABLE IF NOT EXISTS artist (
    -- Задание полей таблицы
	id SERIAL NOT NULL,
	name VARCHAR(255) NOT NULL,
	multiplier_platform NUMERIC(5, 2) DEFAULT 0 NOT NULL,
	multiplier_concert NUMERIC(5, 2) DEFAULT 0 NOT NULL,
	nickname VARCHAR(255) NOT NULL,
	-- Задание ограничений целостности(с установкой имени ограничений)
	CONSTRAINT artist_pk PRIMARY KEY (id),
	CONSTRAINT artist_nickname UNIQUE (nickname),
	CONSTRAINT range_multiplier_platform CHECK (multiplier_platform >= 0 AND multiplier_platform <= 100),
	CONSTRAINT range_multiplier_concert CHECK (multiplier_concert >= 0 AND multiplier_concert <= 100)
);


CREATE TABLE IF NOT EXISTS album (
    -- Задание полей таблицы
	id SERIAL NOT NULL,
	name VARCHAR(255) NOT NULL,
	release_date TIMESTAMP NOT NULL,
	-- Задание ограничений целостности(с установкой имени ограничений)
	CONSTRAINT album_pk PRIMARY KEY (id),
	CONSTRAINT real_album_name CHECK (name != '')
);



CREATE TABLE IF NOT EXISTS concert (
    -- Задание полей таблицы
	id SERIAL NOT NULL,
	city VARCHAR(255) NOT NULL,
	artist_id INTEGER NOT NULL,
	concert_date TIMESTAMP NOT NULL,
	profit MONEY NOT NULL,
	expenditure MONEY NOT NULL,
	profit_plan MONEY NOT NULL,
	expenditure_plan MONEY NOT NULL,
	-- Задание ограничений целостности(с установкой имени ограничений)
	CONSTRAINT concert_pk PRIMARY KEY (id),
	CONSTRAINT positive_profit CHECK (profit::NUMERIC > 0),
	CONSTRAINT positive_expenditure CHECK (expenditure::NUMERIC > 0),
	CONSTRAINT positive_profit_plan CHECK (profit_plan::NUMERIC > 0),
	CONSTRAINT positive_expenditure_plan CHECK (expenditure_plan::NUMERIC > 0),
	-- Задание внешних ключей
	CONSTRAINT concert_fk0 FOREIGN KEY (artist_id) REFERENCES artist(id)
);

CREATE TABLE IF NOT EXISTS genre (
    -- Задание полей таблицы
	id SERIAL NOT NULL,
	name VARCHAR(255) NOT NULL,
	-- Задание ограничений целостности(с установкой имени ограничений)
	CONSTRAINT genre_pk PRIMARY KEY (id),
	CONSTRAINT real_genre CHECK (name != ''),
	CONSTRAINT unique_genre UNIQUE (name)
);


CREATE TABLE IF NOT EXISTS song (
    -- Задание полей таблицы
	id SERIAL NOT NULL,
	name VARCHAR(255) NOT NULL,
	artist_id INTEGER NOT NULL,
	genre_id INTEGER NOT NULL,
	album_id INTEGER NOT NULL,
	-- Задание ограничений целостности(с установкой имени ограничений)
	CONSTRAINT song_pk PRIMARY KEY (id),
	-- Задание внешних ключей
    CONSTRAINT song_fk0 FOREIGN KEY (artist_id) REFERENCES artist(id),
    CONSTRAINT song_fk1 FOREIGN KEY (genre_id) REFERENCES genre(id),
    CONSTRAINT song_fk2 FOREIGN KEY (album_id) REFERENCES album(id)
);



CREATE TABLE IF NOT EXISTS platform (
    -- Задание полей таблицы
	id SERIAL NOT NULL,
	name VARCHAR(255) NOT NULL,
	auditions_times INTEGER NOT NULL, -- Кол-во прослушиваний
	amount MONEY NOT NULL, -- Деньги за данное кол-во прослушиваний
	-- Задание ограничений целостности(с установкой имени ограничений)
	CONSTRAINT platform_pk PRIMARY KEY (id),
	CONSTRAINT positive_amount CHECK (amount::NUMERIC > 0),
	CONSTRAINT positive_auditions_times CHECK (auditions_times > 0)
);

CREATE TABLE IF NOT EXISTS profit_types (
    -- Задание полей таблицы
	id SERIAL NOT NULL,
	name VARCHAR(255) NOT NULL,
	-- Задание ограничений целостности(с установкой имени ограничений)
	CONSTRAINT profit_types_pk PRIMARY KEY (id),
	CONSTRAINT real_name CHECK (name != '')
);



CREATE TABLE IF NOT EXISTS expenditure_types (
    -- Задание полей таблицы
	id SERIAL NOT NULL,
	name VARCHAR(255) NOT NULL,
	-- Задание ограничений целостности(с установкой имени ограничений)
	CONSTRAINT expenditure_types_pk PRIMARY KEY (id),
	CONSTRAINT real_name CHECK (name != '')
);


CREATE TABLE IF NOT EXISTS profit (
    -- Задание полей таблицы
	id SERIAL NOT NULL,
	type_id INTEGER NOT NULL,
	amount MONEY NOT NULL,
	artist_id INTEGER,
	platform_id INTEGER,
	date TIMESTAMP NOT NULL,
	-- Задание ограничений целостности(с установкой имени ограничений)
	CONSTRAINT profit_pk PRIMARY KEY (id),
	CONSTRAINT positive_amount CHECK (amount::NUMERIC > 0),
	-- Задание внешних ключей
    CONSTRAINT profit_fk0 FOREIGN KEY (type_id) REFERENCES profit_types(id),
    CONSTRAINT profit_fk1 FOREIGN KEY (platform_id) REFERENCES platform(id),
    CONSTRAINT profit_fk2 FOREIGN KEY (artist_id) REFERENCES artist(id)
);



CREATE TABLE IF NOT EXISTS expenditure (
    -- Задание полей таблицы
	id SERIAL NOT NULL,
	type_id INTEGER NOT NULL,
	amount DECIMAL NOT NULL,
	platform_id INTEGER,
	artist_id INTEGER,
	date TIMESTAMP NOT NULL,
	-- Задание ограничений целостности(с установкой имени ограничений)
	CONSTRAINT expenditure_pk PRIMARY KEY (id),
	CONSTRAINT positive_amount CHECK (amount::NUMERIC > 0),
	-- Задание внешних ключей
    CONSTRAINT expenditure_fk0 FOREIGN KEY (type_id) REFERENCES expenditure_types(id),
    CONSTRAINT expenditure_fk1 FOREIGN KEY (platform_id) REFERENCES platform(id),
    CONSTRAINT expenditure_fk2 FOREIGN KEY (artist_id) REFERENCES artist(id)
);



CREATE TABLE IF NOT EXISTS song_platform (
    -- Задание полей таблицы
	song_id INTEGER NOT NULL,
	platform_id INTEGER NOT NULL,
	auditions_times INTEGER NOT NULL,
	-- Задание ограничений целостности(с установкой имени ограничений)
	CONSTRAINT song_platform_pk PRIMARY KEY (song_id, platform_id),
	CONSTRAINT positive_auditions_times CHECK (auditions_times > 0),
	-- Задание внешних ключей
    CONSTRAINT song_platform_fk0 FOREIGN KEY (song_id) REFERENCES song(id),
    CONSTRAINT song_platform_fk1 FOREIGN KEY (platform_id) REFERENCES platform(id)
);