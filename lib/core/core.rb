class TTTCore
  attr_reader :player_x, :player_o
  attr_reader :places, :rows

  def initialize(rows, player_x, player_o)
    initialize_places(rows)

    @rows = rows
    @player_x = player_x
    @player_o = player_o
  end

  # used by the player with current turn to insert marker at position
  def turn
    place = current_player.select_place(self)
    move(place)
  end

  # check if place has not been selected and is available
  def place_available?(place)
    @places[place] != 'X' && @places[place] != 'O'
  end

  # add marker to a specifc position in the board
  def move(place)
    @places[place] = current_player.marker if place_available?(place)
    over?
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

  # check if game has been drawn? i.e. no places left in the board
  def draw?
    available_spaces.empty? && winner.nil?
  end

  def winner
    return @player_x if player_won?(@player_x)
    return @player_o if player_won?(@player_o)

    return nil
  end
  
  # check if game has ended
  def over?
    draw? || player_won?(@player_x) || player_won?(@player_o)
  end

  # identify user with current turn
  def current_player
    available_spaces.size.even? ? @player_o : @player_x
  end

  def reset_place(place)
    @places[place.to_i] = place + 1
  end

  private
    def initialize_places(rows)
      @places = (1 .. rows * rows).to_a
    end

    # check if a player has won
    def player_won?(player)
      win_combinations.any? do |combination|
        combination.all? { |place| place == player.marker }
      end
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
