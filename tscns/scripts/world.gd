extends Node2D
func _ready() -> void:
	add_randdom_rigid()
	pass


func add_randdom_rigid():
	for i in 99:
		var rand_health=randi_range(5,50)
		var temp_rigid=Myrigidclass.new()
		temp_rigid.health=rand_health
		add_child(temp_rigid)
		temp_rigid.global_translate(Vector2(randi_range(-100,2000),randi_range(-100,2000)))
