require_relative './core'
require_relative './human_player'
require_relative './computer_player'

class TTTCLI

  def initialize(input=$stdin, output=$stdout)
    @input = input
    @output = output
    start
  end

  # utility used to print available options to CLI and select next marker position
  def choose_marker_position(options)
    available_spaces = options.map { |space| @game.index_to_placeholder(space) }
    @output.puts "Available Options: #{available_spaces}"

    @game.placeholder_to_index(get_valid_input(available_spaces))
  end

  private
    # start the TTT game
    def start
      initialize_game
      until @game.over?
        take_turn
      end
      print_outcome
    end

    # initialize TTT game
    def initialize_game      
      @output.puts "=============== Tic Tac Toe ==============="

      board_size = select_board_size
      player_x = select_player("X")
      player_o = select_player("O")
      @game = TTTCore.new(board_size, player_x, player_o)
    end

    def select_board_size
      @output.puts "Enter the number of rows on the board "
      @output.puts "Select 3 or 4"

      get_valid_input([3,4])
    end

    def select_player(marker)
      @output.puts "Choose player type for #{marker}"
      @output.puts "1) Human"
      @output.puts "2) Computer"

      choice = get_valid_input([1,2])
      return HumanPlayer.new(marker, self) if choice == 1
      return ComputerPlayer.new(marker) if choice == 2
    end

    def get_valid_input(options)
      choice = @input.gets.chomp.to_i

      if options.include? choice
        choice
      else
        @output.puts "Invalid Selection"
        get_valid_input(options)
      end
    end
    
    def take_turn
      clear_screen
      # if it is computer turn do not print
      if @game.current_player.instance_of?(HumanPlayer) 
        display_board
        print_players_turn
      end
      @game.turn
    end

    def print_players_turn      
      @output.puts "\n#{@game.current_player.marker}, take your turn"
    end

    def display_board
      rows = @game.places.each_slice(@game.rows).to_a
      formatted_rows = rows.map { |row| " #{row.join(' | ')}  " }

      line_seperator = "-" * (@game.rows * 3 + ( @game.rows - 1))

      @output.puts "\n   Board:  \n\n"
      @output.puts formatted_rows.join("\n#{line_seperator}\n")
    end

    def print_outcome
      clear_screen
      @output.puts "Game Over"
      display_board
      @output.puts @game.winner ? "\n#{@game.winner.marker} is the winner" : "Tied Game"
    end

    def clear_screen
      @output.puts "\e[2J\e[f"
    end

end
