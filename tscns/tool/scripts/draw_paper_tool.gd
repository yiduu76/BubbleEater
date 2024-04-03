extends Node2D
@export var save_path:String="res://assets/polys/cricel.res"

func _ready() -> void:
	($Polygon2D as Polygon2D).polygon=spawn_cricle_points(8,128)
	save_poly()

func save_poly():
	var new_save=Mypolyresourceclass.new()
	for i in get_children():
		if i is Polygon2D:
			#print(i.polygon)
			if i.polygon.size()>0:
				new_save.polys.append(i.polygon)
			if new_save.polys.size()>0:
				ResourceSaver.save(new_save,save_path)

func spawn_cricle_points(radius:float,seg:int):
	var points=[]
	for i in seg:
		var tmp_rotations=deg_to_rad((360.0/seg)*i)
		points.append(Vector2(radius*cos(tmp_rotations),radius*sin(tmp_rotations)))
	return points
