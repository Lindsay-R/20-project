class PostsTable
  def initialize(database_connection)
    @database_connection = database_connection
  end

  def create(image, description, user_id)
    insert_post_sql = <<-SQL
      INSERT INTO posts (image, description, user_id)
      VALUES ('#{image}', '#{description}', #{user_id})
      RETURNING id
    SQL

    @database_connection.sql(insert_post_sql).first["id"]
  end

  # def find(p_id)
  #   find_sql = <<-SQL
  #     SELECT * FROM users
  #     WHERE id = #{p_id}
  #   SQL
  #
  #   @database_connection.sql(find_sql).first
  # end


  def all
    @database_connection.sql("SELECT * FROM posts")
  end

end