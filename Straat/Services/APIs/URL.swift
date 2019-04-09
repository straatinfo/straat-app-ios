//
//  URL.swift
//  Straat
//
//  Created by Global Array on 06/02/2019.
//

import Foundation

// let root = "https://straatinfo-backend-v2.herokuapp.com/v1/api/"
let root = "https://straatinfo-backend-v2-prod.herokuapp.com/v1/api/" // production
// let root_v2 = "https://straatinfo-backend-v2.herokuapp.com/v2/api/"
let root_v2 = "https://straatinfo-backend-v2-prod.herokuapp.com/v2/api/" // production

let auth = root + "auth/login"
let request_host = root + "registration/validation/host"
let request_team = root + "team"
let signup_v3 = root + "registration/signupV3"
let get_categories_by_host = root + "category/app/mainCategory/withGeneral/hostId/" // + hostId + queryStrings language=nl

let get_default_categories = root + "category/app/mainCategory/general"

// postcode
let POST_CODE_API = "https://api.postcodeapi.nu/v2/addresses"
let POST_CODE_API_V2 = "https://straatinfo-backend-v2-prod.herokuapp.com/api/v1/utility/postcode"

let report_map = root + "report/?user_id=5c63e92035086200156f93e0&fbclid=IwAR1AF8aK8tmFpI5RfNYuNfjXoXNoCFdV_U-OcB649R1Y0Ijh-ZqMzCXen9w"
let send_report = root + "report/V2"
let report = root + "report"
let report_near = report + "/near" // /v1/api/report/near/4.315667/52.077646/100?language=nl&_reporter=5c63452335086200156f93d4
let report_status = report + "/status" // /v1/api/report/status/5c6f1109132fa3001565d743?language=nl [ 'NEW', 'INPROGRESS', 'DONE', 'EXPIRED']
let report_public = report + "/public" // GET /v1/api/report/public?_reporter=5c63e92035086200156f93e0&_reportType=5a7888bb04866e4742f74955&language=nl


// uploading
let upload_photo = root + "upload/public"

// user
let reporter_feedback = root + "feedback"
let user_setting_radius = root + "user/map-radius-setting"
let user = root + "user"
let user_profile = user + "/profile"
let user_pic = user + "/pic"
let user_password = user + "/password"

// team

let team_list = root + "team/list/"
let create_team = root + ""
let update_team = root + "team/"
let team_request = root + "teamInvite/teamRequests/"
let team_info_members = root + "team/info/"
let team_accept_user = root + "teamInvite/acceptRequest/"


// chat
let chat_list = root_v2 + "message"
let send_message = root_v2 + "message/?_conversation="
let create_conversation = root_v2 + "conversation?type=PRIVATE"
let team_chat_list = root_v2 + "conversation?type=PRIVATE,GROUP,TEAM"
/*
 REPORT TYPES
 {
 
 /** @description  code: 'A', name: 'Public Space' */
 PUBLIC_SPACE: {
 _id: '5a7888bb04866e4742f74955',
 code: 'A',
 name: 'Public Space'
 },
 
 /** @description code: 'B', name: 'Safety' */
 SAFETY: {
 _id: '5a7888bb04866e4742f74956',
 code: 'B',
 name: 'Safety'
 },
 
 /** @description code: 'C', name: 'Communication' */
 COMMUNICATION: {
 _id: '5a7888bb04866e4742f74957',
 code: 'C',
 name: 'Communication'
 }
 }
 */
