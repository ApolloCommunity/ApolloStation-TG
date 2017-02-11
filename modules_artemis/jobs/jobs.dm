//Department Flags FUCK BITSSHIFTS!! ~rj
var/const/CIVILIAN 		= "CIV"
var/const/CAPTAIN		= "CAP"
var/const/HOP			= "HOP"
var/const/IAA			= "IAA"
var/const/BARTENDER		= "BAR"
var/const/BOTANIST		= "BOT"
var/const/COOK			= "COO"
var/const/JANITOR		= "JAN"
var/const/LIBRARIAN		= "LIB"
var/const/CHAPLAIN		= "CHA"
var/const/ASSISTANT		= "ASS"
var/const/MIME			= "MIM"
var/const/CLOWN			= "CLO"

var/const/ENG 				= "ENG"
var/const/CHIEF				= "CHI"
var/const/SENIORENGINEER	= "SEE"
var/const/ENGINEER			= "ENG"


var/const/SEC 				= "SEC"
var/const/HOS				= "HOS"
var/const/WARDEN			= "WAR"
var/const/DETECTIVE			= "DET"
var/const/OFFICER			= "OFF"


var/const/CARGO 			= "CAR"
var/const/QUARTERMASTER		= "QUA"
var/const/FOREMAN			= "FOR"
var/const/CARGOTECH			= "CAR"
var/const/MINER				= "MIN"


var/const/MED 			= "MED"
var/const/CMO			= "CMO"
var/const/SENIORDOCTOR	= "SED"
var/const/DOCTOR		= "DOC"


var/const/SCI 			= "SCI"
var/const/RD				= "SRD"
var/const/SENIORSCIENTIST	= "SES"
var/const/SCIENTIST			= "SCI"


var/const/SOLGOV 		= "SOL"
var/const/SOLGOVAGENT	= "SOA"

var/const/SILICON 		= "SIL"
var/const/AI			= "SAI"
var/const/CYBORG		= "CYB"


var/list/assistant_occupations = list(
	"Assistant",
	"Cargo Technician",
	"Chaplain",
	"Lawyer",
	"Librarian"
)


var/list/command_positions = list(
	"Captain",
	"Head of Personnel",
	"Head of Security",
	"Chief Engineer",
	"Research Director",
	"Chief Medical Officer",
	"Internal Affairs Agent"
)


var/list/engineering_positions = list(
	"Chief Engineer",
	"Senior Engineer",
	"Station Engineer"
)


var/list/medical_positions = list(
	"Chief Medical Officer",
	"Senior Medical Doctor",
	"Medical Doctor"
)


var/list/science_positions = list(
	"Research Director",
	"Senior Scientist",
	"Scientist"
)


var/list/supply_positions = list(
	"Quartermaster",
	"Mining Foreman",
	"Cargo Technician",
	"Shaft Miner"
)


var/list/civilian_positions = list(
	"Head of Personnel",
	"Internal Affairs Agent",
	"Bartender",
	"Botanist",
	"Cook",
	"Janitor",
	"Librarian",
	"Chaplain",
	"Entertainer",
	"Assistant"
)


var/list/security_positions = list(
	"Head of Security",
	"Warden",
	"Detective",
	"Security Officer",
)


var/list/nonhuman_positions = list(
	"AI",
	"Cyborg",
	"pAI"
)

var/list/external_positions = list(
	"SolGov Representative"
)

/proc/guest_jobbans(job)
	return ((job in command_positions) || (job in nonhuman_positions) || (job in security_positions))


//this is necessary because antags happen before job datums are handed out, but NOT before they come into existence
//so I can't simply use job datum.department_head straight from the mind datum, laaaaame.
/proc/get_department_heads(var/job_title)
	if(!job_title)
		return list()

	for(var/datum/job/J in SSjob.occupations)
		if(J.title == job_title)
			return J.department_head //this is a list

var/static/regex/cap_expand = new("cap(?!tain)")
var/static/regex/cmo_expand = new("cmo")
var/static/regex/hos_expand = new("hos")
var/static/regex/hop_expand = new("hop")
var/static/regex/rd_expand = new("rd")
var/static/regex/ce_expand = new("ce")
var/static/regex/qm_expand = new("qm")
var/static/regex/sec_expand = new("(?<!security )officer")
var/static/regex/engi_expand = new("(?<!station )engineer")
var/static/regex/atmos_expand = new("atmos tech")
var/static/regex/doc_expand = new("(?<!medical )doctor|medic(?!al)")
var/static/regex/mine_expand = new("(?<!shaft )miner")
var/static/regex/chef_expand = new("chef")
var/static/regex/borg_expand = new("(?<!cy)borg")

//Promotions system
var/list/allJobDatums


/proc/get_full_job_name(job)
	job = lowertext(job)
	job = cap_expand.Replace(job, "captain")
	job = cmo_expand.Replace(job, "chief medical officer")
	job = hos_expand.Replace(job, "head of security")
	job = hop_expand.Replace(job, "head of personnel")
	job = rd_expand.Replace(job, "research director")
	job = ce_expand.Replace(job, "chief engineer")
	job = qm_expand.Replace(job, "quartermaster")
	job = sec_expand.Replace(job, "security officer")
	job = engi_expand.Replace(job, "station engineer")
	job = atmos_expand.Replace(job, "atmospheric technician")
	job = doc_expand.Replace(job, "medical doctor")
	job = mine_expand.Replace(job, "shaft miner")
	job = chef_expand.Replace(job, "cook")
	job = borg_expand.Replace(job, "cyborg")
	return job