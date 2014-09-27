=begin
The MIT License (MIT)

Copyright (c) <2014> <Robert Kowalski>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
=end

require 'net/http'
require 'json'
require 'date'

git_token = ""
git_owner = ""
git_project = ""

url = "https://api.github.com/repos/#{git_owner}/#{git_project}/pulls?state=open&per_page=100&access_token=#{git_token}"

SCHEDULER.every '10m', :first_in => 0 do |job|
  uri = URI.parse(url)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  request = Net::HTTP::Get.new(uri.request_uri)
  response = http.request(request)

  open_pr = JSON.parse(response.body, symbolize_names: true)

  amount_pr = open_pr.length

  send_event('github-open-pr', {
    current: amount_pr,
    title: "Open PR for #{git_owner}/#{git_project}"
  })
end
