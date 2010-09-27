class Asteroid
  include Collidable

  def initialize(window, size='large')
    @window = window
    @size = size
    @image = Gosu::Image.new(window, "assets/asteroid-#{size}-1.png", false)
    @x, @y, @angle = rand(@window.width), rand(@window.height), rand(360)
    @speed_modifier = 1.5
    @angular_velocity = (rand(0) - rand(0))/3
    @draw_angle = rand(360)
    @alive = true
  end

  def draw
    @image.draw_rot(@x, @y, 0, @draw_angle) 
  end

  def points
    {'large' => 20, 'medium' => 50, 'small' => 100}[@size]
  end

  def move
    @x += Gosu::offset_x(@angle, @speed_modifier)
    @y += Gosu::offset_y(@angle, @speed_modifier)
    @x %= @window.width
    @y %= @window.height
    @draw_angle += @angular_velocity
  end

  def kill
    @alive = false
    fragment
  end

  def fragment
    return [] unless next_size
    asteroids = Array.new(2) { Asteroid.new(@window, next_size) }
    asteroids.collect {|asteroid| asteroid.setup(@x, @y, rand(0)*2.5+0.5) }
  end

  def next_size
    return if @size == 'small'
    @size == 'large' ? 'medium' : 'small'
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
    Array.new(count) { Asteroid.new(window) }
  end
end
