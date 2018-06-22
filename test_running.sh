#!/bin/bash

#nchunks=(1000 10000 100000)
nchunks=(1000)
chunksize=(100000 10000 1000)
#chunksize=(10000 1000 100)

for ((i=0; i<${#nchunks[@]}; i++)) do

dropdb test_q3c
createdb test_q3c
psql test_q3c < `pg_config --sharedir`/contrib/q3c.sql >/dev/null 2>/dev/null
psql test_q3c < test_running.q3c.sql >/dev/null 2>/dev/null
echo "q3c" ${nchunks[$i]} ${chunksize[$i]}
./test_running.pl -d test_q3c -t q3c -n ${nchunks[$i]} -c ${chunksize[$i]} > out_run_q3c_c_${nchunks[$i]}_${chunksize[$i]}

dropdb test_pg
createdb test_pg
psql test_pg < `pg_config --sharedir`/contrib/pg_sphere.sql >/dev/null 2>/dev/null
psql test_pg < test_running.pg.sql >/dev/null 2>/dev/null
echo "pg" ${nchunks[$i]} ${chunksize[$i]}
./test_running.pl -d test_pg -t pg -n ${nchunks[$i]} -c ${chunksize[$i]} > out_run_pg_c_${nchunks[$i]}_${chunksize[$i]}

dropdb test_pg112
createdb test_pg112
psql test_pg112 < `pg_config --sharedir`/contrib/pg_sphere_112.sql >/dev/null 2>/dev/null
psql test_pg112 < test_running.pg.sql >/dev/null 2>/dev/null
echo "pg112" ${nchunks[$i]} ${chunksize[$i]}
./test_running.pl -d test_pg112 -t pg -n ${nchunks[$i]} -c ${chunksize[$i]} > out_run_pg112_c_${nchunks[$i]}_${chunksize[$i]}

dropdb test_pg115
createdb test_pg115
psql test_pg115 < `pg_config --sharedir`/contrib/pg_sphere_115.sql >/dev/null 2>/dev/null
psql test_pg115 < test_running.pg3.sql >/dev/null 2>/dev/null
echo "pg114" ${nchunks[$i]} ${chunksize[$i]}
./test_running.pl -d test_pg115 -t pg -n ${nchunks[$i]} -c ${chunksize[$i]} > out_run_pg115_c_${nchunks[$i]}_${chunksize[$i]}

dropdb test_haversine
createdb test_haversine
psql test_haversine < test_running.haversine.sql >/dev/null 2>/dev/null
echo "pg114" ${nchunks[$i]} ${chunksize[$i]}
./test_running.pl -d test_haversine -t haversine -n ${nchunks[$i]} -c ${chunksize[$i]} > out_run_haversine_c_${nchunks[$i]}_${chunksize[$i]}

dropdb test_postgis
createdb test_postgis
psql test_postgis < `pg_config --sharedir`/contrib/postgis-2.1/postgis.sql >/dev/null 2>/dev/null
psql test_postgis < `pg_config --sharedir`/contrib/postgis-2.1/spatial_ref_sys.sql
psql test_postgis < test_running.postgis.sql >/dev/null 2>/dev/null
echo "postgis" ${nchunks[$i]} ${chunksize[$i]}
./test_running.pl -d test_postgis -t postgis -n ${nchunks[$i]} -c ${chunksize[$i]} > out_run_postgis_c_${nchunks[$i]}_${chunksize[$i]}


done