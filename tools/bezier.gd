class_name Bezier

## Must have 3 or 4 points[br]
## 3 Points: Quadratic Bezier curve[br]
## 4 Points: Cubic Bezier curve
static func curve_2d(points: Array[Vector2], t: float, time_to_target: float = 1.0) -> Vector2:
	var points_len := points.size()
	
	if (points_len != 3 and points_len != 4):
		push_error("Bezier.curve_2d: points array must have 3 or 4 points.")
		return Vector2.ZERO

	return _curve(points, t, time_to_target)

## Must have 3 or 4 points[br]
## 3 Points: Quadratic Bezier curve[br]
## 4 Points: Cubic Bezier curve
static func curve_3d(points: Array[Vector3], t: float, time_to_target: float = 1.0) -> Vector3:
	var points_len := points.size()

	if (points_len != 3 and points_len != 4):
		push_error("Bezier.curve_3d: points array must have 3 or 4 points.")
		return Vector3.ZERO

	return _curve(points, t, time_to_target)

## Do not use.[br]
## Call curve_2d or curve_3d instead
static func _curve(points: Array, t: float, time_to_target: float):
	var tf := t / time_to_target

	if points.size() == 4:
		return _cubic_bezier(points[0], points[1], points[2], points[3], tf)
	elif points.size() == 3:
		return _quadratic_bezier(points[0], points[1], points[2], tf)

## Do not use[br]
## Call curve_2d or curve_3d instead
static func _quadratic_bezier(p0, p1, p2, t: float):
	var q0 = p0.lerp(p1, t)
	var q1 = p1.lerp(p2, t)

	var r = q0.lerp(q1, t)
	return r


## Do not use.[br]
## Call curve_2d or curve_3d instead
static func _cubic_bezier(p0, p1, p2, p3, t: float):
	var q0 = p0.lerp(p1, t)
	var q1 = p1.lerp(p2, t)
	var q2 = p2.lerp(p3, t)

	var r0 = q0.lerp(q1, t)
	var r1 = q1.lerp(q2, t)

	var s = r0.lerp(r1, t)
	return s
