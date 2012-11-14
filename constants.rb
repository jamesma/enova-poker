#!/usr/bin/env ruby

module Constants

  # Enova's API
  $PLAYER_KEY            = 'fc2455f8-1879-4ad4-8012-1f337c2869f2'
  $SANDBOX_KEY_BET       = 'fc2455f8-1879-4ad4-8012-1f337c2869f2'
  $SANDBOX_KEY_REPLACE   = '728f53dd-a5dc-4582-8864-be37576b9592'

  $ENOVA_GET_ENDPOINT    = 'http://no-limit-code-em.com/api/players/'
  $ENOVA_POST_ENDPOINT   = 'http://no-limit-code-em.com/api/players/'

  $SANDBOX_GET_ENDPOINT  = 'http://no-limit-code-em.com/sandbox/players/'
  $SANDBOX_POST_ENDPOINT = 'http://no-limit-code-em.com/sandbox/players/'

  $POST_ACTION           = '/action'

  # 5 card poker rankings and strings
  $STRAIGHT_FLUSH  = 1
  $FOUR_OF_A_KIND  = 2
  $FULL_HOUSE      = 3
  $FLUSH           = 4
  $STRAIGHT        = 5
  $THREE_OF_A_KIND = 6
  $TWO_PAIR        = 7
  $ONE_PAIR        = 8
  $HIGH_CARD       = 9

  $STRAIGHT_FLUSH_STR  = 'STRAIGHT_FLUSH'
  $FOUR_OF_A_KIND_STR  = 'FOUR_OF_A_KIND'
  $FULL_HOUSE_STR      = 'FULL_HOUSE'
  $FLUSH_STR           = 'FLUSH'
  $STRAIGHT_STR        = 'STRAIGHT'
  $THREE_OF_A_KIND_STR = 'THREE_OF_A_KIND'
  $TWO_PAIR_STR        = 'TWO_PAIR'
  $ONE_PAIR_STR        = 'ONE_PAIR'
  $HIGH_CARD_STR       = 'HIGH_CARD'
  $NOT_FOUND_STR       = 'NOT_FOUND'

  # Betting weights
  $STRAIGHT_FLUSH_WT  = 1
  $FOUR_OF_A_KIND_WT  = 0.8
  $FULL_HOUSE_WT      = 0.7
  $FLUSH_WT           = 0.65
  $STRAIGHT_WT        = 0.6
  $THREE_OF_A_KIND_WT = 0.4
  $TWO_PAIR_WT        = 0.3
  $ONE_PAIR_WT        = 0.25
  $HIGH_CARD_WT       = 0.2

  $BETTING_MAX_WT     = 0.75

  # Rank values for face values
  $RANK_2 = 0
  $RANK_3 = 1
  $RANK_4 = 2
  $RANK_5 = 3
  $RANK_6 = 4
  $RANK_7 = 5
  $RANK_8 = 6
  $RANK_9 = 7
  $RANK_T = 8
  $RANK_J = 9
  $RANK_Q = 10
  $RANK_K = 11
  $RANK_A = 12

end