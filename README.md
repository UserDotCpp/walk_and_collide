# walk_and_collide
> alternative to move_and_slide() in 3d

There should be a way to move entities **on the floor** in 3d that doesn't tank fps.

## the problem to solve
for 2d games most movement functions can be used as they are, but there are some problems in 3d :
> [!IMPORTANT]
> the goal is not to make a one size fit all solution, the current functions work well as they are for that, we need a way to integrate the navigation agent to the movement. 

- global_translate(   ) : optimal way to move but doesn't apply collision
- move and collide(  ) : this one haves collision but it gets stuck when collides, so you already need to use a custom way for moving
- move_and_slide(  ) : this one applies with what we need but there are a few caveats:
   - since its always hinting the floor the code haves to run make multiple calls to the function.
   - keeps depending on the Godot's physics engine, witch is is non deterministic and kinda unreliable sometimes.

## base-line test
> [!NOTE]
> the results may vary, since Godot inst deterministic / external factors (the test scene isn't that well optimised).

### move_and_slide()
[the script of the move_and_slide() application](https://github.com/UserDotCpp/walk_and_collide/blob/main/script/unit_navigation_slide.gd)
is not optimal but it is well rounded
1.8 ms - 2.1 ms
![image](https://github.com/user-attachments/assets/d0e713e3-e7a7-41a8-a030-ba3010979613)


## the proposal:
making a custom move function is posible == [some custom move_and_slide() function to use as a base line (attributions in the issue)](https://github.com/UserDotCpp/walk_and_collide/issues/1)

lets make an alternative walk_and_collide() that can be implemented as a drag and drop replacement in your code (this way u can tinker with it) that avoids depending on the physics engine as often. With optimizations like using the navigation server for the floor reference instead of collision