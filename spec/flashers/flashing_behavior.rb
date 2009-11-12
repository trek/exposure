shared_examples_for "a flasher" do
  describe "responding with a method call" do
    before(:each) do
      setup_flasher(:create, @custom_flash_message)
    end
    
    it "should respond with redirect to test on success" do
      @pirate.stub(:save => true)
      post(:create)
      should set_the_flash.to(@custom_flash_message)
    end
    
    it "should respond with redirect to test on failure" do
      @pirate.stub(:save => false)
      post(:create)
      should set_the_flash.to(@custom_flash_message)
    end
  end
  
  describe "responding with a method call :on => :success" do
    before(:each) do
      setup_flasher(:create, @custom_flash_message, :success)
     end

    it "should respond with custom response on success" do
       @pirate.stub(:save => true)
       post(:create)
       should set_the_flash.to(@custom_flash_message)
     end

    it "should not respond with custom response on failure" do
       @pirate.stub(:save => false)
       post(:create)
       should_not redirect_to({:action => 'test'})
     end
  end
  
  describe "responding with a method call :on => :failure" do
      before(:each) do
        setup_flasher(:create, @custom_flash_message, :failure)
      end

      it "should not respond with custom response  on success" do
        @pirate.stub(:save => true)
        post(:create)        
        should_not redirect_to({:action => 'test'})
      end

      it "should respond with custom response on failure" do
        @pirate.stub(:save => false)
        post(:create)
        should set_the_flash.to(@custom_flash_message)
      end
  end
end