SELECT fts3_tokenizer('blah2') == fts3_tokenizer('simple'),
typeof(fts3_tokenizer($blah2name)),
typeof(fts3_tokenizer('blah2')),
typeof(fts3_tokenizer($simplename)),
typeof(fts3_tokenizer('simple'));