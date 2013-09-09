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



#merde de la putain d'ajax de mes 2 -_-
get '/ajax/section/:annee' do
  annee = params[:annee]
   case annee
      when "1"  
        "<option>A</option>"
      when "2"
        "<option>A</option><option>P</option>"
      when "3"
        "<option>A</option><option>B</option>"
      when "4"
        "<option>ARCTIC</option><option>ERP_BI</option><option>GL</option><option>INFINI</option>
        <option>IRT</option><option>SIM</option><option>SLEAM</option><option>INFOB</option>
        <option>TELB</option>"
      when "5"
        "<option>INFOA</option><option>INFOB</option><option>SIM</option>
        <option>TELA</option><option>TELB</option>"   
  end
end




post '/' do
   params.inspect
 end
 

post '/post' do  
  n = Perm.new  
  #Nos params
  nom = params[:nom]
  annee = params[:annee]
  section = params[:section]
  clas = params[:clas]
  o_class = annee,section,clas
  o_class.join(',')
  n_class = annee,section
  n_class.join(',')
  fb = params[:fb]

  n.nom = nom
  n.o_class = o_class
  n.n_class = n_class 
  n.fb = fb
  n.save  
  redirect '/'  
end  



##autre shit
get '/:id/go' do 
	lien = Perm.get params[:id]
  lien.checked = 1
  lien.save
  "
  <HTML>
    <HEAD>
      <META HTTP-EQUIV='refresh' CONTENT='5;URL=#{lien.url}'>
    </HEAD>
    <BODY>
      <br /><br /><br /><h4 align='center'>Direction : #{lien.url}</h4>
    </BODY>
  </HTML>
  " 
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
  '<h1>404</h1>Go home you\'r drunk'  
end  