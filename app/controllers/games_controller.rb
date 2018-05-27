class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy, :guess]
  before_action :check_game_status, only: [:show]

  # GET /games
  # GET /games.json
  def index
    @games = Game.all
  end

  # GET /games/1
  # GET /games/1.json
  def show
    @png = @game.guesses + 1


    @main_word = ''

    @game.word.split('').each do |letter|
      if @game.letter_guesses.include?(letter.upcase)
        @main_word += letter
      else
        @main_word += '_'
      end
    end
  end

  # GET /games/new
  def new
    @game = Game.new
  end

  # GET /games/1/edit
  def edit
  end

  # POST /games
  # POST /games.json
  def create
    @game = Game.new(game_params)

    respond_to do |format|
      if @game.save
        format.html { redirect_to @game, notice: 'Game was successfully created.' }
        format.json { render :show, status: :created, location: @game }
      else
        format.html { render :new }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /games/1
  # PATCH/PUT /games/1.json
  def update
    respond_to do |format|
      if @game.update(game_params)
        format.html { redirect_to @game, notice: 'Game was successfully updated.' }
        format.json { render :show, status: :ok, location: @game }
      else
        format.html { render :edit }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end


  def guess

    letter_guesses = @game.letter_guesses + params['user_guessed_letter']

    unless @game.word.upcase.include?(params['user_guessed_letter'])
      wrong_guesses = @game.guesses += 1
      @game.update(guesses: wrong_guesses)
    end

    @game.update(letter_guesses: letter_guesses )

    redirect_to game_path(@game)
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    @game.destroy
    respond_to do |format|
      format.html { redirect_to games_url, notice: 'Game was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_params
      params.require(:game).permit(:word, :guesses, :letter_guesses)
    end

    def check_game_status

      if @game.guesses == 7
        session[:games_lost] += 1
        @game_status = 'defeated'
        # @game_message = 'Too bad, you lost!'
      elsif all_letters_were_guessed
        session[:games_won] += 1
        @game_status = 'victory'
        # @game_message = 'Great job, you won! '
      else
         @game_status = 'playing'
         # @game_message = 'Keep playing!'
      end

    end


    def all_letters_were_guessed
      @true_count = 0

      @game.word.split('').each do |letter|
          @true_count += 1 if @game.letter_guesses.include?(letter)
      end

      return ( @true_count == @game.word.length ) ? true : false

    end

end
