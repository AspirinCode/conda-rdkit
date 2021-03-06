$PYTHON setup.py install

export PGPORT=54321
export PGDATA=$SRC_DIR/pgdata

pg_ctl initdb

# ensure that the rdkit extension is loaded at process startup
echo "shared_preload_libraries = 'rdkit'" >> $PGDATA/postgresql.conf

pg_ctl start -l $PGDATA/log.txt

# wait a few seconds just to make sure that the server has started
sleep 5

set +e
$PYTHON runtests.py
check_result=$?
set -e

pg_ctl stop

exit $check_result
