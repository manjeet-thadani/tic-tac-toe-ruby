require "sinatra/base"

require_relative '../core/core'
require_relative '../core/computer_player'
require_relative './human_player'

class TTTWeb < Sinatra::Base
  enable :sessions
  set :root, File.join(File.dirname(__FILE__), '..', '..')

  set :board_game, nil
  set :selected_place, nil

  # Pops the game mode selection menu
  get '/' do
    erb :index
  end

  # Implements the game mode selection and redirects to the game screen
  get '/mode/:mode' do
    redirect to('/game')
  end

  # Intializes the game
  get '/game' do
    board_size = 3
    player_x = HumanPlayer.new("X", self)
    player_o = HumanPlayer.new("O", self) # ComputerPlayer.new("O")

    TTTWeb.board_game = TTTCore.new(board_size, player_x, player_o)
    set_session_data

    erb :game # renders the game screen
  end

  # Makes a move
  get '/move/:place' do
    session[:error] = nil
    place = params[:place].to_i - 1

    if ! TTTWeb.board_game.place_available?(place)
      session[:error] = 'Invalid move'
    else
      TTTWeb.selected_place = place
      TTTWeb.board_game.turn

      set_session_data
      TTTWeb.selected_place = nil
    end
    erb :game
  end

  def set_session_data
    session[:places] = TTTWeb.board_game.places
    session[:rows] = TTTWeb.board_game.rows
    session[:current_player] = TTTWeb.board_game.current_player.marker
    session[:current_player_computer] = TTTWeb.board_game.current_player.instance_of?(ComputerPlayer) 
    session[:game_over] = nil

    if TTTWeb.board_game.over?
      session[:game_over] = TTTWeb.board_game.over?
      session[:winner] = TTTWeb.board_game.winner ? TTTWeb.board_game.winner.marker : nil
    end
  end

  def selected_place
    TTTWeb.selected_place.to_i
  end

  run!
end
