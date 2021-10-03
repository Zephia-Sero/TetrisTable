extends Node2D
onready var table = $Table
onready var deathfield = $DeathField
onready var stucktimer = $StuckTimer
onready var placesound = $PlacePlayer
onready var scorefield = $UI/Score
onready var losescreen = $UI/LoseScreen
onready var playbutton = $UI/LoseScreen/Play
onready var quitbutton = $UI/LoseScreen/Quit
var hasPlaced = true
var pieces = [preload("res://SPiece.tscn"),preload("res://ZPiece.tscn"),preload("res://JPiece.tscn"),preload("res://LPiece.tscn"),preload("res://SquarePiece.tscn"),preload("res://TPiece.tscn"),preload("res://LinePiece.tscn")]
var rng = RandomNumberGenerator.new()
var nextPiece = 0
var movingPiece = null
var playing = true
var score = 0
func _ready():
	hasPlaced = true
	rng.randomize()
	stucktimer.connect("timeout",self,"_on_stucktimer_timeout")
	playbutton.connect("pressed",self,"_on_play_again")
	quitbutton.connect("pressed",self,"_on_menu_return")
func _on_play_again():
	get_tree().change_scene("res://Main.tscn")
func _on_menu_return():
	get_tree().change_scene("res://Menu.tscn")
func _process(delta):
	if deathfield.overlaps_body(movingPiece):
		hasPlaced = true
		movingPiece.isActive = false
		movingPiece.sleeping = true
		movingPiece = null
		score -= 2000
		scorefield.text = "Score: " + str(score)
		stucktimer.stop()
	if deathfield.overlaps_body(table):
		playing = false
		if movingPiece != null:
			movingPiece.isActive = false
			movingPiece.sleeping = true
	if not (playing or losescreen.visible):
		losescreen.visible = true
		scorefield.rect_position.x = (1024-400)/2
		scorefield.rect_position.y = 100
	if hasPlaced and playing:
		hasPlaced = false
		nextPiece = rng.randi_range(0,pieces.size()-1)
		var instance = pieces[nextPiece].instance()
		instance.position = Vector2(0,-512)
		instance.mass = 1
		instance.bounce = 0
		instance.friction = 1
		instance.contact_monitor = true
		instance.contacts_reported=1
		instance.linear_damp = 4
		instance.isActive = true
		instance.mode = 2 # character mode - disable rotation
		movingPiece = instance
		add_child(instance)
	elif movingPiece.get_colliding_bodies().size() > 0 and stucktimer.is_stopped() and playing:
		stucktimer.start()
	if playing:
		score += 1
		scorefield.text = "Score: " + str(score)
func _on_stucktimer_timeout():
	hasPlaced = true
	if not movingPiece == null and playing:
		movingPiece.isActive = false
		movingPiece = null
		placesound.play()
