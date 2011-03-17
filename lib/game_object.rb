class GameObject  
  def initialize(window, options = {})
    @window = window
    @alive = true
    @angle = rand(360)
  end

  def image_name
    "assets/#{self.class.to_s.downcase}.png"
  end

  def image
    @image ||= Gosu::Image.new(@window, image_name, false)
  end

  def draw
    image.draw_rot(@x, @y, 1, @angle)
  end

  def kill
    @alive = false
    after_kill
  end

  def after_kill
    # Add custom stuff
  end
  
  def dead?
    !@alive
  end

protected

  def fix_coordinates
    @x %= @window.width
    @y %= @window.height
  end
end
