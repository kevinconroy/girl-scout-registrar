mysql -uroot --local-infile=1 < sql/import.sql
echo "" >> ~/Sites/girl-scout-registrar/import/roster.csv
mysqlimport --replace --ignore-lines=1 --fields-terminated-by=, --verbose --local -uroot girlscouts ~/Sites/girl-scout-registrar/import/roster.csv
mysql -uroot --local-infile=1 < sql/import-manual-fixes.sql
mysql -uroot --local-infile=1 < sql/update.sql

rm -rf /tmp/dashboard.csv
rm -rf /tmp/contacts.csv
rm -rf /tmp/troops.csv
rm -rf /tmp/leader_roster.csv
rm -rf /tmp/troop_roster.csv

rm -rf ./export/
mkdir export

mysql -uroot < sql/export.sql

mv /tmp/dashboard.csv export/dashboard.csv
mv /tmp/contacts.csv export/contacts.csv
mv /tmp/troops.csv export/troops.csv
mv /tmp/leader_roster.csv export/leader_roster.csv
mv /tmp/troop_roster.csv export/troop_roster.csv

cd export
sed -i -e 's/\\N/ /g' dashboard.csv
sed -i -e 's/\\N/ /g' contacts.csv
sed -i -e 's/\\N/ /g' troops.csv
sed -i -e 's/\\N/ /g' leader_roster.csv
sed -i -e 's/\\N/ /g' troop_roster.csv
sed -i -e 's/+/\
/g' troop_roster.csv

echo "🍪🍪 DONE! 🍪🍪"
echo ""

open -a "/Applications/Microsoft Excel.app" contacts.csv
open -a "/Applications/Microsoft Excel.app" troops.csv
open -a "/Applications/Microsoft Excel.app" dashboard.csv
open -a "/Applications/Microsoft Excel.app" leader_roster.csv
open -a "/Applications/Microsoft Excel.app" troop_roster.csv
/usr/bin/open -a "/Applications/Google Chrome.app" 'https://docs.google.com/spreadsheets/d/13gp1s1yCtUGXjNNd-0Bsnc6ymebJU5sbNea6Eudd3m8/edit#gid=515104114'
/usr/bin/open -a "/Applications/Google Chrome.app" 'https://docs.google.com/spreadsheets/d/1A-3b3wnhI2Qrd_txFdKSTC6pn9XMf3LYgcGArXJapF8/edit#gid=0'
