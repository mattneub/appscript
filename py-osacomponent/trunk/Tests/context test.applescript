# Demonstrates basic persistency. Top-level state is preserved until script is recompiled or closed. Result will increment by 1 each time script is run.

x = 0

def run(*args):
	global x
	x += 1
	return x