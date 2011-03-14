module Collidable
  def hitbox
    { :x => calculate(@x), :y => calculate(@y) }
  end
  
  def calculate num
    ((num - half_size).to_i..(num + half_size).to_i).to_a
  end
  
  def half_size
    @image.width / 2
  end
end
