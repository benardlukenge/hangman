# lib/hangman.rb
# Like a 5-year-old:
# - Secret word is hidden with underscores
# - You guess letters
# - You can save game to a file and load it later

require "yaml"

class Hangman
  SAVE_FILE = "save.yml"

  def initialize(word: nil)
    @word = (word || %w[ruby rails odin project backend].sample)
    @guessed = []
    @wrong = 0
    @max_wrong = 6
  end

  def play
    loop do
      show
      return puts("You win!") if won?
      return puts("You lose. Word was #{@word}") if lost?

      print "(g)uess, (s)ave, (l)oad: "
      choice = gets&.strip&.downcase

      case choice
      when "s" then save
      when "l" then load_game
      else guess_letter
      end
    end
  end

  private

  def show
    display = @word.chars.map { |c| @guessed.include?(c) ? c : "_" }.join(" ")
    puts "\nWord: #{display}"
    puts "Guessed: #{@guessed.join(', ')}"
    puts "Wrong: #{@wrong}/#{@max_wrong}"
  end

  def guess_letter
    print "Letter: "
    ch = gets&.strip&.downcase
    return unless ch && ch.match?(/^[a-z]$/)

    return if @guessed.include?(ch)
    @guessed << ch

    @wrong += 1 unless @word.include?(ch)
  end

  def won?
    (@word.chars.uniq - @guessed).empty?
  end

  def lost?
    @wrong >= @max_wrong
  end

  def save
    data = { word: @word, guessed: @guessed, wrong: @wrong }
    File.write(SAVE_FILE, data.to_yaml)
    puts "Saved to #{SAVE_FILE}"
  end

  def load_game
    return puts("No save file yet.") unless File.exist?(SAVE_FILE)

    data = YAML.load_file(SAVE_FILE)
    @word = data[:word]
    @guessed = data[:guessed]
    @wrong = data[:wrong]
    puts "Loaded!"
  end
end