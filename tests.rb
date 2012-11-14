#!/usr/bin/env ruby

module Tests

  $TEST_HANDS = [
    ['Ah', 'Kh', 'Qh', 'Jh', 'Th'],     # royal flush
    ['9c', '8c', '7c', '6c', '5c'],     # straight flush
    ['Ah', 'As', 'Ad', 'Ac', 'Kh'],     # four of kind
    ['Ah', 'Ac', 'Ad', 'Kh', 'Kc'],     # full house
    ['As', 'Ts', '7s', '6s', '2s'],     # flush
    ['5c', '4d', '3s', '2h', 'Ah'],     # straight
    ['Ah', 'As', 'Ad', 'Ks', 'Qc'],     # three of kind
    ['Ah', 'As', 'Kc', 'Kh', 'Qs'],     # two pairs
    ['Ah', 'As', 'Kh', 'Qs', 'Jd'],     # one pair
    ['Ah', 'Ks', 'Qd', 'Jc', '9s']      # high card
  ]

end