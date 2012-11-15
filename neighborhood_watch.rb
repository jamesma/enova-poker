#!/usr/bin/env ruby

module NeighborhoodWatch

  def NeighborhoodWatch.get_max_initial_stack(players_at_table)
    max_initial_stack = -1
    players_at_table.each do |player|
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

end