Sequel.migration do

  up do
    add_column :test_runs, :name, String, size: 80, null: true, after: :id
  end

  down do
    drop_column :test_runs, :name
  end

end
