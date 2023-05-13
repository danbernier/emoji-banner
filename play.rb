# take a string of text
# look up each letter in the table
# render each "pixel" with the requested emoji
# puts a line after each word?
#
# TODO: re-add kerning. look at https://glyphsapp.com/learn/kerning.
# It might not be quite possible? seems to be specified on the font, between pairs of letters. So...

def render(text, emojis)
  emoji_index_cycle = (0...emojis.size).cycle

  char_maps = text.split('')
    .map { |char|
      # Get the map for each letter:
      dans_hand_done_char_map(char)
      # downcase_char_map(char)
      # char_map(char)
    }.compact # ...not all fonts have all characters.
    .map { |cm|
      # For each line of the character map, 
      # Turn whatever's in the map that's *not* a space (or newline) into
      # the emoji-index.
      emoji_index = emoji_index_cycle.next.to_s 
      cm.map { |cml|
        cml.gsub(/[^ |\n]/, emoji_index)
      }
    }

  asciiart = concat_letters(char_maps).join("\n")
  # puts asciiart # TODO: write specs against this

  emojis.each_with_index do |em, i|
    asciiart.gsub!(i.to_s, ":#{emojis[i]}:")
  end

  asciiart.gsub(' ', ':transparent:')
    .gsub('|', ':transparent:') # This is a thought experiment: can this be a kerning hint?
end

# TODO: separate the concatting from the kerning
def concat_letters_with_kerning(letters) # take 1
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

    pp memo

    trim_amount = memo.map { |item|
      item[:lc] + item[:rc]
    }.min - 2 # always leave at least 1 space
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

      item[:left].slice!(item[:left].size - left_trim_amt) if item[:left].end_with? ' ' * left_trim_amt
      right_bit = item[:right]
      right_bit.slice!(0...right_trim_amt) if right_bit.start_with? ' ' * right_trim_amt
      item[:left] << right_bit
    end
  end

  lines
end


def concat_letters(letters)
  # Each of the letters is the array of lines, the raster, from the "font".
  # We make a lvar `lines` to start concatting them together in.
  letters.transpose.map { |line_bits| line_bits.join(' ') }
end

def dans_hand_done_char_map(char)
  {
    ' ' => [
      '|',
      '|',
      '|',
      '|',
      '|',
      '|',
      '|',
    ],

    '!' => [
      'o',
      'o',
      'o',
      'o',
      ' ',
      'o',
      ' ',
    ],

     '.' => [
       '  ',
       '  ',
       '  ',
       '  ',
       'oo',
       'oo',
       '  ',
     ],
 
     ',' => [
       '  ',
       '  ',
       '  ',
       '  ',
       'oo',
       ' o',
       'o ',
     ],
 
     ';' => [
       '  ',
       'oo',
       'oo',
       '  ',
       'oo',
       ' o',
       'o ',
     ],
 
     ':' => [
       '  ',
       'oo',
       'oo',
       '  ',
       'oo',
       'oo',
       '  ',
     ],
 
     '-' => [
       '   ',
       '   ',
       'ooo',
       '   ',
       '   ',
       '   ',
       '   ',
     ],
 
    'a' => [
      '   ',
      'oo ',
      '  o',
      'ooo',
      'o o',
      'ooo',
      '   ',
    ],

    'b' => [
      'o  ',
      'o  ',
      'oo ',
      'o o',
      'o o',
      'ooo',
      '   ',
    ],

    'c' => [
      '   ',
      ' oo',
      'o  ',
      'o  ',
      'o  ',
      ' oo',
      '   ',
    ],

    'd' => [
      '  o',
      '  o',
      ' oo',
      'o o',
      'o o',
      'ooo',
      '   '
    ],

    'e' => [
      '   ',
      ' oo',
      'o o',
      'ooo',
      'o  ',
      ' oo',
      '   '
    ],

    'f' => [
      ' o ',
      'o o',
      'o  ',
      'oo ',
      'o  ',
      'o  ',
      '   '
    ],

    'g' => [
      '   ',
      ' oo',
      'o o',
      'o o',
      'ooo',
      '  o',
      'oo '
    ],

    'h' => [
      'o  ',
      'o  ',
      'oo ',
      'o o',
      'o o',
      'o o',
      '   '
    ],

    'i' => [
      'o',
      ' ',
      'o',
      'o',
      'o',
      'o',
      ' '
    ],

    'j' => [
      '  o',
      '   ',
      '  o',
      '  o',
      '  o',
      'o o',
      ' o '
    ],

    'k' => [
      'o   ',
      'o   ',
      'o o ',
      'oo  ',
      'o o ',
      'o  o',
      '    '
    ],

    'l' => [
      'o',
      'o',
      'o',
      'o',
      'o',
      'o',
      ' '
    ],

    'm' => [
      '     ',
      'oo o ',
      'o o o',
      'o o o',
      'o o o',
      'o o o',
      '     '
    ],

    'n' => [
      '   ',
      'oo ',
      'o o',
      'o o',
      'o o',
      'o o',
      '   '
    ],

    'o' => [
      '   ',
      ' o ',
      'o o',
      'o o',
      'o o',
      ' o ',
      '   '
    ],

    'p' => [
      '   ',
      'oo ',
      'o o',
      'o o',
      'ooo',
      'o  ',
      'o  '
    ],

    'q' => [
      '   ',
      ' oo',
      'o o',
      'o o',
      'ooo',
      '  o',
      '  o'
    ],

    'r' => [
      '   ',
      'oo ',
      'o o',
      'o  ',
      'o  ',
      'o  ',
      '   '
    ],

    's' => [
      '   ',
      ' oo',
      'o  ',
      'ooo',
      '  o',
      'oo ',
      '   '
    ],

    't' => [
      ' o ',
      ' o ',
      'ooo',
      ' o ',
      ' o ',
      ' oo',
      '   '
    ],

    'u' => [
      '    ',
      'o  o',
      'o  o',
      'o  o',
      'o  o',
      ' ooo',
      '    '
    ],

    'v' => [
      '     ',
      'o   o',
      'o   o',
      ' o o ',
      ' o o ',
      '  o  ',
      '     '
    ],

    'w' => [
      '     ',
      'o   o',
      'o o o',
      'o o o',
      ' o o ',
      ' o o ',
      '     '
    ],

    'x' => [
      '   ',
      'o o',
      'o o',
      ' o ',
      'o o',
      'o o',
      '   '
    ],

    'y' => [
      '    ',
      'o  o',
      'o  o',
      ' o o',
      '  o ',
      ' o  ',
      'o   '
    ],

    'z' => [
      '     ',
      'ooooo',
      '   o ',
      '  o  ',
      ' o   ',
      'ooooo',
      '     '
    ],

    'A' => [
      ' oo ',
      'o  o',
      'o  o',
      'oooo',
      'o  o',
      'o  o',
      '    '
    ],

    'B' => [
      'oo ',
      'o o',
      'o o',
      'oo ',
      'o o',
      'oo ',
      '   '
    ],

    'C' => [
      ' oo',
      'o  ',
      'o  ',
      'o  ',
      'o  ',
      ' oo',
      '   ',
    ],

    'D' => [
      'oo ',
      'o o',
      'o o',
      'o o',
      'o o',
      'oo ',
      '   ',
    ],

    'E' => [
      'ooo',
      'o  ',
      'o  ',
      'ooo',
      'o  ',
      'ooo',
      '   ',
    ],

    'F' => [
      'ooo',
      'o  ',
      'o  ',
      'ooo',
      'o  ',
      'o  ',
      '   ',
    ],

    'G' => [
      ' oo ',
      'o  o',
      'o   ',
      'o oo',
      'o  o',
      ' oo ',
      '    ',
    ],

    'H' => [
      'o  o',
      'o  o',
      'o  o',
      'oooo',
      'o  o',
      'o  o',
      '    ',
    ],

    'I' => [
      'ooo',
      ' o ',
      ' o ',
      ' o ',
      ' o ',
      'ooo',
      '   ',
    ],

    'J' => [
      '  o',
      '  o',
      '  o',
      '  o',
      'o o',
      ' o ',
      '   ',
    ],

    'K' => [
      'o  o',
      'o o ',
      'oo  ',
      'o o ',
      'o  o',
      'o  o',
      '    ',
    ],

    'L' => [
      'o  ',
      'o  ',
      'o  ',
      'o  ',
      'o  ',
      'ooo',
      '   ',
    ],

    'M' => [
      'o   o',
      'oo oo',
      'o o o',
      'o o o',
      'o   o',
      'o   o',
      '     ',
    ],

    'N' => [
      'o   o',
      'oo  o',
      'o o o',
      'o  oo',
      'o   o',
      'o   o',
      '     ',
    ],

    'O' => [
      ' oo ',
      'o  o',
      'o  o',
      'o  o',
      'o  o',
      ' oo ',
      '    ',
    ],

    'P' => [
      'oo ',
      'o o',
      'o o',
      'oo ',
      'o  ',
      'o  ',
      '   '
    ],

    'Q' => [
      ' ooo ',
      'o   o',
      'o   o',
      'o o o',
      'o  o ',
      ' oo o',
      '     ',
    ],

    'R' => [
      'oo ',
      'o o',
      'o o',
      'oo ',
      'o o',
      'o o',
      '   '
    ],

    # 'S' => [
    #   ' ooo',
    #   'o   ',
    #   'o   ',
    #   ' oo ',
    #   '   o',
    #   'ooo ',
    #   '    '
    # ],

    'S' => [
      ' ooo ',
      'o   o',
      'oo   ',
      '  oo ',
      'o   o',
      ' ooo ',
      '     '
    ],

    'T' => [
      'ooo',
      ' o ',
      ' o ',
      ' o ',
      ' o ',
      ' o ',
      '   '
    ],

    'U' => [
      'o  o',
      'o  o',
      'o  o',
      'o  o',
      'o  o',
      ' oo ',
      '    '
    ],

    'V' => [
      'o   o',
      'o   o',
      'o   o',
      ' o o ',
      ' o o ',
      '  o  ',
      '     '
    ],

    'W' => [
      'o   o',
      'o   o',
      'o o o',
      'o o o',
      ' o o ',
      ' o o ',
      '     '
    ],

    'X' => [
      'o   o',
      ' o o ',
      '  o  ',
      ' o o ',
      'o   o',
      'o   o',
      '     '
    ],

    'Y' => [
      'o   o',
      'o   o',
      ' o o ',
      '  o  ',
      '  o  ',
      '  o  ',
      '     '
    ],

    'Z' => [
      'ooooo',
      '   o ',
      '  o  ',
      ' o   ',
      'o    ',
      'ooooo',
      '     '
    ],

    '0' => [
      ' oo ',
      'o  o',
      'o oo',
      'oo o',
      'o  o',
      ' oo ',
      '    ',
    ],

    '1' => [
      ' o',
      'oo',
      ' o',
      ' o',
      ' o',
      ' o',
      '  ',
    ],

    '2' => [
      ' o ',
      'o o',
      '  o',
      ' o ',
      'o  ',
      'ooo',
      '   ',
    ],

    # '3' => [
    #   'ooo',
    #   '  o',
    #   ' o ',
    #   '  o',
    #   '  o',
    #   'oo ',
    #   '   ',
    # ],

    '3' => [
      'oooo',
      '  o ',
      ' oo ',
      '   o',
      'o  o',
      ' oo ',
      '    ',
    ],

    '4' => [
      '  o',
      'o o',
      'o o',
      'ooo',
      '  o',
      '  o',
      '   ',
    ],

    '5' => [
      'ooo',
      'o  ',
      'oo ',
      '  o',
      'o o',
      ' o ',
      '   ',
    ],

    # '6' => [
    #   '  o',
    #   ' o ',
    #   'oo ',
    #   'o o',
    #   'o o',
    #   ' o ',
    #   '   ',
    # ],

    '6' => [
      '  o ',
      ' o  ',
      'ooo ',
      'o  o',
      'o  o',
      ' oo ',
      '    ',
    ],

    '7' => [
      'ooo',
      '  o',
      '  o',
      ' o ',
      ' o ',
      ' o ',
      '   ',
    ],

    '8' => [
      ' oo ',
      'o  o',
      ' oo ',
      'o  o',
      'o  o',
      ' oo ',
      '    ',
    ],

    '9' => [
      ' oo ',
      'o  o',
      'o  o',
      ' ooo',
      '  o ',
      ' o  ',
      '    ',
    ],

  }.fetch(char) { nil }
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

    '!' => [
      ' o ',
      ' o ',
      ' o ',
      ' o ',
      '   ',
      ' o ',
      '   ',
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
      'ooo',
      'o o',
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
      'o o',
      'o o',
      ' o ',
      'o o',
      'o o',
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

    "'" => [
      ' ',
      'o',
      'o',
      ' ',
      ' ',
      ' ',
      ' ',
      ' ',
    ],

    '!' => [
      ' o ',
      ' o ',
      ' o ',
      ' o ',
      '   ',
      ' o ',
      '   ',
    ],

    'a' => [
      '   ',
      'oo ',
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
      ' oo',
      'o o',
      'ooo',
      'o  ',
      ' oo',
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
      ' o ',
      'o o',
      'o o',
      ' oo',
      '  o',
      'oo '
    ],   

    'h' => [
      'o  ',
      'o  ',
      'oo ',
      'o o',
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
      'o o',
      'oo ',
      'o o',
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
      'oo o ',
      'o o o',
      'o o o',
      'o o o',
      '     ',
      '     '
    ],

    'n' => [
      '   ',
      '   ',
      'oo ',
      'o o',
      'o o',
      'o o',
      '   ',
      '   '
    ],

    'o' => [
      '   ',
      ' o ',
      'o o',
      'o o',
      'o o',
      ' o ',
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
      ' oo',
      'o  ',
      'ooo',
      '  o',
      'oo ',
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
      'o o',
      'o o',
      'o o',
      'ooo',
      '   ',
      '   '
    ],

    'v' => [
      '   ',
      '   ',
      'o o',
      'o o',
      'o o',
      ' o ',
      '   ',
      '   '
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
      'o o',
      'o o',
      ' o ',
      'o o',
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

# render(ARGV[0], ems)
puts render(ARGV[0], ems)
