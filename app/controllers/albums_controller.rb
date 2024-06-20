class AlbumsController < ApplicationController
    def show
      @album = Album.find(params[:id])
      @details=@album.album_details
      render partial: 'albums/album_details', locals: { album: @album , details:@details }
    end
  end
  