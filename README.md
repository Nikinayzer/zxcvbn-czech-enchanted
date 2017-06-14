# zxcvbn-czech

Realistic password strength estimation with Czech and Slovak dictionaries.

This is fork of dropbox/zxcvbn, which is JavaScript password strength estimation. Please refer to [zxcvbn: realistic password strength estimation] (http://tech.dropbox.com/?p=165) for the full details and motivation behind zxcbvn. The source code for the original JavaScript (well, actually CoffeeScript) implementation can be found at:

https://github.com/dropbox/zxcvbn

## Motivation
Many user passwords are dependent on language. zxcvbn relies on dictionaries, original dictionaries are focused on English users. Follows 10 most common passwords from LinkedIn breach for users with e-mail address ending .cz:

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

In our opinion, this passwords should have score 0 on Czech websites. The exception is 'linkedin' - the name of the service. This word should be in user dictionary (optional parameter `user_inputs`).


## Differences from the original version.

* Added Czech and Slovak dictionaries:
  * *cs_names.txt*		- Czech first names, surnames and nicknames, source: http://www.mvcr.cz/clanek/cetnost-jmen-a-prijmeni-722752.aspx, nicknames are from book [Knappova: "Jak se bude vaše dítě jmenovat?"] (http://www.kosmas.cz/knihy/157964/jak-se-bude-vase-dite-jmenovat/)
  * *cs_passwords.txt*	- compiled from password breach Czech users like passwords LinkedIn users with .cz emails
  * *cs_subtitles.txt*	- https://github.com/hermitdave/FrequencyWords.git see also http://opus.lingfil.uu.se/OpenSubtitles2016.php
  * *cs_wikipedia.txt*	- words from Czech Wikipedia (like english_wikipedia.txt)
  * *sk_passwords.txt*	- compiled from password breach Slovak users like passwords LinkedIn users with .sk emails
  * *sk_subtitles.txt*	- https://github.com/hermitdave/FrequencyWords.git see also http://opus.lingfil.uu.se/OpenSubtitles2016.php
  * *sk_wikipedia.txt*	- words from Slovak Wikipedia (like english_wikipedia.txt)
* The CZ and SK keyboard layout is also included, so there are additional spatial sequences, e.g. ZuioP0 is a spatial sequence.
* Configuration files for building individual libraries - how many words from which dictionary will be included in the created library.
  * data/cs.json			- generate dist/zxcvbn_cs.js
  * data/cs_small.json		- generate dist/zxcvbn_cs_small.js
  * data/sk.json			- generate dist/zxcvbn_sk.js
* Our goal is not to exceed 900 KB the size of the library. So we include next modification to build_frequency_lists.py :
  * Skip words with one or two characters. Brutal has better score in most cases. The performance of the library has also improved (see below).
  * Skip words with high rank if one character shorter word + brutal has better score. Example: 'republic' has rank 688, 'republica' has rank 32852. Composition 'republic' + 'a' (brutal) estimate 21814 guesses, so we skip word 'republica'.
* Feedback localization
  * support for custom feedback (inspired by [pull request #124 from dropbox/zxcvbn] (https://github.com/dropbox/zxcvbn/pull/124))
  * Czech and Slovak feedback messages,

## Installation

See also [Installation from original project dropbox/zxcvbn] (https://github.com/dropbox/zxcvbn#installation).

### Manual installation
Download some of available libraries:
* [zxcvbn_cs.js](https://raw.githubusercontent.com/lpavlicek/zxcvbn-czech/master/dist/zxcvbn_cs.js) - with Czech and English dictionaries,
* [zxcvbn_cs_small.js](https://raw.githubusercontent.com/lpavlicek/zxcvbn-czech/master/dist/zxcvbn_cs_small.js) - with Czech dictionaries, half size,
* [zxcvbn_sk.js](https://raw.githubusercontent.com/lpavlicek/zxcvbn-czech/master/dist/zxcvbn_sk.js) - with Slovak and English dictionaries,
* [zxcvbn.js](https://raw.githubusercontent.com/lpavlicek/zxcvbn-czech/master/dist/zxcvbn.js) - with English dictionaries,

Add to your .html:

``` html
<script type="text/javascript" src="path/to/zxcvbn.js"></script>
```

## Usage, API

Library API is compatible with original API, see [Usage from original project dropbox/zxcvbn] (https://github.com/dropbox/zxcvbn#usage). New parameters are passed through the options and are compatible with [pull request #124 in dropbox/zxcvbn] (https://github.com/dropbox/zxcvbn/pull/124).

``` javascript
zxcvbn(password, user_inputs=[])        // original (old) API
zxcvbn(password, options={})			// new API
```

`zxcvbn()` takes one required argument, a password, and returns a result object with several properties, see [Original zxcvbn description](https://github.com/dropbox/zxcvbn#usage)

The optional `options` argument is an object that can contain the following optional properties:
- `user_inputs` is an array of strings that zxcvbn will treat as an extra dictionary. This can be whatever list of strings you like, but is meant for user inputs from other fields of the form, like name and email. That way a password that includes a user's personal information can be heavily penalized. This list is also good for site-specific vocabulary — Acme Brick Co. might want to include ['acme', 'brick', 'acmebrick', etc].
- `feedback_messages` is an object that enables zxcvbn's consumers to customize the messages used for giving feedback to the user. This could be used to skip messages that aren't desired to be returned as feedback to the user, or to modify or internationalize the existing messages.
The list of keys to be used in this parameter could be find in [./src/feedback_l10n.coffee](./blob/master/src/feedback_l10n.coffee#L4).
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
  * `cs` - Czech feedback
  * `sk` - Slovak feedback

Example:
```javascript
var local_dictionary = [ "eduroam", "vsepraha", "wifi" ];

zxcvbn(password, {
	user_inputs: local_dictionary,
	feedback_language: 'cs'
});
```

### Usage Suggestion

You can create a user dictionary, which will include service names, service marks, product names or specific words from a page to change your password. The typical size is 30 to 100 words. And this dictionary use as second parameter when calling zxcvbn function. You can dynamically add words identifying the user - firstname, lastname, username, address, etc.

## Performance

### runtime latency
see [runtime latency] (https://github.com/dropbox/zxcvbn#runtime-latency)

You see the time in ms needed to evaluate the entered password on the [test page](TODO).
Evaluation takes ~4-30ms for ~25 char passwords on modern browsers/CPUs and ~20-100ms in the Firefox on Samsung S4 mini. Evaluation for ~100 char passwords takes ~100-300ms on modern browsers/CPUs and ~500-2000ms on Samsung S4 mini.

When editing I test performance using nodejs. I test 100,000 different passwords from linkedin breach.

library | size | dictionaries | time (shorter is better)
------- | ---- | ------------ | ------------------------
zxcvbn_dropbox.js (original dropbox) | 803KB | 6+1 | 127.9 seconds
zxcvbn.js (en dictionaries) | 814KB | 6+1 | 112 seconds
zxcvbn_cs.js | 841KB | 7+1 | 122,4 seconds
zxcvbn_cs_small.js   | 406KB | 4+1 | 99,7 seconds
zxcvbn_sk.js | 684KB | 7+1 | 121,4 seconds
------- | ---- | ------------ | ------------------------
zxcvbn_en2.js (experimental) | 814KB | 3+1 | 94 seconds

- +1 - a 90-word user_input extra dictionary was used in the tests
- zxcvbn_en2.js - experimental assembly with merged dictionaries (passwords.txt, en_wiki_film.txt, us_names.txt)

Some conclusions from benchmarks:
* The evaluation time has been reduced by 12% after the elimination of 1 and 2 char words (diff between zxcvbn_dropbox.js and zxcvbn.js).
* The evaluation time affects the number of embeded libraries. The siye of the created library has less influence.
* Other implementations of javascript may behave differently.

### script load latency
see [script load latency](https://github.com/dropbox/zxcvbn#script-load-latency)

library | size | gzip -6 | zopfli | brotli 4 | brotli 11
------- | ---- | ------- | ------ | -------- | ---------
zxcvbn_dropbox.js (original dropbox) | 803KB | 390KB | 372KB | 388KB | 350KB
zxcvbn.js (en dictionaries)          | 814KB | 396KB | 378KB | 393KB | 355KB
zxcvbn_cs.js         | 841KB | 389KB | 368KB | 392KB | 354KB
zxcvbn_cs_small.js   | 406KB | 187KB | 176KB | 187KB | 170KB
zxcvbn_sk.js         | 684KB | 328KB | 312KB | 329KB | 298KB

Web servers typically use `gzip -6` or `brotli 4` for dynamic compression. Pre-compression with [zopfli](https://en.wikipedia.org/wiki/Zopfli) or `brotli 11` creates even smaller files. See [Serving Pre-Compressed Files with Apache](https://kevinlocke.name/bits/2016/01/20/serving-pre-compressed-files-with-apache-multiviews/), in Nginx use [gzip_static on;](https://www.nginx.com/resources/admin-guide/compression-and-decompression/) and/or [brotli_static on;](https://certsimple.com/blog/nginx-brotli);

## Development

TODO 

## TODO
* missing dictionary with Slovak names and surnames,
* support for chars with diacritics in passwords,
* next languages - feedback localization, local dictionaries,

## Acknowledgment

Thanks to Dan Wheeler (https://github.com/lowe) for the CoffeeScript implementation (see above).
