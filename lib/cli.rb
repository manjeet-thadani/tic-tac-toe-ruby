require_relative './core'
require_relative './human_player'
require_relative './computer_player'

class TTTCLI

  def initialize(input=$stdin, output=$stdout)
    @input = input
    @output = output
    start
  end

  def choose_marker_position(options)
    offset_spaces = options.map { |space| space + 1 }
    get_valid_input(offset_spaces) - 1
  end

  def get_valid_input(options)
    puts "Available options: #{options}"

    choice = @input.gets.chomp.to_i
    if options.include? choice
      choice
    else
      @output.puts "Invalid Selection"
      get_valid_input(options)
    end
  end

  def start
    initialize_game
    until @game.over
      take_turn
    end
    print_outcome
  end

  def initialize_game      
    @output.puts "Tic Tac Toe"

    player_x = select_player("X")
    player_o = select_player("O")
    @game = TTTCore.new(player_x, player_o)
  end

  def select_player(marker)
    @output.puts "Choose player type for #{marker}"
    @output.puts "1) Human"
    @output.puts "2) Computer"

    choice = get_valid_input([1,2])
    return HumanPlayer.new(marker, self) if choice == 1
    return ComputerPlayer.new(marker) if choice == 2
  end

  def take_turn
    # if it is computer turn do not print
    if @game.current_player.instance_of?(HumanPlayer) 
      display_board
      print_players_turn
    end
    @game.turn
  end

  def print_players_turn      
    @output.puts "#{@game.current_player.marker}, take your turn"
  end

  # TODO: update based on the board size
  def display_board
    puts ""
    puts " #{@game.places[0]} | #{@game.places[1]} | #{@game.places[2]} "
    puts " ----------- "
    puts " #{@game.places[3]} | #{@game.places[4]} | #{@game.places[5]} "
    puts " ----------- "
    puts " #{@game.places[6]} | #{@game.places[7]} | #{@game.places[8]} "
  end

  def print_outcome
    @output.puts "Game Over"
    display_board
    @output.puts @game.winner ? "#{@game.winner.marker} is the winner" : "Tied Game"
  end

end
