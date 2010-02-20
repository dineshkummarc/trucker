def run(cmd)
  puts(cmd)
  output = ""
  IO.popen(cmd) do |com|
    com.each_char do |c|
      print c
      output << c
      $stdout.flush
    end
  end
  form_growl_message output
end

def run_test_file(file)
  run %Q(ruby -I"test" #{file})
end

def growl(title, msg, img)
  %x{growlnotify -m #{msg.inspect} -t #{title.inspect} --image ~/.watchr/#{img}.png}
end

def form_growl_message(str)
  results = str.split("\n").last
  if results =~ /[1-9]\s(failure|error)s?/
    growl "Test Results", "#{results}", "fail"
  elsif results != ""
    growl "Test Results", "#{results}", "pass"
  end
end

# watch('test/test_helper\.rb') { run_all_tests }
watch('test/.*/.*_test\.rb')  { |m| system('clear'); run_test_file(m[0]) }

# Ctrl-\
Signal.trap('QUIT') do
  puts " --- Running all tests ---\n\n"
  run_all_tests
end

# Ctrl-C
Signal.trap('INT') { abort("\n") }