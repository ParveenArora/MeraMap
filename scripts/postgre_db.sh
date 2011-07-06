


psql -d template1 < db.sh

psql -f /usr/share/postgresql/8.4/contrib/postgis.sql -d meramap_dba
echo "ALTER TABLE geometry_columns OWNER TO username; ALTER TABLE spatial_ref_sys OWNER TO meramap_user;" | psql -d meramap_dba
psql -f /usr/share/postgresql/8.4/contrib/_int.sql -d meramap_dba
psql -f 900913.sql -d meramap_dba
