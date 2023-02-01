class MediasController < ApplicationController
  before_action :authenticate_user
  before_action :find_current_user_followings

  def index
    # this returns all intances of another user following the current user, or of another user liking or commenting on one of the current users posts
    #for the union to work, table columns must be selected in same order for each query, each query has a lot of selects to make sure they are in the correct order

    @like_media = Like.joins(:post).joins(:user)
      .select("76 AS id") #ids are set as the unicode value of "L" for like
      .select("likes.created_at")
      .select("posts.picture_url, posts.id AS post_id")
      .select("users.id AS user_id, users.username, users.profile_picture")
      .select("CAST(NULL AS bigint) AS comment_id, CAST(NULL AS text) AS text")
      .select("likes.id AS like_id")
      .select("CAST(NULL AS boolean) AS current_user_follows")
      .where("posts.user_id = :current_user_id AND users.id != :current_user_id", { current_user_id: @current_user.id })
      .to_sql
    @comment_media = Comment.joins(:post).joins(:user)
      .select("67 AS id") #ids are set as the unicode value of "C" for comment
      .select("comments.created_at")
      .select("posts.picture_url, posts.id AS post_id")
      .select("users.id AS user_id, users.username, users.profile_picture")
      .select("comments.id AS comment_id, comments.text")
      .select("CAST(NULL AS bigint) AS like_id")
      .select("CAST(NULL AS boolean) AS current_user_follows")
      .where("posts.user_id = :current_user_id AND users.id != :current_user_id", { current_user_id: @current_user.id })
      .to_sql
    @follow_media = Follow.joins("JOIN users ON users.id = follows.follower_id")
      .select("70 AS id") #ids are set as the unicode value of "F" for follow
      .select("follows.created_at")
      .select("CAST(NULL AS varchar) AS picture_url, CAST(NULL AS bigint) AS post_id")
      .select("follows.follower_id AS user_id, users.username, users.profile_picture")
      .select("CAST(NULL AS bigint) AS comment_id, CAST(NULL AS text) AS text")
      .select("CAST(NULL AS bigint) AS like_id")
      .select("CAST(CAST(SUM(DISTINCT CASE WHEN follows.follower_id IN (#{@current_user_followings.join(", ")}) THEN 1 ELSE 0 END) AS INT) AS BOOLEAN) as current_user_follows")
      .where("follows.followee_id = :current_user_id", { current_user_id: @current_user.id })
      .group("follows.follower_id, users.username, users.profile_picture, follows.created_at")
      .to_sql

    @all_media = User.find_by_sql("#{@follow_media} UNION ALL #{@like_media} UNION ALL #{@comment_media} ORDER BY created_at DESC")

    render :json => @all_media
  end
end
