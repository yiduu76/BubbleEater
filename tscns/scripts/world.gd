extends Node2D
var window
func _ready() -> void:
	window=get_window()
	add_randdom_rigid()
	window.borderless=true
@onready var dragable=false
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_drag"):
		dragable=true
	if Input.is_action_just_released("ui_drag"):
		dragable=false

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and dragable:
		(window as Window).position.x+=event.relative.x
		(window as Window).position.y+=event.relative.y
func add_randdom_rigid():
	for i in 900:
		var rand_health=randf_range(1,80)
		var temp_rigid=Myrigidclass.new()
		temp_rigid.health=rand_health
		add_child(temp_rigid)
		temp_rigid.global_translate(Vector2(randi_range(-1400,1400),randi_range(-1400,1400)))
