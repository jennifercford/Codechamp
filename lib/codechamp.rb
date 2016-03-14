require "pry"
require "httparty"

require "codechamp/version"
require "codechamp/github"


module Codechamp
  class App

    def prompt(message, regex)
      puts message
      choice = gets.chomp
      until choice =~ regex
        puts "Incorrect input. Try again."
        puts message
        choice = gets.chomp
      end
      choice
    end

    def connect_github
      token = prompt("Please provide oauth token",
      /^[a-f0-9]{40}$/)
      @github = Github.new(token)
    end

    def get_owner_and_repo
      @owner = prompt("Who is the owner of the repo you are
      interested in?", /^[a-z0-9\-]{4,30}$/i)
      @repo = prompt("What Github repo do you want to access?",
      /^[a-z0-9\-\_]{6,20}$/i)
    end
    def get_user
      #loop to get all users using response each ["author"]["login"]
    end
    def get_added
    end
    def get_deleted
    end
    def get_commits
    end
    def hash_them_together
    end

    def do_important_work
      get_owner_and_repo
      response = @github.get_contributors(@owner,@repo)
      #Need logical loop to retreive each user
      #need retreive each a ,d , and c
      users = response.each {|x["author"]["login"]| puts "#{x["author"]["login"]}" }
      binding.pry
    end
  end
end


app = Codechamp::App.new
app.connect_github
# app.get_owner_and_repo
app.do_important_work
