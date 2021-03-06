#!/bin/bash

#TEST_RUNNING=test_running
TEST_RUNNING=test_running.unlogged

#nchunks=(1000 10000 100000)
nchunks=(1000)
chunksize=(100000 10000 1000)
#chunksize=(10000 1000 100)

for ((i=0; i<${#nchunks[@]}; i++)) do

dropdb test_q3c
createdb test_q3c
echo 'CREATE EXTENSION q3c;' | psql test_q3c
psql test_q3c < ${TEST_RUNNING}.q3c.sql >/dev/null 2>/dev/null
echo "q3c" ${nchunks[$i]} ${chunksize[$i]}
./test_running.pl -d test_q3c -t q3c -n ${nchunks[$i]} -c ${chunksize[$i]} > out_run_q3c_c_${nchunks[$i]}_${chunksize[$i]}
dropdb test_q3c

dropdb test_pg
createdb test_pg
echo 'CREATE EXTENSION pg_sphere;' | psql test_pg
psql test_pg < ${TEST_RUNNING}.pg.sql >/dev/null 2>/dev/null
echo "pg" ${nchunks[$i]} ${chunksize[$i]}
./test_running.pl -d test_pg -t pg -n ${nchunks[$i]} -c ${chunksize[$i]} > out_run_pg_c_${nchunks[$i]}_${chunksize[$i]}
dropdb test_pg

dropdb test_haversine
createdb test_haversine
psql test_haversine < ${TEST_RUNNING}.haversine.sql >/dev/null 2>/dev/null
echo "haversine" ${nchunks[$i]} ${chunksize[$i]}
./test_running.pl -d test_haversine -t haversine -n ${nchunks[$i]} -c ${chunksize[$i]} > out_run_haversine_c_${nchunks[$i]}_${chunksize[$i]}
dropdb test_haversine

dropdb test_postgis
createdb test_postgis
psql test_postgis < `pg_config --sharedir`/contrib/postgis-2.4/postgis.sql >/dev/null 2>/dev/null
psql test_postgis < `pg_config --sharedir`/contrib/postgis-2.4/spatial_ref_sys.sql
psql test_postgis < ${TEST_RUNNING}.postgis.sql >/dev/null 2>/dev/null
echo "postgis" ${nchunks[$i]} ${chunksize[$i]}
./test_running.pl -d test_postgis -t postgis -n ${nchunks[$i]} -c ${chunksize[$i]} > out_run_postgis_c_${nchunks[$i]}_${chunksize[$i]}
dropdb test_postgis

done
