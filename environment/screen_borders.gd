extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var screen_size = get_viewport_rect().size
	resize_top(screen_size)
	resize_bottom(screen_size)
	resize_left(screen_size)
	resize_right(screen_size)


func resize_top(screen_size):
	$top_border/top_segment_collision.get_shape().b.x = screen_size.x
	$top_border/top_segment_shape.set_polygon(resize_polygon_top($top_border/top_segment_shape.get_polygon(), screen_size.x))


func resize_bottom(screen_size):
	$bottom_border/bottom_segment_collision.get_shape().a.y = screen_size.y
	$bottom_border/bottom_segment_collision.get_shape().b = screen_size
	$bottom_border/bottom_segment_shape.set_polygon(resize_polygon_bottom($bottom_border/bottom_segment_shape.get_polygon(), screen_size.x, screen_size.y))


func resize_left(screen_size):
	$left_border/left_segment_collision.get_shape().b.y = screen_size.y
	$left_border/left_segment_shape.set_polygon(resize_polygon_left($left_border/left_segment_shape.get_polygon(), screen_size.y))

func resize_right(screen_size):
	$right_border/right_segment_collision.get_shape().a.x = screen_size.x
	$right_border/right_segment_collision.get_shape().b = screen_size
	$right_border/right_segment_shape.set_polygon(resize_polygon_right($right_border/right_segment_shape.get_polygon(), screen_size.x, screen_size.y))


func resize_polygon_top(polygon, x) -> PoolVector2Array:
	polygon = polygon as PoolVector2Array # should be a rectangle 
	polygon.set(1, Vector2(x, polygon[1].y))
	polygon.set(2, Vector2(x, polygon[2].y))
	return polygon


func resize_polygon_bottom(polygon, x, y) -> PoolVector2Array:
	polygon = polygon as PoolVector2Array # should be a rectangle 
	polygon.set(0, Vector2(polygon[0].x, y))
	polygon.set(1, Vector2(x, y))
	polygon.set(2, Vector2(x, polygon[2].y + y))
	polygon.set(3, Vector2(polygon[3].x, polygon[3].y + y))
	return polygon


func resize_polygon_left(polygon, y) -> PoolVector2Array:
	polygon = polygon as PoolVector2Array # should be a rectangle 
	polygon.set(1, Vector2(y, polygon[1].y))
	polygon.set(2, Vector2(y, polygon[2].y))
	return polygon


func resize_polygon_right(polygon, x, y) -> PoolVector2Array:
	polygon = polygon as PoolVector2Array # should be a rectangle 
	polygon.set(0, Vector2(polygon[0].x, -x))
	polygon.set(1, Vector2(y, -x))
	polygon.set(2, Vector2(y, polygon[2].y-x))
	polygon.set(3, Vector2(polygon[3].x, polygon[3].y-x))
	return polygon
















