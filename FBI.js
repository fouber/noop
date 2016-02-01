// FBI WARNING

var str = [
'',
'                      \u001b[41m FBI WARNING \u001b[49m',
'',
'Federal Law provides severe civil and criminal penalties for ',
'the unauthorized reproduction, distribution, or exhibition of ',
'copyrighted motion pictures (Title 17, United States Code, ',
'Sections 501 and 508). The Federal Bureau of Investigation ',
'investigates allegations of criminal copyright infringement',
'        (Title 17, United States Code, Section 506).',
''
];

str = '\u001b[37m' + str.join('\n') + '\u001b[39m';

console.log(str);
