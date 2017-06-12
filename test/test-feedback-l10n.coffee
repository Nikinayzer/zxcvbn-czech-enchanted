test = require 'tape'
feedback = require '../src/feedback'
feedback_l10n = require '../src/feedback_l10n'


test 'localized feedback messages', (t) ->

  match =
    pattern: 'dictionary'
    token: 'token'
    rank: 10
    dictionary_name: 'passwords'

  custom_messages =
    top10_common_password: 'custom#top10_common_password',

  # Uses cs messages
  f = feedback.get_feedback(1, [match], {}, 'cs')
  t.equal f.warning, feedback_l10n.cs.top10_common_password
  t.deepEqual f.suggestions, [feedback_l10n.cs.uncommon_words_are_better]

  # Uses custom messages
  f = feedback.get_feedback(1, [match], custom_messages, 'cs')
  t.equal f.warning, custom_messages.top10_common_password
  t.deepEqual f.suggestions, [feedback_l10n.cs.uncommon_words_are_better]

  t.end()
