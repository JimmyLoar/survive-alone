extends SMachinaState

func enter(_previous_state: SMachinaState):
	Locator.get_service(ConditionManager).remove_tag("footsteps")
