# take a string of text
# look up each letter in the table
# render each "pixel" with the requested emoji
# puts a line after each word?

def render(text, emojis)
  emoji_index_cycle = (0...emojis.size).cycle

  char_maps = text.split('')
    .map { |char| downcase_short_char_map(char) }.compact # get the map for each letter
    .map { |cm| cm.join("\n").gsub(/[^ \n]/, emoji_index_cycle.next.to_s).split("\n") } # 'o' -> (0..N)

  asciiart = concat_letters_with_kerning(char_maps).join("\n")
  # puts asciiart

  emojis.each_with_index do |em, i|
    asciiart.gsub!(i.to_s, ":#{emojis[i]}:")
  end

  asciiart.gsub(' ', ':transparent:')
end

def concat_letters_with_kerning(letters)
  # letter_blocks.transpose.map { |line_bits| line_bits.join(':transparent:') }
  lines = letters.first.dup

  letters.drop(1).each do |letter|
    memo = lines.zip(letter).map { |left_line, unpadded_right_line|
      right_line = " #{unpadded_right_line}"
      left = left_line.match(/ *$/)
      right = right_line.match(/^ */)
      left_count = left[0].size
      right_count = right[0].size

      # p [left_line, left_count,
      #    right_line, right_count, left_count + right_count]

      { left: left_line, right: right_line,
        lc: left_count, rc: right_count }
    }

    trim_amount = memo.map { |item|
      item[:lc] + item[:rc]
    }.min - 1 # always leave at least 1 space
    # trim_amount = 0

    # puts '-' * 15
    # puts trim_amount
    # puts '-' * 15

    memo.each do |item|
      # left = left_line.match(/ *$/)
      # right = right_line.match(/^ */)
      # left_count = left[0].size
      # right_count = right[0].size

      left_trim_amt = [[trim_amount, item[:lc]].min, 0].max
      right_trim_amt = [trim_amount - left_trim_amt, 0].max

      item[:left].delete_suffix!(' ' * left_trim_amt)
      item[:left] << item[:right].delete_prefix(' ' * right_trim_amt)
    end
  end

  lines
end

def downcase_short_char_map(char)
  {
    ' ' => [
      '',
      '',
      '',
      '',
      '',
      '',
      '',
    ],

    'a' => [
      'ooo',
      '  o',
      'ooo',
      'o o',
      'ooo',
      '   ',
      '   ',
    ],

    'b' => [
      'o  ',
      'o  ',
      'ooo',
      'o o',
      'ooo',
      '   ',
      '   ',
    ],

    'c' => [
      '   ',
      '   ',
      'ooo',
      'o  ',
      'ooo',
      '   ',
      '   '
    ],

    'd' => [
      '  o',
      '  o',
      'ooo',
      'o o',
      'ooo',
      '   ',
      '   '
    ],

    'e' => [
      'ooo',
      'o o',
      'ooo',
      'o  ',
      'ooo',
      '   ',
      '   '
    ],

    'f' => [
      ' oo',
      'o  ',
      'oo ',
      'o  ',
      'o  ',
      '   ',
      '   '
    ],   

    'g' => [
      '   ',
      '   ',
      'ooo',
      'o o',
      'ooo',
      '  o',
      'ooo'
    ],   

    'h' => [
      'o  ',
      'o  ',
      'ooo',
      'o o',
      'o o',
      '   ',
      '   '
    ],

    'i' => [
      'o',
      ' ',
      'o',
      'o',
      'o',
      ' ',
      ' '
    ],   

    'j' => [
      '  o',
      '   ',
      '  o',
      '  o',
      '  o',
      'o o',
      'ooo'
    ],  

    'k' => [
      'o  ',
      'o  ',
      'o o',
      'oo ',
      'o o',
      '   ',
      '   '
    ],

    'l' => [
      'o',
      'o',
      'o',
      'o',
      'o',
      ' ',
      ' '
    ],

    'm' => [
      '     ',
      '     ',
      'ooooo',
      'o o o',
      'o o o',
      '     ',
      '     '
    ],

    'n' => [
      '   ',
      '   ',
      'ooo',
      'o o',
      'o o',
      '   ',
      '   '
    ],

    'o' => [
      '   ',
      '   ',
      'ooo',
      'o o',
      'ooo',
      '   ',
      '   '
    ],

    'p' => [
      '   ',
      '   ',
      'ooo',
      'o o',
      'ooo',
      'o  ',
      'o  '
    ],  

    'q' => [
      '   ',
      '   ',
      'ooo',
      'o o',
      'ooo',
      '  o',
      '  o'
    ], 

    'r' => [
      '   ',
      '   ',
      'ooo',
      'o  ',
      'o  ',
      '   ',
      '   '
    ],

    's' => [
      'ooo',
      'o  ',
      'ooo',
      '  o',
      'ooo',
      '   ',
      '   '
    ],

    't' => [
      ' o ',
      'ooo',
      ' o ',
      ' o ',
      ' o ',
      '   ',
      '   '
    ], 

    'u' => [
      '   ',
      '   ',
      'o o',
      'o o',
      'ooo',
      '   ',
      '   '
    ],

    'v' => [
      '     ',
      '     ',
      'o   o',
      ' o o ',
      '  o  ',
      '     ',
      '     '
    ],  

    'w' => [
      '     ',
      '     ',
      'o o o',
      'o o o',
      'ooooo',
      '     ',
      '     '
    ],

    'x' => [
      '   ',
      '   ',
      'o o',
      ' o ',
      'o o',
      '   ',
      '   '
    ],

    'y' => [
      '   ',
      '   ',
      'o o',
      'o o',
      ' oo',
      '  o',
      'oo '
    ],

    # tara's y
    # 'y' => [
    #   '   ',
    #   '   ',
    #   'o o',
    #   ' o ',
    #   ' o ',
    #   ' o ',
    #   ' o '
    # ],

    'z' => [
      '   ',
      '   ',
      'ooo',
      ' o ',
      'ooo',
      '   ',
      '   '
    ],

  }.fetch(char.downcase) { nil }
end


def downcase_char_map(char)
  {
    ' ' => [
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
    ],

    'a' => [
      '   ',
      'ooo',
      '  o',
      'ooo',
      'o o',
      'ooo',
      '   ',
      '   '
    ],

    'b' => [
      'o  ',
      'o  ',
      'o  ',
      'ooo',
      'o o',
      'ooo',
      '   ',
      '   '
    ],

    'c' => [
      '   ',
      '   ',
      '   ',
      'ooo',
      'o  ',
      'ooo',
      '   ',
      '   '
    ],

    'd' => [
      '  o',
      '  o',
      '  o',
      'ooo',
      'o o',
      'ooo',
      '   ',
      '   '
    ],

    'e' => [
      '   ',
      'ooo',
      'o o',
      'ooo',
      'o  ',
      'ooo',
      '   ',
      '   '
    ],

    'f' => [
      'ooo',
      'o o',
      'o  ',
      'oo ',
      'o  ',
      'o  ',
      '   ',
      '   '
    ],   

    'g' => [
      '   ',
      '   ',
      '   ',
      'ooo',
      'o o',
      'ooo',
      '  o',
      'ooo'
    ],   

    'h' => [
      'o  ',
      'o  ',
      'o  ',
      'ooo',
      'o o',
      'o o',
      '   ',
      '   '
    ],

    'i' => [
      ' ',
      'o',
      ' ',
      'o',
      'o',
      'o',
      ' ',
      ' '
    ],   

    'j' => [
      '   ',
      '  o',
      '   ',
      '  o',
      '  o',
      '  o',
      'o o',
      'ooo'
    ],  

    'k' => [
      'o  ',
      'o  ',
      'o  ',
      'o o',
      'oo ',
      'o o',
      '   ',
      '   '
    ],

    'l' => [
      'o',
      'o',
      'o',
      'o',
      'o',
      'o',
      ' ',
      ' '
    ],

    'm' => [
      '     ',
      '     ',
      '     ',
      'ooooo',
      'o o o',
      'o o o',
      '     ',
      '     '
    ],

    'n' => [
      '   ',
      '   ',
      '   ',
      'ooo',
      'o o',
      'o o',
      '   ',
      '   '
    ],

    'o' => [
      '   ',
      '   ',
      '   ',
      'ooo',
      'o o',
      'ooo',
      '   ',
      '   '
    ],

    'p' => [
      '   ',
      '   ',
      '   ',
      'ooo',
      'o o',
      'ooo',
      'o  ',
      'o  '
    ],  

    'q' => [
      '   ',
      '   ',
      '   ',
      'ooo',
      'o o',
      'ooo',
      '  o',
      '  o'
    ], 

    'r' => [
      '   ',
      '   ',
      '   ',
      'ooo',
      'o  ',
      'o  ',
      '   ',
      '   '
    ],

    's' => [
      '   ',
      'ooo',
      'o  ',
      'ooo',
      '  o',
      'ooo',
      '   ',
      '   '
    ],

    't' => [
      '   ',
      ' o ',
      'ooo',
      ' o ',
      ' o ',
      ' o ',
      '   ',
      '   '
    ], 

    'u' => [
      '   ',
      '   ',
      '   ',
      'o o',
      'o o',
      'ooo',
      '   ',
      '   '
    ],

    'v' => [
      '     ',
      '     ',
      '     ',
      'o   o',
      ' o o ',
      '  o  ',
      '     ',
      '     '
    ],  

    'w' => [
      '     ',
      '     ',
      '     ',
      'o o o',
      'o o o',
      'ooooo',
      '     ',
      '     '
    ],

    'x' => [
      '   ',
      '   ',
      '   ',
      'o o',
      ' o ',
      'o o',
      '   ',
      '   '
    ],

    'y' => [
      '   ',
      '   ',
      '   ',
      'o o',
      'o o',
      ' oo',
      '  o',
      'oo '
    ],

    # tara's y
    # 'y' => [
    #   '   ',
    #   '   ',
    #   '   ',
    #   'o o',
    #   ' o ',
    #   ' o ',
    #   ' o ',
    #   ' o '
    # ],


    'z' => [
      '   ',
      '   ',
      '   ',
      'ooo',
      ' o ',
      'ooo',
      '   ',
      '   '
    ],

  }.fetch(char.downcase) { nil }
end

def char_map(char)
  {
    ' ' => [
      '',
      '',
      '',
      '',
      '',
    ],

    'A' => [
      '  o  ',
      ' o o ',
      'ooooo',
      'o   o',
      'o   o'
    ],

    'B' => [
      'ooo ',
      'o  o',
      'ooo ',
      'o  o',
      'ooo '
    ],

    'C' => [
      ' ooo ',
      'o    ',
      'o    ',
      'o    ',
      ' ooo '
    ],

    'D' => [
      'ooo ',
      'o  o',
      'o  o',
      'o  o',
      'ooo '
    ],

    'E' => [
      'oooo',
      'o   ',
      'ooo ',
      'o   ',
      'oooo'
    ],   

    'F' => [
      'oooo',
      'o   ',
      'ooo ',
      'o   ',
      'o   '
    ],   

    'G' => [
      ' ooo ',
      'o    ',
      'o ooo',
      'o   o',
      ' ooo '
    ],   

    'H' => [
      'o  o',
      'o  o',
      'oooo',
      'o  o',
      'o  o'
    ],   

    'I' => [
      'ooo',
      ' o ',
      ' o ',
      ' o ',
      'ooo'
    ],   

    'J' => [
      '   o',
      '   o',
      '   o',
      'o  o',
      ' oo '
    ],   

    'K' => [
      'o  o',
      'o o ',
      'oo  ',
      'o o ',
      'o  o'
    ],

    'L' => [
      'o   ',
      'o   ',
      'o   ',
      'o   ',
      'oooo'
    ],

    'M' => [
      'o   o',
      'oo oo',
      'o o o',
      'o   o',
      'o   o'
    ],

    'N' => [
      'o   o',
      'oo  o',
      'o o o',
      'o  oo',
      'o   o'
    ],

    'O' => [
      ' ooo ',
      'o   o',
      'o   o',
      'o   o',
      ' ooo '
    ],

    'P' => [
      'ooo ',
      'o  o',
      'ooo ',
      'o   ',
      'o   '
    ],   

    'Q' => [
      ' ooo ',
      'o   o',
      'o   o',
      ' ooo ',
      '    o'
    ],

    'R' => [
      'ooo ',
      'o o ',
      'ooo ',
      'o  o',
      'o  o'
    ], 

    'S' => [
      ' oo',
      'o  ',
      ' o ',
      '  o',
      'oo '
    ],   

    'T' => [
      'ooooo',
      '  o  ',
      '  o  ',
      '  o  ',
      '  o  '
    ],  

    'U' => [
      'o   o',
      'o   o',
      'o   o',
      'o   o',
      ' ooo '
    ],   

    'V' => [
      'o   o',
      'o   o',
      'o   o',
      ' o o ',
      '  o  '
    ],   

    'W' => [
      'o   o',
      'o   o',
      'o o o',
      'oo oo',
      'o   o'
    ],

    'X' => [
      'o   o',
      ' o o ',
      '  o  ',
      ' o o ',
      'o   o'
    ],

    'Y' => [
      'o   o',
      ' o o ',
      '  o  ',
      '  o  ',
      '  o  '
    ],

    'Z' => [
      'ooooo',
      '   o ',
      '  o  ',
      ' o   ',
      'ooooo'
    ],

  }.fetch(char.upcase) { nil }
end

ems = ARGV.drop(1)
ems = %w(party) if ems.empty?

puts render(ARGV[0], ems)
