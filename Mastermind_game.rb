# Code class represents the secret code to be guessed
class Code
  attr_reader :sequence
  
  def initialize(sequence)
    @sequence = sequence
  end
end

# Player class represents the player of the game
class Player
  attr_reader :name
  
  def initialize(name)
    @name = name
  end
end

# Game class represents the Mastermind game
class Game
  attr_reader :player, :secret_code, :attempts_left, :code_length
  
  def initialize(player, code_length)
    @player = player
    @code_length = code_length
    @secret_code = Code.new(generate_secret_code)
    @attempts_left = 10
  end
  
  def generate_secret_code
    colors = ['R', 'G', 'B', 'Y', 'P', 'O', 'W', 'S'] # Example set of colors
    Array.new(@code_length) { colors.sample } # Generate a random code of specified length
  end
  
  def make_guess(guess)
    @attempts_left -= 1
    compare_codes(guess)
  end
  
  def compare_codes(guess)
    black_pegs = 0
    white_pegs = 0
    
    guess.each_with_index do |color, index|
      if color == @secret_code.sequence[index]
        black_pegs += 1
      elsif @secret_code.sequence.include?(color)
        white_pegs += 1
      end
    end
    
    [black_pegs, white_pegs]
  end
  
  def game_over?
    @attempts_left <= 0
  end
end

# Main program
puts "Welcome to Mastermind!"
puts "Enter your name:"
player_name = gets.chomp
player = Player.new(player_name)

puts "Select code length (4, 6, 8):"
code_length = gets.chomp.to_i
until [4, 6, 8].include?(code_length)
  puts "Invalid input. Please select 4, 6, or 8:"
  code_length = gets.chomp.to_i
end

game = Game.new(player, code_length)

until game.game_over?
  puts "Attempts left: #{game.attempts_left}"
  puts "Make a guess (e.g., for code length #{code_length}, guess 'RGBY' or 'RGBYOP' etc.):"
  guess = gets.chomp.upcase.split('')
  feedback = game.make_guess(guess)
  puts "Feedback: #{feedback[0]} black peg(s) and #{feedback[1]} white peg(s)"
end

if ((feedback[0] == 4) or (feedback[0] == 6) or (feedback[0] == 8))
  puts "Congratulations, #{player_name}! You guessed the secret code #{game.secret_code.sequence.join}!"
else
  puts "Game over. You ran out of attempts. The secret code was #{game.secret_code.sequence.join}."
end

