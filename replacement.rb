#!/usr/bin/env ruby

module ReplacementStrategy

  # Compute replacement cards for hand with rank
  def ReplacementStrategy.compute_replacement(rank, hand)
    case rank

      when $STRAIGHT_FLUSH 
        replace_cards = nil

      when $FOUR_OF_A_KIND
        # Replace the odd one out if rank < 6
        rank_frequencies = ReplacementStrategy.count_freq_rank(hand)
        replace_cards = ReplacementStrategy.odd_one_out_of_four_of_a_kind(hand, rank_frequencies)

      when $FULL_HOUSE
        replace_cards = nil

      when $FLUSH
        replace_cards = nil

      when $STRAIGHT
        replace_cards = nil

      when $THREE_OF_A_KIND
        # Replace the two odd one out
        rank_frequencies = ReplacementStrategy.count_freq_rank(hand)
        replace_cards = ReplacementStrategy.odd_ones_out_of_pairs_or_triples(hand, rank_frequencies)

      when $TWO_PAIR
        # Replace odd one out
        rank_frequencies = ReplacementStrategy.count_freq_rank(hand)
        replace_cards = ReplacementStrategy.odd_ones_out_of_pairs_or_triples(hand, rank_frequencies)

      when $ONE_PAIR
        # If 4 cards have same suit, replace odd one out
        # Else replace the three odd one out
        suit_frequencies = ReplacementStrategy.count_freq_suit(hand)
        most_freq_suit_count = ReplacementStrategy.count_most_freq_suit_count(suit_frequencies)
        if most_freq_suit_count == 4
          replace_cards = ReplacementStrategy.odd_one_out_of_four_same_suit(hand, suit_frequencies)
        else
          rank_frequencies = ReplacementStrategy.count_freq_rank(hand)
          replace_cards = ReplacementStrategy.odd_ones_out_of_pairs_or_triples(hand, rank_frequencies)
        end

      when $HIGH_CARD
        # If 4 cards have same suit, replace odd one out
        # Else replace the three lowest ranked cards
        suit_frequencies = ReplacementStrategy.count_freq_suit(hand)
        most_freq_suit_count = ReplacementStrategy.count_most_freq_suit_count(suit_frequencies)
        if most_freq_suit_count == 4
          replace_cards = ReplacementStrategy.odd_one_out_of_four_same_suit(hand, suit_frequencies)
        else
          replace_cards = ReplacementStrategy.extract_n_lowest_ranked(hand, 3)
        end

      else
        puts 'Error in compute_replacement'
    end

    if (replace_cards.kind_of?(Array))
      replace_cards.join(' ')
    else
      replace_cards
    end
  end

  def ReplacementStrategy.count_freq_suit(hand)
    c, d, h, s = 0, 0, 0, 0

    hand.each do |card|
      case card[1]
        when 'c' 
          c += 1
        when 'C' 
          c += 1
        when 'd' 
          d += 1
        when 'D' 
          d += 1
        when 'h' 
          h += 1
        when 'H' 
          h += 1
        when 's' 
          s += 1
        when 'S' 
          s += 1
        else 
          puts 'Error in count_freq_suit'
      end
    end

    [c, d, h, s]
  end

  def ReplacementStrategy.count_most_freq_suit_count(arr)
    arr.max
  end

  def ReplacementStrategy.count_freq_rank(hand)
    r2, r3, r4, r5, r6, r7, r8, r9, rT, rJ, rQ, rK, rA =
    0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0

    hand.each do |card|
      case card[0]
        when '2' 
          r2 += 1
        when '3' 
          r3 += 1
        when '4' 
          r4 += 1
        when '5' 
          r5 += 1
        when '6' 
          r6 += 1
        when '7' 
          r7 += 1
        when '8' 
          r8 += 1
        when '9' 
          r9 += 1
        when 'T' 
          rT += 1
        when 'J' 
          rJ += 1
        when 'Q' 
          rQ += 1
        when 'K' 
          rK += 1
        when 'A' 
          rA += 1
        else 
          puts 'Error in count_freq_rank'
      end
    end

    [r2, r3, r4, r5, r6, r7, r8, r9, rT, rJ, rQ, rK, rA]
  end

  def ReplacementStrategy.odd_one_out_of_four_of_a_kind(hand, rank_frequencies)
    hand.each do |card|
      case card[0]
        when '2' 
          return card if rank_frequencies[0] == 1 
        when '3' 
          return card if rank_frequencies[1] == 1
        when '4' 
          return card if rank_frequencies[2] == 1
        when '5' 
          return card if rank_frequencies[3] == 1
        when '6' 
          return '' if rank_frequencies[4] == 1 # Replace if rank < 6
        when '7' 
          return '' if rank_frequencies[5] == 1
        when '8' 
          return '' if rank_frequencies[6] == 1
        when '9' 
          return '' if rank_frequencies[7] == 1
        when 'T' 
          return '' if rank_frequencies[8] == 1
        when 'J' 
          return '' if rank_frequencies[9] == 1
        when 'Q' 
          return '' if rank_frequencies[10] == 1
        when 'K' 
          return '' if rank_frequencies[11] == 1
        when 'A' 
          return '' if rank_frequencies[12] == 1
        else 
          puts 'Error in odd_one_out_of_four_of_a_kind'
      end
    end
  end

  def ReplacementStrategy.odd_one_out_of_four_same_suit(hand, suit_frequencies)
    hand.each do |card|
      case card[1]
        when 'c' 
          return card if suit_frequencies[0] == 1
        when 'C' 
          return card if suit_frequencies[0] == 1
        when 'd' 
          return card if suit_frequencies[1] == 1
        when 'D' 
          return card if suit_frequencies[1] == 1
        when 'h' 
          return card if suit_frequencies[2] == 1
        when 'H' 
          return card if suit_frequencies[2] == 1
        when 's' 
          return card if suit_frequencies[3] == 1
        when 'S' 
          return card if suit_frequencies[3] == 1
        else 
          puts 'Error in odd_one_out_of_four_same_suit'
      end
    end
  end

  def ReplacementStrategy.odd_ones_out_of_pairs_or_triples(hand, rank_frequencies)
    discards = Array.new

    hand.each do |card|
      case card[0]
        when '2' 
          discards << card if rank_frequencies[0] == 1
        when '3' 
          discards << card if rank_frequencies[1] == 1
        when '4' 
          discards << card if rank_frequencies[2] == 1
        when '5' 
          discards << card if rank_frequencies[3] == 1
        when '6' 
          discards << card if rank_frequencies[4] == 1
        when '7' 
          discards << card if rank_frequencies[5] == 1
        when '8' 
          discards << card if rank_frequencies[6] == 1
        when '9' 
          discards << card if rank_frequencies[7] == 1
        when 'T' 
          discards << card if rank_frequencies[8] == 1
        when 'J' 
          discards << card if rank_frequencies[9] == 1
        when 'Q' 
          discards << card if rank_frequencies[10] == 1
        when 'K' 
          discards << card if rank_frequencies[11] == 1
        when 'A' 
          discards << card if rank_frequencies[12] == 1
        else 
          puts 'Error in odd_two_out_of_one_pair'
      end
    end
    discards
  end

  def ReplacementStrategy.extract_n_lowest_ranked(hand, n)
    hand.sort! { |x, y| ReplacementStrategy.get_rank_for(x[0]) <=> ReplacementStrategy.get_rank_for(y[0]) }
    hand[0 .. n-1]
  end

  def ReplacementStrategy.get_rank_for(facevalue)
    case facevalue
      when '2' 
        return $RANK_2
      when '3' 
        return $RANK_3
      when '4' 
        return $RANK_4
      when '5' 
        return $RANK_5
      when '6' 
        return $RANK_6
      when '7' 
        return $RANK_7
      when '8' 
        return $RANK_8
      when '9' 
        return $RANK_9
      when 'T' 
        return $RANK_T
      when 'J' 
        return $RANK_J
      when 'Q' 
        return $RANK_Q
      when 'K' 
        return $RANK_K
      when 'A' 
        return $RANK_A
      else 
        puts 'Error in get_rank_for'
    end
  end
end