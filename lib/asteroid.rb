class Asteroid
  include Collidable

  attr_reader :size

  def initialize(window, options = {})
    @window = window
    options = defaults.merge(options)
    @size = options[:size]
    @image = Gosu::Image.new(window, "assets/asteroid-#{@size}-1.png", false)
    @x = options[:x]
    @y = options[:y]
    @angle = rand(360)
    @speed_modifier = options[:speed]
    @angular_velocity = (rand(0) - rand(0))/3
    @draw_angle = rand(360)
    @alive = true
  end

  def defaults
    { :x     => rand(@window.width),
      :y     => rand(@window.height),
      :size  => 'large',
      :speed => 0.7 }
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
    return [] if @size == 'small'

    Array.new(2) do
      Asteroid.new(@window, :x => @x, 
                            :y => @y, 
                            :size => @size == 'large' ? 'medium' : 'small',
                            :speed => rand(0)*2+0.3) 
    end
  end

  def dead?
    !@alive
  end
  
  def collides_with?(obj)
    Gosu::distance(@x, @y, obj.x, obj.y) <= radius
  end
end
