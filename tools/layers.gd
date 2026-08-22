class_name Bitfield

static func layers_to_int(layers: Array[int]) -> int:
	var result := 0
	for layer in layers:
		result |= 1 << (layer - 1)
	return result
