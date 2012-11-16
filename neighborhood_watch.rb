#!/usr/bin/env ruby

module NeighborhoodWatch

  def NeighborhoodWatch.get_max_initial_stack(turn_data)
    max_initial_stack = -1
    players_at_table = turn_data['players_at_table']

    players_at_table.each do |player|
      if player['player_name'] == turn_data['name']
        # Skip myself in iterations
        next
      end

      if player['current_bet'] < player['initial_stack']
        # Only count it in comparison if this player didn't go all-in
        max_initial_stack = [max_initial_stack, player['initial_stack']].max
      else
        # A player went all-in, never go into steam roll mode
        return -1
      end
    end
    max_initial_stack
  end

  # Returns true if I am the last place compared to players at table
  def NeighborhoodWatch.am_i_last_place(turn_data)
    min_initial_stack = turn_data['initial_stack']
    players_at_table = turn_data['players_at_table']

    players_at_table.each do |player|
      min_initial_stack = [min_initial_stack, player['initial_stack']].min
    end

    turn_data['initial_stack'] == min_initial_stack
  end
end