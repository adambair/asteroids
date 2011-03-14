module Collidable
  def hitbox
    { :x => ((@x - half_size).to_i..(@x + half_size).to_i).to_a,
      :y => ((@y - half_size).to_i..(@y + half_size).to_i).to_a }
  end
  
  def half_size
    @image.width / 2
  end
end
