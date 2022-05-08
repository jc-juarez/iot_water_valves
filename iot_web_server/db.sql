CREATE TABLE system_limit (
    main_id TEXT NOT NULL,
    water_limit REAL NOT NULL
);

INSERT INTO system_limit (main_id, water_limit)
VALUES("main", 1);