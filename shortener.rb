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
class Link < ActiveRecord::Base
    attr_accessor :input_url, :output
    def initialize input_url
        @input_url = input_url
    end
    def shortener
        @output = 1
    end
end

get '/' do
    form
end

post '/new' do
    if @params['url'] then
        # binding.pry
        # p @params['url']
        newLink = Link.new( @params['url'] )
        # p newLink
        p newLink.shortener
    end
    # PUT CODE HERE TO CREATE NEW SHORTENED LINKS
end

get '/jquery.js' do
    send_file 'jquery.js'
end

####################################################
####  Implement Routes to make the specs pass ######
####################################################