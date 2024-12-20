require 'rails_helper'

describe "Posters API", type: :request do
  before(:each) do
    Poster.create(name: "REGRET",
                  description: "Hard work rarely pays off.",
                  price: 89.00,
                  year: 2019,
                  vintage: true,
                  img_url: "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
    )
    Poster.create(name: "DISAPPOINTMENT",
                  description: "This is what your parents think of you.",
                  price: 108.00,
                  year: 2020,
                  vintage: false,
                  img_url: "https://images.unsplash.com/photo-1620401537439-98e94c004b0d"
    )
    Poster.create(name: "SADNESS",
                  description: "Let the depression take over.",
                  price: 65.00,
                  year: 2018,
                  vintage: false,
                  img_url: "https://images.unsplash.com/photo-1551993005-75c4131b6bd8"
    )
  end

  it 'sends a list of posters' do
    get '/api/v1/posters'

    expect(response).to be_successful

    posters = JSON.parse(response.body, symbolize_names: true)[:data]
    # binding.pry
    expect(posters.count).to eq(3)

    posters.each do |poster|
      expect(poster).to have_key(:id)
      expect(poster[:id]).to be_an(String)

      expect(poster[:attributes]).to have_key(:name)
      expect(poster[:attributes][:name]).to be_a(String)

      expect(poster[:attributes]).to have_key(:description)
      expect(poster[:attributes][:description]).to be_a(String)

      expect(poster[:attributes]).to have_key(:price)
      expect(poster[:attributes][:price]).to be_a(Float)

      expect(poster[:attributes]).to have_key(:year)
      expect(poster[:attributes][:year]).to be_a(Integer)

      expect(poster[:attributes]).to have_key(:vintage)
      expect(poster[:attributes][:vintage]).to be_a(TrueClass).or be_a(FalseClass)

      expect(poster[:attributes]).to have_key(:img_url)
      expect(poster[:attributes][:img_url]).to be_a(String)
    end
  end

  it 'can return all posters sorted in ascending order of creation' do
    get '/api/v1/posters?sort=asc'

    expect(response).to be_successful

    posters = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(posters[0][:attributes][:name]).to eq('REGRET')
    expect(posters[1][:attributes][:name]).to eq('DISAPPOINTMENT')
    expect(posters[2][:attributes][:name]).to eq('SADNESS')
  end

  it 'can return all posters sorted in descending order of creation' do
    get '/api/v1/posters?sort=desc'

    expect(response).to be_successful

    posters = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(posters[0][:attributes][:name]).to eq('SADNESS')
    expect(posters[1][:attributes][:name]).to eq('DISAPPOINTMENT')
    expect(posters[2][:attributes][:name]).to eq('REGRET')
  end

  it 'can update a specific posters data' do
    first_poster = Poster.first

    patch "/api/v1/posters/#{first_poster.id}", params: {
      poster: {
        name: 'LONELINESS',
        description: 'You will never have friends.',
        price: 32.00
      }
    }

    expect(response).to be_successful

    updated_poster = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(updated_poster).to have_key(:id)
    expect(updated_poster[:id]).to eq(first_poster.id.to_s)

    expect(updated_poster[:attributes]).to have_key(:name)
    expect(updated_poster[:attributes][:name]).to eq('LONELINESS')

    expect(updated_poster[:attributes]).to have_key(:description)
    expect(updated_poster[:attributes][:description]).to eq('You will never have friends.')

    expect(updated_poster[:attributes]).to have_key(:price)
    expect(updated_poster[:attributes][:price]).to eq(32.00)

    expect(updated_poster[:attributes]).to have_key(:year)
    expect(updated_poster[:attributes][:year]).to eq(2019)

    expect(updated_poster[:attributes]).to have_key(:vintage)
    expect(updated_poster[:attributes][:vintage]).to be true

    expect(updated_poster[:attributes]).to have_key(:img_url)
    expect(updated_poster[:attributes][:img_url]).to eq("https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d")
  end

  it 'can delete a poster' do
    poster_to_delete = Poster.first

    delete "/api/v1/posters/#{poster_to_delete.id}"

    expect(response).to be_successful
    expect(response.status).to eq(204)

    deleted_poster = Poster.find_by(id: poster_to_delete.id)
    expect(deleted_poster).to be nil

    remaining_posters = Poster.all
    expect(remaining_posters.count).to eq(2)
  end

  it "can find a single poster" do
    poster1 = Poster.first

    get "/api/v1/posters/#{poster1.id}" 

    expect(response).to be_successful

    poster = JSON.parse(response.body, symbolize_names: true)[:data]
    
    expect(poster).to have_key(:id)

    expect(poster[:id]).to be_an(String)

    poster = poster[:attributes]
    
    expect(poster).to have_key(:name)
    expect(poster[:name]).to be_a(String)

    expect(poster).to have_key(:description)
    expect(poster[:description]).to be_a(String)

    expect(poster).to have_key(:price)
    expect(poster[:price]).to be_a(Float)

    expect(poster).to have_key(:year)
    expect(poster[:year]).to be_a(Integer)

    expect(poster).to have_key(:vintage)
    expect(poster[:vintage]).to be_a(TrueClass).or be_a(FalseClass)

    expect(poster).to have_key(:img_url)
    expect(poster[:img_url]).to be_a(String)
  end

  it "can create a poster" do
    poster_params = {
      name: "REGRET",
      description: "Hard work rarely pays off.",
      price: 89.0,
      year: 2018,
      vintage: true,
      img_url: "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
    }

    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/posters", headers: headers, params: JSON.generate(poster: poster_params)

    newposter = Poster.last

    expect(response).to be_successful

    expect(newposter.name).to eq(poster_params[:name])
    expect(newposter.description).to eq(poster_params[:description])
    expect(newposter.price).to eq(poster_params[:price])
    expect(newposter.year).to eq(poster_params[:year])
    expect(newposter.vintage).to eq(poster_params[:vintage])
    expect(newposter.img_url).to eq(poster_params[:img_url])

  end
end