
use girlscouts;

insert into roster (su, troop_id, role, first, last, email) values
("SU 32-1", "02078", "First Aider", "Kelli", "Giffin", "kelligiffin@yahoo.com"),
("SU 32-1", "02078", "Troop Money Manager", "Leah", "Montas", "lbmontas@yahoo.com"),
("SU 32-1", "02078", "Troop Fall Product Manager", "Leah", "Montas", "lbmontas@yahoo.com"),
("SU 32-1", "02078", "Troop Cookie Manager", "Heidy", "Foelsch", "heidyfoelsch@gmail.com"),
("SU 32-1", "02078", "Campout/Cookout Certified Adult", "Leah", "Montas", "lbmontas@yahoo.com"),


("SU 32-1", "00106", "First Aider", "Vicky", "Schneider", "schneidv69@gmail.com"),
("SU 32-1", "00106", "Troop Money Manager", "Julie", "Simmans", "unknown@unknown.com"),
("SU 32-1", "00106", "Troop Fall Product Manager", "Vicky", "Schneider", "schneidv69@gmail.com"),
("SU 32-1", "00106", "Campout/Cookout Certified Adult", "Vicky", "Schneider", "schneidv69@gmail.com"),


("SU 32-1", "02756", "Troop Money Manager", "Karen", "Rondeau", "karensrondeau@aol.com"),

("SU 32-1", "5000", "Troop Cookie Manager", "Heidi", "Kelly", "unknonw@unknown.com"),
("SU 32-1", "5000", "Troop Cookie Manager", "Alysha", "Digiorgio", "diglight@aol.com"),

("SU 32-1", "32002", "Troop Cookie Manager", "Jaclyn", "Fireison", "jcfcjf2010@gmail.com"),
("SU 32-1", "32002", "Campout/Cookout Certified Adult", "Melissa", "Porter", "rancorswife@yahoo.com"),

("SU 32-1", "32010", "Troop Fall Product Manager", "Aurora", "Sanchez", "aurorasan99@gmail.com");


update roster set email="heidyfoelsch@gmail.com" where email like "hfoelsch@%.net";

update roster set email="cjthomas_35@gmail.com" where email="cjthomas_35@yahoo.com";
