class LongestWordController < ApplicationController
  def game
    @grid = []
    @grid_size = rand(9..15)
      @grid_size.times do
        @letter = ('A'..'Z').to_a[rand(26)]
        @grid << @letter
      end
      @grid
  end

  def score
    @shot = eval(params[:grid])
    @attempt = params[:attempt]
    @try = @attempt.upcase.split(//)
    @result = Hash.new(0)
    @result[:time] = Time.now.round(2) - Time.at(params[:start_time].to_i).round(2)

    @grid_hash = Hash.new(0)
    @shot.each do |x|
      if @grid_hash[x].nil?
        @grid_hash[x] = 1
      else
        @grid_hash[x] += 1
      end
    end

    @attempt_hash = Hash.new(0)
    @attempt.upcase.split(//).each do |x|
      if @attempt_hash[x].nil?
        @attempt_hash[x] = 1
      else
        @attempt_hash[x] += 1
      end
    end

    if !@attempt_hash.all? { |k, v| v <= @grid_hash[k] }
      @result[:message] = "Not in the grid."
      @result[:score] = 0
      elsif
        @url = "https://api-platform.systran.net/translation/text/translate?source=en&target=fr&key=15359063-1d81-4050-b0a6-897bbb5ad14e&input=#{@attempt}"
        @apis = open(@url).read
        @api = JSON.parse(@apis)
        @score = @attempt.size * 10
          if @attempt == @api["outputs"][0]["output"]
            @result[:message] = "Not a english word."
            @result[:score] = 0
            @result[:translation] = nil
          else
            @result[:translation] = @api["outputs"][0]["output"]
            @result[:score] = (@attempt.size * 100) - (@result[:time] * 10)
            @result[:message] = "Well done!"
          end
    end
    @result
  end
end
