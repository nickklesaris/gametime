#requirements
require 'CSV'
require 'sinatra'

before do
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

  @teams = []

  # Initialize `@teams` array with scores of 0 for each team
  score_data.each do |game_results|
    home_team = { name: game_results[:home_team], wins: 0, losses: 0 }
    away_team = { name: game_results[:away_team], wins: 0, losses: 0 }

    @teams << home_team
    @teams << away_team
  end

  @teams.uniq!

  score_data.each do |game_results|
    if game_results[:home_score] > game_results[:away_score]
      winner = @teams.find { |team| team[:name] == game_results[:home_team] }
      loser = @teams.find { |team| team[:name] == game_results[:away_team] }
    else
      winner = @teams.find { |team| team[:name] == game_results[:away_team] }
      loser = @teams.find { |team| team[:name] == game_results[:home_team] }
    end

    winner[:wins] += 1
    loser[:losses] += 1
  end

  @teams.sort_by! do |team|
    [-team[:wins], team[:losses]]
  end
end

get '/' do
  redirect '/leaderboard'
end

get '/leaderboard' do
  erb :index
end
