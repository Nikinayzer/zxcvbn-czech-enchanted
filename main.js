let body = $('body');
let input = $('input');

/*
console.log("A little bit of theory: ");
console.log("Pokud je náhodný výběr a jednotlivé znaky v hesle jsou rozmístěny rovnoměrně, tak entropie (e)závisí na počtu prvků v množině (N) a na počtu prvků, které je mají vybrat (L):");
console.log("𝑺 = 𝒍𝒐𝒈𝟐 𝑵^𝑳 = 𝑳 𝒍𝒐𝒈𝟐 𝑵");
console.log("Z toho se již snadno odvodí vzorec na požadovaný počet znaků v hesle:");
console.log("𝑳 =𝑺/(𝒍𝒐𝒈𝟐 𝑵)");
console.log("--Narozeninovy paradox--");
console.log("Skutečnost, že nejméně dva z „n“ lidí mají stejné narozeniny je komplementární jevu, že všechnydata narozenin jsou různé. A její pravděpodobnost p je");
console.log("𝒑 = 𝟏 − P");
console.log("Pokud ze sady o velikosti 𝑯 vybereme 𝒏 prvků, tak pravděpodobnost kolize lze spočítat dle následujícího přibližného vzorce:");
console.log("𝒑 ≈ 𝟏 − 𝒆^(−𝒏𝟐⁄𝟐𝑯)");
*/
input.on('input', function (e) {
    console.log(zxcvbn(input.val()));

    $(".results").remove();

    let resultsDiv= $('<div class="results"></div>');
    let resultTable = $('<table id="overall"></table>');
    let resultTableBody = $('<tbody></tbody>');




    let data = zxcvbn(input.val());

    //Overall scores table
    let trPassword = $(`
    <tr>
    <td>Password: </td>
    <td colspan="1" id="password">${data.password}</td>
    </tr>
    `);

    let trGuessesLog10 = $(`
    <tr>
    <td>Guesses Log10: </td>
    <td colspan="1">${(data.guesses_log10).toFixed(5)}</td>
    </tr>
    `);

    let trGuessesLog2 = $(`
    <tr>
    <td>Guesses Log2: </td>
    <td colspan="1">${(data.guesses_log2).toFixed(5)}</td>
    </tr>
    `);

    let trScore = $(`
    <tr>
    <td>Score: </td>
    <td colspan="1">${data.score}/4</td>
    </tr>
    `);

    let trFunctionRuntime = $(`
    <tr>
    <td>Runtime(ms): </td>
    <td colspan="1">${data.calc_time}</td>
    </tr>
    `);

    resultTableBody.append(trPassword);
    resultTableBody.append(trGuessesLog10);
    resultTableBody.append(trGuessesLog2);
    resultTableBody.append(trScore);
    resultTableBody.append(trFunctionRuntime);

    //Guesses Times Table
    let guessesTable = $('<table id="guesses"></table>');
    let guessesTableBody = $('<tbody></tbody>');

    let tr100 = $(`
    <tr>
    <td>100 / hour: </td>
    <td>${data.crack_times_display.online_throttling_100_per_hour}</td>
    <td class="attack-type">Throttled online attack</td>
    </tr>
    `);
    let tr10 = $(`
    <tr>
    <td>10 / second: </td>
    <td>${data.crack_times_display.online_no_throttling_10_per_second}</td>
    <td class="attack-type">Unthrottled online attack</td>
    </tr>
    `);
    let tr10k = $(`
    <tr>
    <td>10k / second: </td>
    <td>${data.crack_times_display.offline_slow_hashing_1e4_per_second}</td>
    <td class="attack-type">Offline attack, slow hash, many cores</td>
    </tr>
    `);
    let tr10B = $(`
    <tr>
    <td>10B / second: </td>
    <td>${data.crack_times_display.offline_fast_hashing_1e10_per_second}</td>
    <td class="attack-type">Offline attack, fast hash, many cores</td>
    </tr>
    `);
    guessesTableBody.append(tr100);
    guessesTableBody.append(tr10);
    guessesTableBody.append(tr10k);
    guessesTableBody.append(tr10B);

    //warnings
    let warningsAndSuggestsionsDiv = $('<div class="warnandsuggest"></div>')

    //let warningsDiv = $('<div class="warnings"></div>');
    if(!data.feedback.warning == "" && !input.val()==""){
        let warningsDiv = $('<div class="warnings"></div>');
        let warning = $(`<div class="warning"><i class="fa-solid fa-skull-crossbones"></i><p>${data.feedback.warning}</p></div>`)
        warningsDiv.append(warning);
        warningsAndSuggestsionsDiv.append(warningsDiv);
    }

    //suggestions
    if(!data.feedback.suggestions.length==0 && !input.val()==""){
    let suggestionsDiv = $('<div class="suggestions"></div>');
    data.feedback.suggestions.forEach(element => {
        let suggestion = $(`<div class="suggestion"><i class="fa-solid fa-exclamation"></i><p>${element}</p></div>`)
        suggestionsDiv.append(suggestion);
        warningsAndSuggestsionsDiv.append(suggestionsDiv);

    });}

    //match sequence
    let matchSequenceDiv = $('<div class ="matchSequenceDiv"></div>');
    let matchSequenceButton = $('<div class="button-container"><div><div class="icon"><div class="arrow"></div></div></div></div>');

    data.sequence.forEach(function(element, i) {

        
        let sequenceContainer = $('<div class="sequence-container"></div>');
        let sequence = $(`<table class="sequence" id="sequence-${i}"></table>`);
        let sequenceBody = $('<tbody></tbody>');

        let thToken = $(`<thead><tr><th colspan="2">${element.token}</th></tr></thead>`);

        let trPattern = $(`<tr><td>Pattern: </td><td>${element.pattern}</td></tr>`);
        let trSequenceGuessesLog10 = $(`<tr><td>Guesses log10: </td><td>${(element.guesses_log10).toFixed(5)}</td></tr>`);
        
        sequenceContainer.append(sequence);
        sequence.append(thToken);
        sequenceBody.append(trPattern);
        sequenceBody.append(trSequenceGuessesLog10);
       

        switch(element.pattern){
            case "dictionary":
            //log10 dictionary_name rank reversed l33t un-l33t base-guesses upercase l33t-var
            let trDictionaryName = $(`<tr><td>Dictionary name: </td><td>${element.dictionary_name}</td></tr>`);
            let trRank = $(`<tr><td>Rank: </td><td>${element.rank}</td></tr>`);
            let trReversed = $(`<tr><td>Reversed? : </td><td>${element.reversed}</td></tr>`);
                let trL33tSubs = $(`<tr><td>L33t subs: </td><td>${element.sub}</td></tr>`);
            let trUnl33t = $(`<tr><td>Un-l33ted: </td><td>${element.matched_word}</td></tr>`);
            let trBaseGuesses = $(`<tr><td>Base Guesses: </td><td>${element.base_guesses}</td></tr>`);
            let trUpperCaseVars = $(`<tr><td>Uppercase variations: </td><td>${element.uppercase_variations}</td></tr>`);
            let trL33tVars = $(`<tr><td>L33t variations: </td><td>${element.l33t_variations}</td></tr>`);

            sequenceBody.append(trDictionaryName);
            sequenceBody.append(trRank);
            sequenceBody.append(trReversed);
            sequenceBody.append(trL33tSubs);
            sequenceBody.append(trUnl33t);
            sequenceBody.append(trBaseGuesses);
            sequenceBody.append(trUpperCaseVars);
            sequenceBody.append(trL33tVars);
            break;
            case "repeat":
            // log10 base_token base_guesses num_repeats
            let trBaseToken = $(`<tr><td>Base token: </td><td>${element.base_token}</td></tr>`);
            let trRepeatBaseGuesses = $(`<tr><td>Base guesses: </td><td>${element.base_guesses}</td></tr>`);
            let trNumRepeats = $(`<tr><td>Repeats count: </td><td>${element.repeat_count}</td></tr>`);
           
            sequenceBody.append(trBaseToken);
            sequenceBody.append(trRepeatBaseGuesses);
            sequenceBody.append(trNumRepeats);
            break;
            case "bruteforce":
            break;
            case "date":
            //log10 day month year separator
            let trDay = $(`<tr><td>Day: </td><td>${element.day}</td></tr>`);
            let trMonth = $(`<tr><td>Month: </td><td>${element.month}</td></tr>`);
            let trYear = $(`<tr><td>Year: </td><td>${element.year}</td></tr>`);
            let trSeparator = $(`<tr><td>Separator: </td><td>${element.separator}</td></tr>`);

            sequenceBody.append(trDay);
            sequenceBody.append(trMonth);
            sequenceBody.append(trYear);
            sequenceBody.append(trSeparator);
            break;
            case "spatial":
            //log10 graph turns shifted count
            let trGraph = $(`<tr><td>Graph: </td><td>${element.graph}</td></tr>`);
            let trTurns = $(`<tr><td>Turns: </td><td>${element.turns}</td></tr>`);
            let trShiftedCount = $(`<tr><td>Shifted count: </td><td>${element.shifted_count}</td></tr>`);
            
            sequenceBody.append(trGraph);
            sequenceBody.append(trTurns);
            sequenceBody.append(trShiftedCount);
            break;
            case "sequence":
            //log10 seq-name seq-size asc
            let trSequenceName = $(`<tr><td>Sequence name: </td><td>${element.sequence_name}</td></tr>`);
            let trSequenceSize = $(`<tr><td>Sequence size: </td><td>${element.sequence_space}</td></tr>`);
            let trSequenceAscending = $(`<tr><td>Ascending?: </td><td>${element.ascending}</td></tr>`);
            
            sequenceBody.append(trSequenceName);
            sequenceBody.append(trSequenceSize);
            sequenceBody.append(trSequenceAscending);
            break;
            case "regex":
            //log10 regex_name
            let trRegexName = $(`<tr><td>Regex name: </td><td>${element.regex_name}</td></tr>`);
            
            sequenceBody.append(trRegexName);
            break;
        }






        sequence.append(sequenceBody);
        matchSequenceDiv.append(sequenceContainer);
        
    })


    resultTable.append(resultTableBody);
    guessesTable.append(guessesTableBody);

    resultsDiv.append(resultTable);
    resultsDiv.append(guessesTable);
    //warningsAndSuggestsionsDiv.append(warningsDiv);
    //warningsAndSuggestsionsDiv.append(suggestionsDiv);
    resultsDiv.append(warningsAndSuggestsionsDiv);
    resultsDiv.append(matchSequenceButton);
    resultsDiv.append(matchSequenceDiv);
    body.append(resultsDiv);

    let i=1; //for clicks on button... Needs refactoring asap
    $(document).on("click", ".icon", function (event){
    i=i+1;
    let allSequences = document.getElementsByClassName('sequence');
    if(i>=allSequences.length){
        i=0;
    }
    let neededSequence = document.getElementById(`sequence-${i}`)
    neededSequence.scrollIntoView({ block: 'center',  behavior: 'smooth' });

});
});


