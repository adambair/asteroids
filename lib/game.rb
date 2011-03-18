class GameWindow < Gosu::Window
  POINTS = { 'large'  => 20,
             'medium' => 50,
             'small'  => 100 }

  def initialize
    super(800, 600, false)
    @life_image = Gosu::Image.new(self, "assets/player.png", false)
    @font = Gosu::Font.new(self, 'Inconsolata-dz', 24)
    @state = :title
    title_screen
  end

  # Game States
  #
  def title?
    @state == :title
  end
  
  def playing?
    @state == :playing
  end

  def play!
    @state = :playing
  end

  def game_over?
    @state == :game_over
  end

  def game_over!
    @state = :game_over
  end

  # Prepare Title Screen
  #
  def title_screen
    @asteroids = spawn_asteroids(4)
    @asteroids += @asteroids[0].kill
    @asteroids += @asteroids[1].kill
    @asteroids += @asteroids.last.kill
  end

  # Prepare Game Screen
  #
  def setup_game
    @player = Player.new(self)
    @level = 1
    @score = 0
    @asteroid_count = 3
    @asteroids = spawn_asteroids(@asteroid_count)
    @particles = []
    @projectiles = []
    play!
  end

  # Input
  #
  def button_down(id)
    close if id == Gosu::KbQ || id == Gosu::KbEscape
    shoot if id == Gosu::KbSpace
    
    if title? and id == Gosu::KbS
      setup_game
    end

    if game_over? and id == Gosu::KbR
      title_screen
      setup_game
    end
  end

  # Game Logic
  #
  def update
    handle(@asteroids)

    if playing?
      control_player
      handle(@projectiles)
      handle(@particles)
      detect_collisions

      next_level unless @asteroids.any?
    end
  end

  def control_player
    @player.turn_left  if button_down?(Gosu::KbLeft)
    @player.turn_right if button_down?(Gosu::KbRight)
    @player.accelerate if button_down?(Gosu::KbUp)
    @player.move
  end

  def handle things
    things.each    {|thing| thing.move  }
    things.reject! {|thing| thing.dead? }
  end

  def next_level
    @asteroid_count += 1
    @level += 1
    @asteroids = spawn_asteroids(@asteroid_count)
  end

  def shoot
    if can_shoot?
      @projectiles << @player.shoot
    end
  end

  def can_shoot?
     playing? && @projectiles.size < 5
  end

  def detect_collisions
    @asteroids.each do |asteroid|
      @player.kill if asteroid.collides_with?(@player)

      @projectiles.each do |projectile|
        if asteroid.collides_with?(projectile)
          projectile.kill
          30.times {@particles << Particle.new(self, asteroid)}
          @score += POINTS[asteroid.size]
          @asteroids += asteroid.kill
        end
      end
    end
  end

  def spawn_asteroids(count=3, size='large')
    Array.new(count) { Asteroid.new(self, :size => size) }
  end

  # Render
  #
  def draw
    @asteroids.each{|asteroid| asteroid.draw}

    case @state
    when :title then
      title_text
    when :playing then
      @player.draw
      @projectiles.each{|projectile| projectile.draw}
      @particles.each{|particle| particle.draw}
      show_gui
      game_over! if @player.dead?
    when :game_over then
      game_over_text
    end
  end

  # GUI
  #
  def show_gui
    score_text
    level_text
    draw_lives
  end

  def score_text
    write @score, 10, 10
  end

  def level_text
    write @level, 610, 10
  end

  def draw_lives
    return unless @player.lives > 0
    x = 10
    @player.lives.times do 
      @life_image.draw(x, 40, 0)
      x += 20
    end
  end

  # Texts
  #
  def title_text
    center "ASTEROIDS", 120, 2.8
    center "press 's' to start", 320
    center "press 'q' or 'esc' to quit", 345
  end

  def game_over_text
    center "GAME OVER", 150, 2
    center "press 'r' to restart", 320
    center "press 'q' or 'esc' to quit", 345
  end

  def write text, x, y, factor_x = 1, factor_y = 1
    @font.draw(text, x, y, 50, factor_x, factor_y, Gosu::Color::WHITE)
  end

  def center text, y, factor_x = 1 
    x = (width - @font.text_width(text, factor_x)) / 2
    write(text, x, y, factor_x, factor_x)
  end
end
