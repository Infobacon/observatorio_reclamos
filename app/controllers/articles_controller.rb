class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy]

  # GET /articles
  # GET /articles.json
  def user_tweet
    db = SQLite3::Database.open "./db/sqlitedatabase.db"
    id=db.execute("select id_tweet from tweet order by id_tweet desc limit 1;")
    id_u=db.execute("select id_usuario from usuario order by id_usuario desc  limit 1;")
    db.execute( "INSERT INTO usuariotweet(id_usuario,id_tweet) values (?,?)", id,id_u)
  end
  def insert_tweet(palabra)
    db = SQLite3::Database.open "./db/sqlitedatabase.db"
    #db.execute( "INSERT INTO Tweet(
		 #     	'Contenido','fecha','id_diccionario') values(?,?,?)", [palabra.text],[palabra.created_at],1)
     db.execute( "INSERT INTO Tweet(
          	'Contenido','id_diccionario') values(?,?)", [palabra.text],1)
  end
  def insert_usuario(palabra)
    db = SQLite3::Database.open "./db/sqlitedatabase.db"
    db.execute( "INSERT INTO Usuario(
		      	'Id_t','Nick','Nombre_u','Id_local') values(?,?,?,?)", [palabra.user.id],[palabra.user.screen_name],[palabra.user.name],1)
  end
  def reclamo(texto)
    db = SQLite3::Database.open "./db/sqlitedatabase.db"
    id=db.execute("select id_tweet from tweet
    order by id_tweet desc
    limit 1;")
    id_e=0
    i=" "
    tipo="otros"
    servicio="hogar"
    palabra=texto.split
    palabra.each do |i|
      if (i.equal?"señal")
        tipo="servicio"
      end
      if (i.equal?"boleta")
        tipo="facturacion"
      end
      if (i.equal?"factura")
        tipo="facturacion"
      end
      if (i.equal?"cobro")
        tipo="facturacion"
      end
    end
    palabra.each do |i|
      if (i.equal?"celular")
        tipo="celular"
      end
    end
    palabra.each do |i|
        if (i.equal?"entel_ayuda")
          id_e=db.execute("select id from compañias where compañias.cuenta='entel_ayuda';")
          db.execute("insert into reclamos (id_tweet,id_empresa,tipo,servicio) values(?,?,?,?)",id,id_e,tipo,servicio)
        end
        if (i.equal?"ClaroTeAyuda")
          id_e=db.execute("select id from compañias where compañias.cuenta='ClaroTeAyuda'")
          db.execute("insert into reclamos (id_tweet,id_empresa,tipo,servicio) values(?,?,?,?)",id,id_e,tipo,servicio)
        end
        if (i.equal?"AyudaMovistarCL")
          id_e=db.execute("select id from compañias where compañias.cuenta='AyudaMovistarCL'")
          db.execute("insert into reclamos (id_tweet,id_empresa,tipo,servicio) values(?,?,?,?)",id,id_e,tipo,servicio)
        end
    end
  end
  def index
	require 'sqlite3'
	require 'twitter'
	db = SQLite3::Database.open "./db/sqlitedatabase.db"
	client = Twitter::Streaming::Client.new do |config|
  		config.consumer_key        = "6lbKKtoGUNt1HqmXp5OTfpnSu"
  		config.consumer_secret     = "m0rkrkbmn5sDuXcJFBSJRmrzcEYEBXx95k80nH738JrxdFpl7h"
  		config.access_token        = "777522674-swQ5cJqfqSnzf2CCJgDSWLaVkRpr5XogBmyKCQGJ"
  		config.access_token_secret = "MQuAZO0kJ4JGxTNYQlsdLgRN02RYHChpMLOBQZt6aRMWv"
	end
	topics = ["entel_ayuda celular","AyudaMovistarCL celular", "ClaroTeAyuda celular","entel_ayuda señal","AyudaMovistarCL señal", "ClaroTeAyuda señal","entel_ayuda telefono","AyudaMovistarCL telefono", "ClaroTeAyuda telefono" ]
  #topics = ["internet"]
  contador = 0
	@tweets = []	
	client.filter(:track => topics.join(",")) do |object|
		contador += 1
		if contador >= 2
			break
  		else
  			puts object.text if object.is_a?(Twitter::Tweet)
  			puts object.user.screen_name if object.is_a?(Twitter::Tweet)
  			@tweets.push object.text if object.is_a?(Twitter::Tweet)
        @tweets.push object.user.screen_name if object.is_a?(Twitter::Tweet)
        #@tweets = db:usuario
        #row = db.execute("select * from tweet")
        #@tweets.push db.execute("select * from usuario")
        #@tweets.push db.execute("select * from reclamos")
        #@tweets.push db.execute("select * from compañias")
        insert_tweet(object)
        insert_usuario(object)
        reclamo(object.text)
        user_tweet
      #db.execute(test([object.text],[object.user.screen_name]))
			#@tweets.push contador
  			#@tweets = object.text if object.is_a?(Twitter::Tweet)
  		end
  	end

    #@articles = Article.all
	  end

  # GET /articles/1
  # GET /articles/1.json
  def show
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles
  # POST /articles.json
  def create
    @article = Article.new(article_params)

    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: 'Article was successfully created.' }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to @article, notice: 'Article was successfully updated.' }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_url, notice: 'Article was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_params
      params.require(:article).permit(:title, :body)
    end
end
