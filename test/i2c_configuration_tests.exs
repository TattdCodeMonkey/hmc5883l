defmodule HMC5883L.I2cConfiguration_Tests do
  use ExUnit.Case
  alias HMC5883L.I2cConfiguration
  
  test "empty array, loads default i2c config" do
    :application.set_env(:hmc5883l, :i2c, [])

    assert I2cConfiguration.load_from_env == I2cConfiguration.new
  end
  
  test "i2c configuration is loaded from env - channel" do
    :application.set_env(:hmc5883l, :i2c, [channel: "i2c-2"])

    config = I2cConfiguration.load_from_env

    assert config.channel == "i2c-2"
  end
  
  test "i2c configuration is loaded from env - id" do
    :application.set_env(:hmc5883l, :i2c, [id: 0x01])

    config = I2cConfiguration.load_from_env

    assert config.dev_id == 0x01
  end

  test "i2c configuration is loaded from env - devid" do
    :application.set_env(:hmc5883l, :i2c, [devid: 0x05])

    config = I2cConfiguration.load_from_env

    assert config.dev_id == 0x05
  end

  test "i2c configuration is loaded from env - dev_id" do
    :application.set_env(:hmc5883l, :i2c, [dev_id: 0x7F])

    config = I2cConfiguration.load_from_env

    assert config.dev_id == 0x7F
  end

  test "i2c configuration - ignores invalid id type - atom" do
    :application.set_env(:hmc5883l, :i2c, [dev_id: :test])

    config  = I2cConfiguration.load_from_env
    default = I2cConfiguration.new

    assert config.dev_id == default.dev_id
  end

  test "i2c configuration - ignores invalid id type - string" do
    :application.set_env(:hmc5883l, :i2c, [dev_id: "not a number"])

    config  = I2cConfiguration.load_from_env
    default = I2cConfiguration.new

    assert config.dev_id == default.dev_id
  end
  
  test "i2c configuration - ignores invalid id - out of range" do
    :application.set_env(:hmc5883l, :i2c, [dev_id: 0xA1])

    config  = I2cConfiguration.load_from_env
    default = I2cConfiguration.new

    assert config.dev_id == default.dev_id
  end
end
