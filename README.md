# zxcvbn-czech

Realistic password strength estimation with czech and slovak dictionaries.

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

* Added czech and slovak dictionaries:
  * *cs_names.txt*		- czech firstnames, surnames and nicknames, source: http://www.mvcr.cz/clanek/cetnost-jmen-a-prijmeni-722752.aspx, nicknames are from book [Knappova: "Jak se bude vaše dítě jmenovat?"] (http://www.kosmas.cz/knihy/157964/jak-se-bude-vase-dite-jmenovat/)
  * *cs_passwords.txt*	- compiled from password breach czech users like passwords LinkedIn users with .cz emails
  * *cs_subtitles.txt*	- https://github.com/hermitdave/FrequencyWords.git see also http://opus.lingfil.uu.se/OpenSubtitles2016.php
  * *cs_wikipedia.txt*	- czech wikipedia (like english_wikipedia.txt)
  * *sk_passwords.txt*	- compiled from password breach slovak users like passwords LinkedIn users with .sk emails
  * *sk_subtitles.txt*	- https://github.com/hermitdave/FrequencyWords.git see also http://opus.lingfil.uu.se/OpenSubtitles2016.php
  * *sk_wikipedia.txt*	- czech wikipedia (like english_wikipedia.txt)
* The CZ and SK keyboard layout is also included, so there are additional spatial sequences, e.g. ZuioP0 is a spatial sequence.
* build configuration files - how many words from which dictionary will be included in the created library.
  * data/cs.json			- generate dist/zxcvbn_cs.js
  * data/cs_small.json		- generate dist/zxcvbn_cs_small.js
  * data/sk.json			- generate dist/zxcvbn_sk.js
  * data/default.json		- generate dist/zxcvbn.js
* Our goal is not to exceed 900 KB the size of the library. So we include next modification to build_frequency_lists.py :
  * Skip words with one or two characters. Brutal has better score in most cases. The performance of the library has also improved (see below).
  * Skip words with high rank if one character shorter word + brutal has better score. Example: 'republic' has rank 688, 'republica' has rank 32852. Composition 'republic' + 'a' (brutal) estimate 21814 guesses, so we skip word 'republica'.
* feedback localization
  * support for custom feedback (inspired by pull request #124 from dropbox/zxcvbn - https://github.com/dropbox/zxcvbn/pull/124)
  * support for czech and slovak feedback,

## Installation

See also [Installation from original project dropbox/zxcvbn] (https://github.com/dropbox/zxcvbn#installation).

### Manual instalation
Download some of available libraries:
* [zxcvbn_cs.js](https://raw.githubusercontent.com/lpavlicek/zxcvbn-czech/master/dist/zxcvbn_cs.js) - with english dictionaries, size 845KB,
* [zxcvbn_cs_small.js](https://raw.githubusercontent.com/lpavlicek/zxcvbn-czech/master/dist/zxcvbn_cs_small.js) - with english dictionaries, size 406KB,
* [zxcvbn_sk.js](https://raw.githubusercontent.com/lpavlicek/zxcvbn-czech/master/dist/zxcvbn_sk.js) - with slovak dictionaries, size 690KB,
* [zxcvbn.js](https://raw.githubusercontent.com/lpavlicek/zxcvbn-czech/master/dist/zxcvbn.js) - with english dictionaries, size 814KB,

Add to your .html:

``` html
<script type="text/javascript" src="path/to/zxcvbn.js"></script>
```

## Usage, API

Library API is inspired from pull request #124 from dropbox/zxcvbn - https://github.com/dropbox/zxcvbn/pull/124 and is backward compatible with original API, see [Usage from original project dropbox/zxcvbn] (https://github.com/dropbox/zxcvbn#usage).

``` javascript
zxcvbn(password, user_inputs=[])        // original (old) API
zxcvbn(password, options={})			// new API
```

`zxcvbn()` takes one required argument, a password, and returns a result object with several properties, see [Original API](https://github.com/dropbox/zxcvbn#usage)


The optional `options` argument is an object that can contain the following optional properties:
- `user_inputs` is an array of strings that zxcvbn will treat as an extra dictionary. This can be whatever list of strings you like, but is meant for user inputs from other fields of the form, like name and email. That way a password that includes a user's personal information can be heavily penalized. This list is also good for site-specific vocabulary — Acme Brick Co. might want to include ['acme', 'brick', 'acmebrick', etc].
- `feedback_messages` is an object that enables zxcvbn's consumers to customize the messages used for giving feedback to the user. This could be used to skip messages that aren't desired to be returned as feedback to the user, or to modify or internationalize the existing messages.
The list of keys to be used in this parameter could be find in [./src/feedback.coffee](./blob/master/src/feedback.coffee#L4).
For example, to remove the `use_a_few_words` feedback message, we would call zxcvbn as follows:
```javascript
zxcvbn(password, {
  feedback_messages:{
    use_a_few_words: null
  }
});
```
any falsey value passed as a message will make zxcvbn skip it.
If we would like to modify or internationalize the message instead, we would pass the new message as the value as follows:
```javascript
zxcvbn(password, {
  feedback_messages:{
    use_a_few_words: 'Usa algunas palabras, evita frases comunes'
  }
});
```
any absent message in the `feedback_messages` object will default to the in-app feedback message.
- `feedback_language` - language for localized feedback. The library now contains messages in three languages:
  * `cs` - czech feedback
  * `en` - english feedback (default)
  * `sk` - slovak feedback

Example:
```javascript
var local_dictionary = [ "eduroam", "vsepraha", "wifi" ];

zxcvbn(password, {
	user_input: local_dictionary,
	feedback_language: 'cs'
});
```

### Suggestion

You can create a user dictionary, which will include service names, service marks, product names or specific words from a page to change your password. The typical size is 30 to 100 words. And this dictionary use as second parameter when calling zxcvbn function. You can dynamically add words identifying the user - firstname, lastname, username, address, etc.

## Size, performance

test - nodejs, 66000 different passwords
zxcvbn-dropbox - average 56.7 seconds
zxcvbn-czech   - average 58.5 seconds (without optimization for minimum length word 3 it was 70.1 seconds)

size:
zxcvbn-dropbox  - 820KB,
zxcvbn-cs       - 860KB,
zxcvbn-cs-small - 411KB,
zxcvbn-sk       - 701KB,

## TODO
* support for chars with diacritics in passwords,


## Acknowledgment

Thanks to Dan Wheeler (https://github.com/lowe) for the CoffeeScript implementation (see above).
