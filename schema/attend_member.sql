DROP TABLE attend_member;
CREATE TABLE attend_member(
    event_id INTEGER,
    member_id VARCHAR(20),
    page_id INTEGER,
    module_id INTEGER,
    number INTEGER,
    created_datetime DATETIME,
    PRIMARY KEY (event_id, member_id)
);
CREATE INDEX attend_member_idx1 ON attend_member (event_id, number);
CREATE INDEX attend_member_idx2 ON attend_member (member_id, page_id, module_id, created_datetime);
