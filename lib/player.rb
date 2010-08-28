class Player
  attr_accessor :x, :y, :angle, :lives, :score

  def initialize(window)
    @score = 0
    @lives = 3
    @image = Gosu::Image.new(window, 'assets/ship.png', false)
    @velocity_x = @velocity_y = @angle = 0.0
    @x, @y = 320, 240
    @alive = true
  end

  def draw
    @image.draw_rot(@x, @y, 0, @angle)
  end

  def turn_left
    @angle -= 4.5
  end

  def turn_right
    @angle += 4.5
  end

  def accelerate
    @velocity_x += Gosu::offset_x(@angle, 0.18)
    @velocity_y += Gosu::offset_y(@angle, 0.18)
  end

  def move
    @x += @velocity_x
    @y += @velocity_y
    @x %= 640
    @y %= 480
    @velocity_x *= 1
    @velocity_y *= 1
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
  
  def warp(x=320, y=240)
    @velocity_x = @velocity_y = @angle = 0.0
    @x, @y = x, y
    @alive = true
  end

  def hitbox
    hitbox_x = ((@x - @image.width/2).to_i..(@x + @image.width/2.to_i)).to_a
    hitbox_y = ((@y - @image.width/2).to_i..(@y + @image.width/2).to_i).to_a
    {:x => hitbox_x, :y => hitbox_y}
  end
end
