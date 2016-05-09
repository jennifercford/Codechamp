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

    def do_important_work
      get_owner_and_repo
      contributer_list = @github.get_contributors(@owner,@repo)
      users = contributer_list.map do |x|
        user = x["author"]["login"]
        week = x["weeks"]
        commits = x["total"]
        add = week.map {|x| x["a"]}
        total_additions = add.inject(0) {|sum,x| sum + x }
        del = week.map {|x| x["d"]}
        deletions = del.inject(0) {|sum,x| sum + x}
        changes = week.map {|x| x["c"]}
        total_changes = changes.inject(0) {|sum,x| sum + x}
        [user,total_additions,deletions,total_changes,commits]
      end
      puts "How would you like this sorted by? Please pick a number"
      puts "1) lines added 2) lines deleted 3) total lines changed 4) commits made"
      c = gets.chomp.to_i
      puts "Usernames, Additions, Deletions, Changes, Commits"
      d = users.sort_by { |x| -x[c] }
      d.each_slice(1) { |x|
        puts x.join(", ")
      }
    end
  end
end


app = Codechamp::App.new
app.connect_github
app.do_important_work
