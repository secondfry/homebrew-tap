class NlohmannJsonAT391 < Formula
  desc "JSON for modern C++"
  homepage "https://github.com/nlohmann/json"
  url "https://github.com/nlohmann/json/archive/v3.9.1.tar.gz"
  sha256 "4cf0df69731494668bdd6460ed8cb269b68de9c19ad8c27abc24cd72605b2d5b"
  license "MIT"
  revision 1
  head "https://github.com/nlohmann/json.git", branch: "develop"

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-DJSON_BuildTests=OFF", "-DJSON_MultipleHeaders=ON", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <iostream>
      #include <nlohmann/json.hpp>

      using nlohmann::json;

      int main() {
        json j = {
          {"pi", 3.141},
          {"name", "Niels"},
          {"list", {1, 0, 2}},
          {"object", {
            {"happy", true},
            {"nothing", nullptr}
          }}
        };
        std::cout << j << std::endl;
      }
    EOS

    system ENV.cxx, "test.cc", "-I#{include}", "-std=c++11", "-o", "test"
    std_output = <<~EOS
      {"list":[1,0,2],"name":"Niels","object":{"happy":true,"nothing":null},"pi":3.141}
    EOS
    assert_match std_output, shell_output("./test")
  end
end
