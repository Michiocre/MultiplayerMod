#include <iostream>
#include <vector>
#include <filesystem>
#include <fstream>
#include <string>
#include <chrono>
#include <asio.hpp>
#include <thread>

using asio::ip::udp;

using namespace std;
namespace fs = filesystem;

string readFile(fs::path path)
{
    ifstream f(path, ios::in | ios::binary);

    const auto fileSize = fs::file_size(path);

    string result(fileSize, '\0');
    f.read(result.data(), fileSize);

    return result;
}

int main()
{    
    auto start = std::chrono::high_resolution_clock::now();
    cout << readFile(fs::path("C:/Users/BlankM/workspace/other/MultiplayerMod/dist/test.txt")) << endl;
    auto stop = std::chrono::high_resolution_clock::now();

    string test;

    cin >> test;
    
    if (test == "Server") {
        try
        {
            asio::io_context io_context;
            udp::socket socket(io_context, udp::endpoint(udp::v4(), 6969));

            for (;;)
            {
                std::array<char, 1> recv_buf;
                udp::endpoint remote_endpoint;
                socket.receive_from(asio::buffer(recv_buf), remote_endpoint);

                

                std::string message = "Test";
                    std::error_code ignored_error;
                socket.send_to(asio::buffer(message),
                    remote_endpoint, 0, ignored_error);
            }
        }
        catch (std::exception& e)
        {
            std::cerr << e.what() << std::endl;
        }
    } else {
        try
        {
            asio::io_context io_context;

            asio::ip::address_v4 address;

            udp::resolver resolver(io_context);
            udp::endpoint receiver_endpoint =
                *resolver.resolve(udp::v4(), "127.0.0.1", "6969").begin();
            udp::socket socket(io_context);
            socket.open(udp::v4());

            std::array<char, 1> send_buf  = {{ 0 }};
            socket.send_to(asio::buffer(send_buf), receiver_endpoint);
            std::array<char, 128> recv_buf;
            udp::endpoint sender_endpoint;
            size_t len = socket.receive_from(
                asio::buffer(recv_buf), sender_endpoint);

            std::cout.write(recv_buf.data(), len);
        }
        catch (std::exception& e)
        {
            std::cerr << e.what() << std::endl;
        }

        return 0;
    }

    return 0;
}