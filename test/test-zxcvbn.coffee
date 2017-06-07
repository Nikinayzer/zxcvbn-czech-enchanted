test = require 'tape'
zxcvbn = require '../src/main'
feedback = require '../src/feedback'

local_dictionary = [ 'OurNiceService', 'OurGoodCompany' ]
messages = feedback.messages

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

  t.deepEqual zxcvbn('password').feedback, expected, msg

  t.deepEqual zxcvbn('password', local_dictionary).feedback, expected, msg

  t.deepEqual zxcvbn('password', { } ).feedback, expected, msg

  t.deepEqual zxcvbn('password', { user_input: local_dictionary } ).feedback, expected, msg

#  t.deepEqual zxcvbn('password', { user_input: local_dictionary, feedback_messages: custom_messages } ).feedback, expected_custom, msg

  t.deepEqual zxcvbn('password', { feedback_messages: custom_messages } ).feedback, expected_custom, msg

  t.end()
