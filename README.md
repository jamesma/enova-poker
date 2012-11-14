{
  // Your bot's name
  "name": "Lacey Kuhic", 

  // Your stack as it was at the start of the hand 
  // (*before* the ante)
  "initial_stack": 500, 

  // Returns true if it is your turn and false if 
  // it is not your turn.
  "your_turn": false, 

  // Your current bet (this is an absolute value 
  // from the start of the round, including the 
  // ante).
  "current_bet": 50, 

  // The minimum bet you must make to stay in the 
  // round. If the current betting_phase is not deal 
  // or post_draw, you can ignore this value.
  "minimum_bet": 50,

  // The maximum bet that you can place (always the 
  // same as initial_stack, since we view bets as an 
  // absolute amount from the start of the round). We 
  // send this parameter so that you can guarantee 
  // your bet amount is between minimum_bet and 
  // maximum_bet easily.
  "maximum_bet": 500, 

  // Your five-card hand. This is an array of strings. 
  // See the Suit Lookup tab for info on the card values.
  "hand": ["2S", "TH", "AH", "AD", "2D"],

  // Returns the current state of the round: 
  // Either deal, draw, post_draw, or showdown.
  // You should bet when the betting_phase is "deal" or 
  // "post_draw", and you should replace cards when the 
  // betting_phase is "draw". You do not need to do 
  // anything when the betting_phase is "showdown".
  "betting_phase": "deal", 

  // The state of all players at the current table. If 
  // you want to tell which players have folded, look
  // for players with an action 'fold' in their history.
  "players_at_table": [
    { "player_name":    "Aida Gusikowski", 
      "initial_stack":  250, 
      "current_bet":    50, 
      "actions": [
        { "action":"ante", "amount": 20 },
        { "action":"bet", "amount": 50 }
      ]
    },
    { "player_name":    "Person Bot", 
      "initial_stack":  220, 
      "current_bet":    50, 
      "actions": [
        { "action":"ante", "amount": 20 },
        { "action":"bet", "amount": 50 }
      ]
    }
  ]

  // The number of players remaining in the tournament.
  "total_players_remaining": 100,

  // The id of your table. Probably not useful for your bot.
  "table_id": 12, 

  // The id of the current round. Useful if you're tracking 
  // round progress on your own.
  "round_id": 59, 

  // An array of recent rounds that your bot has played.
  // Note that a non-negative stack change means you won or 
  // broke even during the round, whereas a negative stack 
  // change means you lost during the round. We will only 
  // return the past 10 rounds' worth of history.
  "round_history": [
    {"round_id": 59, "table_id": 3, "stack_change": 2368}, 
    {"round_id": 58, "table_id": 3, "stack_change": 120}
  ]    

  // The time at which you lost. If this is non-null, you 
  // can stop sending requests.
  "lost_at": null
}