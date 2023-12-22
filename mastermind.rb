# Class representing the Code Maker who sets the secret code
class Codemaker
  attr_reader :code

  # Initialize with an optional secret code for a human player to play Code Maker
  def initialize(code = nil)
    @code = code || create_code
  end

  # Method to create a random 4-digit code
  def create_code
    ["#{1 + rand(6)}", "#{1 + rand(6)}", "#{1 + rand(6)}", "#{1 + rand(6)}"]
  end
end

# Class representing the Code Breaker who tries to guess the secret code
class Codebreaker
  attr_reader :name

  def initialize(name)
    @name = name
  end
end

# Class representing the game board
class Board
  attr_reader :board, :guess_feedback

  def initialize
    @board = Array.new(12) { Array.new(4, "-") }
    @guess_feedback = Array.new(12) { Array.new(4, "-") }
    @show_code = false # Option to show/hid the secret code for testing purposes. Set @show_code to true to test the program.
  end

  # Method to display the current state of the game board
  def display(game)
    puts "\n"
    puts "|--------------------------------------------------"
    puts "|---------------M-A-S-T-E-R-M-I-N-D----------------"
    puts "|--------------------------------------------------"

    if @show_code
      puts "|     SECRET CODE | #{game.code[0]} | #{game.code[1]} | #{game.code[2]} | #{game.code[3]} |"
    else
      puts "|     SECRET CODE |###|###|###|###|"
    end
    puts "|--------------------------------------------------"
    puts "|       T-U-R-N-S | G-U-E-S-S-E-S | F-E-E-D-B-A-C-K  "
    puts "|       Turn 12   | #{board[11][0]} | #{board[11][1]} | #{board[11][2]} | #{board[11][3]} | #{guess_feedback[11][0]} #{guess_feedback[11][1]} #{guess_feedback[11][2]} #{guess_feedback[11][3]} "
    puts "|       Turn 11   | #{board[10][0]} | #{board[10][1]} | #{board[10][2]} | #{board[10][3]} | #{guess_feedback[10][0]} #{guess_feedback[10][1]} #{guess_feedback[10][2]} #{guess_feedback[10][3]} "
    puts "|       Turn 10   | #{board[9][0]} | #{board[9][1]} | #{board[9][2]} | #{board[9][3]} | #{guess_feedback[9][0]} #{guess_feedback[9][1]} #{guess_feedback[9][2]} #{guess_feedback[9][3]} "
    puts "|       Turn  9   | #{board[8][0]} | #{board[8][1]} | #{board[8][2]} | #{board[8][3]} | #{guess_feedback[8][0]} #{guess_feedback[8][1]} #{guess_feedback[8][2]} #{guess_feedback[8][3]} "
    puts "|       Turn  8   | #{board[7][0]} | #{board[7][1]} | #{board[7][2]} | #{board[7][3]} | #{guess_feedback[7][0]} #{guess_feedback[7][1]} #{guess_feedback[7][2]} #{guess_feedback[7][3]} "
    puts "|       Turn  7   | #{board[6][0]} | #{board[6][1]} | #{board[6][2]} | #{board[6][3]} | #{guess_feedback[6][0]} #{guess_feedback[6][1]} #{guess_feedback[6][2]} #{guess_feedback[6][3]} "
    puts "|       Turn  6   | #{board[5][0]} | #{board[5][1]} | #{board[5][2]} | #{board[5][3]} | #{guess_feedback[5][0]} #{guess_feedback[5][1]} #{guess_feedback[5][2]} #{guess_feedback[5][3]} "
    puts "|       Turn  5   | #{board[4][0]} | #{board[4][1]} | #{board[4][2]} | #{board[4][3]} | #{guess_feedback[4][0]} #{guess_feedback[4][1]} #{guess_feedback[4][2]} #{guess_feedback[4][3]} "
    puts "|       Turn  4   | #{board[3][0]} | #{board[3][1]} | #{board[3][2]} | #{board[3][3]} | #{guess_feedback[3][0]} #{guess_feedback[3][1]} #{guess_feedback[3][2]} #{guess_feedback[3][3]} "
    puts "|       Turn  3   | #{board[2][0]} | #{board[2][1]} | #{board[2][2]} | #{board[2][3]} | #{guess_feedback[2][0]} #{guess_feedback[2][1]} #{guess_feedback[2][2]} #{guess_feedback[2][3]} "
    puts "|       Turn  2   | #{board[1][0]} | #{board[1][1]} | #{board[1][2]} | #{board[1][3]} | #{guess_feedback[1][0]} #{guess_feedback[1][1]} #{guess_feedback[1][2]} #{guess_feedback[1][3]} "
    puts "|       Turn  1   | #{board[0][0]} | #{board[0][1]} | #{board[0][2]} | #{board[0][3]} | #{guess_feedback[0][0]} #{guess_feedback[0][1]} #{guess_feedback[0][2]} #{guess_feedback[0][3]} "
    puts "|--------------------------------------------------"
    puts "|----------------------LEGEND----------------------"
    puts "|-------------------SECRET CODE--------------------"
    puts "| The Secret Code is a 4 digit code"
    puts "| Each digit is a number between 1 and 6"
    puts "|-------------------IN FEEDBACK--------------------"
    puts "| * -> 1 digit correct in both value and position"
    puts "| O -> 1 digit correct only in value "
    puts "| X -> 1 digit incorrect in both value and position"
    puts "|--------------------------------------------------"
    puts "\n"
  end

  def reveal_code
    @show_code = true
  end

end

# Class representing the game logic
class Game
  attr_reader :player_name, :code, :player_guess, :feedback_copy

  def initialize(player_name, codemaker, board, codebreaker = nil)
    @player_name = player_name
    @code = codemaker.code
    @board = board
    @feedback_copy = nil
    @turn_number = 1
    @codebreaker = codebreaker
  end

  # The main method loop for game play
  def play
    if @codebreaker.is_a?(ComputerCodeBreaker)
      computer_play
    else
      human_play
    end
  end

  # Logic for when the computer is playing as the Code Breaker
  def computer_play
    loop do
      puts "\n|--------------------------------------------------"
      puts "\n|                     TURN: #{@turn_number}"
      @board.display(self)
      @player_guess = @codebreaker.make_guess(@feedback_copy)
      @codebreaker.last_guess = @player_guess.join
      puts "| The Code Breaker Computer's Turn #{@turn_number} guess is : #{@player_guess[0]} #{@player_guess[1]} #{@player_guess[2]} #{@player_guess[3]}"
      update_guess_in_board
      check_guess
      update_guess_feedback_in_board
      if win?
        @board.reveal_code
        puts "\n|--------------------------------------------------"
        puts "\n| Game over! You've lost the game! Code Breaker Computer has correctly guessed the secret code."
        @board.display(self)
        break
      elsif @turn_number == 12
        @board.reveal_code
        puts "\n|--------------------------------------------------"
        puts "\n| Congratulations! You've won. Code Breaker computer couldn't guess the Secret Code correctly."
        @board.display(self)
        break
      end
      puts "\n| Press enter to continue to the next turn..."
      gets # Waits for the user to press enter or any key
    @turn_number += 1
    end
  end

  # Logic for when a human is playing as Code Breaker
  def human_play
    # The main game loop for 12 turns or until the game is won
    loop do
      puts "\n|--------------------------------------------------"
      puts "\n|                     TURN: #{@turn_number}"
      @board.display(self)
      prompt_guess
      update_guess_in_board
      check_guess
      update_guess_feedback_in_board
      if win?
        @board.reveal_code
        puts "\n|--------------------------------------------------"
        puts "\n| Congratulations! You've won the game! You've correctly guessed the secret code."
        @board.display(self)
        break
      elsif @turn_number == 12
        @board.reveal_code
        puts "\n|--------------------------------------------------"
        puts "\n| Game over! You've lost. You couldn't guess the Secret Code correctly."
        @board.display(self)
        break
      end
    @turn_number += 1
    end
  end

  # Method to prompt and validate human Code Breaker's guess
  def prompt_guess
    valid = false
    # Loop to ensure the player enters a valid guess
    while !valid
      print "| #{@player_name}, please enter your guess for Turn #{@turn_number} (4 digits, each 1-6): "
      guess = gets.chomp.chars
      puts "\n|--------------------------------------------------"
      puts "\n|                 END OF TURN: #{@turn_number}"
      if guess.length == 4 && guess.all? { |char| char =~ /[1-6]/ }
        @player_guess = guess
        valid = true
      else
        puts "\n| Invalid input. Please enter exactly 4 digits, each from 1 to 6.\n\n"
      end
    end
    puts "\n"
  end

  # Method to update the game board with the Code Breaker's guess
  def update_guess_in_board
    @board.board[@turn_number - 1] = @player_guess
  end

  # Method to check the player's guess against the secret code
  def check_guess
    exact_match = 0
    value_match = 0
    no_match = 0
    guess_copy = @player_guess.dup
    code_copy = @code.dup

    # Check for exact position and value matches
    guess_copy.each_with_index do |num, index|
      if num == code_copy[index]
        exact_match += 1
        guess_copy[index] = nil
        code_copy[index] = nil
      end
    end

    # Check for value matches
    guess_copy.compact.each do |num|
      if num && code_copy.include?(num)
        value_match += 1
        code_copy[code_copy.find_index(num)] = nil
      end
    end

    # Count no matches
    no_match = 4 - exact_match - value_match

    @colour_position_match = exact_match
    @colour_match = value_match
    @no_match = no_match
  end

  # Method to update the game board with the feedback of the guess
  def update_guess_feedback_in_board
    guess_row = @turn_number - 1
    # Logic to update the guess results with "*", "O", and "X"
    @board.guess_feedback[guess_row] = Array.new(@colour_position_match, "*") +
                                       Array.new(@colour_match, "O") +
                                       Array.new(@no_match, "X")

    @feedback_copy = @board.guess_feedback[guess_row]
  end

  # Method to update the game board with the results of the guess
  def win?
    @player_guess == @code
  end
end

# Class representing the Computer Code Breaker's guessing logic
class ComputerCodeBreaker
  attr_accessor :last_guess

  def initialize
    @last_guess = "1122"
    # Generate all possible guesses for the secret code
    @possible_codes = (1111..6666).map(&:to_s).select { |code| code.chars.all? { |digit| digit.between?( '1', '6') } }
  end

  def make_guess(previous_feedback)
    if previous_feedback.nil?
      return ["1", "1", "2", "2"]
    else
      process_feedback(previous_feedback)
      return @possible_codes.sample.chars
    end
  end

  private

  def process_feedback(feedback)
    @possible_codes.reject! do |code|
      !feedback_matches?(code, feedback)
    end
  end

  def feedback_matches?(code, feedback)
    simulate_feedback(code) == feedback
  end

  def simulate_feedback(code)
    return [] if @last_guess.nil? || @last_guess.empty?

    exact_match, value_match = 0, 0

    code_array = code.split("")
    last_guess_array = @last_guess.chars

    code_array.each_with_index do |digit, index|
      if digit ==last_guess_array[index]
        exact_match += 1
        code_array[index] = nil
        last_guess_array[index] = nil
      end
    end

    code_array.compact.each do |digit|
      if last_guess_array.include?(digit)
        value_match += 1
        last_guess_array[last_guess_array.find_index(digit)] = nil
      end
    end

    generated_feedback = Array.new(exact_match, "*") + Array.new(value_match, "O")
    generated_feedback.fill("X", generated_feedback.length...4)
    generated_feedback
  end
end

# Main script to start the game
print "\n| Welcome to Mastermind!\n\n| Mastermind is a two player game in which one player, called the Code Maker, sets a 4 digit Secret Code with each digit being a number between 1 and 6, and the other player, called the Code Breaker, attempts to correctly guess the Secret Code set by the Code Maker in 12 turns or less.\n\n| The Code Maker provides limited feedback to the Code Breaker about their guess after each turn of guess.\n\n| The Code Breaker wins the game on correctly guessing the Secret Code in 12 turns or less.\n\n| The Code Maker wins the game if the Code Breaker is unable to correctly guess the Secret Code in 12 turns of guesses or less.\n\n| Please enter your name to start the game: "

player_name = gets.chomp
puts "\n| #{player_name}, once again, welcome to Mastermind! Would you like to play the Code Maker or the Code Breaker?"
print "\n| Enter 1 to play Code Maker or 2 to play Code Breaker: "

choice = gets.chomp

if choice == "1"
  print "\n| Code Maker #{player_name}, please choose a Secret Code (4 digits, each 1-6): "
  code = gets.chomp.chars
  puts "\n| The Secret Code set by you is: #{code.join("")}"
  codemaker = Codemaker.new(code)
  codebreaker = ComputerCodeBreaker.new
elsif choice == "2"
  #Use the following code when testing the game play:
  #test_code = ["1", "1", "1", "1"]
  #codemaker = Codemaker.new(test_code)
  codemaker = Codemaker.new
  codebreaker = Codebreaker.new(player_name)
end

board = Board.new
game = Game.new(player_name, codemaker, board, codebreaker)
game.play
