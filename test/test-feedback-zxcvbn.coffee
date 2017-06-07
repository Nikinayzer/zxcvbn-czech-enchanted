test = require 'tape'
zxcvbn = require '../src/main'
feedback = require '../src/feedback'

messages = feedback.messages

test 'dictionary_warnings', (t) ->
  msg = "top10_common_password"
  expected = { 
      suggestions: [ messages.uncommon_words_are_better ],
      warning: messages.top10_common_password
    }
  t.deepEqual zxcvbn('password').feedback, expected, msg

  msg = "top100_common_password"
  expected = { 
      suggestions: [ messages.uncommon_words_are_better ],
      warning: messages.top100_common_password
    }
  t.deepEqual zxcvbn('starwars').feedback, expected, msg

  msg = "very_common_password"
  expected = { 
      suggestions: [ messages.uncommon_words_are_better ],
      warning: messages.very_common_password
    }
  t.deepEqual zxcvbn('devilman').feedback, expected, msg

  msg = "similar_to_common_password"
  expected = { 
      suggestions: [ messages.uncommon_words_are_better ],
      warning: messages.similar_to_common_password
    }
  t.deepEqual zxcvbn('starwars9').feedback, expected, msg


  msg = "a_word_is_easy from wikipedia"
  expected = { 
      suggestions: [ messages.uncommon_words_are_better ],
      warning: messages.a_word_is_easy
    }
  t.deepEqual zxcvbn('congress').feedback, expected, msg

  msg = "names_are_easy from surnames"
  expected = { 
      suggestions: [ messages.uncommon_words_are_better ],
      warning: messages.names_are_easy
    }
  t.deepEqual zxcvbn('johnson').feedback, expected, msg

  msg = "names_are_easy from female_names"
  expected = { 
      suggestions: [ messages.uncommon_words_are_better ],
      warning: messages.names_are_easy
    }
  t.deepEqual zxcvbn('margaret').feedback, expected, msg

  msg = "names_are_easy from male_names"
  expected = { 
      suggestions: [ messages.uncommon_words_are_better ],
      warning: messages.names_are_easy
    }
  t.deepEqual zxcvbn('joseph').feedback, expected, msg

  msg = "common_names_are_easy"
  expected = { 
      suggestions: [ messages.uncommon_words_are_better ],
      warning: messages.common_names_are_easy
    }
  t.deepEqual zxcvbn('joseph9').feedback, expected, msg
  t.end()

test 'dictionary_suggestion', (t) ->
  msg = "capitalization_doesnt_help"
  expected = { 
      suggestions: [ messages.uncommon_words_are_better, messages.capitalization_doesnt_help ],
      warning: messages.common_names_are_easy
    }
  t.deepEqual zxcvbn('Joseph9').feedback, expected, msg

  msg = "all_uppercase_doesnt_help"
  expected = { 
      suggestions: [ messages.uncommon_words_are_better, messages.all_uppercase_doesnt_help ],
      warning: messages.common_names_are_easy
    }
  t.deepEqual zxcvbn('JOSEPH9').feedback, expected, msg

  msg = "reverse_doesnt_help"
  expected = { 
      suggestions: [ messages.uncommon_words_are_better, messages.reverse_doesnt_help ],
      warning: messages.common_names_are_easy
    }
  t.deepEqual zxcvbn('hpesoj9').feedback, expected, msg

  msg = "reverse_doesnt_help and capitalization_doesnt_help"
  expected = { 
      suggestions: [ messages.uncommon_words_are_better, messages.capitalization_doesnt_help, messages.reverse_doesnt_help ],
      warning: messages.common_names_are_easy
    }
  t.deepEqual zxcvbn('Hpesoj9').feedback, expected, msg

  msg = "to_100_password and substitution_doesnot_help"
  expected = { 
      suggestions: [ messages.uncommon_words_are_better, messages.substitution_doesnt_help ],
      warning: messages.similar_to_common_password
    }
  t.deepEqual zxcvbn('st@rwars').feedback, expected, msg


  msg = "substitution_doesnot_help, capitalization_doesnt_help and not removed warnings (guesses_log10 > 6)"
  expected = { 
      suggestions: [ messages.uncommon_words_are_better, messages.substitution_doesnt_help ],
      warning: ''
    }
  t.deepEqual zxcvbn('Devi1M@N').feedback, expected, msg


  t.end()


test 'common_suggestion', (t) ->
  msg = "no_need_for_mixed_chars"
  expected = { 
      suggestions: [ messages.use_a_few_words, messages.no_need_for_mixed_chars ],
      warning: ''
    }
  t.deepEqual zxcvbn('').feedback, expected, msg

  t.end()

test 'keyboard_repeat_number_feedback', (t) ->
  msg = "straight_rows_of_keys_are_easy"
  expected = { 
      suggestions: [ messages.uncommon_words_are_better, messages.use_longer_keyboard_patterns ],
      warning: messages.straight_rows_of_keys_are_easy
    }
  t.deepEqual zxcvbn('wertyu').feedback, expected, msg

  msg = "short_keyboard_patterns_are_easy"
  expected = { 
      suggestions: [ messages.uncommon_words_are_better, messages.use_longer_keyboard_patterns ],
      warning: messages.short_keyboard_patterns_are_easy
    }
  t.deepEqual zxcvbn('wertgb').feedback, expected, msg

  msg = "short_keyboard_patterns_are_easy"
  expected = { 
      suggestions: [ messages.uncommon_words_are_better, messages.avoid_repeated_chars ],
      warning: messages.repeated_chars_are_easy
    }
  t.deepEqual zxcvbn('aaaa').feedback, expected, msg

  msg = "repeated_patterns_are_easy"
  expected = { 
      suggestions: [ messages.uncommon_words_are_better, messages.avoid_repeated_chars ],
      warning: messages.repeated_patterns_are_easy
    }
  t.deepEqual zxcvbn('abcabcabc').feedback, expected, msg

  msg = "sequences_are_easy"
  expected = { 
      suggestions: [ messages.uncommon_words_are_better, messages.avoid_sequences ],
      warning: messages.sequences_are_easy
    }
  t.deepEqual zxcvbn('abcde').feedback, expected, msg

  msg = "recent_years_are_easy"
  expected = { 
      suggestions: [ messages.uncommon_words_are_better, messages.avoid_recent_years, messages.avoid_associated_years ],
      warning: messages.recent_years_are_easy
    }
  t.deepEqual zxcvbn('2017').feedback, expected, msg

  msg = "recent_years_are_easy"
  expected = { 
      suggestions: [ messages.uncommon_words_are_better, messages.avoid_associated_dates_and_years ],
      warning: messages.dates_are_easy
    }
  t.deepEqual zxcvbn('22.02.2013').feedback, expected, msg

  t.end()

test 'feedback_skipped', { skip: true }, (t) ->
  msg = "password and year"
  expected = { 
      suggestions: [ messages.uncommon_words_are_better, messages.avoid_recent_years, messages.avoid_associated_years ],
      warning: messages.similar_to_common_password
    }
  t.deepEqual zxcvbn('starwars2017').feedback, expected, msg

  msg = "year and password"
  expected = { 
      suggestions: [ messages.uncommon_words_are_better, messages.avoid_recent_years, messages.avoid_associated_years ],
      warning: messages.recent_years_are_easy
    }
  t.deepEqual zxcvbn('2017starwars').feedback, expected, msg

  msg = "word from user_input"
  expected = { 
      suggestions: [ messages.uncommon_words_are_better, 'Avoid words that are associated with you, with service or with company' ],
      warning: messages.a_word_is_easy
    }
  t.deepEqual zxcvbn('eduroam', ['eduroam', 'lubos' ]).feedback, expected, msg

  #don't work: for word from us_tv_and_film I expect same feedback as for word from english_wikipedia
  msg = "a_word_is_easy from us_tv_and_films"
  expected = { 
      suggestions: [ messages.uncommon_words_are_better ],
      warning: messages.a_word_is_easy
    }
  t.deepEqual zxcvbn('decision').feedback, expected, msg

  #don't work: "devilmAn" is only similar to a commonly used password
  msg = "one upper char in word"
  expected = { 
      suggestions: [ messages.uncommon_words_are_better ],
      warning: messages.similar_to_common_password
    }
  t.deepEqual zxcvbn('devilmAn').feedback, expected, msg

  #don't work: missing warning, for "Devilman" is returned (log10=4.15), but not for "devilm@n" (log10=4.15)
  msg = "substitution_doesnot_help, capitalization_doesnt_help and not removed warnings (guesses_log10 < 6)"
  expected = { 
      suggestions: [ messages.uncommon_words_are_better, messages.substitution_doesnt_help ],
      warning: messages.similar_to_common_password
    }
  t.deepEqual zxcvbn('devilm@n').feedback, expected, msg

  t.end()

test 'feedback_options_get_feedback', (t) ->
  use_a_few_words = messages['use_a_few_words']
  no_need_for_mixed_chars = 'Minimum 8 chars, one alphabet, one non alphabet'

  msg = "internal sequence.length = 0, no_need_for_mixed_chars modified"
  expected = { 
      suggestions: [ use_a_few_words, no_need_for_mixed_chars ],
      warning: ''
    }
  t.deepEqual feedback.get_feedback(0, '', { 
      'use_a_few_words' : use_a_few_words,
      'no_need_for_mixed_chars' : no_need_for_mixed_chars
      }),
      expected, msg 

  msg = "internal sequence.length = 0, no_need_for_mixed_chars modified, use_a_few_words missing"
  expected = { 
      suggestions: [ use_a_few_words, no_need_for_mixed_chars ],
      warning: ''
    }
  t.deepEqual feedback.get_feedback(0, '', { 
      'no_need_for_mixed_chars' : no_need_for_mixed_chars,
      }),
      expected, msg 

  msg = "internal sequence.length = 0, no_need_for_mixed_chars modified, use_a_few_words empty"
  expected = { 
      suggestions: [ no_need_for_mixed_chars ],
      warning: ''
    }
  t.deepEqual feedback.get_feedback(0, '', { 
      'no_need_for_mixed_chars' : no_need_for_mixed_chars,
      'use_a_few_words' : false
      }),
      expected, msg 

  msg = "internal sequence.length = 0, no_need_for_mixed_chars modified, use_a_few_words null"
  expected = { 
      suggestions: [ no_need_for_mixed_chars ],
      warning: ''
    }
  t.deepEqual feedback.get_feedback(0, '', { 
      'no_need_for_mixed_chars' : no_need_for_mixed_chars,
      'use_a_few_words' : null
      }),
      expected, msg 

  msg = "internal score = 3" 
  expected = { 
      suggestions: [ ],
      warning: ''
    }
  t.deepEqual feedback.get_feedback(3, 'something', { 
      'no_need_for_mixed_chars' : 'Minimum 8 chars, one alphabet, one non alphabet',
      }),
      expected, msg 

  t.end()

test 'feedback_options', (t) ->

  custom_messages =
    top10_common_password: 'custom#top10_common_password',
    uncommon_words_are_better: 'custom#uncommon_words_are_better'

  msg = "modified warning and one suggestion"
  expected = { 
      suggestions: [ custom_messages.uncommon_words_are_better, messages.capitalization_doesnt_help ],
      warning: custom_messages.top10_common_password
    }
  t.deepEqual zxcvbn('Password', { feedback_messages: custom_messages }).feedback, expected, msg

  msg = "one modified suggestion, one suggestion empty"
  custom_messages =
    uncommon_words_are_better: 'custom#uncommon_words_are_better'
    capitalization_doesnt_help: false

  expected = { 
      suggestions: [ custom_messages.uncommon_words_are_better ],
      warning: messages.top10_common_password
    }
  t.deepEqual zxcvbn('Password', { feedback_messages: custom_messages }).feedback, expected, msg


  msg = "one modified suggestion, warning empty"
  custom_messages =
    top10_common_password: false,
    uncommon_words_are_better: 'custom#uncommon_words_are_better'

  expected = { 
      suggestions: [ custom_messages.uncommon_words_are_better, messages.capitalization_doesnt_help ],
      warning: ''
    }
  t.deepEqual zxcvbn('Password', { feedback_messages: custom_messages }).feedback, expected, msg

  t.end()
