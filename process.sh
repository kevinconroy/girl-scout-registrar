mysql -uroot < sql/import.sql
mysqlimport --replace --ignore-lines=1 --fields-terminated-by=, --verbose --local -uroot girlscouts import/roster.csv
mysql -uroot < sql/update.sql

rm -rf ./export/
mkdir export

mysql -uroot < sql/export.sql

mv /tmp/dashboard.csv export/dashboard.csv
mv /tmp/contacts.csv export/contacts.csv
mv /tmp/troops.csv export/troops.csv

cd export
sed -i -e 's/\\N/ /g' dashboard.csv
sed -i -e 's/\\N/ /g' contacts.csv
sed -i -e 's/\\N/ /g' troops.csv

echo "🍪🍪 DONE! 🍪🍪"
