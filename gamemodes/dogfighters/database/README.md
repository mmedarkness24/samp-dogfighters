## Database system
### Important things to know:
- It creates database by itself. No need to care about it;
- Database name, cryptographic salt should be defined in `loginRegisterSensitiveData.pwn` file. This file doesn't exist in this repository because every server admin should generate unique combination of data. It's important for server security and for player passwords data security;
- Whole login system is based on the [Gammix's](https://github.com/Agneese-Saini) [SAMP-YourSQL repository](https://github.com/Gammix/SAMP-YourSQL) licensed under the [MIT LICENSE](https://github.com/Gammix/SAMP-YourSQL?tab=MIT-1-ov-file#readme).
 
 ### File `loginRegisterSensitiveData.pwn`
 So it's nessessary to create file `loginRegisterSensitiveData.pwn` in this folder (`gamemodes\dogfighters\database\loginRegisterSensitiveData.pwn`). Here's the example of how this file should look like:

 ```
//  This is example file with sensitive data. Do not exclude it from .gitignore
#if !defined LOGIN_REGISTER_SENSISIVE
  #define LOGIN_REGISTER_SENSITIVE

  #define LOGIN_PASS_SALT "Un1Qu3P4sS"  //  It should be unique for each server. Or your player's passwords will be in danger
  #define LOGIN_PASS_DBUSR "server.db"  //  Name of database that should be used (in scriptfiles)
  #define LOGIN_PASS_TBL_USR "players"  //  Name of table with players

  #define LOGIN_PASS_TBL_USRNAME "players/Name"
  #define LOGIN_PASS_TBL_USRPASS "players/Password"
  #define LOGIN_PASS_TBL_USRKILLS "players/Kills"
  #define LOGIN_PASS_TBL_USRDEATHS "players/Deaths"
  #define LOGIN_PASS_TBL_USRSCORE "players/Score"

  #define LOGIN_PASS_TBL_USRNAME_SML "players/name"
  #define LOGIN_PASS_TBL_USRPASS_SML "players/password"
  #define LOGIN_PASS_TBL_USRKILLS_SML "players/kills"
  #define LOGIN_PASS_TBL_USRDEATHS_SML "players/deaths"
  #define LOGIN_PASS_TBL_USRSCORE_SML "players/score"
#endif
 ```