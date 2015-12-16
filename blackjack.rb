class Blackjack


	def initialize name
	  @name = name
	  @player_money = 500
	  @face_value = [2,3,4,5,6,7,8,9,10,'Jack','King','Queen','Ace']
	  @suits = ['Diamonds','Clubs','Hearts','Spades']
	  @single_deck = @face_value.product(@suits)  #all cards in a single deck of play
	  @total_decks = 3
	  @game_deck = []  #all cards available for play in the game
	  @shoe = []  #cards remaining in the shoe that the dealer is dealing from
	  @dealer_hand = []
	  @your_hand = []
	  @dealer_is_showing = [] #dealer's face up card on the initial deal
	  @your_count = [] #numerical value of your hand
	  @dealer_count = [] #numerical value of dealer's hand
	  @your_last_card = [] #your last card that was drawn
	  @dealer_last_card = [] #dealer's last card
	  
	  puts ''
	  puts 'Welcome, ' + @name + '.'
	  puts ''
	  
	end

	def sit_at_table
		#clear table
		  @dealer_hand.clear
		  @your_hand.clear
		  @dealer_is_showing.clear
		  @your_count.clear
		  @dealer_count.clear
		  @your_last_card.clear 
		  @dealer_last_card.clear

		if @player_money < 20
			puts ''
			puts 'It looks like you can\'t cover the minimum bet.  Game over, sonny.'
			puts ''
			exit
			
		elsif @player_money > 3000
			puts ''
			puts 'You won so much money from us. Please go play somewhere else.'
			puts ''
			exit
			
		else
			  		  
			reshoe_check
			puts 'Place your bets!'
			puts 'Your cash: $' + @player_money.to_s
			@bet = gets.chomp.to_i
			wager
		
		end
		
	end

	def create_shoe  #establishes all cards in field of play and shuffles the deck
		@game_deck = @single_deck * @total_decks
		@shoe = @game_deck.shuffle
	end



	def reshoe_check #if deck count is less than 25% of total, create a new shoe
		if  @shoe.empty? || @shoe.length <= (0.25 * @game_deck.length)
		system ("cls")
		puts 'Please hold.  Shuffling a new shoe.'
		create_shoe
		sleep 1
		puts '...'
		sleep 1
		puts '...'
		sleep 1
		puts 'New shoe has been shuffled.'
		sleep 1
		puts ''
		else
		end
	end




	def wager
			
		if @bet < 20 && @player_money >= 20
			puts ''
			puts 'You think this is the low roller table? Minimum bet here is $20!  Try again!'
			puts ''
			sit_at_table
		elsif @bet > @player_money
			puts ''
			puts 'You don\'t have that kind of money, buddy. Try again.'
			puts ''
			sit_at_table
		else
			@player_money -= @bet
			initial_deal
		end
	end



def card_reader cards
	cards.each do |x|
		puts x.join(' of ')
		end	
end


def count_value whos_hand

	@hand_value = 0
	faces = [] #holder for number/face (no suits)
	how_many_aces = 0
	no_aces = []
	aces = []   #aces is a holder of Ace values.  Values will either be 1 or 11
	value_without_aces = 0
	hurdle = 0
	value_of_aces = 0

	#put number values of the hand in an array called total_faces
	whos_hand.each do |card|
		card.each do |face, suit|
			faces << face
		end
	end
	
	how_many_aces = faces.count('Ace')	#count the # of aces in the hand

	no_aces = faces.reject {|card| card == 'Ace'}   #remove the aces from the hand; we will deal with aces in the final step
	
	#replace all "king, queen, or jack" strings to integer value 10
	no_aces.map! {|x| x == ('King') ? 10 : x}
	no_aces.map! {|x| x == ('Queen') ? 10 : x}
	no_aces.map! {|x| x == ('Jack') ? 10 : x}
	
	#add all no_aces integer values and store as value_without_aces
	value_without_aces = no_aces.inject(:+).to_i

	
	hurdle = 21 - value_without_aces  #amount left over for the aces to fill
	
	#for every ace in the hand, check "hurdle" and determine if that ace value should be a 1 or 11
	if how_many_aces > 0
		i = 0
		until i == how_many_aces
			if hurdle >= 11
				aces << 11
				hurdle -= 11
				i += 1
			else
				aces << 1
				hurdle -= 1
				i += 1
			end

		value_of_aces = aces.inject(:+).to_i  	#add all the integer values in the aces array and store as value_of_aces

		end
	else
		
	end
	
	
	@hand_value = value_without_aces + value_of_aces

	
end



	def initial_deal

	#you get dealt 1st and 3rd card, dealer gets dealt 2nd and 4th card from shoe
	 2.times do 
		hit @your_hand
		hit @dealer_hand
		end

	@dealer_is_showing = @dealer_hand[0] #unique array for dealer's show card
	
	@first_turn = true #counter for blackjack_check method. this counter is checked at info_screen_you method and turned off at blackjack_check method
	@whos_turn = 'me' #trigger your turn or dealer turn
	
	
	info_screen_top
		
	end
	
	
def info_screen_top

	system ("cls")

	puts '--------------------------------------------------------------'
	puts 'Money remaining: ' + @player_money.to_s
	puts 'CURRENT BET: $' + @bet.to_s
	puts ''
	puts @shoe.length.to_s + ' cards left out of ' + @game_deck.length.to_s
	puts ''

	if @whos_turn == 'me'
		info_screen_dealer_start
	else
		info_screen_dealer_turn
	end
	
end

#dealer start menu ONLY shows one card. the other card is considered "face down"
def info_screen_dealer_start

	puts 'Dealer is showing ' + @dealer_is_showing.join(' of ')
	puts ''

	info_screen_you

end


#dealer turn menu shows both hole cards on dealer's turn
def info_screen_dealer_turn

	puts 'Dealer has:'
	card_reader @dealer_hand
	puts ''
	puts 'Dealer\'s total count is ' 
	count_value @dealer_hand
	puts @hand_value
	puts ''

	info_screen_you

end


def info_screen_you

	puts 'You have:'
	card_reader @your_hand
	puts ''
	puts 'Your total count is ' 
	@your_hand_value = 0
	count_value @your_hand
	@your_hand_value = @hand_value.to_i
	puts @your_hand_value
	puts '--------------------------------------------------------------'


		if @first_turn == true
			blackjack_check
		else
		end


	puts
	puts

	what_happened	

end


def what_happened

	if @whos_turn == 'me'
		if @first_turn == true
			@first_turn = false
			action_menu
		elsif @first_turn != true
			puts 'You BLAHHHH pulled the ' + @your_last_card.join(' of ') + '.'
			puts ''
			sleep 1
			bust_check @your_hand_value
			action_menu
		else
		end
	elsif @whos_turn == 'dealer'
		if @dealer_show_other_card == true
			puts 'Dealer\'s hidden card is the ' + @dealer_hand[1].join(' of ') + '.'
			puts ''
			sleep 1
			@dealer_show_other_card = false
			dealer_turn
		elsif @dealer_show_other_card == false
			puts 'Dealer pulled the ' + @dealer_last_card.join(' of ') + '.'
			puts ''
			sleep 1
			bust_check @dealer_hand_value
			dealer_turn
		else
		end
	else 
	end

	
end


def bust_check whos_hand_value
	
	bust_count = whos_hand_value.to_i
		
	if bust_count > 21 
		if @whos_turn == 'me'
			puts 'Busted!  Over 21'
			sleep 1
			puts ''
			puts 'Dealer\'s other card was a ' + @dealer_hand[1].join(' of ') + '.'
	
		elsif @whos_turn == 'dealer'
			puts 'Dealer BUSTS!!! You win!'
			@player_money += (2 * @bet)
			puts '$' + (2 * @bet).to_s  + ' added to your stack.'

		else
		end
	
		puts ''
		puts ''
		sleep 1
		sit_at_table
	
	else
	end

end




def action_menu
	puts ''
	puts 'What would you like to do?'
	puts 'A - Hit'
	puts 'B - Stay'
	puts 'O - Leave table'
	action = gets.chomp.downcase

	
	if action == 'a'
		hit @your_hand
		@your_last_card = card_reader @your_hand.last #unique array for the last card you pulled
		info_screen_top

	elsif action == 'b'
		@whos_turn = 'dealer'
		@dealer_show_other_card = true
		info_screen_top
		
	elsif action == 'o'
		puts 'Thanks for playing.  You have taken your remaining $' + @player_money.to_s + '.'
		exit
		
	else
		puts ''
		puts 'Please select an option from the menu.'
		puts ''
		action_menu
	end
	
end


def dealer_turn
	@dealer_hand_value = 0
	count_value @dealer_hand
	@dealer_hand_value = @hand_value.to_i

		until @dealer_hand_value > 16
		hit @dealer_hand
		@dealer_last_card = card_reader @dealer_hand.last 
		info_screen_top
		end
	
	bust_check @dealer_hand_value
	check_winner
	
end



def hit someones_hand
	someones_hand << [@shoe.shift]
end



def blackjack_check

	count_value @your_hand
	do_you_have_blackjack = @hand_value.to_i


	count_value @dealer_hand
	does_dealer_have_blackjack = @hand_value.to_i


	if do_you_have_blackjack == 21	&& does_dealer_have_blackjack != 21
		puts 'BLACKJACK!!! YOU WIN!'
		@player_money += (3 * @bet)
		puts '$' + (3 * @bet).to_s  + ' added to your stack.'
		puts 'Dealer\'s other card was a ' + @dealer_hand[1].join(' of ') + '.'
		puts ''
		puts ''
		sleep 1
		sit_at_table
	
	elsif does_dealer_have_blackjack == 21 && do_you_have_blackjack != 21
		puts 'Dealer has Blackjack.  Sorry!'
		puts 'Dealer\'s other card was a ' + @dealer_hand[1].join(' of ') + '.'
		puts ''
		puts ''
		sleep 1
		sit_at_table
	
	elsif does_dealer_have_blackjack == 21 && do_you_have_blackjack == 21
		puts 'You BOTH have Blackjack! What are the odds?'
		puts 'Your bet has been returned to you.'
		puts ''
		@player_money += @bet
		puts 'Dealer\'s other card was a ' + @dealer_hand[1].join(' of ') + '.'
		puts ''
		puts ''
		sleep 1
		sit_at_table
	else
	end

	do_you_have_blackjack = 0
	does_dealer_have_blackjack = 0
	
end



def check_winner
#compare your hand and dealer hand.

	dealer_hand_value = 0
	your_hand_value = 0

	count_value @dealer_hand
	dealer_hand_value = @hand_value.to_i
	
	count_value @your_hand
	your_hand_value = @hand_value.to_i
	
	if dealer_hand_value > your_hand_value
		puts 'Dealer wins.'
	elsif dealer_hand_value < your_hand_value
		puts 'YOU WIN!'
		@player_money += (2 * @bet)
		puts '$' + (2 * @bet).to_s  + ' added to your stack.'
	elsif dealer_hand_value == your_hand_value
		puts 'PUSH'
		@player_money += @bet
		puts '$' + @bet.to_s  + ' added to your stack.'
	end
	
	dealer_hand_value = 0
	your_hand_value = 0
	
	puts ''
	puts ''
	sleep 1
	sit_at_table
	
end


end #end of class

play = Blackjack.new 'Player1'
play.sit_at_table