def assert_difference(executable, how_many = 1, &block)
  before = eval(executable)
  yield
  after = eval(executable)
  after.should == before + how_many
end

def assert_no_difference(executable, &block)
  before = eval(executable)
  yield
  after = eval(executable)
  after.should == before
end