#ifndef TCP_CLIENT_H
#define TCP_CLIENT_H

#include <stdio.h> //printf
#include <sys/socket.h>    //socket
#include <arpa/inet.h> //inet_addr
#include <netdb.h> //hostent
#include "Common_Structs.h"
#include <vector>

/**
    TCP Client class
*/
class tcp_client
{
private:
    int sock;
    struct sockaddr_in server;

public:
    tcp_client();
    bool conn();
    bool send_state(uint8_t OpMode,uint8_t movestate, vector<float> thetas);
    bool receive(Command* cmd);
    bool send_traj(vector<vector<float>> traj);
};

#endif
