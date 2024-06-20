require 'httparty'

namespace :import do
  desc "Import users from JSONPlaceholder"
  task users: :environment do
    url = 'https://jsonplaceholder.typicode.com/users'
    response = HTTParty.get(url)

    if response.success?
      response.each do |user_data|
        company = Company.find_or_create_by(name: user_data['company']['name']) do |c|
          c.catchPhrase = user_data['company']['catchPhrase']
          c.bs = user_data['company']['bs']
        end

        user = User.find_or_initialize_by(email: user_data['email'])
        user.update(
          name: user_data['name'],
          username: user_data['username'],
          phone: user_data['phone'],
          website: user_data['website'],
          company_id: company.id
        )
        
        user.create_address(
          street: user_data['address']['street'],
          suite: user_data['address']['suite'],
          city: user_data['address']['city'],
          zipcode: user_data['address']['zipcode'],
          lat: user_data['address']['geo']['lat'],
          lng: user_data['address']['geo']['lng']
        ) unless user.address.present?
      end
      puts "Users imported successfully!"
    else
      puts "Failed to retrieve data."
    end
  end

  desc "Update profile_pic for all users"
  task profile_pics: :environment do
    User.find_each do |user|
      response = HTTParty.get("https://picsum.photos/id/#{user.id}/info")
      if response.success?
        user.update(profile_pic: response.parsed_response["download_url"])
        puts "Updated profile_pic for user ##{user.id}"
      else
        puts "Failed to fetch profile_pic for user ##{user.id}"
      end
    end
  end

  desc "Import albums and album_details from JSONPlaceholder"
  task album_details: :environment do
    require 'httparty'

    albums_url = 'https://jsonplaceholder.typicode.com/albums'
    details_url = 'https://jsonplaceholder.typicode.com/photos'

    albums_response = HTTParty.get(albums_url)
    details_response = HTTParty.get(details_url)

    if albums_response.success? && details_response.success?
      albums_data = albums_response.parsed_response
      album_details = details_response.parsed_response

      albums_data.each do |album_data|
        user = User.find_by(id: album_data['userId'])
        next unless user

        album = Album.find_or_create_by(id: album_data['id']) do |a|
          a.title = album_data['title']
          a.user = user
        end

        album_details.each do |album_details_data|
          if album_details_data['albumId'] == album.id
            AlbumDetail.find_or_create_by(id: album_details_data['id']) do |p|
              p.title = album_details_data['title']
              p.url = album_details_data['url']
              p.thumbnail_url = album_details_data['thumbnailUrl']
              p.album = album
            end
          end
        end
      end

      puts "Albums and details imported successfully!"
    else
      puts "Failed to retrieve data."
    end
  end
end