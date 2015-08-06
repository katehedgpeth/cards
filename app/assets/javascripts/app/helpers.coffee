holdem.helpers = 

	getRandomNum: (max) -> 
		num = Math.floor max * Math.random()
		if num == 0 then num = @getRandomNum(max)
		num

	newDeck: ->
		suits = ["Spades", "Clubs", "Hearts", "Diamonds"]
		icons = ["♠", "♣", "♥", "♦"]
		cards = ["Ace", "2", "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Queen", "King"]
		deck = []
		cardNum = 1
		for suit, i in suits
			value = 1;
			for card in cards
				deck.push {
					name: "#{card} of #{suit}",
					id: cardNum,
					suit: suit,
					number: card,
					num: card[0],
					value: value,
					color: if i < 2 then "black" else "red"
					icon: icons[i]
				}
				cardNum++
				value++

		deck

