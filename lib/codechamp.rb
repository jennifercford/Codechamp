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
      # @processed_data = []
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
      d = users.sort_by { |x| -x[c] }.join("\n")
      puts "#{d}"
      # puts "Usernames"
      # users.each do |user|
      #   puts "#{user}, #{week}"
      # end
        # @processed_data.push(data)
        #first need a loop to get username and make it a hash key
        #then need to loop over weeks and retreive add, deletion, and commits and attach
        #to username key
        #then make method to sort the values add, delete, and commits diff orders
      # end
      # @processed_data
    end
    def data_processer
      # user
      # username = user["author"]["login"]
      # additions = user.each["weeks"]["a"]#loop to add
      # deletions = user["weeks"]["d"]
      # commits = user["weeks"]["c"]
    end

    # def sort
    #   @processed_data
    # end

  end
end


app = Codechamp::App.new
app.connect_github
#app.get_owner_and_repo
app.do_important_work
#organized_data = app.do_important_work
#app.sort(organized_data)


#   #loop to get all users using response each ["author"]["login"]
# end
# def get_added
# end
# def get_deleted
# end
# def get_commits
# end
# def hash_them_together
# end

# def sum_weeks(weeks, key) # additions = sum_weeks(user["weeks"], "a") => 312
# end
