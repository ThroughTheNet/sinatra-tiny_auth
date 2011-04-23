# require 'spec_helper'
# 
# describe 'Sinatra::TinyAuth::Tasks' do
#   before(:all) do
#     @task = Sinatra::TinyAuth::Tasks.new
#   end
#   
#   context 'with two similar passwords' do
#     before(:all) do
#       $stdin.stub(:gets) {'password'}
#     end
#     
#     it 'calls gets twice on stdin' do
#       $stdin.should_receive(:gets).twice
#       @task.invoke(:set)
#     end
#   
#     it 'finishes successfully' do
#       
#     end
#     
#   end
# end
