CREATE TABLE system_limit (
    main_id TEXT NOT NULL,
    water_limit REAL NOT NULL
);

CREATE TABLE system_running (
    main_id TEXT NOT NULL,
    running INTEGER NOT NULL
);

CREATE TABLE system_liters (
    main_id TEXT NOT NULL,
    liters REAL NOT NULL
);

CREATE TABLE system_current (
    main_id TEXT NOT NULL,
    liters REAL NOT NULL
);

INSERT INTO system_limit (main_id, water_limit)
VALUES("main", 1);

INSERT INTO system_running (main_id, running)
VALUES("main", 0);

INSERT INTO system_liters (main_id, liters)
VALUES("main", 0);

INSERT INTO system_current (main_id, liters)
VALUES("main", 1);