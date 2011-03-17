class Projectile < GameObject
  include ParticleMovement
  include Collidable
  include SlowDeath

  def initialize(window, origin_object)
    super(window)
    @x            = origin_object.x
    @y            = origin_object.y
    @angle        = origin_object.angle    
    @origin_vel_x = origin_object.velocity_x.abs
    @origin_vel_y = origin_object.velocity_y.abs
    @speed_modifier = 6
  end

  private 

    def offset_x
      Gosu::offset_x(@angle, @speed_modifier + @origin_vel_x)
    end

    def offset_y
      Gosu::offset_y(180+@angle, @speed_modifier + @origin_vel_y)
    end
end
