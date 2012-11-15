#!/usr/bin/env ruby

require 'rubygems'
require 'net/http'
require 'json'
require 'logger'

require "./constants"
require "./replacement"
require "./tests"
require "./neighborhood_watch"

$counter = 0

# Send a GET request and returns response
def game_state(player_key, get_endpoint)
  uri = URI(get_endpoint + player_key)
  Net::HTTP.get_response(uri)
end

# Send a POST request
def player_action(player_key, post_endpoint, my_action)
  uri = URI(post_endpoint + player_key + $POST_ACTION)
  # response = Net::HTTP.post_form(uri, my_action)

  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Post.new(uri.request_uri)
  request.set_form_data(my_action)

  request["Content-Type"] = "application/json"

  response = http.request(request)

  # Status
  @@logger.warn('')
  @@logger.warn('Post Response Status: ' + response.code.to_s + ' ' + response.message.to_s)
end

# Poker player infinite loop
def poker_player(player_key, get_endpoint, post_endpoint)

  while true
    sleep 1

    response = game_state(player_key, get_endpoint)

    turn_data = JSON.parse(response.body)

    ### OVERRIDES ###
    prng = Random.new
    # turn_data['hand'] = $TEST_HANDS[prng.rand(0 .. $TEST_HANDS.size-1)]
    # # turn_data['minimum_bet'] = 150
    # turn_data['betting_phase'] = 'deal'
    ### OVERRIDES ###

    rank = obtain_rank(turn_data['hand'])
    pretty_print_data(turn_data, rank)
    pretty_print_entire_data(turn_data)

    if turn_data.has_key?('your_turn') && turn_data['your_turn']

      ### DEAL OR POST_DRAW ###
      if turn_data['betting_phase'] == 'deal' || turn_data['betting_phase'] == 'post_draw'
        bet = compute_bet(rank, turn_data['minimum_bet'], turn_data['maximum_bet'], turn_data['current_bet'])

        max_initial_stack = set_betting_mode(turn_data)

        if $BETTING_MODE == $STEAM_ROLL_MODE
          @@logger.warn('>>>>> STEAM_ROLL_MODE (max_initial_stack: ' + max_initial_stack.to_s + ') <<<<<')
          action_and_bet = ['bet', max_initial_stack]
        else
          if turn_data['betting_phase'] == 'deal'
            action_and_bet = check_bet_boundary_deal(bet, turn_data['minimum_bet'], turn_data['maximum_bet'], turn_data['current_bet'])
          else
            action_and_bet = check_bet_boundary_post_draw(bet, turn_data['minimum_bet'], turn_data['maximum_bet'], turn_data['current_bet'])
          end
        end

        print_bet_data(turn_data, action_and_bet[1])
        
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
      end
    end

    # SEND POST REQUEST
    player_action(player_key, post_endpoint, my_action)
  end
end

# Sets betting mode and returns max_initial_stack
def set_betting_mode(turn_data)
  max_initial_stack = NeighborhoodWatch.get_max_initial_stack(turn_data['players_at_table'])
  cutoff = turn_data['initial_stack'] * $STEAM_ROLL_MODE_CUTOFF

  # Steam roll mode is set if cutoff is met
  if (max_initial_stack != -1) && (max_initial_stack <= cutoff)
    $BETTING_MODE = $STEAM_ROLL_MODE
  else
    $BETTING_MODE = $NORMAL_MODE
  end
  max_initial_stack
end

# Return bet after comparison with min, max, and curr bets for deal phase
def check_bet_boundary_deal(bet, minimum_bet, maximum_bet, current_bet)
  if bet < minimum_bet
    ['fold', nil]
  elsif bet >= maximum_bet
    ['bet', maximum_bet]
  else
    # minimum_bet <= bet < maximum_bet
    ['bet', minimum_bet]
  end
end

# Return bet after comparison with min, max, and curr bets for post_draw phase
def check_bet_boundary_post_draw(bet, minimum_bet, maximum_bet, current_bet)
  if bet < minimum_bet
    ['fold', nil]
  elsif bet >= maximum_bet
    ['bet', maximum_bet]
  else
    # minimum_bet <= bet < maximum_bet
    ['bet', bet]
  end
end

# Apply weights to bet and return newly computed bet
def compute_bet(rank, minimum_bet, maximum_bet, current_bet)
  case rank
    when $STRAIGHT_FLUSH
      bet = maximum_bet * $STRAIGHT_FLUSH_WT
    when $FOUR_OF_A_KIND
      bet = maximum_bet * $FOUR_OF_A_KIND_WT
    when $FULL_HOUSE
      bet = maximum_bet * $FULL_HOUSE_WT
    when $FLUSH
      bet = maximum_bet * $FLUSH_WT
    when $STRAIGHT
      bet = maximum_bet * $STRAIGHT_WT
    when $THREE_OF_A_KIND
      bet = maximum_bet * $THREE_OF_A_KIND_WT
    when $TWO_PAIR
      bet = maximum_bet * $TWO_PAIR_WT
    when $ONE_PAIR
      bet = maximum_bet * $ONE_PAIR_WT
    when $HIGH_CARD
      bet = maximum_bet * $HIGH_CARD_WT
    else
      @@logger.error('Error in compute_bet')
  end

  # Round to nearest integer and take the max of bet & current_bet
  [bet, current_bet].max.round
end

# Run executable and returns exit status of program
def obtain_rank(hand_array)
  hand_string = hand_array.join(' ')
  exec_command = './allfive ' + hand_string
  # puts exec_command
  puts ''
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

# Pretty print entire JSON payload
def pretty_print_entire_data(turn_data)
  @@other_logger.info(JSON.pretty_generate(turn_data))
end

# Pretty print snippets of data
def pretty_print_data(turn_data, rank)
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

def print_bet_data(turn_data, bet)
  puts 'min: ' + turn_data['minimum_bet'].to_s + ' | max: ' + turn_data['maximum_bet'].to_s + ' | curr: ' + turn_data['current_bet'].to_s + ' | bet: ' + bet.to_s
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

  @@other_logger = Logger.new('other_log.txt')
  @@other_logger.datetime_format = "%H:%M:%S"
  @@other_logger.level = Logger::INFO
  poker_player($SANDBOX_KEY_REPLACE, $SANDBOX_GET_ENDPOINT, $SANDBOX_POST_ENDPOINT)
end
