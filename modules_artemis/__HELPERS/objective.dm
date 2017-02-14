var/global/list/objectives_list = list()

/datum/objective/New(var/text)
	if(text)
		explanation_text = text
	objectives_list += src