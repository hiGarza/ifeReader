require 'listen'
require 'pdf-reader'
require 'digest/sha1'
require 'aws-sdk'
require 'json'
require 'net/http'

s3 = Aws::S3::Resource.new(
  access_key_id: 'AKIAITKWFBPFD5CSOPFA',
  secret_access_key: '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',
  region: 'us-west-1'
)

# listener = Listen.to('listen') do |modified, added, removed|
  person = {}
	#Read Data it
	# reader = PDF::Reader.new(added[0])
	reader = PDF::Reader.new(ARGV[0])
	reader.pages.each do |page|
		w = page.xobjects[:im4].hash[:Width]
    	h = page.xobjects[:im4].hash[:Height]
    	File.open("temp.jpg", "wb") { |file| file.write page.xobjects[:im4].data }
		person[:keyDate] = Date.today
    person[:access] = DateTime.now

		# person[:date]= page.text.scan(/Capture Date and Time:.*/)[0].sub(/Capture Date and Time:/, '').strip
		person[:doc_type]= page.text.scan(/Document Type:.*/)[0].sub(/Document Type:/, '').strip
		person[:issue_date]= page.text.scan(/Issue Date:.*/)[0].sub(/Issue Date:/, '').strip
		person[:expiration_date]= page.text.scan(/Expiration Date:.*/)[0].sub(/Expiration Date:/, '').strip

		person[:name]= page.text.scan(/Name:.*/)[0].sub(/Name:/, '').sub(/Height:/, '').strip
		person[:birthdate]= page.text.scan(/Birth Date:.*/)[0].sub(/Birth Date:/, '').sub(/Weight:/, '').strip
		person[:age]= page.text.scan(/Age:.*/)[0].sub(/Age:/, '').sub(/Hair Color:/, '').strip
		person[:gender]= page.text.scan(/Gender:.*/)[0].sub(/Gender:/, '').sub(/Eye Color:/, '').strip
		# person[:userID] = Digest::SHA1.hexdigest(person[:name]+person[:birthdate])
		person[:userID] = ARGV[1]
		person[:company] = "etc"
		obj = s3.bucket('ife-reader').object("#{person[:userID]}.jpg")
		obj.upload_file('temp.jpg')
		uri = URI('https://mwalm5619b.execute-api.us-west-1.amazonaws.com/production/access')
		https = Net::HTTP.new(uri.host,uri.port)
		https.use_ssl = true
		req = Net::HTTP::Post.new(uri.path, initheader = {'Content-Type' =>'application/json'})
		req.body = person.to_json
		res = https.request(req)
		puts "Response #{res.code} #{res.message}: #{res.body}"
	end

	puts person.to_json
# end
# listener.start # not blocking
# sleep