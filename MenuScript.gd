extends Control

onready var un = $Un
onready var pre = $LogoPre
onready var post = $LogoPost
onready var quit = $Quit
onready var play = $Play
var unvelx = 5
var unvely = 5
func _ready():
	play.connect("pressed", self, "_play_game")
	quit.connect("pressed", self, "_quit_game")
func _process(delta):
	un.rect_position += Vector2(unvelx, unvely)
	if un.rect_position.y >= 100:
		un.visible = false
		pre.visible = false
		post.visible = true
func _play_game():
	get_tree().change_scene("res://Main.tscn")
func _quit_game():
	get_tree().quit()
