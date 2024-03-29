extends RigidBody2D
class_name Myrigidclass
@export var my_shape : Resource = preload("res://assets/polys/cricel.res")
@export var is_player : bool = false
@export var health :float = 10.0
@export var floating_health :float = 0.0
@onready var my_cammera=null
func _ready() -> void:
	set_collision_layer_value(2,true)
	set_collision_mask_value(2,true)
	add_collision()
	contact_monitor=true
	max_contacts_reported=2
	add_poly()
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	if is_player:
		add_camerra()

func add_camerra():
	my_cammera=Camera2D.new()
	add_child(my_cammera)
	my_cammera.make_current()

func _physics_process(_delta: float) -> void:
	_move()
	camera_control()

func camera_control():
	if my_cammera!=null:
		(my_cammera as Camera2D).zoom.x=lerp(my_cammera.zoom.x,clampf((1-health/1000.0),0.1,3),0.1)
		(my_cammera as Camera2D).zoom.y=lerp(my_cammera.zoom.y,clampf((1-health/1000.0),0.1,3),0.1)



func _process(_delta: float) -> void:
	if floating_health!=0:
		health+=floating_health
		if health<=1.0:
			queue_free()
			return
		update_poly_coly()
		pass
	else :
		pass
	
func _on_body_entered(body:Myrigidclass):
	if health>body.health:
		floating_health=body.health/10.0
	else :
		floating_health=-health/10.0

func _on_body_exited(body:Myrigidclass):
	floating_health=0

func _move():
	if is_player:
		#var temp_dir=-(global_position-get_global_mouse_position()) as Vector2
		var temp_dir=Input.get_vector("ui_left","ui_right","ui_up","ui_down")
		var angel_gap=linear_velocity.normalized().angle_to(temp_dir)
		constant_force=temp_dir.normalized()*50*(1.0+abs(angel_gap))*mass

func update_poly_coly():
	clear_all_poly_coly()
	add_poly()
	add_collision()
	mass=1+health/100.0

func clear_all_poly_coly():
	for i in get_children():
		if i is Polygon2D or i is CollisionPolygon2D:
			i.queue_free()

func add_poly() -> void:
	for i in (my_shape as Mypolyresourceclass).polys:
		var new_poly=Polygon2D.new()
		new_poly.polygon=return_poly_with_health(i,health)
		add_child(new_poly)

func add_collision() -> void:
	for i in (my_shape as Mypolyresourceclass).polys:
		var new_poly=CollisionPolygon2D.new()
		new_poly.polygon=return_poly_with_health(i,health)
		add_child(new_poly)

func return_poly_with_health(poly : PackedVector2Array,tmp_health : float):
	tmp_health=clampf(tmp_health,0.1,99999)
	var new_poly=[]
	for i in poly:
		new_poly.append(i*(tmp_health/10.0))
	return new_poly
