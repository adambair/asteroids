class Asteroid
  def initialize(window, size='large')
    @window = window
    @size = size
    @image = Gosu::Image.new(window, "assets/asteroid-#{size}-1.png", false)
    @x, @y, @angle = rand(640), rand(480), rand(360)
    @speed_modifier = 1.5
    @alive = true
  end

  def draw
    @image.draw_rot(@x, @y, 0, @angle)
  end

  def points
    case @size
      when 'large'
        20
      when 'medium'
        50
      when 'small'
        100
      else
        0
    end
  end

  def move
    @x += @speed_modifier*Math.sin(Math::PI/180*@angle)
    @y += -@speed_modifier*Math.cos(Math::PI/180*@angle)
    @x %= 640
    @y %= 480
  end

  def hitbox
    hitbox_x = ((@x - @image.width/2).to_i..(@x + @image.width/2.to_i)).to_a
    hitbox_y = ((@y - @image.width/2).to_i..(@y + @image.width/2).to_i).to_a
    {:x => hitbox_x, :y => hitbox_y}
  end

  def kill
    @alive = false
    smash
  end

  def smash
    asteroids = case @size
      when 'large'
        speed = 2
        2.times.collect{Asteroid.new(@window, 'medium')}
      when 'medium'
        speed = 2.5
        2.times.collect{Asteroid.new(@window, 'small')}
      else
        []
    end
    asteroids.collect {|asteroid| asteroid.setup(@x, @y, rand(0)*speed+0.5) }
  end

  def setup(x, y, speed)
    @x, @y, @speed_modifier = x, y, speed
    @angle = rand(360)
    self
  end

  def dead?
    !@alive
  end

  def self.spawn(window, count=3)
    count.times.collect{Asteroid.new(window)}
  end
end
