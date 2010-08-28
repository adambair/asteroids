#!/usr/bin/env ruby -w

require 'lib/gosu.for_1_8.bundle'
require 'lib/player'
require 'lib/asteroid'
require 'lib/projectile'

class GameWindow < Gosu::Window
  def initialize
    super(640, 480, false)
    @background_image = Gosu::Image.new(self, "assets/background.png", true)
    @life_image = Gosu::Image.new(self, "assets/ship.png", false)
    @font = Gosu::Font.new(self, 'Inconsolata-dz', 24)
    @game_in_progress = false
    title_screen
  end

  def title_screen
    @asteroids = Asteroid.spawn(self, 4)
    @asteroids += @asteroids[0].kill
    @asteroids += @asteroids[1].kill
    @asteroids += @asteroids.last.kill
  end

  def setup_game
    @player = Player.new(self)
    @level = 1
    @asteroid_count = 3
    @asteroids = Asteroid.spawn(self, @asteroid_count)
    @projectiles = []
    @game_in_progress = true
  end

  # 60 times per second
  def update
    if button_down? Gosu::KbQ
      close
    end

    if button_down? Gosu::KbS
      setup_game unless @game_in_progress
    end

    if button_down? Gosu::KbR
      title_screen unless @game_in_progress == false
      @game_in_progress = false
    end
    
    @asteroids.each{|asteroid| asteroid.move}
    @asteroids.reject!{|asteroid| asteroid.dead?}

    return unless @game_in_progress

    control_player unless @player.dead?

    @player.move

    @projectiles.each{|projectile| projectile.move}
    @projectiles.reject!{|projectile| projectile.dead?}

    detect_collisions
    next_level if @asteroids.size == 0 
  end

  def next_level
    @asteroid_count += 1
    @level += 1
    @asteroids = Asteroid.spawn(self, @asteroid_count)
  end

  # happens immediately after each iteration of the update method
  def draw
    @background_image.draw(0, 0, 0)
    @asteroids.each{|asteroid| asteroid.draw}

    unless @game_in_progress
      @font.draw("ASTEROIDS", 175, 120, 50, 2.8, 2.8, 0xffffffff)
      @font.draw("press 's' to start", 210, 320, 50, 1, 1, 0xffffffff)
      @font.draw("press 'q' to quit", 216, 345, 50, 1, 1, 0xffffffff)
    end
    return unless @game_in_progress

    if @player.lives <= 0
      @font.draw("GAME OVER", 200, 150, 50, 2.0, 2.0, 0xffffffff)
      @font.draw("press 'r' to restart", 195, 320, 50, 1, 1, 0xffffffff)
      @font.draw("press 'q' to quit", 210, 345, 50, 1, 1, 0xffffffff)
    end
    
    @player.draw unless @player.dead?
    @projectiles.each{|projectile| projectile.draw}
    draw_lives
    @font.draw(@player.score, 10, 10, 50, 1.0, 1.0, 0xffffffff)
    @font.draw(@level, 610, 10, 50, 1.0, 1.0, 0xffffffff)
  end 

  def draw_lives
    return unless @player.lives > 0
    x = 10
    @player.lives.times do 
      @life_image.draw(x, 40, 0)
      x += 20
    end
  end

  def button_down(id)
    close if id == Gosu::KbQ
    if id == Gosu::KbSpace
      @projectiles << Projectile.new(self, @player) unless @player.dead?
    end
  end

  def control_player
    if button_down? Gosu::KbLeft
      @player.turn_left
    end
    if button_down? Gosu::KbRight
      @player.turn_right
    end
    if button_down? Gosu::KbUp
      @player.accelerate
    end
  end

  def detect_collisions
    @asteroids.each do |asteroid| 
      if collision?(asteroid, @player)
        @player.kill
      end
    end
    @projectiles.each do |projectile| 
      @asteroids.each do |asteroid|
        if collision?(projectile, asteroid)
          projectile.kill
          @player.score += asteroid.points
          @asteroids += asteroid.kill
        end
      end
    end
  end

  def collision?(object_1, object_2)
    hitbox_1, hitbox_2 = object_1.hitbox, object_2.hitbox
    common_x = hitbox_1[:x] & hitbox_2[:x]
    common_y = hitbox_1[:y] & hitbox_2[:y]
    common_x.size > 0 && common_y.size > 0 
  end
end

window = GameWindow.new
window.show

