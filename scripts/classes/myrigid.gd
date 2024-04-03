extends RigidBody2D
class_name Myrigidclass
@export var my_shape : Resource = preload("res://assets/polys/cricel.res")
@export var is_player : bool = false
@export var health :float = 10.0
@export var floating_health :float = 0.0
@onready var my_cammera=null
@onready var my_label:Label=null
@onready var my_poly : Polygon2D=null

func _ready() -> void:
	set_collision_layer_value(2,true)
	set_collision_mask_value(2,true)
	lock_rotation=true
	add_collision()
	contact_monitor=true
	max_contacts_reported=2
	add_poly()
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	if is_player:
		add_camerra()
		add_label()
func add_label():
	my_label=Label.new()
	add_child(my_label)
	my_label.add_theme_color_override("font_color",Color.BLACK)
	my_label.add_theme_font_size_override("font_size",health)
	my_label.z_index=2
	await get_tree().create_timer(0.1).timeout
	my_label.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
func update_label():
	my_label.text=str(health).left(5)
	my_label.add_theme_font_size_override("font_size",health*0.5)
	my_label.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	my_label.add_theme_color_override("font_color",my_poly.color.inverted())

func add_camerra():
	my_cammera=Camera2D.new()
	add_child(my_cammera)
	my_cammera.make_current()

func _physics_process(_delta: float) -> void:
	_move()
	if is_player:
		camera_control()
		update_label()

func camera_control():

	if Input.is_action_just_pressed("ui_zoom_in"):
		(my_cammera as Camera2D).zoom.x=lerp(my_cammera.zoom.x,clampf((my_cammera.zoom.x)+0.2,0.01,3),0.1)
		(my_cammera as Camera2D).zoom.y=lerp(my_cammera.zoom.y,clampf((my_cammera.zoom.y)+0.2,0.01,3),0.1)
	if Input.is_action_just_pressed("ui_zoom_out"):
		(my_cammera as Camera2D).zoom.x=lerp(my_cammera.zoom.x,clampf((my_cammera.zoom.x)-0.2,0.01,3),0.1)
		(my_cammera as Camera2D).zoom.y=lerp(my_cammera.zoom.y,clampf((my_cammera.zoom.y)-0.2,0.01,3),0.1)


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
		floating_health=body.health/120.0
	elif health==body.health:
		floating_health=0
	else :
		floating_health=-health/120.0
	await get_tree().create_timer(2.05).timeout
	floating_health=0

func _on_body_exited(body:Myrigidclass):
	pass
	#floating_health=0

func _move():
	var temp_dir=Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	if is_player:
		if temp_dir.is_zero_approx():linear_damp=1.0
		else :linear_damp=0.0
		var angel_gap=linear_velocity.normalized().angle_to(temp_dir)
		constant_force=temp_dir.normalized()*50*(1.0+abs(angel_gap))*mass
	else :
		linear_damp=1.0
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
		my_poly=Polygon2D.new()
		my_poly.polygon=return_poly_with_health(i,health)
		add_child(my_poly)
		var color_s=clampf(health/360.0,0,1.0)
		var color_v=clampf(1-health/360.0,0,1.0)
		var color_h=clampf(health,0,360.0)
		my_poly.color.s=color_s
		my_poly.color.v=color_v
		my_poly.color.h=color_h
		
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
