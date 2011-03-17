class Particle
  def initialize(window, origin_object)
    @window = window
    @image = Gosu::Image.new(window, 'assets/projectile.png', false)

    @origin_object = origin_object
    @x, @y = @origin_object.x-rand(10), @origin_object.y-rand(10)
    @angle = rand(360)

    @time_in_existence, @max_time = 0, rand(30)
    @speed_modifier = 0.5+rand
    @alive = true
  end

  def draw
    @image.draw_rot(@x, @y, 1, @angle)
  end

  def move
    verify_existence
    @x += offset_x
    @y -= offset_y
    @x %= @window.width
    @y %= @window.height
  end

  def kill
    @alive = false
  end

  def dead?
    !@alive
  end

  private 

    def verify_existence
      kill if @time_in_existence > @max_time
      @time_in_existence += 1
    end

    def offset_x
      Gosu::offset_x(@angle, @speed_modifier)
    end

    def offset_y
      Gosu::offset_y(180+@angle, @speed_modifier)
    end
end
