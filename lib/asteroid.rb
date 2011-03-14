class Asteroid
  include Collidable

  attr_reader :size

  def initialize(window, options = {})
    @window = window
    @size = options[:size] || 'large'
    @image = Gosu::Image.new(window, "assets/asteroid-#{@size}-1.png", false)
    @x = options[:x] || rand(@window.width)
    @y = options[:y] || rand(@window.height)
    @angle = rand(360)
    @speed_modifier = options[:speed] || 0.7
    @angular_velocity = (rand(0) - rand(0))/3
    @draw_angle = rand(360)
    @alive = true
  end

  def draw
    @image.draw_rot(@x, @y, 0, @draw_angle) 
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
    speed = next_size == 'large' ? 1.5 : 2
    asteroids = Array.new(2) do
      Asteroid.new(@window, :x => @x, 
                            :y => @y, 
                            :size => next_size,
                            :speed => rand(0)*speed+0.3) 
    end
  end

  def next_size
    return if @size == 'small'
    @size == 'large' ? 'medium' : 'small'
  end

  def dead?
    !@alive
  end
  
  def collides_with?(object)
    hitbox_2 = object.hitbox
    common_x = hitbox[:x] & hitbox_2[:x]
    common_y = hitbox[:y] & hitbox_2[:y]
    common_x.size > 0 && common_y.size > 0 
  end
end
