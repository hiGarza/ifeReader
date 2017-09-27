# app.rb
require 'faye/websocket'
require 'listen'
require 'pdf-reader'
require 'digest/sha1'
require 'json'
require 'fileutils'

saved = []
es = nil
App = lambda do |env|
  if Faye::EventSource.eventsource?(env)
    es = Faye::EventSource.new(env,:headers => {'Access-Control-Allow-Origin' => '*'})
   
    es.on :close do |event|
      es = nil
    end
    es.rack_response
  end
end

listener = Listen.to('/Users/humberto/Desktop/listen') do |modified, added, removed|
  if added.length > 0
    person = {}
    reader = PDF::Reader.new(added[0].to_s)
    reader.pages.each do |page|
      person[:keyDate] = Date.today
      person[:access] = DateTime.now

      person[:doc_type]= page.text.scan(/Document Type:.*/)[0].sub(/Document Type:/, '').strip
      person[:issue_date]= page.text.scan(/Issue Date:.*/)[0].sub(/Issue Date:/, '').strip
      person[:expiration_date]= page.text.scan(/Expiration Date:.*/)[0].sub(/Expiration Date:/, '').strip

      person[:name]= page.text.scan(/Name:.*/)[0].sub(/Name:/, '').sub(/Height:/, '').strip
      person[:birthdate]= page.text.scan(/Birth Date:.*/)[0].sub(/Birth Date:/, '').sub(/Weight:/, '').strip
      person[:age]= page.text.scan(/Age:.*/)[0].sub(/Age:/, '').sub(/Hair Color:/, '').strip
      person[:gender]= page.text.scan(/Gender:.*/)[0].sub(/Gender:/, '').sub(/Eye Color:/, '').strip
      person[:userID] = Digest::SHA1.hexdigest(person[:name]+person[:birthdate])
      person[:company] = "etc" # Cambiar por nombre de la empresa en config file

      w = page.xobjects[:im4].hash[:Width]
      h = page.xobjects[:im4].hash[:Height]
      File.open("/Users/humberto/Desktop/ifeReader/frontEnd/static/#{person[:userID]}.jpg", "wb") { |file| file.write page.xobjects[:im4].data }

      unless saved.include?(person[:userID])
        saved.push(person[:userID])
        person[:exit]= false
      else
        saved.delete(person[:userID])
        person[:exit]= true
      end
    end

    es.send(person.to_json.to_s)
    FileUtils.rm(added[0])
  end
end
listener.start