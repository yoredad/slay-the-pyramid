# autoload class.  defined in Project->Project Settings->Globals
extends Node

var user_settings: UserSettings

var aceInTheHole = false
var faceUp = false
var greaterThan = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	user_settings = UserSettings.load_or_create()
	apply_settings()

func apply_settings() -> void:
	aceInTheHole = user_settings.aceInTheHole
	faceUp = user_settings.faceUp
	greaterThan = user_settings.greaterThan
	
func save_settings() -> void:
	user_settings.aceInTheHole = valueOrFalse(aceInTheHole)
	user_settings.faceUp = valueOrFalse(faceUp)
	user_settings.greaterThan = valueOrFalse(greaterThan)
	user_settings.save()
	
func valueOrFalse(value):
	if(value):
		return value
	else:
		return false
		
