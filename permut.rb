#####################################
#    							                	#
# => Permutaion   	            		#
# => V_0.1	                        #
#   								                #
# 			=>By MILS (SalimoS)		      # 	 
# 									                #
#									                  #
#####################################



require 'sinatra'
require 'sinatra/reloader'
require 'data_mapper'  
require 'open-uri'
require 'date'
require 'open_uri_redirections'





DataMapper::setup(:default, ENV['DATABASE_URL'] || "postgres://localhost/permut")
class Perm  
  include DataMapper::Resource  
  property :id, Serial  
  property :nom, Text, :required => true 
  property :o_class, Text, :required => true 
  property :n_class, Text, :required => true
  property :fb, Text, :required => true  
end  
DataMapper.finalize.auto_upgrade!  

helpers do  
    include Rack::Utils  
    alias_method :h, :escape_html  
end 



get '/' do  
  @Perms = Perm.all :order => :id.desc  
  @title = 'Home'  
  erb :home  
end

get '/add' do
  @title = 'Ajout'
  erb :add
end





post '/' do
   params.inspect
 end
 

post '/post' do  
  n = Perm.new  
  #Nos params
  nom = params[:nom]
  o_class = params[:clas]
  n_class = params[:n_clas]
  fb = params[:fb]

  n.nom = nom
  n.o_class = o_class
  n.n_class = n_class 
  n.fb = fb
  n.save  
  puts "ID  = #{n.id}"
  redirect '/'  
end  



##autre shit
get '/:id/afficher' do 
	@demande = Perm.get params[:id]
  @title = "#{@demande.id}"
  erb :afficher
end




get '/:id/delete' do  
  @lien = Perm.get params[:id]  
  @title = "Confirm deletion of Perm ##{params[:id]}"  
  erb :delete  
end  


delete '/:id' do  
  n = Perm.get params[:id]  
  n.destroy  
  redirect '/'  
end  


#Notre chére 404
not_found do  
  status 404
  '
  <html>
    <head>
    <title>404 | PErmutation</title> 
    <head>
    <body><h3>Go home you\'r drunk</h3></body>
  </html>
'
end  