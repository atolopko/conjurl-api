class KeyGenerator
  def initialize(key_length: Settings.short_url_key.length,
                 alphabet: Settings.short_url_key.alphabet,
                 sequence:)
    @key_length = key_length
    @alphabet = alphabet
    @radix = alphabet.size
    @key_namespace_size = @radix ** @key_length
    @sequence = sequence
  end

  def generate
    n = @sequence.next
    raise "key namespace exhausted (size=#{@key_namespace_size})" if n.nil?
    # convert the base-10 value to a base-<@radix> value, using the specified alphabet
    n.b(@radix).to_a(@alphabet).
      join.
      # handle key values that can be represented with fewer digits
      # than the full key length
      rjust(@key_length, @alphabet[0])
  end
end
