CREATE DATABASE INSPECTION_DB;
USE DATABASE INSPECTION_DB;

CREATE SCHEMA RAW;
USE SCHEMA RAW;

CREATE TABLE PROPERTY (
  property_id STRING,
  property_name STRING,
  city STRING,
  builder STRING
);

CREATE TABLE ROOM (
  room_id STRING,
  property_id STRING,
  room_type STRING
);

CREATE TABLE FINDINGS (
  finding_id STRING,
  room_id STRING,
  finding_text STRING
);

CREATE TABLE IMAGE_TAGS (
  image_id STRING,
  room_id STRING,
  tag STRING,
  confidence FLOAT
);

CREATE OR REPLACE TABLE FINDINGS_CLASSIFIED AS
SELECT
    finding_id,
    room_id,
    finding_text,
    CASE 
        WHEN LOWER(finding_text) LIKE '%crack%' OR LOWER(finding_text) LIKE '%beam%' THEN 'structural'
        WHEN LOWER(finding_text) LIKE '%wiring%' OR LOWER(finding_text) LIKE '%exposed%' THEN 'electrical'
        WHEN LOWER(finding_text) LIKE '%leak%' OR LOWER(finding_text) LIKE '%damp%' THEN 'plumbing'
        WHEN LOWER(finding_text) LIKE '%paint%' OR LOWER(finding_text) LIKE '%tile%' THEN 'finishing'
        ELSE 'ok'
    END AS defect_type,
    CASE
        WHEN LOWER(finding_text) LIKE '%crack%' OR LOWER(finding_text) LIKE '%beam%' OR LOWER(finding_text) LIKE '%wiring%' OR LOWER(finding_text) LIKE '%exposed%' THEN 'high'
        WHEN LOWER(finding_text) LIKE '%leak%' OR LOWER(finding_text) LIKE '%damp%' THEN 'medium'
        ELSE 'low'
    END AS severity
FROM FINDINGS;



CREATE OR REPLACE VIEW ROOM_INSPECTION_VIEW AS
SELECT
    p.property_id,
    p.property_name,
    r.room_id,
    r.room_type,
    f.finding_text,
    f.defect_type,
    f.severity,
    i.tag AS image_tag
FROM PROPERTY p
JOIN ROOM r ON p.property_id = r.property_id
LEFT JOIN FINDINGS_CLASSIFIED f ON r.room_id = f.room_id
LEFT JOIN IMAGE_TAGS i ON r.room_id = i.room_id;


CREATE OR REPLACE VIEW PROPERTY_RISK AS
SELECT
    room_id,
    property_id,
    SUM(
        CASE
            WHEN defect_type IN ('structural','electrical') THEN 5
            WHEN defect_type = 'plumbing' THEN 4
            WHEN defect_type = 'finishing' THEN 2
            ELSE 0
        END
    ) AS room_risk_score
FROM ROOM_INSPECTION_VIEW
GROUP BY room_id, property_id;

CREATE OR REPLACE VIEW PROPERTY_RISK AS
SELECT
    property_id,
    AVG(room_risk_score) AS property_risk_score
FROM ROOM_RISK
GROUP BY property_id;


Delete from property;
delete from findings;
delete from image_tags;
delete from room;