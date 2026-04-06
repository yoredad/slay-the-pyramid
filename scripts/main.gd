extends Node2D

@onready var splash_screen = $SplashScreen
@onready var landingPage = $LandingPage
@onready var game_screen = $Background
@onready var deck = $Deck
@onready var cardSlot = $CardSlot
@onready var aceSlot = $AceSlot
@onready var exitButton = $ExitButton
@onready var startButton = $StartButton
@onready var optionsButton = $OptionsButton
@onready var options = $Options
@onready var pyramid = $Pyramid
@onready var retireButton = $RetireButton
@onready var game_over = $GameOver
@onready var score_board = $ScoreBoard
@onready var longest_streak  = $ScoreBoard/CenterContainer/PanelContainer/VBoxContainer/GridContainer/longestStreak
@onready var cards_played = $ScoreBoard/CenterContainer/PanelContainer/VBoxContainer/GridContainer/cardsPlayed
@onready var cards_remainging = $ScoreBoard/CenterContainer/PanelContainer/VBoxContainer/GridContainer/cardsRemaining
@onready var score_label = $ScoreBoard/CenterContainer/PanelContainer/VBoxContainer/GridContainer/Score

var gameState :String
var cardsPlayed :int = 0
var score :int = 0
var cardsRemaining :int = 52
var longestStreak :int = 0
var currentStreak :int = 0

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
	aceSlot.visible = false
	aceSlot.cardInSlot = false
	gameState = GAME
	# if ace in the hole option, find first ace and deal to slot2
	if Settings.aceInTheHole:
		aceSlot.visible = true
		aceSlot.cardInSlot = true
		deck.dealAce()
	deck.dealPyramid()	
	
func returnToLanding():
	landingPage.visible = true
	showButtons()
	game_screen.visible = false
	game_over.visible = false
	score_board.visible = false;
	deck.visible = false
	cardSlot.visible = false
	aceSlot.visible = false
	options.visible = false
	resetTheGame()
	gameState = LANDING		
	
func resetTheGame():
	deck.resetState()
	resetStats()
	
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

func gameOver():
	deck.disableTheDeck()
	game_over.visible = true;
	# show stats
	# check the current streak one last time
	if currentStreak > longestStreak: # could have ended game on longest streak
		longestStreak = currentStreak
	longest_streak.text = str(longestStreak)
	cards_played.text = str(cardsPlayed)
	cards_remainging.text = str(cardsRemaining)
	score = (longestStreak * 100) + (cardsRemaining * 50) + (cardsPlayed * 25) + 1000
	score_label.text = str(score) + "  " # add some right padding
	score_board.visible = true;
	toggleExit();

func resetStats():
	currentStreak = 0
	longestStreak = 0
	cardsRemaining = 52
	cardsPlayed = 0
	score = 0

func cardDrawnFromDeck():
	cardsPlayed += 1
	cardsRemaining -= 1
	if(currentStreak > longestStreak):
		longestStreak = currentStreak
		currentStreak = 0
		
