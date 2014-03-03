#requirements
require 'CSV'
require 'sinatra'

get '/' do
  redirect '/'
end


#initiate variables
wins_losses = []
@leaderboard = []

score_data = [
  {
    home_team: "Patriots",
    away_team: "Broncos",
    home_score: 7,
    away_score: 3
  },
  {
    home_team: "Broncos",
    away_team: "Colts",
    home_score: 3,
    away_score: 0
  },
  {
    home_team: "Patriots",
    away_team: "Colts",
    home_score: 11,
    away_score: 7
  },
  {
    home_team: "Steelers",
    away_team: "Patriots",
    home_score: 7,
    away_score: 21
  }
]

#methods
def compile_and_sort (wins_losses, iterations)
  count = 1
  iterations = iterations -1
  @leaderboard = []

  sorted0 = wins_losses.sort{ |a, b | a[0]['wins']<=>b[0]['wins']}
  sorted = sorted0.sort{ |a, b | a[0]['team']<=>b[0]['team']}

  current_team = sorted[0][0]["team"]
  current_wins = sorted[0][0]["wins"]
  current_losses = sorted[0][0]["losses"]

  until sorted[count][0]["team"] == "end" do
    if sorted[count][0]["team"] == current_team
      current_wins += sorted[count][0]["wins"]
      current_losses += sorted[count][0]["losses"]
      count += 1
    else
      @leaderboard << [current_team, current_wins, current_losses]
      count += 1
      current_team = sorted[count][0]["team"]
      current_wins = sorted[count][0]["wins"]
      current_losses = sorted[count][0]["losses"]
      if count >= iterations && sorted[count][0]["team"] == "end"
        @leaderboard << [sorted[iterations][0]["team"], sorted[iterations][0]["wins"], sorted[iterations][0]["losses"]]
      end
    end
  end
  @leaderboard
end

@teams = []

# Initialize `@teams` array with scores of 0 for each team
score_data.each do |game_results|
  home_team = { name: game_results[:home_team], wins: 0, losses: 0 }
  away_team = { name: game_results[:away_team], wins: 0, losses: 0 }

  @teams << home_team
  @teams << away_team
end

score_data.each_with_index do |game_results, count|
  if game_results[:home_score] > game_results[:away_score]
    wins_losses << ["team" => game_results[:home_team], "wins" => 1, "losses" => 0]
    wins_losses << ["team" => game_results[:away_team], "wins" => 0, "losses" => 1]
  else
    wins_losses << ["team" => game_results[:away_team], "wins" => 1, "losses" => 0]
    wins_losses << ["team" => game_results[:home_team], "wins" => 0, "losses" => 1]
  end
end

iterations = wins_losses.length
#add ending row
wins_losses << ["team" => "end", "wins" => 0, "losses" => 0]
# send data to method for consolidatiion
@leaderboard = compile_and_sort(wins_losses, iterations)
#sort data
sorted0 = @leaderboard.sort{ |a, b | b[2]<=>a[2]}

get '/leaderboard' do
  @leaderboard  = sorted0.sort{ |a, b | b[1]<=>a[1]}
  erb:index
end
#print @leaderboard
