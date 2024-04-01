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
  attr_reader :player, :secret_code, :attempts_left, :code_length, :allow_duplicates

  def initialize(player, code_length, allow_duplicates)
    @player = player
    @code_length = code_length
    @allow_duplicates = allow_duplicates
    @secret_code = Code.new(generate_secret_code)
    @attempts_left = 10
  end

  def generate_secret_code
    colors = ['Red', 'Green', 'Blue', 'Yellow', 'Purple', 'Orange', 'White', 'Silver']
    code = []
    while code.length < @code_length
      color = colors.sample
      code << color if @allow_duplicates || !code.include?(color)
    end
    code
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

puts "Allow duplicates in the code? (yes/no):"
allow_duplicates = gets.chomp.downcase == 'yes'

game = Game.new(player, code_length, allow_duplicates)

puts "Available colors: Red, Green, Blue, Yellow, Purple, Orange, White, Silver"

puts "\nFeedback Explanation:"
puts "After each guess, you will receive feedback in the form of black and white pegs."
puts "- Black pegs indicate the number of colors that are correct and in the correct position."
puts "- White pegs indicate the number of colors that are correct but in the wrong position.\n"

puts "Make a guess by typing a sequence of colors separated by spaces."
puts "For example, for a code length of #{code_length}, you could guess:"
example_colors = ['Red', 'Green', 'Blue', 'Yellow', 'Purple', 'Orange', 'White', 'Silver']
puts example_colors.take(code_length).join(' ')

until game.game_over?
  puts "Attempts left: #{game.attempts_left}"
  guess = gets.chomp.split.map(&:capitalize)
  feedback = game.make_guess(guess)
  puts "Feedback: #{feedback[0]} black peg(s) and #{feedback[1]} white peg(s)"
end

if game.secret_code.sequence == guess
  puts "Congratulations, #{player_name}! You guessed the secret code #{game.secret_code.sequence.join(' ')}!"
else
  puts "Game over. You ran out of attempts. The secret code was #{game.secret_code.sequence.join(' ')}."
end
