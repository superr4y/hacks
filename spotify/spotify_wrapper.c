#include <unistd.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv, char **env)
{
    
    if(getuid() != 0){
        fprintf(stderr, "Pleas run as Root\n");
        exit(1);
    }

    if(setgid(1003) == -1){
        perror("Could not set gid\n");    
        exit(1);
    }    
    if(setuid(1000) == -1){
        perror("Could not set uid\n");
        exit(1);
    }

    char *spotify = "/usr/bin/spotify";
    execle(spotify, spotify, NULL, env);
    

return 0;
}
