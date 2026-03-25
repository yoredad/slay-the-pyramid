extends Node2D
const OPTION_ACE = "ace"
const OPTION_FACE = "face"
const OPTION_GT = "gt"

var optionAce = false
var optionFaceUp = false
var optionGreaterThan = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setOptionsFromConfig()
	
func setOptionsFromConfig() -> void:
	optionAce = Settings.aceInTheHole
	turnOptionsOnOff(OPTION_ACE)
	optionFaceUp = Settings.faceUp
	turnOptionsOnOff(OPTION_FACE)
	optionGreaterThan = Settings.greaterThan	
	turnOptionsOnOff(OPTION_GT)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func setOption(option):
	if option == OPTION_ACE:
		optionAce = !optionAce
	elif option == OPTION_FACE:
		optionFaceUp = !optionFaceUp
	elif option == OPTION_GT:
		optionGreaterThan = !optionGreaterThan
	turnOptionsOnOff(option)
	
func turnOptionsOnOff(option):
	if option == OPTION_ACE:
		if optionAce:
			get_node("AceX").visible = true
		else:
			get_node("AceX").visible = false
	elif option == OPTION_FACE:
		if optionFaceUp:
			get_node("FaceX").visible = true
		else:
			get_node("FaceX").visible = false			
	elif option == OPTION_GT:
		if optionGreaterThan:
			get_node("GTX").visible = true
		else:
			get_node("GTX").visible = false		
	
func saveOptions() -> void:
	Settings.aceInTheHole = optionAce
	Settings.faceUp  = optionFaceUp
	Settings.greaterThan = optionGreaterThan
	Settings.save_settings()
	
func hideButtons():
	get_node("Ace2D/CollisionShape2D").set_deferred("disabled", true)
	get_node("Face2D/CollisionShape2D").set_deferred("disabled", true)
	get_node("GT2D/CollisionShape2D").set_deferred("disabled", true)
	get_node("Ok2D/CollisionShape2D").set_deferred("disabled", true)
	$Ok2D/CollisionShape2D.disabled = true
	get_node("Cancel2D/CollisionShape2D").set_deferred("disabled", true)
	$Cancel2D/CollisionShape2D.disabled = true
	
func showButtons():
	get_node("Ace2D/CollisionShape2D").set_deferred("disabled", false)
	get_node("Face2D/CollisionShape2D").set_deferred("disabled", false)
	get_node("GT2D/CollisionShape2D").set_deferred("disabled", false)
	get_node("Ok2D/CollisionShape2D").set_deferred("disabled", false)
	$Ok2D/CollisionShape2D.disabled = false
	get_node("Cancel2D/CollisionShape2D").set_deferred("disabled", false)
	$Cancel2D/CollisionShape2D.disabled = false
