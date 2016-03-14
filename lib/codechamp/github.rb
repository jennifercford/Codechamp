module Codechamp
  class Github
    include HTTParty
    base_uri "https://api.github.com"

    def initialize(token)
      @headers = {
        "Authorization" => "token #{token}",
        "User-Agent"    => "HTTParty"
      }
    end

    def get_user(username)
      Github.get("/users/#{username}", headers: @headers)
    end

    def get_contributors(owner,repo)
      Github.get("/repos/#{owner}/#{repo}/stats/contributors",
      headers: @headers)
    end

  end
end
