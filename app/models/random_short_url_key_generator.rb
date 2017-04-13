class RandomShortUrlKeyGenerator
  def initialize(key_length: Settings.short_url_key.length,
                 alphabet: Settings.short_url_key.alphabet)
    @key_length = key_length
    @alphabet = alphabet
    @alphabet_size = alphabet.size
  end

  def generate(*args)
    Array.new(@key_length) { @alphabet[Random.rand(@alphabet_size)] }.
      join
  end

end
