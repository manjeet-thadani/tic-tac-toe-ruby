require_relative '../core/player'

class HumanPlayer
  include Player

  # defines if player will have marker X or O
  attr_reader :marker
  
  def initialize(marker, ui)
    @marker = marker
    @ui = ui
  end
  
  def select_place(game)
    @ui.choose_marker_position(game.available_spaces)
  end
end
