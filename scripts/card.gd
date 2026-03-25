extends Node2D

signal hovered
signal hovered_off

var handPosition
var cardName
var attack
var defense
var cost
var inPlay
var inPyramid
var row
var cell
var isFaceUp = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#all cards must be a child of card_manager
	get_parent().connect_card_signals(self) # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_mouse_entered() -> void:
	emit_signal("hovered", self) # Replace with function body.


func _on_area_2d_mouse_exited() -> void:
	emit_signal("hovered_off", self) # Replace with function body.
	
func faceDown():
	$cardImage.visible = false
	$CardBackImage.visible = true
	isFaceUp = false
	
func faceUp():
	$cardImage.visible = true
	$CardBackImage.visible = false	
	isFaceUp = true

func flipCard():
	if $cardImage.visible:
		faceDown()
	else:
		faceUp()
				
