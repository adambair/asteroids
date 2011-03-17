class Player
  include Collidable

  attr_accessor :x, :y, :angle, :lives, :velocity_x, :velocity_y

  def initialize(window)
    @window = window
    @lives = 3
    @image = Gosu::Image.new(window, 'assets/ship.png', false)
    @speed_modifier = 0.07
    warp
  end

  def draw
    @image.draw_rot(@x, @y, 0, @angle)
  end

  def turn_left
    @angle -= 4.3
  end

  def turn_right
    @angle += 4.3
  end

  def accelerate
    @acceleration = true
    @velocity_x += Gosu::offset_x(@angle, @speed_modifier)
    @velocity_y += Gosu::offset_y(@angle, @speed_modifier)
  end

  def move
    @x += @velocity_x
    @y += @velocity_y
    @x %= @window.width
    @y %= @window.height
    if @acceleration
      @acceleration = false
    else
      @velocity_x *= 0.99
      @velocity_y *= 0.99
    end
    # @x += @velocity_x
    # @y += @velocity_y
    # @x %= @window.width
    # @y %= @window.height
    # @velocity_x *= 1
    # @velocity_y *= 1
  end

  def kill
    @lives -= 1
    @alive = false
    return if @lives <= 0
    warp
  end

  def dead?
    !@alive
  end
  
  def warp
    @velocity_x = @velocity_y = @angle = 0.0
    @x, @y = @window.width/2, @window.height/2
    @alive = true
  end

  def shoot
    Projectile.new(@window, self) unless dead?
  end
end

