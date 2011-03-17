class Player
  include Collidable

  attr_accessor :x, :y, :angle, :lives, :velocity_x, :velocity_y

  def initialize(window)
    @window = window
    @lives = 3
    @image = Gosu::Image.new(window, 'assets/ship.png', false)
    @speed_modifier = 0.07
    warp
    @explosion = Gosu::Sample.new(window, 'assets/explosion.wav')
    @laser = Gosu::Sample.new(window, 'assets/laser.wav')
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
      @velocity_x *= 0.991
      @velocity_y *= 0.991
    end
  end

  def kill
    @explosion.play
    @lives -= 1
    @alive = false
    return if @lives <= 0
    warp
  end

  def dead?
    !@alive
  end
  
  def warp
    @velocity_x = @velocity_y = 0.0
    @angle = rand(360)
    @x, @y = @window.width/2, @window.height/2
    @alive = true
  end

  def shoot
    unless dead?
      @laser.play
      Projectile.new(@window, self)
    end
  end
end

