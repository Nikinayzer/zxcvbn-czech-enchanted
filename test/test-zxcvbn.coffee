test = require 'tape'
zxcvbn = require '../src/main'
feedback = require '../src/feedback'
feedback_l10n = require '../src/feedback_l10n'

local_dictionary = [ 'OurNiceService', 'OurGoodCompany' ]
messages = feedback_l10n.en
messages_cs = feedback_l10n.cs

custom_messages =
  top10_common_password: 'custom#top10_common_password',
  uncommon_words_are_better: 'custom#uncommon_words_are_better'

test 'zxcvbn_run', (t) ->

  msg = "top10_common_password"
  expected = { 
      suggestions: [ messages['uncommon_words_are_better'] ],
      warning: messages['top10_common_password']
    }
  expected_custom = { 
      suggestions: [ 'custom#uncommon_words_are_better' ],
      warning: 'custom#top10_common_password'
    }
  expected_l10n = { 
      suggestions: [ messages_cs['uncommon_words_are_better'] ],
      warning: messages_cs['top10_common_password']
    }

  expected_local_dictionary = { 
      suggestions: [ messages['uncommon_words_are_better'] ],
      warning: messages['a_word_is_easy']
    }

  t.deepEqual zxcvbn('password').feedback, expected, msg

  t.deepEqual zxcvbn('password', local_dictionary).feedback, expected, msg

  t.deepEqual zxcvbn('password', { } ).feedback, expected, msg

  t.deepEqual zxcvbn('password', { user_inputs: local_dictionary } ).feedback, expected, msg

#  t.deepEqual zxcvbn('password', { user_inputs: local_dictionary, feedback_messages: custom_messages } ).feedback, expected_custom, msg

  t.deepEqual zxcvbn('password', { feedback_messages: custom_messages } ).feedback, expected_custom, msg

  t.deepEqual zxcvbn('password', { feedback_language: 'cs' } ).feedback, expected_l10n, msg

  t.deepEqual zxcvbn('OurGoodCompany', local_dictionary).feedback, expected_local_dictionary, msg

  t.deepEqual zxcvbn('OurGoodCompany', { user_inputs: local_dictionary} ).feedback, expected_local_dictionary, msg

  t.end()
