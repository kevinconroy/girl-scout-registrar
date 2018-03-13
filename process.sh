mysql -uroot < sql/import.sql
mysqlimport --replace --ignore-lines=1 --fields-terminated-by=, --verbose --local -uroot girlscouts import/roster.csv
mysql -uroot < sql/update.sql

rm -rf ./export/
mkdir export

mysql -uroot < sql/export.sql

mv /tmp/dashboard.csv export/dashboard.csv
mv /tmp/contacts.csv export/contacts.csv
mv /tmp/troops.csv export/troops.csv
mv /tmp/leader_roster.csv export/leader_roster.csv

cd export
sed -i -e 's/\\N/ /g' dashboard.csv
sed -i -e 's/\\N/ /g' contacts.csv
sed -i -e 's/\\N/ /g' troops.csv
sed -i -e 's/\\N/ /g' leader_roster.csv

echo "🍪🍪 DONE! 🍪🍪"
echo ""

open contacts.csv
open troops.csv
open dashboard.csv
open leader_roster.csv
/usr/bin/open -a "/Applications/Google Chrome.app" 'https://docs.google.com/spreadsheets/d/13gp1s1yCtUGXjNNd-0Bsnc6ymebJU5sbNea6Eudd3m8/edit#gid=515104114'
/usr/bin/open -a "/Applications/Google Chrome.app" 'https://docs.google.com/spreadsheets/d/1A-3b3wnhI2Qrd_txFdKSTC6pn9XMf3LYgcGArXJapF8/edit#gid=0'
