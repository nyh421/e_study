class Public::UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @post_study_method = PostStudyMethod.new
    @post_study_methods = @user.post_study_methods
  end

  def index
    #総勉強時間のランキング
    @total_study_ranks = AchievedTask.group(:user_id).order("sum_study_hour DESC").sum(:study_hour)
    #自分の総勉強時間ランキングを調べる処理
    @total_my_rank = 0
    @total_study_ranks.each.with_index(1) do |rank, i|
      if rank.first == current_user.id
        @total_my_rank = i
        break
      end
    end
    #今日の勉強時間のランキング
    @day_study_ranks = AchievedTask.where(created_at: Time.current.all_day).group(:user_id).order("sum_study_hour DESC").sum(:study_hour)
    #自分の今日の勉強時間ランキングを調べる処理
    @day_my_rank = 0
    @day_study_ranks.each.with_index(1) do |rank, i|
      if rank.first == current_user.id
        @day_my_rank = i
        break
      end
    end
    #今月の勉強時間のランキング
    @month_study_ranks = AchievedTask.where(created_at: Time.current.all_month).group(:user_id).order("sum_study_hour DESC").sum(:study_hour)
    #自分の今月の勉強時間ランキングを調べる処理
    @month_my_rank = 0
    @month_study_ranks.each.with_index(1) do |rank, i|
      if rank.first == current_user.id
        @month_my_rank = i
        break
      end
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    redirect_to user_path(current_user)
  end

  private

  def user_params
    params.require(:user).permit(:name, :school_year, :profile_image)
  end

end
