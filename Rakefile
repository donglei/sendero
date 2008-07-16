#namespace :test do
#  file "dsss.conf"  
#end

SENDERO_SRC = "sendero/**/*.d"
SENDERO_BASE_SRC = "base/sendero_base/**/*.d"
TEST_SENDERO = "test_sendero.d"
RAGEL_SRC = FileList["sendero/**/*.rl"];
RAGEL_OUTPUT = RAGEL_SRC.ext(".d");

rule ".d" => ".rl" do |f|
  sh "ragel -D -o #{f.name} #{f.source}"
end

SRC = FileList[SENDERO_SRC, SENDERO_BASE_SRC, TEST_SENDERO, RAGEL_OUTPUT]

TEST_FILES = FileList["test/template/*.xml"]

file "test_sendero.exe" => SRC do
  sh "dsss build test_sendero.d"
end

task :build => "test_sendero.exe"

task :test_files => TEST_FILES

task :test => [:build, :test_files] do
  sh "test_sendero"
end

task :default => [:test]