#!/usr/bin/env ruby

require 'rubygems'
require 'net/http'
require 'json'
require 'logger'

require "./constants"
require "./replacement"

# Send a GET request and returns response
def game_state(player_key, get_endpoint)
  uri = URI(get_endpoint + player_key)
  Net::HTTP.get_response(uri)
end

# Send a POST request
def player_action(player_key, post_endpoint)
  nil
end

# Poker player infinite loop
def poker_player(player_key, get_endpoint, post_endpoint)

  while true
    sleep 1

    response = game_state(player_key, get_endpoint)

    turn_data = JSON.parse(response.body)

    ### OVERRIDES ###
    turn_data['hand'] = ['2s', '5c', '3d', '4h', '7s']
    turn_data['betting_phase'] = 'draw'
    ### OVERRIDES ###

    pretty_print_data(turn_data)

    if turn_data.has_key?('your_turn') && turn_data['your_turn']
      rank = obtain_rank(turn_data['hand'])

      ### DEAL OR POST_DRAW ###
      if turn_data['betting_phase'] == 'deal' || turn_data['betting_phase'] == 'post_draw'
        bet = compute_bet(rank, turn_data['minimum_bet'], turn_data['maximum_bet'])
        action_and_bet = check_bet_boundary(bet, turn_data['minimum_bet'], turn_data['maximum_bet'], turn_data['current_bet'])
        
        @@logger.warn('POST action: ' + action_and_bet[0])
        @@logger.warn('POST amount: ' + action_and_bet[1].to_s)

        my_action = { action: action_and_bet[0], amount: action_and_bet[1] }

      ### DRAW ###
      elsif turn_data['betting_phase'] == 'draw'
        action = 'replace'
        discards = ReplacementStrategy.compute_replacement(rank, turn_data['hand'])

        @@logger.warn('POST action: ' + action)
        @@logger.warn('POST cards: ' + discards.to_s)

        my_action = { action: action, cards: discards }

      ### SHOWDOWN ###
      else
        @@logger.warn('SHOWDOWN!')
      end
    end
  end
end

# Return bet after comparison with min, max, and curr bets
def check_bet_boundary(bet, minimum_bet, maximum_bet, current_bet)
  if bet < minimum_bet
    if current_bet > minimum_bet
      ['bet', current_bet]
    else
      ['fold', nil]
    end
  elsif bet > maximum_bet
    ['bet', maximum_bet]
  else
    ['bet', bet]
  end
end

# Apply weights to bet and return newly computed bet
def compute_bet(rank, minimum_bet, maximum_bet)
  weighted_max = $BETTING_MAX_WT * maximum_bet

  case rank
    when $STRAIGHT_FLUSH
      bet = maximum_bet
    when $FOUR_OF_A_KIND
      bet = weighted_max * $FOUR_OF_A_KIND_WT
    when $FULL_HOUSE
      bet = weighted_max * $FULL_HOUSE_WT
    when $FLUSH
      bet = weighted_max * $FLUSH_WT
    when $STRAIGHT
      bet = weighted_max * $STRAIGHT_WT
    when $THREE_OF_A_KIND
      bet = weighted_max * $THREE_OF_A_KIND_WT
    when $TWO_PAIR
      bet = weighted_max * $TWO_PAIR_WT
    when $ONE_PAIR
      bet = weighted_max * $ONE_PAIR_WT
    when $HIGH_CARD
      bet = weighted_max * $HIGH_CARD_WT
    else
      @@logger.error('Error in compute_bet')
  end

  puts 'compute_bet returns ' + bet.to_s
  bet
end

# Run executable and returns exit status of program
def obtain_rank(hand_array)
  hand_string = hand_array.join(' ')
  exec_command = './allfive ' + hand_string
  puts exec_command
  system(exec_command)
  $?.exitstatus
end

# Print string of matched hand
def print_hand_match(rank)
  case rank
    when $STRAIGHT_FLUSH 
      str = $STRAIGHT_FLUSH_STR
    when $FOUR_OF_A_KIND
      str = $FOUR_OF_A_KIND_STR
    when $FULL_HOUSE
      str = $FULL_HOUSE_STR
    when $FLUSH
      str = $FLUSH_STR
    when $STRAIGHT
      str = $STRAIGHT_STR
    when $THREE_OF_A_KIND
      str = $THREE_OF_A_KIND_STR
    when $TWO_PAIR
      str = $TWO_PAIR_STR
    when $ONE_PAIR
      str = $ONE_PAIR_STR
    when $HIGH_CARD
      str = $HIGH_CARD_STR
    else
      str = $NOT_FOUND_STR
  end

  str + ' (' + rank.to_s + ')'
end

# Pretty print response
def pretty_print_data(turn_data)
  @@logger.info('')
  @@logger.info('')

  if turn_data.has_key? 'your_turn'
    # @@logger.info('your_turn: ' + turn_data['your_turn'].to_s)
    your_turn = turn_data['your_turn'].to_s
  end

  if turn_data.has_key? 'betting_phase'
    # @@logger.info('betting_phase: ' + turn_data['betting_phase'])
    betting_phase = turn_data['betting_phase']
  end

  prepend_length = 50 - your_turn.size - betting_phase.size
  separator = ''
  
  prepend_length.times do
    separator << '-'
  end

  separator << your_turn + '-----' + betting_phase
  @@logger.info(separator)

  if turn_data.has_key? 'hand'
    rank = obtain_rank(turn_data['hand'])
    @@logger.info('hand: ' + turn_data['hand'].join(' ') + ' -----> ' + print_hand_match(rank))
  end

  if turn_data.has_key? 'initial_stack'
    @@logger.info('initial_stack: ' + turn_data['initial_stack'].to_s)
  end
  
  if turn_data.has_key? 'current_bet'
    @@logger.info('current_bet: ' + turn_data['current_bet'].to_s)
  end

  if turn_data.has_key? 'minimum_bet'
    @@logger.info('minimum_bet: ' + turn_data['minimum_bet'].to_s)
  end

  if turn_data.has_key? 'maximum_bet'
    @@logger.info('maximum_bet: ' + turn_data['maximum_bet'].to_s)
  end

  extract_round_history(turn_data)
end

# Extract round history information
def extract_round_history(turn_data)
  if turn_data.has_key? 'round_history'
    round_history = turn_data['round_history']
    history = ''

    round_history.each do |match|
      history << match['stack_change'].to_s unless match['stack_change'].nil?
    end

    @@logger.info('round_history: ' + history) unless history.empty?
  end
end

# Ruby script starts here
if __FILE__ == $0
  @@logger = Logger.new('log.txt')
  @@logger.datetime_format = "%H:%M:%S"
  @@logger.level = Logger::INFO
  poker_player($SANDBOX_KEY_REPLACE, $SANDBOX_GET_ENDPOINT, $SANDBOX_POST_ENDPOINT)
end
