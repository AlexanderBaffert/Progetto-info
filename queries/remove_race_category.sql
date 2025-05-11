-- Script to remove race bike category

BEGIN TRANSACTION;

-- 1. First, get the IDs of race bikes (currently ID 21-22)
SELECT id, model FROM Bikes WHERE id BETWEEN 21 AND 22;

-- 2. Delete associated data
-- Delete images for race bikes
DELETE FROM Image WHERE bike_id IN (21, 22);

-- Delete descriptions for race bikes
DELETE FROM Description WHERE bike_id IN (21, 22);

-- Delete colors for race bikes
DELETE FROM Color WHERE bike_id IN (21, 22);

-- 3. Finally delete the race bikes themselves
DELETE FROM Bikes WHERE id IN (21, 22);

COMMIT;
