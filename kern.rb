j = [
  '   o',
  '   o',
  '   o',
  'o  o',
  ' oo '
]

l = [
  'o   ',
  'o   ',
  'o   ',
  'o   ',
  'oooo'
]

o = [
  ' ooo ',
  'o   o',
  'o   o',
  'o   o',
  ' ooo '
]

x = [
  'o   o',
  ' o o ',
  '  o  ',
  ' o o ',
  'o   o'
]

y = [
  'o   o',
  ' o o ',
  '  o  ',
  '  o  ',
  '  o  '
]


def concat_letters(letters)
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

puts concat_letters([l, y, y, o, x, j])
