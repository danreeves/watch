require "./spec_helper"

describe Watch do
  it "runs the command immediately with :on_start opt" do
    run "initial" do
      wait_until_stdout "> running \"echo yup\""
      wait_until_stdout "\nyup"
    end
  end
end
