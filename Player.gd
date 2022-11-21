extends Sprite

# NOTES
# Set the RayCast2D transform -> position to have your tile_size.
# (32 in this case, but 8 if you were using 16x16 sprites)

var speed = 256

# this is for 64x64 sprites;
var tile_size = 64

# where we were moving FROM
var last_position := Vector2()

# where we are moving TO
var target_position := Vector2()

# a Vector2 based off the inputs we press
var movedir := Vector2()

onready var ray = $RayCast2D

func _ready():
	position = position.snapped(Vector2(tile_size, tile_size))
	last_position = position
	target_position = position
	
func _process(delta):
	# MOVEMENT
	if ray.is_colliding():
		position = last_position
		target_position = last_position
	else:
		position += speed * movedir * delta
		
		if position.distance_to(last_position) >= tile_size - speed * delta:
			position = target_position
	
	# IDLE
	if position == target_position:
		get_movedir()
		last_position = position
		target_position += movedir * tile_size
	
func get_movedir():
	var LEFT = Input.is_action_pressed("ui_left")
	var RIGHT = Input.is_action_pressed("ui_right")
	var UP = Input.is_action_pressed("ui_up")
	var DOWN = Input.is_action_pressed("ui_down")
	
	movedir.x = -int(LEFT) + int(RIGHT)
	movedir.y = -int(UP) + int(DOWN)
	
	# prevent diagonal movement
	if movedir.x != 0 && movedir.y != 0:
		movedir = Vector2(0,0)
		
	# Remember, Vector2(0,0) is the same as Vector2.ZERO
	# So, if the player is moving, either in the X or Y
	if movedir != Vector2.ZERO:
		ray.cast_to = movedir * tile_size / 2



