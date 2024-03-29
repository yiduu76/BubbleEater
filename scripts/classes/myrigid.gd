extends RigidBody2D
class_name Myrigidclass
@export var my_shape : Resource = preload("res://assets/polys/cricel.res")
@export var is_player : bool = false
@export var health :float = 10.0
@export var floating_health :float = 0.0
func _ready() -> void:
	set_collision_layer_value(2,true)
	set_collision_mask_value(2,true)
	add_collision()
	contact_monitor=true
	max_contacts_reported=2
	add_poly()
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
func _physics_process(_delta: float) -> void:
	_move()

func _process(_delta: float) -> void:
	if floating_health!=0:
		health+=floating_health
		if health<=0:
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
		var temp_dir=-(global_position-get_global_mouse_position()) as Vector2
		var angel_gap=linear_velocity.normalized().angle_to(temp_dir)
		constant_force=temp_dir.normalized()*50*(1.0+abs(angel_gap))
		
func update_poly_coly():
	clear_all_poly_coly()
	add_poly()
	add_collision()

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
