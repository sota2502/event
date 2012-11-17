CREATE TABLE event(
    event_id INTEGER PRIMARY KEY AUTOINCREMENT,
    page_id INTEGER NOT NULL,
    module_id INTEGER NOT NULL,
    title VARCHAR(40),
    description TEXT,
    scheduled_datetime DATETIME,
    created_datetime DATETIME
);
CREATE INDEX event_idx1 ON event (scheduled_datetime);
CREATE INDEX event_idx2 ON event (page_id, module_id, scheduled_datetime);
