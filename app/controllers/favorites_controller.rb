class FavoritesController < ApplicationController
  before_action :require_user_logged_in
  
  
  def create
    micropost = Micropost.find(params[:micropost_id])
    user = micropost.user
    current_user.approve(micropost)
    flash[:success] = 'お気に入りに登録しました。'
    redirect_to user
  end

  def destroy
    micropost = Micropost.find(params[:micropost_id])
    user = micropost.user
    current_user.disapprove(micropost)
    flash[:danger] = 'お気に入りを解除しました。'
    redirect_to user
  end
  
end
