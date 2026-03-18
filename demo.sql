-- try https://playcode.io/sql-editor
-- for a new connection, refresh the page, and disable auto-run

-- show all indexes
SELECT
    tablename,
    indexname,
    indexdef
FROM
    pg_indexes
WHERE
    schemaname = 'public'
ORDER BY
    tablename,
    indexname;

-- show indexes of albums table
SELECT
    indexname,
    indexdef
FROM
    pg_indexes
WHERE
    tablename = 'albums';



-- Estimated cost of the best plan
EXPLAIN select * from albums;



-- actual cost of the best plan after execution
EXPLAIN ANALYZE select * from albums;



-- Also show buffer hit/miss stats
EXPLAIN (ANALYZE, BUFFERS) select * from albums;



-- sequential scan for range query
EXPLAIN ANALYZE 
select * from albums
where artist_id <= 5;


-- create index axplicitly 
create index idx_artist_id on albums(artist_id);

-- index scan for range query
EXPLAIN ANALYZE 
select * from albums
where artist_id <= 5;



-- nested loop join
EXPLAIN ANALYZE
select title from albums al, artists ar
where al.artist_id = ar.artist_id
and ar.name LIKE 'A%';


-- without index, effect of in memory data
drop index idx_artist_id;

EXPLAIN ANALYZE
select title from albums al, artists ar
where al.artist_id = ar.artist_id
and ar.name LIKE 'A%';


-- disable nested loop to explicitly use other joins
SET enable_nestloop TO off;
EXPLAIN ANALYZE
select title from albums al, artists ar
where al.artist_id = ar.artist_id
and ar.name LIKE 'A%';


-- disable sort-merge join to see hash join
SET enable_sort TO off;
EXPLAIN ANALYZE
select title from albums al, artists ar
where al.artist_id = ar.artist_id
and ar.name LIKE 'A%';


-- subplan: correlated nested query
EXPLAIN ANALYZE
SELECT a.name
FROM artists a
WHERE (
    SELECT COUNT(*)
    FROM albums al
    WHERE al.artist_id = a.artist_id
) > 1;


-- decorrelate using HAVING clause
EXPLAIN ANALYZE
SELECT a.name
FROM artists a
JOIN albums al ON al.artist_id = a.artist_id
GROUP BY a.artist_id, a.name
HAVING COUNT(al.album_id) > 1;



