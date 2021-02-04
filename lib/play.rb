require_relative './cli'

begin
  TTTCLI.new
rescue Interrupt
  puts "\n Tic Tac Toe has been terminated. Exiting..."
end
  