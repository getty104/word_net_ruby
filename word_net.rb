require 'sqlite3'
require "json"
include SQLite3

class WordNet
  Word = Struct.new('Word',:wordid, :lang, :lemma, :pron, :pos)
  Sense = Struct.new('Sense', :synset, :wordid, :lang, :rank, :lexid, :freq, :src)
  Synset = Struct.new( "Synset", :synset, :pos, :name, :src)

  def initialize
    @db = Database.new("./wnjpn.db")
  end

  public

  def get_synonym(word, lang="jpn")
    synonym = Hash.new
    words = get_words(word)
    words.each do |w|
      senses = get_senses(w)
      synonym.merge! get_words_from_senses(senses,lang)
    end
    return synonym.uniq
  end

  def get_hyponym(word, lang="jpn")
    words = get_words(word)
    hyponyms = []
    words.each do |w|
      senses = get_senses(w)
      relates = (get_link_words_from_senses(senses, 'hypo', lang)-[word])
      hyponyms += relates
    end
    return hyponyms.uniq
  end

  def get_hypernym(word, lang="jpn")
    words = get_words(word)
    hypernyms = []
    words.each do |w|
      senses = get_senses(w)
      relates = (get_link_words_from_senses(senses, 'hype', lang)-[word])
      hypernyms += relates
    end
    return hypernyms.uniq
  end

  def close
    @db.close
  end

  private

  def get_words(lemma)
    @db.execute(<<-SQL).map{ |c| Word.new(c[0],c[1],c[2],c[3]) }
    select *
    from word
    where lemma='#{lemma}'
    SQL
  end

  def get_senses(word)
    @db.execute(<<-SQL).map{ |c| Sense.new(c[0],c[1],c[2],c[3],c[4],c[5],c[6]) }
    select *
    from sense
    where wordid='#{word.wordid}'
    SQL
  end

  def get_synset(synset)
    @db.execute(<<-SQL).map{ |c| Synset.new(c[0],c[1],c[2],c[3]) }
    select *
    from synset
    where synset='#{synset}'
    SQL
  end

  def get_words_from_synset(synset, lang)
    @db.execute(<<-SQL).map{ |c| Word.new(c[0],c[1],c[2],c[3]) }
    select word.*
    from sense, word
    where synset= '#{synset}'
    and word.lang = '#{lang}'
    and sense.wordid = word.wordid
    SQL
  end

  def get_link_words_from_senses(senses, link, lang)
    links = []
    senses.each do |sense|
      links += @db.execute(<<-SQL).map{|c| c[0]}
      select lemma
      from synlink,sense, word
      where link ='#{link}'
      and synset1 = '#{sense.synset}'
      and synset2 = synset
      and sense.wordid = word.wordid
      and word.lang = '#{lang}'
      SQL
    end
    return links
  end

  def get_words_from_senses(senses, lang)
    synonym = Hash.new
    senses.each do |s|
      lemmas = []
      syns = get_words_from_synset(s.synset, lang)
      syns.each do |sy|
        lemmas << sy.lemma
        get_synset(s.synset).each do |synset|
          synonym[synset.name] = lemmas
        end
      end
    end
    return synonym
  end
end
