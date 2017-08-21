# word_net_ruby
This is a class of getting hyponym, hypernym, and synonym from word_net_jpn db.

example
```
w = WordNet.new
p w.get_hypernym("犬")
p w.get_hyponym("犬")
p w.get_synonym("犬")
w.close
```
result
```
["密偵", "スパイ", "イヌ科動物", "家畜"]
["カウンタースパイ", "ダブルエージェント", "工作員", "諜報員", "犬児", "犬ころ", "仔犬", "子犬", "犬子", "狆ころ", "小犬", "わんこ", "わんわん", "ワンワン", "わんちゃん", "駄犬", "雑犬", "雑種犬", "小型犬", "猟犬", "ワーキングドッグ", "パグ", "グリフォンブリュッセロワ", "ブリュッセルグリフォン", "グリフォン", "ウェルシュ・コーギー", "プードル"]
[["spy", ["廻者", "間諜", "工作員", "犬", "間者", "探", "諜報員", "諜者", "密偵", "スパイ", "秘密捜査員", "いぬ", "まわし者", "隠密", "探り", "廻し者", "回し者", "回者"]], ["canis_familiaris", ["飼い犬", "ドッグ", "犬", "飼犬", "洋犬", "イヌ"]]]
```
