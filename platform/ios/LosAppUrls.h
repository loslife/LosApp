#define ServerHost @"http://192.168.1.108:5000"

#define LOGIN_URL [ServerHost stringByAppendingString:@"/svc/losapp/login"]
#define REGISTER_URL [ServerHost stringByAppendingString:@"/svc/losapp/register"]
#define FETCH_ENTERPRISES_URL [ServerHost stringByAppendingString:@"/svc/losapp/attachEnterprises/%@"]
#define SYNC_MEMBERS_URL [ServerHost stringByAppendingString:@"/svc/losapp/syncMembers/%@?v=%@&t=%@"]
#define GET_CODE_URL [ServerHost stringByAppendingString:@"/svc/getCode/%@?u=%@"]
#define CHECK_CODE_URL [ServerHost stringByAppendingString:@"/svc/checkCode/%@?u=%@&c=%@"]
#define APPEND_ENERPRISE_URL [ServerHost stringByAppendingString:@"/svc/losapp/appendEnterprise"]
#define MODIFY_PASSWORD_URL [ServerHost stringByAppendingString:@"/svc/losapp/modifyPassword"]
#define RESET_PASSWORD_URL [ServerHost stringByAppendingString:@"/svc/losapp/resetPassword"]
#define FETCH_REPORT_URL [ServerHost stringByAppendingString:@"/svc/report/probe/query/%@?year=%@&month=%@&day=%@&type=%@&report=%@"]