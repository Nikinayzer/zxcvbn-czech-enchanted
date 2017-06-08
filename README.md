# zxcvbn-czech

Realistic password strength estimation with czech dictionaries.

This is fork of dropbox/zxcvbn, which is JavaScript password strength estimation. Please refer to [zxcvbn: realistic password strength estimation] (http://tech.dropbox.com/?p=165) for the full details and motivation behind zxcbvn. The source code for the original JavaScript (well, actually CoffeeScript) implementation can be found at:

https://github.com/dropbox/zxcvbn

## Motivation
Many user passwords are dependent on language. zxcvbn relies on dictionaries, original dictionaries are focused on English users. Follows 10 most common passwords from LinkedIn breach for users with e-mail address ending .cz 

password | zxcvbn score | zxcvbn log10 guesses
-------- | ------------ | --------------------
123456 | 0 | 0.3
linkedin | 1 | 4.4
slunicko | 2 | 8.0
beruska | 2 | 7.0
martin | 0 | 1.2
aaaaaa | 0 | 1.9
111111 | 0 | 1.0
hesloheslo | 1 | 4.6
heslo123 | 2 | 6.3
janicka | 2 | 6.8

In our opinion, this passwords should have score 0 on Czech websites. The exception is 'linkedin' - the name of the service. This word should be in user dictionary (user_inputs[] - second parametr for function zxcvbn).


## Differences from the original version.

* Added next czech dictionaries:
  * *czech_names.txt*      - czech firstnames, surnames and nicknames, source: http://www.mvcr.cz/clanek/cetnost-jmen-a-prijmeni-722752.aspx, nicknames are from book [Knappova: "Jak se bude vaše dítě jmenovat?"] (http://www.kosmas.cz/knihy/157964/jak-se-bude-vase-dite-jmenovat/)
  * *czech_passwords.txt*  - compiled from data breach czech users like passwords LinkedIn users with .cz emails
  * *czech_subtitles.txt*	 - https://github.com/hermitdave/FrequencyWords.git see also http://opus.lingfil.uu.se/OpenSubtitles2016.php
  * *czech_wikipedia.txt*	 - wikipedia (like english_wikipedia.txt)
* Our goal is not to exceed 900 KB the size of the library. So we include next modification to build_frequency_lists.py :
  * We modified num of words from dictionaries, for example num words from us_tv_and_film reduced from 30000 to 8000.
  * Skip words with one or two characters. Brutal has better score in most cases.
  * Skip words with high rank if one character shorter word + brutal has better score. Example: 'republic' has rank 688, 'republica' has rank 32852. Composition 'republic' + 'a' (brutal) estimate 21814 guesses, so we skip word 'republica'.
* The CZ keyboard layout is also included, so there are additional spacial sequences, e.g. ZuioP0 is a spatial sequence.

## Installation

Please see [Installation from original project dropbox/zxcvbn] (https://github.com/dropbox/zxcvbn#installation).

## Usage, API

Library API don't changed, so please see [Usage from original project dropbox/zxcvbn] (https://github.com/dropbox/zxcvbn#usage).

### Suggestion

You can create a user dictionary, which will include service names, service marks, product names or specific words from a page to change your password. The typical size is 30 to 100 words. And this dictionary use as second parameter when calling zxcvbn function. You can dynamically add words identifying the user - firstname, lastname, username, address, etc.

## Size, performance

test - nodejs, 66000 different passwords
zxcvbn-dropbox - average 56.7 seconds
zxcvbn-czech   - average 58.5 seconds (without optimization for minimum length word 3 it was 70.1 seconds)

size:
zxcvbn-dropbox - 820KB,
zxcvbn-czech   - 880KB,

## TODO
* support for chars with diacritics in passwords,
* feddback_messages in czech language - we are waiting for changes in master (see https://github.com/dropbox/zxcvbn/pull/124)
* improve dictionary czech_passwords.txt, now it is much influenced by passwords leaked from LinkedIn for czech users.


## Acknowledgment

Thanks to Dan Wheeler (https://github.com/lowe) for the CoffeeScript implementation (see above).
