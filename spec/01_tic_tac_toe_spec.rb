require_relative '../lib/tic_tac_toe.rb'

describe './lib/tic_tac_toe.rb' do
  describe 'WIN_COMBINATIONS' do
    it 'defines a constant WIN_COMBINATIONS with arrays for each win combination' do
      expect(WIN_COMBINATIONS.size).to eq(8)
      
      expect(WIN_COMBINATIONS).to include([0,1,2])
      expect(WIN_COMBINATIONS).to include([3,4,5])
      expect(WIN_COMBINATIONS).to include([6,7,8])
      expect(WIN_COMBINATIONS).to include([0,3,6])
      expect(WIN_COMBINATIONS).to include([1,4,7])
      expect(WIN_COMBINATIONS).to include([2,5,8])
      expect(WIN_COMBINATIONS).to include([0,4,8])
      expect(WIN_COMBINATIONS).to include([6,4,2])
    end
  end

  describe '#display_board' do
    it 'prints arbitrary arrangements of the board' do
      board = ["X", "X", "X", "X", "O", "O", "X", "O", "O"]

      output = capture_puts{ display_board(board) }

      expect(output).to include(" X | X | X ")
      expect(output).to include("-----------")
      expect(output).to include(" X | O | O ")
      expect(output).to include("-----------")
      expect(output).to include(" X | O | O ")          


      board = ["X", "O", "X", "O", "X", "X", "O", "X", "O"]

      output = capture_puts{ display_board(board) }

      expect(output).to include(" X | O | X ")
      expect(output).to include("-----------")
      expect(output).to include(" O | X | X ")
      expect(output).to include("-----------")
      expect(output).to include(" O | X | O ")          
    end
  end

  describe '#move' do
    it 'allows "X" player in the bottom right and "O" in the top left ' do
      board = [" ", " ", " ", " ", " ", " ", " ", " ", " "]
      move(board, 1, "O")
      move(board, 9, "X")

      expect(board).to eq(["O", " ", " ", " ", " ", " ", " ", " ", "X"])
    end    
  end

  describe '#position_taken?' do
    it 'returns true/false based on position in board' do
      board = ["X", " ", " ", " ", " ", " ", " ", " ", "O"]

      position = 0
      expect(position_taken?(board, position)).to be(true)      
      
      position = 8
      expect(position_taken?(board, position)).to be(true)

      position = 1
      expect(position_taken?(board, position)).to be(false)      

      position = 7
      expect(position_taken?(board, position)).to be(false)      
    end      
  end

  describe '#valid_move?' do
    it 'returns true/false based on position' do
      board = [" ", " ", " ", " ", "X", " ", " ", " ", " "]

      position = "1"
      expect(valid_move?(board, position)).to be_truthy

      position = "5"    
      expect(valid_move?(board, position)).to be_falsey

      position = "invalid"    
      expect(valid_move?(board, position)).to be_falsey
    end
  end  

  describe '#turn' do
    it 'makes valid moves' do
      board = [" ", " ", " ", " ", " ", " ", " ", " ", " "]

      allow($stdout).to receive(:puts)

      expect(self).to receive(:gets).and_return("1")

      turn(board)

      expect(board).to match_array(["X", " ", " ", " ", " ", " ", " ", " ", " "])
    end

    it 'asks for input again after a failed validation' do
      board = [" ", " ", " ", " ", " ", " ", " ", " ", " "]

      allow($stdout).to receive(:puts)

      expect(self).to receive(:gets).and_return("invalid")
      expect(self).to receive(:gets).and_return("1")

      turn(board)      
    end    
  end  

  describe '#turn_count' do
    it 'counts occupied positions' do
      board = ["O", " ", " ", " ", "X", " ", " ", " ", "X"]

      expect(turn_count(board)).to eq(3)
    end    
  end

  describe '#current_player' do
    it 'returns the correct player, X, for the third move' do
      board = ["O", " ", " ", " ", "X", " ", " ", " ", " "]

      expect(current_player(board)).to eq("X")
    end    
  end
  
  describe "#won?" do
    it 'returns false for a draw' do
      board = ["X", "O", "X", "O", "X", "X", "O", "X", "O"]

      expect(won?(board)).to be_falsey
    end

    it 'returns true for a win' do
      board = ["X", "O", "X", "O", "X", "X", "O", "O", "X"]

      expect(won?(board)).to be_truthy
    end
  end

  describe '#draw?' do
    it 'returns true for a draw' do
      board = ["X", "O", "X", "O", "X", "X", "O", "X", "O"]

      expect(draw?(board)).to be_truthy
    end

    it 'returns false for a won game' do
      board = ["X", "O", "X", "O", "X", "X", "O", "O", "X"]

      expect(draw?(board)).to be_falsey
    end    

    it 'returns false for an in-progress game' do
      board = ["X", " ", "X", " ", "X", " ", "O", "O", "X"]

      expect(draw?(board)).to be_falsey
    end    
  end

  describe '#winner' do
    it 'return X when X won' do
      board = ["X", " ", " ", " ", "X", " ", " ", " ", "X"]

      expect(winner(board)).to eq("X")      
    end

    it 'returns O when O won' do
      board = ["X", "O", " ", " ", "O", " ", " ", "O", "X"]

      expect(winner(board)).to eq("O")      
    end

    it 'returns nil when no winner' do
      board = ["X", "O", " ", " ", " ", " ", " ", "O", "X"]

      expect(winner(board)).to be_nil
    end   
  end

  describe '#over?' do
    it 'returns true for a draw' do
      board = ["X", "O", "X", "O", "X", "X", "O", "X", "O"]

      expect(over?(board)).to be_truthy
    end

    it 'returns true for a won game' do
      board = ["X", "O", "X", "O", "X", "X", "O", "O", "X"]

      expect(over?(board)).to be_truthy
    end    

    it 'returns false for an in-progress game' do
      board = ["X", " ", "X", " ", "X", " ", "O", "O", " "]

      expect(over?(board)).to be_falsey
    end 
  end

  describe '#play' do
    it 'prints "Welcome to Tic Tac Toe!"' do
      board = [" ", " ", " ", " ", " ", " ", " ", " ", " "]
      allow($stdout).to receive(:puts)

      allow(self).to receive(:over?).and_return(true)

      expect($stdout).to receive(:puts).with("Welcome to Tic Tac Toe!")

      play(board)
    end

    it 'asks for players input on a turn of the game' do
      board = [" ", " ", " ", " ", " ", " ", " ", " ", " "]
      allow($stdout).to receive(:puts)
      allow(self).to receive(:over?).and_return(false, true)

      expect(self).to receive(:gets).at_least(:once).and_return("1")      

      play(board)
    end

    it 'checks if the game is over after every turn' do
      board = [" ", " ", " ", " ", " ", " ", " ", " ", " "]
      allow($stdout).to receive(:puts)
      allow(self).to receive(:gets).and_return("1", "2", "3")      

      expect(self).to receive(:over?).at_least(:twice).and_return(false, false, true)
      
      play(board)
    end

    it 'plays the first turn of the game' do
      board = [" ", " ", " ", " ", " ", " ", " ", " ", " "]
      allow($stdout).to receive(:puts)
      allow(self).to receive(:gets).and_return("1")      

      allow(self).to receive(:over?).and_return(false, true)

      # expect(self).to receive(:turn).at_least(:once)
      
      play(board)
      expect(board).to match_array(["X", " ", " ", " ", " ", " ", " ", " ", " "])
    end

    it 'plays the first few turns of the game' do
      board = [" ", " ", " ", " ", " ", " ", " ", " ", " "]
      allow($stdout).to receive(:puts)
      allow(self).to receive(:gets).and_return("1","2","3")      
      allow(self).to receive(:over?).and_return(false, false, false, true)
      
      play(board)

      expect(board).to match_array(["X", "O", "X", " ", " ", " ", " ", " ", " "])
    end
    
    it 'checks if the game is won after every turn' do
      board = [" ", " ", " ", " ", " ", " ", " ", " ", " "]
      allow($stdout).to receive(:puts)
      allow(self).to receive(:gets).and_return("1", "2", "3")      
      allow(self).to receive(:winner).and_return("X")

      expect(self).to receive(:won?).at_least(:twice).and_return(false, false, true)
      
      play(board)
    end

    it 'checks if the game is draw after every turn' do
      board = [" ", " ", " ", " ", " ", " ", " ", " ", " "]
      allow($stdout).to receive(:puts)
      allow(self).to receive(:gets).and_return("1", "2", "3")      
      
      expect(self).to receive(:draw?).at_least(:twice).and_return(false, false, true)
      
      play(board)
    end

    it 'stops playing if someone has won' do
      board = ["X", "X", "X", " ", " ", " ", " ", " ", " "]
      allow($stdout).to receive(:puts)
      
      expect(self).to_not receive(:turn)      
      
      play(board)
    end

    it 'congratulates the winner X' do
      board = ["X", "X", "X", " ", " ", " ", " ", " ", " "]
      allow($stdout).to receive(:puts)
      
      expect($stdout).to receive(:puts).with("Congratulations X!")      
      
      play(board)
    end

    it 'congratulates the winner O' do
      board = [" ", " ", " ", " ", " ", " ", "O", "O", "O"]
      allow($stdout).to receive(:puts)
      
      expect($stdout).to receive(:puts).with("Congratulations O!")      
      
      play(board)
    end

    it 'stops playing in a draw' do
      board = ["X", "O", "X", "O", "X", "X", "O", "X", "O"]
      allow($stdout).to receive(:puts)
      
      expect(self).to_not receive(:turn)      
      
      play(board)
    end

    it 'prints "Cats Game!" on a draw' do
      board = ["X", "O", "X", "O", "X", "X", "O", "X", "O"]
      allow($stdout).to receive(:puts)

      expect($stdout).to receive(:puts).with("Cats Game!")      
      
      play(board)
    end

    it 'plays through an entire game' do
      board = [" ", " ", " ", " ", " ", " ", " ", " ", " "]
      allow($stdout).to receive(:puts)
      
      expect(self).to receive(:gets).and_return("1")      
      expect(self).to receive(:gets).and_return("2")      
      expect(self).to receive(:gets).and_return("3")      
      expect(self).to receive(:gets).and_return("4")      
      expect(self).to receive(:gets).and_return("5")      
      expect(self).to receive(:gets).and_return("6")      
      expect(self).to receive(:gets).and_return("7")   

      expect($stdout).to receive(:puts).with("Congratulations X!")      

      play(board)
    end
  end
end
