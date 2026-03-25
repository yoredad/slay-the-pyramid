@tool
class_name UserSettings
extends Resource

@export var aceInTheHole: bool = false
@export var faceUp: bool = false
@export var greaterThan: bool = false

const SAVE_PATH = "user://user_settings.tres"

func save() -> void:
	var err = ResourceSaver.save(self, SAVE_PATH)
	if err != OK:
		print("Save failed: ", err)

static func load_or_create() -> UserSettings:
	if ResourceLoader.exists(SAVE_PATH):
		return load(SAVE_PATH) as UserSettings
	else:
		var new_settings = UserSettings.new()
		new_settings.save()  # create defaults file
		return new_settings
