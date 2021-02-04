class TTTCore
  attr_reader :player_x, :player_o, :current_player
  attr_reader :places, :rows, :winner, :draw, :over 

  def initialize(rows, player_x, player_o)
    initialize_places(rows)

    @rows = rows
    @player_x = player_x
    @player_o = player_o

    # assuming player_x would take first turn
    @current_player = player_x
  end

  # used by the player with current turn to insert marker at position
  def turn
    place = @current_player.select_place(self)
    move(place)
  end

  # check if place has not been selected and is available
  def place_available?(place)
    @places[place] != 'X' && @places[place] != 'O'
  end

  # add marker to a specifc position in the board
  def move(place)
    @places[place] = @current_player.marker if place_available?(place)

    next_turn
    game_ended?
  end

  # utility function to get list of available empty spaces
  def available_spaces
    @places.each_index.select { |place| place_available?(place) }
  end

  def placeholder_to_index(value)
    value - 1
  end

  def index_to_placeholder(index)
    index + 1
  end
  
  private
    def initialize_places(rows)
      @places = (1 .. rows * rows).to_a
    end

    # identify user with next turn
    def next_turn
      @current_player = @current_player.marker == 'X' ?  player_o : player_x
    end

    # check if game has ended
    def game_ended?
      ended = draw? || player_won?(@player_x) || player_won?(@player_o)
      @over = true if ended
      ended
    end

    # check if game has been drawn? i.e. no places left in the board
    def draw?
      @draw = available_spaces.empty?
      @draw
    end

    # check if a player has won
    def player_won?(player)
      result = win_combinations.any? do |combination|
        combination.all? { |place| place == player.marker }
      end

      @winner = player if result
      result
    end

    # return all possible win combinations in the board
    def win_combinations
      split_into_rows
        .concat(split_into_columns)
        .concat(split_diagonals)
    end

    # split board row wise
    def split_into_rows
      @places.each_slice(@rows).to_a
    end

    # split board column wise
    def split_into_columns
      split_into_rows.transpose
    end

    # split board in diagonals (both left and right)
    def split_diagonals
      left = []
      right = []
    
      (0..@rows - 1).each do |position| 
        rows = split_into_rows
        left << rows[position][position]
        right << rows[position][@rows - position - 1]
      end
    
      return [left, right]
    end

end
