#define BORG_SUCCESSION_LEVEL 0
#define ASSISTANT_SUCCESSION_LEVEL 2
#define INDUCTEE_SUCCESSION_LEVEL 3
#define SENIOR_SUCCESSION_LEVEL 5
#define COMMAND_SUCCESSION_LEVEL 10
#define CAPTAIN_SUCCESION_LEVEL COMMAND_SUCCESSION_LEVEL+2
#define NO_INDUCTEE 1

//The following list are the actual enabled jobs!

var/global/list/assistant_occupations = list(
	"Assistant",
	"Cargo Technician",
	"Chaplain",
	"Lawyer",
	"Librarian"
)

var/global/list/command_positions = list(
	"Captain",
	"Head of Personnel",
	"Head of Security",
	"Chief Engineer",
	"Research Director",
	"Chief Medical Officer",
	"Internal Affairs Agent"
)

var/global/list/engineering_positions = list(
	"Chief Engineer",
	"Senior Engineer",
	"Station Engineer"
)

var/global/list/medical_positions = list(
	"Chief Medical Officer",
	"Senior Medical Doctor",
	"Medical Doctor"
)

var/global/list/science_positions = list(
	"Research Director",
	"Senior Scientist",
	"Scientist"
)

var/global/list/supply_positions = list(
	"Quartermaster",
	"Mining Foreman",
	"Cargo Technician",
	"Shaft Miner"
)

var/global/list/civilian_positions = list(
	"Captain",
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

var/global/list/security_positions = list(
	"Head of Security",
	"Warden",
	"Detective",
	"Security Officer",
)

var/global/list/nonhuman_positions = list(
	"AI",
	"Cyborg",
	"pAI"
)

var/global/list/external_positions = list(
	"SolGov Representative"
)

var/global/datum/job_stats/job_stats

datum/job_stats/
	var/list/department_jobs
	var/list/all_jobs
	var/list/inductee_roles
	var/list/all_job_datum

datum/job_stats/New()
	department_jobs = new/list()
	department_jobs["ENG"] = engineering_positions
	department_jobs["MED"] = medical_positions
	department_jobs["SCI"] = science_positions
	department_jobs["SEC"] = security_positions
	department_jobs["CAR"] = supply_positions
	department_jobs["SIL"] = nonhuman_positions
	department_jobs["CIV"] = civilian_positions
	department_jobs["SOL"] = external_positions

	all_jobs = new/list()
	for(var/x in department_jobs)
		all_jobs += department_jobs[x]

	inductee_roles = new/list()
	for(var/x in subtypesof(/datum/job))
		var/datum/job/J = new x()
		if(J.rank_succession_level == INDUCTEE_SUCCESSION_LEVEL)
			inductee_roles += J.title

	/* //DEBUG:
	world << "Testing output for department jobs"
	for(var/x in department_jobs)
		world << "Department [x]"
		for(var/y in department_jobs[x])
			world << "	job [y]"
	world << "done"
	*/