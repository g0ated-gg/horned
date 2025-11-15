class_name Quest extends Resource

const NOT_STARTED := 1

var code: String
var steps: Array[Callable] = [ ]
var index := NOT_STARTED

signal quest_completed(code: String)

func _init(quest_code: String, quest_steps: Array[Callable]) -> void:
	code = quest_code 
	steps = quest_steps

func get_quest_name() -> String:
	return tr("quest_{code}".format({"code": code}))

func is_quest_started():
	return index > NOT_STARTED

func get_step_description(step_index: int) -> String:
	return tr("quest_{code}_{step_index}".format({
		"code": code,
		"step_index": step_index
	}))

func get_quest_description(step_index: int) -> Array[String]:
	var array: Array[String] = [ ]
	for i in range(0, step_index+1):
		array.append(get_step_description(i))
	return array

func is_next_step(step_index: int):
	return step_index > index

func is_current_step(step_index: int):
	return step_index == index

func is_previous_step(step_index: int):
	return index > step_index

func is_quest_completed():
	return index >= steps.size()

## Call method depending on current step
func describe(
	step_index: int,
	not_started: Callable,
	next_step: Callable,
	current_step: Callable,
	previous_step: Callable,
	completed: Callable
):
	if not is_quest_started():
		not_started.call()
	elif is_next_step(step_index):
		next_step.call()
	elif is_current_step(step_index):
		current_step.call()
	elif is_previous_step(step_index):
		previous_step.call()
	else:
		completed.call()

func start():
	step_end_reached(-1)

func step_end_reached(last_index: int):
	index = last_index + 1
	_step()

func force_complete():
	index = steps.size()

func _step():
	if not is_quest_completed():
		steps[index].call()
	else:
		quest_completed.emit(code)
