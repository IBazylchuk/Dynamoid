desc "Start DynamoDBLocal, run tests, clean up"
task :unattended_spec do |t|

  if system("bin/start_dynamodblocal")
    puts "DynamoDBLocal started; proceeding with specs."
  else
    raise "Unable to start DynamoDBLocal.  Cannot run unattended specs."
  end

  #Cleanup
  at_exit do
    unless system("bin/stop_dynamodblocal")
      $stderr.puts "Unable to cleanly stop DynamoDBLocal."
    end
  end

  Rake::Task["spec"].invoke
end
