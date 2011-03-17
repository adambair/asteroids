module Collidable
  attr_reader :x, :y  

  def radius
    image.width * 2 / 3
  end
end

module SlowDeath
  def time_in_existence
    @time_in_existence ||= 0
  end

  def max_time
    @max_time ||= 70
  end
  
  def verify_existence
    kill if time_in_existence > max_time
    @time_in_existence += 1
  end
end

module ParticleMovement
  def move
    verify_existence
    @x += offset_x
    @y -= offset_y
    fix_coordinates
  end
end
