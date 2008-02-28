
module sendero.time.data.ZoneInfo;

import sendero.time.internal.TimeZoneImpl;

Rule[] rules = [
	{"Tunisia",[{1,3,0,0,{72000000000}},{1,10,0,0,{72000000000}}],[{36000000000},{0}],0},
	{"Arg",[{0,3,0,15,{-36000000000}},{0,10,0,1,{0}}],[{0},{36000000000}],0},
	{"Thule",[{0,3,0,8,{72000000000}},{0,11,0,1,{36000000000}}],[{36000000000},{0}],0},
	{"Canada",[{0,3,0,8,{72000000000}},{0,11,0,1,{36000000000}}],[{36000000000},{0}],0},
	{"AN",[{0,4,0,1,{72000000000}},{0,10,0,1,{72000000000}}],[{0},{36000000000}],0},
	{"Chile",[{0,3,0,9,{108000000000}},{0,10,0,9,{144000000000}}],[{0},{36000000000}],1},
	{"TC",[{0,3,0,8,{72000000000}},{0,11,0,1,{36000000000}}],[{36000000000},{0}],0},
	{"AS",[{0,4,0,1,{72000000000}},{0,10,0,1,{72000000000}}],[{0},{36000000000}],0},
	{"AT",[{0,4,0,1,{72000000000}},{0,10,0,1,{72000000000}}],[{0},{36000000000}],0},
	{"Brazil",[{0,2,0,15,{-36000000000}},{0,10,0,8,{0}}],[{0},{36000000000}],0},
	{"AV",[{0,4,0,1,{72000000000}},{0,10,0,1,{72000000000}}],[{0},{36000000000}],0},
	{"Mexico",[{0,4,0,1,{72000000000}},{1,10,0,0,{36000000000}}],[{36000000000},{0}],0},
	{"Russia",[{1,3,0,0,{72000000000}},{1,10,0,0,{72000000000}}],[{36000000000},{0}],0},
	{"Chatham",[{0,4,0,1,{99000000000}},{1,9,0,0,{99000000000}}],[{0},{36000000000}],0},
	{"LH",[{0,4,0,1,{54000000000}},{0,10,0,1,{72000000000}}],[{0},{18000000000}],0},
	{"Namibia",[{0,4,0,1,{36000000000}},{0,9,0,1,{72000000000}}],[{0},{36000000000}],0},
	{"ChileAQ",[{0,3,0,9,{108000000000}},{0,10,0,9,{144000000000}}],[{0},{36000000000}],1},
	{"Cuba",[{0,3,0,8,{0}},{1,10,0,0,{0}}],[{36000000000},{0}],0},
	{"US",[{0,3,0,8,{72000000000}},{0,11,0,1,{36000000000}}],[{36000000000},{0}],0},
	{"Uruguay",[{0,3,0,8,{36000000000}},{0,10,0,1,{72000000000}}],[{0},{36000000000}],0},
	{"W-Eur",[{1,3,0,0,{36000000000}},{1,10,0,0,{36000000000}}],[{36000000000},{0}],0},
	{"RussAQ",[{1,3,0,0,{72000000000}},{1,10,0,0,{72000000000}}],[{36000000000},{0}],0},
	{"Para",[{0,3,0,8,{-36000000000}},{0,10,0,15,{0}}],[{0},{36000000000}],0},
	{"EU",[{1,3,0,0,{36000000000}},{1,10,0,0,{36000000000}}],[{36000000000},{0}],1},
	{"E-Eur",[{1,3,0,0,{0}},{1,10,0,0,{-36000000000}}],[{36000000000},{0}],0},
	{"NZAQ",[{0,4,0,1,{72000000000}},{1,9,0,0,{72000000000}}],[{0},{36000000000}],0},
	{"NZ",[{0,4,0,1,{72000000000}},{1,9,0,0,{72000000000}}],[{0},{36000000000}],0},
	{"StJohns",[{0,3,0,8,{600000000}},{0,11,0,1,{-35400000000}}],[{36000000000},{0}],0},
	{"C-Eur",[{1,3,0,0,{72000000000}},{1,10,0,0,{72000000000}}],[{36000000000},{0}],0},
	{"Falk",[{0,4,0,15,{36000000000}},{0,9,0,1,{72000000000}}],[{0},{36000000000}],0},
	{"Egypt",[{1,4,5,0,{0}},{1,8,4,0,{828000000000}}],[{36000000000},{0}],0},
];

ZoneImpl[] zones = [
	{"Etc/UTC",{0},-1,"UTC","UTC"},
	{"Africa/Algiers",{36000000000},-1,"",""},
	{"Africa/Luanda",{36000000000},-1,"",""},
	{"Africa/Porto-Novo",{36000000000},-1,"",""},
	{"Africa/Gaborone",{72000000000},-1,"",""},
	{"Africa/Ouagadougou",{0},-1,"",""},
	{"Africa/Bujumbura",{72000000000},-1,"",""},
	{"Africa/Douala",{36000000000},-1,"",""},
	{"Atlantic/Cape_Verde",{-36000000000},-1,"",""},
	{"Africa/Bangui",{36000000000},-1,"",""},
	{"Africa/Ndjamena",{36000000000},-1,"",""},
	{"Indian/Comoro",{108000000000},-1,"",""},
	{"Africa/Kinshasa",{36000000000},-1,"",""},
	{"Africa/Lubumbashi",{72000000000},-1,"",""},
	{"Africa/Brazzaville",{36000000000},-1,"",""},
	{"Africa/Abidjan",{0},-1,"",""},
	{"Africa/Djibouti",{108000000000},-1,"",""},
	{"Africa/Cairo",{72000000000},30,"",""},
	{"Africa/Malabo",{36000000000},-1,"",""},
	{"Africa/Asmara",{108000000000},-1,"",""},
	{"Africa/Addis_Ababa",{108000000000},-1,"",""},
	{"Africa/Libreville",{36000000000},-1,"",""},
	{"Africa/Banjul",{0},-1,"",""},
	{"Africa/Accra",{0},-1,"",""},
	{"Africa/Conakry",{0},-1,"",""},
	{"Africa/Bissau",{0},-1,"",""},
	{"Africa/Nairobi",{108000000000},-1,"",""},
	{"Africa/Maseru",{72000000000},-1,"",""},
	{"Africa/Monrovia",{0},-1,"",""},
	{"Africa/Tripoli",{72000000000},-1,"",""},
	{"Indian/Antananarivo",{108000000000},-1,"",""},
	{"Africa/Blantyre",{72000000000},-1,"",""},
	{"Africa/Bamako",{0},-1,"",""},
	{"Africa/Nouakchott",{0},-1,"",""},
	{"Indian/Mauritius",{144000000000},-1,"",""},
	{"Indian/Mayotte",{108000000000},-1,"",""},
	{"Africa/Casablanca",{0},-1,"",""},
	{"Africa/El_Aaiun",{0},-1,"",""},
	{"Africa/Maputo",{72000000000},-1,"",""},
	{"Africa/Windhoek",{36000000000},15,"",""},
	{"Africa/Niamey",{36000000000},-1,"",""},
	{"Africa/Lagos",{36000000000},-1,"",""},
	{"Indian/Reunion",{144000000000},-1,"",""},
	{"Africa/Kigali",{72000000000},-1,"",""},
	{"Atlantic/St_Helena",{0},-1,"",""},
	{"Africa/Sao_Tome",{0},-1,"",""},
	{"Africa/Dakar",{0},-1,"",""},
	{"Indian/Mahe",{144000000000},-1,"",""},
	{"Africa/Freetown",{0},-1,"",""},
	{"Africa/Mogadishu",{108000000000},-1,"",""},
	{"Africa/Johannesburg",{72000000000},-1,"",""},
	{"Africa/Khartoum",{108000000000},-1,"",""},
	{"Africa/Mbabane",{72000000000},-1,"",""},
	{"Africa/Dar_es_Salaam",{108000000000},-1,"",""},
	{"Africa/Lome",{0},-1,"",""},
	{"Africa/Tunis",{36000000000},0,"",""},
	{"Africa/Kampala",{108000000000},-1,"",""},
	{"Africa/Lusaka",{72000000000},-1,"",""},
	{"Africa/Harare",{72000000000},-1,"",""},
	{"Antarctica/Casey",{288000000000},-1,"",""},
	{"Antarctica/Davis",{252000000000},-1,"",""},
	{"Antarctica/Mawson",{216000000000},-1,"",""},
	{"Indian/Kerguelen",{180000000000},-1,"",""},
	{"Antarctica/DumontDUrville",{360000000000},-1,"",""},
	{"Antarctica/Syowa",{108000000000},-1,"",""},
	{"Antarctica/Vostok",{216000000000},-1,"",""},
	{"Antarctica/Rothera",{-108000000000},-1,"",""},
	{"Antarctica/Palmer",{-144000000000},16,"",""},
	{"Antarctica/McMurdo",{432000000000},25,"",""},
	{"Australia/Darwin",{342000000000},-1,"",""},
	{"Australia/Perth",{288000000000},-1,"",""},
	{"Australia/Eucla",{315000000000},-1,"",""},
	{"Australia/Brisbane",{360000000000},-1,"",""},
	{"Australia/Lindeman",{360000000000},-1,"",""},
	{"Australia/Adelaide",{342000000000},7,"",""},
	{"Australia/Hobart",{360000000000},8,"",""},
	{"Australia/Currie",{360000000000},8,"",""},
	{"Australia/Melbourne",{360000000000},10,"",""},
	{"Australia/Sydney",{360000000000},4,"",""},
	{"Australia/Broken_Hill",{342000000000},7,"",""},
	{"Australia/Lord_Howe",{378000000000},14,"",""},
	{"Indian/Christmas",{252000000000},-1,"",""},
	{"Pacific/Rarotonga",{-360000000000},-1,"",""},
	{"Indian/Cocos",{234000000000},-1,"",""},
	{"Pacific/Fiji",{432000000000},-1,"",""},
	{"Pacific/Gambier",{-324000000000},-1,"",""},
	{"Pacific/Marquesas",{-342000000000},-1,"",""},
	{"Pacific/Tahiti",{-360000000000},-1,"",""},
	{"Pacific/Guam",{360000000000},-1,"",""},
	{"Pacific/Tarawa",{432000000000},-1,"",""},
	{"Pacific/Enderbury",{468000000000},-1,"",""},
	{"Pacific/Kiritimati",{504000000000},-1,"",""},
	{"Pacific/Saipan",{360000000000},-1,"",""},
	{"Pacific/Majuro",{432000000000},-1,"",""},
	{"Pacific/Kwajalein",{432000000000},-1,"",""},
	{"Pacific/Truk",{360000000000},-1,"",""},
	{"Pacific/Ponape",{396000000000},-1,"",""},
	{"Pacific/Kosrae",{396000000000},-1,"",""},
	{"Pacific/Nauru",{432000000000},-1,"",""},
	{"Pacific/Noumea",{396000000000},-1,"",""},
	{"Pacific/Auckland",{432000000000},26,"",""},
	{"Pacific/Chatham",{459000000000},13,"",""},
	{"Pacific/Niue",{-396000000000},-1,"",""},
	{"Pacific/Norfolk",{414000000000},-1,"",""},
	{"Pacific/Palau",{324000000000},-1,"",""},
	{"Pacific/Port_Moresby",{360000000000},-1,"",""},
	{"Pacific/Pitcairn",{-288000000000},-1,"",""},
	{"Pacific/Pago_Pago",{-396000000000},-1,"",""},
	{"Pacific/Apia",{-396000000000},-1,"",""},
	{"Pacific/Guadalcanal",{396000000000},-1,"",""},
	{"Pacific/Fakaofo",{-360000000000},-1,"",""},
	{"Pacific/Tongatapu",{468000000000},-1,"",""},
	{"Pacific/Funafuti",{432000000000},-1,"",""},
	{"Pacific/Johnston",{-360000000000},-1,"",""},
	{"Pacific/Midway",{-396000000000},-1,"",""},
	{"Pacific/Wake",{432000000000},-1,"",""},
	{"Pacific/Efate",{396000000000},-1,"",""},
	{"Pacific/Wallis",{432000000000},-1,"",""},
	{"Europe/London",{0},23,"",""},
	{"Europe/Dublin",{0},23,"",""},
	{"WET",{0},23,"",""},
	{"CET",{36000000000},28,"",""},
	{"MET",{36000000000},28,"",""},
	{"EET",{72000000000},23,"",""},
	{"Europe/Tirane",{36000000000},23,"",""},
	{"Europe/Andorra",{36000000000},23,"",""},
	{"Europe/Vienna",{36000000000},23,"",""},
	{"Europe/Minsk",{72000000000},12,"",""},
	{"Europe/Brussels",{36000000000},23,"",""},
	{"Europe/Sofia",{72000000000},23,"",""},
	{"Europe/Prague",{36000000000},23,"",""},
	{"Europe/Copenhagen",{36000000000},23,"",""},
	{"Atlantic/Faroe",{0},23,"",""},
	{"America/Danmarkshavn",{0},-1,"",""},
	{"America/Scoresbysund",{-36000000000},23,"",""},
	{"America/Godthab",{-108000000000},23,"",""},
	{"America/Thule",{-144000000000},2,"",""},
	{"Europe/Tallinn",{72000000000},23,"",""},
	{"Europe/Helsinki",{72000000000},23,"",""},
	{"Europe/Paris",{36000000000},23,"",""},
	{"Europe/Berlin",{36000000000},23,"",""},
	{"Europe/Gibraltar",{36000000000},23,"",""},
	{"Europe/Athens",{72000000000},23,"",""},
	{"Europe/Budapest",{36000000000},23,"",""},
	{"Atlantic/Reykjavik",{0},-1,"",""},
	{"Europe/Rome",{36000000000},23,"",""},
	{"Europe/Riga",{72000000000},23,"",""},
	{"Europe/Vaduz",{36000000000},23,"",""},
	{"Europe/Vilnius",{72000000000},23,"",""},
	{"Europe/Luxembourg",{36000000000},23,"",""},
	{"Europe/Malta",{36000000000},23,"",""},
	{"Europe/Chisinau",{72000000000},23,"",""},
	{"Europe/Monaco",{36000000000},23,"",""},
	{"Europe/Amsterdam",{36000000000},23,"",""},
	{"Europe/Oslo",{36000000000},23,"",""},
	{"Europe/Warsaw",{36000000000},23,"",""},
	{"Europe/Lisbon",{0},23,"",""},
	{"Atlantic/Azores",{-36000000000},23,"",""},
	{"Atlantic/Madeira",{0},23,"",""},
	{"Europe/Bucharest",{72000000000},23,"",""},
	{"Europe/Kaliningrad",{72000000000},12,"",""},
	{"Europe/Moscow",{108000000000},12,"",""},
	{"Europe/Volgograd",{108000000000},12,"",""},
	{"Europe/Samara",{144000000000},12,"",""},
	{"Asia/Yekaterinburg",{180000000000},12,"",""},
	{"Asia/Omsk",{216000000000},12,"",""},
	{"Asia/Novosibirsk",{216000000000},12,"",""},
	{"Asia/Krasnoyarsk",{252000000000},12,"",""},
	{"Asia/Irkutsk",{288000000000},12,"",""},
	{"Asia/Yakutsk",{324000000000},12,"",""},
	{"Asia/Vladivostok",{360000000000},12,"",""},
	{"Asia/Sakhalin",{360000000000},12,"",""},
	{"Asia/Magadan",{396000000000},12,"",""},
	{"Asia/Kamchatka",{432000000000},12,"",""},
	{"Asia/Anadyr",{432000000000},12,"",""},
	{"Europe/Belgrade",{36000000000},23,"",""},
	{"Europe/Madrid",{36000000000},23,"",""},
	{"Africa/Ceuta",{36000000000},23,"",""},
	{"Atlantic/Canary",{0},23,"",""},
	{"Europe/Stockholm",{36000000000},23,"",""},
	{"Europe/Zurich",{36000000000},23,"",""},
	{"Europe/Istanbul",{72000000000},23,"",""},
	{"Europe/Kiev",{72000000000},23,"",""},
	{"Europe/Uzhgorod",{72000000000},23,"",""},
	{"Europe/Zaporozhye",{72000000000},23,"",""},
	{"Europe/Simferopol",{72000000000},23,"",""},
	{"EST",{-180000000000},-1,"",""},
	{"MST",{-252000000000},-1,"",""},
	{"HST",{-360000000000},-1,"",""},
	{"EST5EDT",{-180000000000},18,"",""},
	{"CST6CDT",{-216000000000},18,"",""},
	{"MST7MDT",{-252000000000},18,"",""},
	{"PST8PDT",{-288000000000},18,"",""},
	{"America/New_York",{-180000000000},18,"",""},
	{"America/Chicago",{-216000000000},18,"",""},
	{"America/North_Dakota/Center",{-216000000000},18,"",""},
	{"America/North_Dakota/New_Salem",{-216000000000},18,"",""},
	{"America/Denver",{-252000000000},18,"",""},
	{"America/Los_Angeles",{-288000000000},18,"",""},
	{"America/Juneau",{-324000000000},18,"",""},
	{"America/Yakutat",{-324000000000},18,"",""},
	{"America/Anchorage",{-324000000000},18,"",""},
	{"America/Nome",{-324000000000},18,"",""},
	{"America/Adak",{-360000000000},18,"",""},
	{"Pacific/Honolulu",{-360000000000},-1,"",""},
	{"America/Phoenix",{-252000000000},-1,"",""},
	{"America/Boise",{-252000000000},18,"",""},
	{"America/Indiana/Indianapolis",{-180000000000},18,"",""},
	{"America/Indiana/Marengo",{-180000000000},18,"",""},
	{"America/Indiana/Vincennes",{-180000000000},18,"",""},
	{"America/Indiana/Tell_City",{-216000000000},18,"",""},
	{"America/Indiana/Petersburg",{-180000000000},18,"",""},
	{"America/Indiana/Knox",{-216000000000},18,"",""},
	{"America/Indiana/Winamac",{-180000000000},18,"",""},
	{"America/Indiana/Vevay",{-180000000000},18,"",""},
	{"America/Kentucky/Louisville",{-180000000000},18,"",""},
	{"America/Kentucky/Monticello",{-180000000000},18,"",""},
	{"America/Detroit",{-180000000000},18,"",""},
	{"America/Menominee",{-216000000000},18,"",""},
	{"America/St_Johns",{-126000000000},27,"",""},
	{"America/Goose_Bay",{-144000000000},27,"",""},
	{"America/Halifax",{-144000000000},3,"",""},
	{"America/Glace_Bay",{-144000000000},3,"",""},
	{"America/Moncton",{-144000000000},3,"",""},
	{"America/Blanc-Sablon",{-144000000000},-1,"",""},
	{"America/Montreal",{-180000000000},3,"",""},
	{"America/Toronto",{-180000000000},3,"",""},
	{"America/Thunder_Bay",{-180000000000},3,"",""},
	{"America/Nipigon",{-180000000000},3,"",""},
	{"America/Rainy_River",{-216000000000},3,"",""},
	{"America/Atikokan",{-180000000000},-1,"",""},
	{"America/Winnipeg",{-216000000000},3,"",""},
	{"America/Regina",{-216000000000},-1,"",""},
	{"America/Swift_Current",{-216000000000},-1,"",""},
	{"America/Edmonton",{-252000000000},3,"",""},
	{"America/Vancouver",{-288000000000},3,"",""},
	{"America/Dawson_Creek",{-252000000000},-1,"",""},
	{"America/Pangnirtung",{-180000000000},3,"",""},
	{"America/Iqaluit",{-180000000000},3,"",""},
	{"America/Resolute",{-180000000000},-1,"",""},
	{"America/Rankin_Inlet",{-216000000000},3,"",""},
	{"America/Cambridge_Bay",{-252000000000},3,"",""},
	{"America/Yellowknife",{-252000000000},3,"",""},
	{"America/Inuvik",{-252000000000},3,"",""},
	{"America/Whitehorse",{-288000000000},3,"",""},
	{"America/Dawson",{-288000000000},3,"",""},
	{"America/Cancun",{-216000000000},11,"",""},
	{"America/Merida",{-216000000000},11,"",""},
	{"America/Monterrey",{-216000000000},11,"",""},
	{"America/Mexico_City",{-216000000000},11,"",""},
	{"America/Chihuahua",{-252000000000},11,"",""},
	{"America/Hermosillo",{-252000000000},-1,"",""},
	{"America/Mazatlan",{-252000000000},11,"",""},
	{"America/Tijuana",{-288000000000},11,"",""},
	{"America/Anguilla",{-144000000000},-1,"",""},
	{"America/Antigua",{-144000000000},-1,"",""},
	{"America/Nassau",{-180000000000},18,"",""},
	{"America/Barbados",{-144000000000},-1,"",""},
	{"America/Belize",{-216000000000},-1,"",""},
	{"Atlantic/Bermuda",{-144000000000},18,"",""},
	{"America/Cayman",{-180000000000},-1,"",""},
	{"America/Costa_Rica",{-216000000000},-1,"",""},
	{"America/Havana",{-180000000000},17,"",""},
	{"America/Dominica",{-144000000000},-1,"",""},
	{"America/Santo_Domingo",{-144000000000},-1,"",""},
	{"America/El_Salvador",{-216000000000},-1,"",""},
	{"America/Grenada",{-144000000000},-1,"",""},
	{"America/Guadeloupe",{-144000000000},-1,"",""},
	{"America/Guatemala",{-216000000000},-1,"",""},
	{"America/Port-au-Prince",{-180000000000},-1,"",""},
	{"America/Tegucigalpa",{-216000000000},-1,"",""},
	{"America/Jamaica",{-180000000000},-1,"",""},
	{"America/Martinique",{-144000000000},-1,"",""},
	{"America/Montserrat",{-144000000000},-1,"",""},
	{"America/Managua",{-216000000000},-1,"",""},
	{"America/Panama",{-180000000000},-1,"",""},
	{"America/Puerto_Rico",{-144000000000},-1,"",""},
	{"America/St_Kitts",{-144000000000},-1,"",""},
	{"America/St_Lucia",{-144000000000},-1,"",""},
	{"America/Miquelon",{-108000000000},3,"",""},
	{"America/St_Vincent",{-144000000000},-1,"",""},
	{"America/Grand_Turk",{-180000000000},6,"",""},
	{"America/Tortola",{-144000000000},-1,"",""},
	{"America/St_Thomas",{-144000000000},-1,"",""},
	{"America/Argentina/Buenos_Aires",{-108000000000},1,"",""},
	{"America/Argentina/Cordoba",{-108000000000},1,"",""},
	{"America/Argentina/Tucuman",{-108000000000},1,"",""},
	{"America/Argentina/La_Rioja",{-108000000000},1,"",""},
	{"America/Argentina/San_Juan",{-108000000000},1,"",""},
	{"America/Argentina/Jujuy",{-108000000000},1,"",""},
	{"America/Argentina/Catamarca",{-108000000000},1,"",""},
	{"America/Argentina/Mendoza",{-108000000000},1,"",""},
	{"America/Argentina/Rio_Gallegos",{-108000000000},1,"",""},
	{"America/Argentina/Ushuaia",{-108000000000},1,"",""},
	{"America/Aruba",{-144000000000},-1,"",""},
	{"America/La_Paz",{-144000000000},-1,"",""},
	{"America/Noronha",{-72000000000},-1,"",""},
	{"America/Belem",{-108000000000},-1,"",""},
	{"America/Fortaleza",{-108000000000},-1,"",""},
	{"America/Recife",{-108000000000},-1,"",""},
	{"America/Araguaina",{-108000000000},-1,"",""},
	{"America/Maceio",{-108000000000},-1,"",""},
	{"America/Bahia",{-108000000000},-1,"",""},
	{"America/Sao_Paulo",{-108000000000},9,"",""},
	{"America/Campo_Grande",{-144000000000},9,"",""},
	{"America/Cuiaba",{-144000000000},9,"",""},
	{"America/Porto_Velho",{-144000000000},-1,"",""},
	{"America/Boa_Vista",{-144000000000},-1,"",""},
	{"America/Manaus",{-144000000000},-1,"",""},
	{"America/Eirunepe",{-180000000000},-1,"",""},
	{"America/Rio_Branco",{-180000000000},-1,"",""},
	{"America/Santiago",{-144000000000},5,"",""},
	{"Pacific/Easter",{-216000000000},5,"",""},
	{"America/Bogota",{-180000000000},-1,"",""},
	{"America/Curacao",{-144000000000},-1,"",""},
	{"America/Guayaquil",{-180000000000},-1,"",""},
	{"Pacific/Galapagos",{-216000000000},-1,"",""},
	{"Atlantic/Stanley",{-144000000000},29,"",""},
	{"America/Cayenne",{-108000000000},-1,"",""},
	{"America/Guyana",{-144000000000},-1,"",""},
	{"America/Asuncion",{-144000000000},22,"",""},
	{"America/Lima",{-180000000000},-1,"",""},
	{"Atlantic/South_Georgia",{-72000000000},-1,"",""},
	{"America/Paramaribo",{-108000000000},-1,"",""},
	{"America/Port_of_Spain",{-144000000000},-1,"",""},
	{"America/Montevideo",{-108000000000},19,"",""},
	{"America/Caracas",{-162000000000},-1,"",""},
];
