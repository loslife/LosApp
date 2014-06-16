#define ServerHost @"http://192.168.1.116:5000"

#define LOGIN_URL [ServerHost stringByAppendingString:@"/svc/losapp/login"]
#define REGISTER_URL [ServerHost stringByAppendingString:@"/svc/losapp/register"]
#define FETCH_ENTERPRISES_URL [ServerHost stringByAppendingString:@"/svc/losapp/attachEnterprises/%@"]
#define SYNC_MEMBERS_URL [ServerHost stringByAppendingString:@"/svc/losapp/syncMembers/%@?v=%@&t=%@"]