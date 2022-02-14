require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = (0..10).map { ('A'..'Z').to_a[rand(26)] }
    @start_time = Time.now.to_i
  end

  def score
    @start_time = params[:start_time].to_i
    @end_time = Time.now.to_i
    @time = @end_time - @start_time
    @letters = params[:letters].chars
    @letters_original = params[:letters].gsub(' ', ', ')
    @user_input = params[:answer].upcase
    @length = @user_input.length
    @score = (100 - @time) * @length

    @in_grid = letter_in_grid?(@letters, @user_input)
    @valid = english_word?(@user_input)


  end

  def letter_in_grid?(letters, answer)
    @result = true
    answer.chars.each do |letter|
      if letters.include?(letter)
        index = letters.find_index(letter)
        letters[index] = ' '
      else
        @result = false
      end
    end
    return @result
  end

  def english_word?(answer)
    url = "https://wagon-dictionary.herokuapp.com/#{answer}"
    word_serialized = URI.open(url).read
    word = JSON.parse(word_serialized)
    @found = word["found"]
  end
end
