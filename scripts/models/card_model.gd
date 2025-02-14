class_name CardModel extends Model


var title : String = ""
var description : String = "" setget set_description
var list_id : String = ""
var tasks : Array = []
var is_archived := false
var is_draft := false setget set_draft


func _init(_id : String, _list_id : String, _title : String = "", _description : String = "").(ModelTypes.CARD, _id):
	list_id = _list_id
	title = _title
	description = _description


func set_title(_title: String):
	var was_draft = is_draft
	title = _title

	if is_draft and title != "":
		set_draft(false)

	_notify_updated(was_draft)


func set_description(_description: String):
	description = _description
	_notify_updated()


func add_task(task):
	tasks.push_back(task)
	_notify_updated()


func update_task(task, _title, _is_done):
	task.set_title(_title)
	task.set_is_done(_is_done)
	_notify_updated()


func count_tasks_done():
	# TODO: add functional programming (filter -> count)
	var done = 0
	for task in tasks: if task.is_done: done += 1
	return done


func delete_task(task):
	var task_idx = tasks.find(task)
	if task_idx != -1:
		tasks.remove(task_idx)
		_notify_updated()


func archive():
	is_archived = true
	_notify_updated(false, false)


func unarchive():
	is_archived = false
	_notify_updated(false, true)


func set_draft(value := true):
	is_draft = value


func _notify_updated(was_draft := false, was_archived := false):
	DataRepository.update_card(self, was_draft, was_archived)


func _to_string():
	# TODO: add tasks
	return to_json({
		"id": id,
		"title": title,
		"description": description,
		"list_id": list_id,
		"is_archived": is_archived
	})
