class TTTCore
  attr_reader :player_x, :player_o, :current_player
  attr_reader :places, :winner, :draw, :over 

  # TODO: this should be auto generated
  # row, column, diagonal matches check auto
  WIN_COMBINATIONS = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [6, 4, 2],
    [0, 4, 8]
  ]

  def initialize(player_x, player_o)
    # TODO: Add support for more complex board sizes
    @places = Array.new(9, " ") # board of 3 X 3
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

  def move(place)
    @places[place] = @current_player.marker if place_available?(place)

    next_turn
    game_ended?
  end

  # check if place has not been selected and is available
  def place_available?(place)
    @places[place] == " "
  end

  # identify user with next turn
  def next_turn
    @current_player = @current_player.marker.downcase == 'x' ?  player_o : player_x
  end

  # check if game has ended
  def game_ended?
    ended = draw? || player_won?(@player_x) || player_won?(@player_o)
    @over = true if ended
    ended
  end

  def available_spaces
    @places.each_index.select { |place| place_available?(place) }
  end

  def draw?
    @draw = available_spaces.empty?
    @draw
  end

  def player_won?(player)
    result = WIN_COMBINATIONS.detect do |combo|
      @places[combo[0]] == player.marker &&
      @places[combo[0]] == @places[combo[1]] &&
      @places[combo[1]] == @places[combo[2]] &&
      !place_available?(combo[0])
    end

    @winner = player if result
    result
  end
end
