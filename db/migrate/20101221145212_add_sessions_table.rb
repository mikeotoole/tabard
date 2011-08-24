[?1l>[?12l[?25h[?1049lVim: Caught deadly signal SEGV
Vim: Finished.
[55;1Hssions do |t|
      t.string :session_id, :null => false
      t.text :data
      t.timestamps
    end

    add_index :sessions, :session_id
    add_index :sessions, :updated_at
  end

  def self.down
    drop_table :sessions
  end
end
