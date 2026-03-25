extends Node2D

const CARD_SCENE_PATH = "res://scenes/card.tscn"
const CARD_DRAW_SPEED = 0.5

var cardDatabase
var playerDeck # = ["jinn","cleric","warlock","orc","werewolf"]
var cardScene # = preload(CARD_SCENE_PATH)
var cardNo
var cardManRef
var deckRef 
var pyramidRef

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cardManRef = $"../CardManager"
	deckRef = $"."
	cardDatabase = preload("res://scripts/cardDatabase.gd")
#	$RichTextLabel.text = str(cardNo)
	cardScene = preload(CARD_SCENE_PATH)
	pyramidRef = $"../Pyramid"
	init()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func drawCard():
	var cardDrawn = playerDeck[0]
	playerDeck.erase(cardDrawn)
	cardNo -= 1
	# $RichTextLabel.text = str(cardNo)
		
	if playerDeck.size() == 0:
		$Area2D/CollisionShape2D.disabled = true
		$Sprite2D.visible = false
		# $RichTextLabel.visible = false

	var newCard = cardScene.instantiate()
	var cardPath = str("res://assets/" + str(cardDatabase.CARDS[cardDrawn][1]) + ".jpg")
	newCard.get_node("cardImage").texture = load(cardPath)
	newCard.get_node("Attack").text = str(cardDatabase.CARDS[cardDrawn][2])
	newCard.get_node("Attack").modulate = Color(cardDatabase.CARDS[cardDrawn][3])
	newCard.cardName = cardDrawn
	newCard.attack = cardDatabase.CARDS[cardDrawn][0]
	newCard.name = cardDrawn
	newCard.position = deckRef.position	# initialize to deck position
	# newCard.get_node("Health").text = str(cardDatabase.CARDS[cardDrawn][1])
	cardManRef.add_child(newCard)
	return newCard

func drawCardFromDeck():
	var newCard = drawCard()	
	newCard.z_index = 52 - cardNo
	newCard.get_node("Attack").z_index = 52 - cardNo
	$"../PlayerHand".addCardToHand(newCard, CARD_DRAW_SPEED)
	
func init():
	playerDeck = cardDatabase.CARDS.keys()
	playerDeck.shuffle()
	cardNo = playerDeck.size()

func resetState():
	var card
	for i in playerDeck.size(): 
		card = playerDeck.get(i)
		playerDeck.erase(i)
		# card.free() playerDeck does not hold  card objects
	cardManRef.resetState()
	init()
	# reset the deck
	$Area2D/CollisionShape2D.disabled = false
	$Sprite2D.visible = true
	
func dealPyramid():
	pyramidRef.resetState()
	for i in range(1, 29):
		var newCard = drawCard()
		pyramidRef.addCard(newCard)
	pyramidRef.flipFirstCard()
	 
func dealAce():
	for i in range(0, deckRef.size()):
		pass # var card = z
	
	
