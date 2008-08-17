#namespace :test do
#  file "dsss.conf"  
#end

import '../decorated_d/build/Parser.rake'

SENDERO_SRC = "sendero/**/*.d"
SENDERO_BASE_SRC = "base/sendero_base/**/*.d"
TEST_SENDERO = "test_sendero.d"
RAGEL_SRC = FileList["sendero/**/*.rl"];
RAGEL_OUTPUT = RAGEL_SRC.ext(".d");
APD_SRC = FileList['sendero/xml/xpath10/*.apd']

SENDEROXC_SRC = FileList["senderoxc/**/*.d", "../decorated_d/decorated_d/**/*.d", '../decorated_d/decorated_d/parser/Parser.d']

rule ".d" => ".rl" do |f|
  sh "ragel -D -o #{f.name} #{f.source}"
end

file 'sendero/xml/xpath10/Parser.d' => APD_SRC do
  Dir.chdir("sendero/xml/xpath10") {
    sh "apaged_0.4.2", "Parser.apd", "Parser.d"
  }
end

SRC = FileList[SENDERO_SRC, SENDERO_BASE_SRC, 'sendero/xml/xpath10/Parser.d', TEST_SENDERO, RAGEL_OUTPUT]

TEST_FILES = FileList["test/template/*.xml"]

file "test_sendero.exe" => SRC do
  sh "dsss build test_sendero.d"
end

task :senderoxc => SENDEROXC_SRC do
  sh "rebuild senderoxc/Main.d -oqrebuild_objs -I../sendero_base -I../decorated_d -I../qcf -I../ddbi -version=dbi_sqlite -ofc:/tools/dmd/bin/senderoxc -debug -debug=SenderoXCUnittest"
end

task :build => ["test_sendero.exe"]

task :test_files => TEST_FILES

task :test => [:build, :test_files] do
  sh "test_sendero"
end

task :test_senderoxc => [:senderoxc] do
  sh "senderoxc"
end

task :default => [:test, :test_senderoxc]
