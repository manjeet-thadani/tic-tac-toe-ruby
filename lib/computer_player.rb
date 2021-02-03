require_relative './player'

class ComputerPlayer
  include Player

  # defines if computer player will have marker X or O
  attr_reader :marker
  
  def initialize(marker)
    @marker = marker
  end
  
  # TODO: Add intelligent code
  def select_place(game)
    game.available_spaces.sample
  end  

end
  