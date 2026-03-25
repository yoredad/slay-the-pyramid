extends Node2D

@onready var splash_screen = $SplashScreen
@onready var landingPage = $LandingPage
@onready var game_screen = $Background
@onready var deck = $Deck
@onready var cardSlot = $CardSlot
@onready var cardSlot2 = $CardSlot2
@onready var exitButton = $ExitButton
@onready var startButton = $StartButton
@onready var optionsButton = $OptionsButton
@onready var options = $Options
@onready var pyramid = $Pyramid
@onready var retireButton = $RetireButton

var gameState

const STARTUP = "startup"
const LANDING = "landing"
const GAME = "game"
const OPTIONS = "options"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gameState = STARTUP
	splash_screen.visible = true
	landingPage.visible = false
	game_screen.visible = false
	options.visible = false

	# Wait 3 seconds, then show options
	await get_tree().create_timer(3.0).timeout
	splash_screen.visible = false
	landingPage.visible = true
	showButtons()
	gameState = LANDING
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func initializeGame():
	landingPage.visible = false
	startButton.visible = false
	startButton.get_node("Area2D/CollisionShape2D").set_deferred("disabled", true)
	optionsButton.visible = false
	optionsButton.get_node("Area2D/CollisionShape2D").set_deferred("disabled", true)
	exitButton.visible = false
	exitButton.get_node("Area2D/CollisionShape2D").set_deferred("disabled", true)
	retireButton.visible = true
	retireButton.get_node("Area2D/CollisionShape2D").set_deferred("disabled", false)	
	game_screen.visible = true	
	deck.visible = true
	cardSlot.visible = true
	cardSlot.cardInSlot = false
	cardSlot2.visible = false
	cardSlot2.cardInSlot = false
	gameState = GAME
	# if ace in the hole option, find first ace and deal to slot2
	if Settings.aceInTheHole:
		cardSlot2.visible = true
		cardSlot2.cardInSlot = true
		deck.dealAce()
	deck.dealPyramid()	
	
func returnToLanding():
	landingPage.visible = true
	showButtons()
	game_screen.visible = false
	deck.visible = false
	cardSlot.visible = false
	cardSlot2.visible = false
	options.visible = false
	resetTheGame()
	gameState = LANDING		
	
func resetTheGame():
	deck.resetState()
	
func hideButtons():
	startButton.visible = false
	startButton.get_node("Area2D/CollisionShape2D").set_deferred("disabled", true)
	exitButton.visible = false
	exitButton.get_node("Area2D/CollisionShape2D").set_deferred("disabled", true)
	optionsButton.visible = false
	optionsButton.get_node("Area2D/CollisionShape2D").set_deferred("disabled", true)
	retireButton.visible = false
	retireButton.get_node("Area2D/CollisionShape2D").set_deferred("disabled", true)
	
func showButtons():
	startButton.visible = true
	startButton.get_node("Area2D/CollisionShape2D").set_deferred("disabled", false)
	exitButton.visible = true
	exitButton.get_node("Area2D/CollisionShape2D").set_deferred("disabled", false)
	optionsButton.visible = true	
	optionsButton.get_node("Area2D/CollisionShape2D").set_deferred("disabled", false)
	retireButton.visible = false
	retireButton.get_node("Area2D/CollisionShape2D").set_deferred("disabled", true)

func toggleExit():
	exitButton.visible = true
	exitButton.get_node("Area2D/CollisionShape2D").set_deferred("disabled", false)	
	retireButton.visible = false
	retireButton.get_node("Area2D/CollisionShape2D").set_deferred("disabled", true)	
