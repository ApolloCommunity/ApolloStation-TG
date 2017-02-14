var/list/skrell_names = file2list("config/names/skrell.txt")
var/list/vatgrown_names = file2list("config/names/vatgrown.txt")

/proc/skrell_name()
	if(prob(50))
		return "[pick(skrell_names)][pick(skrell_names)]"
	else
		return "[pick(skrell_names)]"

/proc/random_unique_skrell_name(attempts_to_find_unique_name=10)
	for(var/i=1, i<=attempts_to_find_unique_name, i++)
		. = capitalize(pick(skrell_names)) + " " + capitalize(pick(skrell_names))

		if(i != attempts_to_find_unique_name && !findname(.))
			break

/proc/vatgrown_name(gender)
	if(gender==FEMALE)
		if(prob(50))
			return "[pick(first_names_female)]"
		else
			return "[pick(vatgrown_names)][pick(vatgrown_names)]"
	else
		if(prob(50))
			return "[pick(first_names_male)]"
		else
			return "[pick(vatgrown_names)][pick(vatgrown_names)]"

/proc/random_unique_vatgrown_name(gender, attempts_to_find_unique_name=10)
	for(var/i=1, i<=attempts_to_find_unique_name, i++)
		if(gender==FEMALE)
			if(prob(50))
				. = capitalize(pick(first_names_female)) + "-" + rand(1,99)
			else
				. = pick(vatgrown_names) + pick(vatgrown_names) + "-" + rand(1,99)
		else
			if(prob(50))
				. = capitalize(pick(first_names_male)) + "-" + rand(1,99)
			else
				. = pick(vatgrown_names) + pick(vatgrown_names) + "-" + rand(1,99)
		if(i != attempts_to_find_unique_name && !findname(.))
			break