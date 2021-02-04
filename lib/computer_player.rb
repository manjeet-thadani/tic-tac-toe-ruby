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
    # NOTE: use this to obtain random from available spaces
    # game.available_spaces.sample

    get_best_move(game)
  end

  def get_best_move(game, depth=0, best_score={})
    return 0 if game.draw?
    return -1 if game.over?

    game.available_spaces.each do |space|
      game.move(space)
      best_score[space] = -1 * get_best_move(game, depth + 1, {})
      game.reset_place(space)
    end

    best_move = best_score.max_by { |key, value| value }[0]
    highest_minimax_score = best_score.max_by { |key, value| value }[1]

    if depth == 0
      return best_move
    elsif depth > 0
      return highest_minimax_score
    end
  end
end