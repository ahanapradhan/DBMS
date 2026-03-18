create table class_album (like albums);

-- bitmap heap scan
explain analyze 
select album_id from
class_album;
