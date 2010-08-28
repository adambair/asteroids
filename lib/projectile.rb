class Projectile
  def initialize(window, origin_object)
    @image = Gosu::Image.new(window, 'assets/projectile.png', false)
    @x, @y = origin_object.x, origin_object.y
    @angle = origin_object.angle
    @speed_modifier = 7
    @distance_traveled, @max_distance = 0, 50
    @alive = true
  end

  def draw
    @image.draw_rot(@x, @y, 1, @angle)
  end

  def move
    @distance_traveled += 1
    kill if @distance_traveled > @max_distance
    @x += @speed_modifier*Math.sin(Math::PI/180*@angle)
    @y += -@speed_modifier*Math.cos(Math::PI/180*@angle)
    @x %= 640
    @y %= 480
  end

  def kill
    @alive = false
  end

  def dead?
    !@alive
  end

  def hitbox
    hitbox_x = ((@x - @image.width/2).to_i..(@x + @image.width/2.to_i)).to_a
    hitbox_y = ((@y - @image.width/2).to_i..(@y + @image.width/2).to_i).to_a
    {:x => hitbox_x, :y => hitbox_y}
  end
end
