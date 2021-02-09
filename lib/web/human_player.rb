require_relative '../core/player'

class HumanPlayer
  include Player

  # defines if player will have marker X or O
  attr_reader :marker
  
  def initialize(marker, app)
    @marker = marker
    @app = app
  end
  
  def select_place(game)
    @app.selected_place
  end
end
