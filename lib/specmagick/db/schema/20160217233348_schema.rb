Sequel.migration do
  change do
    create_table(:tags, :ignore_index_errors=>true) do
      primary_key :id
      String :name, :size=>255
      
      index [:name], :unique=>true
    end
    
    create_table(:tags_tests, :ignore_index_errors=>true) do
      Integer :test_id
      Integer :tag_id
      
      index [:test_id, :tag_id], :unique=>true
    end
    
    create_table(:test_outcomes, :ignore_index_errors=>true) do
      primary_key :id
      Integer :test_id
      Integer :run_id
      TrueClass :success
      Float :execution_time
      DateTime :created_at
      
      index [:run_id, :test_id], :unique=>true
    end
    
    create_table(:test_runs) do
      primary_key :id
      String :name, :size=>80
      DateTime :created_at
    end
    
    create_table(:test_runs_tests) do
      Integer :test_run_id
      Integer :test_id
    end
    
    create_table(:tests) do
      primary_key :id
      String :name, :size=>1000
      String :description, :size=>1000
      String :position, :size=>1000
      String :location, :size=>1000
    end
  end
end
