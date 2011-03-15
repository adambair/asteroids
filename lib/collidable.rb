module Collidable
  attr_reader :x, :y  

  def radius
    @image.width * 2 / 3
  end
end
