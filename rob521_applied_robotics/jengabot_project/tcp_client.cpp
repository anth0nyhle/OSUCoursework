#include "tcp_client.h"

using namespace std;

tcp_client::tcp_client()
{
 sock = -1;
}

/**
    Connect to a host on a certain port number
*/
bool tcp_client::conn()
{
    //create socket if it is not already created
    if(sock == -1)
    {
        //Create socket
        sock = socket(AF_INET , SOCK_STREAM , 0);
        if (sock == -1)
        {
            printf("Could not create socket\n");
        }
    }
    else    {   /* OK , nothing */  }

    server.sin_addr.s_addr = inet_addr( "192.168.1.115" );
    server.sin_family = AF_INET;
    server.sin_port = htons( 5006 );

    //Connect to remote server
    if (connect(sock , (struct sockaddr *)&server , sizeof(server)) < 0)
    {
        printf("connect failed. Error\n");
        return false;
    }
    return true;
}

/**
    Send data to the connected host
*/
bool tcp_client::send_state(uint8_t OpMode, uint8_t MoveState, vector<float> thetas)
{
    char msg_buff[3 + 4*5];
    msg_buff[0] = 0;
    msg_buff[1] = OpMode;
    msg_buff[2] = MoveState;
    for (int i = 0; i < thetas.size(); i++)
    {
       int t_mrad = int(1000*thetas[i]);
       for (int j = 0; j < 4; j++)
          msg_buff[3 + j + i*4] = (t_mrad >> (j*8));
    }

    //Send some data
    if( send(sock , msg_buff , 3+4*5 , 0) < 0)
    {
        printf("Send failed : ");
        return false;
    }
    return true;
}

bool tcp_client::send_traj(vector<vector<float>> theta_traj)
{
    char msg_buff[1 + 4*5*32];
    msg_buff[0] = 1;
    for (int i = 0; i < 32; i++)
    {
       for (int j = 0; j < 5; j++)
       {
          int t_mrad = int(1000*theta_traj[i][j]);
         // printf("%f, ");
          for (int k = 0; k < 4; k++)
          {
             msg_buff[1 + j*4 + i*20 + k] = (t_mrad >> (k*8));
          }
       }
       //printf("\n");
    }

    //Send some data
    if( send(sock , msg_buff , 1+4*5*32 , 0) < 0)
    {
        printf("Send failed : ");
        return false;
    }
    return true;
}

/**
    Receive data from the connected host
*/
bool tcp_client::receive(Command* cmd)
{
    int size = 18;
    char buffer[size];

    //Receive a reply from the server
    if( recv(sock , buffer , sizeof(buffer) , 0) < 0)
    {
        printf("recv failed");
        return false;
    }
    //for (int i = 0; i < 12; i++)
    //   printf("%d, ", buffer[i]);
    //printf("\n");
    cmd->cmd_type = buffer[0];
    cmd->proceed = buffer[1];
    int command[4];
    for (int i = 0; i < 4; i++)
    {
       command[i] = buffer[i*4 + 5] << 24 | buffer[i*4 + 4] << 16 | buffer[i*4+3] << 8 | buffer[i*4+2];
    }

    cmd->point.x_m = float(command[0])/1000;
    cmd->point.y_m = float(command[1])/1000;
    cmd->point.z_m = float(command[2])/1000;
    cmd->yaw = float(command[3])/1000;
    printf("Received Command: %d, %d | %f, %f, %f, %f\n",cmd->cmd_type,cmd->proceed,cmd->point.x_m,cmd->point.y_m,cmd->point.z_m,cmd->yaw);
    return true;
}
