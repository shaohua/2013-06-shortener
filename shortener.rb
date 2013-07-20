require 'sinatra'
require "sinatra/reloader" if development?
require 'active_record'
require 'pry'

configure :development, :production do
    ActiveRecord::Base.establish_connection(
       :adapter => 'sqlite3',
       :database =>  'db/dev.sqlite3.db'
     )
end

# Quick and dirty form for testing application
#
# If building a real application you should probably
# use views:
# http://www.sinatrarb.com/intro#Views%20/%20Templates
form = <<-eos
    <form id='myForm'>
        <input type='text' name="url">
        <input type="submit" value="Shorten">
    </form>
    <h2>Results:</h2>
    <h3 id="display"></h3>
    <script src="jquery.js"></script>

    <script type="text/javascript">
        $(function() {
            $('#myForm').submit(function() {
            $.post('/new', $("#myForm").serialize(), function(data){
                $('#display').html(data);
                });
            return false;
            });
    });
    </script>
eos

# Models to Access the database
# through ActiveRecord.  Define
# associations here if need be
#
# http://guides.rubyonrails.org/association_basics.html

class Urls < ActiveRecord::Base
    attr_accessible :long_url
end

get '/' do
    form
end

post '/new' do
    find_url = Urls.find_by_long_url(@params['url'])
    if find_url then
        p 'http://localhost:4567/'+find_url.id.to_s
    elsif @params['url'] then
        # @ is the HTTP request obj
        newUrls = Urls.new({'long_url' => @params['url']})
        newUrls.save
        p 'http://localhost:4567/'+newUrls['id'].to_s
    else
        halt 404, 'File Not Found.'
    end
end

get '/jquery.js' do
    send_file 'jquery.js'
end

get '/favicon.ico' do
    #
end

get '/jquery.min.map' do
    #
end


get '/:id' do
    id_converted = @params['id'].to_i
    begin
        find_url = Urls.find(id_converted)
        if find_url then
            redirect 'http://' + Urls.find(id_converted).long_url
            return
        else
            halt 404, 'File Not Found.'
        end
    rescue ActiveRecord::RecordNotFound
        halt 404, 'File Not Found.'
    end
end



####################################################
####  Implement Routes to make the specs pass ######
####################################################