
var/const/ENG				=(1<<0)

var/const/CHIEF				=(1<<0)
var/const/SENIORENGINEER	=(1<<1)
var/const/ENGINEER			=(1<<2)


var/const/SEC				=(1<<1)

var/const/HOS				=(1<<0)
var/const/WARDEN			=(1<<1)
var/const/DETECTIVE			=(1<<2)
var/const/OFFICER			=(1<<3)


var/const/MED				=(1<<2)

var/const/CMO				=(1<<0)
var/const/SENIORDOCTOR		=(1<<1)
var/const/DOCTOR			=(1<<2)


var/const/SCI				=(1<<3)

var/const/RD				=(1<<0)
var/const/SENIORSCIENTIST	=(1<<1)
var/const/SCIENTIST			=(1<<2)


var/const/CIVILIAN			=(1<<4)

var/const/CAPTAIN			=(1<<0)
var/const/HOP				=(1<<1)
var/const/IAA				=(1<<2)
var/const/BARTENDER			=(1<<3)
var/const/BOTANIST			=(1<<4)
var/const/COOK				=(1<<5)
var/const/JANITOR			=(1<<6)
var/const/LIBRARIAN			=(1<<7)
var/const/CHAPLAIN			=(1<<8)
var/const/ASSISTANT			=(1<<9)


var/const/CARGO				=(1<<5)

var/const/QUARTERMASTER		=(1<<0)
var/const/FOREMAN			=(1<<1)
var/const/CARGOTECH			=(1<<2)
var/const/MINER				=(1<<3)


var/const/SILICON			=(1<<6)

var/const/AI				=(1<<0)
var/const/CYBORG			=(1<<1)


var/const/SOLGOV			=(1<<7)

var/const/SOLGOVAGENT		=(1<<0)

//UNUSED
var/const/ENGSEC
var/const/MEDSCI

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

/proc/loadJobDatums()
	allJobDatums = null
	for(var/datum/job/J in (subtypesof(/datum/job)))
		allJobDatums += J