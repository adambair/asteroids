class Particle < GameObject
  include ParticleMovement
  include SlowDeath
  
  def initialize(window, origin_object)
    super(window)
    @x = origin_object.x-rand(10)
    @y = origin_object.y-rand(10)
    @speed_modifier = 0.5+rand
  end

  def max_time
    @max_time ||= rand(30)
  end

  private 

    def offset_x
      Gosu::offset_x(@angle, @speed_modifier)
    end

    def offset_y
      Gosu::offset_y(180+@angle, @speed_modifier)
    end
end
