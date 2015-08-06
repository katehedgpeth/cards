class holdem.Round
	_.extend(@::, holdem.helpers)

	constructor: (you, players, roundNum) ->
		@roundNum = roundNum
		@players = players
		_.each @players, (v,k,list) -> v.folded = false
		@you = you
		@flop = []
		@numPlayers = _.size(@players)
		@deck = @newDeck()
		@assignSeats()
		@dealHands()
		@applyHandlers()
		@seats = @getSeats()
		@betBefore = _.filter @seats, (d) => 
			seatNum = parseInt($(d).attr("data-seat")) 
			seatNum < @you.seat && seatNum <= @numPlayers
		_.sortBy @betBefore, 
		@betAfter = _.filter @seats, (d) => 
			seatNum = parseInt($(d).attr("data-seat")) 
			seatNum > @you.seat && seatNum <= @numPlayers
		for player, i in @betBefore
			@betBot player, i
			return
		# return

	applyHandlers: ->
		$('#betBtn').click =>
			for div, i in @betAfter
				@betBot div


			# _.each @betAfter, (d) => @betBot d
			# @dealFlop()
		$('.changeBet a').click (e) =>
			@changeBet e.currentTarget
			return

	getSeats: ->
		players = _.sortBy $(".player"), (d) -> $(d).attr("data-seat")

	getCard: ->
		num = @getRandomNum(@deck.length)
		card = @deck.splice(num, 1)[0]
	
	dealHands: ->
		_.each @players, (v,k,list) =>
			player = list[k]
			player.hand = [@getCard(), @getCard()]
			$(".player[data-seat='#{player.seat}'] .card").each (i,d) ->
				card = player.hand[i]
				$(d).addClass(card.suit).append("<p>#{card.num}#{card.icon}</p>")
			return
		return

	assignSeats: ->
		$(".player .name").text("")
		_.each @players, (v,k,list) =>
			player = list[k]
			seat = $(".player[data-seat='#{player.seat}']").addClass("playing")
			if player.name == "You" then seat.attr("id", "you") else seat.addClass("opponent")
			seat.find(".name").text(player.name)
		# $(".player").each (i,d) =>
		# 	seat = parseInt $(d).attr("data-seat")
		# 	if seat < @numPlayers then $(d).addClass("playing")
		# 	player = _.find @players, (p) -> 
		# 		p.seat == seat
		# 	name = if player then player.name else ""
		# 	$(d).addClass("playing")
		# 	$(".name", d).text(name)
			return
		return


	dealFlop: ->
		$("#flop .card").each (i,d) =>
			card = @getCard()
			@flop.push card
			setTimeout ->
				flopCard = $(d).addClass(card.suit).append("<p>#{card.num}#{card.icon}</p>")
			, 500 * i
			return

	changeBet: (d) ->
		amount = parseInt $(d).attr("data-amount")
		bet = parseInt $("#betBtn").attr("data-size")
		@you.stack = if $(d).hasClass("plus") == true then @you.stack - amount else @you.stack + amount
		console.log $(d).hasClass("plus")
		bet = if $(d).hasClass("plus") == true then bet + amount else bet - amount
		$("#betBtn").attr("data-size", bet)
		$(".betAmount span").text(bet)
		$("#you .stack span").text(@you.stack)



	betBot: (d, i = 0) ->
		console.log d
		if $(d).hasClass("folded") == false
			setTimeout ->
				seatNum = parseInt $(d).attr("data-seat")
				player = _.find @players, (plyr) -> plyr.seat == seatNum
				dice = @getRandomNum 3
				if dice == 1
					player.folded = true
					$(d).addClass("folded")
					$(".bet[data-seat='#{seatNum}'] p").text("Fold")
				else
					bet = @getRandomNum player.stack
					player.stack = player.stack - bet
					$(".stack span", d).text(player.stack)
					$(".bet[data-seat='#{seatNum}'] p").text("$#{bet}")
				return
			, 1000 * i
			return 




















