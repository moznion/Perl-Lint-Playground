#!/bin/sh

env=$1
if [ "$env" != "development" -a "$env" != "production" ]; then
  echo "Not allowed environment is given: $env"
  exit 1
fi

sql_file="$(cd $(dirname $0);pwd)/../sql/mysql.sql"

test_db="perl_lint_playground_test"
echo "DROP DATABASE IF EXISTS $test_db" | mysql
echo "CREATE DATABASE $test_db" | mysql
mysql $test_db < $sql_file

db="perl_lint_playground_$env"
echo "CREATE DATABASE IF NOT EXISTS $db" | mysql
mysql $db < $sql_file

echo "Successful!"
