extends Control

var template_str: String = '%s'
var levelValue: int = Settings.min_difficulty

export(String, FILE, "*.tscn") var gameScene = "res://scenes/GameScene.tscn"

onready var incrBtn = $Panel/VBoxContainer/HBoxContainer/incrLvlBtn
onready var decrBtn = $Panel/VBoxContainer/HBoxContainer/decrLvlBtn
onready var levelLabel = $Panel/VBoxContainer/HBoxContainer/ChosenLevel
onready var audio = $SFX

enum LVL_EDIT \
{
	INCREASE = 1,
	DECREASE = -1
}

func _ready():
	
	set_focus_mode(Control.FOCUS_ALL)
	incrBtn.disabled = false
	decrBtn.disabled = true
	setLevelLabel()

func incrLevel() :
	setLevel(LVL_EDIT.INCREASE)
	
func decrLevel() :
	setLevel(LVL_EDIT.DECREASE)
		
func setLevel(direction) :
	
	var condition = false
	
	match (direction) :
		
		LVL_EDIT.DECREASE : condition = (levelValue > Settings.min_difficulty)
		LVL_EDIT.INCREASE : condition = (levelValue < Settings.max_difficulty)
	
	if condition :
		levelValue += direction
		incrBtn.disabled = not(levelValue < Settings.max_difficulty)
		decrBtn.disabled = not(levelValue > Settings.min_difficulty)
		setLevelLabel()
		
		if Settings.canPlaySFX :
			audio.play()

func setLevelLabel() :

	levelLabel.text = template_str % str(levelValue)

func _input(event):
	
	if Input.is_action_just_pressed("menu"):
		backToMenu()
	elif Input.is_action_just_pressed("ui_accept"):
		startGame()
	elif Input.is_action_just_pressed("move_left"):
		decrLevel()
	elif Input.is_action_just_pressed("move_right"):
		incrLevel()

func backToMenu() :
	queue_free()

func startGame() :
	queue_free()
	SceneSwitcher.change_scene(gameScene, {level=levelValue})
