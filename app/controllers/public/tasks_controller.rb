class Public::TasksController < ApplicationController

  def new
    @task = Task.new
    #達成済みのタスクは表示しない
    @tasks = Task.where(user_id: current_user.id, is_achieved: false)
    #ユーザーの総勉強時間
    @total_study_time = Task.where(user_id: current_user.id, is_achieved: true).sum(:study_hours)
    @todays_total_study_time = Task.where(user_id: current_user.id, is_achieved: true, updated_at: Time.zone.now.all_day).sum(:study_hours)
  end

  def create
    @task = Task.new(task_params)
    @task.user_id = current_user.id
    @task.save
    redirect_to request.referer
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    @task.update(task_params)
    redirect_to new_task_path
  end

  def destroy
    task = Task.find(params[:id])
    task.destroy
    redirect_to request.referer
  end

  def achieve
    #タスクを達成するとユーザーのポイントが貯まる
    @task = Task.find(params[:id])
    @user = User.find(current_user.id)
    @task.update(is_achieved: true)
    @user.point += @task.study_hours
    @user.save
    redirect_to request.referer
  end

  private

  def task_params
    params.require(:task).permit(:content, :study_hours, :subject_id, :is_achieved)
  end

end
